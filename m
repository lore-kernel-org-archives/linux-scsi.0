From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Mon, 6 Mar 2006 00:26:14 -0800
Message-ID: <20060306082614.GA27603@us.ibm.com>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:24220 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1752245AbWCFIbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2006 03:31:05 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k268V5pv007649
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 03:31:05 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k268V55Z106834
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 03:31:05 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k268V4Bj030442
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 03:31:04 -0500
Content-Disposition: inline
In-Reply-To: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>


Ran into a issue that on the first load I did not have the
attach_HostRAID=1 that I need for my model of card so when I went to do a
modprobe -r; modprobe I got an oops. The patch below helps with the
describe case, but does not fix the problem of not being able to unload if
devices are found.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 drivers/scsi/sas/sas_init.c |    2 ++
 1 files changed, 2 insertions(+)

Index: sas-2.6-patched/drivers/scsi/sas/sas_init.c
===================================================================
--- sas-2.6-patched.orig/drivers/scsi/sas/sas_init.c	2006-03-03 00:07:04.000000000 -0800
+++ sas-2.6-patched/drivers/scsi/sas/sas_init.c	2006-03-05 23:26:21.000000000 -0800
@@ -145,6 +145,8 @@ static int __init sas_class_init(void)
 
 static void __exit sas_class_exit(void)
 {
+	if (sas_transport_template)
+		sas_release_transport(sas_transport_template);
 	if (sas_task_cache)
 		kmem_cache_destroy(sas_task_cache);
 }
