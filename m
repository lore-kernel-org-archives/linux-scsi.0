From: Hannes Reinecke <hare@suse.de>
Subject: Re: bio-based DM multipath is back from the dead [was: Re: Notes from
 the four separate IO track sessions at LSF/MM]
Date: Fri, 27 May 2016 10:39:50 +0200
Message-ID: <574807D6.4030208@suse.de>
References: <1461800389.2311.70.camel@HansenPartnership.com>
 <20160428121108.GA9903@redhat.com>
 <1461858038.2307.16.camel@HansenPartnership.com>
 <20160526023855.GA20659@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbcE0Ijw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2016 04:39:52 -0400
In-Reply-To: <20160526023855.GA20659@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-block@vger.kernel.org, lsf@lists.linux-foundation.org, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, hch@lst.de

On 05/26/2016 04:38 AM, Mike Snitzer wrote:
> On Thu, Apr 28 2016 at 11:40am -0400,
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>
>> On Thu, 2016-04-28 at 08:11 -0400, Mike Snitzer wrote:
>>> Full disclosure: I'll be looking at reinstating bio-based DM multip=
ath to
>>> regain efficiencies that now really matter when issuing IO to extre=
mely
>>> fast devices (e.g. NVMe).  bio cloning is now very cheap (due to
>>> immutable biovecs), coupled with the emerging multipage biovec work=
 that
>>> will help construct larger bios, so I think it is worth pursuing to=
 at
>>> least keep our options open.
>
> Please see the 4 topmost commits I've published here:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.g=
it/log/?h=3Ddm-4.8
>
> All request-based DM multipath support/advances have been completly
> preserved.  I've just made it so that we can now have bio-based DM
> multipath too.
>
> All of the various modes have been tested using mptest:
> https://github.com/snitm/mptest
>
>> OK, but remember the reason we moved from bio to request was partly =
to
>> be nearer to the device but also because at that time requests were
>> accumulations of bios which had to be broken out, go back up the sta=
ck
>> individually and be re-elevated, which adds to the inefficiency.  In
>> theory the bio splitting work will mean that we only have one or two
>> split bios per request (because they were constructed from a split u=
p
>> huge bio), but when we send them back to the top to be reconstructed=
 as
>> requests there's no guarantee that the split will be correct a secon=
d
>> time around and we might end up resplitting the already split bios. =
 If
>> you do reassembly into the huge bio again before resend down the nex=
t
>> queue, that's starting to look like quite a lot of work as well.
>
> I've not even delved into the level you're laser-focused on here.
> But I'm struggling to grasp why multipath is any different than any
> other bio-based device...
>
Actually, _failover_ is not the primary concern. This is on a (relative=
)=20
slow path so any performance degradation during failover is acceptable.

No, the real issue is load-balancing.
If you have several paths you have to schedule I/O across all paths,=20
_and_ you should be feeding these paths efficiently.

With the original (bio-based) layout you had to schedule on the bio=20
level, causing the requests to be inefficiently assembled.
Hence the 'rr_min_io' parameter, which were changing paths after=20
rr_min_io _bios_. I did some experimenting a while back (I even had a=20
presentation on LSF at one point ...), and figuring that you would get =
a=20
performance degradation once the rr_min_io parameter went below 100.
But this means that paths will be switched after every 100 bios,=20
irrespective of into how many requests they'll be assembled.
It also means that we have a rather 'choppy' load-balancing behaviour,=20
and cannot achieve 'true' load balancing as the I/O scheduler on the bi=
o=20
level doesn't have any idea when a new request will be assembled.

I was sort-of hoping that with the large bio work from Shaohua we could=
=20
build bio which would not require any merging, ie building bios which=20
would be assembled into a single request per bio.
Then the above problem wouldn't exist anymore and we _could_ do=20
scheduling on bio level.
But from what I've gathered this is not always possible (eg for btrfs=20
with delayed allocation).

Have you found another way of addressing this problem?

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
