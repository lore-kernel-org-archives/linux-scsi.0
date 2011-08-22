From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use queuedata accessors for device handler
Date: Mon, 22 Aug 2011 17:31:15 +0200
Message-ID: <4E527643.601@suse.de>
References: <201108221335.p7MDZhBm013520@pentland.suse.de> <20110822144505.GA5705@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1HVPbR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 11:31:17 -0400
In-Reply-To: <20110822144505.GA5705@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@parallels.com>, linux-scsi@vger.kernel.org

On 08/22/2011 04:45 PM, Christoph Hellwig wrote:
> On Mon, Aug 22, 2011 at 03:35:43PM +0200, Hannes Reinecke wrote:
>>
>> Starting multipath on a cciss device will cause a kernel
>> warning to be triggered. Problem is that we're using the
>> ->queuedata field of the request_queue to dereference the
>> scsi device; however, for other (non-SCSI) devices this
>> points to a totally different structure.
>> So we should rather be using accessors here to make
>> sure ->queuedata points to a valid sdev.
>
> How do we match to attach a scsi device handler to a non-scsi queue?
> I suspect that is the fundamental issue that needs addressing.
>
We don't. SCSI device handler are only for SCSI devices, not block=20
devices. But scsi_dh_attach() and scsi_dh_detach() is called from=20
dm-mpath.c:parse_path(), and this doesn't have any idea about the=20
underlying device type.

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
