From: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>
Subject: [PATCH 1/1] : Spinning up disk is observed on standby paths until
 timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 11:14:59 +0000
Message-ID: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:34951 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZBTLQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2009 06:16:19 -0500
Received: from G3W0631.americas.hpqcorp.net (g3w0631.americas.hpqcorp.net [16.233.59.15])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g5t0007.atlanta.hp.com (Postfix) with ESMTPS id 97E4D146D7
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2009 11:16:18 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Hi,

  Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time in 2.6.27 kernel.

 Steps to reproduce:
 1. present a standby lun to the host
 2. do a discovery from the host (scan the scsi bus)
 3. Spinning of disks is  observed in  /var/log/messages

Whenever a device goes offline and comes back, the new sd device takes longer
time to get created. This is because of the spinning up of disk in
sd_spinup_disk fuction as the standby paths would return device not ready with
0x04/0x0b asc/ascq.

Recommended patch :

  diff -pNaur /usr/src/linux/drivers/scsi/sd.c sd.c
--- /usr/src/linux/drivers/scsi/sd.c    2009-02-09 22:24:56.000000000 +0530
+++ sd.c        2009-02-19 16:39:16.000000000 +0530
@@ -1181,8 +1181,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
                 */
                if (sense_valid &&
                    sshdr.sense_key == NOT_READY &&
-                   sshdr.asc == 4 && sshdr.ascq == 3) {
-                       break;          /* manual intervention required */
+                   sshdr.asc == 4 && (sshdr.ascq == 3 || sshdr.ascq == 0x0b ||
sshdr.ascq == 0x0c) ) {
+                       break;  /* manual intervention required || Standby ||
Unavailable */

                /*
                 * Issue command to spin up drive when not ready


Thanks,
Narayanan