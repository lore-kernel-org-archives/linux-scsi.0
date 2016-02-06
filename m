From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO support
 optional
Date: Sat, 06 Feb 2016 10:33:44 -0800
Message-ID: <1454783624.2809.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

The reason is fairly obvious: the default for the new option
 BLK_DEV_NVME_SCSI is N and all the distribution kernels (and me when
testing) take the default options (I checked in the OBS kernel builds
and this is true).

The net result is that scsi_id from udev no longer works on nvme disks
and that means that the /dev/disk/by-id links are all gone in 4.5-rc1. 
 If this happens to be how you name your disks in fstab or crypttab,
you can't boot.

If you're going to break an ABI in this way, you really have to plan
for it in userspace.  How are NVMe disk ids supposed to be exported
now?  Does udev need a nvme_id program to do this?  Until there's an
infrastructure ready to work in this way, we need to unconditionally
enable BLK_DEV_NVME_SCSI.

James
