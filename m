From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Getting TRIM working
Date: Sun, 08 Mar 2009 19:38:03 +0200
Message-ID: <49B4027B.9080301@panasas.com>
References: <20090303190700.GD20511@parisc-linux.org> <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org> <49B39DCB.3040203@panasas.com> <20090308165447.GN25995@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:20088 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751647AbZCHRiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2009 13:38:51 -0400
In-Reply-To: <20090308165447.GN25995@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>

Matthew Wilcox wrote:
> On Sun, Mar 08, 2009 at 12:28:27PM +0200, Boaz Harrosh wrote:
>> That's because you are doing it at the wrong level at the wrong stage.
>> 1. block-level submits a request
>> 2. sd/sr or what ever ULD prepares a scsi_cmnd out of request.
>>    Request's sizes are only a recommendation. ULD or scsi-ml may
>>    prepare a smaller command then request. Once command is prepared
>>    request is disregarded, you can bang on it all you want code will
>>    not care about it one bit.
> 
> I may well be changing more than I need to, but it would be foolish of
> me to make the assumption at this point that nothing is looking at the
> request.
> 
>> 3. LLD executes the scsi-command (Not the block-request)
> 
> This is true, *but* some of the lengths in the block request still end
> up getting used, for example bv_len is used by blk_rq_map_sg() which is
> called by the LLD.
> 

I must be running but... What? blk_rq_map_sg() is called by scsi-ml in prep_command
when allocating and setting up SGs (scsi_sglist())

If called by LLD then it's the first I've herd of, and some assumptions at scsi-ml
surly break.

This is exactly stage (2) the call to blk_rq_map_sg(), from there on request is
ignored.

>> 4. scsi-ml completes command's bytes, at this stage the request might
>>    not be over and, and a reminder is re-prepared so the request can
>>    be complete.
>>
>> The code above scmd->sdb.length = req->data_len = size; is not allowed
>> and can cause data leaks.
> 
> Simply not true.  We are *changing the amount of data we wish to
> transfer*.  SCSI would have sent down 24 bytes of data.  ATA needs to
> send down 512 bytes of data.
> 

That's what you want but you can't do that after stage 2.

>> You should ping Tejun, block-layer(1) and ATA-LLD(3) has a way to communicate
>> alignments and drain buffers that expose some other possible lenght's to ata.
>>
>> And to your question the missing length above is probably encoded inside the
>> submitted CDB. (scsi_cmnd->cmnd). When you change the length before
>> stage (2) it works.
> 
> No, that's not it.  This works (in sd.c):
> 
>         if (bio_add_pc_page(q, bio, page, 512, 0) < 512) {
> [...]
>         rq->cmd_type = REQ_TYPE_BLOCK_PC;
> 	rq->cmd_len = 10;
> 	rq->cmd[0] = UNMAP;
> 	put_unaligned_be16(24, rq->cmd + 7);
> 
> So the 24 in the cmd gets ignored.
> 
>> I think you should be using the drain mechanisms built into ata 
> 
> drain seems only applicable to ATAPI, not to ATA.  The comment says:
> 
>  *      ATAPI commands which transfer variable length data to host
>  *      might overflow due to application error or hardare bug.  This
>  *      function checks whether overflow should be drained and ignored
>  *      for @request.
> 
> This isn't the case with discard/UNMAP/TRIM.  We know exactly how much
> data we want to send.  The problem is that I don't know how to update all
> the required places to change the amount of data being sent.  I don't
> see any other ATA command which needs to do this, so this is breaking
> new ground for libata-scsi.
> 

You must do the change before/during stage 2 above. (length get encoded inside
scsi_sglist()).

Sorry I must be running. If you have a public git with this stuff
I can have a look tomorrow, or send a .diff I'll apply locally and
inspect it.

bye
Boaz

