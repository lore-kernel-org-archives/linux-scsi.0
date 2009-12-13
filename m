From: =?UTF-8?B?SsO2cm4gTmV0dGluZ3NtZWllcg==?=
	<nettings@stackingdwarves.net>
Subject: 3ware 9690SA: raid6 array blows up under opensuse 11.2 (2.6.31)
Date: Sun, 13 Dec 2009 16:08:30 +0100
Message-ID: <4B25036E.7080101@stackingdwarves.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.uni-duisburg-essen.de ([132.252.185.20]:33612 "HELO
	mailout.uni-duisburg-essen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753494AbZLMPSH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Dec 2009 10:18:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: =?UTF-8?B?SsO2cm4gTmV0dGluZ3NtZWllcg==?= <nettings@stackingdwarves.net>

hi everyone !


i have had a weird issue with the 3ware 9690SA controller on an intel
nehalem system. there are 5 2tb drives attached to that controller in a
raid6 configuration, which is exported to the operating system as a
single volume.

an installation of opensuse 11.2 (using a 2.6.31 kernel) fails
reproducibly after 10-20mins of heavy disk activity. the error manifest=
s
itself by the first two drives falling off the array, whereupon the
controller switches to read-only mode and any subsequent writes fail.

checking with the CLI or the controller bios shows that drives p0 and p=
1
are disconnected.

at the same time, the controller bios fails to come up after a warm
reboot 3 out of 4 times, which is fixed only by a cold restart.

the nature of the failure and the reboot problems made me suspect a
hardware failure (an opinion shared by my vendor's support technician).

so the box was sent back for testing. turns out they can reproduce the
error 100% with opensuse 11.2, but not with an older debian or SLES 10
system. and they pretty much swapped all hardware components in the lab
(i had already seen the issue with two different controllers of the sam=
e
model).

so it might be a software issue after all.
since the vendor is not supporting oS 11.2, they closed the issue and
sent the machine back.
still, this is nagging me, simply because if it happened on a productio=
n
machine, it would be an issue of massive data loss...

do you know of any known regressions in the 3ware driver or userspace
utilities since 2.6.27 (because that was the latest kernel that passed
the tests) that could be causing this issue?

here are some screenshots of the dmesg buffer and the controller bios
during the error condition:

http://stackingdwarves.net/download/3ware-9690SE-crash/

i'd be happy to run further tests on that machine on monday - any advic=
e
on how to proceed would be most welcome.


best regards,


j=C3=B6rn



ps: i'd appreciate being cc:ed on this issue, since i'm not subscribed.



--=20
J=C3=B6rn Nettingsmeier
Lortzingstr. 11, 45128 Essen, Tel. +49 177 7937487

Meister f=C3=BCr Veranstaltungstechnik (B=C3=BChne/Studio), Elektrofach=
kraft
Audio and event engineer - Ambisonic surround recordings

http://stackingdwarves.net

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
