From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Thu, 20 Oct 2016 14:39:28 -0400
Message-ID: <1476988768.3094.55.camel@HansenPartnership.com>
References: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
         <1476422360.22309.29.camel@linux.vnet.ibm.com>
         <87y41nhrv1.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35530 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933511AbcJTSjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Oct 2016 14:39:35 -0400
In-Reply-To: <87y41nhrv1.fsf@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Mon, 2016-10-17 at 14:17 -0200, Gabriel Krisman Bertazi wrote:
> James Bottomley <jejb@linux.vnet.ibm.com> writes:
> 
> > On Thu, 2016-10-13 at 15:47 -0300, Gabriel Krisman Bertazi wrote:
> > > @@ -210,6 +219,13 @@ int scsi_execute(struct scsi_device *sdev,
> > > const
> > > unsigned char *cmd,
> > >  	 */
> > >  	blk_execute_rq(req->q, NULL, req, 1);
> > >  
> > > +	if (scsi_sense_unit_attention(sense) && req->retries >
> > > 0) {
> > > +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> > > +		retries = req->retries - 1;
> > > +		blk_put_request(req);
> > > +		goto retry;
> > > +	}
> > 
> > OK, so this is more theory, but I think you can actually reuse the
> > same
> > request to go around this loop without doing a get/put.  I've cc'd
> > Jens
> > to confirm, since no other driver I can find does this, but if it's
> > legal, it saves freeing and reallocating the request.  You can then
> > replace the goto with a do { } while (...) which makes the loop
> > obvious
> > to the next person looking at this.
> 
> Hi James,
> 
> I don't think the block layer currently has the machinery to reuse 
> the request.  I think it would be easy to add for the MQ case but I
> don't know about SQ.  If we don't clean up or reinit the request 
> before re-sending, we'll hit the BUG_ON in blk_start_request:
> 
>   BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
> 
> Do you wanna take a v3 of the patch and fix this on a future patch, 


That works.  I certainly believe, looking at the code, that we can
reuse the request, but in the absence from confirmation from Jens I'm
certainly not going to insist on it.

James

> or should I be looking into patching the block layer interface?  I'll
> be looking into it, but I need to get familiar with the SQ code
> first.



