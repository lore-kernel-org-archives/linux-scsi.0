From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Getting TRIM working
Date: Sun, 8 Mar 2009 10:54:47 -0600
Message-ID: <20090308165447.GN25995@parisc-linux.org>
References: <20090303190700.GD20511@parisc-linux.org> <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org> <49B39DCB.3040203@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49B39DCB.3040203@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Mar 08, 2009 at 12:28:27PM +0200, Boaz Harrosh wrote:
> That's because you are doing it at the wrong level at the wrong stage.
> 1. block-level submits a request
> 2. sd/sr or what ever ULD prepares a scsi_cmnd out of request.
>    Request's sizes are only a recommendation. ULD or scsi-ml may
>    prepare a smaller command then request. Once command is prepared
>    request is disregarded, you can bang on it all you want code will
>    not care about it one bit.

I may well be changing more than I need to, but it would be foolish of
me to make the assumption at this point that nothing is looking at the
request.

> 3. LLD executes the scsi-command (Not the block-request)

This is true, *but* some of the lengths in the block request still end
up getting used, for example bv_len is used by blk_rq_map_sg() which is
called by the LLD.

> 4. scsi-ml completes command's bytes, at this stage the request might
>    not be over and, and a reminder is re-prepared so the request can
>    be complete.
> 
> The code above scmd->sdb.length = req->data_len = size; is not allowed
> and can cause data leaks.

Simply not true.  We are *changing the amount of data we wish to
transfer*.  SCSI would have sent down 24 bytes of data.  ATA needs to
send down 512 bytes of data.

> You should ping Tejun, block-layer(1) and ATA-LLD(3) has a way to communicate
> alignments and drain buffers that expose some other possible lenght's to ata.
> 
> And to your question the missing length above is probably encoded inside the
> submitted CDB. (scsi_cmnd->cmnd). When you change the length before
> stage (2) it works.

No, that's not it.  This works (in sd.c):

        if (bio_add_pc_page(q, bio, page, 512, 0) < 512) {
[...]
        rq->cmd_type = REQ_TYPE_BLOCK_PC;
	rq->cmd_len = 10;
	rq->cmd[0] = UNMAP;
	put_unaligned_be16(24, rq->cmd + 7);

So the 24 in the cmd gets ignored.

> I think you should be using the drain mechanisms built into ata 

drain seems only applicable to ATAPI, not to ATA.  The comment says:

 *      ATAPI commands which transfer variable length data to host
 *      might overflow due to application error or hardare bug.  This
 *      function checks whether overflow should be drained and ignored
 *      for @request.

This isn't the case with discard/UNMAP/TRIM.  We know exactly how much
data we want to send.  The problem is that I don't know how to update all
the required places to change the amount of data being sent.  I don't
see any other ATA command which needs to do this, so this is breaking
new ground for libata-scsi.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
