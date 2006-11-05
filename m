From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Sat, 4 Nov 2006 16:45:07 -0800 (PST)
Message-ID: <472336.19994.qm@web31803.mail.mud.yahoo.com>
References: <1162681950.3630.9.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:12936 "HELO
	web31803.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965764AbWKEApI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 19:45:08 -0500
In-Reply-To: <1162681950.3630.9.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Sat, 2006-11-04 at 11:54 -0800, Luben Tuikov wrote:
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > ---
> >  drivers/scsi/sd.c |   17 +++++++----------
> >  1 files changed, 7 insertions(+), 10 deletions(-)
> > 
> > This patch is 8 months old.
> 
> Um:
> 
> patching file drivers/scsi/sd.c
> Hunk #1 FAILED at 1354.
> Hunk #2 FAILED at 1382.
> 2 out of 2 hunks FAILED -- saving rejects to file drivers/scsi/sd.c.rej
> 
> I think the code you're trying to change has altered a bit in the latest
> kernels.

Re-based:

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

--- 
 drivers/scsi/sd.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 84ff203..ffbd021 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1467,7 +1467,6 @@ sd_read_cache_type(struct scsi_disk *sdk
        res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
 
        if (scsi_status_is_good(res)) {
-               int ct = 0;
                int offset = data.header_length + data.block_descriptor_length;
 
                if (offset >= SD_BUF_SIZE - 2) {
@@ -1496,11 +1495,13 @@ sd_read_cache_type(struct scsi_disk *sdk
                        sdkp->DPOFUA = 0;
                }
 
-               ct =  sdkp->RCD + 2*sdkp->WCE;
-
-               printk(KERN_NOTICE "SCSI device %s: drive cache: %s%s\n",
-                      diskname, sd_cache_types[ct],
-                      sdkp->DPOFUA ? " w/ FUA" : "");
+               printk(KERN_NOTICE "SCSI device %s: "
+                      "write cache: %s, read cache: %s, %s\n",
+                      diskname,
+                      sdkp->WCE ? "enabled" : "disabled",
+                      sdkp->RCD ? "disabled" : "enabled",
+                      sdkp->DPOFUA ? "supports DPO and FUA"
+                      : "doesn't support DPO or FUA");
 
                return;
        }



