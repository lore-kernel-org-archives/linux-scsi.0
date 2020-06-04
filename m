Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4C1C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 19:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BDA5206DC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 19:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GjxtAOQp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgFDTfT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 15:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728565AbgFDTfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2020 15:35:19 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036A8C08C5C0
        for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2020 12:35:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l12so3617049ejn.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2020 12:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=oyFcjly3iI3BI3+x8EJy7gBmUy6FOed1sXbAZssuOGo=;
        b=GjxtAOQpLRjZNmSyUueh+o5GYU/a2WnPWJ6lUemF++gMlaOuL43n5nkyCy1JOOntFQ
         N5IG9D54Qy0ztQrXQWRSzHY0sM73WSKhqiNtQ6KuMUwOi7+uVXbfp64AR+O9JXuEKwb6
         LXL0lOS4/jEZkRYhN6FORL6w0jcd96qtmEh4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=oyFcjly3iI3BI3+x8EJy7gBmUy6FOed1sXbAZssuOGo=;
        b=m8SSBpogYP8YH9UJ/ANb4d2bAQ8MMA5MVvfNNa1TOaixe+bYtp39dK9Zq6yCGAYvWe
         hg2vu4qvpbo/S2zSx3Y70Kc/QPxJ7lZtqGhc8Hh0QSk9BFiQ53w1Ku2GR8/rMWs52046
         Co/e4Jpvlz+ylAb3QtbfvITUyDBqoA/799sHU/Nhco6zSLhT8/cJY28OumBR4nxfnmHW
         ZH2to0UQQe19otR2HJwjipJZZ930eoQjl48uNZ1b/5v0rv/sl6h9zjTGK19vP4zqxPT0
         sTw6219PryeKLgqcAyjM/Uv8f4EoUH1eEXh2p4vvhkeQMnGPc6Fd8WZB4DRFXXH0isVj
         yeeg==
X-Gm-Message-State: AOAM533Id41EpQamEMSpvwG06XXV3dJZD8xPZOyjO3Hgteu9PAuSijKQ
        bwXj90NRXr0X/SqEMDX7d+wsG4/ZLKzG/M14PRQYEQ==
X-Google-Smtp-Source: ABdhPJyPugwFVDV6AFxPuiXuVnUxIjbCmjXK1NRb4zaJGKhfuG6BzP+CkKC8JEeaZLgBDICeXdLhDSKGf2RflapIHsg=
X-Received: by 2002:a17:906:8253:: with SMTP id f19mr5433964ejx.470.1591299317595;
 Thu, 04 Jun 2020 12:35:17 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
 <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com> <4779a72c878774e4e3525aae8932feda@mail.gmail.com>
 <20200604155009.63mhbsoaoq6yra77@suse.com>
In-Reply-To: <20200604155009.63mhbsoaoq6yra77@suse.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJb9Wzm0098wwdcUnfhuPbO5i84ZwGnJavmAYBmkM8CEG/qNaeTocBQ
Date:   Fri, 5 Jun 2020 01:05:13 +0530
Message-ID: <4285a7ff366d7f5cfb5cae582dadf878@mail.gmail.com>
Subject: RE: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused by JBOD
To:     Kai Liu <kai.liu@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Xiaoming Gao <newtongao@tencent.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>, xiakaixu1987@gmail.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>Subject: Re: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused
>by JBOD
>
>On 2020/06/04 Thu 16:39, Chandrakanth Patil wrote:
>>
>>Hi Martin, Xiaoming Gao, Kai Liu,
>>
>>It is a known firmware issue and has been fixed. Please update to the
>>latest firmware available in the Broadcom support website.
>>Please let me know if you need any further information.
>
>Hi Chandrakanth,
>
>Could you let me know which megaraid based controllers are affected by this
>issue? All or
>some models or some generations?
>
>Best regards,
>Kai Liu

Hi Kai Liu,

Gen3 (Invader) and Gen3.5 (Ventura/Aero) generations of controllers are
affected.

Thanks,
Chandrakanth Patil
