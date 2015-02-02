From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_SMART PIO mode command.
Date: Mon, 02 Feb 2015 22:44:15 +0300
Message-ID: <54CFD38F.2060803@cogentembedded.com>
References: <1422900439-5541-1-git-send-email-stripathi@apm.com>	<1422900439-5541-2-git-send-email-stripathi@apm.com>	<54CFCC28.6050609@cogentembedded.com> <CAOHikRBMPbyS0q6814+Xkez7ToBwrC7Yzp4sy=NMmPDg-5wCBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36954 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbbBBToU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 14:44:20 -0500
Received: by mail-la0-f46.google.com with SMTP id s18so44673068lam.5
        for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2015 11:44:18 -0800 (PST)
In-Reply-To: <CAOHikRBMPbyS0q6814+Xkez7ToBwrC7Yzp4sy=NMmPDg-5wCBA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

On 02/02/2015 10:37 PM, Suman Tripathi wrote:

    Ugh, please avoid using HTML when posting to the lists hosted on 
vger.kernel.org -- it's configured to ignore such mails AFAIK.

>>>     This patch addresses the issue with ATA_CMD_SMART pio mode
>>>     command for enumeration and device detection with ATA devices.
>>>     The X-Gene AHCI controller has an errata in which it cannot clear
>>>     the BSY bit after the PIO setup FIS. The dma state machine enters

>>     Hum, if this happens after every PIO command (PIO setup FISes are not
>> specific to the command, right?), perhaps it would make more sense to record
>> the *protocol* used by the last command?

> No it happens for IDENTIFY DEVICE, ATA_CMD_PACKET and ATA_CMD_SMART commands .
> It is actually the commands associated with a BSY bit clearing.

    I don't understand that -- BSY bit is cleared for *every* command, either 
at the end of it, or along with setting the DRQ bit for PIO data transfer.

>>>     CMFatalErrorUpdate state and locks up. It is the same issue as
>>>     in the commit 2a0bdff6b958d1b2523d2754b6cd5e__0ea4053016 (ahci-xgene:
>>>     fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
>>>     command).

>> [...]

>>>     Signed-off-by: Suman Tripathi <stripathi@apm.com <mailto:stripathi@apm.com>>
>>>     Reported-by:   Mark Langsdorf <mlangsdo@redhat.com
>>>     <mailto:mlangsdo@redhat.com>>
>>>

MBR, Sergei

