From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Fri, 8 Apr 2011 18:43:14 +0200
Message-ID: <BANLkTimUjkO4s3b1KvhNht-WCfqK+SU2NA@mail.gmail.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
 <20110405161400.GA885@kroah.com> <4D9F17DF.5030601@hitachi.com>
 <4D9F1CD1.2020600@suse.de> <1302275652.4090.10.camel@mulgrave.site> <20110408161420.GB12111@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <20110408161420.GB12111@kroah.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 8, 2011 at 18:14, Greg KH <greg@kroah.com> wrote:
> On Fri, Apr 08, 2011 at 08:14:12AM -0700, James Bottomley wrote:
>> So, while I agree totally with the above: udev and userspace is the =
way
>> to go, I'm not totally opposed to having a non-invasive mechanism fo=
r
>> indicating a user's preferred name for a device. =C2=A0I think there=
 are a
>> couple of ways to do this:
>>
>> =C2=A0 =C2=A0 =C2=A01. Entirely in userspace: just have udev consult=
 a preferred name
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 file and create say /dev/disk/by-preferr=
ed. =C2=A0Then have all the
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 tools that normally output device inform=
ation do the same (i.e.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 since real name to preferred name is 1:1=
, they could all do a
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 reverse lookup).
>> =C2=A0 =C2=A0 =C2=A02. have a writeable sysfs preferred_name field, =
either in the
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 generic device or just in SCSI. =C2=A0Th=
e preferred name would be
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 used by outbound only (i.e. kernel dev_p=
rintk messages and
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 possibly /proc/partitions). =C2=A0All in=
bound uses of the device
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 would come via the standard udev mechani=
sms
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 (i.e. /dev/disk/by-preferred would be th=
e usual symlink). =C2=A0This
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 means from the kernel point of view, no =
renaming has happened.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 We'd just try to print out the preferred=
 name in certain
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 circumstances, which should solve most o=
f the described problem.
>
> Either, or both, of those options are fine with me as well.

I guess a generic sysfs file, that can carry a user-given name for a
device, and which is looked-up with dev_printk() macro, and maybe
/proc/partitions is all what we would need if we want to involve the
kernel here.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-hotplug=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
