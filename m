From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [RFC PATCH 3/9] drivers: convert drivers setting the
 change_queue_depth callback
Date: Wed, 26 Aug 2009 14:50:13 -0700
Message-ID: <1251323413.9966.81.camel@vi2.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
	 <20090826180331.23396.77062.stgit@vi1.jf.intel.com>
	 <4A957CC3.6080605@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:22851 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753797AbZHZVuM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 17:50:12 -0400
In-Reply-To: <4A957CC3.6080605@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, michaelc@cs.wisc.edu
Cc: Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org

On Wed, 2009-08-26 at 14:19 -0400, Jeff Garzik wrote:
> On 08/26/2009 02:03 PM, Vasu Dev wrote:
> > From: Mike Christie<michaelc@cs.wisc.edu>
> >
> > This is a simple port of the drivers setting a change_queue_depth
> > callback but were not tracking queue fulls. In the patch I just have
> > these LLDs adjust the queue depth if the user was requesting it.
> 
> Where is the doc describing how, and why, queue-full tracking occurs?
> 

The FCP-3 sec 4.2 states "If command queueing resources are unavailable
in the logical unit when a command is received, the device server
returns TASK SET FULL status or BUSY status in the FCP_RSP IU as
specified by SAM-3". 

But this patch series is to move the QUEUE_FULL and then the ramp up
code from libfc, qla2xxx and lpfc drives to scsi-ml, the libfc had
QUEUE_FULL code to move up. This series is not to change how and why
part in current queue_full tracking and that was better described in
first RFC cover by Mike at
http://www.spinics.net/lists/linux-scsi/msg35959.html .

> 
> > diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> > index 86a4058..fb28be9 100644
> > --- a/drivers/ata/sata_nv.c
> > +++ b/drivers/ata/sata_nv.c
> > @@ -1963,7 +1963,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
> >   	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
> >
> >   	if (strncmp(model_num, "Maxtor", 6) == 0) {
> > -		ata_scsi_change_queue_depth(sdev, 1);
> > +		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_SYSFS_REQ);
> >   		ata_dev_printk(dev, KERN_NOTICE,
> >   			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
> >   	}
> 
> This queue depth change was clearly not requested via sysfs...
> 

Can be renamed as SCSI_QDEPTH_DEFAULT or SCSI_QDEPTH_NONE reason. What
do you think Mike ?

Added SCSI_QDEPTH_SYSFS_REQ is default reason code for other drivers
code impacted by addition of new reason parameter to existing
scsi_host_template->change_queue_depth(), then other non-FC driver
ignore any other reason code to keep their existing functionality intact
by this API change, so any generic reason name will work and Mike may
find more suitable common name for this.

	Thanks
	Vasu

