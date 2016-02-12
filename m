From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] bio: return EINTR if copying to user space got
 interrupted
Date: Fri, 12 Feb 2016 17:14:12 +0100
Message-ID: <56BE04D4.7080308@suse.de>
References: <1455266355-44676-1-git-send-email-hare@suse.de>
 <56BE02BA.5080001@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56BE02BA.5080001@interlog.com>
Sender: stable-owner@vger.kernel.org
To: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, #@suse.de, v.3.11+@suse.de
List-Id: linux-scsi@vger.kernel.org

On 02/12/2016 05:05 PM, Douglas Gilbert wrote:
> On 16-02-12 03:39 AM, Hannes Reinecke wrote:
>> Commit 35dc248383bbab0a7203fca4d722875bc81ef091 introduced a check f=
or
>> current->mm to see if we have a user space context and only copies d=
ata
>> if we do. Now if an IO gets interrupted by a signal data isn't copie=
d
>> into user space any more (as we don't have a user space context) but
>> user space isn't notified about it.
>>
>> This patch modifies the behaviour to return -EINTR from bio_uncopy_u=
ser()
>> to notify userland that a signal has interrupted the syscall, otherw=
ise
>> it could lead to a situation where the caller may get a buffer with
>> no data returned.
>
> Interesting, the "f091" commit has been in the kernel since 2013
> hence your reference to v.3.11 . I always had the feeling that
> handling signals that interrupted SG_IO calls was skating on thin
> ice.

Yeah; that bug was really annoying, as occasionally receiving no data=20
whatsoever without any indication makes it really, really hard to debug=
=2E
Kudos go to Johannes and Ewan for pointing to the offending function.

> Hence in ddpt (but not sg_dd nor sgp_dd) the code masks out
> all signals (that it can) during the SG_IO calls then opens a
> signal window briefly after a SG_IO ioctl has finished and before
> the next one starts. This approach used by ddpt is borrowed from
> dd (in coreutils) which masks signals during its read() and
> write() calls.
>
> Any idea how accurate resid is in this scenario?
>
Bah. F*sk knows.
That takes far more POSIX knowledge than I have.
I would suspect that by masking out signals they'll be marked as pendin=
g=20
for the process, and will be delivered once you unmask them.
Or dropped, depending.
In either case, once they are blocked out the kernel part shouldn't=20
receive a signal, and hence we should be able to receive the data prope=
rly.
But as noted I'm not a POSIX expert.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
