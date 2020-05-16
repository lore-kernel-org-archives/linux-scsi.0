Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDEEC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 06:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02222075F
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 06:56:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UTdXNDal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgEPG45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 02:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725867AbgEPG44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 May 2020 02:56:56 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9D0C05BD09
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 23:56:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id d7so3606870eja.7
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=ufEiffPhcdP1WFgoGgcsuuopbnAWO2zcIgZgPK4ybrw=;
        b=UTdXNDalGYLrLOXK9iqt2npY4Iu8ydQrcgKzEZ1Bl7b+k1XQEny7HyKvRMWlHbk4Vu
         bfZ7xU6HGhrcUFsT045L9FmtKYb+KuNDuj0LwI7YK27bjMFsSLvZgTyzk4yNfmdOugu/
         nYeplNdFfbQ8Pmsz599w+Eu61gc4tJfpyHqJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=ufEiffPhcdP1WFgoGgcsuuopbnAWO2zcIgZgPK4ybrw=;
        b=dnp2kUn1uqLybLJSmkcBixDnMJXCeIBVXjYXrN72SvHNdE/G1QZ8T0qtux1/4AaHew
         IzRAbetjUleqNg1UDe6l+H8nMRwBOPFBWJyTAN0cnx1wT4KoC27AiKLO7mMM8pBp+KJe
         GEBy0rXCcwFuW1ExQm4pQuNBqw2RJ6E2Fo5giTIXIZywLP38ZOjl62s4B6YQUC0vXB1V
         Vy7BRy8u2l+XrsAJsbuTb5NE71S4ttJCuiMyDQbqQDE0edtbmyH3J4xuUovBQwJXxFdx
         mKurUYAVN6YqVqliQkTPkXO4R/ToTSwdi5Yq9reP08taveCzeSpplFz/nHJtcP2SdUiK
         JOxA==
X-Gm-Message-State: AOAM533W4nWryxpUpYxt5xKeCEvhutWs0YVTJgcJGt4LPY6jN35vRdrI
        Xg+wapYsI3+3Wv56NjhLW767IfSFpxL+eXPMQrGUWg==
X-Google-Smtp-Source: ABdhPJxTDXezfYE0PaU0TaBXJVNiuc9ittt8gwZVnbU8oL6eWbSdJzBq0qD/BgelhdTtWPk36mwGGsF39bGnRDopDKQ=
X-Received: by 2002:a17:906:5255:: with SMTP id y21mr6540516ejm.306.1589612214360;
 Fri, 15 May 2020 23:56:54 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <20200508085242.23406-1-chandrakanth.patil@broadcom.com> <b007f7ae-0a9d-2bfd-6da8-e72576c40353@suse.de>
In-Reply-To: <b007f7ae-0a9d-2bfd-6da8-e72576c40353@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJgInzLHphm3XOTq02c+mL5v6fZnAIOEm9Ip4XnPXA=
Date:   Sat, 16 May 2020 12:26:51 +0530
Message-ID: <8e37b956275b2837da4ba71773033c7d@mail.gmail.com>
Subject: RE: [PATCH 4/5] megaraid_sas: TM command refire leads to controller
 firmware crash
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Issue: When TM command times-out driver invokes the controller reset.
> > Post reset, driver re-fires pended TM commands which leads to firmware
> > crash.
> >
> > Fix: Post controller reset, return pended TM commands back to OS.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> > Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> > ---
> >   drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 87f91a38..319f241 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -4180,6 +4180,7 @@ static void megasas_refire_mgmt_cmd(struct
> megasas_instance *instance,
> >   	struct fusion_context *fusion;
> >   	struct megasas_cmd *cmd_mfi;
> >   	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> > +	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
> >   	u16 smid;
> >   	bool refire_cmd = false;
> >   	u8 result;
> > @@ -4247,6 +4248,11 @@ static void megasas_refire_mgmt_cmd(struct
> megasas_instance *instance,
> >   			result = COMPLETE_CMD;
> >   		}
> >
> > +		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
> > +				cmd_fusion->io_request;
> > +		if (scsi_io_req->Function == MPI2_FUNCTION_SCSI_TASK_MGMT)
> > +			result = RETURN_CMD;
> > +
> >   		switch (result) {
> >   		case REFIRE_CMD:
> >   			megasas_fire_cmd_fusion(instance, req_desc); @@ -4475,7
> +4481,6
> > @@ megasas_issue_tm(struct megasas_instance *instance, u16
> > device_handle,
> >   	if (!timeleft) {
> >   		dev_err(&instance->pdev->dev,
> >   			"task mgmt type 0x%x timed out\n", type);
> > -		cmd_mfi->flags |= DRV_DCMD_SKIP_REFIRE;
> >   		mutex_unlock(&instance->reset_mutex);
> >   		rc = megasas_reset_fusion(instance->host, MFI_IO_TIMEOUT_OCR);
> >   		mutex_lock(&instance->reset_mutex);
> >
> Why didn't the 'DRV_DCMD_SKIP_REFIRE' work?
> And if it doesn't work, can't it be removed completely?

Re-fire logic doesn't check  'DRV_DCMD_SKIP_REFIRE'  flag for TM commands
but it will check the flag for DCMDs
Hence, 'DRV_DCMD_SKIP_REFIRE' flag is only removed for TM commands.

-Chandrakanth Patil
