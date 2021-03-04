Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BE6C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 10:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B40F64F23
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 10:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbhCDKBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 05:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbhCDKAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 05:00:39 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C3AC061756;
        Thu,  4 Mar 2021 01:59:58 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id bd6so20721510edb.10;
        Thu, 04 Mar 2021 01:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QO2U8n7VLVtOJdfm5GM29eksy0RQwsKOS6VHIcEvuf4=;
        b=Gj3sa1sI7yDqxZts7fU37dsBsaeJYgrRAPhHDAif3sg6sAkam9aXaJnhR1bNKSmns3
         JH0+pUCYqDvMy5/afRKfdy2bKCrmErj9/fPou0e8k+wAcoZTPgUgLKMmmW9JDa7VaiTu
         WLzOrN/w9wSX9KR5ITtgCr2a/PuKHv8WWWdlPlLv8C1T4zXjGUkgBCzL1yvZF2h/TkKs
         +gY3eZu6zv4fNVt8Cp5Q0wyq9juOb2LLCjULPbD5WPb5br4Srp1GxHe5svdgaw3LBKl2
         +8Qa3W/CWBh1yM+V5ufXiGh3T6IgDwDCS2/k+o3YSutnbr69F3duHm2NgibPWWgvnYxM
         gdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QO2U8n7VLVtOJdfm5GM29eksy0RQwsKOS6VHIcEvuf4=;
        b=HmOkW71sagbYyNozsMUvtLG2EAdiVTwW6Xt3pNYt3qgvI+mNTU0q+RxJw3QQn3ozFA
         KsRxj1j0BV1pfeXy552NSIjG3Yutnw2dR56BBSq+8s3GW/nMUX58BaWeRl0BMBpArM5h
         L8WKB++et+1cRtOVuPdNJS0WO/d9Lc3AcqnUbHHIa0XlqsuSuIJE68ol5YBPSdqw3A3v
         4ZNRPHqXM8C44h/OtxpF0zKkZZrx9EKcGWrA8bV+p0dHYy1u3bXYxGSUFjqSFG7h571E
         T2hmNyJgJ7bzQyEjeIF/0R5xjcj9VpX8+IRxcyKWAD/a2pvtMe4aiJHORxFFHbInprGi
         7/Hg==
X-Gm-Message-State: AOAM530u2pIKaYAtKqBQVfKcLRFFA594HhMFD3+/lb5EDjkhTWKIeTSQ
        K4yT0OxCSZ4eNKEfjADY4Lw=
X-Google-Smtp-Source: ABdhPJx7Be59CS4Jz3cuhD/DDFmjxCPgjLfpLB4Nh9q9B0A/m8JGsdEev0WAmhnX7g0GLHQoaMPlDw==
X-Received: by 2002:a50:d71e:: with SMTP id t30mr3418285edi.58.1614851997254;
        Thu, 04 Mar 2021 01:59:57 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id be27sm8590157edb.47.2021.03.04.01.59.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Mar 2021 01:59:56 -0800 (PST)
Message-ID: <0242e4ab10acff9a7d71c2f956ba4624bf95add2.camel@gmail.com>
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
Date:   Thu, 04 Mar 2021 10:59:55 +0100
In-Reply-To: <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
References: <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
         <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p6>
         <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-03-03 at 15:29 +0900, Daejun Park wrote:
> +
> +static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
> +{
> +       if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
> +               hpb->cur_read_id = 0;
> +       return hpb->cur_read_id;
> +}
> +
> +static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct
> scsi_cmnd *cmd,
> +                                 struct ufshpb_req *pre_req, int
> read_id)
> +{
> +       struct scsi_device *sdev = cmd->device;
> +       struct request_queue *q = sdev->request_queue;
> +       struct request *req;
> +       struct scsi_request *rq;
> +       struct bio *bio = pre_req->bio;
> +
> +       pre_req->hpb = hpb;
> +       pre_req->wb.lpn = sectors_to_logical(cmd->device,
> +                                            blk_rq_pos(cmd-
> >request));
> +       pre_req->wb.len = sectors_to_logical(cmd->device,
> +                                            blk_rq_sectors(cmd-
> >request));
> +       if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
> +               return -ENOMEM;
> +
> +       req = pre_req->req;
> +
> +       /* 1. request setup */
> +       blk_rq_append_bio(req, &bio);
> +       req->rq_disk = NULL;
> +       req->end_io_data = (void *)pre_req;
> +       req->end_io = ufshpb_pre_req_compl_fn;
> +
> +       /* 2. scsi_request setup */
> +       rq = scsi_req(req);
> +       rq->retries = 1;
> +
> +       ufshpb_set_write_buf_cmd(rq->cmd, pre_req->wb.lpn, pre_req-
> >wb.len,
> +                                read_id);
> +       rq->cmd_len = scsi_command_size(rq->cmd);
> +
> +       if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> +               return -EAGAIN;
> +
> +       hpb->stats.pre_req_cnt++;
> +
> +       return 0;
> +}
> +
> +static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct
> scsi_cmnd *cmd,
> +                               int *read_id)
> +{
> +       struct ufshpb_req *pre_req;
> +       struct request *req = NULL;
> +       struct bio *bio = NULL;
> +       unsigned long flags;
> +       int _read_id;
> +       int ret = 0;
> +
> +       req = blk_get_request(cmd->device->request_queue,
> +                             REQ_OP_SCSI_OUT | REQ_SYNC,
> BLK_MQ_REQ_NOWAIT);
> +       if (IS_ERR(req))
> +               return -EAGAIN;
> +
> +       bio = bio_alloc(GFP_ATOMIC, 1);
> +       if (!bio) {
> +               blk_put_request(req);
> +               return -EAGAIN;
> +       }
> +
> +       spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +       pre_req = ufshpb_get_pre_req(hpb);
> +       if (!pre_req) {
> +               ret = -EAGAIN;
> +               goto unlock_out;
> +       }
> +       _read_id = ufshpb_get_read_id(hpb);
> +       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +       pre_req->req = req;
> +       pre_req->bio = bio;
> +
> +       ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
> +       if (ret)
> +               goto free_pre_req;
> +
> +       *read_id = _read_id;
> +
> +       return ret;
> +free_pre_req:
> +       spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +       ufshpb_put_pre_req(hpb, pre_req);
> +unlock_out:
> +       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +       bio_put(bio);
> +       blk_put_request(req);
> +       return ret;
> +}
> +
>  /*
>   * This function will set up HPB read command using host-side L2P
> map data.
> - * In HPB v1.0, maximum size of HPB read command is 4KB.
>   */
> -void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  {
>         struct ufshpb_lu *hpb;
>         struct ufshpb_region *rgn;
> @@ -291,26 +560,27 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> ufshcd_lrb *lrbp)
>         u64 ppn;
>         unsigned long flags;
>         int transfer_len, rgn_idx, srgn_idx, srgn_offset;
> +       int read_id = 0;
>         int err = 0;
>  
>         hpb = ufshpb_get_hpb_data(cmd->device);
>         if (!hpb)
> -               return;
> +               return -ENODEV;
>  
>         if (ufshpb_get_state(hpb) != HPB_PRESENT) {
>                 dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
>                            "%s: ufshpb state is not PRESENT",
> __func__);
> -               return;
> +               return -ENODEV;
>         }
>  
>         if (!ufshpb_is_write_or_discard_cmd(cmd) &&
>             !ufshpb_is_read_cmd(cmd))
> -               return;
> +               return 0;
>  
>         transfer_len = sectors_to_logical(cmd->device,
>                                           blk_rq_sectors(cmd-
> >request));
>         if (unlikely(!transfer_len))
> -               return;
> +               return 0;
>  
>         lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd-
> >request));
>         ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx,
> &srgn_offset);
> @@ -323,18 +593,19 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> ufshcd_lrb *lrbp)
>                 ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx,
> srgn_offset,
>                                  transfer_len);
>                 spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> -               return;
> +               return 0;
>         }
>  
> -       if (!ufshpb_is_support_chunk(transfer_len))
> -               return;
> +       if (!ufshpb_is_support_chunk(hpb, transfer_len) &&
> +           (ufshpb_is_legacy(hba) && (transfer_len !=
> HPB_LEGACY_CHUNK_HIGH)))
> +               return 0;
>  
>         spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>         if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx,
> srgn_offset,
>                                    transfer_len)) {
>                 hpb->stats.miss_cnt++;
>                 spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> -               return;
> +               return 0;
>         }
>  
>         err = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset,
> 1, &ppn);
> @@ -347,28 +618,46 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> ufshcd_lrb *lrbp)
>                  * active state.
>                  */
>                 dev_err(hba->dev, "get ppn failed. err %d\n", err);
> -               return;
> +               return err;
> +       }
> +
> +       if (!ufshpb_is_legacy(hba) &&
> +           ufshpb_is_required_wb(hpb, transfer_len)) {
> +               err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> +               if (err) {
> +                       unsigned long timeout;
> +
> +                       timeout = cmd->jiffies_at_alloc +
> msecs_to_jiffies(
> +                                 hpb->params.requeue_timeout_ms);
> +
> +                       if (time_before(jiffies, timeout))
> +                               return -EAGAIN;
> +
> +                       hpb->stats.miss_cnt++;
> +                       return 0;
> +               }
>         }
>  
> -       ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn,
> transfer_len);
> +       ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn,
> transfer_len, read_id);
>  
>         hpb->stats.hit_cnt++;
> +       return 0;
>  }



BUG!!!


Please read HPB 2.0 Spec carefully, and check how to correctly use HPB
READ ID. you are assigning 0 for HPB write buffer. how can you expect
the HPB READ be paired???



HPB READ ID
• If this value is 0, then HPB READ ID mode is not used, in which case
the physical addresses, except for the first LBA, needed to read the
data should be calculated or searched for by the device. If this value
is not 0, then HPB READ ID mode is used, in which case the device
returns the data corresponding to the HPB entries that are bound to
the HPB READ ID value.

Bean

