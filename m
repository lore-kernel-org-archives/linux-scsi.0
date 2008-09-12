From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH scsi-rc-fixes] qla2xxx: Defer enablement of RISC interrupts
	until ISP initialization completes.
Date: Thu, 11 Sep 2008 22:19:45 -0700
Message-ID: <20080912051945.GB76313@plap4-2.local>
References: <20080909143932.GA27117@orion.carnet.hr> <20080911113727.GA24487@orion.carnet.hr> <20080911215727.GA12885@orion.carnet.hr> <20080911.150150.256816031.davem@davemloft.net> <20080911221543.GQ66567@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080911221543.GQ66567@plap4-2.local>
Sender: sparclinux-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: joy@entuzijast.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

Josip Rodin noted
(http://article.gmane.org/gmane.linux.ports.sparc/10152) the
driver oopsing during registration of an rport to the
FC-transport layer with a backtrace indicating a dereferencing of
an shost->shost_data equal to NULL.  David Miller identified a
small window in driver logic where this could happen:

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
    >         qla_printk(KERN_INFO, ha, "\n"
    >             " QLogic Fibre Channel HBA Driver: %s\n"
    >             "  QLogic %s - %s\n"
    >             "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
    >  ...
    >
    > message yet.
    >
    > Which means that the crash occurs between qla2x00_request_irqs()
    > and printing that message.

Close this window by enabling RISC interrupts after the host has
been registered with the SCSI midlayer.

Reported-by: Josip Rodin <joy@entuzijast.net>
Cc: Stable Tree <stable@kernel.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 -
 drivers/scsi/qla2xxx/qla_os.c  |    2 ++
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e50752e..fc4bfa7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1837,7 +1837,6 @@ clear_risc_ints:
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
-- 
1.6.0.1.267.gec3a

