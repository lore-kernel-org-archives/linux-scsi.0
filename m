From: Dan Williams <dan.j.williams-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Remove scsi_wait_scan module
Date: Wed, 30 May 2012 19:34:14 -0700
Message-ID: <CAA9_cmfZFm5+9ARB7tNVwNzwxJh3bPD=h7gMWhByjy00-qZvgg@mail.gmail.com>
References: <1338110026.2957.5.camel@dabdike.int.hansenpartnership.com>
	<20120528100015.GB10036@vostochny.stro.at>
	<1338206866.6330.22.camel@dabdike>
	<CAA9_cmfh9ZtepX+hjLVRM95u_pAe90kZTkBeVmFPWm8AMaqJ5g@mail.gmail.com>
	<1338420752.3069.20.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338420752.3069.20.camel@dabdike>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: maximilian attems <max-U9r9yeDMy7A@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Mahoney <jeffm-l3A5Bk7waGM@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 30, 2012 at 4:32 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Wed, 2012-05-30 at 11:26 -0700, Dan Williams wrote:
>> On Mon, May 28, 2012 at 5:07 AM, James Bottomley
>> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> > On Mon, 2012-05-28 at 10:00 +0000, maximilian attems wrote:
>> >> On Sun, May 27, 2012 at 10:13:46AM +0100, James Bottomley wrote:
>> >> > scsi_wait_scan was introduced with asynchronous host scanning a=
s a hack
>> >> > for distributions that weren't using proper udev based wait for=
 root to
>> >> > appear in their initramfs scripts. =A0In 2.6.30 Commit
>> >>
>> >> > c751085943362143f84346d274e0011419c84202
>> >> > Author: Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org>
>> >> > Date: =A0 Sun Apr 12 20:06:56 2009 +0200
>> >> >
>> >> > =A0 =A0 PM/Hibernate: Wait for SCSI devices scan to complete du=
ring resume
>> >> >
>> >> > Actually broke scsi_wait_scan because it renders
>> >> > scsi_complete_async_scans() a nop for modular SCSI if you inclu=
de
>> >> > scsi_scans.h (which this module does).
>> >> >
>> >> > The lack of bug reports is sufficient proof that this module is=
 no
>> >> > longer used.
>> >>
>> >> We do use it in initramfs-tools.
>> >>
>> >> There is quite a number of bug reports moaning about having to bo=
ot with
>> >> `scsi_mod.scan=3Dsync'. I didn't pass them on, because I didn't k=
new that
>> >> the module itself got broken, for example:
>> >> http://bugs.debian.org/616689
>> >
>> > OK, so what these bugs show is the breakage ... basically scsi_wai=
t_scan
>> > isn't really waiting for the scans to complete. =A0I can fix it in=
 stable
>> > so you can close your bug reports, but if I do, can you also trans=
ition
>> > away from using it so I can remove it in 3.5?
>>
>> Is there some other method whereby userspace can sync all driver
>> probing actions?
>
> No, =A0but then there never really was. =A0The theory is you know all=
 the
> disks you need (/ /usr and so on) and you just wait for them to appea=
r
> before mounting them and proceeding with boot.
>
>> We won't need scsi_complete_async_scans() after:
>>
>> =A0 http://marc.info/?l=3Dlinux-scsi&m=3D133840132007532&w=3D2
>>
>> ...but won't initramfs environments still need a way to trigger
>> wait_for_device_probe()? =A0Something like echo "flush" >
>> /sys/devices/async_probe. and maybe reading that file indicates if
>> some async probing is still in-flight?
>
> Why? =A0The job of an initramfs is to mount root. =A0All it has to do=
 is
> wait for root to appear via udev and then proceed. =A0The whole reaso=
n for
> doing stuff async initially was to speed boot, so probing can still b=
e
> ongoing even after the initrd exits.
>
> If you think about it, most modern fabrics are hot plug. =A0Just beca=
use
> the initial scan has completed there's no guarantee that all the devi=
ces
> have appeared yet.

=46ine for single device root, but what about raid and degraded assembl=
y?

Last time I checked scsi_wait_scan was still being used by dracut in
the case where it decides to stop waiting for all raid members to
appear.  It's a "last call" before proceeding with degraded assembly.

If you immediately assemble and mount root as soon as the root device
could be started it will almost always be a degraded array.  Sure the
initramfs can just timeout arrival, but at a minimum that timeout
should be "load module + flush scanning".  Without a flush mechanism
it's just a shot in the dark what that minimum timeout should be.

If ata error recovery is kicking in and needs 10s of seconds to
recover a drive I'd want my initramfs to wait for that process to
quiesce before timing out and moving on.

--
Dan
