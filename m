From: Hannes Reinecke <hare@suse.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Tue, 13 Oct 2015 08:00:43 +0200
Message-ID: <561C9E0B.6070500@suse.de>
References: <20150930215303.GI2627@mtj.duckdns.org> <1443652494.2185.57.camel@HansenPartnership.com> <20151002125608.GB14899@lst.de> <1443792301.2209.4.camel@HansenPartnership.com> <20151002133423.GA15867@lst.de> <1443793497.2209.10.camel@HansenPartnership.com> <20151004074556.GA13932@lst.de> <561BAB72.1070205@suse.de> <20151012143927.GA24770@lst.de> <CAMM=eLdLh4VGapGH2WcEUY2Biwx-ZojQ0HELCFYvQwW9zzpQ1A@mail.gmail.com> <20151012193614.GA32464@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbbJMGAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2015 02:00:46 -0400
In-Reply-To: <20151012193614.GA32464@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/12/2015 09:36 PM, Christoph Hellwig wrote:
> On Mon, Oct 12, 2015 at 03:29:45PM -0400, Mike Snitzer wrote:
>> What may be getting lost during this discussion is that historically
>> it has been important to be able to attach the scsi_dh during the SC=
SI
>> scan.  As the scsi_dh alters the SCSI midlayer's sense code processi=
ng
>> (via callout to the attached scsi_dh).  And this altered SCSI sense
>> code handling amounts to the difference between a successful/quick
>> boot versus hugely delayed and ultimately error-prone boot on system=
s
>> with many LUNs that have multiple paths.
>>
>> So that is why either of these solutions were deployed:
>> 1) in RHEL6 we'd require dracut to preload the scsi_dh modules early
>> in loading the initramfs
>> 2) in RHEL7 all scsi_dh modules _are_ builtin
>>
>> Both achieve the goal of having all required scsi_dh available durin=
g SCSI scan.
>=20
> Yes, and both are workarounds.  I tried to implement this properly,
> but due to async probing it doesn't actually work.  Given the stateme=
nt
> from Tejun I don't really see how to ever get it to work as long as
> we use async probing and the module loading code isn't safe to call
> from the async probe path unfortunately.
>=20
We've originally designed them to be modular as some handler
(notably emc, netapp, and alua) are mutually exclusive, ie you could
load either the alua or one of the vendor specific ones.

In the light of the discussion I think it would be better to
upgrade the device handler to become their own transport class,
to be hooked in between scsi_target and scsi_device.
That way we would have a way of exposing the topology (target port
groups etc) and would get rid of the probing problem.

It would mean that effectively the device handler would be
demodularized and become a compile-time option, but even that
wouldn't be too much of an issue, seeing that most vendors load
the modules unconditionally anyway.
(BTW, SUSE also loads the modules unconditionally ...)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
