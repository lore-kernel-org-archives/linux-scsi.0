From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v3] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_SMART PIO mode command.
Date: Tue, 3 Feb 2015 21:42:48 +0530
Message-ID: <CAOHikRCnDTQXrfZB6yYSvFpDpiRi68yM2WS8nw5PB0UEM9ZQZw@mail.gmail.com>
References: <1422900439-5541-1-git-send-email-stripathi@apm.com>
	<1422900439-5541-2-git-send-email-stripathi@apm.com>
	<54CFCC28.6050609@cogentembedded.com>
	<CAOHikRBMPbyS0q6814+Xkez7ToBwrC7Yzp4sy=NMmPDg-5wCBA@mail.gmail.com>
	<54CFD38F.2060803@cogentembedded.com>
	<CAOHikRDZ-xxBxT_jr44HmKiDHfn2Q1K0ihbNDH-6LvYaq08=gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og122.obsmtp.com ([64.18.0.192]:50262 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965888AbbBCQMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 11:12:50 -0500
Received: by mail-yh0-f44.google.com with SMTP id i57so18865614yha.3
        for <linux-scsi@vger.kernel.org>; Tue, 03 Feb 2015 08:12:49 -0800 (PST)
In-Reply-To: <CAOHikRDZ-xxBxT_jr44HmKiDHfn2Q1K0ihbNDH-6LvYaq08=gw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

   Ugh, please avoid using HTML when posting to the lists hosted on
vger.kernel.org -- it's configured to ignore such mails AFAIK.
Yeah forgot to set the plain text mode. Sorry for that

>>>     This patch addresses the issue with ATA_CMD_SMART pio mode
>>>     command for enumeration and device detection with ATA devices.
>>>     The X-Gene AHCI controller has an errata in which it cannot clear
>>>     the BSY bit after the PIO setup FIS. The dma state machine enters


>>     Hum, if this happens after every PIO command (PIO setup FISes are not
>> specific to the command, right?), perhaps it would make more sense to record
>> the *protocol* used by the last command?


> No it happens for IDENTIFY DEVICE, ATA_CMD_PACKET and ATA_CMD_SMART commands .
> It is actually the commands associated with a BSY bit clearing.


   I don't understand that -- BSY bit is cleared for *every* command,
either at the end of it, or along with setting the DRQ bit for PIO
data transfer.
BSY bit is cleared after the end of these commands by the controller.
So due to the bug it doesn't clear it. When the DMA commands is issued
, it check for the BSY bit cleared or not and finds not cleared and
results in CMFatalErrorUpdate  and hangs.

Ping ?? Any problem with this last posted version  Actually Mark from
redhat reported this issue while using smartctl and we found that
ATA_CMD_SMART also has BSY bit not clearing issue..

On Tue, Feb 3, 2015 at 1:18 AM, Suman Tripathi <stripathi@apm.com> wrote:
>    Ugh, please avoid using HTML when posting to the lists hosted on
> vger.kernel.org -- it's configured to ignore such mails AFAIK.
> Yeah forgot to set the plain text mode. Sorry for that
>
>>>>     This patch addresses the issue with ATA_CMD_SMART pio mode
>>>>     command for enumeration and device detection with ATA devices.
>>>>     The X-Gene AHCI controller has an errata in which it cannot clear
>>>>     the BSY bit after the PIO setup FIS. The dma state machine enters
>
>
>>>     Hum, if this happens after every PIO command (PIO setup FISes are not
>>> specific to the command, right?), perhaps it would make more sense to record
>>> the *protocol* used by the last command?
>
>
>> No it happens for IDENTIFY DEVICE, ATA_CMD_PACKET and ATA_CMD_SMART commands .
>> It is actually the commands associated with a BSY bit clearing.
>
>
>    I don't understand that -- BSY bit is cleared for *every* command,
> either at the end of it, or along with setting the DRQ bit for PIO
> data transfer.
> BSY bit is cleared after the end of these commands by the controller.
> So due to the bug it doesn't clear it. When the DMA commands is issued
> , it check for the BSY bit cleared or not and finds not cleared and
> results in CMFatalErrorUpdate  and hangs.
>
>>>>     CMFatalErrorUpdate state and locks up. It is the same issue as
>>>>     in the commit 2a0bdff6b958d1b2523d2754b6cd5e__0ea4053016 (ahci-xgene:
>>>>     fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
>>>>     command).
>
>
>>> [...]
>
>
>>>>     Signed-off-by: Suman Tripathi <stripathi@apm.com <mailto:stripathi@apm.com>>
>>>>     Reported-by:   Mark Langsdorf <mlangsdo@redhat.com
>>>>     <mailto:mlangsdo@redhat.com>>
>>>>
>
> MBR, Sergei
>
> On Tue, Feb 3, 2015 at 1:14 AM, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
>> On 02/02/2015 10:37 PM, Suman Tripathi wrote:
>>
>>    Ugh, please avoid using HTML when posting to the lists hosted on
>> vger.kernel.org -- it's configured to ignore such mails AFAIK.
>>
>>>>>     This patch addresses the issue with ATA_CMD_SMART pio mode
>>>>>     command for enumeration and device detection with ATA devices.
>>>>>     The X-Gene AHCI controller has an errata in which it cannot clear
>>>>>     the BSY bit after the PIO setup FIS. The dma state machine enters
>>
>>
>>>>     Hum, if this happens after every PIO command (PIO setup FISes are not
>>>> specific to the command, right?), perhaps it would make more sense to
>>>> record
>>>> the *protocol* used by the last command?
>>
>>
>>> No it happens for IDENTIFY DEVICE, ATA_CMD_PACKET and ATA_CMD_SMART
>>> commands .
>>> It is actually the commands associated with a BSY bit clearing.
>>
>>
>>    I don't understand that -- BSY bit is cleared for *every* command, either
>> at the end of it, or along with setting the DRQ bit for PIO data transfer.
>>
>>>>>     CMFatalErrorUpdate state and locks up. It is the same issue as
>>>>>     in the commit 2a0bdff6b958d1b2523d2754b6cd5e__0ea4053016
>>>>> (ahci-xgene:
>>>>>     fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
>>>>>     command).
>>
>>
>>>> [...]
>>
>>
>>>>>     Signed-off-by: Suman Tripathi <stripathi@apm.com
>>>>> <mailto:stripathi@apm.com>>
>>>>>     Reported-by:   Mark Langsdorf <mlangsdo@redhat.com
>>>>>     <mailto:mlangsdo@redhat.com>>
>>>>>
>>
>> MBR, Sergei
>>
>
>
>
> --
> Thanks,
> with regards,
> Suman Tripathi



-- 
Thanks,
with regards,
Suman Tripathi
