Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC45C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9591861222
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhFSCcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:32:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57470 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSCcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:32:25 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2BUVR003398;
        Sat, 19 Jun 2021 02:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=1vMyF4ncJ5CxaF81o2OlH8MzHVu4v+51n4CbkX/cqsE=;
 b=0H3clobH026Y/9zyUhGiZO6O+iqOZ8wQ2MMQejbbuw7uk8qS/7s/anncJz29RlrRJ4nN
 GN0X3r92qVA0jTv8ocTsbSzgfC0X4EHN5zSZUdOqsett1vdoRl37PXeKdGPXpE/tPOCh
 rgBn3bGWRfadE1g0ARUwXX8ynqGImZvz5r/wgcwG93QJYURK6Q4KGmfvo2xRHK1KTlLT
 O8cY3ebgTn25fJcBnpH7hM5+1I6Z9wEf3vObqxD7fgeaOvnBYSU5tkOjCqpEHYE70euG
 cJVgYCWZ7QqTWCxPEzSuQ4o+YuYetqXGK237KoJKraRSDpDLxcN9AslH4UoBdWc7ziTt Bw== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg113-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:30:00 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J2Txvv006970;
        Sat, 19 Jun 2021 02:29:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 3996ma1fe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6SbBHa8B2ZgFV6tnf2XPXpcMXS9AMHd1ft/zF73dkyARfbKJpM8kqbZ96ocu5v7QPP7xT54s8vr2mGHSrZIBNzyI94P/5ug7tJrHy1WMecy7BxowmqthjzjtUVaRD1axS6po35rJzzDPok3xGap3cDnGiikPhI3aDV/guGOfO6zv5Lpgr13/+lRtizCfI1PodYUKlrgA99/D+cfkqZTfSUYU8eUYYZ2Tvd7eqLsUH/FSLC23QDrW8qU+rgChUGhn6+heOT1CjgNdAOIZq9jdCNiD4cFZ61Di+/Xc2VGnksPgTG0ZDjy4D931exYdIZSqGrmii7fdsHuXeXppKJg7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vMyF4ncJ5CxaF81o2OlH8MzHVu4v+51n4CbkX/cqsE=;
 b=gQoYmlFx5hxhahf2440blU9ZhelcyS8rR2W+2sdjRwBHvvr+tZXErthBjtd6b458j5kpcJcwa6KUQrfOoLUZ1PhgrpF27PDcmKrd1vkho27huUfgLLIap596ciocBj6jzqLVuEtfBuAKuTvFzXm2qEJz5BYKQDAf7qHUHZAcKRToq0GvYrUe2adX0bqSU7wG0K90zP0kTDiPnFSiSkyytgKfpYd8mQ8z8qG9RU+3+zJ6Rr0Swlw1PHBxvanu7bI2TFALvBfcOFkj355Wus+lloZEC0RqFo9y9/4FGcgWoE91gRdxXAVkjxFnA/RLxKR/dPu7OzDaKhiV6M8wHy7cxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vMyF4ncJ5CxaF81o2OlH8MzHVu4v+51n4CbkX/cqsE=;
 b=icWr2CTjZ/OxQ3G3vKoCoPtRFJjAkvRIyjVkX/Q8fyNzsIILs4MF2GkLd1Ps3rLzheju2htExjxS1lMIIG90NJS1AaiNAdDEUzbwGIrg44z4mTI53AcMwkBSI9fmyTN8VJkOJxVCi+a+rAWfwpASDk4x+FZS9j1eSaxemvGPJg8=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4757.namprd10.prod.outlook.com (2603:10b6:510:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Sat, 19 Jun
 2021 02:29:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:29:57 +0000
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     James Smart <jsmart2021@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] scsi: elx: efct: Fix error handling in
 efct_hw_init()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s36ziw8.fsf@ca-mkp.ca.oracle.com>
References: <20210617024837.1023069-1-weiyongjun1@huawei.com>
Date:   Fri, 18 Jun 2021 22:29:52 -0400
In-Reply-To: <20210617024837.1023069-1-weiyongjun1@huawei.com> (Wei Yongjun's
        message of "Thu, 17 Jun 2021 02:48:37 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:806:6f::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR12CA0003.namprd12.prod.outlook.com (2603:10b6:806:6f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Sat, 19 Jun 2021 02:29:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 283f50ac-46d7-40a3-d0ca-08d932ca20c5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4757:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4757014F3F4842D55A6043858E0C9@PH0PR10MB4757.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sbqdo3OoFqVrOpIy72M7EH4+doAG4pwpPNfw7HNzsK7MDTHwm0eokpXrxBC5JlI1RJQ11FVJVaKdQNB6p+gA8mwxiIaaF6Ys4ShFlbdG2DmAynfFdEAjSXX0UbJFT2cSY4M4Nq/v/yze14tB/U8jVM5RCM1lkUP4s/euKK9rsE4NFQ1WwQaUp1SR2bLrTjuvz6CK4dHHTdPRlqS2VulMUq7taAzDf7rEzyOuYrh/fetqkSLgdxBvAzJZU/kS/xvWX7jG4yzKzxISgRSduzOtD7u3wNWZjWn7yF6quxahI6TBN4aFs/mo+vfenBSEbs4jlQhbWX5WK9Ls4nu/p6Fd01+o+V1TPnwMahSo37gp+6opH/3Is67G/jRBjdXvgcQ9gcGoiP+FLyrH2x3C/XOBRROTpE+8YIGOFYwD4kN2MnnNIt9vP1rwFvpx6AGKWU1v/LbLb1xK+tNu9ShEttkVf8bvSIRzux6MH87j1it7wUVTj2Km7+OPTKvQlA93O7eOpLmDh+B0G0SXEf70fY0X14clbXUSJJ4gV2QdT2howvi6aSF1+NQNESLtROsXqc+XbS2ZjSo++n8+o4yHd9L7peQ8XVxBodUWOUHkkV6FP8yz6h/r1/UGUroN6Ci4cGuiQbS2JF7amz5KEEUmnP1gEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(346002)(376002)(6916009)(558084003)(316002)(38350700002)(8676002)(54906003)(956004)(4326008)(66476007)(66946007)(83380400001)(478600001)(26005)(5660300002)(2906002)(38100700002)(16526019)(186003)(6666004)(55016002)(7416002)(8936002)(66556008)(36916002)(86362001)(7696005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?agaCidX7KkiY1htIdmcZC4e+kzFM/mieXrT+WiUAYmOUGjEVJ5gnMyISNrcc?=
 =?us-ascii?Q?U1f5WShmi9XF0wqhRmJGuhBsTrH0MMbT31IYMjZgBhYu31hSg2FktHLr7TOW?=
 =?us-ascii?Q?WzNfMw9sqXnZU+Fr7ZNil8lfiu4UIDQzD/5ub8UpwiLqbZHlhXHcV4soJCLY?=
 =?us-ascii?Q?qooSUU9kVcs2X7LVcCo5EXl3V34WEeZanoz6lk4t8PoFN7zkurLqhTTSHi/V?=
 =?us-ascii?Q?VPGX6HxMa9vwdfgsFtUCKI1/psJBvqlUMRAifqW6qtvuqAhHcCrdgYmYH2Le?=
 =?us-ascii?Q?i0fjQHucrFwFTs0duMMC0ScjP9YXeot7F9+kJnTOzM7h4tHecny1ffOGKmDJ?=
 =?us-ascii?Q?DmcBwTVUC8PwpX2EHQKxtTdoiZUuGqd1rOHOmw08M0jURQV7GCi6VXz/fEzm?=
 =?us-ascii?Q?OgkBySg0ZQZumOEaArtxF1qlpBrjNXtsuEhsnG7sWylXi7jlw4LVJg3On3KN?=
 =?us-ascii?Q?B5kJWnrWWAy/077FIZgxk3c24EiMcm0vTfiCVkbdSykANd/LGsMpL3ZPj3Dc?=
 =?us-ascii?Q?IIQnZ1rKrB4GRemX3FoiV/v3x5Z6BeyoDMuAbXdbCNQYOzSSBhFTqr8eWBm7?=
 =?us-ascii?Q?WDeZYPv1adOQePRcX4Q285E+0/PhBRM1n+1m+SudMEzX1qxitsqRaYjDQbhd?=
 =?us-ascii?Q?bfMQYsvuaKtmlLhVFsyGCcbKv3bXQfS43Z6GJk+OosI5InZ+pUm+MNwn15zv?=
 =?us-ascii?Q?LjvM+DaW6mnqr2xyHNOml/uqTD7tNPTEaMto9+W3h2nxynqDyef1b7I1C0sG?=
 =?us-ascii?Q?zYeMd9oSdkE0Tkaqr3S9yPAE5t79iv3+q+dJXB59A+TS2bYERVAzjlpaZcyw?=
 =?us-ascii?Q?MUJzL3MCijcqD9nsXLxVinoi/o5Cyi3vM5CAljeyKLL4v1UtkmR8AQ4Y6CMU?=
 =?us-ascii?Q?BEUfy0BM6cWi1cj12Yb2s1j/LLIgIeIgkcRoU2nNAvC9sTxxYOAyKUjZq3R3?=
 =?us-ascii?Q?oEiMS22UZjn84dd3VD7LSXE0b+ZD5TktUUXGhOzKaeQv7h7+ze2tVW/Uw7BP?=
 =?us-ascii?Q?PmRmsNOg5QkfabOIlEQr4GWRKUN9XXVOKB+NzYKrPd883tRUBvTgauBXnhe9?=
 =?us-ascii?Q?GzygiMHjeRrvpadICIXMzi+kB6nBGOGxtwaviJVtxvOsFAnw6Is5zSYLRacg?=
 =?us-ascii?Q?ximQTQt9iShguKJhakRFAqHMUpQ84Xqbd6oDWMSDkb9dWspZpxIKZGtKNnuO?=
 =?us-ascii?Q?fgTm8BE6kzA29HyGZZLMu4pLSECG473X1lFl4Qo6eM1v1OTnSjzaOT/F2CA9?=
 =?us-ascii?Q?gwC0MhD1wiY+DPYD+zQMr8awfBByr1AMoh8d8Lx20D4Fl40+yMOkp0OkLh0/?=
 =?us-ascii?Q?oUspooeYLU5cLtKcqi2zSVQC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283f50ac-46d7-40a3-d0ca-08d932ca20c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:29:56.8136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UaWOjr98ZLJwLFfqeTWUybP4hbQoE1GwiVfDkGDadZfzgeOieJ214bLSL8CItUCtMGP7SXnucEgUCAfJfz4s+5nRL2+/jorcMW81CvsaLDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4757
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190010
X-Proofpoint-GUID: URZWVaVyj0BvYB9xWIEkEldAGVjubx2B
X-Proofpoint-ORIG-GUID: URZWVaVyj0BvYB9xWIEkEldAGVjubx2B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wei,

> Fix to return negative error code -ENOMEM from the error handling case
> instead of 0, also fix typo in error message.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
