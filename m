From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/4] scsi: use 64-bit value for 'max_luns'
Date: Tue, 19 Feb 2013 16:33:46 +0000
Message-ID: <1361291625.2382.54.camel@dabdike.int.hansenpartnership.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de>
	 <1361261883-41467-4-git-send-email-hare@suse.de>
	 <26C9F254-62B6-460A-BEB3-BE41516B5186@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.parallels.com ([199.115.104.20]:34595 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab3BSQee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2013 11:34:34 -0500
In-Reply-To: <26C9F254-62B6-460A-BEB3-BE41516B5186@cs.wisc.edu>
Content-Language: en-US
Content-ID: <10D4B6B0EBB76C428167637EF56E5371@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

On Tue, 2013-02-19 at 10:30 -0600, Michael Christie wrote:
> On Feb 19, 2013, at 2:18 AM, Hannes Reinecke <hare@suse.de> wrote:
> 
> > diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> > index b44c1cf..95105c0 100644
> > --- a/drivers/scsi/cxgbi/libcxgbi.c
> > +++ b/drivers/scsi/cxgbi/libcxgbi.c
> > @@ -245,7 +245,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
> > }
> > EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
> > 
> > -int cxgbi_hbas_add(struct cxgbi_device *cdev, unsigned int max_lun,
> > +int cxgbi_hbas_add(struct cxgbi_device *cdev, uint64_t max_lun,
> > 		unsigned int max_id, struct scsi_host_template *sht,
> > 		struct scsi_transport_template *stt)
> > {
> > diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
> > index 80fa99b..d3b27f8 100644
> > --- a/drivers/scsi/cxgbi/libcxgbi.h
> > +++ b/drivers/scsi/cxgbi/libcxgbi.h
> > @@ -692,7 +692,7 @@ struct cxgbi_device *cxgbi_device_register(unsigned int, unsigned int);
> > void cxgbi_device_unregister(struct cxgbi_device *);
> > void cxgbi_device_unregister_all(unsigned int flag);
> > struct cxgbi_device *cxgbi_device_find_by_lldev(void *);
> > -int cxgbi_hbas_add(struct cxgbi_device *, unsigned int, unsigned int,
> > +int cxgbi_hbas_add(struct cxgbi_device *, uint64_t, unsigned int,
> > 			struct scsi_host_template *,
> > 			struct scsi_transport_template *);
> > void cxgbi_hbas_remove(struct cxgbi_device *);
> > diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> > index dfe90ce..9acdb9c 100644
> 
> 
> Could it be possible to use u64, so it matches the rest of the driver
> coding style? The rest of the driver uses the u* definitions instead f
> the uint*_t ones.

In general we should use u64 for kernel internal stuff (which this is).
uint64_t is supposed to be reserved for user interfaces.

James

