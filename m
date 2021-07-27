Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4E3C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 02:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFCCF60FED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 02:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhG0CMT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:12:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61474 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhG0CMS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 22:12:18 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R2mq4X015022;
        Tue, 27 Jul 2021 02:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=nwln6O04O0ku0RZHum6+oifn0RkR+jVyiTzyzK8meHk=;
 b=YAS6SyRPuf/OXRFKvCird3hHHJ+ot75VMS7GyCHdjZXegtI0/bvdrA08N9RdFbYe8fgR
 VyL/H8hDkPEYVoWfxHmLI7I3l8ZEaSI2PV/1aJjusIt01+WtrJa+NBN+0QzfkRnjitM7
 FEqxZgkkzQQbjuTOSOgVwwJsNGGS0dYzO2U93YPlP+pKyUCF/SWt1oDYcLwmzrivNREy
 aX/pE0KoXdbkwzmxVN1ealV3PpuiyNc88XkP58xuXEDapfLSN2FxPsmEADW9xsg0e8NC
 Aw94PAYP7rlkNeGN8sZok3v1MVdBt2iUShVDh1lajgvZLZwLCxDLlZCh47OkvAh2NTCv gw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nwln6O04O0ku0RZHum6+oifn0RkR+jVyiTzyzK8meHk=;
 b=xElg1gBdpJo8a0gu8rO/STl5nPXC71I9Zkq/xQM9wK4hQN7ka7GALIm0CdhvXqD2CpPw
 yXEVmDGMvvXT1a/T9ucpntd4eYAkBYndqpQDo9cdk+nXRDs+ROuegRMq2pCPm+jm5hUO
 Aaoj9XSyVVjWlQxteiJ31ms4RK8renpcqWGzNC/PpBc21ULtqy7dk4duizAT9CEeYD4l
 nWBMfcVVJTRY2qZiUFB2k2473L/OSamjdMEBqFfQl/QKf66uJPFr5PczfTaBBtRJQeUY
 +GZvRieiYu2Z/IH/7sqJBHONkMZMQeFrx2cZTNGJIGkJ2cFEJLDA80/K/EdLiujoFvPa iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n0k82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 02:52:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R2pSHw072892;
        Tue, 27 Jul 2021 02:52:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 3a2347b2yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 02:52:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZ3WeJEYx7GYlrGoLZUjjAkGhNYjxsSvYy3vmIJgdNKfpfUYPxtpSsGvjEhDsIHlBt/AGjTNu35oLyByZengaKc5kP9l4yGfeeQXj/JQ9D8pwSWw2gsBTYOsk3Ls7/DzPgM9ZNrd2LxLEQVjygK8qjf6tlzj7F3XsbSXIEq5VmFHeHF17KpYx3iduJgmuvwL8iYvDvt+EVScJ71upPMr4ubE2sKcUUm4EME0pXzqifJKfWH4f9BDuvVEhX8GKZCUMUpxsR+boDVZIoQJuh+j5aVtw+RM2SRRcjcnv4igbtxe0vlBLe240zJbFT5XSTHPCEAch5734E0kTuFsJtu1GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwln6O04O0ku0RZHum6+oifn0RkR+jVyiTzyzK8meHk=;
 b=kyAJzgwlsR4ATmHpV53kAHy6xLSvi9CqCpQc+h8ZuscLFhsHFNH8jViTVWtOKl+G/1Kqr6x5TL4gBEnUy6uoX/3I2rm8M51YvhrviXIFWuFbWff8I3U7INu0IwdQVh/hVEYGTM3eU3ZeRXy/r1EZxDv3oLf40wgUNRXS9Obr474vEePTNqnlFIlthMOO1IFVjBs7bKvsX2AOMUOIgEEyFgj8HOByb8SJEG1fKN3Y3F4OoYQtGorYjgQcy3sKiUxRiZTLG6/lnN/d1xlM5R6niJfIxFdNcgrmfgeSlZpw0YBmZwOs7RGOWbEV3oKcOGvjg9TUQXIJsWPwFT0+ErHX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwln6O04O0ku0RZHum6+oifn0RkR+jVyiTzyzK8meHk=;
 b=Oc+rRLEFfwcyA2Y/5JeB/HK9Q3bSoxparVoXgVuSIgOXwg0GguvcwouoTbqy/uDZdwj3YtiGPKD2ntTpAL/R+FT4r0Gc3WHKI1YH9WdxdA+zBa7m7jSno1i7b4Lhg9rDiKUmqKXwH2JDiERRAoJipXdNk7N9KTAuHZ8QUa0YEpw=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4661.namprd10.prod.outlook.com (2603:10b6:510:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 02:52:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 02:52:33 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: cleanup SCSI ioctl support v2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im0wsc4u.fsf@ca-mkp.ca.oracle.com>
References: <20210724072033.1284840-1-hch@lst.de>
Date:   Mon, 26 Jul 2021 22:52:30 -0400
In-Reply-To: <20210724072033.1284840-1-hch@lst.de> (Christoph Hellwig's
        message of "Sat, 24 Jul 2021 09:20:09 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0186.namprd03.prod.outlook.com (2603:10b6:a03:2ef::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 02:52:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15f5cd86-0b66-4b7a-7889-08d950a9954a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4661:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4661AB62B5FD22F6A2C2D9AC8EE99@PH0PR10MB4661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9eFBojXR/WPT2nkz7vCKjvUrPn9Ce3abGIxKe5FpVlESrS73MzYvVXoybLRhD3Q9lA1sBhGNGOSrIpdbmIZl77XyJYnXVRPqvwlvBUkB8BcHkBIIFPUGNmuzpWG5jjM0Kqzz2/dpHYsCBwIuRlpnn+Lsl4qdwkIVXlDyRYrjNCiuTsBaSb3CLGzWuuddK1sbg0gk4OAt+D9/tIawNT5JIGp0U/44qFaSetaPefVKmD/aeM5r3KxKZi8GPvNpq2mhtnwhbxTUf/7BFqdljWBKaOixsYk1JrsX4BVTrpPoNN4vKlvaUDYSvJa9smEJt9qgMs1SyXHtDM29TdFqJsIfJWpk8I6wqmTU+ZcT6lOpHs6muv7HneSo4u0oOHHy6CtbFItSZbk/4arehWKQ36UQ277b+959Mm42a7OqZBvVQnk86iRdrYnvwb51HeKh4/eBYXuzh86RYOpUvscn/1KEWY3mu4OHbVOLdAZB03w7IRSNix/qMdIvj2ShtixVKrQn4nhk0AJ4Hnk1j7yeq0qhDhy3X2SqO4sLF0b9MXK+BtTd6sbNzkWlDEfQVHXhxZFZdIwksAuW2wCuraJKor0aqTWvtqunUjl0lyOBxdPXAwK1bzgWTd10uYTe7CQHz2XzFL56iS/X2OBlMhGnGr5dEYomwZnlQes5sptCddWESLqdDwEJCDYuEcw3wth3WVqfxkUgzcNW1ghz5bwgC9Ovpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(346002)(136003)(38100700002)(5660300002)(83380400001)(38350700002)(54906003)(186003)(2906002)(66946007)(66476007)(66556008)(316002)(6916009)(4326008)(36916002)(956004)(55016002)(86362001)(26005)(7696005)(8936002)(4744005)(478600001)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eIp1goOO2xDuPMzREINPPn13wzy3xV4fsnej7z5fuT22lWBkgJP3NSqzNgmP?=
 =?us-ascii?Q?yQS0jxFt+91M1Jbo8EEeY1gPvXOFAtB4tb77q006oay+1VNtJ5eBeUKzEIHw?=
 =?us-ascii?Q?solDjPE0TCE5OUKporlsCCywFAMy64rurQ8h9xvFgw6H2dWHIRQNm8JFgMgK?=
 =?us-ascii?Q?Jo4c225i67DwG09Ag5UXcmU2Br4wWTmRyvqNSmXQpKXVdn46cu+WFYjnhVVL?=
 =?us-ascii?Q?++PVfELBMzvvatxdVX/NvjCeJuBwlZtoAU1gvE6a20a3nYWORVW3D4/HKBBG?=
 =?us-ascii?Q?pfsuU0d9VWqMl6OdNT+W2sCerIkfdPYVpDotCEDVjw4wmIhpaj6S5ae+Ly/X?=
 =?us-ascii?Q?JNxz0RiGSvGNikrT67KnuAr4DSwF97an4c974OSL7hU+HdYA8XPzPNQIX4kQ?=
 =?us-ascii?Q?qR13L1WVTBefRDTGp5MzR96xIlUsR6KQmyiYQikMcweGl783Xe1T9wN05iHP?=
 =?us-ascii?Q?81xv2u+ym1ird6rwE81ORrvPRCgkZHGEH2+rNcvbt1F3ahdnVzZ0XOEptQ7c?=
 =?us-ascii?Q?TlhGok/JLjcgZaCu9HsPdwKXHNU8gDULFqzkDK7QVzRgUL2Yyow/+j6qo4/N?=
 =?us-ascii?Q?8618Xu4IWui67go2UZAJAkJ2B+CamWvDMwTNMfTDR4rMU4hrDFRJ1IsPLPs8?=
 =?us-ascii?Q?k4d5TuVhx/ni0Lm0z36To+4g2XYA+QhhT4yL3XbyHSOLmNCDC+yaiwzeF7iG?=
 =?us-ascii?Q?tmZMDm+UI/gYrETy4RoWNJosRj2vl0bVwx6CRdi8iv11vDEZDYcsIsn/OYMs?=
 =?us-ascii?Q?VNa/7qxEl/Usj0tXUNoG/rERsg5cPAiyZ+UcU9HJe6uF3xmIGOFWeFLeDoiq?=
 =?us-ascii?Q?9fXO2ADyIVmzILSpY5SpI61ChpdmjxmrVScGtDViXLZtnCU8j5dKzo+UFXQN?=
 =?us-ascii?Q?IbjF8HiQ0Uroc7D+wuFpi7nGUVyrMj6rGrxW1u6eapts/y/BS8S2/uWwwUzT?=
 =?us-ascii?Q?LpDM6mu5Yp2djffjVvD5SeLgO6r5oDuoHJva42cAV5bAPQkCkidpKdZ+X/zh?=
 =?us-ascii?Q?UNXqI7a4lssl4/anAys/wptlApIfECsol/6BKwuE3TUPlVQZhOKzcGrT+is5?=
 =?us-ascii?Q?M7pU67M/n3M6kAOwtPAiNltVMnyTGxCcU6coNWA5aYaPcdn8dFJW85TbmYIP?=
 =?us-ascii?Q?6kssAWt8iEQbTPdPtXSMI03w8G6z314N/QFIU7O0HIOfngy9Z2bt+jGLMwBH?=
 =?us-ascii?Q?XW0VR3saoVJmXgfVJON4d26twKZz6c7hppIgzsXA2qT3hWBIVRtAelaoKvGX?=
 =?us-ascii?Q?Npc5cx5VjVPxEu0pKmpHT9PHSi8NjO0ZH10kSnfoXZa+yF1NGn087ZxnWfOC?=
 =?us-ascii?Q?SZ2DafyqNnz3mNLVimRBwoBa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f5cd86-0b66-4b7a-7889-08d950a9954a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 02:52:33.5669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HWLA8Ca2pW/T6OEwbTi8co9nhUQuAI2CCxK63a1avoOysdPZrJWIpnC4n+9NP/tJod1XL4kbrQX8ehnp0pM4vV84bqnU1R/TBUXVF36r2nE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4661
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=602 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270014
X-Proofpoint-ORIG-GUID: fUE30Fki8L5BO-gNPKJO5bNwyixjOjpX
X-Proofpoint-GUID: fUE30Fki8L5BO-gNPKJO5bNwyixjOjpX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> this series cleans up the scsi ioctl handler and merges the "block
> layer" SCSI ioctl code that is only used by the SCSI layer and its
> drivers now into the main SCSI ioctl handler.

Applied to 5.15/scsi-staging, thanks!

The missing module license for scsi_common.c remained an issue. I fixed
it up.

-- 
Martin K. Petersen	Oracle Linux Engineering
