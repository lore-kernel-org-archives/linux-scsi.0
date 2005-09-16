From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] change port speed definitions for scsi_transport_fc
Date: Fri, 16 Sep 2005 11:01:14 +0200
Message-ID: <20050916090114.GA7110@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:7298 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1161054AbVIPJEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 05:04:01 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j8G93ud7099036
	for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 09:03:56 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8G93udg181250
	for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 11:03:56 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j8G93ttP018084
	for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 11:03:56 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>, James Smart <james.smart@emulex.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

obviously FC Port Speeds in scsi_transport_fc.h are defined according
to FC-HBA:

#define FC_PORTSPEED_1GBIT              1
#define FC_PORTSPEED_2GBIT              2
#define FC_PORTSPEED_10GBIT             4
#define FC_PORTSPEED_4GBIT              8

Problem is, whoever invented FC-HBA did not care about FC-FS or
FC-GS-x. Following FC-FS/FC-GS-x defintions of port speeds would look
like:

1 GBit: 0x0001
2 GBit: 0x0002
4 GBit: 0x0004
10GBit: 0x0008

(and new in FC-LS:
8 Gbit: 0x0010
16GBit: 0x0020)

I really appreciate if scsi_transport_fc.h would define port speeds
according to FC-GS-x/FC-FS. Thus mapping of port speed capabilities to
values defined in scsi_transport_fc.h can be avoided in the LLDD.

Attached is a patch to change the definitions.


Regards,

Andreas

--- linux-2.6.14-rcx/include/scsi/scsi_transport_fc.h.orig	2005-09-16 10:49:44.000000000 +0200
+++ linux-2.6.14-rcx/include/scsi/scsi_transport_fc.h	2005-09-16 10:50:03.000000000 +0200
@@ -103,8 +103,8 @@ enum fc_port_state {
 					     incapable of reporting */
 #define FC_PORTSPEED_1GBIT		1
 #define FC_PORTSPEED_2GBIT		2
-#define FC_PORTSPEED_10GBIT		4
-#define FC_PORTSPEED_4GBIT		8
+#define FC_PORTSPEED_4GBIT		4
+#define FC_PORTSPEED_10GBIT		8
 #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
 
 /*
