Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17919C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D56FE61494
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhEKD1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:27:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhEKD04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:26:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EtdJ072331;
        Tue, 11 May 2021 03:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IvzcOggMAXK2mwZ/r3XPPEM7NOaf2Tv5G6NYTJDssNI=;
 b=Bnpz/IJFYdv4x4wuw4z0MxYTHtnqDkCfKUCckAD39/G8b3Q27Fpuf2M3c0yWG15eHMZn
 MYwE1oCTJEx3MdUK2RX+zuCgEF7WtPVUs0z95xPIfFeyvkA9jKuKsLDmi14frUVxkkvw
 PGSEYxyi1gSKprkbX2V5eecuxbiEe9QmMdRcedyVPK3CcBd3UBw4dG3q3Xz077r2TOxL
 YfyQlwmEXzXKD2ELxcbe1Gf65eAPX3FXG0ITbiBi8LkNibhbqO/q9kcEMna8n7gNSNPx
 LTGOQdKUUwIo/gKqvIdFby90eN0Zu2frC+8dn4uRdiMuIk1MN9yw9y4h2/0sZ2yu/eh1 LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38e285cgd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3FoGP103196;
        Tue, 11 May 2021 03:25:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3030.oracle.com with ESMTP id 38e5pwfpat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqkrFh0uS1uddq9hpBDaqDOKuWMfmaDuXHYYmAhNHQvVPr8UWioV6LQGt+lym1O0dvyrfEtulaYDCiMm9Wy/Q2bH0A3uFVX9McEdqA5VaJ7b9FgDvACcTQ+R8hvb7zNKtsyc705/jrIHoZMa3IqFKNfnH2d78KrWbTS6fXl56oDybDG1W2ztWkY825j5vVvRLvdRTVoHPI0ouY55S0S6B2gM+DdK8BivpAaLOb+qjTD45G307ywV+Bd73sUk3qUsrOu0ch833CNJntercZWM0JIkY3Nhce9cPh0EEYFuwfmKZg3bw0lE6Yzfw/DmMmqcfJrEHRVHarCVoPgYXd7WWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvzcOggMAXK2mwZ/r3XPPEM7NOaf2Tv5G6NYTJDssNI=;
 b=flDTnf18xMRFeqE4fTXHFaQlOfLdk7sbRWqn9uHsabhltqOTVzUiV8zAUzU/EDQZA/yu37N9w2rrGdzUzzKneFVZOFRwEhlzFC6tGWArJG3g14VTBafMIgc4IoOe/vHb7Xo7oZ5Pj3MYrLz1DGq6s1BiJlNA3z4T67ZwU2bGIzMtA3clJ3/VzoDDa7CDpWKjpCQniupJrtFZyotufbtCR/5j573uD1HH+NzqmxG4FXCS8anbNc5LV0hdXTZcqlavw03byfGTFKBtowxrjqQLKvWSdrUkPfFUoXLywNmYJpw+kT3AQwf7VBdjSUVv6gSWGZDKENgqqzY+i7uz0HCr+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvzcOggMAXK2mwZ/r3XPPEM7NOaf2Tv5G6NYTJDssNI=;
 b=HKT8zUB6mjiflc+EtiXZ1CSJhcPceD1IZO0FJXIQ3n/ozADAdtqDt0P0Bq2VWoDOaoZ0eFstruSjthdrsuHGtOR717hmOxHNAAaGkKVGok6av/+kZy74WlHeiHPv2wFUh/9dcpAhs7rdEKEYrDzmcQr1Ab3KLjqK5z4jSH3KYDI=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Colin King <colin.king@canonical.com>,
        megaraidlinux.pdl@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_mbox: remove redundant initialization of pointer mbox
Date:   Mon, 10 May 2021 23:25:27 -0400
Message-Id: <162070348783.27567.3347735004810932594.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420104919.376734-1-colin.king@canonical.com>
References: <20210420104919.376734-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a24c3ef3-d53d-46a7-9e54-08d9142c755b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440861C6C04FDFD209F5119E8E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ctAliTA29nFc/h45qm6tgDOglUkfQhB0LakZaN4Sxtia1m5VvenIE6ZjtakrKdQWv5VTZnw7LQ1v9wkhwVU9gF5Rs7ykJvUkmY+lu98HEEJXqKZ6Wj0mVkmOMywGwKhWs/1314sCCdpsyKUa2T+240JAzjSQeoMhHlW3L7iBh+fpD8fE+nPjdsk+XdlKZ6+ure0LkzOqzO3/u62GJKXf4hDLwCNQiGL6nlnw2bdh6uGa8iwJzA3e5cFUSfMVxvh5D6wGnDEpHarILQVHkzegWetQnprRtBO6SInBcSVXXPPmR17zbdH2DDCT9UTulEcHHxwHFdVufYqA2BDa/Gz3rwz+gE53n1LnoNgBCRuaFGnPLeTDhFx6JJm5lH2JjROaJO2SVSfqdL8gmxJ03lztVBx6Opk044LVoffpKNPOp/2ftjy7aNKhxMMTcj8NiauOfq+KW5zRe8y+uaaELr7N5obhzUwbGUetd81Mk73B3kWBO5oMts47sco9weXyrBJUTDE251YsnGijzhUn/rf98FGq+TVvxg32er/dB7+wNZhIsutpk/XJtRdT4qZmihP2E4fHrnWX3GHzINZslYW85i0nhdH1neYqP4DffBd+9JEDzC55eu4j+mAeK07NPdmdjv/3F/97lLKC/DiAESPP+Ev77s1CRT7XiHQQzAf8Ao+ikmUB5zX4HhgLzdtXO8+++lqvP63aqDaF4v+mAa+KX5D7Il7oCIIHNeN+rnO474=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(110136005)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(83380400001)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUkrZy93T1ZRbGFDN3hIcDM0eGVKRkxXL3FLYnRMNVBQT1dNQ0hlTzFZTmow?=
 =?utf-8?B?bzVaTklIL1lYeVRtZzBTWlpqYUFWU0NFZGpUWG9QTTlJbHV4YnYrREFGUlJW?=
 =?utf-8?B?V2hzdXB3Um8vMzYyc2xkeHlqRFloeE9KM0lrV2Z2Q0loaUhOd3pmRzkrVU5v?=
 =?utf-8?B?RVdiSGRCWms3d3I1NlhYa0g3cU9wRzhKYjE0Z0dUaGZHbzAzNlJNVEpXVmFs?=
 =?utf-8?B?M1ZhT0wwRkd5MmwwWk9SRVJXMFZqd0hFVDJYbjFJcXlUSE1mcXZIelZhQzVx?=
 =?utf-8?B?Yzczc2RoTTMyWWxFRk9pZ01BL2RVUGdRalpxUXhMelNHMFNuYmZ6SzE4RXFK?=
 =?utf-8?B?VTkvK0VHeFdFY2Y3RHNJUzg1M2dxb0djaEJsRVBxS1JwRnFJN2VkRG5SRXJN?=
 =?utf-8?B?NW1ZaG9CYlN1SnVRVHhrSjB6ZnZ4dkdMcEZtRitoZGlYWVVzWXdPa1Z1SXYw?=
 =?utf-8?B?UjQ5YmNFN0E1dTBaeWgrVE0xN2h1SzBVTDBybVdkMi9BZVNKbU1sYVFkcWVK?=
 =?utf-8?B?eWRUVnpBaFY1WjRkL1N4WE11dUluZzF5NEV6RllabXRMNld6azlYSG5zY3ln?=
 =?utf-8?B?STVUeTRGUEJyN2k0NEp5SVlMMUxGVWhFS0loNm1zSlQwLzhvcUl6WUtSL3NI?=
 =?utf-8?B?TlVnZ0tQQVgzWWNQZ29QK3RyMkdPekh5M1ZmRTZiYVVjb3hkMVdxTUVaRHln?=
 =?utf-8?B?QzRlWTdYa3kyMnNFNGppZ1NhTjJoTCtwZ3oyaXJtWkQzWGQyU05LbzNHZklS?=
 =?utf-8?B?dVBlSUE4bmxMbG93UFZubnZpS1gzUGtpMEpTdEVUelJMZGVFdHBGMm1EdjYy?=
 =?utf-8?B?SkxNQlNNRjVTZlR4cGtKY1pobkt4QktXV3hSckJNT2tqQkhWQk9WUGk5SDE0?=
 =?utf-8?B?MGlHTUkzdzEvY2lkbnJxLy9mcEdXZWJMVERvbWhoYnJzNVRyQU9seWkzUVRD?=
 =?utf-8?B?Nk9LK1BjQzdRNjRJMWZCYjl2VnRmanpmTlNLcW9HbjZvM05mak5melN2cWE2?=
 =?utf-8?B?Y0Q5Z1dTYXhVZlB2ellIQXMxRG5ONkIyS0FZd3RzZml6UktaeTQ5SXU2OHEx?=
 =?utf-8?B?L1hJbUt2M2pkbGxwWlNVbEJyNXJzeFlMVU4ySnFta0hnSjNFdlV3UEZPaUU4?=
 =?utf-8?B?TlJCdWpiZEhjeTRoaWp0U2VFVUVOalpxNEtCdkVsQnhLQWpxVEhEeS9ubUNv?=
 =?utf-8?B?eW1tUE1FNGRUZHRuUm44R1hITCtiY1FxdzhRVlhEcFJuY0lyaDl2TThIVGRI?=
 =?utf-8?B?Z2pCZXpqU0NJQ1BrWXh5S3ZnT2ZOU1JsbGIxMmp4M1JwOU9sNE5rTkE0Rkly?=
 =?utf-8?B?V2kwZ0x0cU5UWHhwWWVtOXlacE9VbXVseUpXaXlwQ2JWcllXSFdsSnFKM3Ir?=
 =?utf-8?B?bVQ4ek5zZW5rZG5yd1RJUjIybDh1ZVhXRDRuQ2NRVTdUd25ZM2tuR2Rwdi9t?=
 =?utf-8?B?V0NjTFo5MysrMWhhQXkzaFRhUEo0UElwbTdUanRVVVNPd3hnd1ZVd3h2dFRs?=
 =?utf-8?B?QkJkWHNudldXT0llekdEZURFQXQvbE9lNjhvWE04M0FBQWdQZHAxc3RGSVhC?=
 =?utf-8?B?NmJpa0gzV0ZyOG0yOE5YS0p3d1hpaHc0Vm9IcktEOHNTVFpwdHR4WHl6eGE2?=
 =?utf-8?B?ejl3eldhMmJRRWJ3UXlzMTFoaVNWOXdaaDBOU2tpR3NOdHBsQVF4TW1RQ0J3?=
 =?utf-8?B?dnQ0UXBjb1NMWllnLytpK1lHckNhVEI3b0czUTI0VVQxakFiY0Q3RitlSVAy?=
 =?utf-8?Q?QqdtyGkW7xm2kr6zAER59k/rIgULFo018bA922K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24c3ef3-d53d-46a7-9e54-08d9142c755b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:43.1333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /cXHxkgKIgL+PASn+F+zOYmffGJLOVTB2bRJ3Hw4YxVAVpZc3d78hW5PRt1fNsgObEoo0QDV7Tyhar0ez815DgBJ2nWT8L+LAZSrOyfQxOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: GeKDU2_Up_ZOPC5hf_dHyBZHE_9YWYl1
X-Proofpoint-ORIG-GUID: GeKDU2_Up_ZOPC5hf_dHyBZHE_9YWYl1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 20 Apr 2021 11:49:19 +0100, Colin King wrote:

> The pointer mbox is being initialized with a value that is
> never read and it is being updated later with a new value.  The
> initialization is redundant and can be removed.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: megaraid_mbox: remove redundant initialization of pointer mbox
      https://git.kernel.org/mkp/scsi/c/807b31d8e0fc

-- 
Martin K. Petersen	Oracle Linux Engineering
