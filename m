From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Automatic LUN detectioning not working
Date: Mon, 06 Nov 2006 11:22:48 +0100
Message-ID: <1162808568.3160.194.camel@laptopd505.fenrus.org>
References: <20061106090702.GA8071@npjaco.netgroup.co.za>
	 <1162807123.3160.182.camel@laptopd505.fenrus.org>
	 <20061106100806.GA9343@npjaco.netgroup.co.za>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:25505 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S1423743AbWKFKXE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 05:23:04 -0500
In-Reply-To: <20061106100806.GA9343@npjaco.netgroup.co.za>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaco van der Schyff <jvds@netgroup.co.za>
Cc: linux-scsi@vger.kernel.org

> Host: scsi1 Channel: 00 Id: 00 Lun: 00
> Vendor: SA-6640S Model:                  Rev: R0.0
> Type:   Direct-Access                    ANSI SCSI revision: 03
> 
> The device is question is the SA-6640S on scsi1:0:0:0

the patch below should make this one work... can you test it and confirm
if it works/doesn't work?

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

--- linux-2.6.18/drivers/scsi/scsi_devinfo.c.org	2006-11-06 11:19:29.000000000 +0100
+++ linux-2.6.18/drivers/scsi/scsi_devinfo.c	2006-11-06 11:21:15.000000000 +0100
@@ -211,6 +211,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
+	{"SA-6640S", "", "R0.0", BLIST_FORCELUN},
 	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
 	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},

