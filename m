From: phil <philippe.aubry1@mageos.com>
Subject: Re: Problems with higher SCSI LUN's with SLES8
Date: Wed, 17 Sep 2003 03:05:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F67B36B.2060303@mageos.com>
References: <A00BBCF927F25E4A9D5F6EE1380CDEF2CC88@hedwig.ysl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:40464 "EHLO
	kraid.nerim.net") by vger.kernel.org with ESMTP id S262560AbTIQBJK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 21:09:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Zuylen, G. van" <GvZuylen@ysl.nl>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Zuylen, G. van wrote:
> Hi you all,
> 
> We are using a HP DL380 server with a Qlogic 2300 HBA adapter. This adapter
> is connected to a HP EMA12000 SAN (with HSG80 controllers). Behind the HBA
> (qlogic 2300) we see only the devices up to LUN 7, higher LUN are not
> detected. We have tried several things like modifying /etc/modules.conf with
> "options scsi_mod max_scsi_luns=128" and modifying /boot/grub/menu.lst. But
> nothing seems to be working.
> We are using SLES8 with kernel version k_smp-2.4.19-304 and the qlogic
> driver version 6.05.60. Also tested with a newer kernel k_smp-2.4.19-340,
> but this makes no difference. 
> 
> Does anybody know how we can solve this problem or is there somebody who has
> experience with this ?
> 
> Best regards,
> 
> Gert van Zuylen
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi,
On your hsg when you saw your connection ( show conn on the console ) do 
you have an offset on the connection of your qlogic card ?
what is the mode of the controler, transparent failover or multibus 
failover ?
What is the number of your unit ( D10 D11 D12 D120 for exemple ) ?
The information on your mail are not sufficient for helping you, they 
are many possiblities and reasons for see only the 7 fisrt lun.

Do you have compiled your kernel with more than 7 scsi disks, probe all 
luns, see this options with the make menuconfig ( this is probably a 
stupid remark but in case of ).
If you have an offset on the connection of your linux boxe's and they 
are probably another system on the ema12000, the unit offset on a 
connection allow to present the device to your system with lun 0 ( if 
the Command Console Lun is disable ) lun 1, lun 2 ... make sure the unit 
offset above LUN 7 are right because if you have a unit for exemple D110 
with a unit offset 120 the result for the lun presentation is :
unit D110, unit offset connection 120, 110 - 120 = -10, your unit arrive 
with a LUN equal to -10. The driver doesn't like that and you don't see 
the unit.
If the controler is configured for transparent failover ( make a show 
this and a show other on each controler you must have a stanby port and 
an active port ) make sure your unit is not greatter than 99, your last 
unit must be D99, because in transparent failover the unit must be in 0 
to 99 ( D0 if you don't have the command console lun disable but it is 
recommended to not use D0 ) D1 to D99, if you unit after D99 i don't 
remenber but i think the controler refused to attribute a unit with 
D100, this is a functionnality and a limitation of the transparent 
failover, because in case of failure on "this controler" all unit are 
transfered on the "other controler" and the "other controler" become 
"this controler" with the same wwn.
If the controler is configured for multibus failover check the unit 
offset and check where the unit after LUN 7 are presented ( check the 
port on the controler you use sho unit full or show unit DXX and look 
where the unit is ONLINE ), check your zoning on your san switch make 
sure you have the right controler port and the right qlogic card ( you 
can check this with the world wide name on each device, qla card, port 
controler).
I hope that help you, and if you more information about your EMA is 
better for helping you.
A tip if you have 2 qlogics on your DL380 you can use the qlogic driver 
that support a card failover the name of this driver have "FO". Is 
interesting for fault tolerance on your system, because the failover on 
the controler is not supported by the qlogic driver at this time... If 
the driver have this functionality this is probably the end of HP secure 
path on linux, if you have free why pay.

A+
phil

