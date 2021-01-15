Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520C9C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C09D23A3C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbhAOEJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbhAOEJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F45VcH056123;
        Fri, 15 Jan 2021 04:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MzU30lWqLw247EtPlMq/ONB+ebHk1kmvxTqtbPqJE8Y=;
 b=uuSmNoIBMXI9L8FpZ47mZELxjHGT54uHhYWQjCDj98QN8SJgO6Cn043GAkuZQatzeQKP
 Hfl6eZSsSeDt6WK5CGD4Z9ueUkdwcc3boX7Au2DnvVzgpOUx5W0uU8+Y+DFwngGwEHau
 Pkh7nSQUhITStFEoPYgoGU6nSNfKFIR6As3MmgSHs4gJ+iUejPvigz9+qXmU/vHlOnyK
 2UeP54yHuK+OSsN9U2ou4bG1DC7a+ETIIn7fsdtJwo4odgKYkcjXu2EsCmMs5hDl5tji
 8NIlueaM9uI2ZABr8ojd0hzufaBuZfC5uLRK/k2eq3Ojt02zzNZbIPzxwYAUmltEW1K3 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 360kd037wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46eX5094901;
        Fri, 15 Jan 2021 04:08:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 360kfagp6r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCXZLfJIPvWfvvKB3E8lYvo+hQHMvMTpkGqzjZsXSQVpK6l3uqTgJrtAIpIKli9BMoUvkfCqWYtF3VtT/jI+Asj0ZaG1SB5PQyh1pjoC+jxndIF6hoBcY8bozv/ZDzIjtR6Ui1Y8E3B+tOvEtWxVH5Gg/9iJoEePJaRevZqTpnAcBBw//3oT7vFELh4Z/4wrs89Z0BduVW3qr/DH7MPt8lEeBqg3rLu7FCIt8cEp8VFTXM62iyP7HFF1Z+G/DcfHAlha6cSsVoHJg/NDyzirXPTdXylUeKFLlfEg3GOj1QRFiJsu30MljDHve3hPLWQza8qWPvbZFeZ1mgt9rMQ7Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzU30lWqLw247EtPlMq/ONB+ebHk1kmvxTqtbPqJE8Y=;
 b=GQaLP73iFvd3dUn/SotSvY4RUJbvcTkfGu/wkvIc5dDm3u38NEgqfQ0EBPV27T3qSK5QqQ1b3JhFhViXYjCQexHkyzyG1zL1nYuLOdikV2+DG7WOdUWC6g+mx1kdWGwa8NHJNnPTuSKKXZYO2s13Rex+SjAfj6ELLRjAtQI0/XZS3R89PJMAkci1SQXPT43UQPwR3+WTuvV5XBLfYC+58XepLiXHzDaG8qeRSXVrPVk2OpLs/uhHQI+J7F6C6XgC3yblYiuEmx25QlTyI4nYBJb/gTQDdWNJAEkZM/LY9Jgi8sXieC8uZm84kanxo6RatZWrRG9EPKxMRqmQUnBq+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzU30lWqLw247EtPlMq/ONB+ebHk1kmvxTqtbPqJE8Y=;
 b=jU0lAgwYVuqXu5Epx09ATrKEI4DmO9v7ta1JDaTp8g8L1MprPeAEAG59Sj9berjZtsbTNYug79kMaQLQ6i9RAElK1+zCjMLL9gjSxVQHtsYpJ+5tt4oBM1cGpSEVsvBIB6g/4f7xPEBm8wAQiU+/WMfgebnaBUJtQ3BuYmisdc4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
Date:   Thu, 14 Jan 2021 23:08:22 -0500
Message-Id: <161068333184.18181.4234969905192129364.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25caeaca-6a67-45d9-2e1b-08d8b90b3de9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568851AB5E66D8623EF68F38EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1VV4aeRfBtqignO5TlbX6/BTTeWqHcW/+VH8corS2lrFXkTyFlsYAT72+9Yyj/aPyvcAkVIdEYdZC9QrzygLOqn8+YmyaBOPqBKxM+M4oYbMcOAgIrDRSsx7dohP7Qw0zYmZZBKg2sFPA4gJiRDxfsof1cv0cL8POuvG0UmkbPnqooxbzF016UBK0jTUsaMnu+RWpsTux3xpHmxMQPUaleZvuOEomFhYdAJW0tGsYVRN0kQIfmE1T494//gZG2yhv3WeZjkmX5ytPR38qTw6kHV56gGw7xVMPj8sjqnPwa3BZP1/HVArXIpGMjH/Ie6x0rry16st+tVDCpuCesaR4SX4cNigj3yCry5Xmpf673HAk20pI03YsLhZVGYXnChSQRNiRicrZVRanObI77DX57lDIijNkTjrXzMZAQNgoCzPdO/rYrnZ+78OKlub8p+j3r2Jk6Bl+K7Wg6K8Ina6CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eVNOaWMvSjdmQUFWTlEzbmowOXpzL2lEaDR6bWZxd05vQlNvRi9hWHorSERl?=
 =?utf-8?B?d09zVVhpY1YybDVqTDZkYlFwYlVpMGNKWjA0QmdRdEJiMVh3M2NjUWdzbjVi?=
 =?utf-8?B?V20wM0dMNDNIU3gyYlYvWDRVM2dtYUVwZEFyWnNnNXZZN2x4Rjh4UHhsb3l6?=
 =?utf-8?B?UzVZRVZlQTgrVjd4R3JQRmpvL0RFUFdCSjVtWEZGTWQwQzdjdWk4elZVcFBk?=
 =?utf-8?B?dmUzQjEySnNpV2xOeHJkenRtK0VPbWIwSlBvYjZDNS9SdFdxSXhFYlZpVlpk?=
 =?utf-8?B?dFNXMHFSZU1VV1kxMkZRcUJFMmJ0UHpvMEcxVldHa25manFzcnl5WTRob1hs?=
 =?utf-8?B?MjNxUGJJaWxZWUkwa3hqcEVweHRNT3BybzUwc0oxT3BYMTJ0Ti9BOW5QL01J?=
 =?utf-8?B?S1VvdmVXekx1VnVVU1hNeTdMLzI3bS9JVWhubE03SmtsVm02N0FyajJRL0RS?=
 =?utf-8?B?Nkk0MXJ5SzhJbW9iM3A5VFM2MmUydjBsNVBpZytnS1VlMWQ1WVR2MW1pYmw1?=
 =?utf-8?B?SnhwbVIrZGxyZnRULzdqemdsamFaM25rTDFPM0lKa2tNNk10TEdIUkx0TUxN?=
 =?utf-8?B?WlVBaDRFMEdneHd1dzVsaWpwQk5YeE0vYzkzbEJ0blV1THcyZnlsUkNwUTdn?=
 =?utf-8?B?NXM1NUxkYnFOeHJNRm5KK1lkVGtNcjdhYlhjYUcyZWdBUFQwTzNFVUM3SzRR?=
 =?utf-8?B?dUI4eGthUlpsOFlqVnp6M3pxdW5FU3pTaHp5eHdRZ3VoKzc2djVadGMza0hG?=
 =?utf-8?B?S2c4YURRdFZSdkpmTk5iT0dTZmo4R1BOQktkeFVtR0lkUGFRdEsvMTV6YmJF?=
 =?utf-8?B?cU40SDhvOXRRTmd5OXBYRURrSHVTd1VFMG9BblY2Q0ZiWUhRUTVoS05keHFN?=
 =?utf-8?B?OXpKRkhvMTh5TElHbXVrZDg4WVk5M0NGRDdEWE5ONGdIZFFiSXdad2FzRGhX?=
 =?utf-8?B?Y0RQeTRGK1diUktOMDhJb2R3dnBvRUpCdE5wTTVVTlk5Z01idUNiVS93Ky9z?=
 =?utf-8?B?TCtVTHljSEFvUlNjV2hGM09pWjQxNGlRWElhVkdOUzdNV2ZXY01CUDJVMDY4?=
 =?utf-8?B?dktaN21GTTlzcTlaS2EreThYRVgxV2dYb09HeHBNdmgxcVVkcC9zOXRxZ08z?=
 =?utf-8?B?bVl0aDBLRkFCZGtlTVRZWjJ1UnEwalpqaDVZU2pla3Z5Z0V0YmltY0g1WDdC?=
 =?utf-8?B?Y1k5ZExVVGFCNU5DTTZHL2RxaUtna0RhQVJrQ2hSL1dvZEJXTWFxVUEyYmd2?=
 =?utf-8?B?L2p4Vnl1NUQvYlBtdFcxNGxCMStwNlAwWmh0U1NOdEJuSk1LM3pvVkhaU29y?=
 =?utf-8?Q?E1E30AFdKfC4U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25caeaca-6a67-45d9-2e1b-08d8b90b3de9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:41.0054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGKU42hwvvIRnMN08IhICi53vcf5eum4GYnEmdQyN+cc8rdzIYb25NyqVgM8/xIjGatNUGdBqJ7U8u86yydkmx1HosIzXzDYwqKPHlMbNVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=900 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 Jan 2021 15:53:27 +0000, Pavel Begunkov wrote:

> iov_iter_bvec() initialises iterators well, no need to pre-zero it
> beforehand as done in fd_execute_rw_aio(). Compilers can't optimise it
> out and generate extra code for that (confirmed with assembly).

Applied to 5.12/scsi-queue, thanks!

[1/1] target/file: don't zero iter before iov_iter_bvec
      https://git.kernel.org/mkp/scsi/c/6b1dba3d8c85

-- 
Martin K. Petersen	Oracle Linux Engineering
