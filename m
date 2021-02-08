Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D49C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 10:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F388D64EA7
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 10:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhBHKKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 05:10:09 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:28443 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232124AbhBHJ7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 04:59:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612778366; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=SaZaHBLKUsOHV+ADNlGOajlR/W8Hmri2bwY0Sr/RM5U=;
 b=pK2IddlUFyUC+3hRbB6HxyINmp4OM4r+1eoaWZwxS156MhUfoYqrGGvQE4eja/Nz3PgE2o1n
 Vm6OTv3/EeFcyC1sBhng7Wg6RqfHgilWLCn/tM8w+ux9JAgub0t8eX16oEswJ0szvA/YRjAh
 m9RyhtGDa/N0/v74EUFoT06Xbjg=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60210b58f112b7872c08e0a9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 09:58:48
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 63587C43469; Mon,  8 Feb 2021 09:58:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 74B43C433C6;
        Mon,  8 Feb 2021 09:58:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Feb 2021 17:58:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, bvanassche@acm.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached sub-region
In-Reply-To: <a95af313ee4dfb7173b0c5a23b52d2168a94f87a.camel@gmail.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
 <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
 <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
 <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
 <a95af313ee4dfb7173b0c5a23b52d2168a94f87a.camel@gmail.com>
Message-ID: <8c79dfb0dc749c3c1362b57c5a9766c0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-08 16:16, Bean Huo wrote:
> On Fri, 2021-02-05 at 11:29 +0800, Can Guo wrote:
>> > +     return ppn_table[offset];
>> > +}
>> > +
>> > +static void
>> > +ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn,
>> > int
>> > *rgn_idx,
>> > +                     int *srgn_idx, int *offset)
>> > +{
>> > +     int rgn_offset;
>> > +
>> > +     *rgn_idx = lpn >> hpb->entries_per_rgn_shift;
>> > +     rgn_offset = lpn & hpb->entries_per_rgn_mask;
>> > +     *srgn_idx = rgn_offset >> hpb->entries_per_srgn_shift;
>> > +     *offset = rgn_offset & hpb->entries_per_srgn_mask;
>> > +}
>> > +
>> > +static void
>> > +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct
>> > ufshcd_lrb
>> > *lrbp,
>> > +                               u32 lpn, u64 ppn,  unsigned int
>> > transfer_len)
>> > +{
>> > +     unsigned char *cdb = lrbp->cmd->cmnd;
>> > +
>> > +     cdb[0] = UFSHPB_READ;
>> > +
>> > +     put_unaligned_be64(ppn, &cdb[6]);
>> 
>> You are assuming the HPB entries read out by "HPB Read Buffer" cmd
>> are
>> in Little
>> Endian, which is why you are using put_unaligned_be64 here.
>> 
> 
> 
> Actaully, here uses put_unaligned_be64 is no problem. SCSI command
> should be big-endian filled. I Think the problem is that geting ppn
> from HPB cache in ufshpb_get_ppn().
> 

whatever...

> ...
> e0000001f: 12 34 56 78 90 fa de ef
> ...
> 
> +
> +static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
> +			  struct ufshpb_map_ctx *mctx, int pos, int
> *error)
> +{
> +	u64 *ppn_table;  // It s a 64 bits pointer
> +	struct page *page;
> +	int index, offset;
> +
> +	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
> +	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
> +
> +	page = mctx->m_page[index];
> +	if (unlikely(!page)) {
> +		*error = -ENOMEM;
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"error. cannot find page in mctx\n");
> +		return 0;
> +	}
> +
> +	ppn_table = page_address(page);
> +	if (unlikely(!ppn_table)) {
> +		*error = -ENOMEM;
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"error. cannot get ppn_table\n");
> +		return 0;
> +	}
> +
> +	return ppn_table[offset];
> +}
> 
> 
> 
> 
>> this assumption
>> is not right for all the other flash vendors - HPB entries read out
>> by
>> "HPB Read Buffer"
>> cmd may come in Big Endian, if so, their random read performance are
>> screwed.
>> Actually, I have seen at least two flash vendors acting so. I had to
>> modify this line
>> to get the code work properly on my setups.
>> 
>> Meanwhile, in your cover letter, you mentioned that the performance
>> data
>> is collected
>> on a UFS2.1 device. Please re-collect the data on a real UFS3.1
>> device
>> and let me
>> know the part number. Otherwise, the data is not quite convincing to
>> us.
>> 
>> Regards,
>> Can Guo.
