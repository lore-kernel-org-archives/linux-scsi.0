From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/15] copy offload patches
Date: Thu, 10 Dec 2015 12:29:57 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi

This patch series adds copy offload (the XCOPY command) to the block 
layer, SCSI subsystems and device mapper.

The principle of operation is this:

We create two bios with REQ_COPY flag, one for read and one for write. The 
bios have no data pages and they both point to the same bio_copy 
structure. The bios may be submitted to the same logical volume or to 
different logical volumes. The bios go independently through the device 
mapper stack and when they both reach the physical device (the function 
blk_queue_bio), the bio pair is collected and the XCOPY request is sent to 
the SCSI device.

Mikulas
