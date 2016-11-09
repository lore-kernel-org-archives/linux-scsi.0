From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [REGRESSION] 4.9-rc4+ doesn't boot on my test box
Date: Wed, 9 Nov 2016 05:50:20 +0530
Message-ID: <48f84d6c60f7ac70928c2cb34cd2ed1f@mail.gmail.com>
References: <f0fa381c-e224-b660-27c4-dede4a5b543e@kernel.dk> <yq1mvh9r2b9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:35564 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbcKIAUX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 19:20:23 -0500
Received: by mail-it0-f53.google.com with SMTP id e187so181578200itc.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2016 16:20:23 -0800 (PST)
In-Reply-To: <yq1mvh9r2b9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, November 09, 2016 4:45 AM
> To: Jens Axboe
> Cc: linux-scsi; Kashyap Desai; Martin K. Petersen
> Subject: Re: [REGRESSION] 4.9-rc4+ doesn't boot on my test box
>
> >>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:
>
> Jens> I wasted half a day on this, thinking it was something in my
> Jens> 4.10 branches. But it turns out it is not, the regression is in
> Jens> mainline.

Jens -

Sorry for trouble.  I did not validated this single patch. I validated
complete patch set.
Issue is improper MACRO usage MEGASAS_IS_LOGICAL, which gives incorrect
check condition in qcmd Path.

Below is proposed fix.


diff --git a/drivers/scsi/megaraid/megaraid_sas.h
b/drivers/scsi/megaraid/megaraid_sas.h
index 74c7b44..0d2625b 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2236,7 +2236,7 @@ struct megasas_instance_template {
 };

 #define MEGASAS_IS_LOGICAL(scp)
\
-	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
+	((scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)

 #define MEGASAS_DEV_INDEX(scp)						\
 	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\


>
> Kashyap, have you tested the stable fix without the remainder of the
driver
> update in place?

Martin -  I validated whole series.  Apologies for this.

Please help me to know how to fix this ? Do I need to send only fix on top
of latest commit (as posted above - MACRO definition) for this issue ?

>
> --
> Martin K. Petersen	Oracle Linux Engineering
