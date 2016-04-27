From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v5] qla1280: Don't allocate 512kb of host tags
Date: Wed, 27 Apr 2016 13:09:35 -0700
Message-ID: <1461787775.2311.40.camel@linux.vnet.ibm.com>
References: <1461746932-123934-1-git-send-email-jthumshirn@suse.de>
	 <572096C4.4090705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:41394 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbcD0UJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2016 16:09:44 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Wed, 27 Apr 2016 16:09:43 -0400
In-Reply-To: <572096C4.4090705@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Michael Reed <mdr@sgi.com>, Laura Abbott <labbott@redhat.com>, Laurence Oberman <loberman@redhat.com>, Lee Duncan <lduncan@suse.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.4@suse.de

On Wed, 2016-04-27 at 12:39 +0200, Hannes Reinecke wrote:
> On 04/27/2016 10:48 AM, Johannes Thumshirn wrote:
> > The qla1280 driver sets the scsi_host_template's can_queue field to
> > 0xfffff
> > which results in an allocation failure when allocating the block
> > layer tags
> > for the driver's queues. This was introduced with the change for
> > host wide
> > tags in commit 64d513ac31b - "scsi: use host wide tags by default".
> > 
> > Reduce can_queue to MAX_OUTSTANDING_COMMANDS (512) to solve the
> > allocation
> > error.
> > 
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Fixes: 64d513ac31b - "scsi: use host wide tags by default"
> > Cc: stable@vger.kernel.org # v4.4
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: Michael Reed <mdr@sgi.com>
> > Reviewed-by: Laurence Oberman <loberman@redhat.com>
> > Reviewed-by: Lee Duncan <lduncan@suse.com>
> > ---
> > Changes to v4:
> > * Make subject more meaningfull
> > * Remove warning's backtrace
> > * Re-add reference to commit  64d513ac31b - "scsi: use host wide
> > tags by default"
> > 
> > Changes to v3:
> > * Use  MAX_OUTSTANDING_COMMANDS insted of hard coded magical number
> > 
> > Changes to v2:
> > * Change can_queue to 512 upon James' request
> > 
> >  drivers/scsi/qla1280.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> > index 5d0ec42..634254a 100644
> > --- a/drivers/scsi/qla1280.c
> > +++ b/drivers/scsi/qla1280.c
> > @@ -4214,7 +4214,7 @@ static struct scsi_host_template
> > qla1280_driver_template = {
> >  	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
> >  	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
> >  	.bios_param		= qla1280_biosparam,
> > -	.can_queue		= 0xfffff,
> > +	.can_queue		= MAX_OUTSTANDING_COMMANDS,
> >  	.this_id		= -1,
> >  	.sg_tablesize		= SG_ALL,
> >  	.use_clustering		= ENABLE_CLUSTERING,
> > 
> Hmm.
> 
> The driver has this:
> 
	
> ha->request_ring = pci_alloc_consistent(ha->pdev,
> 			((REQUEST_ENTRY_CNT + 1) * sizeof(request_t)),
> 			&ha->request_dma);
> 
> and
> 
> /* ISP request and response entry counts (37-65535) */
> #define REQUEST_ENTRY_CNT	255 /* Number of request entries. */
> #define RESPONSE_ENTRY_CNT	63  /* Number of response entries.
> */
> 
> IE the driver (as it stands currently) will never be able to queue
> more than 255 requests.
> So where's the point in setting can_queue to 512? Shouldn't we
> rather use 255 here?

Because that's for the request/response message ring.  You don't keep a
request allocated while the command is outstanding, you send a request
message with the command handle (the index into the outstanding_cmds
array) and a pointer to the command and get a response back when the
firmware accepts it (at which time you can re-use the request).

You eventually get a completion interrupt with MBA_SCSI_COMPLETION and
a handle number (index into the outstanding_cmds array) when the host
is done with the command.

James

