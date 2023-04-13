Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B213BC77B6E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 01:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDMBRm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 21:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjDMBRl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 21:17:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9C76A61;
        Wed, 12 Apr 2023 18:17:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33CJTDDN031304;
        Thu, 13 Apr 2023 01:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=tE3gY/44wF4nP5Zbzqz9RqsmLSssNqcBnbyKnx/buMA=;
 b=lmGk1Vkh9CaQRmmMF3QNByJLcKHicMWQFih6qt8fiv7CKJMrA3Uch+eukgasadUcy/oC
 cSIILphXpOahf72lle2VgOarRmhU161Mgnf11pJTBL9GWgns2K/w1kTN9BkFn/paGehU
 Ui11av/h+DgBD87Gq6RHbCJ84zv4Wswul+x5+tyEBKi5h9xVGZODf43OXCw6Y9Gb9Ui7
 8pDYqJRz/raK+bcb4d2Sx7P/cokeYWKcGAmiTZjTGD4Uoh3BljNuPRk88ZwS55wcPXxa
 FTZpyZFc/aaJQxnFsPMS1Io2jzvfOP5NkMHhg19DGaSXGRkzg188rerFPVUT/SszX02C Qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7hp22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 01:17:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33CNPJ4S039733;
        Thu, 13 Apr 2023 01:17:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbqxcjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 01:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHqafxvkpYlrRt42deiB9lJXwfR8kOPsiW+0Sz0gXQX6Nky23JIJ+sly1JlPZ17ixe+frzL+5QF05aYY5oLTlpQ7O3RQnNHV8pO5vuWfpm5APOwCFdwIh/R2Q3YlDGObRfuOfqSOyzy9MeDfAY9i5eg8EiUD2L0020hJDWtyh2yiHcvJDvnupKnx0M91Ws8SXZSjLCFYv6PUMsYAO2uWlYrCFBKXXbgKJxMEeNa2ez1Kz18n4euMHpa5x5R2kPF6a8rQjwO3Zk1eTiyJRuy2pbaGAkQUc67HE7Agtr9Sl2IqSlPp2C96tgIPJrbIHojMJReydmC91FYYQOe9vPVXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tE3gY/44wF4nP5Zbzqz9RqsmLSssNqcBnbyKnx/buMA=;
 b=iUC1NlFCl8+y/dZ8I8Pgi6M/mCp2oR0K9DzqXC7AcftkguYj+d4/pRmvgRguDLlOoSZ03V1m4r7tKRELc+Vs1OzdODFlmjB/57Wl7Bd7Vw7r/5pUNp0p2lymw5s1Bwp48ll392DLe/FRAxHA/38oZO0/bwW8BSiW4fiuxruPu89E0OuehMwSpOdgds+ALJjW4Y13FHgYVTMPWBy2Thjwu+y2bE6f3nQBIH/1xJLKeEUObaiWNz5Ehrcrp9etd6J/p+c9/cCkXj9fuJKHdJJrZtXzrle3srfPkQG6FnV1NDhsvwZBfdRgY02GG3Sgyn5/x22XpfXlD9F1+Gu253gIqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tE3gY/44wF4nP5Zbzqz9RqsmLSssNqcBnbyKnx/buMA=;
 b=dO9gD49PdqiaULqeSuXgerA5wjlfVQWSJGpHIPdUkRuEjTeL6WnIvsNTDxd6ho8YuhlvgnJXL0jo9KuwYutY1fCs9vXtjJaDu97/wbTH/ajf/q6y+ZlKjsvrIMlNmaeZoKm3mPltsCUJb8Tmoixuu1OLFX4s5XjyhgRisf6Vo2U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5250.namprd10.prod.outlook.com (2603:10b6:208:333::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 01:17:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%5]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 01:17:20 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v6 00/19] Add Command Duration Limits support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rewd1qy.fsf@ca-mkp.ca.oracle.com>
References: <20230406113252.41211-1-nks@flawful.org>
        <fe9fdfc9-5eff-ba29-5139-0aa44ddadc35@kernel.org>
Date:   Wed, 12 Apr 2023 21:17:14 -0400
In-Reply-To: <fe9fdfc9-5eff-ba29-5139-0aa44ddadc35@kernel.org> (Damien Le
        Moal's message of "Thu, 13 Apr 2023 07:29:04 +0900")
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0057.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5250:EE_
X-MS-Office365-Filtering-Correlation-Id: 65cd64f6-1a78-45a5-bca2-08db3bbcd464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ufTOpDCQdpUz0nyZIZAaWNMS15FCQQHJpI3BsGDkwRnPIeKv2oElsduX37jLOA9MkyywKYrvlQXgmHtlkl2pDSygScY7XsFCivVsVWsh5LiRd+uGdBxbv4WruUkqqDHYdo2a8KwsaNKtycqNrMYFhuubdER5hgfxzWLyc3yK0QjpARaNZpyyT6NqkrDaczyPpzx8AKWdEG5d4OByjINJFEenXkKqr4QAZx74MoJcvi6VdTlJwIX7yx9Eg/CsoUjOthejtxJxoSF2BHdlq+yUSUOgNv2flyrV6WcByfggEoPT7T8HgosMwQ5BtMIGWFy7iC5SIvBXevh1Dww/FLv0R9i3441DpCnVjrV+aw2rPGJ0DCoOc0fX1TX8zoNwmHWo2RxmbDlwGZCByS2ndKyCRwHM4OHIVvW9C0uzYgjm8teRatPPzO1jwfAclALB7UFk4vlM1vpjtAi1iCeHg0jpV8BGRhYkGomkzgrK7s9kpAXreES+gruZlb6+hNuI6Xb1VKwfHgYilgTD0MLygYqLtEZZfwreH9RSXT+5lipBPZx0IqNwlg0S9PdCSvOww242
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(478600001)(54906003)(36916002)(6486002)(6666004)(41300700001)(8676002)(8936002)(38100700002)(66476007)(66556008)(66946007)(316002)(4326008)(6916009)(83380400001)(6506007)(6512007)(186003)(26005)(86362001)(5660300002)(4744005)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9l+dKLXG5HhSm83OBuwSbCM/5nq6VTnT8vmczOcu/1kxC3EdQE12IBOQYir0?=
 =?us-ascii?Q?SZc6vxeonqv3CxhlKT4yD3xUyYoAJIVls+FfKQaC52vyQAMgbn0TT6Sal/CJ?=
 =?us-ascii?Q?QZvYnqex3dPGRjimfGwMeaFqhBC8ip4lgPnrrGzV5S3OZt8/KXQX7Cb2lUgZ?=
 =?us-ascii?Q?gEl91ExMDmYWGkRn5bNbjp25Ym3RrHNE3M0Q5p/Drz6/EFHmLkHWlqDpLLQO?=
 =?us-ascii?Q?0l8zHl5aUp4jvpaufFLN27AVRXccg1VpkYlaxa1QGdVbLO8TojlWQn1bRw5h?=
 =?us-ascii?Q?N1/E3iZt/SsY6ZiRXDFZN4xmicU8fNntJlPdfvkp5AO3/hL/2+DDE2e3XzXA?=
 =?us-ascii?Q?ko/ZcXbVQAKxlll1JqgAIvHF4PlAmcpW56quf2ja1xSrdyyeciFwi4LGXBOG?=
 =?us-ascii?Q?sUYRPUcweZ54IWJGw3TXnHVsPV1C2EKa48kYkcxLVYbwuw3vn8RLsYjIQDMb?=
 =?us-ascii?Q?M44uwONlsUTdxZ8jX34hbSLm5kv46rPo/OTDOjPHnUiA2FQv58kTd8NXmL0U?=
 =?us-ascii?Q?dy47eGFAAxAqaGzrgnIUj8JlCwm/BQby3olLC9iok0wfQmObGq7ZIHDpTNfB?=
 =?us-ascii?Q?Ay4w52VEeaeWV8SkNDoe8V3Mkgnh560/vwnxxlZ8ro69RlvLxB7WkPPhnq1Y?=
 =?us-ascii?Q?/D8PsD6/zR1aeZdzLrOFZfXM7IxhXB+DRoyxfayogtbmaxqt1aqLfTjrGEwv?=
 =?us-ascii?Q?ssqvrQYjVWF2JaJIR8hHA0CqJ4qJ5lVA++gfSxT3HE6Ui7cgXHMY9n5/N3Lb?=
 =?us-ascii?Q?smQxWBEd8haMBjbc3qR074ucplzGTneJDmn5YYE7IdcgWY6OxXSfrrs1qody?=
 =?us-ascii?Q?GG+696t13rNvNwD6A4WlYtISUIO0IdgQJ7lOjtYPNnKfaZwpgjb2PdQ4MG0U?=
 =?us-ascii?Q?Q4NzMRD8kn+n5EzNURP1HNuJkU8Lsrr5o6k5sEgEguj43jyWi0KcEWq/cKzd?=
 =?us-ascii?Q?wkah/iCKy6zvC6nqNfXwsy3CNb+v2IWmMnZLsulfpA3HrpYi1qLn2sBTpjIo?=
 =?us-ascii?Q?WbmJ4itaOd5Zjlp973zv2ue4xM6ISy/fUoWyHOxSF1rewwqQpVKu2uLI26z8?=
 =?us-ascii?Q?dIpRMV6XlqcSQTSmXoVEQHyj9VbTYkKCmPjrWH7bn0c+nEoNgIU44B/0Co2p?=
 =?us-ascii?Q?MQs5hmbqwE4tCBRc2vuYZaORxvYWuX7poHYqAwPg5FamARrB63zZ+zn51+hj?=
 =?us-ascii?Q?9HzgdFsbbbwMsaU98kpIoYXHL868OasVoL6rwAh1Vx5L7PsOelC+0uJxLpFQ?=
 =?us-ascii?Q?sd07kdxCzpyZhsXKqFQCQBLOGjHfyJ12g/IYKF7K+IdzgNsXuO9xoZlGp82R?=
 =?us-ascii?Q?tBjitVJ3zzcNWXe7sKzgnLPS3ZPr97G7G0MTvzejp/54DeVgBRkkiDOuKIQq?=
 =?us-ascii?Q?WutYwCtiLnyWo3Wt9ow9HOAri+U6i8vJOu5xVo6+np1zGqO36yOsDNZzawLr?=
 =?us-ascii?Q?Uz3tqoyRdOzJRh+JiZhkE5PbZQdMtawSyykveN42sXxxAPfs7l+T6CqCdHKF?=
 =?us-ascii?Q?MQhraIbSq/qzVQop7FV/uq35crOv82a2s5S4mWZIdL3TgyiiafX2SoKZLA5M?=
 =?us-ascii?Q?oP0w8F7D2ptDE4ntmRNKp5Z4dUd7WHa0IYheUsBoTKdQzl4mqwbXEvjfDplz?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?y8djlfSRy2VqfmdB2sn87bjV2kz2nkj2vJ32AQnRnI1qWOBJys71risILcly?=
 =?us-ascii?Q?TWORjm4tYXOpBtTw1Yk1THn5g9Nmz5k7N3jZymQOL3U44ijh6Eh7cyIxQtjE?=
 =?us-ascii?Q?tPiJtQTTWth4mcT5afETQvyJAsPIINsapNDkWpOB+RXCauBSeVsAdZZgm9nj?=
 =?us-ascii?Q?Cmx0nPPivxrmYEeCqIqif/o3BLdeffTyDiq5R3WcDv9cP2hsYIxBlWJkWLBj?=
 =?us-ascii?Q?3VfAoMSb/PhWfF9gxyZAIORdOwvOOtdAcQwtpt6pKt6UH/j89iYLwFf5IHLi?=
 =?us-ascii?Q?YottOz+oGtxNQO0W75cJXqd46dNFWLrpcUQ7kjqz/N+QAzBhZgEjTA76iKtW?=
 =?us-ascii?Q?IJ8uhoqL3FOShpBAFeJvfD3FzTAWvaxjiXKtw5PFln9Wr7I0v9p43mXcJUdQ?=
 =?us-ascii?Q?ESnj7MGZUueEy1jT66uoxWfm6IRfBUEY14HSDtDJQn6V1SlEp6y68CuPsm8U?=
 =?us-ascii?Q?1RgIO6WqCr8DBxOGcEOf0HdfzPoWyezXaI6lz2yPAqAR1mDIfhyxgJYUgEct?=
 =?us-ascii?Q?8osE9VkkDBjYwxn5QhUSjWzfoR928IbgmyWzL/B4PuB9wuy4FOkyg6fZyIW/?=
 =?us-ascii?Q?oQ33GaG8pJBxg4q1A4EOmUwGTbbWdhILFFl3kuPY2DIqBSvcsNCkGplA0Y2M?=
 =?us-ascii?Q?lAkG823qePG6+EPmefNkrvQnYAyV2MXPSGxRm9Nj7mbZg3jNUMywRHjy1C/Z?=
 =?us-ascii?Q?JJPizcRb73voIdd/5nuRKfA9ldhClarlaFoFusMlDan0tNrSGDJRFpZ8k76X?=
 =?us-ascii?Q?oXJKigKb7275snkAV129mAN8oYBPMZvh5MGAc+990CsBynL+Olxx3QWstm8j?=
 =?us-ascii?Q?ZAVwYWgBrWDD2W7VeSljVMYQodJqR66Jr171+Su1RYOnOjsUswrpOlZLqr4x?=
 =?us-ascii?Q?gwj0MkZwM7bzniVlxVDPCdL12iFkuJcUUaeBqBipJHLxli/xKBb2zJnRrqop?=
 =?us-ascii?Q?VaAE8au/+kxj01K4gTdBYF8kBpfn+5uKNJipXmIzxUg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65cd64f6-1a78-45a5-bca2-08db3bbcd464
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 01:17:20.8203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82wAswz8MorKAN7kxTCL+eEX79/mJuFuc1KsproY9lPf7TCWGU0nTWt5DdrDA08mfu8nFwDOyhKpdcUc8PmUU94gZT0xg5waknRgmFXptF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_14,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=783 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130009
X-Proofpoint-ORIG-GUID: SDcjAG36ZvU4DWI3L2Y2VI3yEeo9fnTI
X-Proofpoint-GUID: SDcjAG36ZvU4DWI3L2Y2VI3yEeo9fnTI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Any thought on this series ? Can we get this queued for 6.4 ?

I don't have any major objections (other than the mode sense hack but I
agree there's no obvious way to avoid it).

My only concern is that it's a bit late in cycle. But I'll at least put
it in staging and see what breaks.

Jens: Are you OK with the block bits?

-- 
Martin K. Petersen	Oracle Linux Engineering
