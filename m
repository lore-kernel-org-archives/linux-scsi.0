From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 6/9] tgt: convert ibmvstgt and libsrp to use
 scsi_data_buffer
Date: Sun, 9 Sep 2007 23:38:55 +0900
Message-ID: <20070909054929C.tomof@acm.org>
References: <46E3C6F3.6020506@panasas.com>
	<20070909045722P.tomof@acm.org>
	<46E40319.4030704@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60759 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933AbXIIOjv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Sep 2007 10:39:51 -0400
In-Reply-To: <46E40319.4030704@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Sun, 09 Sep 2007 17:28:41 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Sun, Sep 09 2007 at 16:47 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> > On Sun, 09 Sep 2007 13:12:03 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> On Fri, Sep 07 2007 at 0:50 +0300, FUJITA Tomonori <tomof@acm.org> wrote:
> >>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >>> ---
> >>> ...
> >>> @@ -425,8 +426,8 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
> >>>  
> >>>  	sc->SCp.ptr = info;
> >>>  	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
> >>> -	sc->request_bufflen = len;
> >>> -	sc->request_buffer = (void *) (unsigned long) addr;
> >>> +	sc->sdb.length = len;
> >>> +	sc->sdb.sglist = (void *) (unsigned long) addr;
> >>>  	sc->tag = tag;
> >>>  	err = scsi_tgt_queue_command(sc, (struct scsi_lun *) &cmd->lun, cmd->tag);
> >>>  	if (err)
> >> What is done here in srp_cmd_queue() looks scary to me. even today.
> >> What is that u64 addr that gets truncated to unsigned long and put
> >> on sglist? What data-buffer "len" is suppose to describe? And "dir"
> >> is for what data?
> > 
> > No trancated since it's used for an address. addr, data length, and
> > data transfer direction though they are not used now.
> > 
> I wish you could maybe clean up the unused stuff,

Well, I put them for Xen scsiback driver though now I could remove it.


> and/or give addr its proper type. If it's a pointer than make it a
> pointer.

You need to read the SRP spec.


> Also you are implying a use_sg==0 here which is not allowed.
> 
> > 
> >> It is made to look like addr is a linear pointer with a use_sg==0
> >> issued command, which is no longer allowed. Only we know it is not,
> >> because of the "(void *)(unsigned long) addr;" which is a bug in
> >> 64-bit.
> >>
> >> If this is a totally private message sent threw the scsi-ml. I would
> >> rather it was done with DMA_NONE,bufflen=0,sglist=NULL and put all
> >> the user-info into scsi_cmnd.SCp like above "void* info".
> > 
> > tgt doesn't queue a command to scsi-ml. It queues it to user space.
> 
> Even though. Please don't misuse scsi_cmnd members in this way.
> If you are not using any of scsi-ml functions on these commands and
> they do not carry sg-lists than why use a scsi_cmnd at all?

We try to use scsi-ml and transport class as much as possible.


> You can just use a tgt private structure.

And we don't try to do this.


> If these commands do go through some scsi-ml functions than banging
> scsi_cmnd.sdb.sglist this way is dangerous.

As I said, these commands will not go to scsi-ml in a way as you
think.
