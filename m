From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Remove 'unhandled error code' messages
Date: Thu, 10 Nov 2011 16:18:57 +0100
Message-ID: <4EBBEB61.1090903@suse.de>
References: <1320934327-8384-1-git-send-email-hare@suse.de> <1320936918.3040.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935118Ab1KJPS6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2011 10:18:58 -0500
In-Reply-To: <1320936918.3040.1.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 11/10/2011 03:55 PM, James Bottomley wrote:
> On Thu, 2011-11-10 at 15:12 +0100, Hannes Reinecke wrote:
>> scsi_io_completion() tries to take some action based on
>> the command result and sense code. It also displays
>> 'unhandled error code' or 'unhandled sense code' in case
>> no special handling was found.
>> This serves as an additional source of confusion to
>> the unsuspecting user, as the message in fact means
>> 'everything okay, no special casing required',
>> and not 'oh gosh, something has happened and the system
>> couldn't deal with it'.
>
> It means we're just about to fail the command with an error.  That's =
not
> really an everything ok case.
>
> Sometimes, you're right, this is the correct thing to do silently, bu=
t
> often it's not.  So, same question to you as to Rob: What are the
> circumstances you want silent failure for and can you special case th=
em?
>
The whole point here is: It's not silent, even when the=20
'description' is not set.

	switch (action) {
	case ACTION_FAIL:
		/* Give up and fail the remainder of the request */
		scsi_release_buffers(cmd);
		if (!(req->cmd_flags & REQ_QUIET)) {
			if (description)
				scmd_printk(KERN_INFO, cmd, "%s\n",
					    description);
			scsi_print_result(cmd);
			if (driver_byte(result) & DRIVER_SENSE)
				scsi_print_sense("", cmd);
			scsi_print_command(cmd);
		}
		if (blk_end_request_err(req, error))
			scsi_requeue_command(q, cmd);
		else
			scsi_next_command(cmd);
		break;

So the decoded result and sense code is printed always, regardless=20
of the 'description'.
The 'description' just tells us if there are special
circumstances. And as we didn't do anything special
we should print anything here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
