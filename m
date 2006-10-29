From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC] support for bidirectional transfers and variable length
 CDBs
Date: Sun, 29 Oct 2006 15:33:39 +0200
Message-ID: <4544ADB3.8050708@panasas.com>
References: <4541F822.70700@panasas.com> <20061028163609.GA17317@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:27849 "EHLO
	cassoulet.panasas.com") by vger.kernel.org with ESMTP
	id S965214AbWJ2NfK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Oct 2006 08:35:10 -0500
In-Reply-To: <20061028163609.GA17317@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Dalit Naor <DALIT@il.ibm.com>, Liran Schour <LIRANS@il.ibm.com>, Sami.Iren@seagate.com, Daniel.E.Messinger@seagate.com, stuart.brodsky@seagate.com, open-iscsi@googlegroups.com, Boaz Harrosh <bharrosh@panasas.com>

Christoph Hellwig wrote:
> On Fri, Oct 27, 2006 at 02:14:26PM +0200, Benny Halevy wrote:
>   
>> Hi,
>>
>> Attached are patches for linux-2.6.18, open-iscsi (2.0-711), and
>> ibm-osd-initiator (v3.1.1), sketching a proposal for supporting 
>> bi-directional
>> scsi commands and variable length CDBs.  The motivation behind this is
>> having an OSD stack in the kernel for the Object-based pNFS layout driver
>> in the linux kernel that we're working on with CITI.
>> (part of NFSv4.1, see also 
>> http://www.ietf.org/internet-drafts/draft-ietf-nfsv4-pnfs-obj-02.txt)
>>     
>
> Offtopic note:  unless you opensource all your filesystem code and merge
> into the kernel there's not chance we'll put in nfs hooks for you.  This
> doesn't affect the scsi bits though as we plan to have bidi commands
> for other reasons though (which doesn't mean it's legal to use for
> binary modules either)
>   
That's what the pnfs-over-objects layout driver is all about...
>   
>> The core changes we propose in the scsi layer to support bidi are:
>>  - adding struct scsi_cmnd_sgl for holding a mapping of the caller 
>> buffers as
>>    <use_sg, sglist_len, request_buffer, request_bufflen, request>
>>     
>
> I would rather call this scsi_data_buffer, but that's just a smallish thing.
> Having this as a separate stuct is a lot nicer than my previous proposal,
> though.
>   
cool, works for me.
>   
>>   - using it in struct scsi_cmnd to map the read buffer of 
>> bidirectional commands.
>>     for backward compatibility and to keep this patch minimalistic we 
>> kept the mapping
>>     of the uni-directional buffers as well as the write buffers of 
>> bi-directional transfers intact;
>>     in the future I think it will be cleaner to hold these in a 
>> scsi_cmnd_sgl of their own.
>>     
>
> This on the other hand is not very nice.  We should put an in and and an
> out scsi_data_buffer in struct scsi_cmnd.  As we need to revist this part
> of the scsi midlayer <-> LLDD interface anyway we plan to handle this
> change as part of the bigger overall transition.  Here are the helpers
> I had envisioned at storage summit in the version where they still
> translate to the currently existing code, but can be nicely adopted
> to bidi-capable versions with two sg lists:
>
> size_t scsi_dma_map(struct device *dev, struct scsi_cmnd *cmd)
> {
> 	ssize_t nseg = 0;
>
> 	if (cmd->use_sg) {
> 		struct scatterlist *sg =
> 			(struct scatterlist *) cmd->request_buffer;
>
> 		nseg = dma_map_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
> 		if (unlikely(!nseg))
> 			return -ENOMEM;
> 	}
>
> 	return nseg;
> }
>
> void scsi_dma_unmap(struct device *dev, struct scsi_cmnd *cmd)
> {
> 	if (cmd->use_sg) {
> 		struct scatterlist *sg =
> 			(struct scatterlist *) cmd->request_buffer;
> 		dma_unmap_sg(dev, sg, cmd->use_sg, cmd->sc_data_direction);
> 	}
> }
>
>
> and something similar for pio / virtual drivers.  Note that the
> above doesn't handle non-sg commands - we still have one user of them
> in the error handler, but I'll finally submit the patch to remove it
> soon.  Also note that actually bidi-capable driver still will have
> to opencode the map and know about the two data buffers.  I expect
> driver actually handling bidi commands to be the absolute minority,
> though.
>   
I'm not sure I understand exactly when these helpers are to be used.
Can you point me at more info please?
Does this solve the dependency of scsi on struct request for buffer mapping?
(i.e. will this be used in the scsi_init_io() path instead of calling 
blk_rq_map_kern()
or the calls to the block layer in scsi_merge_bio()?)

>   
>>  - allocate another struct request when executing a bidirectional 
>> command and use it to map the bidi read
>>    buffer (or sglist).  keep a pointer to it in the scsi_io_context.
>>     
>
> That's also not the way to go ahead - struct request should support
> bidi commands the same way scsi should.  I'd rather finish the scsi
> bits first, and until that is done your approach might be fine for
> (out of tree) debugging.
>   
work for me
>   
>> Core changes proposed to support variable length CDBs:
>>     
>
> This should be an entirely separate patch.  (As should your updates to
> the list of scsi device types and the typo fix in a comment in your
> patch)  I haven't looked at this code in detail but it looks rather
> messy already ;-)  I'd prefer if we could postponed implementing this
> properly until we've landed bidi support.
>   
ok
>   
>>   - API crafted in the spirit of scsi_execute_async and is a super set of
>>     scsi_execute and scsi_execute_async (i.e. the varlen cdb and 
>> bidi_read_buff
>>     are optional)
>>     
>
> We might aswell change scsi_execute_async to just support bidi and varlen
> commands in the end.  There's very few user and having yet another API
> to submit scsi commands doesn't sound very helpfull.
>   
cool.  and what about scsi_execute?  are you ok with changing it too or 
would you
rather add a new synchronous API call for bidi. The reason I'm asking is 
that
it doesn't currently allocate a scsi_io_context and therefore it's more 
efficient
than the async api.
>   
>>  - use two scsi_cmnd_sgl's in struct scsi_cmnd to map uni/bidi_write 
>> buffers and bidi_read buffers
>>    respectively (or alternatively use one to map write buffers and the 
>> other to map read buffers, this
>>    doesn't matter much id everybody uses scsi_get_{in,out,uni}_buff() 
>> rather than dereferencing
>>    a scsi_cmnd pointer to get to the fields.
>>
>>  - support bidi in struct request.  This will save allocating yet 
>> another request for mapping the
>>    bidi_read buffers
>>     
>
> As per comments above I think we should do this from the beginning.
>
> As for the further todo I'd suggest the following:
>
>  - I submit the patch to get rid of the remaining non-sg I/O ASAP
>  - you submit your patch to add the osd type and the addition device
>    type descriptions
>  - you submit your patch that fixes the scsi_execute comment typo
>  - you submit your patch to add the VARLEN_CDB opcode
>  - you start converting as many as possible drivers to the
>    above wrapper API (I already had a big FC card vendor signed up
>    for this, but no updates so far..)
>   
fine with me, if ok with them too, please send them my way so they can send
us whatever they've done already.
>  
>  And then once we have almost all direct references to the request_buffer
>  & friends gone you submit a new bidi patch based on the comments in this
>  mail.
>   
sounds like a plan!
> Thanks for working on this.
>   
you're welcome, my pleasure...
(especially after the much needed cleanup in 2.6.18 :)

