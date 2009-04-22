From: Daniela Engert <dani@ngrt.de>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 17:10:55 +0200
Message-ID: <49EF337F.1030804@ngrt.de>
References: <20090422090929.GA14928@havoc.gtf.org> <49EEE225.3010700@garzik.org> <49EF0A92.1070400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:60319 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZDVPKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 11:10:55 -0400
In-Reply-To: <49EF0A92.1070400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>

Boaz Harrosh wrote:
> On 04/22/2009 12:23 PM, Jeff Garzik wrote:
>> Jeff Garzik wrote:
>>> Currently, libata creates a Scsi_Host per port.  This was originally
>>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>>> devices, but is not needed for most modern SATA controllers.   And I
>>> _think_ it is not needed for master/slave if done properly, either.

>>> It may work with other controllers -- TRY AT YOUR OWN RISK.  It will
>>> probably fail for master/slave configurations, and SAS & PMP also
>>> need looking at.  It yielded this lsscsi output on my AHCI box:
>>>
>>> [0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
>>> [0:2:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
>>> [0:5:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0
>> For comparison, here is unmodified 2.6.30-rc3:
>>
>> [jgarzik@bd ~]$ lsscsi
>> [0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
>> [2:0:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
>> [5:0:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0
>>
> 
> Could the master/slave be simply solved by emulating a SCSI LUN

Don't forget, there are ATAPI devices (some Sony CD burners and old 
phase-changers come into mind) which *do* have multiple LUNs sitting 
beyond the PATA port. I don't know if libata supports such setups (my 
old OS/2 driver does) but one shouldn't hijack LUNs to emulate targets.

Ciao,
   Dani
