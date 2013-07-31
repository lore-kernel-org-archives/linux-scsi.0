From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Wed, 31 Jul 2013 19:11:07 +0200
Message-ID: <20130731171106.GA12489@dhcp-26-207.brq.redhat.com>
References: <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
 <20130719003034.GG28005@kernel.dk>
 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <20130722150359.GA16564@dhcp-26-207.brq.redhat.com>
 <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 25, 2013 at 12:16:41PM +0200, Alexander Gordeev wrote:
> On Mon, Jul 22, 2013 at 02:10:36PM -0700, Nicholas A. Bellinger wrote:
> > Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
> > target-pending/scsi-mq, which now has functioning scsi-generic support.
> 
> Survives a boot, a kernel build and the build's result :)

Not that rosy. Turned out the old code is called. Hangs with this hunk..

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ac05cd6..a75fd41 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1103,6 +1103,8 @@ static struct device_attribute *piix_sidpr_shost_attrs[] = {
 static struct scsi_host_template piix_sidpr_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 	.shost_attrs		= piix_sidpr_shost_attrs,
+	.scsi_mq		= true,
+	.queuecommand_mq	= ata_scsi_queuecmd,
 };
 
 static struct ata_port_operations piix_sidpr_sata_ops = {


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
