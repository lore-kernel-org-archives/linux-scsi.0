From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/file: Add WRITE_SAME w/ UNMAP=0 emulation
 support
Date: Wed, 20 Feb 2013 12:32:56 -0800
Message-ID: <1361392376.3667.10.camel@haakon2.linux-iscsi.org>
References: <1361324623-17041-1-git-send-email-nab@linux-iscsi.org>
	 <51244031.5000302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <51244031.5000302@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Asias He <asias@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-02-20 at 11:17 +0800, Asias He wrote:
> On 02/20/2013 09:43 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi mkp, hch, & Co,
> > 
> > Please review this patch to add support for WRITE_SAME w/ UNMAP=0
> > emulation into FILEIO, as I'd really like to include this in the
> > upcoming for-3.9 target merge.
> > 
> > Thank you,
> > 
> > --nab
> > 
> > ---------------------------------------------------------------------
> > 
> > This patch adds support for emulation of WRITE_SAME w/ UNMAP=0 within
> > fd_execute_write_same() backend code.
> > 
> > The emulation uses vfs_writev() to submit a locally populated buffer
> > from the received WRITE_SAME scatterlist block for duplication, and by
> > default enforces a limit of max_write_same_len=0x1000 (8192) sectors up
> > to the limit of 1024 iovec entries for the single call to vfs_writev().
> > 
> > It also sets max_write_same_len to the operational default at setup ->
> > fd_configure_device() time.
> > 
> > Tested with 512, 1k, 2k, and 4k block_sizes.
> > 
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Asias He <asias@redhat.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_file.c |  115 +++++++++++++++++++++++++++++++++++++
> >  1 files changed, 115 insertions(+), 0 deletions(-)
> > 

<SNIP>

> > +
> > +static sense_reason_t
> > +fd_execute_write_same(struct se_cmd *cmd)
> > +{
> > +	struct se_device *se_dev = cmd->se_dev;
> > +	struct fd_dev *fd_dev = FD_DEV(se_dev);
> > +	struct file *f = fd_dev->fd_file;
> > +	struct scatterlist *sg;
> > +	struct iovec *iov;
> > +	mm_segment_t old_fs;
> > +	sector_t nolb = spc_get_write_same_sectors(cmd);
> > +	loff_t pos = cmd->t_task_lba * se_dev->dev_attrib.block_size;
> > +	unsigned int len, len_tmp, iov_num;
> > +	int i, rc;
> > +	unsigned char *buf;
> > +
> > +	if (!nolb) {
> > +		target_complete_cmd(cmd, SAM_STAT_GOOD);
> > +		return 0;
> > +	}
> > +	sg = &cmd->t_data_sg[0];
> > +
> > +	if (cmd->t_data_nents > 1 ||
> > +	    sg->length != cmd->se_dev->dev_attrib.block_size) {
> > +		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
> > +			" block_size: %u\n", cmd->t_data_nents, sg->length,
> > +			cmd->se_dev->dev_attrib.block_size);
> > +		return TCM_INVALID_CDB_FIELD;
> > +	}
> > +
> > +	len = len_tmp = nolb * se_dev->dev_attrib.block_size;
> > +	iov_num = DIV_ROUND_UP(len, PAGE_SIZE);
> > +
> > +	buf = fd_setup_write_same_buf(cmd, sg, len);
> > +	if (!buf)
> > +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> > +
> > +	iov = vmalloc(sizeof(struct iovec) * iov_num);
> > +	if (!iov) {
> > +		pr_err("Unable to allocate fd_execute_write_same iovecs\n");
> > +		kfree(buf);
> > +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> > +	}
> > +	memset(iov, 0, sizeof(struct iovec) * iov_num);
> 
> Use vzalloc()?

Of course..  Changed to vzalloc + dropped memset.

Thanks for reviewing!

--nab
