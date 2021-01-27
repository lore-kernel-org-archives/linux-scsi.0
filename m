Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F6FC43381
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3A5A2070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbhA0Fit (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238762AbhA0E5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:57:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4t952058295;
        Wed, 27 Jan 2021 04:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gBjmzAqh5bkLv0eLChyxQk82TlDIYX+qKopyz+aim6s=;
 b=xYLhAlGvomHtLZQ22Xx3Gbo5X38JDzf9J6uhn3UMHOxR+9f8UU4CJG5SqtviafS8fzsU
 MzshK5JEFjoeFO7huQUOIsjNkDmO0M1sh1lsfuUeHg0fISGKYVKV+m+vShlryiMyz+8u
 yak6nBR2gg7pKW/tXfytPCbHLnraF0+ksfeRFih8/tPD0XV5MRQmW3/myu+4B4vfy3JM
 qICvP4yZzWPRp0CM/WzGClo1tWCKdsFT4J1Juxi5NgwDXSVHtA+O79ANk25Pu9FV+crh
 WwX5+3qznRXf5ut5p1M5d+2+DDdy6J4+Q5EEfS1/19l19ILDC6tMX/Jr24nX8UTWrsvN nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 368brkn3v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:57:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4oXD7100801;
        Wed, 27 Jan 2021 04:57:02 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3020.oracle.com with ESMTP id 368wpyspmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:57:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUvEFJ9TnrNjByLgrHuI3CKmR2oNY7sDqcoZB/jk3Fg+aTg4Kw3aB4sge4bxl76OYBOLN2twAVkO9ge3/L9J6+0qrUa91yGTD2rdm/iuXWLZWdSaxdsMviftobT6yL0os12V3r+jbj5YUga1wBdCDVJwBTSeg8FphsNnYz210CRWTo0/LXwkoFGLzqB7m1EOAxBJOhcUusQQN8l9QxeDbv7I6N8i8D/fIXLlsECquh6WeksBuP+iUxph0S7+M3jdDuiAdb3yvv+rXYoWyPH+QdRTjkzPcbqXeY2o7hdlGzYxJpAkGbbakQXlwQIp7cJk9iLKthPM8zXDZh1CNlAGkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBjmzAqh5bkLv0eLChyxQk82TlDIYX+qKopyz+aim6s=;
 b=nwhj6bxQejkFNizcDghzBN08yAzZZ9P6MlpTIRz2xMl/q6vGiKIwjFePmbtaREIkuHQW9KMpqf4jCfhtt08hR1RFBa7uig7uo7sNq7+DyAVmKcejSWocadUQ8kh5DXW7F/wxyWcJLS4KsuF43+alEIb4Kdv8On2KJ2rKYCsIGjRg5078XGO4lNxoq5cZqfgeZAM6Iyzahk5vs9mJDrC6BqWHC4jc0OMgxR5ui2wrQjNCtCidhxBi9KJh+exOzR9IlLppn+IdQHMnF6AcXn41ABj/eN4OES6OfwGBf8DU+Qbb6pjurKjD0KJKRK4Bu3BpRx0tdQ4bA/PbOzt0o1VqWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBjmzAqh5bkLv0eLChyxQk82TlDIYX+qKopyz+aim6s=;
 b=csMIWN6NonZ9zxZmAxCTYvorZVMLZ3nF7S9tx+X8ZIawB3E6SVcfZ4JXEAb2bfFHoBC1hxQUee7brq8hG04i+4eyQbFqMRDoCLUPHXgbJn1F9LvYt4zT/Uiqdvj9JrG/1LN6tRcJaBg9v1GM3uQoJytkhj+OLlGGripwQ3jF8Sc=
Authentication-Results: interlog.com; dkim=none (message not signed)
 header.d=none;interlog.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:57:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:57:00 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, kashyap.desai@broadcom.com
Subject: Re: [PATCH v15 00/45] sg: add v4 interface
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135ynj8lg.fsf@ca-mkp.ca.oracle.com>
References: <20210125191122.345858-1-dgilbert@interlog.com>
Date:   Tue, 26 Jan 2021 23:56:57 -0500
In-Reply-To: <20210125191122.345858-1-dgilbert@interlog.com> (Douglas
        Gilbert's message of "Mon, 25 Jan 2021 14:10:37 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR04CA0009.namprd04.prod.outlook.com (2603:10b6:610:76::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:56:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47ed41e3-44f5-41f5-f524-08d8c27ffb32
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45845E776F5AA4499AE016898EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ObBUSjJRToTBRl9ZyFbBqzZI5kcdi4eCNOBg4ymPjzO1VRthiitK9j4YghByyEt0NDdjL2HdaGL9lWuukIEBmlk8CFk/s5UEhaOwAakD/abhC5STubVZ7QPYUIv5bOnLUn14fGcn25EBTJL7IhRqBOFwJSjf0YdLz25g+Xs/QeozqFFSXEKMqWG4d0IPueJ1o8RIoKoXffuhPTl4CC9n2WjgxZoE+K37xRIEtDPbWpHYlppDzYFf0AwshwKZWMq9xhsXfBe4GT0Y92+rJkEc0kdaMEXLXJ7i9SBGYZOu9t/9FdYqdaGwyyU4Nem0Zpqwi9oprgK6UMUlDllKuTtC6nycnHrpwUdMgfKDERphTiV1jgeQeYsP5qPkaG+Pw5wOfuPodpf5TkIAMUTzrbEl1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(16526019)(4744005)(26005)(86362001)(186003)(2906002)(6916009)(55016002)(8936002)(5660300002)(4326008)(66556008)(66476007)(52116002)(36916002)(7696005)(478600001)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mGNmbPMiFoa5DL6GNjx8Q45GUwo3O4E+ha5H523aBJiT4MvpMg6/2h1aIJYq?=
 =?us-ascii?Q?EeZRert8cX2RAJNe/VN76cTM7bnjl+dq+fAy7e7CX6x1M8XN7ePjfNNHkm9D?=
 =?us-ascii?Q?A0xCURcWC/KUSWo2iwqsPRDKj0pcO1yxj6Hurd93vpZm0jOJ3qFgWNZL7tcm?=
 =?us-ascii?Q?u4GWGihwEH/E4quXMZVPv2VMqlLN53Tp/ISEH2HLpigrMPQPAYGohX4FxtPP?=
 =?us-ascii?Q?KqFDeSNM+irWyZEXEyLEeac/4fA5VyElXonmP+y+xKpqNZWH9SqX9+WKPk7W?=
 =?us-ascii?Q?9rn+7/ZYmB9cTOWIHArorv6vBH34IZLz9tNe1MNdtoFHaFe6qow0BzZlo64Z?=
 =?us-ascii?Q?mfkfpa5P//V4UZpEMfL091fH1IjQzCFIkKD/0xVoSR5e1SPESjXWLdlbEYIs?=
 =?us-ascii?Q?nyD3vBM1tqZT5OoXWcOUjotq1cCgErl0XZePS9NKtV6SL+S6uLWWx0nhPWL1?=
 =?us-ascii?Q?nSjXUqzSy274VkeDhY5WqU+FcS/pnEEZyKWRMs91H8zx6w87dzYs+4G9/7NY?=
 =?us-ascii?Q?42q9Ep3r36xao8WO33Ly0I8nvkJTf1ML1xGbu5cn+uljiAgF8BAT61h9ZKuc?=
 =?us-ascii?Q?F7YyuygiDwIfcjKHaTk+A6Hv6OM2E92JinvrZN2TP7Zn3fuAf44fGTzSwvof?=
 =?us-ascii?Q?a8Ux25agoM8vWim9mWqVyxK5jNxAn51AoK8cDClMwnXFo61McC0F43GL7Lyk?=
 =?us-ascii?Q?cjlAJ0+mM50gOcEUFMzxsu7X2fVN+pHEhv8Rkx8YYgscQ7aOkxEAsL5f/Uku?=
 =?us-ascii?Q?Jam7pL3EMnENOK1bc7lBLu1wc8HI+outGx5nuv8ZnX3gWr1TahFNibYPxXfs?=
 =?us-ascii?Q?6yVXTSzsdRGaW6mkdF1vw0XlY81SS2E7/HjjbafcjVNP/TbjUp8VfMlzbKxQ?=
 =?us-ascii?Q?pjTNLJdvFqmgpTI83NPcU2dEwAHTA2CpuuSUfCOP0uQFUBeSKSAcyYTxHc+E?=
 =?us-ascii?Q?1BmYAV99mDrXD7CV5BVl55ZESvbtZGtzMZs7GF0xMq6kOsfCxtfxLqmB7xzr?=
 =?us-ascii?Q?uGC4somV+jUa++/aBJnIvAapl2D+pxpCXbAXuSuhm6ZKBnCdf/zMCFOYAwtZ?=
 =?us-ascii?Q?cgw0r2Vn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ed41e3-44f5-41f5-f524-08d8c27ffb32
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:57:00.6241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cxXLVuyl6v+op5Q0QxLgSmmVdmNr9n0HqRNu9NjtRJ3BmXYSFqW4TN3MT3nK/pj6xnR6CGJhQjg2VolKNgOFZrJ3E2HLS8ujpuo4tSvj/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Douglas,

> Changes since v14 (sent to linux-scsi list on 20210124)
>   - two fixes based on report from Dan Carpenter and kernel test
>     robot 
>   - fix Johannes Thumshirn's email address
>   - separate patch issued on fio to add 'hipri' option to its sg
>     engine. Enables fio to test new sg driver blk_poll() support
>
> Changes since v13 (sent to linux-scsi list on 20210113)
>   - fix obscure compile error reported by "kernel test robot
>     <lkp@intel.com>"
>   - harden code around blk_poll() invocation; needed based on
>     fio testing
>   - remove SG_FFD_MMAP_CALLED bit code after Hannes Reinecke pointed
>     out it was redundant

Please send incremental fixes for the patches I already applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
