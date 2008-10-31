From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [dm-devel] i/o error due to all path failure with rdac
Date: Fri, 31 Oct 2008 13:21:39 -0700
Message-ID: <1225484499.14830.1057.camel@chandra-ubuntu>
References: <49022078.6010700@datadirectnet.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD3B893@cosmail01.lsi.com>
	 <20081030173453.GB23948@linux.vnet.ibm.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D049@cosmail01.lsi.com>
	 <1225396981.14830.990.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D0AD@cosmail01.lsi.com>
	 <1225405417.14830.1001.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D16B@cosmail01.lsi.com>
	 <1225409729.14830.1005.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BD9D2E2@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:53109 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbYJaUWj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Oct 2008 16:22:39 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9VKM9D8003070
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2008 14:22:09 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9VKMc25120340
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2008 14:22:38 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9VKM9rr015093
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2008 14:22:09 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BD9D2E2@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

That is good to know. I will push the patch upstream.

BTW, Please be advised that you might see some unknown problems if you
use the multipath tools from mainline on your distro releases.

The library in distro releases and the tools in mainline may not be
totally compatible, which is the cause.

I would suggest you to use the tools from your distro itself. The kernel
changes for SCSI_DH should work with no changes to the tools (in your
distro). IOW, you do not need the latest multipath tools.

chandra
On Fri, 2008-10-31 at 10:05 -0600, Moger, Babu wrote:
> Yes, It is working fine with this patch. Now my online/offline test is running fine. Thank you very much. That was really a quick fix.
> 
> I am still learning the device mapper. Hopefully I will be some help in the future.
> 
> Thanks
> Babu Moger
> 
> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Thursday, October 30, 2008 6:35 PM
> To: Moger, Babu
> Cc: device-mapper development; linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] i/o error due to all path failure with rdac
> 
> Can you try this patch.
> ---------
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Index: linux-2.6.27/drivers/scsi/device_handler/scsi_dh_rdac.c
> ===================================================================
> --- linux-2.6.27.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ linux-2.6.27/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -386,6 +386,7 @@ static int check_ownership(struct scsi_d
>         struct c9_inquiry *inqp;
> 
>         h->lun_state = RDAC_LUN_UNOWNED;
> +       h->state = RDAC_STATE_ACTIVE;
>         err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
>         if (err == SCSI_DH_OK) {
>                 inqp = &h->inq.c9;
> ---
> 
> On Thu, 2008-10-30 at 17:21 -0600, Moger, Babu wrote:
> > Looks like eventually we get rport failure after the controller offline.
> >
> >
> > I have attached the messages file.  I am running raw IO.
> >
> > Also, please note that I have added following lines in check_sense. This condition (quiescence) should be retried.
> >
> >
> > case UNIT_ATTENTION:
> >                 if ((sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) ||
> >                     (sense_hdr->asc == 0x8b && sense_hdr->ascq == 0x02))
> >                         /*
> >                          * Power On, Reset, or Bus Device Reset, just retry.
> >                          */
> >                         return ADD_TO_MLQUEUE;
> >
> >
> >
> > Thanks
> > Babu Moger
> >

