From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: possible bug in rmmod scsi controllers?
Date: Thu, 10 Jun 2004 11:01:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <DB7891DD5641F14391475AFFF42568F50551A25E@azsmsx407>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from petasus.ch.intel.com ([143.182.124.5]:51558 "EHLO
	petasus.ch.intel.com") by vger.kernel.org with ESMTP
	id S262170AbUFJSBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2004 14:01:50 -0400
Received: from azsmsxvs040.ch.intel.com (azsmsxvs040.ch.intel.com [143.182.252.54])
	by petasus.ch.intel.com (8.12.9-20030918-01/8.12.9/d: small-solo.mc,v 1.9 2004/01/09 01:01:53 root Exp $) with SMTP id i5AI1Ghb014012
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2004 18:01:48 GMT
Received: from azsmsx331-2.ch.intel.com ([10.2.161.41])
 by azsmsxvs040.ch.intel.com (SAVSMTP 3.1.2.35) with SMTP id M2004061011014825760
 for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2004 11:01:48 -0700
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Boji T Kannanthanam (Kannanthanam, Boji T)" <boji.t.kannanthanam@intel.com>

While playing around with scsi_debug on 2.6.7-rc3, I noticed that
whenever I rmmod scsi_debug, the sync cache command always fails. After
a little looking around it seems that whenever scsi_remove_host() is
called, the host state is set to SHOST_CANCEL. If the disk is configured
as write-back cache, then a SYNCH_CACHE command is issued. However, in
scsi_dispatch_cmd() function in scsi.c a check is done to see if
SHOST_CANCEL state is set and if so the command is rejected. Therefore
the sync cache command always fails during unload. Something such as
below fixes the problem:

--- scsi.c.old	2004-06-10 10:43:02.478538016 -0700
+++ scsi.c	2004-06-10 10:41:52.627157040 -0700
@@ -576,7 +576,8 @@
 	}
 
 	spin_lock_irqsave(host->host_lock, flags);
-	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state))) {
+	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state)) &&
+			unlikely(cmd->device->sdev_state == SDEV_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
 	} else {

However, this is a quick hack and I'm sure there are better ways to do
this. There was a similar issue on 2.6.5 with the device state that was
fixed in 2.6.6 which exposed this issue. 

----

    -= Dave =- 

Software Engineer - Advanced Development Engineering Team 
Storage Component Division - Intel Corp. 
mailto://dave-DOT-jiang-AT-intel.com 
----
The views expressed in this email are
mine alone and do not necessarily 
reflect the views of my employer
(Intel Corp.).

