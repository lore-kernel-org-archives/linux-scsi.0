From: Ashutosh Naik <ashutosh.naik@gmail.com>
Subject: PATCH [1/2] scsi/BusLogic.c:Handle scsi_add_host failure
Date: Wed, 11 Jan 2006 15:05:16 +0530
Message-ID: <81083a450601110135t4f038fbds1bce6d8c9302e89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_15292_28003396.1136972116981"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.206]:21162 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751406AbWAKJfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 04:35:17 -0500
Received: by zproxy.gmail.com with SMTP id 14so116739nzn
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2006 01:35:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@steeleye.com, lnz@dandelion.com, Andrew Morton <akpm@osdl.org>

------=_Part_15292_28003396.1136972116981
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Add scsi_add_host() failure handling for the Linux Driver for BusLogic
MultiMaster and FlashPoint SCSI Host Adapters

Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

------=_Part_15292_28003396.1136972116981
Content-Type: text/plain; name=BusLogic.txt; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="BusLogic.txt"

diff -Naurp linux-2.6.15-git6-vanilla/drivers/scsi/BusLogic.c linux-2.6.15-git6/drivers/scsi/BusLogic.c
--- linux-2.6.15-git6-vanilla/drivers/scsi/BusLogic.c	2005-10-28 05:32:08.000000000 +0530
+++ linux-2.6.15-git6/drivers/scsi/BusLogic.c	2006-01-11 14:12:37.000000000 +0530
@@ -2173,7 +2173,7 @@ static int BusLogic_SlaveConfigure(struc
 
 static int __init BusLogic_init(void)
 {
-	int BusLogicHostAdapterCount = 0, DriverOptionsIndex = 0, ProbeIndex;
+	int BusLogicHostAdapterCount = 0, DriverOptionsIndex = 0, ProbeIndex, retval;
 	struct BusLogic_HostAdapter *PrototypeHostAdapter;
 
 #ifdef MODULE
@@ -2296,7 +2296,12 @@ static int __init BusLogic_init(void)
 				scsi_host_put(Host);
 			} else {
 				BusLogic_InitializeHostStructure(HostAdapter, Host);
-				scsi_add_host(Host, NULL);
+				retval = scsi_add_host(Host, NULL);
+				if (retval) {
+					printk(KERN_WARNING "BusLogic: scsi_add_host failed\n");
+					scsi_host_put(host);
+					return retval;
+				}
 				scsi_scan_host(Host);
 				BusLogicHostAdapterCount++;
 			}

------=_Part_15292_28003396.1136972116981--
