Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F87C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E734C64EBB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbhCDAc6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbhCCOxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:53:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8980AC0613DF;
        Wed,  3 Mar 2021 06:50:32 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b7so16802126edz.8;
        Wed, 03 Mar 2021 06:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AFppenI13kjsXfrjDViwOVysKoaD+KTI7ZPsYdTTtaU=;
        b=dT78zq+u6JDAHwBcf6rjNXYywZcIUiPljmXBmw1naqiOJaOHG2VBfuCgwM8QumONhD
         Rr9K1ZqhbLgnUJYDdcMKpqUk4/n/7czVKmqLvQSsLqnfmRb2sVznA7rItpRwp9/neQy9
         8pOmlYWqvsgUYl06iQeV5u0Yo6wFRJC4e2VdmjnF/gbtUnv0KTzQpMNNNyXCrYUSgIHg
         TUk9bmp+PBRu4ZX3cv0AVkRnfeGlzmbNPr1KxCq2phsIAyJrVGl923LAKkxoeRBMNrmy
         BrJWyJ1OfEmcaNIYPjnwVoqzdDW37in/ImlvRKwJ4J42Xy+cH8gu06JByQ0X3uFLDF37
         W3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AFppenI13kjsXfrjDViwOVysKoaD+KTI7ZPsYdTTtaU=;
        b=iApzVEtJv9kL/nwr+6GwAJfN9JWTyGGD9XVy2UmB9lTA1a8/jLygKC1PTuOH1dn4W9
         uSd5Rzb9VFn167Wg39rw0IREDTGL75KgkvZ5p4F0C4wCHDxuBvrl3kboNqTfvNvlWnYc
         feY0jyMHYcSoSTNBbiHBibleYbYWOduQLjEZXJYhD0m/VL1nvczuq/ovIBn0Z1eF4h5B
         cIc8jNeF84OugAm901nwHfITljUHPdON8P22MQ6/gSCzW1KRBMhWV0VdRc1HfpJQi3EV
         5n84lJiSGt+vpRZp9M/IJbokOhu7kr8Wwz5TPfVaKZovs7kfjd9xrRGkGmyjH6+E3hfa
         hLgg==
X-Gm-Message-State: AOAM532i99LUvV6eQmLH7oNdDvnrYbc0UL5OuKbUGPndwBjSHTtKYlC/
        BarHP6YME/V6Njn1dPjmQ9c=
X-Google-Smtp-Source: ABdhPJxOO25yiQcpfQk0ftl6p78LCmoJFLgqEqgjIrnxMPe2qSIYwILNpozOGvseZzEr4SdPV83erg==
X-Received: by 2002:aa7:c94a:: with SMTP id h10mr26697075edt.41.1614783031163;
        Wed, 03 Mar 2021 06:50:31 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id t16sm23680538edi.60.2021.03.03.06.50.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 06:50:30 -0800 (PST)
Message-ID: <2f1b8ff5aec540ef731bf5b2c3691dd23ea2e6b0.camel@gmail.com>
Subject: Re: [PATCH v26 4/4] scsi: ufs: Add HPB 2.0 support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Wed, 03 Mar 2021 15:50:29 +0100
In-Reply-To: <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
References: <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
         <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p6>
         <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-03-03 at 15:29 +0900, Daejun Park wrote:
> +
> +static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
> +                                     struct ufshpb_req *pre_req)
> +{
> +       pre_req->req = NULL;
> +       pre_req->bio = NULL;
> +       list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
> +       hpb->num_inflight_pre_req--;
> +}
> +
> +static void ufshpb_pre_req_compl_fn(struct request *req,
> blk_status_t error)
> +{
> +       struct ufshpb_req *pre_req = (struct ufshpb_req *)req-
> >end_io_data;
> +       struct ufshpb_lu *hpb = pre_req->hpb;
> +       unsigned long flags;
> +       struct scsi_sense_hdr sshdr;
> +
> +       if (error) {
> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status
> %d", error);
> +               scsi_normalize_sense(pre_req->sense,
> SCSI_SENSE_BUFFERSIZE,
> +                                    &sshdr);
> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +                       "code %x sense_key %x asc %x ascq %x",
> +                       sshdr.response_code,
> +                       sshdr.sense_key, sshdr.asc, sshdr.ascq);
> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +                       "byte4 %x byte5 %x byte6 %x additional_len
> %x",
> +                       sshdr.byte4, sshdr.byte5,
> +                       sshdr.byte6, sshdr.additional_length);
> +       }


How can you print out sense_key and sense code here? sense code will
not be copied to pre_req->sense. you should directly use
scsi_request->sense or let pre_req->sense point to scsi_request->sense.

You update the new version patch so quickly. In another word, I am
wondering if you tested your patch before submitting?

Bean





