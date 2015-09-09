From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 1/2] mpt3sas: Refcount sas_device objects and fix
 unsafe list usage
Date: Tue, 08 Sep 2015 23:21:27 -0700
Message-ID: <1441779687.26610.6.camel@haakon3.risingtidesystems.com>
References: <1440921279-9973-1-git-send-email-nab@daterainc.com>
	 <1440921279-9973-2-git-send-email-nab@daterainc.com>
	 <CAK=zhgrTpxiiEbHCvLL09EhyLq+xAdteMU1Gzd3jPg9UGo=BDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34772 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbbIIGXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2015 02:23:38 -0400
In-Reply-To: <CAK=zhgrTpxiiEbHCvLL09EhyLq+xAdteMU1Gzd3jPg9UGo=BDA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Calvin Owens <calvinowens@fb.com>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team <kernel-team@fb.com>, Chaitra Basappa <chaitra.basappa@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi Sreekanth,

On Tue, 2015-09-08 at 17:25 +0530, Sreekanth Reddy wrote:
> On Sun, Aug 30, 2015 at 1:24 PM, Nicholas A. Bellinger
> <nab@daterainc.com> wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > These objects can be referenced concurrently throughout the driver, we
> > need a way to make sure threads can't delete them out from under
> > each other. This patch adds the refcount, and refactors the code to use
> > it.
> >
> > Additionally, we cannot iterate over the sas_device_list without
> > holding the lock, or we risk corrupting random memory if items are
> > added or deleted as we iterate. This patch refactors _scsih_probe_sas()
> > to use the sas_device_list in a safe way.
> >
> > This patch is a port of Calvin's PATCH-v4 for mpt2sas code, atop
> > mpt3sas changes in scsi.git/for-next.
> >
> > Cc: Calvin Owens <calvinowens@fb.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> > Cc: MPT-FusionLinux.pdl <MPT-FusionLinux.pdl@avagotech.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_base.h      |  25 +-
> >  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 479 +++++++++++++++++++++----------
> >  drivers/scsi/mpt3sas/mpt3sas_transport.c |  18 +-
> >  3 files changed, 364 insertions(+), 158 deletions(-)


<SNIP>

> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> > index 70fd019..6074b11 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> > @@ -734,7 +734,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
> >         rphy->identify = mpt3sas_port->remote_identify;
> >
> >         if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
> 
> [Sreekanth] Here also sas_device_lock spin lock needs to be acquired
> before calling
>                   __mpt3sas_get_sdev_by_addr() function.
> 

Thanks for your review.

Fixed with the following incremental patch atop for-next-merge code.

Please review.

Thank you,

>From 4004584675d24d8e886b03c013074cdfb76a0864 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 8 Sep 2015 23:05:49 -0700
Subject: [PATCH] mpt3sas: Add missing ioc->sas_device_lock in
 mpt3sas_transport_port_add

This patch adds the missing struct MPT3SAS_ADAPTER->sas_device_lock
usage in __mpt3sas_get_sdev_by_addr() lookup to avoid a NULL pointer
dereference when &ioc->sas_device_list or &ioc->sas_device_init_list
changes from below without a proper sas_device_get(sas_device)
reference held.

Reported-by: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 6074b11..cc55907 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -734,8 +734,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	rphy->identify = mpt3sas_port->remote_identify;
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = __mpt3sas_get_sdev_by_addr(ioc,
 				    mpt3sas_port->remote_identify.sas_address);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 		if (!sas_device) {
 			dfailprintk(ioc, printk(MPT3SAS_FMT
 				"failure at %s:%d/%s()!\n",
-- 
1.9.1

