From: Guido Guenther <agx@sigxcpu.org>
Subject: RFC/patch: bflags not applied in case of SCSI_SCAN_TARGET_PRESENT
Date: Fri, 10 Dec 2004 13:33:33 +0100
Message-ID: <20041210123333.GD685@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:8108 "EHLO
	honk1.physik.uni-konstanz.de") by vger.kernel.org with ESMTP
	id S261186AbULJMlG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2004 07:41:06 -0500
Received: from localhost (localhost.localnet [127.0.0.1])
	by honk1.physik.uni-konstanz.de (Postfix) with ESMTP id 1CDAF2BC43
	for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2004 13:41:05 +0100 (CET)
Received: from honk1.physik.uni-konstanz.de ([127.0.0.1])
	by localhost (honk [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 21456-17 for <linux-scsi@vger.kernel.org>;
	Fri, 10 Dec 2004 13:40:58 +0100 (CET)
Received: from bogon.sigxcpu.org (unknown [62.157.100.134])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by honk1.physik.uni-konstanz.de (Postfix) with ESMTP id DA4932BC3E
	for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2004 13:40:57 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
we're using a qla2342 together with an EMC Symmetric. SCSI scanning the
EMC reports a peripheral identifier of 3 for lun 0, which leads to
a SCSI_SCAN_PRESENT return code of scsi_probe_and_add_lun, but the
devices blacklist flags are not being honored. This is a problem since
we need SCSI_LARGELUN for successfull scanning on LUNs past 8 in
scsi_scan_target. The attached patch tries to fix this:

a) makes sure we honor the bflags in scsi_probe_and_add_lun, even when
   there's no device supported on this lun (lun 0 is special so it might
   make sense to special case this for lun 0 only)
b) passes them on to the sequential scanning part of scsi_scan_target.

--- linux-2.6.10-rc3.real-orig/drivers/scsi/scsi_scan.c	2004-12-09 18:48:39.000000000 +0100
+++ linux-2.6.10-rc3/drivers/scsi/scsi_scan.c	2004-12-10 12:03:59.000000000 +0100
@@ -717,6 +730,8 @@
 					"scsi scan: peripheral qualifier of 3,"
 					" no device added\n"));
 		res = SCSI_SCAN_TARGET_PRESENT;
+		if (bflagsp)
+			*bflagsp = bflags;
 		goto out_free_result;
 	}
 
@@ -1157,10 +1179,10 @@
 		/*
 		 * There's a target here, but lun 0 is offline so we
 		 * can't use the report_lun scan.  Fall back to a
-		 * sequential lun scan with a bflags of SPARSELUN and
+		 * sequential lun scan with a bflags of at least SPARSELUN and
 		 * a default scsi level of SCSI_2
 		 */
-		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN,
+		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN | bflags,
 				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
 	}
 }

Does this look o.k.? Patch is against 2.6.10-rc3. I know little about
scsi scanning, so this might be completely bogus.
Please cc: me on replies since I'm not subscribe to this list.
Cheers,
 -- Guido
