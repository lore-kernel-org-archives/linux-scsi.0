Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C0BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94A452313A
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbhAMFeV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:34:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbhAMFeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:34:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5PSCd085292;
        Wed, 13 Jan 2021 05:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DRSaxmIo6b3iFDwGI+FOSB777902W526T5AB8gvJC1s=;
 b=O8I6kl48qONykDGCCW9aAmt9luG4PLdyHyoHMiyL0qBgTUk+5cZTAIrfbcZF6TpNTLRc
 LR07vg44x+OGzcyOLuOh9T28rf+kMihjkeJA1FcCP3FpAkIxs0yB5Z1D9esgsPaN2zZ6
 x4Luc+QdaKXt/qiZHFabEPS4itpKzVzjXzjqRMeeGuY1p9tS3hlSm8FgWIk+mOdAiuNJ
 J9VsOhtugdz3Qp6vzOKoeVRorgoUnolDYolSDMEk3Lfp83S1P7tK14vOTfb1S4hqTnnK
 t4nqTWC1UVlSBnr/1gpEz7duVBk2k0NQKipWDrZw84QNkQXHkA1lJUAwQxkl+roOG+Oo CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 360kvk1hy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:33:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5Odnx136835;
        Wed, 13 Jan 2021 05:33:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 360kejfwhk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:33:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQ4Sx0NGwLg8zd39eLuhDF9uPoz3JtZDl4xIp7biNyk0dkKn4AyCqkEIP7ZKTTAe15QxKjpnD7Y2Nvh4EbBcgbVKoOXqhlhYVIHVyk1qMUNZtfUdQESqzDeMnmn5Iv1IFFERqlHIYP/vRVp2RDKfXNInMjdH+EBpQxSUfNnoxq6W4rMZbqfiiX3nycZxh9MzNKRBmGllvBXimt3qng9gt4SIkBfLJNA8mAT6P+YcZHxRr27Voomgscz8LIkSgScc7ZihWBO+bmiN93vFI1ueYq0B26GenaNKa35D40W+EFiRQE5yOVr84/onVFz6EjjljrcIzFDn6VZhSQr43HQ+cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRSaxmIo6b3iFDwGI+FOSB777902W526T5AB8gvJC1s=;
 b=RIgCVtmHkOjz+5DCgehNI6Bq6WgWkp3cT0NJsnW4euEgeZyXWmcJVOs4ALUKKTpMPvVOG20HXaazR873URp9NWLPvFtPPe4+0v9RcrYb7+tpFODCvH4WrXVpDlC5tyOgX1HxJ/+cqd0PbcKgSKpf/uWakzZD53rnDz4IOUIH0tZ8vgfYxMbFBhdwnPK29g9JHNitzSTfMg5OuXdAbCsX2shuxWgWqJ7HxTbfoQp7pX8shuyEoWixTKxX6qNPLFAf6RnNSTYsV7p6QxW+wNACD8VD4/1WM/BbjPmceb5H3Lj+zp8RKgl95GlIXTBvsgX9oxXaNYYbYy+vzBVIS/H/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRSaxmIo6b3iFDwGI+FOSB777902W526T5AB8gvJC1s=;
 b=twK6tBffgBui0h8aFfbedMhcnei3moQFsf/LFi9O09r0/6hKW7N/37dy4yi1HLdD751z5P1L0lyW3kc6xjStO/o8dwyR4wyA/PFf+dVd8PZE0XEF5b9OmgUcbB/7meuPdkSW15NG+5xNCcIWfittShLwIPe2tlozLWtUcslB/3A=
Authentication-Results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 05:33:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:33:26 +0000
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17doh2yg3.fsf@ca-mkp.ca.oracle.com>
References: <20201225083520.22015-1-dinghao.liu@zju.edu.cn>
Date:   Wed, 13 Jan 2021 00:33:23 -0500
In-Reply-To: <20201225083520.22015-1-dinghao.liu@zju.edu.cn> (Dinghao Liu's
        message of "Fri, 25 Dec 2020 16:35:20 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM3PR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:0:52::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM3PR08CA0016.namprd08.prod.outlook.com (2603:10b6:0:52::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 13 Jan 2021 05:33:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 623fa8e4-4370-4cb0-851f-08d8b784c0b8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB469486EE6B62E38A62D632A38EA90@PH0PR10MB4694.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1i7EmqdR5+9irBYZDgsSP5rNLbC+CZemHrMQ9PWpyenZbbNXog8bIwsxejsqUdLYKMKEF5R7GKzrRAwrAA07TaDvtweM6ymjoaOlQf35KOIsUd56G6HGwk9BEO4FguoHgSS9xBZojevoXEDdIhExnn6xKxn+JGc1cBwCb9rDXRgoWKFxASHNQi4im85JH/PiFCX2nDfpMVMshONQ1ck2O1DmW8kwPloXyhXFzPeH9A3R6keFS5ABQGJB5Ql73+4ctz0h4erqTHi6czTRtZhKPVarfNeHmytV2NL1rynt2vuO/Mqw3zNwdonDHAr+LM6syklmorDsWkLPsSoRfV0gSrUy6YTiHc6XNTq2wq/A31Cfhm2rFVXXTVuclb9rI//N+/6/eWimRwdUkxggO5XZAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39850400004)(55016002)(66556008)(54906003)(66476007)(316002)(66946007)(186003)(8676002)(16526019)(4326008)(86362001)(956004)(5660300002)(6666004)(7696005)(6916009)(52116002)(8936002)(2906002)(36916002)(478600001)(26005)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QCFZMqNED1wqpsKE9kPfEiSyCKqi5YIMhoWS26IQF/x5Wjtv6nqfnn35ZaqL?=
 =?us-ascii?Q?u9HnTrEvR8gDwrOdl2Vi6fvO1jzh9Xo+UCI19tyvhnKqoVK3QgHzfJOLaSUs?=
 =?us-ascii?Q?M1IOHrkMA3mxSQO8cpyTc4OWuOCm2IBvA/NgUaYxN3Mbv2LIJMW3h9E9iDek?=
 =?us-ascii?Q?Ay3Hm8W1bTOSqmBonZcbaPePRmqfsoUnMNb22s0twxs2Cyp9/qBf4O50GCMH?=
 =?us-ascii?Q?wCh3iaBNBq6osRjIl3YpYhnr+uAia/zSp5IGkHkwguwf5goF7TCq0yHLhnpc?=
 =?us-ascii?Q?QiSZlLE8GuF9XpBj7iy6a6sO8IPx77Bm+vEN9Q/zqHK/BnerrzHv9/z1ytK8?=
 =?us-ascii?Q?7PN8Shl1t+kWsCrgG65PkcxPGBzf31IDLwZLQqyWmc+jnpsnXCbYAMqexB9i?=
 =?us-ascii?Q?Rb/cPfAKkUYA561KCLqSD98Sg7825xAjM9G0Qcd7vTFq0mxDt1W3s8pM8Q0n?=
 =?us-ascii?Q?ucVNabdf1ATqTCCik5I+qu+cl5oDekeG5CFiVGCFYi3X0U0h+MN/HOV3BY8M?=
 =?us-ascii?Q?okopRJmOvsBmrUM0g3Pyaf69Kebq+qO5FYZM0Sq5tnRZJ9Dttr6WBBlKe/QY?=
 =?us-ascii?Q?2fN+auEMP+yFlGZWNz4+Iw7W85O3TFWALA4I9D8A1vcLjvjijwYUoUGYXbzU?=
 =?us-ascii?Q?szWpf06f73/BehH9OKXT5mANDn9Q9TBxECzgZuMG12M+xZwtBKJTVXj50AbQ?=
 =?us-ascii?Q?zW7ExI2BpnkxlpO/sWzFnBmH7mS0DH2rxHaaNp7fPxus8FPxL2LMPXIDlP31?=
 =?us-ascii?Q?ogP7Uln+kjkfPMDLae4mkVmIksleIRowkBW0koJg1eVduKIB9o95OQm/ADiD?=
 =?us-ascii?Q?cxz50uYpim9Pd1b3X4iJIWfhKgaqI1UWqqOp3xlxDQQVAFiIOZ5K1Y0VtAdk?=
 =?us-ascii?Q?7pvlVX2H+EIZWS20H4QXDrPNORvhDQwvDMfky26aj0dmaFHGXzb7W+bmR5dV?=
 =?us-ascii?Q?9ojwGYLX1kBoF4AWQifXC/TLnU2Q3sE4kTmCWOxEDunUhOGW0DDdB5aQ7O7W?=
 =?us-ascii?Q?UGQO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:33:26.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 623fa8e4-4370-4cb0-851f-08d8b784c0b8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSMWFq5aGvTPEzw+ryfL8SbK/YOp+9tDR60tTcxsHsdKrV7f1ek5wifV67o3wyyiG0x9fxoZ9FP6MSd6dMOCn+Vm/j5GjtPozGSEO+b5o8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=598 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=772 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dinghao,

> When ioread32() returns 0xFFFFFFFF, we should execute
> cleanup functions like other error handling paths before
> returning.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
