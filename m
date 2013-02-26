From: =?iso-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>
Subject: Re: [Patch][RFC] st: provide tape statistics via sysfs
Date: Tue, 26 Feb 2013 19:38:20 +0200
Message-ID: <3C97D1F8-2520-4D26-9F6D-DF07221B17F6@kolumbus.fi>
References: <DDB9C85B850785449757F9914A034FCB34340D6F@G4W3219.americas.hpqcorp.net> <1361530259.2372.28.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:59088 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3BZRsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Feb 2013 12:48:18 -0500
In-Reply-To: <1361530259.2372.28.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Seymour, Shane M" <shane.seymour@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Feb 22, 2013, at 12:50 PM, James Bottomley <James.Bottomley@HansenPa=
rtnership.com> wrote:

> On Fri, 2013-02-22 at 02:11 +0000, Seymour, Shane M wrote:
>> First forgive me for using outlook for this, if there are any issues=
 with what I sent let me know and I'll send it again from gmail. This i=
s also my first attempt at a kernel patch so please be gentle.
>>=20
>> This patch was written to enable tape statistics via sysfs for the d=
t
>> driver based on kernel 3.8.0-rc6. It creates two new files in sysfs
>> and is based on work done previously in 2005 by Kai M=E4kisara. Any
>> feedback would be greatly appreciated.
>=20
> I'm afraid we can't do it the way you're proposing.  files in sysfs m=
ust
> conform to the one value per file rule (so we avoid the ABI nastiness
> that plagues /proc).  You can create a stat directory with a bunch of
> files, but not a single file that gives all values.
>=20

The sysfs files in the patch export the statistics in the same way as t=
he
disk statistics are exported (cf. linux/Documentation/iostats.txt). Thi=
s
would enable the tools parson iostats easily analyze statistics also fo=
r
tapes.

The statistics represent the status at one time point and must be read
together (within reason). This means that splitting the values to sever=
al
files is not a proper way to export the information.

What then is the proper way? Debugfs?

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
