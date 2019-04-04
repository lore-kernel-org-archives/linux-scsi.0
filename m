From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: correcting incorrect peripheral device type 0x0
Date: Thu, 4 Apr 2019 14:02:01 +0200
Message-ID: <69474538-b097-f672-a263-aefd5958dc90@free.fr>
References: <ab8d589f-db76-9a95-1b55-3e906ad89487@free.fr>
 <yq1zhp6satq.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zhp6satq.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Avri Altman <avri.altman@wdc.com>, Alim Akhtar <alim.akhtar@samsung.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/04/2019 05:34, Martin K. Petersen wrote:

> Marc wrote:
> 
>> scsi 0:0:0:49488: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c150hN
> 
>             ^^^^^ Where do these crazy LUN numbers come from? That
>             looks like something which needs fixing...

	sdev_printk(KERN_WARNING, sdev, "%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
			__func__, sdev->type, (unsigned int)sdev->lun);

What does the "hN" suffix stand for? It seems redundant with the "0x" prefix...
(Looks like hN might be "hexadecimal Number")


scsi 0:0:0:49488 -> 0xc150
scsi 0:0:0:49476 -> 0xc144
scsi 0:0:0:49456 -> 0xc130

4.7.7.5.1 Well known logical unit addressing

Table 37 — Well known logical unit extended addressing format

Bit         7         6         5         4         3         2         1         0
       ADDRESS METHOD (11b)     LENGTH (00b)          EXTENDED ADDRESS METHOD (1h)

1100 0001 = 0xc1

So W-LUN 0x50, 0x44, 0x30.

"The W-LUN field specifies the well known logical unit to be addressed (see SPC-4)."

Does anything seem out-of-place?


I'd change the log message like this:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 53380e07b40e..d28c5a30f60a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -820,8 +820,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		 */
 		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
 			sdev_printk(KERN_WARNING, sdev,
-				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
-				__func__, sdev->type, (unsigned int)sdev->lun);
+				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%016llx\n",
+				__func__, sdev->type, (unsigned long long)sdev->lun);
 			sdev->type = TYPE_WLUN;
 		}
 
