From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 1/3] scsi: arcmsr: Add driver module parameter
 msi_enable
Date: Fri, 24 Nov 2017 09:03:55 +0800
Message-ID: <1511485435.4370.19.camel@Centos6.3-64>
References: <1511400439.9832.19.camel@Centos6.3-64>
         <20171123104408.jkslvj2axy4svt4a@mwanda>
         <1511469909.4370.14.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511469909.4370.14.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-11-24 at 04:45 +0800, Ching Huang wrote:
> Hello Dan,
> 
> On Thu, 2017-11-23 at 13:44 +0300, Dan Carpenter wrote:
> > On Thu, Nov 23, 2017 at 09:27:19AM +0800, Ching Huang wrote:
> > > From: Ching Huang <ching2048@areca.com.tw>
> > > 
> > > Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.
> > > 
> > > Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> > > ---
> > > 
> > > diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> > > --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-23 14:29:26.000000000 +0800
> > > +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-23 16:02:28.000000000 +0800
> > > @@ -75,6 +75,10 @@ MODULE_DESCRIPTION("Areca ARC11xx/12xx/1
> > >  MODULE_LICENSE("Dual BSD/GPL");
> > >  MODULE_VERSION(ARCMSR_DRIVER_VERSION);
> > >  
> > > +static int msi_enable = 1;
> > > +module_param(msi_enable, int, S_IRUGO);
> >                                  ^^^^^^^
> > checkpatch.pl will complain that this should be 0444
> S_IRUGO value is 00444, defined in <linux/stat.h> -> <uapi/linux/stat.h>.
>      A. It will be not a issue.
> > 
> > > +MODULE_PARM_DESC(msi_enable, " Enable MSI interrupt(0 ~ 1), msi_enable=1(enable), =0(disable)");
> >                                  ^
> > Remove the extra space
> OK
> > 
> > > +
> > >  static int host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
> > >  module_param(host_can_queue, int, S_IRUGO);
> > >  MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024), default is 128");
> > > @@ -831,11 +835,15 @@ arcmsr_request_irq(struct pci_dev *pdev,
> > >  		pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
> > >  		flags = 0;
> > >  	} else {
> > > -		nvec = pci_alloc_irq_vectors(pdev, 1, 1,
> > > -				PCI_IRQ_MSI | PCI_IRQ_LEGACY);
> > > +		if (msi_enable == 1)
> > > +			nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
> > > +		else
> > > +			nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_LEGACY);
> > >  		if (nvec < 1)
> > >  			return FAILED;
> > 
> > I feel like we should try PCI_IRQ_MSI then if it fails we could fall
> > back to PCI_IRQ_LEGACY.  Originally, it worked like this and now it just
> > fails unless you toggle the module param.  It's a regression.
> update as below
> ---
> 		unsigned int irq_flag;
> 		irq_flag = PCI_IRQ_LEGACY;
> 		if (msi_enable == 1)
> 			irq_flag |= PCI_IRQ_MSI;
> 		nvec = pci_alloc_irq_vectors(pdev, 1, 1, irq_flag);
> > >  
> > > +		if (msi_enable == 1)
> > > +			pr_info("arcmsr%d: msi enabled\n", acb->host->host_no);
> > 
> > This printk could be improved.  Use dev_info(&pdev->dev, for a start.
> > I know that the other prints don't use this, but we could use it one
> > time then slowly add more users until more are using dev_info() than
> > pr_info() and then someone will decide to clean up the old users.
> update as below
> ---
> 		if (msi_enable == 1)
> 			dev_info(&pdev->dev, "msi enabled\n");
> 
> > 
> > regards,
> > dan carpenter
> > 
> 
Dan,.

This new patch apply to mkp/scsi.git 4.16/scsi-queue
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-23 14:29:26.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-24 15:16:20.000000000 +0800
@@ -75,6 +75,10 @@ MODULE_DESCRIPTION("Areca ARC11xx/12xx/1
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
+static int msi_enable = 1;
+module_param(msi_enable, int, S_IRUGO);
+MODULE_PARM_DESC(msi_enable, "Enable MSI interrupt(0 ~ 1), msi_enable=1(enable), =0(disable)");
+
 static int host_can_queue = ARCMSR_DEFAULT_OUTSTANDING_CMD;
 module_param(host_can_queue, int, S_IRUGO);
 MODULE_PARM_DESC(host_can_queue, " adapter queue depth(32 ~ 1024), default is 128");
@@ -831,11 +835,17 @@ arcmsr_request_irq(struct pci_dev *pdev,
 		pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
 		flags = 0;
 	} else {
-		nvec = pci_alloc_irq_vectors(pdev, 1, 1,
-				PCI_IRQ_MSI | PCI_IRQ_LEGACY);
+		if (msi_enable == 1) {
+			nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
+			if (nvec == 1) {
+				dev_info(&pdev->dev, "msi enabled\n");
+				goto msi_int1;
+			}
+		}
+		nvec = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_LEGACY);
 		if (nvec < 1)
 			return FAILED;
-
+msi_int1:
 		flags = IRQF_SHARED;
 	}
 
