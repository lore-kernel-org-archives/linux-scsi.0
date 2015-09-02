From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 2 Sep 2015 10:48:36 +0200
Message-ID: <55E6B7E4.7010308@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-20-git-send-email-hare@suse.de>
 <20150901111517.GB10589@lst.de> <55E5A0D5.5070402@suse.de>
 <20150902063927.GA13399@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbbIBIsk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Sep 2015 04:48:40 -0400
In-Reply-To: <20150902063927.GA13399@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Todd Gill <tgill@redhat.com>

On 09/02/2015 08:39 AM, Christoph Hellwig wrote:
> On Tue, Sep 01, 2015 at 02:57:57PM +0200, Hannes Reinecke wrote:
>> That is what I'm eventually planning to do.
>> My final goal is to move the multipath path monitoring stuff
>> into the kernel (via the block device polling mechanism), and sendin=
g
>> block events for path failure and re-establishment.
>=20
> It might be a good idea to prioritize that.  Todd has been asking
> for multipath monitoring APIs and suggested adding D-BUS APIs to
> multipathd.  I'd much prefer them directly talking to the kernel
> instead of cementing multipathd, which is a bit of a wart.
>
Precisely my idea.
I'm fine with having a device-mapper D-Bus API, so that any application
can retrieve the device-mapper layout via D-Bus.
(It might as well be using sysfs directly, but who am I to argue here)
Path events, however, out of necessity are instantiated within the
kernel, and should be send out from the kernel via uevents.

D-Bus can be added on top of that, but multipathd should not generate
path events for D-Bus.

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
