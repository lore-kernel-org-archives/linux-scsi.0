From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: REPORT LUNS
Date: Fri, 13 Jun 2003 16:04:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE9DA00.A429F83F@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------7B6CFB07DD5B16D77E9CAAA9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plim.fujitsu-siemens.com ([217.115.66.8]:25146 "EHLO
	plim.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S265396AbTFMNsx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2003 09:48:53 -0400
Received: from trulli.pdb.fsc.net (this.is.a.RFC1918.address [172.25.96.53] (may be forged))
	by plim.fujitsu-siemens.com (8.11.3/8.11.3) with ESMTP id h5DE2dF27255
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2003 16:02:39 +0200
Received: from fujitsu-siemens.com (bounty.pdb.fsc.net [172.25.187.68])
	by trulli.pdb.fsc.net (8.11.6/8.11.6) with ESMTP id h5DE2dg15243
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2003 16:02:39 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------7B6CFB07DD5B16D77E9CAAA9
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Wile trying to figure out how to ignore non-existing LUNs on RAID
devices, I have fallen across an error in scsilun_to_int() where it
doesn't behave as the comment suggests and a problematic piece of code
in scsi_report_lun_scan().

Patch is included.

-- =

Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
--------------7B6CFB07DD5B16D77E9CAAA9
Content-Type: text/plain; charset=us-ascii;
 name="patch-2.5.70a"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-2.5.70a"

--- linux-2.5.70/drivers/scsi/scsi_scan.c	2003-05-27 03:00:46.000000000 +0200
+++ linux-2.5.70a/drivers/scsi/scsi_scan.c	2003-06-13 15:54:22.000000000 +0200
@@ -884,8 +884,8 @@
 
 	lun = 0;
 	for (i = 0; i < sizeof(lun); i += 2)
-		lun = lun | (((scsilun->scsi_lun[i] << 8) |
-			      scsilun->scsi_lun[i + 1]) << (i * 8));
+		lun = lun | (((scsilun->scsi_lun[i] & 0x3f) << (i * 8 + 1)) |
+			      ((scsilun->scsi_lun[i + 1]) << (i * 8)));
 	return lun;
 }
 
@@ -1027,13 +1027,18 @@
 	 * the header, so start at 1 and go up to and including num_luns.
 	 */
 	for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++) {
+		int j;
+
 		lun = scsilun_to_int(lunp);
 
 		/*
 		 * Check if the unused part of lunp is non-zero, and so
 		 * does not fit in lun.
 		 */
-		if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", 4)) {
+		for (j = sizeof(lun); j < sizeof(struct scsi_lun); j++)
+		    if (lunp->scsi_lun[j] != 0)
+			break;
+		if (j < sizeof(struct scsi_lun)) {
 			int i;
 
 			/*


--------------7B6CFB07DD5B16D77E9CAAA9--

