From: Tong Zhang <ztong@vt.edu>
Subject: duplicate check for CAP_SYS_RAWIO
Date: Tue, 25 Sep 2018 13:27:05 -0400
Message-ID: <9CFCBC36-B08F-4920-B144-F7EED5B9BC33@vt.edu>
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Kernel Version: 4.18.5

Problem Description:

We found a path where duplicate capability checks are observed,
the path is :

scsi_ioctl<- require CAP_SYS_ADMIN and CAP_SYS_RAWIO
     `->sg_scsi_ioctl() 
                `->blk_verify_command() <- require CAP_SYS_RAWIO

CAP_SYS_RAWIO is checked twice.

related file: 
  block/scsi_ioctl.c:215 
  block/scsi_ioctl.c:471
  drivers/scsi/scsi_ioctl.c:240
  drivers/scsi/scsi_ioctl.c:242

- Tong
