From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] scsi: Implement 'ZBC' device type
Date: Mon, 02 Jun 2014 10:46:35 +0200
Message-ID: <538C39EB.90109@suse.de>
References: <1401692478-23557-1-git-send-email-hare@suse.de> <1401692478-23557-4-git-send-email-hare@suse.de> <20140602083919.GA31170@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaFBIqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2014 04:46:36 -0400
In-Reply-To: <20140602083919.GA31170@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 06/02/2014 10:39 AM, Christoph Hellwig wrote:
> On Mon, Jun 02, 2014 at 09:01:18AM +0200, Hannes Reinecke wrote:
>> ZBC (zoned block command aka 'SMR drives') devices will have
>> a new device type 0x14 assigned by T10. So add the necessary
>> mappings to sd.c and make it an alias for ATA ZAC devices.
>
> The libata changes should defintively be a separate one, the sd chang=
es
> probably as well.
>
> But I'm uneasy with adding anything like this for now, for one the sp=
ecs
> aren't even anywhere close to done, and second attaching ZBC devices
> in general doesn't sound like a very smart idea, we really need a
> strategy for the sequential required zones first.
>
In theory, yes.

In practice, however, ZAC drives will show up a normal ATA devices=20
without that patch. Which is leading to even more trouble.
So with this patch we're at least signalling to the user that=20
something odd might happen.

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
