Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEF5C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9DE364FA3
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhBELSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 06:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhBELQZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 06:16:25 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7E6C06178A;
        Fri,  5 Feb 2021 03:15:43 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id b9so11271474ejy.12;
        Fri, 05 Feb 2021 03:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xGy6QPSyFqGl2apBoSDjOXH0DYYBflQ0iXGm5zmDxkc=;
        b=vKx78CoBsYFL2sQWSF7KF162QYkAF+sOldJiHNphzx0P1zSGrzWeETems+cfpntWyx
         JNPnflSZvYVpw3Q0QCYtjKjrJgSKBpzI8FJgrW3wtk5ohLPnMAdFanxsunHEKHberI/P
         fXhjSNEjFG9fd4RA58P5Hl5vSYjswkreYPRRo6ZDEORDSLb5t6kC6oe8nZN+wycYkwrI
         SZfOAVNnmTBGgiLlf/cxvJ8+HBpOH65b7QNbYqwE/GouuaxCdD7oASQNu67DJCa7/Zrl
         G+HyUCMlUrvrkSSv5mIvrw3AIBafhqLGKzUT3UjJdVafHo8cLxfDRy+AQ7UGDLrGpyyz
         ntDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xGy6QPSyFqGl2apBoSDjOXH0DYYBflQ0iXGm5zmDxkc=;
        b=Pi5SNjh1S5fFqL+bLngmxeYO35mWgN55w/HB2itmDanM0srNY7xFAFCBs4wUw7BMoX
         wS2gmU+Qhuudq3kqnK+SyAIUOcbKoajYkO+P8FpB50RV7EtA4FXhaQzcmGIN2t2dktzm
         XKIJ+Ohc0ZQShFjwMRTPNOz02zRlwWp1Oe7JVpICoklElwwktf+J3WSBwEBZ5500BFhd
         386E6R5o4yws7UXbNmuhabR25gndsEzRztTvcKKpWUHgV9+qekC2/c0SGjVWAB/h2nCM
         dSS5mWrSlo/pzEN8qMdAKxmUb25GvDJMosjfHm5RC4d4N3QFGKnEjRcDT1xx6pGs1JZL
         zDgA==
X-Gm-Message-State: AOAM531E0imM7AAfIyZuFoaice7c3lY+kooo5TlNTY1lrmTNV+zEa1C9
        6YboUJF28w8AvVt2niGg+twRjI6bWI4=
X-Google-Smtp-Source: ABdhPJyms+hJzmTMnNhN6Va3fknGEV52K1mnhH8ndJRj5B9dAKOC26O1142JBLiX2CiemAEK7GSZsw==
X-Received: by 2002:a17:906:b09a:: with SMTP id x26mr3607767ejy.199.1612523742471;
        Fri, 05 Feb 2021 03:15:42 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id t19sm3758856ejc.62.2021.02.05.03.15.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Feb 2021 03:15:41 -0800 (PST)
Message-ID: <218be362c71a9cdb8312f6d8156a0935985aae04.camel@gmail.com>
Subject: Re: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
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
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Fri, 05 Feb 2021 12:15:39 +0100
In-Reply-To: <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p3>
         <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-01-29 at 14:30 +0900, Daejun Park wrote:
> +static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
> +                                          int srgn_idx, int
> srgn_mem_size)
> +{
> +       cdb[0] = UFSHPB_READ_BUFFER;
> +       cdb[1] = UFSHPB_READ_BUFFER_ID;
> +
> +       put_unaligned_be16(rgn_idx, &cdb[2]);
> +       put_unaligned_be16(srgn_idx, &cdb[4]);
> +       put_unaligned_be24(srgn_mem_size, &cdb[6]);
> +
> +       cdb[9] = 0x00;
> +}
> +
> +static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
> +                                 struct ufshpb_req *map_req)
> +{
> +       struct request_queue *q;
> +       struct request *req;
> +       struct scsi_request *rq;
> +       int ret = 0;
> +       int i;
> +
> +       q = hpb->sdev_ufs_lu->request_queue;
> +       for (i = 0; i < hpb->pages_per_srgn; i++) {
> +               ret = bio_add_pc_page(q, map_req->bio, map_req->mctx-
> >m_page[i],
> +                                     PAGE_SIZE, 0);
> +               if (ret != PAGE_SIZE) {
> +                       dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +                                  "bio_add_pc_page fail %d - %d\n",
> +                                  map_req->rgn_idx, map_req-
> >srgn_idx);
> +                       return ret;
> +               }
> +       }
> +
> +       req = map_req->req;
> +
> +       blk_rq_append_bio(req, &map_req->bio);
> +
> +       req->end_io_data = map_req;
> +
> +       rq = scsi_req(req);
> +       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
> +                               map_req->srgn_idx, hpb-
> >srgn_mem_size);

Hi Daejun

Thanks for your hard-working on the HPB driver.

I found you didn't take into account of allocation Length of the last
sub-region of the last region.

UFS HPB spec: 

"If the requested field of the HPB Region or HPB Sub-Region is out of
range, then the device shall terminate the command by sending RESPONSE
UPIU with CHECK CONDITION status, with the SENSE KEY set to ILLEGAL
REQUEST, and the additional sense code set to INVALID FIELD IN CDB"


Below codes are from my RFC HPB patchset:

https://patchwork.kernel.org/project/linux-scsi/patch/20200504142032.16619-6-beanhuo@micron.com/

+	alloc_len = hpb->hba->hpb_geo.subregion_entry_sz;
+	/*
+	 * HPB Sub-Regions are equally sized except for the last one
which is
+	 * smaller if the last hpb Region is not an integer multiple of
+	 * bHPBSubRegionSize.
+	 */
+	if (map_req->region == (hpb->lu_region_cnt - 1) &&
+	    map_req->subregion == (hpb->subregions_in_last_region - 1))
+		alloc_len = hpb->last_subregion_entry_size;
+
+	ufshpb_prepare_read_buf_cmd(ureq->cmd, map_req->region,
+				    map_req->subregion, alloc_len);
+	if (!ureq->req) {
+		ureq->req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
+		if (IS_ERR(ureq->req)) {
+			ret =  PTR_ERR(ureq->req);
+			goto free_mem;
+		}
+	}

please fix it in your next version patch. thanks.


Kind regards,
Bean



