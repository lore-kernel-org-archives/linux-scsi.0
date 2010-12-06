From: Audio Haven <audiohaven@gmail.com>
Subject: Re: mvsas errors in 2.6.36
Date: Mon, 6 Dec 2010 12:11:11 +0100
Message-ID: <AANLkTimShdYvutSH-_mzZmSdgkFGOojjs-w+CDiMRCQq@mail.gmail.com>
References: <201010290650.32892.thomas@fjellstrom.ca>
	<4CE3912E.6060904@tomt.net>
	<201012012329.54944.thomas@fjellstrom.ca>
	<201012020249.00367.thomas@fjellstrom.ca>
	<4CF79C60.9030107@shiftmail.org>
	<AANLkTinVK8FAApP2zP8gqmPhgPo4ZeUMRRJ4cD+O1iza@mail.gmail.com>
	<alpine.DEB.1.10.1012051156400.9121@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39574 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0LFLLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2010 06:11:13 -0500
Received: by wyb28 with SMTP id 28so11884079wyb.19
        for <linux-scsi@vger.kernel.org>; Mon, 06 Dec 2010 03:11:12 -0800 (PST)
In-Reply-To: <alpine.DEB.1.10.1012051156400.9121@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello Mikael,

smartctl reporting seems to work fine while xfs_fsr is defragmenting
xfs on top of the raid6 software raid + lvm2:

# for disk in /dev/sd[c-j]; do  smartctl -T permissive -s on -A
$disk|grep Raw_Read_Error_Rate ; done
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail
Always       -       2
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail
Always       -       0
  1 Raw_Read_Error_Rate     0x000b   086   086   016    Pre-fail
Always       -       4587581
  1 Raw_Read_Error_Rate     0x000b   086   086   016    Pre-fail
Always       -       2883644
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail
Always       -       12
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail
Always       -       0
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail
Always       -       0
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail
Always       -       1

No issues appear in dmesg. Notice the difference in Hitachi disks
(very high numbers, likely the actual raw error rate before error
correction, both are Hitachi HDT721010SLA360) vs Samsung disks (only
the unrecoverable, SAMSUNG HD103SI -> they lie, shouldn't be named
'raw').

On Sun, Dec 5, 2010 at 11:58 AM, Mikael Abrahamsson <swmike@swm.pp.se> =
wrote:
> On Sun, 5 Dec 2010, Audio Haven wrote:
>
>> Thanks to everyone who helped making mvsas stable as it finally work=
s!
>
> Did you include smartctl reading under load as well, does that now wo=
rk
> reliably?
>
> I've had my AOC-SASLP-MV8 lying in a box for about a year because I j=
ust
> gave up trying to get it to work, would be very welcome news to see i=
t
> working in 2.6.37.
>
> The changes made, are they backportable to 2.6.32 by any chance?
>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
