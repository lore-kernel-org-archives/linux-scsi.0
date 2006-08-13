From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: scsi_host_template.can_queue and "software host adapters"
Date: Sun, 13 Aug 2006 15:52:17 +0200
Message-ID: <44DF2E91.6050208@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34708 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751247AbWHMNxG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 09:53:06 -0400
Received: from [192.168.0.41] ([83.221.230.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.13.6/8.13.6/Debian-1) with ESMTP id k7DDr0Ul006914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 13 Aug 2006 15:53:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

the "hosts" usb-storage and sbp2 currently use one instance of struct 
Scsi_Host per instance of struct scsi_device. I believe certain other 
similar "pseudo host adapters" did or do the same for various reasons.

I am thinking about converting sbp2 to use a single Scsi_Host for all 
SBP-2 targets. This would mean that the sbp2 "host's" command queuing 
capacity will be unlimited. There will only be the queuing limits of 
each logical unit.

Given there are no other show stoppers for my planned rework of sbp2, 
which value should I set sbp2's host template's can_queue to? INT_MAX?
-- 
Stefan Richter
-=====-=-==- =--- -==-=
http://arcgraph.de/sr/
