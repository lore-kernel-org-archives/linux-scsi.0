Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A2CC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 11:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39B9920730
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 11:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wxot29R3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgAQLTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 06:19:43 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46082 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgAQLTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 06:19:42 -0500
Received: by mail-il1-f195.google.com with SMTP id t17so20966831ilm.13
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 03:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6le4NoZTvYDC0gaMP9YinfltqRZfgd5/Cmsz167yEns=;
        b=Wxot29R3SVXp373o/M5HBKZ0yisNDtWqVQi/jBdvQI4iGu4BJPUKnzFwDmEZdanuVi
         5Bv5FS2B4bT48xy/xuZSWLJYZGK9MbmWj4rAnwuMK9Nss7BxvoJipUxpO/wvy1iKpg9s
         GYe0x8aVhRrdCFLXY/0DOfEZc5Y61XlPogh8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=6le4NoZTvYDC0gaMP9YinfltqRZfgd5/Cmsz167yEns=;
        b=YHParIV7/6dUlVrI52dYoVw5xGsWC4C87hk7OCDJ9F5EgONlGIXGW7Ft4Zt9PNQ783
         fNhLGFq/IJRCwoqRINWijk7brJ4+zWPf/RuGMojzVnePTOZo556ps10VfPv5/5tpLVIC
         CoqFWei+rSHd3I9a13zCaIRcfmAWuf92sygTPycwa9vL05b+hvH6+EzDpQ4F+zbUWNJO
         V1zTswQdfsuNrWyH+7dATgGoIVSL6V+JDRW+zev1xD+dtHTwZK1U6Q4DpbcfHwyXLAZv
         U3bK8PpHSRh0H3zd0BvtHonE+RvDdoULA6dlyguU3s9f33PG7/QpbHimETgO84QsYI4a
         wIPg==
X-Gm-Message-State: APjAAAX0nc0FPFLCQjcQykXshWLSfBj1SKkTUANqkK1YFBItzlU56GZS
        CpX5NwiY+sKvX4wrV+5SxHlkRcbHns/UcwARKR1Gjg==
X-Google-Smtp-Source: APXvYqwQ0rssftlQ46lc8QMKhCvowGpUnE1YWVG6aY5RAC5HBFni39eXUKibthyqk5FADWiIHdYNyG/5juAKwU/rGeg=
X-Received: by 2002:a92:cacb:: with SMTP id m11mr2657915ilq.133.1579259982014;
 Fri, 17 Jan 2020 03:19:42 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
 <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com> <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de>
In-Reply-To: <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKinn4w+yLGD2wxDyYdH/X80yxgmwIrFr9NAYD95LqmN7Fx4A==
Date:   Fri, 17 Jan 2020 16:49:39 +0530
Message-ID: <b5ab348d98b790578325140226f741c8@mail.gmail.com>
Subject: RE: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI
 device in-flight IO requests
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hannes,
               Thank you for pointing it out. Will incorporate the suggeste=
d
changes in the upcoming patches.

Thanks & Regards,
Anand R.L

-----Original Message-----
From: Hannes Reinecke [mailto:hare@suse.de]
Sent: Thursday, January 16, 2020 6:01 PM
To: Anand Lodnoor <anand.lodnoor@broadcom.com>; linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
kiran-kumar.kasturi@broadcom.com; sankar.patra@broadcom.com;
sasikumar.pc@broadcom.com; shivasharan.srikanteshwara@broadcom.com;
chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check
SCSI device in-flight IO requests

On 1/14/20 12:21 PM, Anand Lodnoor wrote:
> Remove usage of device_busy counter from driver. Instead of
> device_busy counter now driver uses 'nr_active' counter of
> request_queue to get the number of inflight request for a LUN.
>
> Link : https://patchwork.kernel.org/patch/11249297/
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 56
> ++++++++++++++++-------------
>  1 file changed, 31 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 0bdd477..f3b36fd 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -364,6 +364,35 @@ inline void megasas_return_cmd_fusion(struct
> megasas_instance *instance,
>  		instance->max_fw_cmds =3D instance->max_fw_cmds-1;
>  	}
>  }
> +
> +static inline void
> +megasas_get_msix_index(struct megasas_instance *instance,
> +		       struct scsi_cmnd *scmd,
> +		       struct megasas_cmd_fusion *cmd,
> +		       u8 data_arms)
> +{
> +	int sdev_busy;
> +
> +	/* nr_hw_queue =3D 1 for MegaRAID */
> +	struct blk_mq_hw_ctx *hctx =3D
> +		scmd->device->request_queue->queue_hw_ctx[0];
> +
While this might be true it would be better to use the hctx from the reques=
t
itself:

struct blk_mq_hw_ctx *hctx =3D scmd->request->mq_hctx;

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg HR=
B
36809 (AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
