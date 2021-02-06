Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFE9C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 09:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002C164FA7
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 09:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhBFJPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 04:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBFJPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 04:15:40 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566C3C06174A;
        Sat,  6 Feb 2021 01:15:00 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b9so16447027ejy.12;
        Sat, 06 Feb 2021 01:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b7YIX8SshshVZJRcWkL4mQV5VYda5wbJcpvmOSIp7iM=;
        b=c9/eQYp24v16eO7/PdlH0HExNZlDgSFtgHA8UG2aoOTJZi/alKZbA1ieCzT4YdrSeV
         fLElZkbn5DOuBKmunbiYsRmnS2avJPbhMNej42pHxsUBf3w0PjI0HRE/F4vwCzUT2e1/
         TbyTsYm/vB+mYXdKT/JixZVL/WjSedVtdxVkYGC+06I5tpewU5JYzfAVyDNq8O0r4NDT
         8LxUlPFVbbbS63AR/1cSm+XMKblzQdok0YxKifhXjk2gF4HQdJ/220gaXkv9YfTnEWhE
         U41c28kGyTPMQvmSQ4KJrbu7Q6B/CWvLj8NCTMSbiBMpG+4kM5qtjnCFDjkCPrOZeK8p
         iloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b7YIX8SshshVZJRcWkL4mQV5VYda5wbJcpvmOSIp7iM=;
        b=bZaqrkP/u7UyEY1VBGqOiAVnipBtqETLLgPRa8GB0eW0HHb8XILQH5hixnnqV8FjGv
         SnQ4cFuK/L8g+ik72VAvfO08LLd/04EvCjQCgdxhkg9sfWYVZ+zcK9n2KHpD9MeoJB0i
         RX8khjeJt1c+YrAcdTFIiM+PjPiJ+ChlZ0ziJvDIou4DC7NBtAGYbwZPL6o/HX10y0fU
         GVFYLf24hwjZ9geiv7I8DBZj+quy+cXZMEIRJ8ax+OuWA3VFAEdnBtH4QLOwbGS827Pb
         PuEl8aWhQW/ES+ui9azxzePkA1Hm1xcQob4QfTr2S90pZtD0EPLqWg1Ipt3yvLgH7vDD
         P2Vg==
X-Gm-Message-State: AOAM533RviT+h3DesTXldcxYEJfUyiDTVFakDsXPBQwyAzGMBx/+r/az
        29m6wzMdDD1WpZcPVAV2rpk=
X-Google-Smtp-Source: ABdhPJzF/dd/Z3RbwWIPxAutVN/GaUnPCmcXMWH0XIPRu8dOHXuP1uJRMmfOHztl0cmkSf8+4P3J6w==
X-Received: by 2002:a17:907:2130:: with SMTP id qo16mr7749896ejb.537.1612602898182;
        Sat, 06 Feb 2021 01:14:58 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id r6sm2081032edq.43.2021.02.06.01.14.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Feb 2021 01:14:57 -0800 (PST)
Message-ID: <6bcd5f74352a63fb96de1640ea4b453f150a88f5.camel@gmail.com>
Subject: Re: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Sat, 06 Feb 2021 10:14:55 +0100
In-Reply-To: <652fa8013c26df497049abe923eb1b97@codeaurora.org>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p3>
         <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
         <652fa8013c26df497049abe923eb1b97@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-02-06 at 15:23 +0800, Can Guo wrote:
> > +     dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT
> > %u\n",
> > +             rsp_field->active_rgn_cnt, rsp_field-
> > >inactive_rgn_cnt);
> > +
> > +     queue_work(ufshpb_wq, &hpb->map_work);
> > +}
> > +
> > +/*
> > + * This function will parse recommended active subregion
> > information 
> > in sense
> > + * data field of response UPIU with SAM_STAT_GOOD state.
> > + */
> > +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > +{
> > +     struct ufshpb_lu *hpb = ufshpb_get_hpb_data(lrbp->cmd-
> > >device);
> > +     struct utp_hpb_rsp *rsp_field;
> > +     int data_seg_len;
> > +
> > +     if (!hpb)
> > +             return;
> 
> You are assuming HPB recommandations only come in responses to LUs
> with HPB enabled, but the specs says the recommandations can come
> in any responses with GOOD status, meaning you should check the *hpb
> which belongs to the LUN in res_field, but not the one belongs to
> lrbp->cmd->device.
> 

correct, see here HPB driver patch :).


https://patchwork.kernel.org/project/linux-scsi/patch/20200504142032.16619-6-beanhuo@micron.com/

+
+#if defined(CONFIG_SCSI_UFSHPB)
+			/*
+			 * HPB recommendations are provided in RESPONSE
UPIU
+			 * packets of successfully completed commands,
which
+			 * are commands terminated with GOOD status.
+			 */
+			if (scsi_status == SAM_STAT_GOOD)
+				ufshpb_rsp_handler(hba, lrbp);
+#endif
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
 			/* TODO: handle Reject UPIU Response */

we need re-test this series patch seriously.


Thanks Can.


Bean


> Regards,
> 
> Can Guo

