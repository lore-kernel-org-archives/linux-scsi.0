From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri, 04 Jul 2014 16:12:57 +0200
Message-ID: <53B6B669.10704@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-3-git-send-email-hare@suse.de> <53B69E97.4050901@acm.org> <53B6A5B4.2040807@suse.de> <20140704134835.GB12345@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbaGDOM6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 10:12:58 -0400
In-Reply-To: <20140704134835.GB12345@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/04/2014 03:48 PM, Christoph Hellwig wrote:
> On Fri, Jul 04, 2014 at 03:01:40PM +0200, Hannes Reinecke wrote:
>> What I would like to do is to provide accessor functions for the scs=
i lun;
>> I've started this already for the older SCSI parallel drivers (see m=
y
>> earlier patch).
>> Once everything is moved over to accessors it should be trivial to m=
ove from
>> the current scsilun_to_int representation in struct scsi_device to t=
he
>> 'real' LUN.
>>
>> Adding another field would be bit of an overkill IMO, seeing that we=
 can
>> achieve the very same thing with a bit of code reshuffling.
>>
>> James, Christoph, what's your opinion on using accessors?
>> Would solve this issue nicely, and we can also use proper functions =
for HBAs
>> only capable of handling 32bit LUNs.
>> Drawback is that we would need accessors also for this capable of ha=
ndling
>> full 64bit LUNs, thus potentially incur some overhead there.
>
> I think storing the struct scsi_lun in the scsi_device is the right w=
ay
> to go ahead.  Any "accessors" for 8 or 32-bit LUNs should be simply
> enough by just ignoring bits in the array, so there's very little
> performance overhead.
>
> If we can get rid of the old scalar LUN field that would be great,
> and given that we know the printk format fallout already it doesn't l=
ook
> like too much work.  Do you want to look into this?
>
Already working on it.

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
