From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Wed, 15 Nov 2006 12:47:08 -0800 (PST)
Message-ID: <643370.18693.qm@web31814.mail.mud.yahoo.com>
References: <1163622402.3524.14.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1326788834-1163623628=:18693"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:64344 "HELO
	web31814.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030992AbWKOUrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 15:47:09 -0500
In-Reply-To: <1163622402.3524.14.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--0-1326788834-1163623628=:18693
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Sat, 2006-11-04 at 16:45 -0800, Luben Tuikov wrote:
> > Re-based:
> > 
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> 
> It still won't apply ... this time it looks like a mailer tab->space
> conversion problem.

Attached.

    Luben

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>


--0-1326788834-1163623628=:18693
Content-Type: text/plain; name="sd.txt"
Content-Description: 2974651858-sd.txt
Content-Disposition: inline; filename="sd.txt"

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 84ff203..ffbd021 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1467,7 +1467,6 @@ sd_read_cache_type(struct scsi_disk *sdk
 	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
-		int ct = 0;
 		int offset = data.header_length + data.block_descriptor_length;
 
 		if (offset >= SD_BUF_SIZE - 2) {
@@ -1496,11 +1495,13 @@ sd_read_cache_type(struct scsi_disk *sdk
 			sdkp->DPOFUA = 0;
 		}
 
-		ct =  sdkp->RCD + 2*sdkp->WCE;
-
-		printk(KERN_NOTICE "SCSI device %s: drive cache: %s%s\n",
-		       diskname, sd_cache_types[ct],
-		       sdkp->DPOFUA ? " w/ FUA" : "");
+		printk(KERN_NOTICE "SCSI device %s: "
+		       "write cache: %s, read cache: %s, %s\n",
+		       diskname,
+		       sdkp->WCE ? "enabled" : "disabled",
+		       sdkp->RCD ? "disabled" : "enabled",
+		       sdkp->DPOFUA ? "supports DPO and FUA"
+		       : "doesn't support DPO or FUA");
 
 		return;
 	}

--0-1326788834-1163623628=:18693--
