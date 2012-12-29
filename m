From: Ron A <linux-scsi@itrefined.com>
Subject: Re: megaraid_sas: problem with specific hardware only with kernel
 3.2.5 and above
Date: Fri, 28 Dec 2012 17:10:15 -0700
Message-ID: <50DE34E7.2030407@itrefined.com>
References: <S1755061Ab2L2AAn/20121229000043Z+354@vger.kernel.org>
Reply-To: linux-scsi@itrefined.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.itrefined.com ([166.70.145.131]:13452 "EHLO
	mail.itrefined.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2L2AQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Dec 2012 19:16:09 -0500
Received: from localhost ([127.0.0.1] helo=mua01.itrefined.net)
	by mua01.itrefined.net with esmtp (Exim 4.71)
	(envelope-from <linux-scsi@itrefined.com>)
	id 1Tok03-0006ED-Ft
	for linux-scsi@vger.kernel.org; Fri, 28 Dec 2012 17:10:03 -0700
Received: from 173-165-129-125-utah.hfc.comcastbusiness.net ([173.165.129.125] helo=[10.99.10.200])
	by mua01.itrefined.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <linux-scsi@itrefined.com>)
	id 1Tok00-0006E4-Fs
	for linux-scsi@vger.kernel.org; Fri, 28 Dec 2012 17:10:00 -0700
In-Reply-To: <S1755061Ab2L2AAn/20121229000043Z+354@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

After 3 straight days of wrongly debugging the megaraid_sas source code, 
I believe I found the proper work-around/solution for this situation.

Setting linux kernel boot parameter pci=conf1 allows my Intel RAID 
Controller-RMS25PB080 (LSI 2208/Fusion based) to be detected, and the FW 
to transition to Ready state. Without this setting the Card FW responds 
only with 0xF0000000 Fault (Masked).

I found linux kernel series 3.0.0, properly discovered and used the RAID 
card. Things broke for me in kernel series 3.2.0, onward.  So there 
seems to be ?broken? PCI discovery on my Intel s2600 system, using the 
Intel/LSI 2208 card

My System Details:
Card PCI ID: 1000:005b
Card PCI description: LSI Logic / Symbios Logic MegaRAID SAS 2208 
[Thunderbolt] (rev 03) aka Fusion
Card Firmware Version: v23.9.0-0018 (most current to-date)
Card OEM: Intel RAID Module (Card) RMS25PB080 SAS
System Board: s2600CP - E5-2600 Xeon, LGA2011 Socket
System Firmware BIOS level: 01.06.0002 2012/11/15 (most current to-date)

Best Regards,
Ron Allred


> --
> Hello everyone, hello Michal,
>
> I can confirm and reproduce this issue on a different set of hardware:
>
> Intel S1200BTLR Mainboard
> LSI MegaRAID 9266-4i Raid-Controller
>
> I haven't tried using a kernel older than 3.2.5 so far, but with kernels
> 3.2.24 and 3.5.0 I get the following dmesg output:
>
> [    2.621164] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
> [    2.621179] megasas: 0x1000:0x005b:0x1000:0x9269: bus 1:slot 0:func 0
> [    2.621599] megasas: Waiting for FW to come to ready state
> [    2.621601] megasas: FW in FAULT state!!
>
> As a result I can't access any drives connected to the controller.
>
> Tested Controller firmwares: 23.7.0-0031, 23.7.0-0035 and 23.9.0-0015
> Tested Mainboard BIOSes: R0037 (BMC 1.14, FRUSDR 1.14)
>
> I contacted Intel and LSI support a while ago. Intel shot me down by
> telling me this wasn't their problem. LSI at least tried to resolve the
> issue but thus far failed to do so.
>
> Unfortunately I don't have access to the system on a day-to-day basis,
> but I will test eventual fixes as soon as I get the chance.
>
> ---
> Matthias Prager
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@xxxxxxxxxxxxxxx
> More majordomo info athttp://vger.kernel.org/majordomo-info.html

