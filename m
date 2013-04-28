From: "Gurinder (Sunny) Shergill" <gurinder.shergill@gmail.com>
Subject: Re: lpfc and FLOGI failure.
Date: Sun, 28 Apr 2013 09:38:47 -0700
Message-ID: <517D5097.2030406@gmail.com>
References: <517D44FB.5050206@linuxsolutions.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49598 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3D1Qit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Apr 2013 12:38:49 -0400
Received: by mail-ie0-f171.google.com with SMTP id e11so6581480iej.30
        for <linux-scsi@vger.kernel.org>; Sun, 28 Apr 2013 09:38:49 -0700 (PDT)
In-Reply-To: <517D44FB.5050206@linuxsolutions.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Johnny_Str=F6m?= <johnny.strom@linuxsolutions.fi>
Cc: linux-scsi@vger.kernel.org

On 4/28/2013 8:49 AM, Johnny Str=F6m wrote:
>
> Hello
>
> We have an Emulex LPe1150 that is causing FLOGI failure when the driv=
er
> is loaded.
>
> We have updated the firmware on the card. It is working ok with an ol=
d
> HP MSA.
>
> But with an new MD36xxf so dose it not work.
>
> when the lpfc driver is loded so dose it take about 7 seconds to load
> and efter that so
> do we only see these LUN's: We do not see the other disk LUN's
>
> [16:0:0:0]   disk    DELL     MD36xxf          0784  -
> [16:0:0:31]  disk    DELL     Universal Xport  0784  -
>
>
> dmesg shows this after the driver is loaded.
>
> [15313.555729] scsi12 : Emulex LPe1150 1Gb PCIe Fibre Channel Adapter=
 on
> PCI bus 0e device 00 irq 30
> [15317.795558] lpfc 0000:0e:00.0: 1:1303 Link Up Event x1 received Da=
ta:
> x1 x1 x10 x2 x0 x0 0
> [15317.795680] lpfc 0000:0e:00.0: 1:1309 Link Up Event npiv not
> supported in loop topology
> [15317.796111] lpfc 0000:0e:00.0: 1:(0):2858 FLOGI failure Status:x3/=
x18
> TMO:x0
> [15317.796423] lpfc 0000:0e:00.0: 1:(0):2858 FLOGI failure Status:x3/=
x18
> TMO:x0
> [15317.796726] lpfc 0000:0e:00.0: 1:(0):2858 FLOGI failure Status:x3/=
x18
> TMO:x0
> [15317.796825] lpfc 0000:0e:00.0: 1:(0):0100 FLOGI failure Status:x3/=
x18
> TMO:x0
>
> Could it be an bug in the lpfc driver when it is used with MD36xxf?
> Any suggestions what to do or try?

=46irst thing to note here is that FLOGI is issued to log into a switch=
=20
and not to an end-port. Next thing is that the logs you emailed show yo=
u=20
are most probably in a "loop topology" and not in a Fabric topology. So=
,=20
=46LOGI messages are probably not relevant, unless you can confirm that=
=20
LPe1150 is indeed connected to a FC switch.

Now, moving to the array side as a potential cause, disk arrays normall=
y=20
have setting associated with the front-side ports, which when not=20
configured properly may cause issues with FC discovery (especially, whe=
n=20
in loop topology). I certainly don't know if that is the case here, but=
=20
I'd make sure to go thru the Dell MD36xx guide to ensure you have=20
configured they array properly for loop topology. For example, some=20
initiators won't "connect" with a array if the array port doesn't have=20
Hard-addressing enabled when in loop topology.

One more thing (this is an obvious one, so sorry, if you have already=20
done this one) -- I am assuming you have properly presented the disk=20
LUNs in MD36xx to the LPe1105 port WWN. Right ?

Hope this helps,
Sunny

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
