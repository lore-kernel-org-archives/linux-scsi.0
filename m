From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v4 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Sun, 24 Nov 2013 20:59:31 -0800
Message-ID: <CAPw-ZTnxu1EFaQzSuq5XwC8m7SQUQz7SP8u0Zva2rvheFzTa-Q@mail.gmail.com>
References: <1385014298-15700-1-git-send-email-lho@apm.com>
	<201311211401.14836.arnd@arndb.de>
	<CAPw-ZTnt0QnXxb_dkDpkXbz4xFOcMM2Z-oOVJdH9o9u3S+DuPg@mail.gmail.com>
	<201311242035.11411.arnd@arndb.de>
	<CAPw-ZTkBovLrQEk_CQzuw03t5P2N2ZecQhK8tkZQM0grGwPxSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPw-ZTkBovLrQEk_CQzuw03t5P2N2ZecQhK8tkZQM0grGwPxSA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

 Hi,

Resend in plain text as mailing list reject HTML format.

> > > > +static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
> > > > +{
> > > > +     void *diagcsr = ctx->csr_base + SATA_DIAG_OFFSET;
> > > > +     int timeout;
> > > > +     u32 val;
> > > > +
> > > > +     xgene_rd(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR, &val);
> > > > +     if (val == 0) {
> > > > +             dev_dbg(ctx->dev, "memory already released from
> > > shutdown\n");
> > > > +             return 0;
> > > > +     }
> > > > +     dev_dbg(ctx->dev, "Release memory from shutdown\n");
> > > > +     /* SATA controller memory in shutdown. Remove from shutdown. */
> > > > +     xgene_wr_flush(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR, 0x00);
> > > > +     timeout = SATA_RESET_MEM_RAM_TO;
> > > > +     do {
> > > > +             xgene_rd(diagcsr + REGSPEC_BLOCK_MEM_RDY_ADDR, &val);
> > > > +             if (val != 0xFFFFFFFF)
> > > > +                     udelay(1);
> > > > +     } while (val != 0xFFFFFFFF && timeout-- > 0);
> > >
> > > With SATA_RESET_MEM_RAM_TO == 100000, this is an awfully long busy-loop.
> > > Can you replace the udelay with usleep_range() providing a reasonable
> > > wide range, and the replace the retry count with a time_before(jiffies(),
> > > timeout) comparision?
> > >
> > [Loc Ho]
> > I reduce to 1000. It only takes about one or two reads.
>
> It's still over two miliseconds for the (unlikely) timeout in that case,
> plus the time it takes to do the 1000 reads. The important part of my
> comment was about using usleep_range(), which lets another process run
> in the meantime rather than blocking the CPU.
>
> If you want to keep using a retry count rather than a timeout, don't
> call it "timeout".
>
[Loc Ho]
I will give usleep_range a try.

>>
>> > > > +/* Flush the IOB to ensure all SATA controller writes completed before
>> > > > +   servicing the completed command. This is needed due to the
>> > > possibility
>> > > > +   that interrupt serviced before the data actually written to the
>> > > cache/DDR.
>> > > > +   Writes from the IP to the CPU domain is not synchronized with the IRQ
>> > > > +   line or the IP core toggled the CI bits before the data write
>> > > completed. */
>> > > > +static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
>> > > > +{
>> > > > +     if (ctx->ahbc_io_base)
>> > > > +             readl(ctx->ahbc_io_base);
>> > > > +     return 0;
>> > > > +}
>> > >
>> > > Normally the synchronization should be guaranteed by using MSI interrupts
>> > > rather than edge or level interrupt pins. Do you have MSI support in your
>> > > hardware? Using that would get rid of this ugly hack and likely improve
>> > > performance significantly.
>> > >
>> > [Loc Ho]
>> > The SATA IP is built into the chip and NOT on the PCIe bus. The need for
>> > this is already mentioned above.
>>
>> I don't understand the comment about PCIe. MSI should work regardless of
>> where the device resides in the system, unless you have the MSI controller
>> integrated into the PCIe host, which would be a bug because it causes the
>> same problem that you have on this device for any PCIe add-on device
>> (the MSI would no longer flush the a PCIe bus master DMA transfer
>> all the way to memory if the message is consumed by the PCIe host).
>
[Loc Ho]
The SATA IP does not support MSI as it is NOT an PCIe interface. The
interrupt line is just a direct line into the GIC similar to the UART.

-Loc
