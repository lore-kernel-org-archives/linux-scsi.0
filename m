From: Emiliano Garcia <emi@vinyltribe.com>
Subject: Problem with SCSI in 2.6.9
Date: Wed, 15 Dec 2004 13:57:30 -0800
Message-ID: <41C0B34A.7030701@vinyltribe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tierzero.net ([66.6.216.70]:2464 "HELO mail.tierzero.net")
	by vger.kernel.org with SMTP id S262507AbULOV5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2004 16:57:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

    I have twice now run into a bug where the scsi layer tries to 
synchronize the scsi cache on a device that is no longer plugged into 
the system. After this, a cat /proc/scsi/scsi hangs my terminal, and the 
load average on the machine won't drop below 1.0. It takes roughly a 
month for this bug to show up, I back up my system to a firewire drive 
every week, and today on the 28th day of uptime I have this in dmesg:

ieee1394: Node changed: 0-01:1023 -> 0-00:1023
ieee1394: Node suspended: ID:BUS[0-00:1023]  GUID[0010100500000689]
Synchronizing SCSI cache for disk sda:


Clearly you can see that the scsi layer tries to sync after the fw 
device has been unplugged. All this and I even did this before unplugging:

sync;sync;sync;umount /mnt/backup;

This is the second time I have run into this and I belive is related to 
post on the LKM:

Aug. 5th 2004:

Re: BUG: SCSI SYNCHRONIZE_CACHE on driver unload

Please refer to this email (google it) because I believe it is very related.

Regards,

Emiliano Garcia
Senior Systems Admin
