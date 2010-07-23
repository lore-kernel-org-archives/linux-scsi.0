From: "jack wang" <jack_wang@usish.com>
Subject: RE: RE pm8001 bug - pcieport error when loading 'pm8001' driver / no backplane drives seen
Date: Fri, 23 Jul 2010 09:30:36 +0800
Message-ID: <48831161A575401AB1417D72763A3EAD@usish.com.cn>
References: <4C483158.9060405@agenda.si> <F84ED190842B4649A809941E3F3F4BBA@usish.com.cn> <4C4864CA.8040508@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:51586 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab0GWBax (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 21:30:53 -0400
In-Reply-To: <4C4864CA.8040508@agenda.si>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Danilo Godec' <danilo.godec@agenda.si>
Cc: linux-scsi@vger.kernel.org


Thank you for a quick reply - but I'm not sure I understand correctly...

> [Jack]ATTO H608 use pm8001 SAS SPC chip as controller, but they don't
> use original PMC-Sierra's firmware AFAIK, the firmware we don't test well
> with our pm8001 driver.So I recommended you use HBA card made by USI.
> If you want to try pm8001 to drive your ATTO HBA, you'd better make sure
> remove ATTO's driver and reboot to load pm8001 fresh.
>   

The 'esas2hba' driver wasn't even installed - I downloaded and compiled
it later, after I couldn't get pm8001 to 'see' drives on the backplane.

If I use a MiniSAS to 4x SATA cable, the pm8001 driver works perfectly
with the ATTO - even with the 'pcieport' error. It's only when the
drives are in the enclosure / backplane. that the pm8001 driver doesn't
'see' them.
[Jack] Could you reboot the Expender (poweroff and poweron) to clear the
affliation in the expander to see whether the disks can be founded or not.
> [Jack] The errors means all SATA disks have affiliations with
> other devices, here I think it's esas2hba.
>
>
> [Jack]I believe the all 6 drives are SATA disks. They have affiliations
> with esas2hba.
>   

You are right - all of my drives are SATA, connected to a SAS backplane,
which is connected to the HBA via a SAS expander / midplane (at least as
far as I understand).

I don't quite understand what you mean by 'affiliations with esas2hba'
(especially since there was no 'esas2hba' driver in the beginning)?

I'm quite new to SAS and especially to 'expanders', so maybe I'm missing
something obvious...

Regards, Danilo

[Jack] Sorry for my words made you confused .
SAS use STP to access SATA behind expanders, it will first open 
STP connection between SAS initiator and STP/SATA Bridge in expander, then
the HBA and the SATA disks communicate as SATA HOSTs and SATA devices.

An affiliation is a state entered by an STP target port in which the STP
target port refuses to accept connection requests from STP initiator ports 
other than those that have established an affiliation.

You can refer to spl 6.18.4 to see detail informations.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

