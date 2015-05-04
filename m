From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v3 1/2] libahci: Add support to handle HOST_IRQ_STAT as
 edge trigger latch.
Date: Mon, 4 May 2015 22:13:11 +0530
Message-ID: <CAOHikRCZimsE+_-6dqTiCT6qRTFLp9VGt6=WHWA_Z86GBn+WRg@mail.gmail.com>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com>
	<1430667220-23477-2-git-send-email-stripathi@apm.com>
	<20150504154726.GA1971@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20150504154726.GA1971@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 4, 2015 at 9:17 PM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, May 03, 2015 at 09:03:39PM +0530, Suman Tripathi wrote:
>> This patch adds the support to handle HOST_IRQ_STAT as edge trigger
>> latch.
> ...
>> +     /*
>> +      * HOST_IRQ_STAT behaves as edge trigger latch. When HOST_IRQ_STAT
>> +      * detects a egde from PORT_IRQ_STAT, it happens to loose interrupts
>> +      * when interrupts are triggered from both ports. So handling of
>> +      * the residual interrupt is required.
>> +      */
>> +     if (hpriv->flags & AHCI_HFLAG_EDGE_TRIG_IRQ) {
>> +             for (i = 0; i < host->n_ports; i++) {
>> +                     struct ata_port *ap;
>> +
>> +                     ap = host->ports[i];
>> +                     if (ap) {
>> +                             ahci_port_intr(ap);
>> +                             VPRINTK("Residual irq from port %u\n", i);
>> +                     }
>> +                     handled = 1;
>> +             }
>> +     }
>
> This is kinda gross.  The right thing do is clearing irq stat
> registers before handling the events, right?  That shouldn't be too
> difficult to implement.  Create a separate set of irq functions which
> clear irqs before processing rather than after.

AFAIK clearing host_irq_stat means we have handled port interrupts .
Now for our case we still have interrupts left because it didn't get
detected on
first ahci_port_intr.  So you  mean to handle that residual irq in the
next cycle (i mean next call intr handler ) ??

>
> Thanks.
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
