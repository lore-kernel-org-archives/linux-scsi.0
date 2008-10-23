From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [dm-devel] failover does not work with rdac device handler
Date: Thu, 23 Oct 2008 11:31:54 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BCE4739@cosmail01.lsi.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>
	 ,<1223081419.14830.585.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BB949D3@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBCCF2@cosmail01.lsi.com>
	 <1223322817.14830.593.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBCD31@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBCE37@cosmail01.lsi.com>
	 <1223345074.14830.601.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBD142@cosmail01.lsi.com>
	 <1223407146.14830.617.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BCE45E0@cosmail01.lsi.com>
 <1224782104.14830.870.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39378 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYJWRcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2008 13:32:16 -0400
In-Reply-To: <1224782104.14830.870.camel@chandra-ubuntu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks for the updates..
Babu Moger

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
Sent: Thursday, October 23, 2008 12:15 PM
To: Moger, Babu
Cc: device-mapper development; linux-scsi@vger.kernel.org
Subject: RE: [dm-devel] failover does not work with rdac device handler

Hi Babu,

There is an another issue w.r.t non-listed devices (like you tested).
The issue is that when the device disappears and reappear, the dh_state
file is not created for them. I wanted to send the patch for that also
together with this one. That is the reason for delay.

chandra
On Thu, 2008-10-23 at 08:12 -0600, Moger, Babu wrote:
> Hello Chandra,
>    I have not seen this patch being submitted to mainstream kernel. When are you planning to submit this patch? Should I open a bugzilla for tracking purposes?
>
> Thanks
> Babu Moger
> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Tuesday, October 07, 2008 2:19 PM
> To: Moger, Babu
> Cc: device-mapper development; linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] failover does not work with rdac device handler
>
>
> Sorry, I sent an imcomplete patch. Here is the correct one.
>
> BTW, The panic you saw is caused by the line (one of the lines you
> added):
>
> dev = container_of(&scsi_dh_data, struct scsi_device, scsi_dh_data);
>
> in scsi_dh_release(). We cannot use pointer in a structure to get the
> parent structure.
>
> chandra
>
> Keep a reference count of attaches, so that same number of detaches are allowed.
> -----------
>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
> Index: linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
> ===================================================================
> --- linux-2.6.27-rc8-git5.orig/drivers/scsi/device_handler/scsi_dh.c
> +++ linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
> @@ -153,12 +153,28 @@ static int scsi_dh_handler_attach(struct
>         if (sdev->scsi_dh_data) {
>                 if (sdev->scsi_dh_data->scsi_dh != scsi_dh)
>                         err = -EBUSY;
> -       } else if (scsi_dh->attach)
> +               else
> +                       kref_get(&sdev->scsi_dh_data->kref);
> +       } else if (scsi_dh->attach) {
>                 err = scsi_dh->attach(sdev);
> +               if (!err) {
> +                       kref_init(&sdev->scsi_dh_data->kref);
> +                       sdev->scsi_dh_data->sdev = sdev;
> +               }
> +       }
>
>         return err;
>  }
>
> +static void scsi_dh_release(struct kref *kref)
> +{
> +       struct scsi_dh_data *scsi_dh_data;
> +       scsi_dh_data = container_of(kref, struct scsi_dh_data, kref);
> +
> +       if (scsi_dh_data->scsi_dh && scsi_dh_data->scsi_dh->detach)
> +               scsi_dh_data->scsi_dh->detach(scsi_dh_data->sdev);
> +}
> +
>  /*
>   * scsi_dh_handler_detach - Detach a device handler from a device
>   * @sdev - SCSI device the device handler should be detached from
> @@ -176,11 +192,7 @@ static void scsi_dh_handler_detach(struc
>         if (scsi_dh && scsi_dh != sdev->scsi_dh_data->scsi_dh)
>                 return;
>
> -       if (!scsi_dh)
> -               scsi_dh = sdev->scsi_dh_data->scsi_dh;
> -
> -       if (scsi_dh && scsi_dh->detach)
> -               scsi_dh->detach(sdev);
> +       kref_put(&sdev->scsi_dh_data->kref, scsi_dh_release);
>  }
>
>  /*
> Index: linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
> ===================================================================
> --- linux-2.6.27-rc8-git5.orig/include/scsi/scsi_device.h
> +++ linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
> @@ -6,6 +6,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/workqueue.h>
>  #include <linux/blkdev.h>
> +#include <linux/kref.h>
>  #include <scsi/scsi.h>
>  #include <asm/atomic.h>
>
> @@ -191,6 +192,8 @@ struct scsi_device_handler {
>
>  struct scsi_dh_data {
>         struct scsi_device_handler *scsi_dh;
> +       struct kref kref;
> +       struct scsi_device *sdev; /* back reference */
>         char buf[0];
>  };
>
>
>

