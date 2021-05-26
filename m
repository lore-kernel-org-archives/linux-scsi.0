Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66929C4708A
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5C761431
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhEZEJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39232 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhEZEJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3xTHO183927;
        Wed, 26 May 2021 04:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Xl/gkk94A07n+OjPgXNz7hs8hwfKlWKB3SdxE+6PEeY=;
 b=HBt3EDI7OnRmIkHqILuvoBLH6CNM5jnXdQ2sxTIYOyY5u6iZrYjzSLm4DSyLF1dlx6Wx
 jOKvnRJRXJ+SktXOeV646o2k3rwqvJvphM4rhBV1PdwvZ7Lg4mykNsc9kjt8xv1yH7CR
 4ERnJtjBPxerSFQwrF8NN5elj1Cioa9fwqxXrkrn74IQsmEMSqCXfCLvdOfxH1I3oVQK
 rMSzgbqZ6ozSGmzD8uVBZDRkRMkHJL9h4KESGGcsSWATSo+mWASPX2LX/RmmTgxa2lYP
 PNFJvQG7+oEXb98EI20fU36H3o28YeCHKlrvyrR568KCRAjcV2R8istcbBkX5jOy4GS0 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8y7hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q46EFp028041;
        Wed, 26 May 2021 04:07:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 38qbqsvdad-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alPw/HBAu6zez4eE364f7XLDQ0BHivukvKNWkcx43gJ2iydOIiMNvLTM8u4LTzGLh25twJQQ31U4W586Tk50J9Ebzzfb5yfGQCvk6XJ4JT3qOdLUE0L0lW8QxOjk6SyfIeciMFkOe4xxpgjvclIDNevKtCrB1coRUe2spxqlU+15JcBhpwW4bAGeG58ZJb+OguWfGFeGA0P2KE1yAS457LLhQrI9B2gVOxFsTHXsbEgIgwDSBRrpAXcWaFUQxvl2pOiF/0HNTPODf8tzmIoo8y012Brdmg+v5m1KGB/svbVitpUt8mgR82Mmhklh8nGAWSTny/pRu2U1u7wnOkjH3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xl/gkk94A07n+OjPgXNz7hs8hwfKlWKB3SdxE+6PEeY=;
 b=J2VhGW1NQWcJURE3Af8I5iPxImxkeCAOXO+r04caCBfEHSvpTL+90AW7CifOi+dXZnAy5iwa82/PSYt92vANCQxie/GoI4h6KiZUg63DTa6qEWuTr5Rtp1VwG71Aw2hDN/HZeA8LBBARQIt+qgBbuNxmJL98UnZdkD+UVw+zBY8Qylvp0wSJuFQNxQTHi+NMSlD0MQz6Czm+oygWqWxs3Ic2bCLvkL9tBaDmiUOSKlINtFgLFmb215SmMh7Qv1BYcfdCYxx121w6ucB8NGO2zQxbOHQXgZBrqJp/pgDhMGo5pMZUOmQMeN3ssRrtAgcI/lRAdh0xjPrAAvsknmhLyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xl/gkk94A07n+OjPgXNz7hs8hwfKlWKB3SdxE+6PEeY=;
 b=i9gOD7OC4VDcRjwBGCkXgysuwWZNpAuJ0ulz4plA63k65Kc/OLq+YOFwmcu6Nll2am9tnymIsribrt2CYgZAr9ge0Nw8Y9Xc0wU8aQfXhjy/9davr0YoLzAgMOdhXBXRCANb1e4un1qLbz8Nn0kUIdTIexPzEmad4h6HWy11Oy4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4549.namprd10.prod.outlook.com (2603:10b6:510:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 04:07:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-samsung-soc@vger.kernel.org,
        Colin King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: make a const array static, makes object smaller
Date:   Wed, 26 May 2021 00:07:19 -0400
Message-Id: <162200196243.11962.421044433268376300.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505190104.70112-1-colin.king@canonical.com>
References: <20210505190104.70112-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e8aa34d-db23-4c0a-a122-08d91ffbcead
X-MS-TrafficTypeDiagnostic: PH0PR10MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB454946D3FD63A0A6805E14A18E249@PH0PR10MB4549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SAaqcxvq73oSozSXdK1LbZKXvPM1LiHg7u4OxZAmyvpy6InaaonlIssHYYLHiopl/IQONvkrpN+g0ljtZ7pTmys8b3VFf3WOB0voKxxWPRtCQ3jQv0VyNGb8WTa49wEYySOJvOU4gkN2OMd6PO11dVsqIpmuaIrdjp/Hzt7pLYW+oP9KmlQTUNk8UNJSywJuuVDRHm+DanPgqzKHV69lZ0muQLPbMPYI4oYne2GTXJBlxxlZIwAqaLg+yHFAJclu3LXmTXrfowuKao6ihhqEHqmElnGnueotgUbX+Mk2DYiB95ZvxJV7/ul4nNXaSQuD3bAktwXASrB/MCx4qTZKObDptNNrkYt+rS5ewqhR4EsOVcQxyFKT7H6HAezKRHdGzIdrVVlxzr0lPcKfcF2am54ENGyXCYZ+6WRNkT4sl2pOdnh3ENI3rsj+2oykqzpzzqlIGXMofP/gQvJzmuPNHMvAxW2pRaBuTPvOKe9tr4ZH1rpkHhy6T8ZFcbDeqtz9v/xZXucNpmeg0o7f0rqT8C0h8KCOjYuTbh3Us5bvQTFdKmM07OkI2Me1kRHv7tTQSfUaqASOgjp+Y1rpFYrqsk2wyOn6bsDCHj65sz0VrdR9VBLn8srxSj7RazcNscay5lOfGbcBFGfgu+IZFEd30Tnq/wzgYMHsyyeEzfA6S/4ZQhWmRjCfDN7MdRkjJqIiMKxvjPmZsKWA4HELyKlqCW2ZnJKcYdzhGENYt6UqvG/5c8LOvxMza7Fcz6Ipf5b4S21ZQmaUQaXX8Lnq4Xeh5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(478600001)(66556008)(38350700002)(2616005)(110136005)(38100700002)(86362001)(103116003)(4744005)(52116002)(66476007)(66946007)(4326008)(956004)(5660300002)(6666004)(26005)(36756003)(966005)(316002)(7696005)(186003)(2906002)(7416002)(6486002)(16526019)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2hGRndGZzFpcGlnbTd1bkRKYk1XVFhSbFRnNXhQSFlNbzBnM1p1dW9oRFdR?=
 =?utf-8?B?YWNpSGJUNURKb0pNaXFyRk52cUIxTGdqdWFCT3pqQ3VYeEFsRzBZQTk0MzZ0?=
 =?utf-8?B?Smk3OVlGSkpHNkNkOERlM3A4dGNzVms3d2pPd0VycUovSURsbEdza2FKMUJz?=
 =?utf-8?B?TzVUbFUrYjZQUDJjbDgxTDR6b0EwSzZCa1VDK3BhQ01kY29nNnRLbjdHTHox?=
 =?utf-8?B?cWkya1dHZXR3VlQ4c0ZwL1QvOXNkQkk0VE9oNWU3ZDZoVW4wVU5yRmU3U1Rm?=
 =?utf-8?B?VFRjQkt0cDBOUkk5Q1o4K3BXVTQ4b0xhZkQ3VTdkS0VadjV6ODRlZGZNUUtq?=
 =?utf-8?B?U1dleTlCV0llUWRsSXBqYUxnQ0tpUGpVdHZIcEJOWEFMV25jYkJCTngwZ0p6?=
 =?utf-8?B?UGVYVHRYRDFycjQzYU83NkFYZXpkanZmRlpWb2MvUUNFd1R0Zkh3THVicmdI?=
 =?utf-8?B?ajhpMUYzaE1YS3RKc2s3TGFYOWprakVDMVhEYzhONDhGZklkRGZ5a1d1Skow?=
 =?utf-8?B?UTRWMThiVnRUWlc4bjgxNTdzeklpL3hzNUVZWkV6U1EvWWMrcnBDWW1HZjdK?=
 =?utf-8?B?UzQxS2JXRlU4VVAwNnVnZjVkcUFJRmNueDBVSTV1eWxReVBtekpWTDB3RHJE?=
 =?utf-8?B?ZERISTY3RDhsbWt6MWZCQk9NTlI1S2pSUXpTenhNOGkycWJZYk15ZjdRazFz?=
 =?utf-8?B?c21XVElDeFhEVTgvbUV1TVp5bjVUS2Zac2Zpcm1yVDBBUXQwdkFHU3JwVmNH?=
 =?utf-8?B?WXRxZHFPYXIyRXJ0SjMwOFA5MDYvK2huSWVvVEFQV0xoK3pHTjA5NUZGN3lV?=
 =?utf-8?B?aU5kWEZSNVNHLzVBUk9iRVRCWDFNN1p1cWNPNk1aUVQwNDJOTnZOR3FMYXJz?=
 =?utf-8?B?MjF6dkFDc1lTL1lyQVpqSURzYkJFVTcwV01nYWg3NkVaSm11dEpEYTJOTStu?=
 =?utf-8?B?YmF4MDR5bUF5dk9rYmdYaVc3b0lnaTZGRGxpalZYMEVUVXpBbWVEb2JYM3Jy?=
 =?utf-8?B?S2pNLzhoWU9xR3dpSkg2cVJ3TkloS0ZPS2MxeHNQK1Q2enVjRDVBbDg1Wnda?=
 =?utf-8?B?WDFYRjlDbUQ1SFF5RVZPbWJlMWxTaDJqZk82RTlTUHJ3R3RWbWI4ZzNvSkdy?=
 =?utf-8?B?NXhCTmtxSVFqbGs5c21zWWFWYU4zM2ZvRjdTaXZpQ3dNNWpXbzhuRmNBbTYy?=
 =?utf-8?B?YWtQNGpyUTFRV1dtZmFFVld4aFQvYVZhb2FvNHViY284akFJMGsya2I0MlVZ?=
 =?utf-8?B?TWZGRmFIaUxKcXNWcjRlNzU0N0dzV3IzSmV3ay90OHFEdGsxRGFEMHpLS0Ri?=
 =?utf-8?B?MkFnZlFLYnVHNnZTdWtlR2NTYjZReXpZQ3BvY2hIcFdSZTA0RjY5eGVTUW9V?=
 =?utf-8?B?RUVyeUc4Ym0wd2VGaDRMQmNzQ081US92MXNlbC9sSGhGQUwwTTBTekVpYk5R?=
 =?utf-8?B?SW5ucmkyMDBDRFIvNlBQRW5wSXo0VHdLTzQ4VVBLYTU2UUw0QWRLNEU4aUd3?=
 =?utf-8?B?UU9OSkloZTRSa0l4YU44akpDOGtQZ0FKcm5tVGE4aU9acVJWT0t4akloSlFr?=
 =?utf-8?B?aGYrM1NUVVBISjB6dHBSK0RDd1hvZWJqQ3B1MDh1RENtYU0rSVVldUNlZ1Jr?=
 =?utf-8?B?SEJscXBINWR4dVJkTnQ1U1ErR2txUVBKSnk2WDV0RFpnMExlekFFNjZCajJM?=
 =?utf-8?B?bkhxTVQ5VzNicEFadGtSaFA4aG1PbnpPQmZyVnAxLzJJUU9EL2NlKzdsM1lE?=
 =?utf-8?Q?eMvIhSW3/eIIQS8KGinGR67mYs4UVLcjXhJbCkV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e8aa34d-db23-4c0a-a122-08d91ffbcead
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:41.6494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vjMlp6Nox/dCYs8pTMBSeA8mHADxkC8xFY9jMPzKQ55rGteyiQFkIRjTmx1o4Z8+vJ4jrryYdCCpyxpf1VEr8rE8l/wn9I2PjOg5/Zp67so=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: H5sq8I429DfATCKlmSJ_VRA6ssocLsgb
X-Proofpoint-ORIG-GUID: H5sq8I429DfATCKlmSJ_VRA6ssocLsgb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 5 May 2021 20:01:04 +0100, Colin King wrote:

> Don't populate the const array granularity_tbl on the stack but instead it
> static. Makes the object code smaller by 190 bytes:
> 
> Before:
>    text    data     bss     dec     hex filename
>   25563    6908       0   32471    7ed7 ./drivers/scsi/ufs/ufs-exynos.o
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-exynos: make a const array static, makes object smaller
      https://git.kernel.org/mkp/scsi/c/5ac3c649f11c

-- 
Martin K. Petersen	Oracle Linux Engineering
