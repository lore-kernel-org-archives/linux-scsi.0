From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/15] SCSI XCOPY support for the kernel and device mapper
Date: Thu, 28 Aug 2014 17:37:19 -0400
Message-ID: <20140828213719.GA3734@redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 15 2014 at  3:34pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This patch series makes it possible to use SCSI XCOPY offload for the 
> block layer and device mapper.
> 
> It is based on Martin Petersen's work
> https://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=xcopy&id=0bdeed274e16b3038a851552188512071974eea8,
> but it is changed significantly so that it is possible to propagate XCOPY
> bios through the device mapper stack.
> 
> The basic architecture is this: in the function blkdev_issue_copy we
> create two bios, one for read and one for write (with bi_rw READ|REQ_COPY
> and WRITE|REQ_COPY). Both bios have a pointer to the same bio_copy
> structure. These two bios travel independently through the device mapper
> stack - each bio can go through different device mapper devices. When both
> the bios reach the physical block device (in the function blk_queue_bio)
> the bio pair is collected and a XCOPY request is allocated and sent to the
> scsi disk driver.
> 
> Note that because device mapper mapping can dynamically change, there no
> guarantee that the XCOPY command succeeds. If it ends with an error, the
> caller is supposed to perform the copying manually.
> 
> The dm-kcopyd subsystem is modified to use the XCOPY command, so device
> mapper targets that use it (mirror, snapshot, thin, cache) take advantage
> of copy offload automatically.
> 
> There is a new ioctl BLKCOPY that makes it possible to use copy offload
> from userspace.

Hi Martin (and others on linux-scsi),

It would be ideal for XCOPY support to make its way upstream for
3.18.. but the window for staging this work in time is closing.

Any chance you might have some time to review Mikulas' revised approach
to your initial XCOPY support?
