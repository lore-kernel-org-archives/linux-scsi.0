From: Michele Baldessari <michele-lists@pupazzo.org>
Subject: 2.6 and DEC HSG80
Date: Fri, 18 Nov 2005 12:25:40 +0100
Message-ID: <20051118112540.GB13447@michele.pupazzo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgrava.tizianodinca.com ([195.47.199.19]:53892 "EHLO
	mail2.rhx.it") by vger.kernel.org with ESMTP id S1161044AbVKRLZm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 06:25:42 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail2.rhx.it (Postfix) with ESMTP id E8727179B4
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 12:25:38 +0100 (CET)
Received: from mail2.rhx.it ([127.0.0.1])
 by localhost (mail2.rhx.it [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 28010-03 for <linux-scsi@vger.kernel.org>;
 Fri, 18 Nov 2005 12:25:38 +0100 (CET)
Received: from laptop (nat.xsec.it [83.103.127.222])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "kantele", Issuer "mail2.rhx.it" (verified OK))
	by mail2.rhx.it (Postfix) with ESMTP id 9D71D1799B
	for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2005 12:25:38 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

While struggling to get a DEC HSG80 working with a qla2312 FC card with a 2.6 kernel, 
I noticed that the following patch:

--- linux-2.6.13.4/drivers/scsi/scsi_devinfo.c.orig 2005-11-17 17:52:49.424914776 +0100
+++ linux-2.6.13.4/drivers/scsi/scsi_devinfo.c  2005-11-17 17:53:12.938400491 +0100
@@ -135,7 +135,7 @@
        {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
        {"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
        {"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
-       {"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+       {"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_NOSTARTONADD},
        {"DELL", "PV660F", NULL, BLIST_SPARSELUN},
        {"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
        {"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},     /* Dell PV 530F */

(to be found at http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-04/0511.html)

was never applied (probably because the poster didn't follow up on James' question).

Applying this patch, I am able to see the device correctly, although I get a good half an hour
of messages like:

scsi: unknown device type 31
  Vendor: DEC       Model: HSG80             Rev: V86F
  Type:   Unknown                            ANSI SCSI revision: 02

on my syslog. But I guess those will be fixable by tweaking the max_report_luns option (Will do 
on monday once I get a hold of such machine).

So, to the point, could the above patch be integrated? Any specific
testing I should be doing to get it integrated?

thanks,
Michele

ps. for the record kernels >= 2.6.14 end up in a soft lockup in the qla drivers 
(see <20051116193608.GA8500@michele.pupazzo.org> for the full report)
