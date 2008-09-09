From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Mon, 8 Sep 2008 18:35:57 -0700
Message-ID: <20080909013557.GD25591@plap4-2.qlogic.org>
References: <20080908211331.GC22598@plap4-2.qlogic.org> <20080908.142351.00296600.davem@davemloft.net> <20080908214932.GF22598@plap4-2.qlogic.org> <20080908.160820.20152853.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080908.160820.20152853.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: joy@entuzijast.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 08 Sep 2008, David Miller wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Mon, 8 Sep 2008 14:49:32 -0700
> 
> > Hmm...  Still looking...
> 
> Look at how the driver registers the IRQ handler before the host has
> been registered with the SCSI layer.
> 
> That leads to a window of time where the shost hasn't been setup
> fully, yet ISRs can come in and trigger DPC thread events, such as
> loop resyncs, which expect the transport area to be setup.
> 
> But it won't be setup, because scsi_add_host() hasn't finished yet.
> 
> Note that in Josip's crash log, we don't even see the
> 
> 	qla_printk(KERN_INFO, ha, "\n"
> 	    " QLogic Fibre Channel HBA Driver: %s\n"
> 	    "  QLogic %s - %s\n"
> 	    "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
>  ...
> 
> message yet.
> 
> Which means that the crash occurs between qla2x00_request_irqs()
> and printing that message.

Certainly possible, yes...

Josip, could you try out the following patch which defers enablement
of RISC interrupts until after scsi_add_host()?

Thanks, AV

---

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 45a3b93..bf41887 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1834,7 +1834,6 @@ clear_risc_ints:
 		WRT_REG_WORD(&reg->isp.hccr, HCCR_CLR_HOST_INT);
 	}
 	spin_unlock_irq(&ha->hardware_lock);
-	ha->isp_ops->enable_intrs(ha);
 
 fail:
 	return ret;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fcbcd44..3433441 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1739,6 +1739,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto probe_failed;
 
+	ha->isp_ops->enable_intrs(ha);
+
 	scsi_scan_host(host);
 
 	qla2x00_alloc_sysfs_attr(ha);
