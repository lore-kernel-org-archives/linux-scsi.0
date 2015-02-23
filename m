From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/8] target: Add sanity checks for DPO/FUA bit usage
Date: Sun, 22 Feb 2015 22:13:09 -0800
Message-ID: <1424671989.18478.53.camel@haakon3.risingtidesystems.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>
	 <1423884463-16797-6-git-send-email-nab@daterainc.com>
	 <20150222164114.GA1484@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48552 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbBWGNY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 01:13:24 -0500
In-Reply-To: <20150222164114.GA1484@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <jbottomley@parallels.com>

On Sun, 2015-02-22 at 17:41 +0100, Christoph Hellwig wrote:
> On Sat, Feb 14, 2015 at 03:27:40AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a sbc_check_dpofua() function that performs sanity
> > checks for DPO/FUA command bits.
> > 
> > It introduces checks to fail when either bit is set, but the backend
> > device is not advertising support for them.
> > 
> > It also moves the existing cmd->se_cmd_flags |= SCF_FUA assignement
> > into the new helper function.
> 
> This causes I/O errors with ext4 on tcm_loop on what seems to be the first
> journal commit:
> 
> [   41.818126] EXT4-fs (sdc): mounted filesystem with ordered data mode. Opts: (null)
> [   48.919107] Got CDB: 0x2a with FUA bit set, but device does not advertise support for FUA write
> [   48.920245] sd 3:0:0:0: [sdc] tag#113 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [   48.921219] sd 3:0:0:0: [sdc] tag#113 Sense Key : Illegal Request [current] 
> [   48.921980] sd 3:0:0:0: [sdc] tag#113 Add. Sense: Invalid field in cdb
> [   48.922696] sd 3:0:0:0: [sdc] tag#113 CDB: Write(10) 2a 08 00 c4 22 c8 00 00 08 00
> [   48.923619] blk_update_request: critical target error, dev sdc, sector 12853960
> [   48.924501] blk_update_request: critical target error, dev sdc, sector 12853960
> [   48.925598] Aborting journal on device sdc-8.
> 

Thanks for the heads up.

I'm able to reproduce this one, but only when emulate_write_cache has
been explicitly disabled via configfs before an FS unmount.  It happens
when WCE is disabled underneath the existing host side LUN registration,
yes..?

If that's the only case, then one option is to just keep the new
sbc_check_dpofua() check around and -EINVAL attribute modification of
emulate_[write_cache,fua_write] if any active fabric exports exist.

A quick patch to that end:

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 58f49ff..37449bd 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -767,6 +767,16 @@ int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
                pr_err("Illegal value %d\n", flag);
                return -EINVAL;
        }
+       if (flag &&
+           dev->transport->get_write_cache) {
+               pr_err("emulate_fua_write not supported for this device\n");
+               return -EINVAL;
+       }
+       if (dev->export_count) {
+               pr_err("emulate_fua_write cannot be changed with active"
+                      " exports: %d\n", dev->export_count);
+               return -EINVAL;
+       }
        dev->dev_attrib.emulate_fua_write = flag;
        pr_debug("dev[%p]: SE Device Forced Unit Access WRITEs: %d\n",
                        dev, dev->dev_attrib.emulate_fua_write);
@@ -801,7 +811,11 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
                pr_err("emulate_write_cache not supported for this device\n");
                return -EINVAL;
        }
-
+       if (dev->export_count) {
+               pr_err("emulate_write_cache cannot be changed with active"
+                      " exports: %d\n", dev->export_count);
+               return -EINVAL;
+       }
        dev->dev_attrib.emulate_write_cache = flag;
        pr_debug("dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
                        dev, dev->dev_attrib.emulate_write_cache)

Are you seeing any other sbc_check_dpofua() related failures beyond this
particular case..?

--nab

