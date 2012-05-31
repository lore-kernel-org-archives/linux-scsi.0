From: Dan Williams <dan.j.williams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Remove scsi_wait_scan module
Date: Thu, 31 May 2012 09:40:59 -0700
Message-ID: <CAA9_cmet6tMi6rNNv_ktRwHh3_N4rOSd+_jBW0P_gomHLpOytw@mail.gmail.com>
References: <1338110026.2957.5.camel@dabdike.int.hansenpartnership.com>
	<20120528100015.GB10036@vostochny.stro.at>
	<1338206866.6330.22.camel@dabdike>
	<CAA9_cmfh9ZtepX+hjLVRM95u_pAe90kZTkBeVmFPWm8AMaqJ5g@mail.gmail.com>
	<1338420752.3069.20.camel@dabdike>
	<CAA9_cmfZFm5+9ARB7tNVwNzwxJh3bPD=h7gMWhByjy00-qZvgg@mail.gmail.com>
	<1338452505.3073.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338452505.3073.4.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: maximilian attems <max-U9r9yeDMy7A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Mahoney <jeffm-l3A5Bk7waGM@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 31, 2012 at 1:21 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> Last time I checked scsi_wait_scan was still being used by dracut in
>> the case where it decides to stop waiting for all raid members to
>> appear. =A0It's a "last call" before proceeding with degraded assemb=
ly.
>
> That's pretty pointless behaviour, isn't it? =A0What it's basically d=
oing
> is allowing a set time for the devices to appear, waiting out that ti=
me
> (so presumably something is wrong with one or more of the devices), t=
hen
> inserting scsi_wait_scan as some type of magic incantation to just ma=
ke
> it work.

Random timeouts are magic, waiting for known probing to complete is not=
=2E

>> If you immediately assemble and mount root as soon as the root devic=
e
>> could be started it will almost always be a degraded array. =A0Sure =
the
>> initramfs can just timeout arrival, but at a minimum that timeout
>> should be "load module + flush scanning". =A0Without a flush mechani=
sm
>> it's just a shot in the dark what that minimum timeout should be.
>
> No, you wait a specified time for all the devices to appear before
> assembling the raid. =A0If they don't, you try to bring a degraded ra=
id
> up.
>
> The behaviour is also dependent on the user: If I'm a savvy user and =
I
> have a raid log, I want my system up as fast as possible, so I only w=
ant
> to wait until the minimum number of devices appears before assembling
> the raid and moving on, knowing that hotplug of the remaining will ca=
use
> a log replay.
>
>> If ata error recovery is kicking in and needs 10s of seconds to
>> recover a drive I'd want my initramfs to wait for that process to
>> quiesce before timing out and moving on.
>
> That's the timeout you specify.

I'm a savvy raid user who wants his raid arrays to start as soon as
possible and one that knows that  lldds, libsas, and libata can inject
long unpredictable delays to discover devices that were attached since
boot.

So it's not about hotplug it's about letting the initial scan /
discovery process (which may involve 3 resets and 1 minute of timeouts
per-disk in a pathological ata configuration) complete for devices
that were minimally indicated in the initial scan.  The initramfs
timeout is then an optional cushion to allow a hotplug event to land,
but for the "as fast as possible case" that means letting link
recovery actions quiesce.

--
Dan
