From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v4 1/2] libahci: Add support to handle HOST_IRQ_STAT as
 edge trigger latch.
Date: Tue, 5 May 2015 23:18:09 +0530
Message-ID: <CAOHikRAnS1+c4K0thYN9HxwJD1b7FiDE87xi8eBi=uA3XCyv2A@mail.gmail.com>
References: <1430838822-17507-1-git-send-email-stripathi@apm.com>
	<1430838822-17507-2-git-send-email-stripathi@apm.com>
	<20150505170440.GW1971@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og125.obsmtp.com ([64.18.0.245]:44412 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760661AbbEERsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 13:48:11 -0400
Received: by wgso17 with SMTP id o17so191992679wgs.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2015 10:48:09 -0700 (PDT)
In-Reply-To: <20150505170440.GW1971@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

Hi Tejun,

On Tue, May 5, 2015 at 10:34 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Suman.
>
> Looks pretty.  Some nitpicks.
>
> On Tue, May 05, 2015 at 08:43:41PM +0530, Suman Tripathi wrote:
>> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
>> index 71262e0..2df2237 100644
>> --- a/drivers/ata/ahci.h
>> +++ b/drivers/ata/ahci.h
>> @@ -238,6 +238,8 @@ enum {
>>       AHCI_HFLAG_MULTI_MSI            = (1 << 16), /* multiple PCI MSIs */
>>       AHCI_HFLAG_NO_DEVSLP            = (1 << 17), /* no device sleep */
>>       AHCI_HFLAG_NO_FBS               = (1 << 18), /* no FBS */
>> +     AHCI_HFLAG_EDGE_TRIG_IRQ        = (1 << 19), /* HOST_IRQ_STAT behaves as
>> +                                                     Edge Triggered */
>
> Let's just name it ahci_HFLAG_EDGE_IRQ.

Sure

>
>> +static irqreturn_t ahci_level_trig_intr(int irq, void *dev_instance)
>
> ahci_single_level_irq_intr()
>
>> +{
> ...
>> @@ -1877,13 +1885,51 @@ static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
>>        * Also, use the unmasked value to clear interrupt as spurious
>>        * pending event on a dummy port might cause screaming IRQ.
>>        */
>> +
>
> Extra newline which wasn't there before.

sorry . Happened mistakenly

>
>> +     writel(irq_stat, mmio + HOST_IRQ_STAT);
>> +
>> +     spin_unlock(&host->lock);
>> +
>> +     VPRINTK("EXIT\n");
>> +
>> +     return IRQ_RETVAL(rc);
>> +}
>> +
>> +static irqreturn_t ahci_edge_trig_intr(int irq, void *dev_instance)
>
> ahci_single_edge_irq_intr()

Sure.

>
> And let's please separate refactoring of intr routine and addition of
> edge irq handling into two patches.

Okay


>
> Thanks.
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
