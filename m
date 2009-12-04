From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Fri, 4 Dec 2009 19:08:49 +0000
Message-ID: <73e903670912041108o32c28af3q5a61e5a2e33edd0a@mail.gmail.com>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca>
	<4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>
	<alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se> <73e903670912031336n749c0bb4l5f2e46d5347e5875@mail.gmail.com>
	<alpine.DEB.1.10.0912041952370.23464@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0912041952370.23464@uplift.swm.pp.se>
Sender: linux-ide-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 4, 2009 at 7:00 PM, Mikael Abrahamsson <swmike@swm.pp.se> w=
rote:
>
> On Thu, 3 Dec 2009, Kristleifur Da=C4=91ason wrote:
>
>> On Thu, Dec 3, 2009 at 9:17 PM, Mikael Abrahamsson <swmike@swm.pp.se=
> wrote:
>>>
>>> On Wed, 4 Nov 2009, Andre Tomt wrote:
>>>
>>>> Identical issues with the AOC-SASLP-MV8 card with 8 Seagate Barrac=
uda
>>>> 7200.11 1.5TB drives using the mvsas driver. Creating a md raid ar=
ray seems
>>>> to trigger it nearly instantly, however other loads do not trigger=
 it
>>>> as fast (if at all, only tested briefly with paralell dd).
>>>
>>> Would just like to chime in with a "me too" on this. I've tried bot=
h ubuntu
>>> 9.10 kernel (2.6.31) and their 10.04 pre-alpha (guess it's 2.6.32-r=
c8) and
>>> mvsas + AOC-SASLP-MV8 is pretty much unusable. If I start md creati=
on it
>>> stalls immediately and gets nowhere, last time I tried it md claime=
d it had
>>> written 160 blocks then it stalled (all drive LEDs on the controlle=
r is
>>> constantly lit).
>>>
>>> If I boot without drives and then hot-plug the drives, it immediate=
ly
>>> oops:es.
>>>
>>> Any code/fixes I can try, this is a lab machine so I can easily do =
whatever
>>> needed with it...
>>>
>>
>> Hi,
>>
>> I had a bit of trouble finding some patches that were released by An=
dy Yan at
>> Marvell on November 9th, so here is a link:
>>
>> 1/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558753
>
> They applied cleanly to the ubuntu 10.04 2.6.32 kernel source package=
 but when compiling I received an error about "sas_change_queue_depth" =
having wrong amount of arguments:
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sas_change_queue_d=
epth(sdev, MVS_QUEUE_SIZE);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sas_change_queue_d=
epth(sdev, MVS_QUEUE_SIZE, SCSI_QDEPTH_DEFAULT);
>
> So I removed that change and then things compiled, booted properly, b=
ut just froze when I plugged in the disks (including some garbled graph=
ics on my X screen). That patch set doesn't seem to be ok.

(This is resent as my first email was HTML formatted and rejected by
the list. Edited and amended also.)

Cheers for trying them out! For the record, I think they were made
against 2.6.31, perhaps the original 2.6.31 rather than later 2.6.31.x
releases.

And also, I recommend using the mainline kernel for Ubuntu, especially
when trying these patches. It's available here:
http://kernel.ubuntu.com/~kernel-ppa/mainline/ - including source
packages.

-- Kristleifur
