From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 1/1] drivers/scsi: fix proc_scsi_write to return
	"length" on success with remove-single-device case
Date: Thu, 27 Apr 2006 14:07:49 -0500
Message-ID: <1146164869.3528.20.camel@mulgrave.il.steeleye.com>
References: <200604262138.k3QLchcv009103@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52443 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750754AbWD0TIG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 15:08:06 -0400
In-Reply-To: <200604262138.k3QLchcv009103@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, suzuki@in.ibm.com

On Wed, 2006-04-26 at 14:41 -0700, akpm@osdl.org wrote:
> +               if (!err)
> +                       err = length;

We have more than one of these cases; we might as well accommodate them
all at the bottom of the routine, like the attached

James

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 07be62b..55200e4 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -266,8 +266,6 @@ static ssize_t proc_scsi_write(struct fi
 		lun = simple_strtoul(p + 1, &p, 0);
 
 		err = scsi_add_single_device(host, channel, id, lun);
-		if (err >= 0)
-			err = length;
 
 	/*
 	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
@@ -284,6 +282,13 @@ static ssize_t proc_scsi_write(struct fi
 		err = scsi_remove_single_device(host, channel, id, lun);
 	}
 
+	/*
+	 * convert success returns so that we return the 
+	 * number of bytes consumed.
+	 */
+	if (!err)
+		err = length;
+
  out:
 	free_page((unsigned long)buffer);
 	return err;


