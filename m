From: "Qi, Yanling" <yanling.qi@lsil.com>
Subject: 2.6 kernel and hot-plug in scsi subsystem
Date: Thu, 8 Apr 2004 10:31:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <53CF1076699CD711B7DD0002A51363F102AD7F8A@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39909 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261907AbUDHPcl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 11:32:41 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id i38FWRcq009722
	for <linux-scsi@vger.kernel.org>; Thu, 8 Apr 2004 08:32:27 -0700 (PDT)
Received: from exw-ks.ks.lsil.com (wic1.ks.lsil.com [153.79.12.11])
	by milmhbs0.lsil.com (8.12.11/8.12.10) with ESMTP id i38FWrrd008132
	for <linux-scsi@vger.kernel.org>; Thu, 8 Apr 2004 08:32:54 -0700
List-Id: linux-scsi@vger.kernel.org
To: 'linux-scsi-reflector' <linux-scsi@vger.kernel.org>

I didn't find out how hot-plug is handled in the SCSI subsystem and its
drivers, specially in a SAN environment. Let's assume we have the following
two scenarios:

1. A new target port is plugged into a FC switch where a Linux host HBA is
connected to. 
2. An existing target creates a new LUN (a hardware RAID system).

In the first case, FC switch will generate a RSCN event, the FC HBA driver
knows a new target port joins the Fabric. Should FC HBA driver find new LUNs
on that target port and call scsi_add_device()/scsi_scan_host()? What should
the hot-plug event chain look like in this case?

With the second case, the target will generate a UA 3Fh/0Eh (REPORTED LUNS
DATA HAS CHANGED). If we plan to handle this case, should the middle level
check the check-condition and perform host-rescan?

Yanling

 Yanling Qi
 Software Engineer
 9020-I Capital of TX Hwy, Ste150
 Austin, TX 78759
 512-794-3713 phone
 512-794-3702 fax
 yanling.qi@lsil.com
 www.lsilogicstorage.com

 LSI Logic Storage Systems
 AT THE HEART OF INFORMATION
