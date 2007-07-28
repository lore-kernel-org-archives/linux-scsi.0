From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Sat, 28 Jul 2007 13:40:21 -0400
Message-ID: <1185644421.11492.32.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D708B3D56@NAMAIL4.ad.lsil.com>
	 <1185575403.3434.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34748 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754487AbXG1RkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jul 2007 13:40:23 -0400
In-Reply-To: <1185575403.3434.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org

On Fri, 2007-07-27 at 18:30 -0400, James Bottomley wrote:
> On Fri, 2007-07-27 at 16:16 -0600, Moore, Eric wrote:
> > On Friday, July 27, 2007 10:21 AM, wrote: 
> > > 
> > > The way your module parameter works is slightly counter intuitive.  On
> > > all our other drivers, you can write a value into 
> > > 
> > > /sys/module/<module>/parameters/<debug parameter>
> > > 
> > > And have it acted on immediately.  In yours, it seems only to work
> > > before the host is probed (because after that, the value in the ioc
> > > structure is what's used).
> > 
> > not true,  the debug parameter can be configured prior to the host being
> > probed.
> 
> That's what I just said ... if you mean can be configured *after* the
> host being probed, then I think the parameter needs a
> module_param_call() so you can intercept the set and update the ioc
> structures accordingly.

I tell you what, let me just show you the actual patch.  This allows you
to write to the /sys/module/mptbase/parameters/mpt_debug_level and have
it take effect in every ioc.

James

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e866dac..414c109 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -88,7 +88,9 @@ module_param(mpt_channel_mapping, int, 0);
 MODULE_PARM_DESC(mpt_channel_mapping, " Mapping id's to channels (default=0)");
 
 static int mpt_debug_level;
-module_param(mpt_debug_level, int, 0);
+static int mpt_set_debug_level(const char *val, struct kernel_param *kp);
+module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
+		  &mpt_debug_level, 0600);
 MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h - (default=0)");
 
 #ifdef MFCNT
@@ -220,6 +222,19 @@ pci_enable_io_access(struct pci_dev *pdev)
 	pci_write_config_word(pdev, PCI_COMMAND, command_reg);
 }
 
+static int mpt_set_debug_level(const char *val, struct kernel_param *kp)
+{
+	int ret = param_set_int(val, kp);
+	MPT_ADAPTER *ioc;
+
+	if (ret)
+		return ret;
+
+	list_for_each_entry(ioc, &ioc_list, list)
+		ioc->debug_level = mpt_debug_level;
+	return 0;
+}
+
 /*
  *  Process turbo (context) reply...
  */


