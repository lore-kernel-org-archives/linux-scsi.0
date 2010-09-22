From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm/fileio: Convert to iov allocations for
	fd_do_readv() and fd_do_writev()
Date: Wed, 22 Sep 2010 04:58:38 -0700
Message-ID: <1285156718.1849.63.camel@haakon2.linux-iscsi.org>
References: <1285142558-13219-1-git-send-email-nab@linux-iscsi.org>
	 <4C99E7D6.1040004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C99E7D6.1040004@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Fubo Chen <fubo.chen@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-22 at 13:26 +0200, Boaz Harrosh wrote:
> On 09/22/2010 10:02 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greetings all,
> > 
> > This patch converts target_core_file.c fd_do_readv() and fd_do_writev() code to
> > use dynamic allocation for *iov[] instead of local scope static memory to
> > properly handle cases with TCM_Loop that can potentially exceed the 8K stack
> > on 64-bit kernels with per 1:1 struct scatterlist <-> 512-byte block_size SGL length
> > mapping up to the current FD_MAX_SECTORS=1024.  For more information please see:
> > 
> > http://lkml.org/lkml/2010/9/22/42
> > 
> > Many thanks to Fubo Chen for spotting this one!
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_file.c |   20 ++++++++++++++++----
> >  1 files changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> > index 221b41e..93d3f63 100644
> > --- a/drivers/target/target_core_file.c
> > +++ b/drivers/target/target_core_file.c
> > @@ -476,12 +476,16 @@ static int fd_do_readv(struct fd_request *req, struct se_task *task)
> >  {
> >  	struct file *fd = req->fd_dev->fd_file;
> >  	struct scatterlist *sg = task->task_sg;
> > -	struct iovec iov[req->fd_sg_count];
> > +	struct iovec *iov;
> >  	mm_segment_t old_fs;
> >  	loff_t pos = (req->fd_lba * DEV_ATTRIB(task->se_dev)->block_size);
> >  	int ret = 0, i;
> >  
> > -	memset(iov, 0, sizeof(struct iovec) * req->fd_sg_count);
> > +	iov = kzalloc(sizeof(struct iovec) * req->fd_sg_count, GFP_KERNEL);
> 
> A kzalloc allocation bigger then PAG_SIZE is very unstable, more so when
> the system is up for a long time.
> 
> Better prepare to loop here, up to PAG_SIZE iov at a time.
> 

Hmmm, good point for the extreme TCM_Loop single 512-byte block per SGL
case.  Looks like we need to split up the struct iovec mappings for
FILEIO into multiple allocations in fd_do_readv() and fd_do_writev()..?

Best,

--nab
