From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [PATCH 2.6] partly rewritten I2O subsystem to better fit into 2.6
 kernel
Date: Fri, 23 Jul 2004 00:40:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41004277.1010106@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.239.201.226] ([213.239.201.226]:55008 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S267335AbUGVWt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2004 18:49:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

finally there is a new version of the I2O subsystem available. The patch 
is 600k large and available under:

http://i2o.shadowconnect.com/patches/i2o-build_92.patch

and also bzip2 compressed under:

http://i2o.shadowconnect.com/patches/i2o-build_92.patch.bz2

The major benefits are:
- sysfs support
- PCI probing (which now should allow PCI hotplugging)
- dynamically allocated request queues and gendisks for block devices
   and a own request queue per disk (which results in much better
   performance on many parallel requests)

To verify the stability, we've run 4 parallel bonnie++ on a dual Opteron 
on 4 separate disks without a problem. To generate huge load we've also 
created a ext2 filesystem on all 4 disks in parallel. This lead to 
hangups of single disks in earlier versions, but is now fixed.
Also the driver was tested on 32-bit as well, but only with 2 disks :-)

Compared to my last post, all subsystems are now converted to use the 
new API.

Please include the patch to get a wider exposure to test it, and let me 
know, if there is something missing or there is something to change.

Any comment is appreciated.



Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
