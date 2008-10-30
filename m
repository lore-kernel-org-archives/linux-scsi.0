From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [dm-devel] i/o error due to all path failure with rdac
Date: Thu, 30 Oct 2008 16:35:29 -0700
Message-ID: <1225409729.14830.1005.camel@chandra-ubuntu>
References: <49022078.6010700@datadirectnet.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD3B893@cosmail01.lsi.com>
	 <20081030173453.GB23948@linux.vnet.ibm.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D049@cosmail01.lsi.com>
	 <1225396981.14830.990.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D0AD@cosmail01.lsi.com>
	 <1225405417.14830.1001.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D16B@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:46286 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYJ3Xgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 19:36:41 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9UNZflQ021040
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 17:35:41 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9UNaeFt116910
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 17:36:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9UNaAj1025030
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 17:36:11 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BD9D16B@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Can you try this patch.
---------
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Index: linux-2.6.27/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.27.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.27/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -386,6 +386,7 @@ static int check_ownership(struct scsi_d
 	struct c9_inquiry *inqp;
 
 	h->lun_state = RDAC_LUN_UNOWNED;
+	h->state = RDAC_STATE_ACTIVE;
 	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c9;
---

On Thu, 2008-10-30 at 17:21 -0600, Moger, Babu wrote:
> Looks like eventually we get rport failure after the controller offline.
> 
> 
> I have attached the messages file.  I am running raw IO.
> 
> Also, please note that I have added following lines in check_sense. This condition (quiescence) should be retried.
> 
> 
> case UNIT_ATTENTION:
>                 if ((sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) ||
>                     (sense_hdr->asc == 0x8b && sense_hdr->ascq == 0x02))
>                         /*
>                          * Power On, Reset, or Bus Device Reset, just retry.
>                          */
>                         return ADD_TO_MLQUEUE;
> 
> 
> 
> Thanks
> Babu Moger
> 
> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Thursday, October 30, 2008 5:24 PM
> To: Moger, Babu
> Cc: device-mapper development; linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] i/o error due to all path failure with rdac
> 
> 
> On Thu, 2008-10-30 at 14:30 -0600, Moger, Babu wrote:
> > This is what happens in my case
> >
> > When the active path is failed, the dh handler calls rdac_activate to activate the passive path.
> > Then check_ownership is called. As you know check_ownership sends inquiry (page c9). Looking at the
> > response this function sets the lun_state(h->lun_state) to RDAC_LUN_OWNED.
> >
> > If lun_state is set to RDAC_LUN_OWNED then send_mode_select will not be called. This is what
> > happens in my case.
> 
> Ok. Now it is clear. I thought the port was disabled.
> 
> The rport failure in the log you sent made me think that it was a port
> disable. Why was there a rport failure ?
> 
> Can you add these two lines at the top of
> scsi_dn_rdac.c:rdac_check_sense() function, retest and send me the log.
> ------------
>         sdev_printk(KERN_ERR, sdev, "sense_key:%x; asc %c; ascq %x\n",
>                 sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
> -----------
> I want to see if we are getting any special sense that we are not
> handling.

