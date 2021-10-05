Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0725C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8BFA61526
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhJEEfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:35:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8034 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhJEEfV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:35:21 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19534b7m010255;
        Tue, 5 Oct 2021 04:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3freiAG6jjSkXiGxid/QGRWO/HhUch7EzdAciV1AZNo=;
 b=ixdxSJA8aLclO1hUB6rwjqptRjkCtiEg971b0vdZ6uHiwZvDphiecfu45MyDHir41xxi
 l1RJAIxYSq+CHcw39Wxd1uycwN+Yo2c5Jv5yLEHEynhkAE7gIzwv0eC4ANYKUYP8Dur8
 /aUvACnyvRA1mvZE0W1qpy3m3OpEavfLy8qNX4t8F7T7mSIcAcYoWlbnGZn/x/3pAliN
 /VNbCPUK2jcr9ch2jWNI1z3Yy8tHMOie28t+foB6WbbOV6V9njxk/aXMLNUwByoz7IOZ
 i2Rr5IJVB6zJNyV+5zyo7CJW31g4e82PuO9qT47i/pelqhIcnt+smDBel2FOP+b+dpwp Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3upvqx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UdHq029873;
        Tue, 5 Oct 2021 04:33:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3020.oracle.com with ESMTP id 3bf16se29c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fv0I9mIDHGNEWlD8JuHx1vcsjP3bzU2Nu71u7HntRy7bAfQkKv0q62cw692i3uX4QwzeT5My/7cLZSKURx74MTakw6hSF+yXRLyi5/Z31qfearsJCXB3QpyEQsyqLPUSVS0oQ6BeWszHkzYMZMyG/UCN1md8P/+8cb+0sRcRYMevzKURRXgkRJui5WTHib2Xv/koDHqnRRUHGBSmRfZkeaO48h8AGiPU6ZqbDXFzrbWVzQIizzIPE6Qi1QQCq8+J/G3UtswLVA77ghaXXT0Zp6cjm3g4XB35vhL45n9L7KREMF2cgXH4W0hpBTqBpr4Gm8e7ZQR4jcO2trUUG4OQOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3freiAG6jjSkXiGxid/QGRWO/HhUch7EzdAciV1AZNo=;
 b=lcYWe6RJEgQjZEwR6sOGVZKWmhZWLEMRllr47VhE02n37tXSabg9JPZKkIul6TGiDcwk4zhKJxaa2PtLYlKrcVViw7bptG2vMCi/JCFXp9LA5TRwgaVTOZv78XqnmFZp0qF849Hiefj/n76Iz2I7/yeleq2qQJ7b/GsN18rcRMzJuLY5dj57G+hCUVxDBeiqVOVFdzZEeaWszenZFbZe3eMBFE18qCobbCiuVyUoyKrvyBuQOb6GKU4+7AqiZdEvA+i781NjO/3+n09KzJuDTx33jlXUyoRIpGxviB4EoZ/MWKROhnlnO2//rDwazy0rXGE/4L4iB3TkWX1Lw84SHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3freiAG6jjSkXiGxid/QGRWO/HhUch7EzdAciV1AZNo=;
 b=NqJSrLP5q+Ukepwxrs5V0ZmDVlodZgUOjVWsWFOQCnU5P4fchw20FM9CJP3RIcYQupb5OWw97PZBDyKCT0I1+ruc6206rWywG17WC5uVek9PFca4THfwpTw6SG3amz0Q6ardLUx3Knui4U9RXXGgFIvvRpHyO5d0hb2NvNh3tDU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1885.namprd10.prod.outlook.com (2603:10b6:300:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 04:33:09 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:33:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Jens Axboe <axboe@kernel.dk>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: ufs: Fix task management completion
Date:   Tue,  5 Oct 2021 00:32:59 -0400
Message-Id: <163340836500.12017.3755166310975946882.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210922091059.4040-1-adrian.hunter@intel.com>
References: <20210922091059.4040-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0096.namprd05.prod.outlook.com
 (2603:10b6:803:22::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0096.namprd05.prod.outlook.com (2603:10b6:803:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Tue, 5 Oct 2021 04:33:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6e59393-a261-4e48-f32f-08d987b93b88
X-MS-TrafficTypeDiagnostic: MWHPR10MB1885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB188506F54E996FB02C1438108EAF9@MWHPR10MB1885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkpwN4qhYMq3kUAF0b1yWHyLxBgsQuu4JOizRreGtz/gDLI5zgwngk6suv5bkTUN8OZAJtUPxjqeIoWdCFxvv7sdAFqt1UPfyg0NkWFKpaVCiO/B2QxZ5btdq2EdSnaACG494kcBBIV386x/odRIL6q39Bec7RcUpGmZKrqSyuhjfxbVFOAdd/t8J0/fmtKX/u5i9Okaa4XiK0e6l8E0sjBzLJ2PSSJsL26UT+X4l0fup0qCWiYvalSszR/RsXw2yK3cYnVfEywRDk5oOvVXJyB6BHbGy4Ts5Fal7nzSvdcq+Ze7Byfh33h3V2fwhslCDCe1suWJICGUbbMlBbPW+h64uJqzQ9dfzT2OFeUyHpDxf0C/Y5Ff9xUp0GIAWe2vqIHemmHp7rFlcxzaGNatbvxD+ofwghT4gfKwFpyy2WBWmjRjiSeXf1QZ2bbkItvszKWSqDf5NNw3nzePNxg02kKZLY2ECXMRrgu4tUi0Ne09AO8BwveG8nFbtDsdAHJDF2iQRf/xwiweokbw+705S4yB33DU64NoTgp1lqvwn5K5nu6GgMXR7OmmkrLFOL0J+HoZmWJrn7NmR71gGng2MNccws2WaLhuyqXOX/JiR+D2zWqH6tRV8Q9R4VlEI2VCZ1M7cHN8gI9mccgDVxGuF3U5SENsTKMo3qYJu1s6FtmZP4tCgUEVZx0TEqNOQulppnN5JeOmUxkBIBZ7KwtJMdYcx0SatiEXOthSXT3StXQAIwOVkt174X3tCHxqSpHSAUs/r8W8Av8KHZtIF2NZFYbnCaDBI9s/YNclsuVfWps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(8676002)(956004)(52116002)(7696005)(54906003)(6666004)(86362001)(2906002)(26005)(36756003)(4326008)(6486002)(4744005)(38350700002)(66476007)(38100700002)(7416002)(2616005)(66946007)(966005)(66556008)(5660300002)(8936002)(83380400001)(103116003)(316002)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGdOdEJqaktFZmVxa0xSSkJuWXNTbGtTbGhCVG9pdkNrTHM3dW5saVdGNmpY?=
 =?utf-8?B?cEc4WlV6ZFBIVnBQYUl3b1RyVDc2QjU0L0F1eXJQR1p5UWwrMmlPLzVWU2k1?=
 =?utf-8?B?STZyU0VvYkZqenJ6SzllNm1vUER4UEIxSm5ZZDVyT3Z2VHBRSGw0czRsVVUw?=
 =?utf-8?B?NXRtY1ZIQkNUMjkxRE9LYlVnUDcreHZsR3RzWmcyUy9XVTVSQVdvTDZMM0hz?=
 =?utf-8?B?OXVtRFFZT1R4b05QWi8wNXhBN3lpSUwwaEJUdS9DbXRWZmZISlQzbDRsRjRX?=
 =?utf-8?B?cWtiRmNWMlBBVlB0VCtaRWZxRFVPdHd0SVlsWlREbWZNSlNDTU45bGQwQXNx?=
 =?utf-8?B?ZWJ1SVBLeEV4OW11WTluaFN5bzArZjU0WEp5NG5tNkdQeVU4RUZpZU5wM3Q3?=
 =?utf-8?B?VEpoYXN0SHNtSTdLaHZQQ0Z4a2Nrc3dlTis1UUJSNGRGVmdydnIzcUpwNHNM?=
 =?utf-8?B?bVQ2UDVqdjlQc2lXeHk2V3ZXUmpHdFlOeWU5dDZzUGh6dHJrQzhpRCtrMUIz?=
 =?utf-8?B?TGx2ZmZLK2toSEg0dkVJUWRZR20rblZBdHAwS1hySW5wcEtHd21ubzl0OGVl?=
 =?utf-8?B?UkxpR0h2YklCTlM4NWpxckhWWkJ4OThhS05kZkRpS1E5UGE5MWloWkVpODgz?=
 =?utf-8?B?bHNBWEVmY1RHWUtjUGhZU2tCOFdrbUE4VUl5Wm01bmpQai9mbE5UZFk5ZENv?=
 =?utf-8?B?U3ErOE5NM2h1UnNhbmVhMkJkZnFXc2srQ0dVR1pIQkljK2I5aDYzUlFrc1RC?=
 =?utf-8?B?cE5aQWR6ci9sSVhWMWt0VS95d2Jnb3Zyc1JGNjhtSXB3b1Rnem16dkdMNzEy?=
 =?utf-8?B?dFdIMFZBTElMczVEbVdXZ09rQUdVNHJFdm55eVBSRElCem9aMzNGcXBMMnFZ?=
 =?utf-8?B?MHdFaFh1SEExYU1HQjVUd2p3YjRaZVJsYm5laWVHNkV4NjRsdVpzRDNpaFJ6?=
 =?utf-8?B?Ylh1OWc3ZVhzMVdkam05OEtlaUhqUkZuMFZ0U0RTMFV3dEorTGgyVHpISmE1?=
 =?utf-8?B?Y0Fncm5KMFdFS2NmM0Zub3IwbVRKTm5PWGhnL1ArSEJLeWY0U3l2LzhHRnBw?=
 =?utf-8?B?QzNENnNOOUZxQTBscnNxcHp6MGdXNU1FRXluYm1FaWpleXZBMlV4UHNRdCtI?=
 =?utf-8?B?dzNMV1VqaUJmT05GNy80MlJYaVQ5UU1pRWh3Sm9OaTMvbmNtV0RCSTMwV2gw?=
 =?utf-8?B?TnF3V3JzaXhMTG05M3IvekY2UE1SN2VSM094bUJiNy9rQkN2OXhaZytGOVh5?=
 =?utf-8?B?NUF3NHVaZ0FBbU9VNWJaTUlOYkFuaVNqaHRLSmhBN29rMlNXRFF0N0FKZDcw?=
 =?utf-8?B?U3JmeGJ1SHoydWdtOWF5ZlArd1VsYWJvVDR5YXRsakNrSVJxNGFWdWZYSmJu?=
 =?utf-8?B?SjJPNHJ6cWRPUTF2MzlLTnpXOXEwZnNmL1U5Y3FzQkNJRW1QbHV3U1duVDFn?=
 =?utf-8?B?WDRYeThCOEZsRS9odEdBY1JacDg5NnRBVDFUM2VtQlBDNVI5NE5sR0VJbHdE?=
 =?utf-8?B?YjVIU3ZsTzV2Y2tQelFCRWNmN1NGWjM1WXBKUExibXVoOXJZNVFvUldkT0th?=
 =?utf-8?B?K0tJWTRhc3YvZ0o2WTJqb3JCdzNXYVZvZzZGc2Z1YnZKRmc0bTlZa2pQRTJ6?=
 =?utf-8?B?NndqT3ZNRkRLcHJyalJhZURnT2x4YWxlTzZLcFpyWStRRFJyTkU1TDBKQklI?=
 =?utf-8?B?NkZEV0dDK0FNMEthSlNnVVZNSEpkNFJQR3JjWnJ4TVBwd3FZc2NQaU8rMktH?=
 =?utf-8?Q?z61b+FSh6K83wiwXCt+ps7vU/jQFw/T6pBK78yq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e59393-a261-4e48-f32f-08d987b93b88
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:33:08.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewVQkL5atSYSOyExsaqgO4EvjM2ttqKiOj98jYUtt10CkPVWgGAurOzJSw7a9xTdhFahmuwIYuB2x1S3O7b28+znFaZKhVafd5jiaaLiqc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1885
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050025
X-Proofpoint-ORIG-GUID: hJQ-PYk3l4S7n7-hJx-5RRJVXz_RUksA
X-Proofpoint-GUID: hJQ-PYk3l4S7n7-hJx-5RRJVXz_RUksA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Sep 2021 12:10:59 +0300, Adrian Hunter wrote:

> The UFS driver uses blk_mq_tagset_busy_iter() when identifying task
> management requests to complete, however blk_mq_tagset_busy_iter()
> doesn't work.
> 
> blk_mq_tagset_busy_iter() only iterates requests dispatched by the block
> layer. That appears as if it might have started since commit 37f4a24c2469a1
> ("blk-mq: centralise related handling into blk_mq_get_driver_tag") which
> removed 'data->hctx->tags->rqs[rq->tag] = rq' from blk_mq_rq_ctx_init()
> which gets called:
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix task management completion
      https://git.kernel.org/mkp/scsi/c/f5ef336fd2e4

-- 
Martin K. Petersen	Oracle Linux Engineering
