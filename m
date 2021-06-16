Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D965BC48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38546137D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFPDmb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:42:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60986 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229931AbhFPDma (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:42:30 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3VUO9014640;
        Wed, 16 Jun 2021 03:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=utoO6DKsH4V1XIwKv3WhvEC5ij7KuRv02ai0/QyZBs4=;
 b=bZaAzZrSCLV+8QXzQZePzjAqorbv6r59UMlu5IBBUsMOZC2++i5W9VM7Y7i3w/2Budl3
 LS0HkP1oCJOkFmi1yFVOISsE/cnSiSxIbGqLF6rdRPxM+gmx7X0Prj1bmp+CGPlE+kYv
 N1A3x2pCrWOptP+f4aFhCUteWZOQSgzI1Z7iY1eHjvqlwSjfZAHQB/5G81LgH4akIuC4
 kqnsDRbo/kNnJD+WUPe0x7W4id2UE+MR5+8JLY55UqKSpLzefbUll3ltdIAPnrza/pqq
 7R6I1a5+JksPOoQQKZUwddzwRlTY0Saa4gqTklcNdIDxp8TMAYR8CdQtU9a69jWLTzmk Ig== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 396tjdsahe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:40:24 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15G3eOXS018661;
        Wed, 16 Jun 2021 03:40:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 396was6pf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:40:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaT8jLi8e25b2B8+qm4TWgDxPgI7hTRXoNy5P9asvEmPv5Tou7GeCol2QZ59GMb2ftZIogjArELRjHc9wgfthKTNSWXBzU9Xs4te0reMMnJNLFYsLncXWhwhwLsNl/elx3Jzg5EI983fyFo2kzbvhLRI554fTaiBIhusg2DaY3LoNZlOR38dG62Edx97aPexeAx8zfsntqQrbHREWPef/UpX7uFa8kzn9sA1KDPvG769g6b2iOzWCQTtYCf2lq5Fs8rbDmIHoAyB1eROXX0Y3EIoR/WTQy6ejpORGiokY8hQTa0YO2liNB9Ya80LT9yp96pIMBzQcJ0jCfFKaEgwow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utoO6DKsH4V1XIwKv3WhvEC5ij7KuRv02ai0/QyZBs4=;
 b=g3yidEZQIPDgVkjQw+2aCDB/8WIdkcaq7UD24qOEhnbvMJGycwTE0YEVgrveaJNDax6bf1I9XHvOS32OeceE0OimCGRJvsj6aV+S9GGwwWRf66z8bmeqpb+tadoGERUFjSNcZcPE8QW0CYkK6wVUDyXBeRNpwtYTAPuUGoxnublSZbIVierp3GQhbakcAmIcZQWRzt8QelIYFuaSZ2SmX14zf+vbpegSNrHm864uqqpwVtsLque6rajbjNrXFmzwvnXfpgbTf31J6gr0zI7GEqq8A/rQzDVnS+yerv0eTB+7uzCiuJEmk4k2+M4zv1MQr7SLlTOOnik8lpLyNRanWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utoO6DKsH4V1XIwKv3WhvEC5ij7KuRv02ai0/QyZBs4=;
 b=XEymRc3icUp0RuTqXRecy+Cmfo4TL2F/AJAkJNrZfEkn0xdrrX+i5QQeekE2boFpMJ8Bo/bkuYD2fcUFZ2la9XugzF3YWhj44bgZoGh7xmx1EUbK/lTr4BxPPgZr/NpZNnTPsAArw0xiUqbjTWIsJvCLUDpTQJrtS2mGMDbcOkI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5436.namprd10.prod.outlook.com (2603:10b6:510:e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Wed, 16 Jun
 2021 03:40:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:40:22 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v9 00/31] [NEW] efct: Broadcom (Emulex) FC Target driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kdy5vfp.fsf@ca-mkp.ca.oracle.com>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
Date:   Tue, 15 Jun 2021 23:40:18 -0400
In-Reply-To: <20210601235512.20104-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 1 Jun 2021 16:54:41 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0701CA0007.namprd07.prod.outlook.com
 (2603:10b6:803:28::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0007.namprd07.prod.outlook.com (2603:10b6:803:28::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:40:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71c5bc75-6986-4143-70de-08d930787864
X-MS-TrafficTypeDiagnostic: PH0PR10MB5436:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54366A439337E956D42C84F98E0F9@PH0PR10MB5436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAg4+7h6K5o1v8tyuDzknkzL9zIRU13Herwsw+CJpbBStlgBmQZ+MdJllsIIWT+28CF8MQn1BwzzdULCTqULCBdvYcA0pRo179WoisXJCgBbIxij0xdaDnWlSC8D6ft9YYdBZqdw7qhXdzlREKv9WZtVe/AzbRCWJ7DZfrXh8vj9mM6DRMYAt4N5+YQkj6tO9N/oNK2DU4V1F+CZu8cNVf/NqHd4hrJ5oq0/oiOVQiNHJ04lhGswb+NUKzGkEcqmn45c0DIIPkTjaQzuoQM6AOX/uD8Y7gshZyu3iglhUjhfzqlMk5ac+6Toj4A5pn5ECM60/2m2cZEiFBuV1MNGwm1iVmguxViBEMVgB+Ws9ypMp2oFzAKx9sIusYNv8biDH+HVt29RYzgYC7knDYq0/mcO88NJpah/vPGiPgtNRZzm3xFTWSCtUMm4FaKOijbJtqp4+YttosVkC4Hv7CBhDiSSUOLv8XLGFRFXs2bNjvvY/Y+4JUY24tSgAIK0jd5Z/KkAErWueIWFQYdBeJQBkBMB/f3zvkr2WbHgr87Qw0mNN+boK6rWai5EoqUwiZPsDaEQC7uDJAUbXWfUoucQU8nSwHGF3OTsZ/gw74AFjnir2/GI6PdWP3HXPdmLdEnCFYEJSxwLnGi9QLw1tqbDRmStHwmYsWqNQg+Ahr3trJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(376002)(366004)(346002)(5660300002)(316002)(16526019)(36916002)(4326008)(52116002)(186003)(83380400001)(956004)(7696005)(38350700002)(26005)(478600001)(55016002)(66476007)(558084003)(38100700002)(2906002)(86362001)(6916009)(8676002)(66556008)(8936002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UuTTMoAj8EuSn2wgZCJBzf8GU5+d+1qJE3cYPCsRTMa3GUXJNLCz4NMQ7VRb?=
 =?us-ascii?Q?ri/t3k5vprDpf6xuK1S+tL9Dr3v1q7sy5Gd5g+Y2UnrHYBIs24CQln7TCKGS?=
 =?us-ascii?Q?AaIvUJ2yyhDgTPublcCwW0GY5hFl8qG52GrU/znX9JvTrC7UEo1tKGbCsXAN?=
 =?us-ascii?Q?nFhK2qrlg7rhV2dbHaOdy6folVx0cMEmn94LWZ06VJIg8T+NsLt3KqXJAe5D?=
 =?us-ascii?Q?UHpLBug1S1vVqHHSkikFJ/9irWpRT0tR8pYpmmtx1n57U/EDDaqIvOGhrXeA?=
 =?us-ascii?Q?xbe1Np701CHD1A72G1kkh3roublD/0qklU50v3Nhz1aaGsWWL63/L0EzwbUY?=
 =?us-ascii?Q?5rv2TB6u1Ur+PUHymAK4xlhtapBWOQH8TWLEryWO2/JROFNPq7u1/E02d49j?=
 =?us-ascii?Q?M+BLc7Xwpmvuhvl/kcKnwajyNbY7JgSUdRbtqik28Vl4IieZMid2ROQrIdJ3?=
 =?us-ascii?Q?PiVVNiNGYh0hov8xRulx+JizbwVz4Ln/CTxGn7iYTWsAO7Qd8QnlgvBBuQY5?=
 =?us-ascii?Q?tCTwP/1kOnckceUR8N1zPYoHcoQDiPFa250Lq76fy0Hse15RvLz2azBW6KMl?=
 =?us-ascii?Q?DWhFUyxpc016zATqJ3CKktxY6C5JbjMUdNQeufk3G5N14NT7NkwOU4fHagyl?=
 =?us-ascii?Q?Cf6bj1ytLBwkhzNym4Zy3mFooJyFXK8Ng6J2SMqPqD7sRBCEsDDoekyXDmDH?=
 =?us-ascii?Q?oNhjDmLpGottRA5kNS545muba/icfCaBE0i8reDGORv83ckLNrRHJLfyOWBz?=
 =?us-ascii?Q?AfZkQLA+2pvAS7506vy150mxYr0dGu8HQGJiaDUDktOQTzmQFoFx18sErndN?=
 =?us-ascii?Q?fdM+fBL7YEASvjMXYiL463Zp6VK5fR3KWghHDnxzOg51ibbcg/6hqdBcGus5?=
 =?us-ascii?Q?kkM8cMxH/oUKloor6XBvuktnzQi2BtV2H2PKHNMF5GCHT7gTfcnEtMC9OU8c?=
 =?us-ascii?Q?rCIWUj2k4l84gHSn0ZVHc+VR4HpPbIgRz4jZ8qXW3xWsfnNs0lDql4v/0htH?=
 =?us-ascii?Q?8YGGrl8yjHpAoVKAQdqmk+W6LXO0O0SUuW4PxlvfLPTw0U1nemNqS9Gl6aIK?=
 =?us-ascii?Q?22igLIlv8GatkbJjJQV+bm2BRxoSjOiYkqEiLJv7RTKMkwQ8CaFgIlvXZA4l?=
 =?us-ascii?Q?7JkDyqRcet/A4g6ifa5okA+F+CXLjNbjFFKNvhsHWr/o2McThFoyY19y9fAY?=
 =?us-ascii?Q?2dsUxsKpiH1eKi9dPhgrViBb4ee2GYz0T2pL2nN8xT6qMbhcf6m5fCV1yjzQ?=
 =?us-ascii?Q?sOwwn5aoaU+JjEVLN4QHAGkszLSeylYxpFI4xHqEYjBumrt+1pfREiRYOsxf?=
 =?us-ascii?Q?IuutMN+fPxIrDlz9MUqzFMop?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c5bc75-6986-4143-70de-08d930787864
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:40:22.5325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b1dMXD1whWEAz9+0ZjRvlyyhqL0ifFvH2RYPoYUhhMXfgLJl33thnE3vcMDtJusxDC9Ewb+HMGwhlBqlkJ3kLxEWj0ZDumO9XNDf6c1yctA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5436
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160020
X-Proofpoint-ORIG-GUID: YnHo-iBiBdjxX0ddTgKYJrF56A6-58VT
X-Proofpoint-GUID: YnHo-iBiBdjxX0ddTgKYJrF56A6-58VT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> This patch set is a request to incorporate the new Broadcom (Emulex)
> FC target driver, efct, into the kernel source tree.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
