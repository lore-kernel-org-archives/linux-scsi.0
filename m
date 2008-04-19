From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 10:54:44 -0500
Message-ID: <1208620484.3280.23.camel@localhost.localdomain>
References: <1208540517.3063.18.camel@localhost.localdomain>
	 <20080419151934.GA17089@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756797AbYDSPzH@vger.kernel.org>
In-Reply-To: <20080419151934.GA17089@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org


On Sat, 2008-04-19 at 17:19 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> >       libsas: Provide a transport-level facility to request SAS addrs
> 
> this (or a nearby) commit caused a build regression:
> 
>  drivers/built-in.o: In function `sas_request_addr':
>  : undefined reference to `request_firmware'
>  drivers/built-in.o: In function `sas_request_addr':
>  : undefined reference to `release_firmware'
> 
> config can be found at:
> 
>    http://redhat.com/~mingo/misc/config-Sat_Apr_19_16_58_35_CEST_2008.bad
> 
> ... brought to you by x86.git's randconfig build and boot service ;-)

This one's fun.  The root cause is 

CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_FW_LOADER=m

The problem is that libsas doesn't depend on the FW loader and doesn't
want to.  It just wants to use it if it's available.  The definitions in
include/linux/firmware.h have stubs to facilitate this.

However, CONFIG_FW_LOADER=m defeats the stubs.

This is a bit nasty to fix; however, I think this patch does.  I've also
put a large comment in to explain what's going on.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 4d10c73..01e39a1 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -13,7 +13,16 @@ struct firmware {
 
 struct device;
 
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+
+/*
+ * This is very subtle.  If the Firmware loader is built in then the
+ * request/release calls can be accessed by anything.  If it's built
+ * as a module then only other modules can access it.  The check on
+ * MODULE specifically fixes the case where the firmware loader is
+ * built as a module, but a built in kernel component tries to use the
+ * request/release functions.
+ */
+#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
