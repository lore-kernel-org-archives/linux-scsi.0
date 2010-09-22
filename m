From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 15/22] tcm: Add FILEIO subsystem plugin
Date: Wed, 22 Sep 2010 00:29:26 -0700
Message-ID: <1285140566.1849.27.camel@haakon2.linux-iscsi.org>
References: <1283160144-6848-1-git-send-email-nab@linux-iscsi.org>
	 <AANLkTimPh+SNroYoavomwVtQ5UHsr7Lsq_229Vkbc1CB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:24824 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753016Ab0IVHdn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2010 03:33:43 -0400
In-Reply-To: <AANLkTimPh+SNroYoavomwVtQ5UHsr7Lsq_229Vkbc1CB@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, 2010-09-20 at 18:18 +0200, Fubo Chen wrote:
> On Mon, Aug 30, 2010 at 11:22 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds the O_SYNC FILEIO subsystem plugin for accessing struct file
> > using Linux/VFS struct file_operations.  It also includes WriteCache and FUA
> > Write Emulation support to struct file using fs/sync.c/vfs_fsync_range()
> >
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> >
> > [ ... ]
> >
> > +static int fd_do_writev(struct fd_request *req, struct se_task *task)
> > +{
> > +       struct file *fd = req->fd_dev->fd_file;
> > +       struct scatterlist *sg = task->task_sg;
> > +       struct iovec iov[req->fd_sg_count];
> 
> Kernel stack size is 8 KB. On a 64-bit system struct iovec takes 16
> bytes. What happens if req->fd_sg_count is large ? Kernel crash ?
> 

Greetings Fubo,

So wrt to a potential 8K stack over here for the local scope iov[]
arrays in fd_do_writev() and fd_do_read()..

Currently target_core_file.h defines a FD_MAX_SECTORS of 1024, which
means that each struct se_task *task here will be containing at most a
1024 sector request.

In scatterlist terms for a TCM fabric module like LIO-Target that does
1:1 struct scatterlist w/ PAGE_SIZE allocations, this would be:

	((1024 * block_size) / PAGE_SIZE) * sizeof(struct iovec);

which for 64-bit uses 2048 bytes of stack for a FD_MAX_SECTORS task.

For a fabric module like TCM_Loop that maps incoming Linux/SCSI
scatterlist memory to internal TCM memory points and down to FILEIO
code, the maximum here is a scatterlist + offset for every block_size
sector for certain cases like mkfs* and friends, which means:

	((1024 * block_size) / block_size) * sizeof(struct iovec);

which for 64-bit uses 16384 bytes for a FD_MAX_SECTORS task with a
scatterlist entry per 512-byte logical block.

For at least for the latter case this is a problem with 8K stacks, so it
looks these will need to convert to dynamic allocation within the local
scope.  I will push a patch to fix this shortly.

Many thanks for your astute observation!

--nab


