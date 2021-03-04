Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E08CC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 08:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F28064F27
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 08:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbhCDIiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 03:38:21 -0500
Received: from z11.mailgun.us ([104.130.96.11]:42636 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236124AbhCDIhw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Mar 2021 03:37:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614847049; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=mEqUGAmQIw80rVkgfOpohiF/Cg6qjh2EbNOd+LrIMdU=;
 b=CSfdbUYHiREjolyniy2AMfE+OaMpGL/NVGL7CoUUXlP7JYanSw2kRQUiRqMb7d6aFkqNwR42
 Xjjnh47nc70JSzlfMDe5jZ0NWw6eSCqYga7OzDH6OrozVeITKyfbiqUgc6TebHAWwpbI7+Fs
 O4e8xDHQ4W/W1i51KhWVWBJH3Ks=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 60409c431a5c93533f2ab510 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 04 Mar 2021 08:37:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 993F8C43462; Thu,  4 Mar 2021 08:37:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF3DFC433C6;
        Thu,  4 Mar 2021 08:37:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Mar 2021 16:37:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, bvanassche@acm.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v26 4/4] scsi: ufs: Add HPB 2.0 support
In-Reply-To: <2f1b8ff5aec540ef731bf5b2c3691dd23ea2e6b0.camel@gmail.com>
References: <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
 <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p6>
 <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
 <2f1b8ff5aec540ef731bf5b2c3691dd23ea2e6b0.camel@gmail.com>
Message-ID: <bffa984b28a4b3a8af3eefba39de6b18@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-03 22:50, Bean Huo wrote:
> On Wed, 2021-03-03 at 15:29 +0900, Daejun Park wrote:
>> +
>> +static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
>> +                                     struct ufshpb_req *pre_req)
>> +{
>> +       pre_req->req = NULL;
>> +       pre_req->bio = NULL;
>> +       list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
>> +       hpb->num_inflight_pre_req--;
>> +}
>> +
>> +static void ufshpb_pre_req_compl_fn(struct request *req,
>> blk_status_t error)
>> +{
>> +       struct ufshpb_req *pre_req = (struct ufshpb_req *)req-
>> >end_io_data;
>> +       struct ufshpb_lu *hpb = pre_req->hpb;
>> +       unsigned long flags;
>> +       struct scsi_sense_hdr sshdr;
>> +
>> +       if (error) {
>> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status
>> %d", error);
>> +               scsi_normalize_sense(pre_req->sense,
>> SCSI_SENSE_BUFFERSIZE,
>> +                                    &sshdr);
>> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
>> +                       "code %x sense_key %x asc %x ascq %x",
>> +                       sshdr.response_code,
>> +                       sshdr.sense_key, sshdr.asc, sshdr.ascq);
>> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
>> +                       "byte4 %x byte5 %x byte6 %x additional_len
>> %x",
>> +                       sshdr.byte4, sshdr.byte5,
>> +                       sshdr.byte6, sshdr.additional_length);
>> +       }
> 
> 
> How can you print out sense_key and sense code here? sense code will
> not be copied to pre_req->sense. you should directly use
> scsi_request->sense or let pre_req->sense point to scsi_request->sense.
> 
> You update the new version patch so quickly. In another word, I am
> wondering if you tested your patch before submitting?
> 
> Bean

Bean is right about the sense buffer...
