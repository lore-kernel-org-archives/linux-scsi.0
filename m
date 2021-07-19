Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980FFC636C8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722856113D
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhGSBXD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 21:23:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61092 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232895AbhGSBXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 21:23:00 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J1GMgl028357;
        Mon, 19 Jul 2021 01:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qdrwbwRep3vRu6g6Rt2DUN+i64J9I9xn2IZeEhY+g7E=;
 b=k0alGjezTGmWAB65sfDFt3PbfxOlucyUR8d5pTzam64maIM64S8TTnAX1jA8wTc9wtP3
 W1UoK4zNeGyFk8Yd2/wcNEAPTjYiDuAV9pEHms3vmGjtE8YUtT9hIEc0DeJx5At/+aiK
 JAIKU4FuLXAWRpERCwDSmLGKovy6+BcyeHzHpm1IBKA9HK2QaFjjWkVL4tGO7CM8zCmO
 hnd6H8iwMbAGKsQCWtZo9RA9tyvuSrxlv72GCTiavjLqwjK2JbqP98xD4gLbRzfNsocB
 lmNiA1UQ18sy49+Gl3uHDM2BcwbnzSDJkIiMSWwY57PRPqjEMCNHTTOdXcR/L3ZqiiTu Kg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=qdrwbwRep3vRu6g6Rt2DUN+i64J9I9xn2IZeEhY+g7E=;
 b=0gJGYo1D16hEEfzu5iMmMPMnAXGaUHclF61uHDQoTo4b51q/Vw8QkYtA2mCcr3oYWAji
 s/7tNLFeCTSYBzducKF29Dvfj6iPCQKMb3ww6UFtH6M43i2PUQqjG7ZVAsgsQEPdGuBn
 J3nYSyYYvTxIRdAURcJrMM8CKs+wcD7X62PUySHSrFUPh0mXfoMpOkQv/H0GFASpHFrM
 WFcA8nEtY6SrQ5A4L/Wg2dgrqHL9qU/mcu4sfllA9/7MWQj34fKl/tFnyvzLfEQ6qwrE
 BQdYs4S7f/ILHU1EHu5jRYt+ViPgWrAYcivMJL+lkU/injJyHga62elYg0ydRkpkMm6L Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39uptrsu3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:19:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16J1EwKl029496;
        Mon, 19 Jul 2021 01:19:51 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by aserp3020.oracle.com with ESMTP id 39uq13s8me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:19:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myZXN8vbU8AhVQRup7YeFfRYtTEh4U169usP6Qcl0BhxFVEE3zXxmi1WOdHzYMI7fJKcV519cqmNtzMT+FvV4ASHLYrnlh5oUndG+/3RFvgaYfqRmNHZOB2PPDSdbWw33WWwzeWETt6RyKj4eqNtrLPcIdTuMZ5zPZoQITIyIkUIwO8/IUTBWkuNf+PN7Iex8B46kZPr4tLppjnX4AhJrdS5LMvKP21fFuSTJls2tUKxmtL06YQX4fchxTcOjRvvfJxbEMmgw6JI2Xv1vlmubSIm8Lz8jnGXxel76pprnmZ81GDX3D222dkXgxaAU7tcXkzT929KRzhackZZFFH5MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdrwbwRep3vRu6g6Rt2DUN+i64J9I9xn2IZeEhY+g7E=;
 b=GRsH59PjsTR27FMEDy3hClxLvgK3BbwKzo3yFgjQ3DwuFbEtY/anVh1uGoG+rWbJt8AZCFdmuedyPgIFnbjqSMrxhbTpnvNqR6gvPH1wOI30B9a8v8KvcmxnveovOb/q3Hvv6kcoScMS+Okuaw/SnLGsSsPFjQtGkvTEO7puPFFlUEF/d4XQqUSW/aiRHGuMF24ZTbM8ksZsgAvIvL5Qx5lTsxV2gKJcPPXWxH2vM8kiiAnPZYq1zkG1zmSLv9DD2S41C6FpN8bfAlusWY985hn4IsNkwos8TAGrFs7fbEyjUBdoNBWrGIyyD6h0IcbipUsQyTnAEH0OwiUny3iv1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdrwbwRep3vRu6g6Rt2DUN+i64J9I9xn2IZeEhY+g7E=;
 b=YZfsJhERX3pClo+ezyhbw9GL4imHenW8ZKgXGX0A3U87TkzuWHHf8X0XMHQGdNXIAzFZOD5SFW7lVeOCwmye3yL929TepCKBq9gcrUcuJ8vvJWXdOzZEfaAbCDvxMX4pXS1DL0JCyNEJqW8yeyja/j/zTa5SkNEzvJba7PL9eOQ=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4581.namprd10.prod.outlook.com (2603:10b6:510:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Mon, 19 Jul
 2021 01:19:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 01:19:50 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lyl2019@mail.ustc.edu.cn, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH 1/1] scsi: be2iscsi: fix use after free during IP updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf6314nr.fsf@ca-mkp.ca.oracle.com>
References: <20210701190840.175120-1-michael.christie@oracle.com>
Date:   Sun, 18 Jul 2021 21:19:47 -0400
In-Reply-To: <20210701190840.175120-1-michael.christie@oracle.com> (Mike
        Christie's message of "Thu, 1 Jul 2021 14:08:40 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR2101CA0002.namprd21.prod.outlook.com
 (2603:10b6:805:106::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR2101CA0002.namprd21.prod.outlook.com (2603:10b6:805:106::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.2 via Frontend Transport; Mon, 19 Jul 2021 01:19:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55d50d2f-6c48-4098-6a1e-08d94a534e2f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4581:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB458132A27BB7E7DE92C0F5498EE19@PH0PR10MB4581.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nktGcexD3yD4egD8lWukJlbbrcBj5/gZS1SzDMBp7EGgwUU2Z8+3m14MFyKsYMgmBYHcGyvsjY8PwnN4PuWChW7B+0jMDNaFehQVJkQcwPKWsq8MBLYQ7DKTKsLVKWJLNfI0goTNgjiUl9S1VsSN2PxHODIZMNjOmxuJ/16hTHF6+QV6E3MvOIr0Gax6ekMsipTQ9NdTv+PlvwpLna1UfO4+yF5w50SKygznWW4i4Ru36d/iwTsm+5GrpoOmlpppfSYK05uyQohlXxaCbledEn8tk54w8sp8ERGIjIEYor8dlsJcgg3qEGIXwDKVBzR5H2bUgeVl751y+oH+35Mhiw5SMjOX1aCB7EQw/3bH9hG06ZsI1kC1eQWOXvpzFD+wjSuaix6O7W9/Nbjynth0KWzEyvxqYgAqMYZtDYNbaD8XfdHHx+aGcZTCW1wePddYQ89JOmtgVb2FmwS77DNVmUGcwvvZ9IH2Szt0nrnWi/1oyusp4Wm0X6vTd8AkONzXHRgZpMxk2iqC9cM7J3tbDQCSm1Wc6rmZX8g6chbfQYZ2RiQHTcc/ZeY8jIszM/qvaWwQRndFJsghv7dsxd0WUptnEu0jTJzSADZvn/3AuTVSzl53PtOqpU73DRysMv+JJuknPIyMGysPYn+t7zr2y+BNT4aM5rzngeF0Dwjf5sKBtRNPWyKePAWmvGuJqAKwmlG8LgZvyadFgtj6+CYngg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(4744005)(6862004)(5660300002)(508600001)(316002)(66476007)(36916002)(66556008)(55016002)(8936002)(66946007)(86362001)(8676002)(956004)(26005)(52116002)(7696005)(83380400001)(6636002)(186003)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/0I54F4FPBgVk/DRbNiCB5VVrRO4ICSLZK2ZQJdCRyQ9xms77gjxfZiFnpnJ?=
 =?us-ascii?Q?xuAtrbVXd5G9eDhqZsfnmr1TvIbRu+pYXtFo7AvP+KRUqpmCsYz9tOU/+g9t?=
 =?us-ascii?Q?rZ5iQlg19VJybw0Bg7HsshOesdfmZxcmx9g3q/3BVk4UTpvaeTlDyPySoVHG?=
 =?us-ascii?Q?i2RBSq2g8N4ZiLjGSl0DSZLEJGGX4YEiGBfLBp9DnwaioPKV6YDPBht5u8zu?=
 =?us-ascii?Q?VFDNFoU+pLID1skqFDC8X9OjHElFOOruTJC0MK9niZCC6QhLz8IJ9jHxK7Zx?=
 =?us-ascii?Q?TI9XaaWyChQv2Njy2b8A85uok4UFv+5MtzOGiUGH0EdcbNDjh5USrMdNwxSZ?=
 =?us-ascii?Q?UHAXEiLWxmJMCgtXmytLb/kT9BmP/rar4cLG41SEGXtwoQ+lCd97M0xNGPs/?=
 =?us-ascii?Q?IcjMmUhytu0+VupEr8l7H6B9Zry9ZjS7c5OLAg2ZKR27b8AIGGM4FOnyyTiJ?=
 =?us-ascii?Q?ciYJDY8Y+2/N7vp5vDySuuJlAnWz1jbtGHc3yKZRtoKxt9LKzYnRFmvM1qbE?=
 =?us-ascii?Q?UivIJIi350C0wGsPCPOp5m5vv5KZvaY/wUaq7du5fDDFvKRnFl4FjjCqSZnW?=
 =?us-ascii?Q?4rlR2HrfKm2hyTy6lKYpXGEO6gVn+fMz22GZG7dWLMTGIFvmztl3Av3eDDEs?=
 =?us-ascii?Q?6xFjUjCTPbFiYdQ/15vIZ/BNdnwAf2MUYCgA6l8hWwrHzmlWDlfH0vGisJKT?=
 =?us-ascii?Q?Bv+vENv4Tda5OQp2I8iNRET3xLUxVFcqUMmqF6APsTRIT2eIQIxX4Noo9ZzJ?=
 =?us-ascii?Q?rlNM2xL2h/e93HPzEbQvR0maTaBmjuQLYKAqxPKOp9rQhdsYUfSzvxpdck7j?=
 =?us-ascii?Q?y3Xmg1dY3Cxch1WkwcRnrBlGPNbOOtNXCymBxRisd8+1LM7bh0QqXG90c3dA?=
 =?us-ascii?Q?E4FTXXJdGBE1YR6Msm0yhNzt7rNXOaUmrQcBJSJ7UjeeQ9n6dWLH67WJ4i5I?=
 =?us-ascii?Q?bfiJT33bMvRVL6dC5JsIoQZrZGvBEYTN6HxOrBR5aEBQtLnLt6cYkAimcuSZ?=
 =?us-ascii?Q?JvrfBmtk/pOOGBkK1WhH6g2v81xN3lapecyfiF/bWRzxIzYM2zJ27OfF1ZdE?=
 =?us-ascii?Q?qFvvCi5zUUTh9ZET5t0/ZiGx/MqfVw2IOCXSbDKqo/BTgX3zTnji7Gf/k9cr?=
 =?us-ascii?Q?4HUtvCoeLeEmnB1mpiOdquvJMy8835c5SZHGrm2b5HGQ12phXkrb4WhclbTD?=
 =?us-ascii?Q?0EWpwVbuNfPNUP9dxWGd6GHBLtFs2Mm8Vh0Lhax280NSpQQ+1rzXoSXwPiJ4?=
 =?us-ascii?Q?03I7srNr7qDV9tM1jKTMeezmsG46K4biuLHJYOi99biOdFlgA2pV0nOw1qST?=
 =?us-ascii?Q?J1RQE4mbGHo89PrHutsAtbCY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d50d2f-6c48-4098-6a1e-08d94a534e2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 01:19:50.5769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGQDXSC32zH0VqOqTtLRSZpbk3OVmHfN78SyqVDaqV1qwr420PisgLg5a5CwudRilN6pnM4zLswGIf7HQfQObmq8cpCFulVVT7xrYPWg3Ac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4581
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=795 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190006
X-Proofpoint-ORIG-GUID: dFPQQCGIxCsHy0qkrXXLIOTD8GOEBiiR
X-Proofpoint-GUID: dFPQQCGIxCsHy0qkrXXLIOTD8GOEBiiR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> This fixes a bug found by Lv Yunlong where because
> beiscsi_exec_nemb_cmd frees memory for the be_dma_mem cmd, we can
> access freed memory when beiscsi_if_clr_ip/beiscsi_if_set_ip's call to
> beiscsi_exec_nemb_cmd fails and we access the freed req. This fixes
> the issue by having the caller free the cmd's memory.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
