Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15C9C4743F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB0E6135D
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhFHBdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 21:33:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhFHBdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 21:33:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581UMZQ107409;
        Tue, 8 Jun 2021 01:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=scEQjg7xFIGIZ9s8NfdBqCQ31NJLVL8cwVjuyvjlUvE=;
 b=QyrJb8ncKQCAbJv2achBIkNzNl1O55D027iZYpNkaBSbB9yPJ0RzcFsk2u03jMHfzagL
 COOmxaDdoqM5Nh/obnVb8f/RuPr3Mq4e5xODm+XR5+tTDafLmyoWu/evOCQ+Gy201Mav
 RNbELX6rl98owaZ+23PlaS/7FgNbWq+3xCg2gcciT195IodJZ/JjYSi8vTUlY+N4jj/4
 vaQR/jdHlWqb3CYr+oSb03QbZWVAqoB0AlObBGz6Hjttkmo95CUV2ucAqeBuI655ggIL
 sGu92Y9JUvx9sj7cPdvUpaqL3l3LZd1JCfcd6G1tngYnb9pLBpXNohKUCrNvQQJSxBOC Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3914qujyy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:30:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581UZJd123609;
        Tue, 8 Jun 2021 01:30:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by aserp3020.oracle.com with ESMTP id 391ujwcmjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:30:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAyY6ZDOj5FGpqbBx/I0XxiYGlyrHX1Adj5Tjg5Zgk3XIZcnSEN4rlw16E6b6bNe5dGUMqmYmKpf6JUm9BLxvgk5BBRUd9rbeNN7X7XcHerbB6YDDBPhqZloXFQtyRKj2wDN1Hizxpg0Rj+uoPbwhnC2m6StXfNVdHkraULKFY7raOdr36HCbbcquUdUO8ouMnK0ig6mkPMc/FzChO9nuDRtFH5nYsCJG9eI2wDlQeiOrzPVa1KQ/oDiu1T21725ye/anGlmMCzzhz9Hx4jHC7wIg+lx9Nt5O7aOl/ZMpBjZ0ciU34cAFiLDakZiQGX7z41hNNa7/ahEZa3XBqgowg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scEQjg7xFIGIZ9s8NfdBqCQ31NJLVL8cwVjuyvjlUvE=;
 b=YLv7VUAo3Cl/tII6arxRVGLQkL4w3HGGPIfzCq7nyxt7IztKPFqQvnqH6NT5z0ty85ttoBObJ4/VUTiEZQaxQ5i5u+SKlnNcsF/3NFq3yXdaPJdrvisWDaQ30O58aub+bNHU/SyVOOlxPrGgfsAGLlHdLoLvkNA84Zed2sFMWYPc0MrEESWlAntCCUDQEmcVJlqGodVqFuMSoRRLGwc0gbunsoWnev0cHOkcKKH+yVPawftgPMHOZ9fv+ec29WTW1IxVteLqos/fLU1at3TaxQpuV73lxBkTMkKbS0c+tdUPXq0Q9NtVWji5uUeS+HJLacaGPi/kq4Dm8Mp9NP9Vfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scEQjg7xFIGIZ9s8NfdBqCQ31NJLVL8cwVjuyvjlUvE=;
 b=vkzB67tDkwELjMH2PMsE9fOFb+tAjDqPI+km5uw5eiyHCQRNBPUmVWTTwFniZu4F7Tq9uiaE19cROImme6Hwtw9kEql8oSuQZB2/LFY7k12FfGOxDoV4e/8ArqXB/98yJl9kXeVBLHxD/UZKYaqftJbFY33dNdGWdiU/l4VQJPM=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 01:30:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 01:30:22 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joe Perches <joe@perches.com>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fcoe: Statically initialize flogi_maddr
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im2pkusa.fsf@ca-mkp.ca.oracle.com>
References: <20210602180000.3326448-1-keescook@chromium.org>
Date:   Mon, 07 Jun 2021 21:30:19 -0400
In-Reply-To: <20210602180000.3326448-1-keescook@chromium.org> (Kees Cook's
        message of "Wed, 2 Jun 2021 11:00:00 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:806:22::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0039.namprd13.prod.outlook.com (2603:10b6:806:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Tue, 8 Jun 2021 01:30:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 968d9cb5-0a6f-4959-01dc-08d92a1cfbd6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB463187B52B8A8168828BB8DC8E379@PH0PR10MB4631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pa5xU5UCl9ArOVyLUbmhYAowzxrdazTGCM55jpXJtMcsVgOBpw8tLzDe/UVd/EYd6TtKmK4aYJndlnv2h6ih7DslndNhGCIi0w3zRupmxvREeah1E0gbFcoLve+bJkj1v+jSHrHonPNFhKphVWj70HdJZDHDqCEcvUUL4L7YYuGMKrvW3kNElicaZxmeeLAGCA3AiHEaZkT/dsvIY5OmqeTKITEFYoYniXhLHFRyGVeByJMtyYWmPann7rOY1HlWvxKR4VXGGFFDjnIbs2ZD3Dwqcv0wE0U9Gywzuf8IIG3cdpDywPZ+LXzqiup7WIZM7Y40/4/CER+HTCQEoeFwLUGKTzuoxWQZ4vAURUqQdMNIoJacWEB7yN1W1M0jriKYPQepYVbo7bSrTY9Zek6E0zThsF+r5RwPM8DKLlNcVT2pDxNCiM6vXJtIVbZpB1UHmHUQ9+YziFqturTZNNmdfqDdKRsmLfE326Ss+TeiAKLj3LRJJ2Pcikk8RMYCM6yLIbHDFdHook2Fw41cgaiUtZff8AB5Gny3OH8P2OIInlLgSXeIIh9tJ1ufCeOmLIvW9hxX12TyvBehojOIl0IHXFzSYACCS81SqSbTQkhSpE6VJfvCZR0HlYMSHJecEi0qCXG522w/ZSSu47zvkcR+xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(396003)(346002)(6916009)(16526019)(26005)(186003)(66476007)(36916002)(52116002)(7696005)(66556008)(478600001)(8676002)(956004)(55016002)(54906003)(5660300002)(2906002)(316002)(4744005)(38350700002)(4326008)(8936002)(86362001)(38100700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pzBLVWhF1LjeJMh5I3gqXb444EReviJ93i+t7eP+C4Eiwc2ywcvHsH5/R1RT?=
 =?us-ascii?Q?ZxbsnUEIl4rfRnzj2eQVUQWqZT/hqM3DugonOze5lwV/+g8iCCi4Cwpc/VcI?=
 =?us-ascii?Q?mw6pecDB/W46VVbKyK0oGHrv+FsMM5Y/BcRplV09MrDwSB2kFSbzlDobuL/i?=
 =?us-ascii?Q?7iIFXzThyNXwM//nfBPw9BVwgFZCg3DUbmoAnEf44H4ntJ2uOgQRCE2Vup9+?=
 =?us-ascii?Q?YHIou+9T1YejeXL3MBYQ4pvppVIYgKJO5lvipsVocmDmlFF55F8QktWoJVIB?=
 =?us-ascii?Q?N/2sTqkadnKxJ9WaHabdqR30QVW875t5scZsx7MMzJLEFf9hfL2Iszg4+7Nr?=
 =?us-ascii?Q?AqeiaGlUOdWFKj5240L4SaSdvl0ImbGkHCzWaGxTGm/VT4Xz8lgJjcQAN5Qf?=
 =?us-ascii?Q?QHeCqhf2CHL9LI9jjbtmH3Uw021GwZ9iKwb9i3cR9xagUjlhNsO6DX0fTUEA?=
 =?us-ascii?Q?Q3KCc+plqunI8dnVqPj55uceXLBkk2CQi+JEP5tXz22oC6u7Ew6peOape7oU?=
 =?us-ascii?Q?vX8YwQMKDXbUHufqIohSQZoBWDCD5Cr9d2qUxN/Ndbyr9lt5c1Y+8M8Grfxy?=
 =?us-ascii?Q?gbxETYPTgIq+Y+D7b1phQET3ojC2Y9zgvHGQtXzm95WezxDNa5UKy8Dfd8+5?=
 =?us-ascii?Q?5Zg+5bKbyC1ODNt/ZG6vn6la50w4h4l5ARJw+2q4NqUwnFwAoL6OTJidOfVK?=
 =?us-ascii?Q?NX9W7jmUC7un9pVSBKjmbC2cNoY6dq0wqRgU4RMo40ehgsyJS3jjhR5OShqK?=
 =?us-ascii?Q?guxy6T34ajAnBv72/6IPpuypmO2dIJVqDvwvE9c+1DhFw0nCUfegHlJZ+Tdq?=
 =?us-ascii?Q?e2SmPZykniCXAfCII7Q8M3laG9WkeCYDAebzynK16QfPHVZVng3wm4legY8g?=
 =?us-ascii?Q?lcuFdeR+TjjzH0YtijIWvlDgKWDqwLKGY41bzlQQGbd/AAE9pSsgIhiR8niP?=
 =?us-ascii?Q?7x6SWzKRxG3XWMzgrKey9FeVM7L2gXrh+MT1TBMfETbJ2CMT1KTFJUshhMTA?=
 =?us-ascii?Q?khy5LtPv9tLVFSjEYGjDscTi36NpubbFZZmZK7FKUv03ux+SnEO4to/YzRLc?=
 =?us-ascii?Q?lxV5aq8JzHmeKvF9vQH0Ju68jQpMeb08HoBpP52ApvLqc2e9i0OzcLuBJ/nQ?=
 =?us-ascii?Q?0Nd97eJ8LGLyUTmXe+QMs3b1Z4iyTlZTiPuBp2VVtoenTzIWKr1X1ubnFIQY?=
 =?us-ascii?Q?TXE6+w/gFH/Mt/tg4pdElRcyyUzhN2RefmeygSEmc7Iw0h15OWDIw4Jf8h+E?=
 =?us-ascii?Q?oxfQ6S9zx5/lAaDmEcHsUV3+UzFenqLXH2zJqOQ739LP34zu1RJ/vDLSSwAR?=
 =?us-ascii?Q?IIZj9ta4LsQmmKPSM0qjpYEJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968d9cb5-0a6f-4959-01dc-08d92a1cfbd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 01:30:22.3437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0IDJ0DTKmEGrxYh/Fr9oiKo9NLZ9AApXZ+Zn9d+rjB/GhWWfJ83p/bzZAoWmc3oXZ0p29ABGYeFQ5ud9V3Vcit06V6ltHnT9U0YjYzzslE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080007
X-Proofpoint-ORIG-GUID: WtBRkkXkcFJVTR5htFXfxnBzBUFV1fBz
X-Proofpoint-GUID: WtBRkkXkcFJVTR5htFXfxnBzBUFV1fBz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080007
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kees,

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy() avoid using an inline const buffer
> argument and instead just statically initialize the destination array
> directly.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
