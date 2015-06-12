From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: retry MODE SENSE on unit attention
Date: Fri, 12 Jun 2015 10:08:25 -0400
Message-ID: <1434118105.22842.8.camel@localhost.localdomain>
References: <1434020506-41897-1-git-send-email-hare@suse.de>
	 <1434035231.27387.111.camel@localhost.localdomain>
	 <557A7BD3.7040607@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbFLOI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 10:08:27 -0400
In-Reply-To: <557A7BD3.7040607@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>

On Fri, 2015-06-12 at 08:27 +0200, Hannes Reinecke wrote:
> On 06/11/2015 05:07 PM, Ewan Milne wrote:
> > On Thu, 2015-06-11 at 13:01 +0200, Hannes Reinecke wrote:
> >> The 'sd' driver is calling scsi_mode_sense() to figure out
> >> internal details. But scsi_mode_sense() never checks for
> >> any pending unit attentions, so we're getting annoying error
> >> messages like:
> >>
> >> MODE SENSE: unimplemented page/subpage: 0x00/0x00
> >>
> >> and a possible wrong decision for device cache handling.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  drivers/scsi/scsi_lib.c | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >> index 2428d96..d7915c8 100644
> >> --- a/drivers/scsi/scsi_lib.c
> >> +++ b/drivers/scsi/scsi_lib.c
> >> @@ -2423,7 +2423,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
> >>  	unsigned char cmd[12];
> >>  	int use_10_for_ms;
> >>  	int header_length;
> >> -	int result;
> >> +	int result, retry_count = retries;
> >>  	struct scsi_sense_hdr my_sshdr;
> >>  
> >>  	memset(data, 0, sizeof(*data));
> >> @@ -2502,6 +2502,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
> >>  			data->block_descriptor_length = buffer[3];
> >>  		}
> >>  		data->header_length = header_length;
> >> +	} else if ((status_byte(result) == CHECK_CONDITION) &&
> >> +		   scsi_sense_valid(sshdr) &&
> >> +		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
> >> +		retry_count--;
> >> +		goto retry;
> >>  	}
> >>  
> >>  	return result;
> > 
> > Great, but shouldn't we be doing this more generally?  What about
> > scsi_mode_select()?
> > 
> I haven't seen any issues with scsi_mode_select() as of now, so I
> didn't do anything about this :-)
> 
> > (And, with the number of status changes that can get reported by
> >  UAs, we might want to think about increasing the retry count on
> >  these commands up from 3 at some point.)
> > 
> Hmm. _Actually_, we're not getting _more_ UAs (neither the number
> nor the situation at which UAs are being send has changed).
> It's just that we're trying to _use_ UAs so these things pop up.
> But yeah, raising the number or retries to eg 5 is probably a good idea.

Yeah, or maybe add a time limit to we don't drag out the boot time.
We can do this later, though, I'm fine with your patch as it is.

> 
> > Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> > 
> Cheers,
> 
> Hannes


