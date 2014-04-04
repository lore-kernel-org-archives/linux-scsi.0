From: Hannes Reinecke <hare@suse.de>
Subject: Re: EH method APIs
Date: Fri, 04 Apr 2014 09:36:54 +0200
Message-ID: <533E6116.2090206@suse.de>
References: <20140404070408.GA30326@infradead.org> <533E5C81.60409@suse.de> <20140404072400.GA23630@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaDDHg4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2014 03:36:56 -0400
In-Reply-To: <20140404072400.GA23630@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On 04/04/2014 09:24 AM, Christoph Hellwig wrote:
> On Fri, Apr 04, 2014 at 09:17:21AM +0200, Hannes Reinecke wrote:
>> Plus we don't meddle with block request allocation intrinsics
>> anymore; the SCSI EH command is allocate within the SCSI midlayer,
>> and requests originating from the block layer won't be messed with.
>=20
> Any chance we could also switch to a new scsi_tmf structure instead
> of reusing struct scsi_cmnd for that?  It should be a lot smaller
> without all the baggage, and make it clear we're not dealing with a
> command.  That would also solve the scsi_reset_provide issue.
>=20
Have to look into this. Problem is that some eh_XXX callback
implementations actually are using the command to send the TMF;
will need to look into them how and if they could be changed.

Actually, alongside with that change I would update the arguments
to the callback functions to align with the strategy level;
eh_device_reset() would be getting struct scsi_device as argument,
eh_target_reset() would get getting struct scsi_target as argument etc.

So the actual SCSI EH would not be tied to struct scsi_cmnd, and we
would just be needing something to send TUR etc in the course of
SCSI EH. Whether that needs to be a struct scsi_cmnd or something
else can discussed.

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
