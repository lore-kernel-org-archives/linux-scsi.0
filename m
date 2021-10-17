Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9103BC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 03:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C82361164
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 03:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244903AbhJQDKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 23:10:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:10904 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231972AbhJQDKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 23:10:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19H070SB003980;
        Sun, 17 Oct 2021 03:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ksJ5rQPfWMPpZSffuYtNXROoitHl+/jAVFXWG8Exzu8=;
 b=xJCnULqpW+HiX+6sl3CYgEfbPJCZ2FjcDUSulbWax9bCaiPyJtRHwIy/Qwzugnch7tdw
 2do6sM4c41zT2NDTiHubvGjdgBYt15lt5/bnTdwgtSFN0TxgA2+XJIMSJTT/YDxyLl4G
 k1EzT3Lr4W21UAwUav+1/EbdtLowq0kWCv2Z4TeyRxxlNEsNrqdzFRaV07a4nND/QFxw
 uEMQsC0tOwt3dm5EcyGQo0mE7N+iv3DXfM5jcnjSl5WD1BxpyxugM7ybTEVhz56oNSY/
 kmhseSys+90mTK4dRSkBv7MlWs96daczBZrvuMv+Qa6iH2Sp641LYyXzVtcGGy8Sb9wU LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqj6srte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 03:08:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H35MpD091834;
        Sun, 17 Oct 2021 03:08:31 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by userp3030.oracle.com with ESMTP id 3bqkutsc3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 03:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq0UaZxE0lBDmgB+pBDFwx4vMP5KRnDv+9KHeJDq+FrhB2W35jXrX96FD1WdlAVC+akrzYJVkRno/f0nPAJoMurr1e/I9wWm4Ead7muH09yjZihVL56QfDxJhHn2d4azsSQxXYzbnhejTqBhMy39A8dlgcSoTd3Tf42HpzjKx7RHKLLAsuxly5w8vbDhIjVfinvz9ASX2O8Xh4+XyZvqMO3tgx1n2Av8mm3K/lyJhWJ9h9N9qGMsGkDZLh2zgkhzmfknwCW9ZNEgSvhjw5ufRLz1q0yuu9LSVhIwIEy9G9A+Va2zfBUDklsw1ZCifkXxNT2/e+BkPcSvC2CKFF8rFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ksJ5rQPfWMPpZSffuYtNXROoitHl+/jAVFXWG8Exzu8=;
 b=kZCnMYGEE6fgA31wAEWJS4gUC4NjXglIAg/tmCvPLZHYaMd1Va330/qmJ+7zocgax2nc2DPL7T2YCeE84gypM+OEVptj8EAETUreZ99yJvrSqga3h+c9z2D8NK4+Nr2hgQJOZ7wAtbWo0hgr1xigAiTLmdtbKHS1kqE6Cra4xGAsxo9hfZGMm8NoHcnUlNnRBOvEmFmXq3ESvR7Gp3Uk55n7Rb373HN+ILw675QkmLRHtvpfjiLSJt61IMc3TRvkQKZmuaGT0/Y/P9G226J7JJdqAiPY09/PHcmDeFjEAtGepY47F2UvcjCd0EX+DjvJy2K9NnD41Yy/9GN0TGr3vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ksJ5rQPfWMPpZSffuYtNXROoitHl+/jAVFXWG8Exzu8=;
 b=KvscxuB8CGxvfxucjAvypvIO/ElKK7REqw/L9fE0LTe16h7W/2vlCrJavHi8uW95/Y0c+MUz9kTwrlHiOnNVA4hx1icfnVu9KzcHSVSHWYPz6DtwxCkKJPADZfrTIBb1785C/+9/wInXO1uaopDsQfMyrHGVl4Hfd6YTQAHb/aQ=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 03:08:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 03:08:29 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] target: fixes and perf improvements
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuhge4bg.fsf@ca-mkp.ca.oracle.com>
References: <20210930020422.92578-1-michael.christie@oracle.com>
Date:   Sat, 16 Oct 2021 23:08:26 -0400
In-Reply-To: <20210930020422.92578-1-michael.christie@oracle.com> (Mike
        Christie's message of "Wed, 29 Sep 2021 21:04:17 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:254::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by BY3PR05CA0016.namprd05.prod.outlook.com (2603:10b6:a03:254::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Sun, 17 Oct 2021 03:08:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a11d70c-c675-4ca2-7fd5-08d9911b64c3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB461554CE2BB791ED286E4C408EBB9@PH0PR10MB4615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9C/TPsd29e9H6AB2cSKste544RqRM3SrOBm4lH2DYbZ8mo2cBKyVKj5UESZoEAdQJ1iMihT4Os49dLnM5unuCKE8V0XTj5UaVpSVnbC5N92zYcM+eOzxh6r589m1xRmx67K6pI2P4Hn/ykGmEBwJ/V6+HfeXvEcyjdcOHMneNFQfmZRmLX8S5mXZCHabQnu/SCCupRllwr84zAVcHKe7QercEtaD7nfZIC1rNduLqNHBfYfE1pNSsn/u7lOBSCqNzo6I68k1FRBSJwoCEAoA5olmQOHWQ011a2Ci2k8lyDbDLv8up9DOjVrQCVin6BS5Xmxp0NaZtEBZ+KoS0vGzL8rDJxKIWb4CA6ykgYgiTgYvFoM+iCiBVIcOnhaO6/Qdl58mCAMwe33emBnX83x8xXvr/UJYbBJO0JQfzK+S+1UA7X1OJqCeBxMtC+0A4z8Xd2iMhwb7bZyqazenIl2RX/K0s6a4pjxc2awMSejgS9oef1fZF7ryLMNVzlhJLm1jz3g2Pi8B3JSf5WZhv1Xz+k9I09UIagN1nzdA+lPqFbhwyZvMaADKeZRUF0xinoiovbIv8xhdwXnHQVrc2NJaSem2VL15Y7+4ottbhrv5nhLuQFrrdoqV49GWxo2DvBL7cYKW4vgqWYNHZcVjuoTNkLWQ2EEKlbuhn6pxrWBX+/X8UoIbfsJGO3WO1G8ZVtdQ9IBzWxBPEZvqiHs7w7aNrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(558084003)(186003)(6862004)(2906002)(6636002)(26005)(55016002)(5660300002)(38350700002)(38100700002)(8676002)(8936002)(66556008)(316002)(508600001)(52116002)(4326008)(86362001)(66476007)(956004)(36916002)(66946007)(7696005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fdrQvfPxtQfUsTl1Icx7HHrxAqHMQbd2TPTKVKv5k1C6tRRP2775L6avHdkL?=
 =?us-ascii?Q?lFL9TveeAYxlwspCyign1M6Mr0VGYkM8PtI0810lwy/70yfXZKF+5z0e/mHO?=
 =?us-ascii?Q?4qtgFQD6Vm9ar2RajGXv5BSwOVyOJzLKM9oRWCKgWYUK9ASZI3m2XStHhP42?=
 =?us-ascii?Q?3T8SBwZxDo9jVVufhoUcog3ZktOzhRbVvKqOMOq5nntgtNcEaHrdQS7O1+bl?=
 =?us-ascii?Q?IWdt8sOP6u2ENqRl9fds+F4PbTkY5B3/MwuVxu0Uulh+InK4AGZWgi6Pfpuy?=
 =?us-ascii?Q?AhyDQ6l/0jox8yIsDMaK1RZIBdIFRGstVQdNOo/X+Rl9MgVo5Abw8Vk6LJIu?=
 =?us-ascii?Q?AyDe0j+pJjN1sO/9eX5E9RjerZcpVRYarFFs5rPvY2IkR3qac2RwioLFxuwb?=
 =?us-ascii?Q?uywFkprMGYD7iP/iyKSH+XdUaF/mbrMJuhQEcP5Ro5T5n3QpS5ge63b9o98i?=
 =?us-ascii?Q?uSEBBjQibtwicA7zn81lHsVviLXnIQbxzrUeR52HjqjypJfv6Hp7NgSrJ2Ne?=
 =?us-ascii?Q?bDg987cALLcDHMYEyrFHUzWFD+j7mPhPGE2Tg9M/ptyUUnJo5KkGzKrHtKHc?=
 =?us-ascii?Q?r8MOSwCbBPGZhOKpF9j1+2G9h/PyGH5dcTFHonlVhzjy8l6ZvON522ByHRVo?=
 =?us-ascii?Q?PVCBeSRGDa+AKzLpf8GGitucVSwPf+N6djrHsL0u+IVIfRuD5FnNgOhXZ3h6?=
 =?us-ascii?Q?kkppdAJMC8/YBODG7Z2JmyCP83oyEE+6gLnaCtL1zmjk7wKoWV7Bw+giGX3f?=
 =?us-ascii?Q?3RfIOvIChOV4Ylsj4O3uvms56loRI3MayMjx31cX5ibcNICDuUKZP766VHYP?=
 =?us-ascii?Q?l+QNUgzObNmIyfAQLFHNLyo7ozK8twA6N+9MyLT5DhOAfaFH4rdTwREMxE8N?=
 =?us-ascii?Q?RZbRUQjNw10+q++z4acNEdegL+vkbqvm4XDY9gV8kgkcsRIySkplWiJQRBPv?=
 =?us-ascii?Q?bDZkSf0ugvZViMX9CHqHhmwUVXsuDvveBWtpRKBt/nPAr0MFtJfLx+6v4JII?=
 =?us-ascii?Q?41cBUmKP2Vgk2O0PHjqIfn1lTiKFLvrVUqqk9jcFbwKQccAqyb9/nOBHo3N+?=
 =?us-ascii?Q?8n3Lx2+nmFHP+RdPHqp2Nn6SK2tjW7tA1hB1p7OrIMMrCQwVKOxguuLhIrz2?=
 =?us-ascii?Q?6jxkOYH6E2RSs+kv316aSJAXTy7snH/5oiI1fKOiIbzYM24tvuucSw6m8UlU?=
 =?us-ascii?Q?dF31i6f/DJwa7lb4FYIreC9pDU0MUXYvqGKtxQhTLgnkNnV7O0tT7nv6ntW2?=
 =?us-ascii?Q?YiLL8Odwr4PPwH788Yw2PD7mOuKZFPyIZXcXnMvORXZhg7OABocFq/1Z5NW0?=
 =?us-ascii?Q?hbV+n6CXx2SttE8VU/+A34Et?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a11d70c-c675-4ca2-7fd5-08d9911b64c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 03:08:29.1578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nj+k9zMKmK3nguF7kPjZm+Xn1dMmqyX5qzq31ed+dsG9bb0YIKpKJj+ea0Egg04E5h3pP0YqIgm47c2tX50W6EGIBDjyDAb95Lis5DH54z0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110170021
X-Proofpoint-GUID: DsZBfmnytHWvTmcWMIacdD7a4t3xekcS
X-Proofpoint-ORIG-GUID: DsZBfmnytHWvTmcWMIacdD7a4t3xekcS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches apply to Martin's staging tree or Linus's tree.
> The patches main goal is to take the locks out of the main IO path but
> for the case of ordered cmds they also fix a handfull of bugs.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
