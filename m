From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: aic94xx status
Date: Mon, 10 Jul 2006 09:09:15 -0700
Message-ID: <20060710160915.GA30179@us.ibm.com>
References: <1152376067.12020.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51386 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1422673AbWGJQJO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 12:09:14 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6AG9DoT020464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 12:09:14 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6AG9Dmm270494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 12:09:13 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6AG9C78017227
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 12:09:13 -0400
Content-Disposition: inline
In-Reply-To: <1152376067.12020.26.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 1) SATA support.  We at least need this stubbed out so seeing a SATA
> device won't cause nasty things to happen (IBM is working on this).
> Ideally, we need to integrate this driver with Brian King's SATA/SAS
> code, but no-one who has this board has a sata device and vice versa.
> 

Currently I am running a loaned SATA drive with the patch below. It just
generates the "Unidentified device type" type message when it detects a
SATA device and appears in my configuration to not cause any bad things to
happen.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 Do not drop phy_list_lock is we have not taken it. Also added a SATA_DEV
 case as marker for future calls.

 Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/sas/sas_discover.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_discover.c	2006-06-23 11:12:01.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c	2006-07-05 13:19:20.000000000 -0700
@@ -265,6 +265,7 @@ static int sas_get_port_device(struct as
 		rphy = sas_expander_alloc(port->port,
 					  SAS_FANOUT_EXPANDER_DEVICE);
 		break;
+	case SATA_DEV:
 	default:
 		printk("ERROR: Unidentified device type %d\n", dev->dev_type);
 		rphy = NULL;
@@ -272,7 +273,6 @@ static int sas_get_port_device(struct as
 	}
 
 	if (!rphy) {
-		spin_unlock_irqrestore(&port->phy_list_lock, flags);
 		kfree(dev);
 		return -ENODEV;
 	}
