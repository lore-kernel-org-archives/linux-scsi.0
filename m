Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0998C35249
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 16:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74AF320838
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 16:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgBCQaI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 11:30:08 -0500
Received: from m4a0072g.houston.softwaregrp.com ([15.124.2.130]:45532 "EHLO
        m4a0072g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729418AbgBCQaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 11:30:07 -0500
Received: FROM m4a0072g.houston.softwaregrp.com (15.120.17.146) BY m4a0072g.houston.softwaregrp.com WITH ESMTP;
 Mon,  3 Feb 2020 16:28:36 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 3 Feb 2020 16:29:19 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (15.124.72.12) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Mon, 3 Feb 2020 16:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OW7lZb0FMGlO2K5HbYUk5tyGLIBesnYexX7Eu71UbpRtuiksagLTo7srlaxQn0+kV7GPMjB0wzvynSm8yfaFkl3OTnHOKgvXIO79vVyn/hh82GXihKFPSpdiw+bnYCgfPZSuX79VYBV49qxNvuwg1sU2XboDzLG2dwFKIwlWXzgAYyhpMajjJTVYkjqs8VdLSshdIBtbcKU5RvrYe1z41bSrQB1Xd6yS7d9IvRAF0ltmmJVdVTJ1IBhqHLgenxmrPdvhAgILqC2smYgj/DVKdupmCy+mOjUoIDll9MYl/mNRZyPJBNutEPGZdep5lsc+uT1YPj/3TiAy9ID6p928fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbvrxZsUTex/uaFtba2/6ycgPtDfDa/xhpeIyTXxzHU=;
 b=LN1x0IbGlcen3xdhLvBMre5bByfTPK4jyfluaQF71ZbuUJW6gvbKg5ndxzyJLnsS4I52ORRAT9mXDDgT0KZv/TOUHDHz6XynmeL/b4b9AhG5Y90UxnQ71b4XxexqrfRxYRWLTb9i6BAafGEDCJNNA4lTc+65WtH+9toSbaIM61qCHIKbB4ceYvGMprqrn+j0neMdgTOUnv9OWSEUT0qnt66Usf7dBuKS8rSVdNa6RBuC/qjSQ7Fdpza2vtpxbjwVAL5XQNGlnDjJLpm4NxaUotGe8tg+F6jmRHtf/2L/pStnh1gNSfEYXcGbtb0TSB+DN8vB9zoH72mFknIRTAKvDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2592.namprd18.prod.outlook.com (20.179.83.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.30; Mon, 3 Feb 2020 16:29:17 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784%5]) with mapi id 15.20.2686.031; Mon, 3 Feb 2020
 16:29:17 +0000
Subject: Re: [PATCH] megaraid_sas: silence a warning
To:     Tomas Henzl <thenzl@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
CC:     Linux SCSI List <linux-scsi@vger.kernel.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
References: <20200131132350.31840-1-thenzl@redhat.com>
 <ff50f95a-1885-9fce-946c-f31861c06486@suse.com>
 <CAL2rwxqDTRmmk_RUEHQpf6MUu5CBaKKBu8W0D3o=y0Yygo6unw@mail.gmail.com>
 <4fac061b-a026-4b5d-b420-787733b961b5@redhat.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <92ecd372-7798-98ec-cfa2-ae1d7532028a@suse.com>
Date:   Mon, 3 Feb 2020 08:29:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <4fac061b-a026-4b5d-b420-787733b961b5@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::13) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by LNXP265CA0001.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Mon, 3 Feb 2020 16:29:16 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4868dc67-9914-40ca-9152-08d7a8c63700
X-MS-TrafficTypeDiagnostic: MN2PR18MB2592:
X-Microsoft-Antispam-PRVS: <MN2PR18MB2592CD1548CD267A0F597692DA000@MN2PR18MB2592.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0302D4F392
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(189003)(199004)(6486002)(31686004)(478600001)(26005)(53546011)(81156014)(81166006)(16576012)(8676002)(8936002)(6666004)(86362001)(2906002)(4326008)(31696002)(66476007)(66556008)(66946007)(316002)(54906003)(110136005)(186003)(36756003)(16526019)(52116002)(2616005)(956004)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2592;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kFcH9FdwVaG+XZxPjrYZ69SQ5ofJP3XZ0u3Oi8LCx2y3nf9+bMBdIyVzDU3VspjZ2JbmYPu4rHpgrHE3/PhHfGxqWNjLfKqeVabrSPoJk74FclIkZcg9j1Xav8szsT+6A5tbFBPL+6CLTIO90v8MYHtEHApYjN9FolHVxXseIweWyjAS4ERoFcFhSuxHZma4VVn7PQDoGTwFs5HUoLfRFw4zr7HhTSNLHNYXFsaGKo0nPR6MipvSMZUDvfanvDeoLe51yRFfCVeB6C1SjlRCC0GSCNagfvV0DKNcA4Amb/EiUx7LqXScTspNuCGH5luGXhsorIGdjuP4plmp7OAgyrXJf5J7+v0OcOzts3idaluvajyoDsbBAuUiwyrNGoefEGWAx3d06nlzn3spgHMMwx4kwnwPBzs4tJiWdqkpgBQ1xMHiH2+ltvcMTrCQF+Y
X-MS-Exchange-AntiSpam-MessageData: KRCadjmJhjxpuDqDBGdKUQDVn6E1dTHJGoQPH4JXHQuYFQnMmgcSxla+eByeAvzBgLPUb9f91JYHtrdeGuratNNyOCXHJZpCFuOq2MwrEJmKOuEUTBjDApsA1EvZHKvqL4G3t1DcWOJmin2U5XAdvw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4868dc67-9914-40ca-9152-08d7a8c63700
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 16:29:17.8358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4c+LzPWXtVTsOSagWZh0t3onUJWsbfKb2VHPbQSa0ZKFac2loWLoNNTlUsFdmW7xbVpi7PfTpnlJwT9crAry+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2592
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/20 4:20 AM, Tomas Henzl wrote:
> On 2/3/20 10:16 AM, Sumit Saxena wrote:
>> On Sat, Feb 1, 2020 at 10:57 PM Lee Duncan <lduncan@suse.com> wrote:
>>>
>>> On 1/31/20 5:23 AM, Tomas Henzl wrote:
>>>> Add a flag to dma mem allocation to silence a warning.
>>>>
>>>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>>>> ---
>>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>> index 0f5399b3e..1fa2d1449 100644
>>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>>> @@ -606,7 +606,8 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
>>>>
>>>>       fusion->io_request_frames =
>>>>                       dma_pool_alloc(fusion->io_request_frames_pool,
>>>> -                             GFP_KERNEL, &fusion->io_request_frames_phys);
>>>> +                             GFP_KERNEL | __GFP_NOWARN,
>>>> +                             &fusion->io_request_frames_phys);
>>>>       if (!fusion->io_request_frames) {
>>>>               if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
>>>>                       instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
>>>> @@ -644,7 +645,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
>>>>  open-isns-updates.diff.bz2
>>>>               fusion->io_request_frames =
>>>>                       dma_pool_alloc(fusion->io_request_frames_pool,
>>>> -                                    GFP_KERNEL,
>>>> +                                    GFP_KERNEL | __GFP_NOWARN,
>>>>                                      &fusion->io_request_frames_phys);
>>>>
>>>>               if (!fusion->io_request_frames) {
>>>>
>>>
>>> I'm fairly sure this is a good fix, but I'd appreciate more information
>>> in the comment, such as what warning was silenced, and why it's okay to
>>> silence it rather than "fix" it. I know from experience that, when
>>> choosing which commits to backport, more information is better than less.
>> This code allocates DMA memory for driver's IO frames which may exceed
>> MAX_ORDER pages for few
>> megaraid_sas controllers(controllers with High Queue Depth). So there
>> is logic to keep on reducing controller
>> Queue Depth until DMA memory required for IO frames fits within
>> MAX_ORDER. So or impacted megaraid_sas controllers,
>> there would be multiple DMA allocation failure until driver settles
>> down to Controller Queue Depth which has memory requirement
>> within MAX_ORDER. These failed DMA allocation requests causes stack
>> traces in system logs which is not harmful and this patch
>> would silence those warnings/stack traces.
>>
>> With CMA (Contiguous Memory Allocator) enabled, it's possible  to
>> allocate DMA memory exceeding MAX_ORDER.
>> And that is the reason of keeping this retry logic with less
>> controller Queue Depth instead of calculating controller Queue depth
>> at first hand which has memory requirement less than MAX_ORDER.
> 
> Thank you Sumit for writing it down.
> An over-sized allocation failure is sanitized in a proper way. The
> warning may hide other allocation warnings in other parts of kernel as
> it is printed only once.
> 
> I could have written more vecasue I've underestimated it and I'm sorry
> for that.
> 
> Tomas

No problem! Thank you for adding this. Can you resubmit with this info?

If you're not familiar with submitting a 2nd version (V2), please look
at the mailing list archives (or email me directly for advice).

I'd be glad to add my reviewed tag once the patch is updated.

> 
> 
>> Thanks,
>> Sumit
>>>
>>> --
>>> Lee Duncan
>>
> 

