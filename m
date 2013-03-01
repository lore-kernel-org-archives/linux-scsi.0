From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [Patch][RFC] st: provide tape statistics via sysfs
Date: Fri, 1 Mar 2013 00:49:44 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3434A6C5@G9W0766.americas.hpqcorp.net>
References: <DDB9C85B850785449757F9914A034FCB34340D6F@G4W3219.americas.hpqcorp.net>
 <1361530259.2372.28.camel@dabdike.int.hansenpartnership.com>
 <3C97D1F8-2520-4D26-9F6D-DF07221B17F6@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1981 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3CAAvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2013 19:51:24 -0500
In-Reply-To: <3C97D1F8-2520-4D26-9F6D-DF07221B17F6@kolumbus.fi>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



-----Original Message-----
=46rom: Kai M=E4kisara [mailto:kai.makisara@kolumbus.fi]=20
Sent: Wednesday, February 27, 2013 4:38 AM
To: James Bottomley
Cc: Seymour, Shane M; linux-scsi@vger.kernel.org
Subject: Re: [Patch][RFC] st: provide tape statistics via sysfs


> The sysfs files in the patch export the statistics in the same way as=
 the disk statistics are exported
> (cf. linux/Documentation/iostats.txt). This would enable the tools pa=
rson iostats easily analyze
> statistics also for tapes.

Can I make a counter proposal that doesn't introduce any more ABI compa=
tibility issues than already exist in sysfs? I'll create a statistics d=
irectory as James suggested and expose all of the individual statistics=
 in their own files one value per file. I'll remove the extra field I w=
anted to add from the stat file and make it identical to the file provi=
ded for disk statistics and move the file down into the statistics dire=
ctory under the device (with a warning in the code that this file must =
provide exactly the same information as the disks stat file and cannot =
provide more than that). To get the statistics I want to get I'll use t=
he stat file plus one of the individual files. I'd still like to keep t=
he file with the hint about how many tape drives there will be as a max=
imum.

> The statistics represent the status at one time point and must be rea=
d together (within reason).
> This means that splitting the values to several files is not a proper=
 way to export the information.

One file would be better than two, but two is a lot better than having =
to open and read all of them individually and get stats that really are=
 an approximation.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
