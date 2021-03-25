Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38977C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1685061A12
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCYDyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhCYDyH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3oWIr040400;
        Thu, 25 Mar 2021 03:54:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZVe32DO7gVwLU6D4NUsbg577M7BSXlNYjw0azzzIWTU=;
 b=nJYLDU6AksPhS8mRGt2UmqXHYG2VcH4uR3SHM3P6sK1KOmZ63BDCBT8BZHAwmnH8VySB
 fxhGhVlniChxoWrza1SuvRiEvAkZASWj3jhB4UJNo6kxvQ5oK2Uqwe4IbD73i2/dKhf4
 UffkoV+4B/sP345rK1vEC7t45WnmK32nu7j+476h/2wlr7YQJzg+T5/fRr8T2zW6035/
 X7YqFY83k3zxR5PW7zLXXP2KtkSe6WMWqc7t35rYgnsoXl+X+xcJNmvaFOFtB+rZfCvF
 jSJxbduZwtJgHbABLIj3UQ4gumTvTotVVutaMYwiXBwyMKovnq23upftCb/Q0Xyaiq58 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37d9pn4ubu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pFgw134348;
        Thu, 25 Mar 2021 03:53:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 37dtmrmunn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:53:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N434yZyq45rRkYMwwBtM0AoJ0/XtaJ96sPMm6PYbw+xsQQNgNFqCxIb3R5dzTRpNDYrXRu1zxad+yqEE+Gn34RSE+ADtAPFCx56zuPcnZVr7u444S7stSaQzAxriksAw8lEfVYMAY/VXqJB7oJHUGomIKXA3abIb/VP463F3sG5SwqFECt8rEbzwZugXrH4UY3SNoyS4YYleI5kvv3pK22AarGsgCzJQSqWLsoFf/St9D2vSQtebcPev+bbQBrtcOIQHIFe7ddWCLFR0XU4ZLbJGD/aj5eGM5F/544H2xCgD8cSZjIfPNLxh+wJEFfPj959RvWJB0ngRannHvySeVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVe32DO7gVwLU6D4NUsbg577M7BSXlNYjw0azzzIWTU=;
 b=mMuKSm9PTRvC2AGsH958EaiLyd8X2bTP7rwHF6breHr8tOvxmo1Nx1F81pQTM8yhh1WKv3Z8Oy9W2qrEf1bwktFPMnsxSHreSBGcI0aD98QBlpRpRrLH7eoz4LekGFbXxMPysMQH6w24RdU7djI4AWQAJcRufCw5ZIVD1qoxT1UIdDV5Q9EN0+fpZ/hkxA73VO0ud5BOr74PFrU7PCwLjWko7/jiSSy+xieLDCOn39eFyC1NKlTsVp8jfyBsK+4BWRzXuU8U1t27VlK69fP7xbKa6MaMj8joQf65hPHnoFDzcXxkPQGbvV8cOikJlXg4xtjj2EjmH2ZkMQ0mTnuP7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVe32DO7gVwLU6D4NUsbg577M7BSXlNYjw0azzzIWTU=;
 b=Cvg3GNi3AB/TAUZYLRaKOU3N1JsUGnOrLBLW/YTtG+79TQytKBpn41C8v74W6wMfk6bUvffkp84zhCaYWmVUIXS8gyUSZIBdSbwCInwh+bLJCOOeh4kh1jMkIEaOw+CU3VreEAJswIrIe73Ji+Tuk7tt579FCyTH8O1x0XBI6U0=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:53:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:53:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>, mwilck@suse.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        David Disseldorp <ddiss@suse.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        =?UTF-8?q?J=C3=BCrgen=20Gro=C3=9F?= <jgross@suse.com>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] target: pscsi: avoid OOM in pscsi_map_sg()
Date:   Wed, 24 Mar 2021 23:53:48 -0400
Message-Id: <161664413900.21300.16395947495735872708.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210323212431.15306-1-mwilck@suse.com>
References: <20210323212431.15306-1-mwilck@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: CH2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:610:38::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by CH2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:610:38::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Thu, 25 Mar 2021 03:53:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddacb175-e32f-43aa-d2be-08d8ef419e2f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB477499F4509A08DBB0C6B62F8E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3kOfU4DszhzsMgj53BU83WLsD7obYrh2krwFFHY0/e+0WSzptyLN8ZqPCnu2GDPez5q2M1xdDhWR4byLjXFdjduyG12y9Akf18zh5rIVFjeAW4pC0h63yNwLrcb5yINfQzUn7eGwl1GoCUI4yfLuRcEtnDppFwWiYoMB/+g1/HSFJUAe1KU0X+GoQZFtaeYb8iN694OQLi6AlcmFNBwzEsNar+sVdS1Q1YgFDaepWv4bNroa+F8kjlsw0pZfhkjP8NJ5To5/Rz255URMQqX9Q1s+b9LdTX9MN5msT2N5TNnY6KV1l481d1k37RAf79+UaOYjzOXH/35NvydJwNJ/1fI+W+D1ibc+6AysUlzWtYyR1HBetLB0X3O1A6Hu0ooFAZJfC0uI4O522tqldMlQ8NGil/M2s3ry2Fc5L/LcqaBgUuBjG03p1uKzBoZWVD1bt3gRJDGLx5vPeuOqYclFBsUCPConpQFPCgO3eunJJbDieKYRfQ1ib7kWBvHVh1zYjqGNT5VEM3rfppf+aOWpOKTiN1RZ3Da3U9lkwNSHBNpDm+X6y4+Anfs4FFsexb2EADhCAJeYxTJDcWdQUdW0bD3iO8PNG7I1q9ycOpFaqVPhRYoLLAgHUN2nzQHGWFthu/orLH7gQA4qarIr2Xg2vnQwCbdJpWDq2nUZP+fgrkOwSxkl9fSF8vhqwYigD4WBAiHQdktcJRUE7oEJ+yFOy7CAUuF5zIQWix24lvCs6U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(54906003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(966005)(38100700001)(8936002)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(83380400001)(66476007)(478600001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ejZuTnFRb3BmeTByVHdtVTdDbGlpNnZxZWh3cUgvdFNBTGNvRDNtU0hFTHdH?=
 =?utf-8?B?SlZxclIzSUNyekwzM1BZbEtjL0kybExiL0JmcWRIQlBCUjVaM04rOEkzb1Jw?=
 =?utf-8?B?amI0ZW1YTGxROG80TmNwL2xlRHo5aXRXc2VwRmRUTG1wMkszZnc5dUVHdEFY?=
 =?utf-8?B?WjNrRk1PeXl2NlVkQkw4WDkxSmo3Z294ZlY1cVo3RkQreTNTYnZiNlJEbHdI?=
 =?utf-8?B?OFBCbXRmVnhGYWIzZ1FJWnpLWHcyci9jZ2U0WXFkTGZIdzNZWjdFWGVoaFdK?=
 =?utf-8?B?d1JzN0xZVzR2Y1FHamFOYlcydFhKaE80cWhmVDMwUWtDa1dZYnZ4VThhKzg0?=
 =?utf-8?B?MXlTdzRtYm1VcmhsR3ZQVzdNcDZDK3Bkd1FNQXlYNU9GZ3JMK05xaHFlZWg2?=
 =?utf-8?B?WTh2cHVmdllkem85WG1nMEZHM3pjd3J1WlJJSmZaQmZsbVU4bmlFTGJaVDBN?=
 =?utf-8?B?c3BGSHRVMkNBYVArM24yOXRjMGV4WTVBSjRycEN6U3Z5VCttZmxEQmNwUmFP?=
 =?utf-8?B?Q2YwaHlGaElvelJiY2xnTVM0Y2xtMjRXTloreThZcjhLN0J6eTRZOU1zdEd0?=
 =?utf-8?B?MXNLNURxWlFFNjROa25ad2cyVkx6TGI2WFdFY2QvYy90cmZaYitnTzBVODcx?=
 =?utf-8?B?ZzduSWRnSy9FWGgzZ3pINnV6Qjc1KzBQYjlCUEY3bTFqeE9xa3BHaVJKcFd5?=
 =?utf-8?B?amg1VEt6WTdmcTRiU2JuaUw4cWd5REtwdjNyVDdGcktqZ29MSEZBVkRUOHRL?=
 =?utf-8?B?SzVhSGdiVjR4ZzZ3MEJJSTdMZW5FLzJYZmRwRnljZ3h2RGJrYll6UmNST2JE?=
 =?utf-8?B?WGhLTytENktHYWZCVkd4VXRnM0RkOUJBYTF6VE9TcTlDdFYrOG9wUEh2WnIr?=
 =?utf-8?B?a0pNSm1HUERsbkJMT0d6cjFKa0hqNDFIcXZBb3VtckE1TThXakxSQXVLbHlE?=
 =?utf-8?B?NlVySlZ5TU9Uam1YT2FQRUVtSnZHY2lISnd3bmtEUW5xckJRWGFURTg4TVNa?=
 =?utf-8?B?M1kvby9NMStKWTY1OFRaYTZZMGlzU2p6TE1uTmlsbTZxTkxsdStiWklubUJa?=
 =?utf-8?B?blNyV1hvKzdxMXRJbzBYMThQYTNXT20vcStRQ1ZZNzlLeXhONTZ2dm1Xd21j?=
 =?utf-8?B?U3ljdjR1alBaVlJQcUpuVzI3cEphT3I3dGxyOStUZWhxVy9ITTZKVllTUEhZ?=
 =?utf-8?B?SlQvWEt5N2xPanRCMXRla2RqdVI3N3R0UEVBUi9HclZBS1JEaGJZNmMwQ2Iw?=
 =?utf-8?B?TlBzZlhzRTljVnJRTzBqWkhtb1ZLWmVhZXhyYUFvdysyQ1BhOUtBaktDRTVp?=
 =?utf-8?B?TU8vWC9lTE5MTi81a0F4VGdSa3RIS3l5dUtIRXM0OGRjZXBNamZ6QjU4cHNq?=
 =?utf-8?B?cjd0Mk5KcWVCUEJndk5DdDFCTTBJNC9hTXM5ckR1bjlTdHpxTDVRZEZuUndT?=
 =?utf-8?B?NnF5Ky9XV2t4bnl6UTFpMUMwRWdZcGhiUkpkeVFHaDRtWmJpMFUwYklWampI?=
 =?utf-8?B?bFdxNjVpWUtVTHRDVHprSTZENmI1ZFZGVEtMR3RsTzJYRUVNaThPSklCbFUw?=
 =?utf-8?B?WlVBUk9aMk1vcU1HL0JRZnRjVWVlYkV1UWFCNlNvMXYvNHd0dzYwTXVZTUpi?=
 =?utf-8?B?eXZIV3hFanQwa3R5cnFpUkZoR2NGR2dPVmF3SHBXZTNlSHRJb2loZjYxNWw3?=
 =?utf-8?B?YVdLR1hLQnZIQ2NHc01Oc2NXenRJa21EWFU2dHNxWkc5ZHhBdjlRSWZDZE85?=
 =?utf-8?Q?huXDlhS1C9avVLqMs3iMYCLVpYZhBHhWXA1iQ/c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddacb175-e32f-43aa-d2be-08d8ef419e2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:53:58.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvd5kTekLs2Bekgjf5Y15wNxhtrOuYWyAPP1St6anuoUHSmWNevdjiUh/KdJRd0Wc1Ge7BWpmuiILZZw5tUh/3IsETKoMN/fO9BfHNjLkao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=982 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1011 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 Mar 2021 22:24:30 +0100, mwilck@suse.com wrote:

> pscsi_map_sg() uses the variable nr_pages as a hint for bio_kmalloc()
> how many vector elements to allocate. If nr_pages is < BIO_MAX_PAGES,
> it will be reset to 0 after successful allocation of the bio.
> 
> If bio_add_pc_page() fails later for whatever reason, pscsi_map_sg()
> tries to allocate another bio, passing nr_vecs=0. This causes
> bio_add_pc_page() to fail immediately in the next call. pci_map_sg()
> continues to allocate zero-length bios until memory is exhausted and
> the kernel crashes with OOM. This can be easily observed by exporting
> a SATA DVD drive via pscsi. The target crashes as soon as the client
> tries to access the DVD LUN. In the case I analyzed, bio_add_pc_page()
> would fail because the DVD device's max_sectors_kb (128) was
> exceeded.
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/2] target: pscsi: avoid OOM in pscsi_map_sg()
      https://git.kernel.org/mkp/scsi/c/077ce028b8e0
[2/2] target: pscsi: cleanup after failure in pscsi_map_sg()
      https://git.kernel.org/mkp/scsi/c/36fa766faa0c

-- 
Martin K. Petersen	Oracle Linux Engineering
