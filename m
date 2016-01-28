From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 13/15] megaraid_sas: Introduce module parameter for SCSI command-timeout
Date: Thu, 28 Jan 2016 16:47:58 +0530
Message-ID: <5d3a71612d095ed7cbd7103954342d77@mail.gmail.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
 <1450445228-26571-14-git-send-email-Sumit.Saxena@avagotech.com> <569E4ED8.9010904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33406 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966828AbcA1LSB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 06:18:01 -0500
Received: by mail-lb0-f179.google.com with SMTP id x4so21823284lbm.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 03:18:01 -0800 (PST)
In-Reply-To: <569E4ED8.9010904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@avagotech.com>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, January 19, 2016 8:27 PM
> To: Sumit Saxena; jbottomley@parallels.com; hch@infradead.org;
> martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; kashyap.desai@avagotech.com
> Subject: Re: [PATCH 13/15] megaraid_sas: Introduce module parameter for
SCSI
> command-timeout
>
> On 18.12.2015 14:27, Sumit Saxena wrote:
> > This patch will introduce module-parameter for SCSI command timeout
value
> and fix setting of resetwaitime beyond a value.
> >
> > Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> > Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c   |   15 ++++++++++++---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index cc843d6..316d5a0 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -83,7 +83,7 @@ module_param(throttlequeuedepth, int, S_IRUGO);
> > MODULE_PARM_DESC(throttlequeuedepth,
> >  	"Adapter queue depth when throttled due to I/O timeout. Default:
> > 16");
> >
> > -int resetwaittime = MEGASAS_RESET_WAIT_TIME;
> > +unsigned int resetwaittime = MEGASAS_RESET_WAIT_TIME;
> >  module_param(resetwaittime, int, S_IRUGO);
> > MODULE_PARM_DESC(resetwaittime, "Wait time in seconds after I/O
timeout
> "
> >  		 "before resetting adapter. Default: 180"); @@ -100,6
+100,10
> @@
> > unsigned int dual_qdepth_disable;  module_param(dual_qdepth_disable,
> > int, S_IRUGO);  MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual
> > queue depth feature. Default: 0");
> >
> > +unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
> > +module_param(scmd_timeout, int, S_IRUGO);
> > +MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s),
> > +default 90s. See megasas_reset_timer.");
>
> When you know that "The RAID firmware may require extended timeouts"
what
> do you expect when an user sets a short timeout value ?

The requirement here was to have scmd_timeout be tunable at driver load
time so have to add
Module parameter to do so.

> Other than that, I don't think that lot of tunables in a driver makes it
better, from
> my point of view you could remove both resetwaittime + scmd_timeout.
> Okay, I don't want to stay in the way if you really need it so -
>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>
> Tomas
