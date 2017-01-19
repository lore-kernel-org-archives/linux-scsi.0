From: Jens Axboe <axboe@kernel.dk>
Subject: Re: requeue failure with blk-mq-sched
Date: Thu, 19 Jan 2017 06:09:13 -0800
Message-ID: <8b7436c0-91c4-0b70-071c-364abe1f24f5@kernel.dk>
References: <fb509d83-c895-ba78-e181-145c77542eac@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34554 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752992AbdASOQO (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Thu, 19 Jan 2017 09:16:14 -0500
Received: by mail-pf0-f178.google.com with SMTP id e4so13923292pfg.1
        for <Linux-scsi@vger.kernel.org>; Thu, 19 Jan 2017 06:16:14 -0800 (PST)
In-Reply-To: <fb509d83-c895-ba78-e181-145c77542eac@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 01/19/2017 04:27 AM, Hannes Reinecke wrote:
> Hi Jens,
> 
> upon further testing with your blk-mq-sched branch I hit a queue stall
> during requeing:
> 
> [  202.340959] sd 3:0:4:1: tag#473 Send: scmd 0xffff880422e7a440
> [  202.340962] sd 3:0:4:1: tag#473 CDB: Test Unit Ready 00 00 00 00 00 00
> [  202.341161] sd 3:0:4:1: tag#473 Done: ADD_TO_MLQUEUE Result:
> hostbyte=DID_OK driverbyte=DRIVER_OK
> [  202.341164] sd 3:0:4:1: tag#473 CDB: Test Unit Ready 00 00 00 00 00 00
> [  202.341167] sd 3:0:4:1: tag#473 Sense Key : Unit Attention [current]
> [  202.341171] sd 3:0:4:1: tag#473 Add. Sense: Power on, reset, or bus
> device reset occurred
> [  202.341173] sd 3:0:4:1: tag#473 scsi host busy 1 failed 0
> [  202.341176] sd 3:0:4:1: tag#473 Inserting command ffff880422e7a440
> into mlqueue
> 
> ... and that is the last ever heard of that device.
> The 'device_busy' count remains at '1' and no further commands will be
> sent to the device.

If device_busy is at 1, then it should have a command pending. Where did
you log this - it would be bandy if you attached whatever debug patch
you put in, so we can see where the printks are coming from. If we get a
BUSY with nothing pending, the driver should be ensuring that the queue
gets run again later through blk_mq_delay_queue(), for instance.

When the device is stuck, does it restart if you send it IO?

-- 
Jens Axboe

