From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 05:23:49 -0400
Message-ID: <49EEE225.3010700@garzik.org>
References: <20090422090929.GA14928@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756716AbZDVJYZ@vger.kernel.org>
In-Reply-To: <20090422090929.GA14928@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Currently, libata creates a Scsi_Host per port.  This was originally
> done to leverage SCSI's infrastructure to arbitrate among master/slave
> devices, but is not needed for most modern SATA controllers.   And I
> _think_ it is not needed for master/slave if done properly, either.

BTW note the above, with regards to the libata SCSI->block conversion. 
libata currently relies on SCSI for some amount of generic device 
arbitration, in several situations (see ->qc_defer, 
SCSI_MLQUEUE_.*_BUSY).  libata expects SCSI to be intelligent and not 
starve devices, etc.


> I was able to successfully boot the following patch on
> AHCI/x86-64/Fedora.
> 
> It may work with other controllers -- TRY AT YOUR OWN RISK.  It will
> probably fail for master/slave configurations, and SAS & PMP also
> need looking at.  It yielded this lsscsi output on my AHCI box:
> 
> [0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
> [0:2:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
> [0:5:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0

For comparison, here is unmodified 2.6.30-rc3:

[jgarzik@bd ~]$ lsscsi
[0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
[2:0:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
[5:0:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0
