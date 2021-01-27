Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC281C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1FA2070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhA0FiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:10 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36184 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbhA0Ezb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4j9S7092666;
        Wed, 27 Jan 2021 04:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OrJjxBhCmc/Lpml56MvMouDE/QICgRnPybkMQxpuzhc=;
 b=C65t8cI+dhP0+EATcDM0CXPazoKv7XRjDpUyg52XKFbpe3DL7F2F8FPHKf5KnBcB8eZn
 QHnmVTF8lsodfm8E6YN3rd34ah8ugP6vd/B9eH0AFTKrqsjVta3n2DqPuzLKAXfRlb/B
 RSs2e4xXByOrM18smUpCSI9tXgu4UbycFFwCYxNyYnLk0HC4AZxffrEk+x1P0MGAyPg2
 v5ku9EPobf4qFBWYglkw0zX3xouh0QKnI7Dj9au9W3mLlsPpjKfdBZWIJF94BfRszVHP
 jIjYHuJ805jhLDY0dbAu7Gj79+OsN8eBr4ftOrqK30LaTY/3JktMlAcFQUuWTRD4+AtQ wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aanbau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4p6Rq188980;
        Wed, 27 Jan 2021 04:54:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 368wcnsk3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwXS67onHIsj2JKpdRGUxGaHVK11lCBaNBjr+ghKlAI2ynz2S0OKFzV5GTg9cguqLzKx4AezGVDXJlfFKpJkfB0Eyob8TtekuQYj+bNEsQmA0hHNicE3grd9qCnbjX6kw9/bCAmrEEkzxDwxTmLWkFfSVkpX8pD7fpyy0RkZo/bYSfla790VArPCmaRQ1r0g0tW5PH5zdM1RuTh0GHbuXxUHm5k3vrgzHrn4IFkH2wj+4NuwhjwbFzCdYqOa16MrjZyFO2X/nJnukQKwxsunOyZuGSeF83cx2WM4JVtSAdsTfY/4ED5tRCiddool4RxiPf9Lq8IN4PGnjOJTWn7J7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrJjxBhCmc/Lpml56MvMouDE/QICgRnPybkMQxpuzhc=;
 b=F6Du9gUMMS40FnMI9jqsH7qEz/hNWVn5ZClS+bUArbvuCK2LSVHA9hzAFdZaQPfH2Exb8ltxZhGk1F7hXmKiXP8GXTw0UhnioAHRAwxTdXFhlym2zE6Ted+LmgD9AK4lUjOLXHzN86JXYteWxx4mCUILqn5g3AWEsH/z/bhC+6YnBsIxenCcNyBqnq6vIXM6cGU5itURSLRHDPH0pLmGWRuGTfT04XFpf+eNKroBaO4dyPHSkOwyKbnsjZ1QXB2Jvq6RQpZV5AnYbyNSwe/yFOKxlGU1E0cswoUwkLJiq/hetAVeEPMD7l5pMlUkx5Vo/kASgdJj2TI4wMxSjhCYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrJjxBhCmc/Lpml56MvMouDE/QICgRnPybkMQxpuzhc=;
 b=bQkCWC8K58l9JRx1Htg15VoyL7St/iy8PaAFzXfbmz4e6OL0cteIPUPrYU4TUcAedGW24AG8lTSt7UmRZsqVffUrWx2NxxPdhLrby9DjPB92JzQby/duQySrgAMvVBEyU0NS2H8DrEiZj8cgr9pin3ExMHjC+OwYDznMeFMQevk=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, sathya.prakash@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, sreekanth.reddy@broadcom.com,
        linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: style: Simplify bool comparison
Date:   Tue, 26 Jan 2021 23:54:19 -0500
Message-Id: <161172309261.28139.10623986186367068190.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1610355253-25960-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1610355253-25960-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc65ac6b-ac9c-459a-376c-08d8c27fa547
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45846AF4540A71C8AA6657C88EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZedQVWZDGsi25UfPfYbwiGSOFv/JMH7uc2Oia+QzVCtQQo9Tr4Vhcx/ICqIsuLnewBLJu/OC+1SUhuHKiljv7uTHlI3+6RkLDn8q+l5dCIszoQUsXOu2ZSNmKKmXGE4Ldz3tD5kQskwlUZPd43LgAf+67/x5NzATBVkMO2AY0Dg8CUZmVeBR+FEeTBYfawnmlN5Fq5n18Xf6PLFepVpdQyCygS2DSdwxxtbH2OPh05HdK4fSJ8GiRx2hs1zXy/wCqnx1RaG148byBKaKMPa7wOVJaFWksoJaib2rMZWRqs1S+r1EPRiA4VWtw0fFNKwC0X9wmhOHID+eCz0yQEpwUFopyu0jcLhPeN4LERtSAQJWQNq9IAiwBlJ5jflRQ+kuPr4sWmfEutwpHn4kD7jfpaBH7+jBCSUPLBLWPK9NLmurH+Mnam8VrScsXguOWk4Lpme1osLRQVOusznRDo67607cAqXpNbHtKdBELmPJZqQn4/TnrSbZvo3fxi4dnf/J3Fi09cEtD4Do+/QPM8Di+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(4744005)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(4326008)(66556008)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eVdmdmprcUpHNERkcGpWZ1lNWGtQKzhzcHRpM05sTTB0K0p5UGFQL1k0YXJn?=
 =?utf-8?B?TGZHbWtmY0FjVnRZajRyQ0t5dzhmOGFaMkZ1OXYzUjJHUEJCR1FNNDI5Z2hE?=
 =?utf-8?B?TUhWODI1RTVUVzZ4MmpndHQzeW43RFVsWGhiVGZ0UVFJaXZOaEJSTDdyVWkr?=
 =?utf-8?B?bVp2MGRYOWtSVFFrMVZMK2dXdG1NWnJxMDQ5bHF5YTBNN3FCbTFWY2t6WG5o?=
 =?utf-8?B?QjVOb0trQ1NwU1pXemptWFFROGZKdTMzcktVWXFqVWRkOHFjaWY4Z0U2QkRO?=
 =?utf-8?B?TW5tbXFPOGtkNUIrM2piMk8zKzdLU05peVErU1ZucVNUa2xtdjhJVEJ3VjFE?=
 =?utf-8?B?WGxDQ3d4ZTlJUW04bjl4UjI2bEh2Zk42d09Na083U3RzODlmYzZ0ZTZBdG9i?=
 =?utf-8?B?b0hqcm96NUg0cEpGa1Bwby9xUXVJNmRBOWlremIzSGdXVjFvT1REdkFzN0lW?=
 =?utf-8?B?dTdLc2J5TXBDekQxYnRMTFpkRzZjWSt2UHVNazlPT0drNkJjajc5SnNQRVU3?=
 =?utf-8?B?bmRwNmJYOVJIR0NQWHpUdXpsV3NVOHZkRHI5cHhMV1dPdW0wbXYyZE1ERlFX?=
 =?utf-8?B?U3dneDJSdjVtTjhqaDVMdjljSjZITkZiM21iQkpUamdScDBmc3pQVStSMndR?=
 =?utf-8?B?VVNKa0NNbHBaRGxZbUhZc2V5VzhPRWE4Y2Z5Q0hMZjV4a3BuQXZCMnAzUnZ1?=
 =?utf-8?B?WUM2T2NtMG1wYzVKSmc4Wm5YQzNEb1BUM2RObE9MbGQrUFIxUHRTOHc4cEtC?=
 =?utf-8?B?ZHRmN043cjZmNlRmRmFDSldENE9DbW03cklVOWFrakFmWEFFT3RqRTMrbnBq?=
 =?utf-8?B?NlRqc21CTWZhT0lDRTJyU3VXVFZPMHhwaXFZYldISzNuVTJ4V04vc3hLZ0g2?=
 =?utf-8?B?SkNzWXUrYVkyQkZhUVpaZ1NONWFmODk0clpQUThkelVZbWwzb1JpNC9GTkV4?=
 =?utf-8?B?M0MvY0Zub2FmTnZDeG5YejR3WERFNTJtSTl6T0QycitNNFBnKy9vWGxvMmx4?=
 =?utf-8?B?NjdNQVVlOW42U1hpS3kvTUNQSnJ1dEM1UUZCRG1KSjh0MUVhZFRqaXdiek10?=
 =?utf-8?B?TytuVUk4bEdudXlTZ2Z6T25UbjJvOEdnaGQ5TEh2VXZFb203ZHZsRC9pQ3hT?=
 =?utf-8?B?SkpoR3NoY2d1QnZ6TlFaNko1M2NDTlhVN2Q3MVdEUktCWWFZSkZ2NC80dmZG?=
 =?utf-8?B?UEQ2NDczcG9WRVdQYmZvbHNWR21rWHpTZWxKb0hwRHptYk1ic2k1dTBXc3hQ?=
 =?utf-8?B?d1h4ZHduZ0lsdDh6ZzBER2hIOVh2ZlJkbWg2ZFNmYjdTYzZleHJtSWV6T3Yz?=
 =?utf-8?B?R0VyVzBRYkViUUxuUXlFTm5KQkJsbGd3RG5YSHVld0N1c280Q1l1Qmt0Njc3?=
 =?utf-8?B?YXNOYnRjVEtwNFdjQnpxSlA3dzkxNVJySEV0NFBUQ3VSWldXcHlCSTlsSVcz?=
 =?utf-8?Q?H5BBXTHU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc65ac6b-ac9c-459a-376c-08d8c27fa547
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:36.5106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfVX0p6s8SGJBM5X32yyu+s8+vroNcXDwW2IgTAJfH7854k4GYYhhlIvXpBVGjRadyHQA22TRYTsCzj7xjiIJ2eN9SPpNn0pE76yjLHWIl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Jan 2021 16:54:13 +0800, YANG LI wrote:

> Fix the following coccicheck warning:
> ./drivers/scsi/mpt3sas/mpt3sas_base.c:2424:5-20: WARNING: Comparison of
> 0/1 to bool variable

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: mpt3sas: style: Simplify bool comparison
      https://git.kernel.org/mkp/scsi/c/bfb3f00c0613

-- 
Martin K. Petersen	Oracle Linux Engineering
