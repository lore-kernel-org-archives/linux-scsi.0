From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Kill superfluos newline in dmesg output of aic7xxx
Date: Fri, 25 Mar 2005 10:02:50 +0100
Message-ID: <200503251002.51656.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Received: from mail.sf-mail.de ([62.27.20.61]:30849 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S261610AbVCYLa0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 06:30:26 -0500
Received: from dfue129.rz.uni-mannheim.de ([::ffff:134.155.18.129] HELO caliban.sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.3pre) with (RC4-MD5 encrypted) ESMTPS
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2005 12:30:24 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

my dmesg looks like this:

----
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec 2940A Ultra SCSI adapter>
        aic7860: Single Channel A, SCSI Id=7, 3/253 SCBs

(scsi0:A:0): 10.000MB/s transfers (10.000MHz, offset 15)
  Vendor: SEAGATE   Model: ST318436LW        Rev: 0010
----

To avoid the empty line I think this patch is needed.

Eike

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

diff -aupr linux-2.6.11/drivers/scsi/aic7xxx/aic7xxx_osm.c linux-2.6.12-rc1/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- linux-2.6.11/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-03-02 08:37:48.000000000 +0100
+++ linux-2.6.12-rc1/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-03-25 09:57:01.000000000 +0100
@@ -932,7 +932,6 @@ ahc_linux_info(struct Scsi_Host *host)
 	strcat(bp, "        ");
 	ahc_controller_info(ahc, ahc_info);
 	strcat(bp, ahc_info);
-	strcat(bp, "\n");
 
 	return (bp);
 }
