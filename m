From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi traffic sniffing
Date: Tue, 01 Sep 2009 13:19:44 +0200
Message-ID: <4A9D0350.2010201@s5r6.in-berlin.de>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com> <d364733c0909010340t57499a38y4c0bd949e5ba63a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60004 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbZIALTt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 07:19:49 -0400
In-Reply-To: <d364733c0909010340t57499a38y4c0bd949e5ba63a6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?6LCi57qy?= <xiegang112@gmail.com>
Cc: Jonathan Nell <crtrn13@gmail.com>, linux-scsi@vger.kernel.org

=E8=B0=A2=E7=BA=B2 wrote:
> On Tue, Sep 1, 2009 at 2:13 PM, Jonathan Nell<crtrn13@gmail.com> wrot=
e:
>> Is there any way to sniff the traffic of a scsi device? I need to
>> debug a firmware update and need to see the traffic being passed to
>> the drive
> You may hook the queue_command function of the scsi host. It can snif=
f
> all scsi request to scsi host driver.

Actually you can switch on logging of commands and status (though not o=
f=20
data) at runtime by something like
# echo $BITMASK > /sys/module/scsi_mod/parameters/scsi_logging_level
or
# echo $BITMASK > /proc/sys/dev/scsi/logging_level
provided that the kernel's SCSI core was compiled with=20
CONFIG_SCSI_LOGGING=3Dy.

Bitmask values can be constructed as in=20
linux/drivers/scsi/scsi_logging.h.  Long ago I made a note that 9216 as=
=20
bitmask was useful for my purposes, but don't ask me what that means.

=46or data logging, you have to modify the SCSI low-level driver or SCS=
I=20
core indeed.

However, all this applies only if the firmware updater actually runs on=
=20
a Linux initiator, not e.g. on an MS Windows initiator.  In the latter=20
case, you need a debug driver which hooks into Windows' SCSI stack, or=20
some sort of bus analyzer.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--=3D =3D--=3D ----=3D
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
