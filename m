Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C251AC433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9673665089
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhCPDPq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbhCPDPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G38xLl030086;
        Tue, 16 Mar 2021 03:15:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fnX2CakkKC5mHaMUri7CGAOxYHTfFNzilDSukxLfynw=;
 b=TqrDNHJiQFLSbDeesAroSiuK+IiDAxDfaE6jbZPbT0xDaamg74yRZPKRyC/bDgSuIhQt
 AnG3LNpFAUR5dx90t+kn1bHkvsO4676C1K/APo4uS6xpONL2EQMRSBMakYAdbqXAj2hP
 UjD8DuHCv5UzUmwbcs/RPzz2WWqB/nQOFpifLByYqIkIgeQPrNLs+uT5O/uLXGaHHEr0
 mXTo9pufVp2WvZiYGCIbBwPWW1e5YozELrL7mHwflPHZ63ZV+SPvgSj1Hzbtb7382GB3
 bBKekZhi9O1msW+jFxeyHLMxTAb3BlnoYKdMJWKRCWKLdqARYDxkGbYdKf00HMKMCtRW XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 378nbm64kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3BCBc139199;
        Tue, 16 Mar 2021 03:15:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 37a4esbqg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrnTjL7hPr5uq0IvBllJFHFdufdlVim1h7A1xnstXVWkLbWCbj0pGt9aoVAG9TfZeivtLD3sZnWzh8J3fr72CI4EmBJZQyGWKZlYCcvyygHIcf0+fO8uXkesiYJ2hX8QIcQL3zdsOwEp0rbEX3Key3nUf+oebOxGnSWDiYT1pSGHLw0qNQSeZVFYaYJUk+upy3oQgOEldPX5f8ufZ66QDcMDNJ7wbVknMKbfhcU9Zyp3W1YZGs9RKfiAALmjAknJF+w7iTLALL8eOL1R4j2I2q6sx9r2eROpSXut32WHADuE4baypFL5Hej5ovHUq9SZ9OyaT37FlB64k0A6ilhbgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnX2CakkKC5mHaMUri7CGAOxYHTfFNzilDSukxLfynw=;
 b=c5ApkcTMUoQ1E9swPymTXv9rUM4SwJ0yBtT3Xcr3XaTS8eaJLmmuzBzTS9dcxsUqicHrPvqpkrsC5CM0/zEbR4VI+FaE+s7XeCVTwYjO22uPa2nogpDGHM9jDbY6TW89C1IUiSnGspmHJlYVMK/JJPr7RhKAiDqWkat8vi5bbdgyCkGYW2UiJhbXv2aJVnlcgxCb07nnFKJdVKkD0TbFebbVsbz/ENUw29W86yGnn/simJzTfhKHGoJGpqwz86ucUVpmdo8ff6wdkH2FMZbRdESaV3jFDFZxBTfcyZ6eDBjnmLNelqeNownjfnR6U2oonpHaQzTCc6h9TZ+2sAOODg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnX2CakkKC5mHaMUri7CGAOxYHTfFNzilDSukxLfynw=;
 b=wqqddmSrw4VKKKZT3PyJHG0Gt4KWzqC+des/aRavNsZPBsHy3OpVDYxfyDuLVqrKq3pmN13Q1GqXBQ6S4bndNhpnp9/lRHyz/o8wElwgfz/xUvhbTCRRUi//hh2rhnQaZtThWd+hPlJ15qfF2Qv30dttm0+DxbNuzgzAtNSHetg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Replace IDR and radix_tree with XArray
Date:   Mon, 15 Mar 2021 23:14:52 -0400
Message-Id: <161586054341.25014.3485241054829049703.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210224185335.13844-1-bostroesser@gmail.com>
References: <20210224185335.13844-1-bostroesser@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b6abecf-726c-41e2-3c2d-08d8e829b231
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4709B5BEE326B7453E59B8498E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: noJ0TGCdXMUEWHMLsGnCyayayYyXdI11tZu5W86cOECn7+ucRrjv+92vSVc5HQ7JwZFlubQ1ernIinOMUijD1Zt9sLDnjdFnCoSz0U2gWnLy3nMOQXj1omLRkhP1v6yy4O3yIHN5zzLL8iC57Bvfybn2aYEYLFcoMti9mAlSiWaAEKxRdCQp1Q4NqLH+DumE72wlrElQZSgPbUtW9g6DZr1Bw1r91uVn0TLTIh37vNOaGnrq9J3VCm/vV388s3iaAhySI8dnL/usuYstV4cizGWmaBet/CxoJHvnRg+3PGXPB7UVpj1UKbdhlTmy/eq7S6KbTrdGppzSuobKsYLPe7WdFKtR1L4WuIKP17sCciHlY67WsgOfy+leobvouT+Jfz8Hw8AP5xsE3ry4IOT3TRpDh9oaHoilr7YmPtgvhs5ILH1HIrKHuwq2mRKkwqn9OA9NQLgqt2ncypp1CA5BYuAC+Ixni2UdUAO9yHN9Y7e+I4Hz1EOMcAkd1nnZFR8QT3KYzPXoUu5mrL8p5THbLuQu+sgykC9lWgNXctTOpvw6D0RBYVMrXGKc75J+KecVGvbTnfDQb+HNlTPc+jLVFjw+Ud2mX3WyNj5vlowcJ+u47CGbTSWIZnhxXYluy8r1t3qhBboPhV718Wm6zi103w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(4744005)(107886003)(316002)(110136005)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a2E2Nlh2cVVyaVpEcU1HUGlNK25za2hYOEpmWEhzRGNVSzFka045dzJmc00z?=
 =?utf-8?B?dmU5eWtCTEd6dmpVUVZtVE1xMGF5RzdWeXdmVmU0Y2ZRNGIwMm44YkdqMW85?=
 =?utf-8?B?ZjVmMHBMODdKM056TytZZzFzUEUySW9Ed282a1BvYnZ3RnVsa3Jwd1dNUlBp?=
 =?utf-8?B?S05nVlRRd3FiM0RPU1VlQUpWaTE2SkNhNzFnVVFTRFJvV016bWR5ajlyMjhO?=
 =?utf-8?B?WDBnb2dQcWlhWEFVNVdGbzJHUXpQZ3hWWkhwTk1SZjZ3NXpiL20vbUtXd1Er?=
 =?utf-8?B?ZlpnallGanBFaERaV2poVkFUd1lNSmQvU3VXTVJidTlKS2YxYTVOL0d0Mzc2?=
 =?utf-8?B?YVhkTkdjZXhPOXh2SUhQT2RYUWpQZVFhVFgrWjhuMVA2RURVZXhyNlVQb0xZ?=
 =?utf-8?B?aUVnN3Y0MXJVWXo2SmlKdTFMTGlKMi9KMHl5YkRweUYrUXJFeW9zWVdMOXhp?=
 =?utf-8?B?elFwbHU1bVg5VkVQNHN1ZzcyY3BiSTJqNjBSTVMrU0NPTloyZWw1R05UY1pk?=
 =?utf-8?B?UHozMXJNZ0ZnTkUvOUNNdUQyemd1VXFOUzJHeitmN0EvempOY3UvOXlWeXhF?=
 =?utf-8?B?WDNzMEpnTXVyUGtrQzQ3eElxNWhNUi93aG50d05wQzB2N013WHh0V1dJaXJH?=
 =?utf-8?B?dWQxYVZnbXpZekp2ZlhxQ1cxUWJPR3FXVnM2UEtKcDlxQzcwMWVDZUllMTVO?=
 =?utf-8?B?Sm9qeHhkZHR3blpveXZaalRqeWdVd0hBYXNTMGRQTmxZc2hKKzZJVllQanVW?=
 =?utf-8?B?TnJmaUlrRWxDUjhORXd3dzgyWDlhbkZXNVpQWFdFeWxpNElQenlOMzM5dEtu?=
 =?utf-8?B?MWV4MTErSDYvblovakd3YlMvT1h0a0lkdVZQK3RUZVRVYTE5LzE2MkxMcDhZ?=
 =?utf-8?B?N2VMM1k4cW5LdlhWYVRPcXJyVE4rUkR3amJKTzYwSGd6OEE3cy9oNGVSbTln?=
 =?utf-8?B?Tzh5VERhSC9ydU5nTzBQU1ZtMkxKUy9XdTdKdTF4SFpxdVdteGdwbkc3KzhO?=
 =?utf-8?B?d283dzF2bGRwbFR2Nm9Wd25tMWpCY2FPMlBIM2NqeHFSWkJhdTl6dm5PMjl2?=
 =?utf-8?B?VE50VWFDc3JjeHNJVGx6OWlibzFOZ3ZSclJVVlZkT084VndiNlRrU1Y4K0xw?=
 =?utf-8?B?VS83M1dNeHg2MU03Z2JQZnFvYkdvSDFXMHJiMlMxQUZEZzFRM1NRZnJhODEx?=
 =?utf-8?B?OEVhZ2dJTncrUlhXTGJDem54RTg0VTNMV1Y5T1FHaHdTTHdwRWJYcFVneFNt?=
 =?utf-8?B?NkdDZE9mZmdtcHM5Y1JqN3JOQkVXd00wSEQvbFJqN0pxNUxYdGphTmFXQW1C?=
 =?utf-8?B?VnlnTWNnbmNTcFhtd21CZmpLdGFmNEtEY0Fwckw5R09Ra0R2Y3IwNytxT21k?=
 =?utf-8?B?S3dSRFdaeEcrbXE2Qm42QmRsZGxXQVBkK3J3QVRmS3pPbHZ4bm52U3FCdzkv?=
 =?utf-8?B?ejdTWldRRmNmelloWG4yUmdDeXdSSkQ0N3p3WXA3Mm1PS0Uwdnc2eVF2UXp3?=
 =?utf-8?B?QnVPbDFJWVBHbHc5czIrQjZTYk8vOFQxSFVydmRiRnhseTZpbEg3anlNTXQr?=
 =?utf-8?B?dWt6N0swZkI1VzViVSt2dXNnNUJ3UGVhVEpBRTVwWllvaDNiSDBpNzZmWGQw?=
 =?utf-8?B?ekVsaUNNSG9lb2hjWkplMXc0Y1ZLRVpFU0FtZ3RhUlcvbWRjYlhjTEo2SUE2?=
 =?utf-8?B?c1ZTeHZ0VzBRUkJrM08vZWVtbmsrYUlnVG9MZUV6V08vNkhuaWszVmhlNEgz?=
 =?utf-8?Q?rKsrTnUUy8IlgG4M4xFpAYO8mfGIfxDhW6tfwXi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6abecf-726c-41e2-3c2d-08d8e829b231
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:05.6049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2/Ss6SC7iZwp2EWSpAQ6JmwlwIfVBDcn9c0jO1SMQgAA7TEyFw+aNF6UFMSrh23V2ma9RCjGLSWsZBMqmNj2RRJhWtrJ+Fxah7PmVH8sLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Feb 2021 19:53:33 +0100, Bodo Stroesser wrote:

> This small series is based on Martin's for-next.
> 
> Future patches will need something like the - meanwhile removed -
> radix_tree_for_each_contig macro.
> Since general direction is to use xarray as replacement for
> radix_tree and IDR, instead of re-introducing or open coding the
> removed macro, with this series we switch over to xarray API.
> Based on xarray a future patch easily can implement an analog
> to radix_tree_for_each_contig.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/2] scsi: target: tcmu: Replace IDR by XArray
      https://git.kernel.org/mkp/scsi/c/d3cbb743c362
[2/2] scsi: target: tcmu: Replace radix_tree with XArray
      https://git.kernel.org/mkp/scsi/c/f7c89771d07d

-- 
Martin K. Petersen	Oracle Linux Engineering
