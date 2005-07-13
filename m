From: Edward Falk <efalk@google.com>
Subject: Re: map gendisk (or blockdev) -> scsi_device
Date: Wed, 13 Jul 2005 11:44:34 -0700
Message-ID: <db3nei$nrs$1@sea.gmane.org>
References: <db1npr$c1d$1@sea.gmane.org> <20050713143843.GC26025@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59035 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S262312AbVGMSov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 14:44:51 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1DsmDs-0006iG-IR
	for linux-scsi@vger.kernel.org; Wed, 13 Jul 2005 20:44:44 +0200
Received: from 216-239-45-4.google.com ([216.239.45.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 20:44:44 +0200
Received: from efalk by 216-239-45-4.google.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 20:44:44 +0200
In-Reply-To: <20050713143843.GC26025@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


> You should revisit your code to not need access to the scsi_device
> structure, and follow the layering of the block and scsi subsystems.

Maybe I should explain what I'm trying to do here.

Some of our software reads some of the values in /proc/ide/hda/.  We're 
porting this facility to libata-based drivers in 2.6 and moving it to 
/sysfs/block/sda/.  The sysfs show() functions will be given pointers to 
gendisk structures but will need to obtain information from the 
associated scsi_device structure.

Does anybody have any suggestions as to the "right" way to proceed?


meta:

I understand the layering of block vs scsi and so on, but I wonder why 
there's so much isolation in the kernel.  Why should it be impossible to 
obtain the gendisk structure from the scsi_device structure, or to 
obtain the block_device structure from the gendisk?

   -ed falk

