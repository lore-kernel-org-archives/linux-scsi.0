Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22332C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F359E613BE
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243679AbhDFExv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:53:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51328 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243665AbhDFExs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:53:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364o0Qt049745;
        Tue, 6 Apr 2021 04:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=G1v+xEdw1b3ZM16+EmYtVQa9uxZGSqyHxTNzUinGbXQ=;
 b=PlsSTyiwUWywWuAMoryOVO+SDDZzbGLium9zR67i4YFNIBKrunRF75Pab2lza6/o7Nfu
 YbFMT3dTR8LakxoK82kRmLZMDHPcJ/4pvSqg9aMjGGzRaXsd9AHWltCY3o1wR1bpgNWJ
 6u5Bm+pjy8IcRYHfayxc9lpGQ+NfSnFGQYb3B9ZJWLDBjii7K8gKNqHIKjv0ha5ieRW0
 Pu7jBQrEw5PNlDepOz3IIcfJDsW3yKEtqlmE+nvfIjUCoXdlErZR8FVpXccmc6uRAQ+p
 4aXO6ybBRvho9Ar8ehmwiY91a/wwdsf8bS1cHmozMylPuh6rfJh2apwH6Ts25zuEKdee hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37q38mm1am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364ox0V070460;
        Tue, 6 Apr 2021 04:53:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 37q2ptrhk3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEi57dGt9+U+fn9tmtmo5fyEokSQjz3LDfh4e9pjQvhFUFQRTBDhc7pYE8fioZWiKoTqsg4O6gr29xnaJPEilExvaMnq8gDVHqu0KLCK3mDuP8H7+GfL8hBQHn/kldtJ2P/0gqLm3RLw/iSgkWdqfmQ+o78cJdqSyhEeg4RqaW/auEHI9foX61RWYh/fIaaxuD1ENRtl2pqlNOG5yoTrrKXemevaAbnu8RIH3mYrQlrfxfgyDZQBoSKUgb8bF6NtTWLulyWO1rJrfTpSNLJR0GpD0q7sIbrq+AA68u8FbD8ZlxDNozn0LBUmyJiUyZkabQIb3mjh8N0iNucrmhZqRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1v+xEdw1b3ZM16+EmYtVQa9uxZGSqyHxTNzUinGbXQ=;
 b=YaqeKGwVVR9E1efiY7dRYWP89zsrtpBlN5woOYtnSu69OexJk9d00B/OWF7CaIVbZOhvECqt3COKeeVRDB9EciujLRae1TAO54zgGEGlSvS+x7Rvvq6m4FRD8MhalFpBi5CsHO2hddvWHbrxncUHiOELr2LBPxrPpFU0KuBo6biuVJI+FVQYzuBrGVp2aUhL+JXKWfBkGTOpyDULl6Y2ShQHVphfpWRd0rhtu7J+Kv7aRaJiOrPZvUnzEYWUiieDZg8xSJ2kNGmG1psbVGHmidZaeT5ZWRolBPD9OcygYKyh8GnycA5s3lqFyqKi3yYtG15ToHrRNSU4DTOoVOpDfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1v+xEdw1b3ZM16+EmYtVQa9uxZGSqyHxTNzUinGbXQ=;
 b=oT/2j/obEO9H6niQUnkyc+dcwM1FKwaPM1FPxE8NM6uHjhueik+3gaanxPuUCB1ZgqsABg35p4HQE/Qk1Iig1nuR1OgfsNvlFv5x5qmY+mSwjzrL0kiN+G+T8L9K8YBAyH0j9TAJfNfsKIICwwvisUcWzLaNPbyZHDVnZSvQqLY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:53:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:53:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 1/2] aic94xx: avoid -Wempty-body warning
Date:   Tue,  6 Apr 2021 00:53:18 -0400
Message-Id: <161768454090.32082.6927914416351855012.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322102549.278661-1-arnd@kernel.org>
References: <20210322102549.278661-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0193.namprd04.prod.outlook.com
 (2603:10b6:806:126::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0193.namprd04.prod.outlook.com (2603:10b6:806:126::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 04:53:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a85c5a02-dd7c-4f79-b86f-08d8f8b7eaf2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44075157FC7615F56B2DEE308E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zokkrE7oW4rtGHbn5Rnd74EFuFdUAXjAVlZVnx5PjXpvWaMfn92PAd65mNHdANk7Zrn5ZLWS3TAqWm5ceYGyoXSZT7pzlIxuXMvS2EglfULf9HRYFpL5UV08iwxKv9BpKQw9PGIxyIMuFpHlqF6bF2mpkkXAwMfdSx46DFatYbCa0j+QjTw2xlBSWDygdPW/JpTHhvBAB5zVF0kF4jpUFWh9DChX5ckXitZC4zq517ItG2UlFFh/fskHgYeiEQ7/zkgiYEmmu2ANM2TtrGRbITFzp382vyTguLPfqu7RnIgkoH2m20LcF+9mxb5H0ocMntkLvtg4Y8NzcCDaz2PQ2/XZpc+lNdieKNxXsX1aCPH3bS8P6BRQ3+1JyDWWpPeLH3SEP/HQfM61e5rTHkaEIawcu+pPLJwmYrirZXp3ijbfHMf/QdVpr1drvKp9pdMAijEi8sp7PxLxMHm6gyjFKHMtDX1grV4fnvKVlOTDXVnMN08RyIdDdhZEsDj36sfThp9NjqA9PMMlqwuKSMDgIDx/wfwpWateNakaNZU+YUmwSid8jnLmrRMqtubMyg2LwqWdtg3m1nrHKnHGrd4ziZesodH215ImECLYWwh6AvHp6IlNU+8eQYmzKz0C0IzNkuPwaVLjFtzWfmqZM4ShCMedSDMspInvyVb9ROHDFg3pSVvh7kplMSPY6E6DNPGgx+hEH/Uw9RPRIrxtCt+T7oJQa2y5q3BnvfB3WUMZ4wha2Z84pWJZDBvfA9it5w2O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(36756003)(110136005)(316002)(2906002)(38100700001)(103116003)(54906003)(5660300002)(83380400001)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SDBIVW5Cc3Vrd3V0Vks0RE4rMDBaYjlieTl4a0NMRHFjeUZjdGZ5b1IzbmRX?=
 =?utf-8?B?NTc0YWo3RWxmWldkYmp3dzdNcTQ2TjVqWEg3SnpqUE96eEZPOGVlMUlOUncr?=
 =?utf-8?B?WE82bUIxV2NjNysyZUQvTFV1b25aR3ZuQlZDd0RSWjAwUllIaS9nTjdkd2NX?=
 =?utf-8?B?VDZHbWZadHBqRHBVd05XcklCUDFIZEhSZ2pCRFk4N1V1NVFaWk5PbC81dis1?=
 =?utf-8?B?OXZHVWJZeFNZcVl2RGVPTTJNcVlIMFFIb1BRVGVDNkFlY3BoeEh3THdYdmZ4?=
 =?utf-8?B?aDhLNldieUVzdTRZMTF0SEVtUWxCN2VWSFdoYkg2OFdmQkt2c1E0UjlCdzJH?=
 =?utf-8?B?ZVlJSHdXUURiL0RhRTNwQU9iNXFScHBpVzRrVHZaZk5tSFNKQWp3d01QbktR?=
 =?utf-8?B?Y1ljS1hZNHZRUTJta0NUWWJMRWxvM21RSitjdlpsWFVjV2lOWnF6TW5TMGFi?=
 =?utf-8?B?amxDT1lkUVk1ayt6bTlVVXJoK2ZyOE1HbTFqQWVtYTJPTFdhWmtncVpLa05U?=
 =?utf-8?B?NDRzaVFCcHYxcExQMVFBRFh5ak1Qa3lrak1WUXduWmpXZzNtc1ZyY0xXTUlZ?=
 =?utf-8?B?TE5UbzJMRGlhSVI5RUUvVVh2aEcrYy9Bekl3cjhFbnBaOGR0dEt6WXJnYzBm?=
 =?utf-8?B?ZFVOYk52UDJKdXcvQ0d4VmJSR3BFVUF2RURUOTJuN3lTTkJQRDFCeHBEcDZt?=
 =?utf-8?B?eUt6SHhDQkJyZEFVZGxpMDFZeEx5YWhlZUR6c3hZZUovY2pMc0x0cXo4aDFx?=
 =?utf-8?B?MlB5ZXcwRHZDZTRmYmYxaCtYZGhnY3liZzJtQ2lTNCtsWk1aYW5YeWNNZ3hq?=
 =?utf-8?B?QTlxQ2hkT0ltQ1dYc3BqR0hhVDcySDZ6S0FLNlpwRjBuS3pERVNFUHdCU0dG?=
 =?utf-8?B?OTB5NU12Mk1sNGZCdytkZXBENmJiYjFITHFTMWJ6TjQzSmJqRE0zTnlkMGlv?=
 =?utf-8?B?S2piRWxaRDZuY2tJM3p6ZTJKdEt2NTVlN2JNR0NRaFc2dTRYcStxYUJBNFk4?=
 =?utf-8?B?TGJYRWxDNWlVZlJjdndZNG9HQm8rM1A3bzhkWk1GT1B5SDVXNTRNSzJCcTYy?=
 =?utf-8?B?R2dyTnI0aUIvamFyd0x6eVpZQzhJRHN0dCtkVXBiR2NTWCt2UWgvUis0d0RI?=
 =?utf-8?B?c3lRU3dHNm1qSXpOek9WRVhpeVB2RUxjZkxjM1RGUW9QSzlCeThMOTVpcWJ6?=
 =?utf-8?B?K2RBaFFjQThxUVVKaUorVUVidU85Y3lkaWZvU0V6SzFZcTZlSkFGQytzY2NO?=
 =?utf-8?B?WmUrYmIzVmROcGhvc0g4OE9BT2JyaXJheXk0aDVRTHRFNlJnREZ6UGxmM0Q2?=
 =?utf-8?B?KzluZFFYazdod09RUEUvSWJTajlCdVhzZ1dLdGR1WEN3cHh5b3BhYnBJR2Mv?=
 =?utf-8?B?ZVFPeXhqZU1lRWUvQUxCZkQ3ZHF5cjZmeE9BdXZTL1FDWUNZTTZoRE4xMGpi?=
 =?utf-8?B?WmxpOWl4WGk3TEIvcXRnQllvd2xUcFAvaUJZL3pENjNldUJ3VmlIaWx2MmhJ?=
 =?utf-8?B?MlRlMVdxbjlHcHhTdzN2QjZPUWhNbWtzK0dBcHo1bzhRc1RxRFdYSDMwYnRZ?=
 =?utf-8?B?VjlJdEZ2SHJXNjhmUEF0QTAxLzNHMWJBcXV4c204a3E3MklGVGNwSDdWSjA1?=
 =?utf-8?B?anpaWDZFNi84RGg5R1Q3aHlhV2wvRjJ1MmMvOStBNU94ZU4vdDc3NktGSU1N?=
 =?utf-8?B?ektpQmtWN2haMTAwZVVWcUpobmhYcWlpM1lUVm1HbWFmMitnTXVCb0VyWXJU?=
 =?utf-8?Q?be1KGVCcFpgvx9nJvPi8SynUPjW7OfTegTy/9e+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85c5a02-dd7c-4f79-b86f-08d8f8b7eaf2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:53:27.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXXqFOIu1GpVGVoUPG7anN+9f6fAieL5OdiLnPNyoxrALz5mcco47rPZM7Due5+H1jobgYEPsZP9+ju6w25bJE1m/w5MSDhc5J7xqXVJBes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: OQ6tORW2YR6Lupa1eV-oQKZYZVYptqk9
X-Proofpoint-ORIG-GUID: OQ6tORW2YR6Lupa1eV-oQKZYZVYptqk9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 11:25:43 +0100, Arnd Bergmann wrote:

> Building with 'make W=1' shows a harmless -Wempty-body warning:
> 
> drivers/scsi/aic94xx/aic94xx_init.c: In function 'asd_free_queues':
> drivers/scsi/aic94xx/aic94xx_init.c:858:62: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>   858 |                 ASD_DPRINTK("Uh-oh! Pending is not empty!\n");
> 
> Change the empty ASD_DPRINTK() macro to no_printk(), which avoids this
> warning and adds format string checking.

Applied to 5.13/scsi-queue, thanks!

[1/2] aic94xx: avoid -Wempty-body warning
      https://git.kernel.org/mkp/scsi/c/6c26379def09
[2/2] scsi: message: fusion: avoid -Wempty-body warnings
      https://git.kernel.org/mkp/scsi/c/472c1cfb10f1

-- 
Martin K. Petersen	Oracle Linux Engineering
