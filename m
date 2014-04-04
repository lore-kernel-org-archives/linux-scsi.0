From: Hannes Reinecke <hare@suse.de>
Subject: Re: EH method APIs
Date: Fri, 04 Apr 2014 09:17:21 +0200
Message-ID: <533E5C81.60409@suse.de>
References: <20140404070408.GA30326@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaDDHRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2014 03:17:24 -0400
In-Reply-To: <20140404070408.GA30326@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 04/04/2014 09:04 AM, Christoph Hellwig wrote:
> One think I noticed when doing the SCSI MQ work is that our EH method
> signature are starting to really get into the way by passing a scsi_c=
mnd
> as the only argument.  While we'll obviously need the command we want
> to abort for eh_abort the resets aren't command specific at all and
> passing the command doesn't seem too helpful in general.
>=20
> There's two specific reasons why it's getting in it's way:
>=20
>  - With the cmd_size field in the host template we can now allocate
>    driver specific data as part of the scsi_cmnd, but we'll usually
>    still need driver specific data to do the actual error handling.
>    The virtio_scsi driver conversion I posted is a good example of th=
at.
>  - The scsi_reset_provider situation is getting worse: this fakes up
>    a request on stack, then allocates a scsi_command which doesn't ge=
t
>    fully set up and points to it and calls the eh_reset* methods on i=
t.
>    For now we can keep doing that even with blk-mq, but if we eventua=
lly
>    want to remove the old code we need a way to fake up the request/c=
mnd
>    combo.  Even until then drivers get a command that subtly differen=
t
>    from normal ones from scsi_reset_provider in the old code case, an=
d
>    even more subtly different for scsi-mq.
>=20
> I wonder if we should start adding new methods that pass a tmf contex=
t
> soon.  I think Hannes was looking into EH methods that match the SAM
> error handling concepts better anyway, so this might be a good synerg=
y.
>=20
My next step for the EH updates would be to get rid of the annoying
'holding on to the original scmd until my last breath' strategy.

Plan here is to allocate a dedicated EH command which then could be
used to send the SCSI commands during EH.
This would allow use to return the original command as soon as we've
entered SCSI EH. Of course this will trigger a retry, but EH will
block command submission until it is done.
Thereby we should be having much the same behaviour as we have now,
with the marked difference that control of the command is now being
passed back to the block layer during SCSI EH.
This allows for a much saner request handling, and allows things
like multipathing to work far better even when EH is running.
_And_ we can basically terminate SCSI EH at any time as no commands
are pending within the SCSI midlayer anymore.

Plus we don't meddle with block request allocation intrinsics
anymore; the SCSI EH command is allocate within the SCSI midlayer,
and requests originating from the block layer won't be messed with.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
