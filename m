From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 9 Aug 2013 21:15:42 +0200
Message-ID: <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
References: <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
 <51E83E32.9050306@cs.wisc.edu>
 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
 <20130719003034.GG28005@kernel.dk>
 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <51EAA33C.9010405@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51EAA33C.9010405@fusionio.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Christie <mchristie@fusionio.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 20, 2013 at 09:48:28AM -0500, Mike Christie wrote:
> What about the attached only compile tested patch. The patch has the mq
> block code work like the non mq code for bio cleanups.

Not sure if it is related to the patch or not, but it never returns from
wait_for_completion_io(&wait) in blkdev_issue_flush():

# ps axl | awk '$10 ~ /D\+/'
4     0   938   879  20   0 111216   656 blkdev D+   pts/1      0:00 fdisk/dev/sda
#
# cat /proc/938/stack
[<ffffffff812a8a5c>] blkdev_issue_flush+0xfc/0x160
[<ffffffff811ac606>] blkdev_fsync+0x96/0xc0
[<ffffffff811a2f4d>] do_fsync+0x5d/0x90
[<ffffffff811a3330>] SyS_fsync+0x10/0x20
[<ffffffff81611582>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

Any ideas?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
