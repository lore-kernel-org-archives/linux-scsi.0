From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Tue, 10 Jun 2014 15:01:30 +0000
Message-ID: <1402412490.2185.26.camel@dabdike.int.hansenpartnership.com>
References: <1401785937-43581-1-git-send-email-hare@suse.de>
		 <1401785937-43581-7-git-send-email-hare@suse.de>
	 <5396EE0C.3070108@acm.org>
	 <1402409172.2185.3.camel@dabdike.int.hansenpartnership.com>
	 <53971AD5.308@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:40506 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaFJPBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 11:01:33 -0400
In-Reply-To: <53971AD5.308@acm.org>
Content-Language: en-US
Content-ID: <86A089C2F40DF243B95135E73B6DD5A7@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "emilne@redhat.com" <emilne@redhat.com>, "hare@suse.de" <hare@suse.de>

On Tue, 2014-06-10 at 16:48 +0200, Bart Van Assche wrote:
> On 06/10/14 16:06, James Bottomley wrote:
> > On Tue, 2014-06-10 at 13:37 +0200, Bart Van Assche wrote:
> >> On 06/03/14 10:58, Hannes Reinecke wrote:
> >>> + *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
> >>> + *     returns the integer: 0x0b03d204
> >>> + *
> >>> + *     This encoding will return a standard integer LUN for LUNs smaller
> >>> + *     than 256, which typically use a single level LUN structure with
> >>> + *     addressing method 0.
> >>>   **/
> >>>  u64 scsilun_to_int(struct scsi_lun *scsilun)
> >>>  {
> >>> @@ -1279,7 +1280,7 @@ u64 scsilun_to_int(struct scsi_lun *scsilun)
> >>>  
> >>>  	lun = 0;
> >>>  	for (i = 0; i < sizeof(lun); i += 2)
> >>> -		lun = lun | (((scsilun->scsi_lun[i] << 8) |
> >>> +		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) *8)) |
> >>>  			      scsilun->scsi_lun[i + 1]) << (i * 8));
> >>>  	return lun;
> >>>  }
> >>
> >> The above code doesn't match the comment header. Parentheses have been
> >> placed such that each byte with an even index is shifted left (2*i+1)*8
> >> bits instead of (i+1)*8.
> > 
> > I don't see that in the code, which parentheses do you mean?
> 
> This patch should change the code into what I think was intended by the
> comment above scsilun_to_int():
> 
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1280,8 +1280,8 @@ u64 scsilun_to_int(struct scsi_lun *scsilun)
>  
>  	lun = 0;
>  	for (i = 0; i < sizeof(lun); i += 2)
> -		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) *8)) |
> -			      scsilun->scsi_lun[i + 1]) << (i * 8));
> +		lun = lun | (((u64)scsilun->scsi_lun[i] << ((i + 1) *8)) |
> +			     ((u64)scsilun->scsi_lun[i + 1] << (i * 8)));
>  	return lun;
>  }
>  EXPORT_SYMBOL(scsilun_to_int);

So this is nothing to do with a wrong 2*i+1 step, which was your initial
complaint?  Now it's an arithmetic conversion problem (which looks
reasonable: on 32 bits, we'll do the shift at the natural size, which is
u32, so we'll overshift for i>4.  If we're using sizeof(lun) in the for
loop, the converter should probably be typeof(lun) for consistency).

I don't see your second set of brackets being necessary bitwise or is
one of the lowest precedence non-logical operators; certainly it's lower
than shift:

http://en.cppreference.com/w/c/language/operator_precedence

James

