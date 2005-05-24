From: Aldo Gavioli <aldo.gavioli@netstorage.it>
Subject: Re: sd driver
Date: Tue, 24 May 2005 13:58:13 +0200
Message-ID: <429316D5.6050000@netstorage.it>
References: <42919ABC.9030508@netstorage.it> <4292C7C4.2030204@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout08.attiva.biz ([85.37.16.6]:42003 "EHLO
	smtpout08.attiva.biz") by vger.kernel.org with ESMTP
	id S262003AbVEXL6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 07:58:17 -0400
In-Reply-To: <4292C7C4.2030204@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Gilbert,
thanks for your answer.
I'm thinking regarding your ideas which could be the best.
In any case I think that this behaviour is a malfunction of kernel 2.6.
We cannot denied to load different drivers than sd for type MOD.
This behaviour will generate other troubles in developper community.
Aldo

> Aldo Gavioli wrote:
>
>> Hello All,
>>
>> Hello All,
>> I'm trying to attach one proprietary SCSI driver for optical disk on 
>> kernel 2.6.
>> I noted that if sd attach the same device before, my driver will 
>> never be called in the probe function. How can I by-pass this 
>> situation ?
>> If anyone can help me I appreciate very much.
>
>
> Aldo,
> Upper Level Drivers (ULDs of which sd is one) discriminate
> on the basis of the peripheral device type returned by an
> INQUIRY. Currently sd_probe() takes control of TYPE_DISK
> (pdt=0x0) and TYPE_MOD (pdt=0x7 "Optical memory device")
> and will soon take control of TYPE_RBC.
>
> If the class of devices you are interested in is TYPE_MOD
> then (at least for testing) just comment out that bit of
> code in sd_probe().
>
> The st and osst (tape ULDs) co-operate to do a finer
> grain division of labour (see their respective *_probe()
> functions). These ULDs show you one way of solving the
> problem. Another way would be a kernel/module option
> to sd (and possibly other ULDs) telling it to leave
> device <h,c,t,l> (or better some world wide unique
> identifier) alone.
>
>
> As for Arjan's comment about extending sd to cope with
> your class of devices, recent experience with RBC devices
> indicates that such a move may not add to the coherency
> of the sd driver.
>
> Doug Gilbert
>
>
>
>
>
>


-- 
Aldo Gavioli
Product Manager
NetStorage Software s.r.l
Viale Europa,74 - 20090 Cusago (Milan) Italy - Web: www.netstorage.it 


