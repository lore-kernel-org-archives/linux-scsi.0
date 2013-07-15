From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: The pm80xx driver hangs in 3.10 with the Adaptec 71605H HBA
Date: Mon, 15 Jul 2013 10:53:41 +0200
Message-ID: <51E3B895.9010400@gmail.com>
References: <201307121302.06856.hansverk@cisco.com> <CAD+HZHUc7wULDUpKq24rmcVC9MCcgaoO4i1LxGcW-q-y-c3tcQ@mail.gmail.com> <201307121419.50786.hansverk@cisco.com> <E5DEE6F468524847995699AD11E8088501B28CAA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <51E2651F.1040905@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40256 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3GOIxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 04:53:09 -0400
Received: by mail-bk0-f45.google.com with SMTP id je9so4470511bkc.32
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2013 01:53:08 -0700 (PDT)
In-Reply-To: <51E2651F.1040905@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, lindar_liu <lindar_liu@usish.com>, linux-scsi@vger.kernel.org, jinpu.wang@profitbricks.com

Hi Hans,
On 07/14/2013 10:45 AM, Hans Verkuil wrote:
> Hi Anand,
> 
> On 07/12/2013 03:14 PM, Anand Kumar Santhanam wrote:
>> Hans,
>>
>> I reviewed the code changes and I did not see major differences except
>> for the fact that in adaptec driver we have 64 interrupt handlers to
>> handle 64 MSI-X.
>> This was optimized in open src driver to use only 1 interrupt handler.
>> Can you pls make this change to the open src driver (i.e have multiple
>> interrupt handlers for multiple MSI-X) and check?
> 
> I've looked at this more closely, and I wonder whether there isn't a race condition
> here. When an interrupt arrives you put the interrupt vector in pm8001_ha->int_vector,
> then schedule the tasklet. But what if two interrupts with different vectors arrive
> in quick succession before the tasklet got a chance to run? In that case the tasklet
> will only see the second vector, not the first. Rather scary.
> 
> I have not actually seen any issues with this, but by definition race conditions are
> hard to reproduce and I haven't done any serious testing with this card. For now I
> will run with the quick and dirty msi.diff (http://hverkuil.home.xs4all.nl/msi.diff).
> 
> I see two solutions: either use the 64 interrupt handlers as done in the adaptec
> driver, or you can change int_vector into a u64 and use it as a bitmask to record
> all interrupt vectors that have arrived.
Thanks for looking into this, I think second one is what we want, set
the bitmask when interrupt arrived and clear it when it's processed.

> 
> BTW, another difference between the linux kernel driver and the adaptec version are
> several of the defines in pm8001_defs.h: e.g. MPI_QUEUE is 256 in the adaptec driver,
> while it is 1024 in the kernel driver. There are other differences as well.
> 
Different value may reflect different performance character, but both
should works, there is no one for all setting.

> Are all the changes in the kernel correct? I would like to have a confirmation of
> that before I am going to trust my data to this driver.
> 
> It clearly hasn't been tested with actual hardware :-(
> 
:_(

Thanks,
Jack

> Regards,
> 
> 	Hans
> 

