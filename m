Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7681FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 09:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B6EE61B39
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 09:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhKSKCx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 05:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbhKSKCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 05:02:50 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAABC06173E
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 01:59:48 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so7042641wme.4
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 01:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Sj3d3QYObw5ShpDMIYZ3Y1rx+Fb1hX5GT8SBZoj6gdE=;
        b=JcYO8nCoqvNAsT5ydqjlATJxma0OrbGbE2N7nov72Fr1i/AVikpM0KusmKbVzE3wZi
         AHg8WeIhJztt9E2vn2XaF4GXugw8ILUmTjLzs+GJWTEtgtu5dpsBmXlpj67uKuWq6eoV
         cOAnTKkS8+xSvIhCvxHj7qq6IGvjV83u9OPxx4ca8JUbURToyOtcsbTaGlpSCQihT5dX
         okYA+/DVZcfDrTAijptC16/ojRqqaRIDXp3Ye9Xh/RufV+bLBblE3V01dnBxUareol+F
         SV7Q297j+QB43g86zjnHptaPKd2B6ev+YoFQCo+WG9/m6LoWifoE9BGEfU3nSVBsJxzH
         /QIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Sj3d3QYObw5ShpDMIYZ3Y1rx+Fb1hX5GT8SBZoj6gdE=;
        b=T4yLtuOZFQWxqCvLrmNZJsmVXkz41+43N1NjHzEhVYOotijV9LeR3XnNe/XGszz/cy
         t816qLzD0F2TA5a/ia/lmetTEgq7nLLCQokj4rrf0kotiARMcV7n7PId+IGQ4va7MmnA
         WfyhmhkdYiMm6N3wB3UxuBjOK/SFz+1g0pryQN/gMUghp44Cjx2sxn+mAGSVnIxQIUwT
         g3tE/PMamEtRGLWpWZQutxMPHD7o9cvwNWRhHwkz41DYLoqv1oQSoyGLtvnpeTUJPfDn
         N8LENmf46Q12Qq1HO8aAxmVdrcy7j3D5hGM6OrRf+gZ5a3pkgzLIZRrr+Hj91XG24sEp
         M60Q==
X-Gm-Message-State: AOAM531ddU4/taDkI556hiHKfDDZgHC99mBBThE4c43qnOGHkUbOvort
        XvFf0y3t8FvrH9rOzuuvwSk=
X-Google-Smtp-Source: ABdhPJx0TGfLbPxa0HyOIcxMPuIaUytPV57SKDTx2zXBMT5wcdZ2fZLlVGvReV2rxXDTbLLi4tkLVQ==
X-Received: by 2002:a05:600c:358a:: with SMTP id p10mr5095222wmq.180.1637315987594;
        Fri, 19 Nov 2021 01:59:47 -0800 (PST)
Received: from p200300e94719c9bf1b0f08bbfadaf76c.dip0.t-ipconnect.de (p200300e94719c9bf1b0f08bbfadaf76c.dip0.t-ipconnect.de. [2003:e9:4719:c9bf:1b0f:8bb:fada:f76c])
        by smtp.googlemail.com with ESMTPSA id m2sm11494244wml.15.2021.11.19.01.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 01:59:47 -0800 (PST)
Message-ID: <b06d9a87232a6d4e90fe635384a83c48586652e9.camel@gmail.com>
Subject: Re: Please check ufshpb init flow
From:   Bean Huo <huobean@gmail.com>
To:     =?UTF-8?Q?=EC=A0=95=EC=9A=94=ED=95=9C=28JOUNG?= "YOHAN) Mobile SE" 
        <yohan.joung@sk.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?UTF-8?Q?=EC=B5=9C=EC=9E=AC=EC=98=81=28CHOI?=
         "JAE YOUNG) Mobile SE" <jaeyoung21.choi@sk.com>,
        =?UTF-8?Q?=EA=B3=BD=ED=83=9C=EC=88=98=28KWAK?= "TAESU) Mobile SE" 
        <taesu.kwak@sk.com>
Date:   Fri, 19 Nov 2021 10:59:46 +0100
In-Reply-To: <e092e35414844175bf76868b820d907f@sk.com>
References: <e092e35414844175bf76868b820d907f@sk.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


it's for "Inactivating all HPB regions" after reboot      

scsi_add_lun()...>ufshpb_issue_umap_all_req(hpb);

if it is a cold reboot on both host side and UFS device side, it is not
necessary to issue this write buffer.


On Fri, 2021-11-19 at 02:31 +0000, 정요한(JOUNG YOHAN) Mobile SE wrote:
> Hi daejun
> 
> Please check ufshpb init flow.
> sending write buffer(0x03) seems spec violation (JESD220 Commands for
> exceptional behavior on UAC, SAM 5r05) before UAC clear (sd_probe).
> Anyway hpb reset query(ufshpb_check_hpb_reset_query) seems
> sufficient.
> Why do we need to send write buffer?
> 
> void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct scsi_device
> *sdev)
> {
> out:
>     /* All LUs are initialized */
>     if (atomic_dec_and_test(&hba->ufshpb_dev.slave_conf_cnt))
> 	There seems to be a problem with this logic.
> 	If hpb is set on the last LUN, write buffer command is sent
> before sd_probe completes.
>         ufshpb_hpb_lu_prepared(hba);
> }
> 
> static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
> {
> 
>     init_success = !ufshpb_check_hpb_reset_query(hba);
> 
>     shost_for_each_device(sdev, hba->host) {
>         hpb = ufshpb_get_hpb_data(sdev);
>         if (!hpb)
>             continue;
> 
>         if (init_success) {
>             ufshpb_set_state(hpb, HPB_PRESENT);
>             if ((hpb->lu_pinned_end - hpb->lu_pinned_start) > 0)
>                 queue_work(ufshpb_wq, &hpb->map_work);
>             if (!hpb->is_hcm)
>                 ufshpb_issue_umap_all_req(hpb); 
> 		This seems unnecessary.
> 		
>         } else {
> 
> Thanks 
> yohan

