From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] mptfusion - fc transport attributes - REVISED
Date: Fri, 13 Jan 2006 12:18:03 -0600
Message-ID: <43C7EEDB.3010802@sgi.com>
References: <43C6E06D.7090609@sgi.com> <20060113103106.GA11553@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.26]:37820 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1422745AbWAMSSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:18:14 -0500
In-Reply-To: <20060113103106.GA11553@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Hickerson, Roger" <roger.hickerson@lsil.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>



Christoph Hellwig wrote:
>>+	int			 count=400;
>>+
> 
> 	Please add a space before and after the '='  Same things in various
> 	other places all over the patch.

OK.

> 
>>+			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
> 
> 	Please make sure you don't add lines longer than 80 characters.

This driver is full of lines longer than 80 characters....  I'll see what I can
do.  I'm not planning on reworking the entire driver to shorten the line lengths
but if there are obvious places in my patch, like above, I'll do what I can to
conform.

I suspect it should be a separate patch to clean up all the white space / style/long line / other issues in this driver.  :)

> 
>>+				if (count-- > 0) {
>>+					msleep_interruptible(100);
>>+					goto try_again;
>>+				}
>>+				else
> 
> should be
> 
> 				} else

OK

> 
>>+#define MPT_RPORT_INFO_FLAGS_REGISTERED		0x01	/* rport registered */
>>+#define	MPT_RPORT_INFO_FLAGS_MISSING		0x02	/* missing from DevPage0 scan */
> 
> 	should also use a space after the #define, and again lines
> 	longer than 80 chars (and quite a few times more later in the
> 	patch)

OK.

> 
>>+
>>+	union {
>> 	struct list_head	 sas_topology;
>>+	struct list_head	 fc_rports;	/* list of wwpn / sdev target / rport ptr */
>>+	} l;
>>+
>>+	spinlock_t		 fc_rport_lock;	/* for all accesses of list and ri flags */
>>+
>>+	spinlock_t		 work_lock;
>>+	int			 work_count;
>>+	struct work_struct	 work_task;	/* for use by personality, i.e., fc, sas, spi, lan */
> 
> 	Please don't make this a union yet.  There's too much work going on
> 	in the SAS area and this would cause conflicts all over.  We can
> 	move to the union later on ones all the major pending changes have
> 	settled.

OK.

> 
>>+int mptfc_slave_alloc(struct scsi_device *device);
>>+static int mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *));
>>+static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
>>+static void __devexit mptfc_remove(struct pci_dev *pdev);
> 
> 	Please try to order functions so that forward-prototypes aren't
> 	needed.  (where easily possible)

In this case, most references are needed for the scsi_host_template
or the fc_function_template and I'm chosing to not move those function
templates.

> 
> 
>>+	.get_starget_node_name = NULL,
> 
> 	no need to initialize unused memembers of static structures to zero.

Agreed.

> 
>>+	p_p0 = p0_array =  kmalloc(data_sz,GFP_KERNEL);
>>+	if (!p0_array)
>>+		goto out;
>>+	memset((u8 *)p0_array, 0, data_sz);
>>+
>>+	data_sz = sizeof(FCDevicePage0_t *) * max_bus * max_targ;
>>+	p_pp0 = pp0_array = kmalloc(data_sz,GFP_KERNEL);
>>+	if (!pp0_array)
>>+		goto out;
>>+	memset((u8 *)pp0_array, 0, data_sz);
> 
> 	just use kzalloc in those two cases.
OK

> 	also please a whitespace after the , in arguments.
OK

> 
>>+		if (hdr.PageLength <= 0)
>>+			break;
>>+		else {
> 
> 	no need for the else here, the break already jumps out of the loop.
> 	and the lesser indentation should make the code quite a lot more
> 	readable aswell.

Nice catch.

> 
>>+			data_sz = hdr.PageLength * 4;
>>+			ppage0_alloc = (FCDevicePage0_t *) 
>>+ 					pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
> 
> 	mo need to cast the return value of pci_alloc_consistent.

OK

> 
> 
>>+			rc = -ENOMEM;
>>+			if (ppage0_alloc) {
> 
> 	just break out of the loop in the !ppage0_alloc case, reduces
> 	indentation again and makes the code fit into 80 columes.

OK

> 
>>+				memset((u8 *)ppage0_alloc, 0, data_sz);
> 
> 	pci_alloc_consistent returns zeroed memory.

OK

> 
> +				if ((rc = mpt_config(ioc, &cfg)) == 0) {
> +					le32_to_cpus(ppage0_alloc->PortIdentifier);
> +					le32_to_cpus(ppage0_alloc->WWNN.Low);
> +					le32_to_cpus(ppage0_alloc->WWNN.High);
> +					le32_to_cpus(ppage0_alloc->WWPN.Low);
> +					le32_to_cpus(ppage0_alloc->WWPN.High);
> +					le16_to_cpus(ppage0_alloc->BBCredit);
> +					le16_to_cpus(ppage0_alloc->MaxRxFrameSize);
> 
> 	please never use leXX_to_cpus but always leXX_to_cpu and assign to
> 	a separate variable.  Assigning hardware endian and host endian
> 	values to the same value defeats static typechecking with sparse.

OK

> 
>>+		ri = kmalloc(sizeof(struct mptfc_rport_info), GFP_KERNEL);
>>+ 		if (!ri)
>>+			return;
>>+		memset(ri, 0, sizeof(struct mptfc_rport_info));
> 
> 	case use kzalloc, too.
> 
>>+	INIT_WORK(&ioc->work_task, mptfc_rescan_devices,(void *)ioc);
> 
> 	could you calls this ioc->fc_rescan_work?  also no need for the
> 	void cast.

I had intended to create a "generic" work_task structure that could be
used by all personalities of the driver as, AFAIK, only one will
own an hba.  However, I understand the point and will change it.  If
this is important enough to me, I can make it a union later once the
dust settles.

> 
> @@ -332,6 +784,7 @@
>  	hd->scandv_wait_done = 0;
>  	hd->last_queue_full = 0;
>  
> +	sh->transportt = mptfc_transport_template;
>  	error = scsi_add_host (sh, &ioc->pcidev->dev);
>  	if(error) {
>  		dprintk((KERN_ERR MYNAM
> @@ -339,7 +792,11 @@
>  		goto out_mptfc_probe;
>  	}
>  
> -	scsi_scan_host(sh);
> +	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
> +		mptfc_init_host_attr(ioc,ii);
> +		mptfc_GetFcDevPage0(ioc,ii,mptfc_register_dev);
> +	}
> +
>  	return 0;
>  
>  out_mptfc_probe:
> 
>>+++ linux-2.6.15-git8-mdr/drivers/message/fusion/mptscsih.c	2006-01-12 16:09:08.000000000 -0600
>>@@ -58,6 +58,7 @@
>> #include <linux/workqueue.h>
>> 
>> #include <scsi/scsi.h>
>>+#include <scsi/scsi_transport_fc.h>
> 
> 	you must only use transport-class infrastructure in the per-transport
> 	files, but not in the common ones.

Another good catch.  This was left over from earlier code and not needed.

> 
> 
> 
> also don't we need a slave_destroy menthod, as in the SAS hotplug patches?
> And you should probably remove the scsi_scan_host call as all additions
> should be done through the FC transport class functionality.

I looked at your patch to mptsas for slave_destroy.  I believe that since the
fc_transport retains rport info for the case when the rport returns
after destroy, that mptfc should retain its data structure.

I'll think about this for a subsequent patch.  It's on my white board!
(No software is ever finished!)


scsi_scan_host was a delete, not an insert point....

> 

A revised patch will be forthcoming.

Mike

