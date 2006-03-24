From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Fri, 24 Mar 2006 13:30:22 +0100
Message-ID: <4423E65E.20005@suse.de>
References: <20051114224512.GF9905@mathom.us> <20060323180909.GD15140@mathom.us> <1143139044.3415.26.camel@mulgrave.il.steeleye.com> <20060324122715.GG15140@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:64700 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932145AbWCXMaY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 07:30:24 -0500
In-Reply-To: <20060324122715.GG15140@mathom.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stone <mstone@mathom.us>
Cc: linux-scsi@vger.kernel.org

Michael Stone wrote:
> On Thu, Mar 23, 2006 at 01:37:23PM -0500, James Bottomley wrote:
>> Well, since the driver works normally for most people, it sounds lik=
e
>> there's some issue with this configuration.  First of all, look
>> in /sys/class/spi_transport/target2:0:0 and tell me what min_period,
>> max_offset and max_width are.  Then, if min_period is too high, echo
>> 12.5 to it and 1 to revalidate.  Finally, see if you can set the per=
iod
>> yourself using the period file.  Also, what does /proc/scsi/aic79xx/=
2
>> say?  If none of that works, we can try debug the negotiation.
>=20
> Thanks for the reply, it's finally working. The min_period was 6.5,
> changing it to 12.5 & revalidating made it properly negotiate 160MB/s
> instead of asynchronous. max_offset was 254 & max_width was 1. Is the=
re
> a way to make that permenant beside setting the proc entries on each =
boot?
>=20
Well, yes. You can limit the transfer speed in the BIOS for that device=
=2E
With the latest patches from scsi-misc we're finally picking them up :-=
)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
