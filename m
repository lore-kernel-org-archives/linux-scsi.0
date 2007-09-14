From: Dave Jiang <djiang@mvista.com>
Subject: command failing at iSCSI disconnect
Date: Fri, 14 Sep 2007 14:43:43 -0700
Message-ID: <46EB008F.7040003@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:27194 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbXINVmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 17:42:00 -0400
Received: from [127.0.0.1] (asshur.mvista.com [10.0.0.11])
	by hermes.mvista.com (Postfix) with ESMTP id 82D4F1E3ED
	for <linux-scsi@vger.kernel.org>; Fri, 14 Sep 2007 14:41:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm using the latest linus git tree. This is in fileio mode with
IOMode=wb. It seems that if I do I/O and then immediately disconnect
then the cache sync commands fail. Is this expected behavior or should
the connection wait till all existing commands has been flushed before
logout? Thanks!

root@192.168.1.171:~/iscsi2# iscsiadm -m node -T
iqn.2007.com.mvista:disk1 -p 192.168.1.239:3260 --logout
Logout session [sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sid: 1, target: iqn.2007.com.mvista:disk1, portal: 192.168.1.239,3260]
iscsi: cmd 0x35 is not queued (6)
iscsi: cmd 0x35 is not queued (6)
iscsi: cmd 0x35 is not queued (6)
sd 1:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
