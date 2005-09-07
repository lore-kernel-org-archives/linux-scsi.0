From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: deadlock in scsi_remove_device + sr_mod
Date: Wed, 07 Sep 2005 21:31:19 +0200
Message-ID: <431F4007.3080807@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53729 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932187AbVIGTbc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 15:31:32 -0400
Received: from [192.168.0.41] ([62.180.98.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id j87JVMJS024508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2005 21:31:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

as I already mentioned earlier, sr_mod is prone to deadlocks if 
scsi_remove_device is called for a CD-ROM. Specifically, when sr_mod is 
running retries of failing start-up commands (i.e. whatever sr_mod is 
doing shortly after a CD-ROM was added), scsi_remove_device will sleep 
non-interruptibly.

Here is a syslog, taken from Linux 2.6.13-rc4 plus linux1394.org's sbp2 
updates: http://marc.theaimsgroup.com/?l=linux-scsi&m=112432347606912
-- 
Stefan Richter
-=====-=-=-= =--= --===
http://arcgraph.de/sr/
