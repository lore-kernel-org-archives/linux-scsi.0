From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mptsas: fixed hot-removal processing
Date: Tue, 20 Jul 2010 11:33:30 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB2490298F21A38@inbmail02.lsi.com>
References: <4BBC5BB4.2050805@jp.fujitsu.com>
 <4C44EE08.4080500@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40233 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab0GTGDk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 02:03:40 -0400
In-Reply-To: <4C44EE08.4080500@jp.fujitsu.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Kei Tokunaga [mailto:tokunaga.keiich@jp.fujitsu.com]
> Sent: Tuesday, July 20, 2010 6:00 AM
> To: Desai, Kashyap
> Cc: linux-scsi; Kei Tokunaga
> Subject: Re: [PATCH] mptsas: fixed hot-removal processing
> 
> Kei Tokunaga wrote:
> > Hi Kashyap,
> >
> > This patch fixes mptsas disk hot-removal processing.  The
> > hot-removal processing doesn't complete because of this condition.
> >
> >   drivers/message/fusion/mptsas.c:
> >   mptsas_taskmgmt_complete()
> >
> >   if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc->fw_events_off)
> >     mptsas_queue_device_delete(...);
> >
> > mptsas_queue_device_delete(), which must be called for
> > hot-removal, never gets called because mptsas_find_vtarget()
> > always returns 0 here.  At that time, the vtarget has already
> > been freed in mptsas_target_destroy(), and also the scsi_device
> > has been marked as SDEV_DEL.
> >
> > As a result of the issue, port deletion functions won't get
> > called and the device ends up being in an incomplete state.
> > (Some data structures and sysfs entries, which should be
> > removed in hot-removal, remain.)  One side effect of this is
> > that a hot-addition of the device (bringing the device back
> > on) fails.
> >
> > This patch just removes mptsas_find_vtarget() from the if-state
> > condition.
> >
> > This applies to 2.6.34-rc3.
> 
> Kashyap, can you please give it an ACK?  I confirmed it still
> applies to the latest git tree (scsi-misc-2.6).

Kei,
This patch has valid code change. I have also validated patch works fine for your explained case.
Please consider this patch as ACKed.

James, Can we have this patch committed in next merge window?

~Kashyap
> 
> Thanks,
> Kei
> 
> 
> > Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> > ---
> >
> >  linux-2.6.34-rc3-kei/drivers/message/fusion/mptsas.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff -puN drivers/message/fusion/mptsas.c~fix-mptsas_hot_removal
> drivers/message/fusion/mptsas.c
> > --- linux-2.6.34-rc3/drivers/message/fusion/mptsas.c~fix-
> mptsas_hot_removal	2010-04-07 16:47:36.000000000 +0900
> > +++ linux-2.6.34-rc3-kei/drivers/message/fusion/mptsas.c	2010-04-07
> 16:48:17.000000000 +0900
> > @@ -1221,7 +1221,7 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
> >  	 * enable work queue to remove device from upper layers
> >  	 */
> >  	list_del(&target_reset_list->list);
> > -	if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc-
> >fw_events_off)
> > +	if (!ioc->fw_events_off)
> >  		mptsas_queue_device_delete(ioc,
> >  			&target_reset_list->sas_event_data);
> >
> >
> > _
> >
> >
> >
> >
> >

