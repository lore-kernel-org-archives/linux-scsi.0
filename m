From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: Mainly add version info to run testing process.
Date: Fri, 29 Feb 2008 11:04:28 -0600
Message-ID: <1204304668.4003.24.camel@localhost.localdomain>
References: <20080227125025.GA7897@ubuntu.domain>
	 <1204129357.3470.14.camel@localhost.localdomain>
	 <6b2481670802271916y62aa0588w81de83c08c9f128c@mail.gmail.com>
	 <1204247725.4003.4.camel@localhost.localdomain>
	 <20080229133444.GA7908@ubuntu.domain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57152 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbYB2REg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 12:04:36 -0500
In-Reply-To: <20080229133444.GA7908@ubuntu.domain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

On Fri, 2008-02-29 at 21:34 +0800, Ke Wei wrote:
> On Thu, Feb 28, 2008 at 08:15:25PM -0500, James Bottomley wrote:
> > On Thu, 2008-02-28 at 11:16 +0800, Ke Wei wrote:
> > > On Thu, Feb 28, 2008 at 12:22 AM, James Bottomley
> > > <James.Bottomley@hansenpartnership.com> wrote:
> > > > On Wed, 2008-02-27 at 20:50 +0800, Ke Wei wrote:
> > > > > 1. Owing to device testing, we need the kernel can show mvsas current
> > > > > version in the /proc system.
> > > >
> > > > I'm afraid proc is really deprecated now.  We have /sys for showing
> > > > necessary information.  For an example of how to use /sys, aacraid does
> > > > it the right way (drivers/scsi/aacraid/linit.c).  They use this for
> > > > exposing a lot of detail about the actual device and its firmware.  The
> > > > format of sysfs is one entry per file, rather than descriptive text.
> > > >
> > > > However, for both the parameters you're trying to export, you can get
> > > > them an alternative way.  The driver version is available from modinfo,
> > > > which is usually what your support is looking for:
> > > >
> > > > jejb@hobholes> modinfo -F version mvsas
> > > > 0.5
> > > >
> > > > And the sas_address is available from the phys.  Because it's possible
> > > > for a HBA to have a different address per phy, it has to be stored this
> > > > way:
> > > >
> > > > jejb@hobholes> ls /sys/class/sas_host/host0/device/*/sas_phy\:*/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:0/sas_phy:phy-0:0/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:1/sas_phy:phy-0:1/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:2/sas_phy:phy-0:2/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:3/sas_phy:phy-0:3/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:4/sas_phy:phy-0:4/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:5/sas_phy:phy-0:5/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:6/sas_phy:phy-0:6/sas_address
> > > > /sys/class/sas_host/host0/device/phy-0:7/sas_phy:phy-0:7/sas_address
> > > >
> > > > (showing that the sas_address is stored under the sas_phy class in
> > > > sysfs).  The values for this one (aic94xx) are all the same:
> > > >
> > > > jejb@hobholes> cat /sys/class/sas_host/host0/device/*/sas_phy\:*/sas_address
> > > > 0x50000d100001cae0
> > > > 0x50000d100001cae0
> > > > 0x50000d100001cae0
> > > > 0x50000d100001cae0
> > > > 0x50000d100001cae0
> > > > 0x50000d100001cae0
> > > > 0x50000d100001cae0
> > > > 0x50000d100001cae0
> > > >
> > > Ok, I will tell our testing team how to show version in this way.
> > 
> > Thanks!
> > 
> > > >
> > > > > 2. Set the correct SAS address to per port.
> > > >
> > > > This looks interesting:
> > > >
> > > > >         for (i = 0; i < mvi->chip->n_phy; i++) {
> > > > > -               /* FIXME: is this the correct dword order? */
> > > > > -               u32 lo = *((u32 *)&mvi->sas_addr[0]);
> > > > > -               u32 hi = *((u32 *)&mvi->sas_addr[4]);
> > > > > +               u32 lo = swab32p((u32 *)&mvi->sas_addr[4]);
> > > > > +               u32 hi = swab32p((u32 *)&mvi->sas_addr[0]);
> > > > >
> > > > >                 mvs_detect_porttype(mvi, i);
> > > >
> > > > I'm assuming the swab32p is because the mvi->sas_addr array is in wire
> > > > (big endian) format, and you need to write it out to the config
> > > > registers as two u32 upper and lower words via mvs_write_port_cfg.  As
> > > > long as that register set is always in pci order (little endian), I
> > > > think this will work, but has it been tested on a big endian system,
> > > > like PPC?
> > > 
> > > Yes,  the mvi->sas_addr array is in wire big endian format. And it
> > > will be written to two
> > > little-endian 32-bit registers after converting to little endian. So I
> > > think this is independent
> > > of system architecture.
> > 
> > OK, so in that case, this manner of doing the transformations will fail
> > on a Big Endian machine.  I think instead of the swab32p, which will
> > swap to little endian all the time, you want be32_to_cpu() which will
> > swap on a little endian CPU but not on a big endian one.
> > 
> > The register outputs eventually go via writel which likewise includes a
> > cpu_to_<architecture endianness> before it actually does the write (So
> > on a big endian machine, writel takes big endian in and swaps to output
> > in PCI bus format, which is little endian).
> > 
> > James
> You are right. I will patch for this issue.
> BTW, mvsas driver may perform big endian transfers in a big-endian system in the future.
> Thanks.
> 
> Signed-off-by: Ke Wei <kewei@marvell.com>
> 
> diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
> old mode 100644
> new mode 100755
> index 3e56178..1f77b6e
> --- a/drivers/scsi/mvsas.c
> +++ b/drivers/scsi/mvsas.c
> @@ -2747,8 +2747,8 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
>  	msleep(100);
>  	/* init and reset phys */
>  	for (i = 0; i < mvi->chip->n_phy; i++) {
> -		u32 lo = swab32p((u32 *)&mvi->sas_addr[4]);
> -		u32 hi = swab32p((u32 *)&mvi->sas_addr[0]);
> +		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);
> +		u32 hi = be32_to_cpu(*(u32 *)&mvi->sas_addr[0]);
>  
>  		mvs_detect_porttype(mvi, i);

Thanks, but for future reference, what I need is a patch based on the
current git doing what's necessary, like that attached below.  i.e.
without the piece you can get elsewhere and with everything else updated
correctly

James

---

From: Ke Wei <kewei.mv@gmail.com>
Date: Wed, 27 Feb 2008 20:50:25 +0800
Subject: [SCSI] mvsas: fix phy sas address

The phy sas address is showing wrongly (wrong endianness).  Fix up the
endian transforms to make this correct.

Signed-off-by: Ke Wei <kewei@marvell.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/mvsas.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)
 mode change 100644 => 100755 drivers/scsi/mvsas.c

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
old mode 100644
new mode 100755
index d4a6ac3..5ec0665
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -40,7 +40,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"mvsas"
-#define DRV_VERSION	"0.5"
+#define DRV_VERSION	"0.5.1"
 #define _MV_DUMP 0
 #define MVS_DISABLE_NVRAM
 #define MVS_DISABLE_MSI
@@ -1005,7 +1005,7 @@ err_out:
 	return rc;
 #else
 	/* FIXME , For SAS target mode */
-	memcpy(buf, "\x00\x00\xab\x11\x30\x04\x05\x50", 8);
+	memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
 	return 0;
 #endif
 }
@@ -1330,7 +1330,7 @@ static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 
 		mvs_hba_cq_dump(mvi);
 
-		if (unlikely(rx_desc & RXQ_DONE))
+		if (likely(rx_desc & RXQ_DONE))
 			mvs_slot_complete(mvi, rx_desc);
 		if (rx_desc & RXQ_ATTN) {
 			attn = true;
@@ -2720,9 +2720,8 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 	msleep(100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
-		/* FIXME: is this the correct dword order? */
-		u32 lo = *((u32 *)&mvi->sas_addr[0]);
-		u32 hi = *((u32 *)&mvi->sas_addr[4]);
+		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);
+		u32 hi = be32_to_cpu(*(u32 *)&mvi->sas_addr[0]);
 
 		mvs_detect_porttype(mvi, i);
 
-- 
1.5.4.1



