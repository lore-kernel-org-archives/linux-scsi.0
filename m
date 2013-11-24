From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Sun, 24 Nov 2013 20:35:11 +0100
Message-ID: <201311242035.11411.arnd@arndb.de>
References: <1385014298-15700-1-git-send-email-lho@apm.com> <201311211401.14836.arnd@arndb.de> <CAPw-ZTnt0QnXxb_dkDpkXbz4xFOcMM2Z-oOVJdH9o9u3S+DuPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPw-ZTnt0QnXxb_dkDpkXbz4xFOcMM2Z-oOVJdH9o9u3S+DuPg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Sunday 24 November 2013, Loc Ho wrote:
> 
> > > +struct xgene_ahci_context {
> > > +     struct ahci_host_priv  hpriv;
> > > +     struct device *dev;
> > > +     int irq;                /* IRQ */
> > > +     void __iomem *csr_base; /* CSR base address of IP */
> > > +     u64 csr_phys;           /* Physical address of CSR base address */
> > > +     void __iomem *mmio_base; /* AHCI I/O base address */
> > > +     u64 mmio_phys;          /* Physical address of MMIO base address */
> > > +     void __iomem *ahbc_csr_base; /* Used for IOB flushing if non-zero
> > */
> > > +     void __iomem *ahbc_io_base;  /* Used for IOB flushing if non-zero *
> >
> > I still think the flushing should be split out into a separate subsystem
> > of some
> > sort, or into common code. Can you explain why it is needed in this
> > driver, and
> > what other parts of your SoC also need to do the same thing?
> >
> [Loc Ho]
> Due to HW bug, the read to flush does not function properly with the SATA
> and SD IP's. For this reason, to ensure that data has reached the DDR after
> reading the CI register of the AHCI, we need to flush the bus. This will
> ensure data for the corresponding CI bit are available before the SATA
> upper layer consumed the data. The chance of this happen is extremely lower
> but this will ensure 100% data consistency. As the SD IP is single
> operation at a time, it will never need this. Also, if it does, by enable
> the feature itself, any read on the SD register is enough to handle the bus
> flush. So, SD don't needs this as SATA will enable it. This will not be fix
> in the first generation of the chip and this explicit flush is required for
> SATA.
> 
> 
> >
> > Maybe we can have custom dma_map_ops for your platform so the flushing
> > automatically
> > happens in dma_unmap_sg().
> >
> [Loc Ho]
> We don't want this for other IP as it will affact performance for the other
> IP's.

The dma_map_ops can be set per device, so it would still be possible to do,
but if the AHCI is the only one that needs it, I guess it makes
sense to do it the currect way.

> > > +static void xgene_wr_flush(void *addr, u32 val)
> > > +{
> > > +     writel(val, addr);
> > > +     pr_debug("X-Gene SATA CSR WR: 0x%p value: 0x%08x\n", addr, val);
> > > +     val = readl(addr);
> > > +}
> >
> > This seems to be a rather expensive operation. Can you explain what the
> > extra
> > flush is trying to achieve here? Normally you'd want to eliminate any
> > readl()
> > from high-performance device drivers if you can. Is this used in any fast
> > path?
> >
> [Loc Ho]
> This is only for configuration barrier. Will not be used for IO.

Ok.

> > > +static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
> > > +{
> > > +     void *diagcsr = ctx->csr_base + SATA_DIAG_OFFSET;
> > > +     int timeout;
> > > +     u32 val;
> > > +
> > > +     xgene_rd(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR, &val);
> > > +     if (val == 0) {
> > > +             dev_dbg(ctx->dev, "memory already released from
> > shutdown\n");
> > > +             return 0;
> > > +     }
> > > +     dev_dbg(ctx->dev, "Release memory from shutdown\n");
> > > +     /* SATA controller memory in shutdown. Remove from shutdown. */
> > > +     xgene_wr_flush(diagcsr + REGSPEC_CFG_MEM_RAM_SHUTDOWN_ADDR, 0x00);
> > > +     timeout = SATA_RESET_MEM_RAM_TO;
> > > +     do {
> > > +             xgene_rd(diagcsr + REGSPEC_BLOCK_MEM_RDY_ADDR, &val);
> > > +             if (val != 0xFFFFFFFF)
> > > +                     udelay(1);
> > > +     } while (val != 0xFFFFFFFF && timeout-- > 0);
> >
> > With SATA_RESET_MEM_RAM_TO == 100000, this is an awfully long busy-loop.
> > Can you replace the udelay with usleep_range() providing a reasonable
> > wide range, and the replace the retry count with a time_before(jiffies(),
> > timeout) comparision?
> >
> [Loc Ho]
> I reduce to 1000. It only takes about one or two reads.

It's still over two miliseconds for the (unlikely) timeout in that case,
plus the time it takes to do the 1000 reads. The important part of my
comment was about using usleep_range(), which lets another process run
in the meantime rather than blocking the CPU.

If you want to keep using a retry count rather than a timeout, don't
call it "timeout".

> > > +/* Flush the IOB to ensure all SATA controller writes completed before
> > > +   servicing the completed command. This is needed due to the
> > possibility
> > > +   that interrupt serviced before the data actually written to the
> > cache/DDR.
> > > +   Writes from the IP to the CPU domain is not synchronized with the IRQ
> > > +   line or the IP core toggled the CI bits before the data write
> > completed. */
> > > +static int xgene_ahci_iob_flush(struct xgene_ahci_context *ctx)
> > > +{
> > > +     if (ctx->ahbc_io_base)
> > > +             readl(ctx->ahbc_io_base);
> > > +     return 0;
> > > +}
> >
> > Normally the synchronization should be guaranteed by using MSI interrupts
> > rather than edge or level interrupt pins. Do you have MSI support in your
> > hardware? Using that would get rid of this ugly hack and likely improve
> > performance significantly.
> >
> [Loc Ho]
> The SATA IP is built into the chip and NOT on the PCIe bus. The need for
> this is already mentioned above.

I don't understand the comment about PCIe. MSI should work regardless of
where the device resides in the system, unless you have the MSI controller
integrated into the PCIe host, which would be a bug because it causes the
same problem that you have on this device for any PCIe add-on device
(the MSI would no longer flush the a PCIe bus master DMA transfer
all the way to memory if the message is consumed by the PCIe host).

	Arnd
