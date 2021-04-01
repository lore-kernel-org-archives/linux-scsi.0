Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDAAC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 08:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38ABE610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 08:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhDAIdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 04:33:00 -0400
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:48240 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbhDAIcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 04:32:39 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2021 04:32:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1617265959;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fb9nMJKAmryxJ9vLKIJzlyebAKY4HN5cTqJe+OJXZ+w=;
  b=SA3Ph3t27ludggcd/+ifsqACye9wcf517yKNcdLX4a05oOHM1Ylb23fh
   ijKhxZyjXgbNjuq7D8hgISFL7Qedy5mPSg+tdT6uIEOQZdIaOhlr0U8tP
   q4JyWyQaAzZJmPZriLHtdx4e/7y1YChSJxFJ8hTM93XJBdtUSLsvgsA7a
   k=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: ZhcgzhfVO4v4+rl51WptVJ2zcDv08a7sNmkobghE3AbUmrD5vEsOGpcbtEFoAlmUg+Giajq+2z
 ljNJoTYRb/mK04QpVJGv7Hr22B9tFyZFQwP/P+RgNNe9wfaXmqruK5Cj8O75dFCH5jHREfLAGm
 j4GvYCEgTFZM55BkFkZRGSNc7iRaA3Fh88rqRt/E5jiL/6cpO8BUjNLY8IXvZ7ZV2YQpzGXozK
 wLmsp1vRHSt3O+oeZkbOu0KyoVPAnWbiuit2cmsic742d6Yp6chDJo7wU/1VuF5DWdhX/gbJ1e
 joY=
X-SBRS: 5.2
X-MesageID: 40805822
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-HdrOrdr: A9a23:ikylNKlkPrX97jzpo7lD6+xxXZrpDfPcj2dD5ilNYBxZY6Wkvu
 iUtrAyyQL0hDENWHsphNCHP+26TWnB8INuiLN9AZ6LZyOjnGezNolt4c/ZwzPmEzDj7eI178
 1dWoBEIpnLAVB+5PyQ3CCRGdwt2cTC1aiui/vXwXsFd3ANV4hL6QBlBgGHVmh/QwdbDZQ0fa
 Dsn/ZvjTymZHgRc4CHFmAINtKz7uHjubDHRVo9BxAh4BSTlj/A0tLHOjWRwxt2aUIq/Z4M6m
 7A+jaZ2oyGk9WWjiDRzHXS6ZM+oqqo9vJmCNaXgsYYbhXA4zzYA7hJYLGJsDArrOzH0j9D/7
 fxii09NMd+4W65RBDXnTLR2hLt2Dtry3juxU7wuwqHneXFRSk3A8cEuIRBchGx0TtDgPhA1s
 twv16xht5yN1ftjS7979/HW1VBjUyvu0cvluYVkjh2TZYeQKU5l/1UwGplVLM7WA7q4oEuF+
 djSOvG4uxNTF+cZ3fF+kFy3d2XWGgpFBvueDlOhuWllxxt2FxpxUoRw8IS2l0a8ogmdpVC7+
 PYdoNlia9JVc1TSa5mHu8OTY+WBwX2MF7xGVPXBW6iOLAMOnrLpZKyyq4y/vuWdJsBy4Z3l4
 /GVF9eqG4ua0PjAcCDx/Rwg17waVT4eQ6o5tBV5pB/tLG5bqHsKze/RFcnlNblo/h3OLybZ9
 +DfLZtR9PzJ2rnHohEmyfkXYNJFHUYWMoJ/tIyW1eEpNPXOpTn39arMMr7Ff7IK3IJS2n/Cn
 wMUHzYP8Nb9H2mXXf+nVzWQHPiekv2+JpqC6jE9+0PyIwAX7c8/TQ9uBCc3IWmODdCuqs5cA
 9VO7X8iJ62omGw4CLV9WlzIwFcCUxU+b3kVHtPqWYxQgDJWIdGn+/aVXFZ3XOBKBM6ctjfFx
 RHoU9rvYitKYaL+CwkA9W7E26TgncJvkiWR5MElqDr37amRroISrIdHI14D0HiCgF8kwcCkh
 Y6VCY0AmvkUg7IpYrgppoOH+3bf8R7m26QULVpgEOak16dq8EpTmYcRBi0X6es8E0TbjJJm1
 x89LIeirKcmTCpbXAymvg8LUckUhXsPJtWSAuCf4lagbbtZUV5SnqLnyWTj1UpdnPt7Fh6vB
 2UEQSEPfXKCEFaoHZWz+Lj9051bHyUeytLGwJHmJw4EWTNoXBo1+CXIqK1zmuKc1MHhuUQKi
 vMbzdXIgRgwbmMpWuosSfHEXUt3ZM1OOPBSLwlbrHIw3uobJSSirtuJY4kwL91cNT19uMbW+
 OWfAGYaDv+FuMywgSQ4nIoIjN9pnUome7hsSeVm1SQzTo6G77fMV5mT7YUL5WH42/oS+2B3Z
 95gdg21NHAQVnZe5qD0+XafjRDIhTcrSqqVOkus4lTpr93u71pHZXXOAG4ok1vzVE7NoPzm0
 wfSqggv+yENY9rYsAIeyVWulAuj8+CKUM3sgrwRu8yFGtd8EPzLpeM+f7Pr7FqH0iK4A33Ml
 Ob+zdG//jEUzCYvIRqe54YMCBTcgwk9H9m/OmebIXeBwWhavFb8DOBQwOAWa4YTLLABK4ZoR
 l76cyZhuObdyL33wbLoDtwS5g+jVqPUIe1GwKDGelB7ty8NxCNm8KRkbOOsAs=
X-IronPort-AV: E=Sophos;i="5.81,296,1610427600"; 
   d="scan'208";a="40805822"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4KvaKYoTLGVT8rNo2MRiSQHtN26+/edfljOSIGcO0cNEv17hOswv0knK4h5Fco+etRF4nzOHJciEFLy3ed+iMEJAT1KV5DP3sX0VNocD4/QZY7norwyCi9Gmq4sGFI5bKlY+JkxN9j8y/2p52XW9qWbgJyHK/2Difoa/3pxJDgXw8iWz1kgk/coRrddVGZ00YFK3zbO5aTJAhdjtd/k5u5FNO/trJqWt2ZqBmJ3aDtmn7VPaOrv9bFtsgJQkqvBTTQ54WsouV2coSKHwsRMu40eGPK04wx/TOi/LijM0UiA76YdX8LaDTdkrYA5HwEGxPrS5iZUnnfX9uaiNUjPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzpt8LFHm2RZltGND/oaw/q1K9U+1k0MqbHDyijM9ro=;
 b=ASLcTpCSd13VfIFdcQ/WfYD/7NOeJP2+435rKSO8lBY4m71R550r4uza5WcQHPhlPvci1PtDDOItVXyDsslAYlQWaLk9nUK9Qel6688Ng9fUlPzzitg2RVLC4Mzr2ybDR4Z73gBTyCgDlG/uB04lCmgqQA7My0KAQmmvb+8AzTf7guzXS6/iruNPipqrbHywi0/P+WhVsf36vH0jxJVv3QSXIQP3zoCefuh4NJ+pGNE02t6Ep2MmN4uSCSXdfqmXJhC0FMSbMy0U/7zZ5xvNYRnHInVUFu0NS2FUSMmFkbr6G6oIx3wWlcN8TmXdnDIk5jL/8REHsihwFRzq4fm1mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzpt8LFHm2RZltGND/oaw/q1K9U+1k0MqbHDyijM9ro=;
 b=SbyGFdKy6MsywxuNnFgS/Bl3XGor20rdRh+KZt7wyMEAz0mX7N+nAWRaV1CJ9q/ggFHowLSzdEtkCVwc9P82w+L9+ThtHCBVd+I+Smki1gZaowY7NPPmyaWeopMmyl+JZhv2KjG6zKMyPKFY5HBAFag2PkH/Jy79j+mp5zhsIxs=
Date:   Thu, 1 Apr 2021 10:25:20 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 10/15] block: move bd_mutex to struct gendisk
Message-ID: <YGWDcMV/3u8mxJD1@Air-de-Roger>
References: <20210330161727.2297292-1-hch@lst.de>
 <20210330161727.2297292-11-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210330161727.2297292-11-hch@lst.de>
X-ClientProxiedBy: AM5P194CA0023.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::33) To DS7PR03MB5608.namprd03.prod.outlook.com
 (2603:10b6:5:2c9::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c273f1c-606c-4734-d8e6-08d8f4e7b3a8
X-MS-TrafficTypeDiagnostic: DM6PR03MB5066:
X-Microsoft-Antispam-PRVS: <DM6PR03MB50667F5F8D9487A1B83656B88F7B9@DM6PR03MB5066.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KbX+Rde82EBvjgicolgst9BFGvgpL7/YU2zacLIedQMlz8AxwJrcFkMpZgKdIoUb9cKV/oabBL0WYaDOhI07z4IzwVuprCgdyxV+/PHM/2oa7JWCROXpsdsYgRA9XAH+w0wdLxpGx9LUaWV7IKvuFdyfK0ST0llLZ2Qhwe5lRJCGntk/LUoHC61Rvv64i3Nb0twUpVq2wwy6bC/SeEEr70Z5j7SCLmcahMnnk/nO5bk7ORxkwYMtcK61hRmqxm16IXULc3yyT0sWaU9p8yRQak90LzEzsOb9TqSBaVWgmEOy/lR8IWeFpyP4EBDIubVKoiWwp5nUfHCASAbPhUn2pd/yQp2zrUpVvkTRnkNbNul59NDjMJpn4rISHneeu0GAq3Gd++O8cJo6i67rw7UcCWBhvsO/0GclfsIuTNUpQMqrFBGRHMaP1E71HlQ8QIRHqlXa43vvq2eLcaKn5nx90RwAgTdnnPVZsYxNgMf9J0IPoIl9w7WePhzUFudQlqjHLz28Bh2WHfTxF6AQTM5go0BqR8WXi4IO8pJzsvOSUxkhuOJPL1khMDAovXg5ywPpfBqBMheM2K3di4Y4cy2GKiUFDkUh6c1BCxdKjJSgwvql1ZINJ5lJfSeEFvF3pki4hEHj3GixugvMi+YuEnpVyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR03MB5608.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(396003)(366004)(39850400004)(376002)(136003)(478600001)(16526019)(186003)(8936002)(54906003)(6916009)(33716001)(2906002)(4326008)(7416002)(26005)(85182001)(6486002)(8676002)(6496006)(38100700001)(4744005)(5660300002)(9686003)(66556008)(66476007)(83380400001)(316002)(86362001)(66946007)(956004)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SXUza1pFL0xyMVBGZFFtc0dkR29qbjZXV3BkTVRwZy9VNy85enZJSE1rbFZx?=
 =?utf-8?B?QWRwUy9aRElSNGRKKytCTVQvM1EwaFN1TEo1aDBPb1k2d2o3NWFBUFdMRUpO?=
 =?utf-8?B?OGVITEwyMC80TjE0dGVQTnlST2h6eVNGUUZFSmxIUzJLeEJ6VDVRM3N0OEJo?=
 =?utf-8?B?blh6N0lUYlRqVzM2VElhVWY1VUFaTjB4RUx2NnVFbVBsclJQZ3cwaTBLdHpo?=
 =?utf-8?B?Nnlka1lWRFE5SEpjbTg5anhvMStzZ1JHcmVaSk03MDZINzJ1d3RtMHEzMzcw?=
 =?utf-8?B?OGRsU1RHRTQwZWRUTkVtSU9aMG9DeHN3RUVrRHcvK3NDR0VXcEd3M2p6alU3?=
 =?utf-8?B?K0ZTaEJmbFU0VDNaVU41ODBDOUJ1Mm9VclRnRFE4K1c3OTFrQThYVWhJRXZj?=
 =?utf-8?B?MWx5Z3IvOEp3TCs5WlFjenVMTm56RHRhdG9ta3d4R2VuT3lUdXNqRXlaS3J4?=
 =?utf-8?B?MzdLbENXZW41SzZMZms3aWNpeko4YXROZm50MHRuQkhkeWdKVHJvVmhMQm52?=
 =?utf-8?B?d2dUc0d2a0NNdklZWGpKTldwK21BdENMWllyK28zK0l5aUZlY29wOWp1YjFr?=
 =?utf-8?B?RDFmZEJ5L1hjeWtUTWFtUzh3SkFTNStFN3JlbXd3aS9QUE5hOENsUWdBdE5r?=
 =?utf-8?B?dDk3ZEtQLytTemVZZVdZRzkrQTVYYVZlNXZUL0s0MXFtM1h2UXdPWkd0eDJl?=
 =?utf-8?B?Q3hmYjJVRW5sN0VOY1BlR1dwbkFCWkZ6c3A0TTI5NHk5eCtLd3FCci9TOGNS?=
 =?utf-8?B?ai9YVk5JcmU0ZmQreFVhYW1HeHhueWkvZFNibTNOZDM5RTlVazczNzFwZmw4?=
 =?utf-8?B?ZkJVaE0vZnNuVURZQ3F0YmFNOHdsYzNGVjZMbmJhYXNQNkdqb2F1WTdVMjdT?=
 =?utf-8?B?ZUxuUHhjZi9XUkxGRXlsTmlhVW5DS2ZxNk1PK1NYREhoRk00YTBjN0tFRXA5?=
 =?utf-8?B?K2hOMnM0QU83V2p5QjQzeCttRzhuenFGZnpjYVVQK1ZYSDJjaGpENWVHdlFj?=
 =?utf-8?B?aVMwbE5FVGZlTjJpdUY3K2dmMlZWTVlkZFBWZDZnL0FmbGJSUEgyNk51a1JN?=
 =?utf-8?B?Mm5BU2F2c2NLZzl5eEJ2enZUYXBrNHdrMjVZNExONkMySVZvMFRtbHUyWm56?=
 =?utf-8?B?bWUrOVg4bWJPUFBCallEdlp2U2RYdTdoZ1NjeDZadGxxQmdseEFkMUxMT013?=
 =?utf-8?B?QnJ5VmlJRFJRNlN5MjBVNVlMVk1hS0FRQ3dzM0ZsUGY1Y0dTUC9iNG15K2pY?=
 =?utf-8?B?OUZraVQ2NWRIcnJEc1h0MEVyKzdqQ2RDNU95OE5QK2w5MGhJeWxLWVNMa2NX?=
 =?utf-8?B?MmZ3NEtjNGlObGFnRks3L0pNdmZQVE5ici84UWhkK1hSOFhVRG95TS8wMDE4?=
 =?utf-8?B?ci9BdEMrcVVTc2NrMjM1UUF2ZzdYUkpUUGFINzBtTGo4UHF3K2dJakpyMHFw?=
 =?utf-8?B?dDR3YnZDUU91YytGMlR5bzFwczQ4R1J3aHhCclMwcVYrY3N6WjY1TWZiYjA2?=
 =?utf-8?B?RldxdktrdGNqMDNwTWtJeUdrbHp3QTdmMzJ3YldrVnFtUS9Pa3BkU3cyZEYz?=
 =?utf-8?B?R0MwSWFMbU56SEV6TXJEazZMREU1UjUzS2o0ZTJ4ZjRwUFE1bnRRTG5iQ1Mz?=
 =?utf-8?B?RlJnQ3V2bnlnK3NONVFpWm9rT1gyb0lnVWoxeU81UDBpYVZWVTFvcWtNaFZV?=
 =?utf-8?B?RW9BbFRVUytGVVdONmd2MXJUTGlTSnJYVGVuQ3NGbVNGZS90VktPR2JTaWZL?=
 =?utf-8?Q?00JK+e1JbXbDtQyAVr5mBlL2dQKNV8kZ9oIcyx2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c273f1c-606c-4734-d8e6-08d8f4e7b3a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR03MB5608.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 08:25:26.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwQTyswAfmWhOBXHilS3WKs0vXrJ1wGaOAvXUo4cQsC2zsSbESaFmhru+EO7jc4AHjlgEf3WvYlb0X2YaMqlpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5066
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 30, 2021 at 06:17:22PM +0200, Christoph Hellwig wrote:
> Replace the per-block device bd_mutex with a per-gendisk open_mutex,
> thus simplifying locking wherever we deal with partitions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/locking.rst |  2 +-
>  block/genhd.c                         |  3 ++-
>  block/partitions/core.c               | 22 +++++++---------
>  drivers/block/loop.c                  | 14 +++++-----
>  drivers/block/xen-blkfront.c          |  8 +++---

For xenblkfront:

Acked-by: Roger Pau Monné <roger.pau@citrix.com>

Thanks, Roger.
