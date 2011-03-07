From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
	top level
Date: Mon, 07 Mar 2011 15:15:47 -0800
Message-ID: <1299539747.19683.333.camel@haakon2.linux-iscsi.org>
References: <1299036841-23677-1-git-send-email-nab@linux-iscsi.org>
	 <1299036841-23677-13-git-send-email-nab@linux-iscsi.org>
	 <20110301223251.11c95eed.rdunlap@xenotime.net>
	 <1299101531.5401.313.camel@haakon2.linux-iscsi.org>
	 <20110303141928.GA25256@infradead.org>
	 <1299185905.5401.405.camel@haakon2.linux-iscsi.org>
	 <1299258022.7041.64.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1299258022.7041.64.camel@mulgrave.site>
Sender: linux-crypto-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-03-04 at 11:00 -0600, James Bottomley wrote:
> On Thu, 2011-03-03 at 12:58 -0800, Nicholas A. Bellinger wrote:
> > On Thu, 2011-03-03 at 09:19 -0500, Christoph Hellwig wrote:
> > > On Wed, Mar 02, 2011 at 01:32:11PM -0800, Nicholas A. Bellinger wrote:
> > > > The kernel code itself that is specific to using the SSE v4.2
> > > > instruction for CRC32C offload are using #ifdef CONFIG_X86 stubs in
> > > > iscsi_target_login.c:iscsi_login_setup_crypto(), and !CONFIG_X86 will
> > > > default to using the unoptimized 1x8 slicing soft CRC32C code.  This
> > > > particular piece of logic has been tested on powerpc and arm and is
> > > > funcitoning as expected from the kernel level using the arch independent
> > > > soft code.
> > > 
> > > I don't think you need that code at all.  The crypto code is structured
> > > to prefer the optimized implementation if it is present.  Just stripping
> > > the x86-specific code out and always requesting the plain crc32c
> > > algorithm should give you the optimized one if it is present on your
> > > system.
> > > 
> > > Please give it a try.
> > > 
> > 
> > This is what I originally thought as well, but this ended up not being
> > the case when the logic was originally coded up.   I just tried again
> > with .38-rc7 on a 5500 series machine and simply stubbing out the
> > CONFIG_X86 part from iscsi_login_setup_crypto() and calling:
> > 
> >    crypto_alloc_hash("crc32c", 0, CRYPTO_ALG_ASYNC)
> > 
> > does not automatically load and use crc32c_intel.ko when only requesting
> > plain crc32c.
> 
> It sounds like there might be a bug in the crypto layer, so the Linux
> way is to make it work as intended.
> 
> It's absolutely not acceptable just to pull other layer workarounds into
> drivers.
> 
> > The reason for the extra crypto_alloc_hash("crc32c-intel", ...) call in
> > iscsi_login_setup_crypto() is to load crc32c_intel.ko on-demand for
> > cpu_has_xmm4_2 capable machines.
> > 
> > I should mention this is with the following .config:
> > 
> > CONFIG_CRYPTO_CRC32C=y
> > CONFIG_CRYPTO_CRC32C_INTEL=m
> > 
> > This would seem to indicate that CRC32C_INTEL needs to be compiled in
> > (or at least manually loaded) for libcypto to use the optimized
> > instructions when the plain crc32c is called, correct..?
> 
> That sounds right.  There's probably not an autoload for this on
> recognising sse instructions.
> 

I have been thinking about this some more, and modifying libcrypto to be
aware of optimized offload methods for hardware specific modules that it
should load does sound useful, but it seem like overkill to me for only
this particular case.

What about the following to simply call request_module("crc32c_intel")
at module_init() time and top the extra iscsi_login_setup_crypto()
code..?

Thanks,

--nab

[PATCH] iscsi-target: Call request_module("crc32c_intel") during module_init

This patch adds a call during module_init() -> iscsi_target_register_configfs()
to request the loading of crc32c_intel.ko to allow libcrypto to properly use
the optimized offload where available.

It also removes the extra crypto_alloc_hash("crc32c-intel", ...) calls
from iscsi_login_setup_crypto() and removes the unnecessary TPG attribute
crc32c_x86_offload for control this offload from configfs.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target_configfs.c |   18 +++++++----
 drivers/target/lio-target/iscsi_target_core.h     |    4 --
 drivers/target/lio-target/iscsi_target_login.c    |   34 ++-------------------
 drivers/target/lio-target/iscsi_target_tpg.c      |   19 -----------
 drivers/target/lio-target/iscsi_target_tpg.h      |    1 -
 5 files changed, 15 insertions(+), 61 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target_configfs.c b/drivers/target/lio-target/iscsi_target_configfs.c
index 76ee4fc..7ba169a 100644
--- a/drivers/target/lio-target/iscsi_target_configfs.c
+++ b/drivers/target/lio-target/iscsi_target_configfs.c
@@ -927,11 +927,6 @@ TPG_ATTR(demo_mode_write_protect, S_IRUGO | S_IWUSR);
  */
 DEF_TPG_ATTRIB(prod_mode_write_protect);
 TPG_ATTR(prod_mode_write_protect, S_IRUGO | S_IWUSR);
-/*
- * Define iscsi_tpg_attrib_s_crc32c_x86_offload
- */
-DEF_TPG_ATTRIB(crc32c_x86_offload);
-TPG_ATTR(crc32c_x86_offload, S_IRUGO | S_IWUSR);

 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
        &iscsi_tpg_attrib_authentication.attr,
@@ -942,7 +937,6 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
        &iscsi_tpg_attrib_cache_dynamic_acls.attr,
        &iscsi_tpg_attrib_demo_mode_write_protect.attr,
        &iscsi_tpg_attrib_prod_mode_write_protect.attr,
-       &iscsi_tpg_attrib_crc32c_x86_offload.attr,
        NULL,
 };

@@ -1525,6 +1519,18 @@ int iscsi_target_register_configfs(void)
        lio_target_fabric_configfs = fabric;
        printk(KERN_INFO "LIO_TARGET[0] - Set fabric ->"
                        " lio_target_fabric_configfs\n");
+#ifdef CONFIG_X86
+       /*
+        * For cpu_has_xmm4_2 go ahead and load crc32c_intel.ko in order for
+        * iscsi_login_setup_crypto() -> crypto_alloc_hash("crc32c", ...) to
+        * use the offload when available from libcrypto..
+        */
+       if (cpu_has_xmm4_2) {
+               int rc = request_module("crc32c_intel");
+               if (rc < 0)
+                       printk(KERN_ERR "Unable to load crc32c_intel.ko\n");
+       }
+#endif
        return 0;
 }

diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index b8e87a3..93632f3 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -83,8 +83,6 @@
 #define TA_DEMO_MODE_WRITE_PROTECT     1
 /* Disabled by default in production mode w/ explict ACLs */
 #define TA_PROD_MODE_WRITE_PROTECT     0
-/* Enabled by default with x86 supporting SSE v4.2 */
-#define TA_CRC32C_X86_OFFLOAD          1
 #define TA_CACHE_CORE_NPS              0

 /* struct iscsi_data_count->type */
@@ -781,8 +779,6 @@ struct iscsi_tpg_attrib {
        u32                     default_cmdsn_depth;
        u32                     demo_mode_write_protect;
        u32                     prod_mode_write_protect;
-       /* Used to signal libcrypto crc32-intel offload instruction usage */
-       u32                     crc32c_x86_offload;
        u32                     cache_core_nps;
        struct iscsi_portal_group *tpg;
 }  ____cacheline_aligned;
diff --git a/drivers/target/lio-target/iscsi_target_login.c b/drivers/target/lio-target/iscsi_target_login.c
index 35d4765..0f098d3 100644
--- a/drivers/target/lio-target/iscsi_target_login.c
+++ b/drivers/target/lio-target/iscsi_target_login.c
@@ -95,38 +95,10 @@ static int iscsi_login_init_conn(struct iscsi_conn *conn)
 int iscsi_login_setup_crypto(struct iscsi_conn *conn)
 {
        struct iscsi_portal_group *tpg = conn->tpg;
-#ifdef CONFIG_X86
        /*
-        * Check for the Nehalem optimized crc32c-intel instructions
-        * This is only currently available while running on bare-metal,
-        * and is not yet available with QEMU-KVM guests.
-        */
-       if (cpu_has_xmm4_2 && ISCSI_TPG_ATTRIB(tpg)->crc32c_x86_offload) {
-               conn->conn_rx_hash.flags = 0;
-               conn->conn_rx_hash.tfm = crypto_alloc_hash("crc32c-intel", 0,
-                                               CRYPTO_ALG_ASYNC);
-               if (IS_ERR(conn->conn_rx_hash.tfm)) {
-                       printk(KERN_ERR "crypto_alloc_hash() failed for conn_rx_tfm\n");
-                       goto check_crc32c;
-               }
-
-               conn->conn_tx_hash.flags = 0;
-               conn->conn_tx_hash.tfm = crypto_alloc_hash("crc32c-intel", 0,
-                                               CRYPTO_ALG_ASYNC);
-               if (IS_ERR(conn->conn_tx_hash.tfm)) {   
-                       printk(KERN_ERR "crypto_alloc_hash() failed for conn_tx_tfm\n");
-                       crypto_free_hash(conn->conn_rx_hash.tfm);
-                       goto check_crc32c;
-               }
-
-               printk(KERN_INFO "LIO-Target[0]: Using Nehalem crc32c-intel"
-                                       " offload instructions\n");
-               return 0;
-       }
-check_crc32c:
-#endif /* CONFIG_X86 */
-       /*
-        * Setup slicing by 1x CRC32C algorithm for RX and TX libcrypto contexts
+        * Setup slicing by CRC32C algorithm for RX and TX libcrypto contexts
+        * which will default to crc32c_intel.ko for cpu_has_xmm4_2, or fallback
+        * to software 1x8 byte slicing from crc32c.ko
         */
        conn->conn_rx_hash.flags = 0;
        conn->conn_rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
diff --git a/drivers/target/lio-target/iscsi_target_tpg.c b/drivers/target/lio-target/iscsi_target_tpg.c
index e851982..212d8c1 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.c
+++ b/drivers/target/lio-target/iscsi_target_tpg.c
@@ -465,7 +465,6 @@ static void iscsi_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
        a->cache_dynamic_acls = TA_CACHE_DYNAMIC_ACLS;
        a->demo_mode_write_protect = TA_DEMO_MODE_WRITE_PROTECT;
        a->prod_mode_write_protect = TA_PROD_MODE_WRITE_PROTECT;
-       a->crc32c_x86_offload = TA_CRC32C_X86_OFFLOAD;
        a->cache_core_nps = TA_CACHE_CORE_NPS;
 }

@@ -1103,24 +1102,6 @@ int iscsi_ta_prod_mode_write_protect(
        return 0;
 }

-int iscsi_ta_crc32c_x86_offload(
-       struct iscsi_portal_group *tpg,
-       u32 flag)
-{
-       struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
-
-       if ((flag != 0) && (flag != 1)) {
-               printk(KERN_ERR "Illegal value %d\n", flag);
-               return -EINVAL;
-       }
-
-       a->crc32c_x86_offload = flag;
-       printk(KERN_INFO "iSCSI_TPG[%hu] - CRC32C x86 Offload: %s\n",
-               tpg->tpgt, (a->crc32c_x86_offload) ? "ON" : "OFF");
-
-       return 0;
-}
-
 void iscsi_disable_tpgs(struct iscsi_tiqn *tiqn)
 {
        struct iscsi_portal_group *tpg;
diff --git a/drivers/target/lio-target/iscsi_target_tpg.h b/drivers/target/lio-target/iscsi_target_tpg.h
index bcdfacb..2553707 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.h
+++ b/drivers/target/lio-target/iscsi_target_tpg.h
@@ -53,7 +53,6 @@ extern int iscsi_ta_default_cmdsn_depth(struct iscsi_portal_group *, u32);
 extern int iscsi_ta_cache_dynamic_acls(struct iscsi_portal_group *, u32);
 extern int iscsi_ta_demo_mode_write_protect(struct iscsi_portal_group *, u32);
 extern int iscsi_ta_prod_mode_write_protect(struct iscsi_portal_group *, u32);
-extern int iscsi_ta_crc32c_x86_offload(struct iscsi_portal_group *, u32);
 extern void iscsi_disable_tpgs(struct iscsi_tiqn *);
 extern void iscsi_disable_all_tpgs(void);
 extern void iscsi_remove_tpgs(struct iscsi_tiqn *);
-- 
1.6.2.2
