Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFF2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 05:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D245464E4B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 05:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhBJFdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 00:33:18 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:29766 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231244AbhBJFdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Feb 2021 00:33:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612935172; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BIlfa2cy/5+Yjvxzsa3tehqtwaQL36b2B1AzhanU16c=;
 b=T4f2DKPgqCbkRPFd+GDpyX9m600fol2D04T/hqBE4pvk41o6w4Xnk5rpMw+luFZY4BJGo+a1
 pXWE7fX/3Vc5kwyVpIDx5zqry8NYYtVnRI+jp0qBA5rhVfqePsPovm3lnForJaxgY2ptFBXa
 hNBhUylFj6XS0Yxey6/YnTwq6wA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60236fe34bd23a05ae12ef53 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Feb 2021 05:32:19
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DA41CC433ED; Wed, 10 Feb 2021 05:32:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0779C433CA;
        Wed, 10 Feb 2021 05:32:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 13:32:17 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>, daejun7.park@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>, jejb@linux.ibm.com,
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
In-Reply-To: <4355a1ebffea1da290389c57eb2b42df75990c6e.camel@gmail.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
 <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
 <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
 <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
 <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
 <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB6575C8C5BEE5BCDA7EBE786BFC8E9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <4355a1ebffea1da290389c57eb2b42df75990c6e.camel@gmail.com>
Message-ID: <bbfc6fa427b7b1972bf55e77458bf809@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-09 22:21, Bean Huo wrote:
> On Tue, 2021-02-09 at 13:25 +0000, Avri Altman wrote:
>> >
>> >
>> > > > > +     put_unaligned_be64(ppn, &cdb[6]);
>> > > >
>> > > > You are assuming the HPB entries read out by "HPB Read Buffer"
>> > > > cmd
>> > > > are
>> > > > in Little
>> > > > Endian, which is why you are using put_unaligned_be64 here.
>> > > > However,
>> > > > this assumption
>> > > > is not right for all the other flash vendors - HPB entries read
>> > > > out
>> > > > by
>> > > > "HPB Read Buffer"
>> > > > cmd may come in Big Endian, if so, their random read
>> > > > performance are
>> > > > screwed.
>> > >
>> > > For this question, it is very hard to make a correct format since
>> > > the
>> > > Spec doesn't give a clear definition. Should we have a default
>> > > format,
>> > > if there is conflict, and then add quirk or add a vendor-specific
>> > > table?
>> > >
>> > > Hi Avri
>> > > Do you have a good idea?
>> >
>> > I don't know.  Better let Daejun answer this.
>> > This was working for me for both Galaxy S20 (Exynos) as well as
>> > Xiaomi Mi10
>> > (8250).
>> 
>> As for the endianity issue -
>> I don't think that any fix is needed in the hpb driver.
>> It is readily seen that the ppn from get_ppn, and the one in the upiu
>> cdb (upiu trace) are identical.
>> Therefore, if an issue exist, it is IMHO a device issue.
>> 
>> kworker/u16:10-315   [001] d..2    62.283264: ufshpb_get_ppn: Avri
>> ppn 480d2f8244c21abd
>>   kworker/u16:10-315   [001] d..2    62.283336: ufshcd_upiu: v:1.10
>> send: T:62283314922, HDR:014000000000000000000000,
>> CDB:8800002ddaac480d2f8244c21abd0100, D:
>> 
>> Again, verified on both gs20 (exynos) and mi10 (8250).
>> Thanks,
>> Avri
> 
> 
> Hi Avri,
> Your testing method is no problem, the current problem is in function
> ufshpb_get_ppn().
> 
> 
> +static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
> +                         struct ufshpb_map_ctx *mctx, int pos, int
> *error)
> +{
> +       u64 *ppn_table;
> +       struct page *page;
> +       int index, offset;
> +
> +       index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
> +       offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
> +
> +       page = mctx->m_page[index];
> +       if (unlikely(!page)) {
> +               *error = -ENOMEM;
> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +                       "error. cannot find page in mctx\n");
> +               return 0;
> +       }
> +
> +       ppn_table = page_address(page);
> +       if (unlikely(!ppn_table)) {
> +               *error = -ENOMEM;
> +               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +                       "error. cannot get ppn_table\n");
> +               return 0;
> +       }
> +
> +       return ppn_table[offset];
> +}
> 
> 
> Say, the UFS device outputs the L2P entry in big-endian, which means
> the most significant byte of an L2P entry will be output firstly, then
> the less significant byte..., let's take an example of one L2P entry:
> 
> 0x 12 34 56 78 90 12 34 56
> 
> 0x12 is the most significant byte, will be store in the lowest address
> in the L2P cache.
> 
> eg,
> 
> F0000008: 1234 5678 9012 3456
> 
> In the ARM based system, If we use "return ppn_table[offset]",
> the original L2P entry 0x1234 5678 9012 3456, will be converted to
> 0x5634 1290 7856 3412. then use put_unaligned_be64(), UFS receive
> unexpected L2P entry(L2P entry miss).
> 
> If the UFS output L2P entry in the big-endian, this is a problem.
> 
> 
> For the UFS outputs L2P entry in little-endian, no problem,
> 
> Because of the L2P entry in the memory:
> 
> F0000008: 5634 1290 7856 3412
> 
> After return ppn_table[offset], L2P entry will be correct L2P entry:
> 
> 0x1234567890123456. then use put_unaligned_be64(), UFS can receive
> expected L2P etnry(L2P entry hit).
> 
> 
> we need to figure out which way is the JEDEC recommended L2P entry
> output endianness. otherwise, two methods co-exist in HPB driver, there
> will confuse customer.
> If you have a look at the JEDEC HPB 2.0, seems the big-endian is
> correct way. This need you and Daejun to double check inside your
> company.
> 

Bean is right, finally you know what I was saying...

We need to fix it before move on - all the UFS3.1 HPB parts which I 
tested
over the last few weeks are screwed due to this... I don't care 
where/how
you want to get it fixed in next version.

In my case, which may not be a valid fix, I simply hack the code as 
below
and it works for me.

-      put_unaligned_be64(ppn, &cdb[6]);
+      memcpy(&cdb[6], &ppn, sizeof(u64));

Thanks,
Can Guo.

> thanks,
> Bean
