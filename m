From: Audio Haven <audiohaven@gmail.com>
Subject: Re: MVSAS status
Date: Wed, 10 Feb 2010 10:22:35 +0100
Message-ID: <333bc7e11002100122m5eb97d7ey78a31df91dee2405@mail.gmail.com>
References: <loom.20100210T002935-813@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62072 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0BJJWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2010 04:22:37 -0500
Received: by bwz19 with SMTP id 19so1694672bwz.28
        for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2010 01:22:36 -0800 (PST)
In-Reply-To: <loom.20100210T002935-813@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I'm still experiencing issues with this patched driver (using patches
posted in November '09), but I believe I'm hitting known issues in the
following Western Digital green drives.

WDC WD15EADS-00P8B0

I have five of those 00P8B0, some of them have a really high
Load_Cycle_Count, or they become slow during a raid rebuild, or they
just timeout when not using WDIDLE3.EXE (and using the default 8sec
Intellipark feature which is really bad design) ... they are reported
as BAD and "NOT RECOMMENDED" all over the internet. WD doesn't provide
a decent solution yet for these.

My three newer WD15EADS-00S2B0 are also running on the same Marvell
controller and were never kicked out of the raid. Stable and decent
speed. I didn't see any issue with those newer 00S2B0 drives, so I
believe this is actually a WD issue and not a Marvell issue. Maybe the
timeouts are not handled well by the Marvell driver and we're seeing
mvs_abort_task , but that looks more like a symptom.

I disabled the intellipark feature of the WD drives using WDIDLE3.EXE
via a DOS usb bootable stick, and instead of timing out, the
WD15EADS-00P8B0 just have become extremely slow now, iostat reports
1.5 MB/s writes to the  raid rebuild drive.

I believe the current MVSAS patches should be good enough if you avoid
WD Green drives;

Best regards,

Audio Haven

On Wed, Feb 10, 2010 at 12:32 AM, Orion Poplawski <orion@cora.nwra.com>=
 wrote:
> What's the status of the MVSAS patches posted in November '09? =A0I'm=
 just trying
> to get started with mvsas and running into the mvs_abort_task issue. =
=A0At least
> one person has reported that stability improved, but it looks like th=
ere were
> some other issues with the patches. =A0Any chance on seeing this in t=
he mainline
> kernel soon? =A0Are there updated versions? =A0A git tree to pull fro=
m?
>
> Thanks!
>
> - Orion Poplawski
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
