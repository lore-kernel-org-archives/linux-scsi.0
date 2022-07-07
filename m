Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5685CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbiGGVSD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbiGGVSB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:18:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EF23055F
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 14:18:01 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCTj7026380;
        Thu, 7 Jul 2022 21:18:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Vwx9+FZ2/30xewNuv1NGuY/9Rxhfz15brtCjV/5vTE8=;
 b=eJQpnd3Gb4qpa93VZFw83URagWPjLWaHZBQhxvH7mKFgSthgLGfCxeS10ijOvVtZREZF
 /ZQP96hUtEjy2PYxmHRMAbzMbkjhV5zjAL1eHu9LhguJDBt2LEynfFic/xuZRieELblU
 6defX4kJstWBI4dEkwA30Kaj8JhGvSbh0KCISCOnKDi9m5cQCl9eU6M6rdtiLTGyYMs0
 mV7t6ReJNOlIFhWLpFwDgliU/+GBV3P8smBA1q5m1LahfoyoNl/ZMx3HFOB8upH7OIG0
 9RIfZ/v/hM7rtYQ242g1+p489ahFDvM4mhuAmnhPl1zCH8tmQNFCdlHxGvKIS8kV/mbB uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubypep6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:17:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LBO3p031272;
        Thu, 7 Jul 2022 21:17:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud71gw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:17:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhScwI9NiZehrK2sOthALpXSvd2CymCxTYJg23rFByLI+yrJrDaNLHuwQh0lOQh2Rwsk8cjhrb6vE3p0uhljh70NLUTFlrOJ7+mDjx5cOj9mqijseP24x6whHI6jyy7EfBX/6pTCIqOnqbiJ4dqEWTwdYd7w2QK6uj2C8zY3JOBNV82B/o2yEWIECqFiBlaG+FPpkv4brFbg3DjpkEqBjtFnYFOsUXysTxmoZwJPywtT8NZw8fsVVnlVmjkUDJXcA7eqNToIn233w3K0LdJapyRoQ4s20UwKZ7k9YEiJFuGZpqkkjkgqAtAOydQAYPvdqOkdtW3DP6ZZhWjdHeyQWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vwx9+FZ2/30xewNuv1NGuY/9Rxhfz15brtCjV/5vTE8=;
 b=lIjzBH1zZEGu6ZCuNTPTSF8GOzEhc/aiJ2NSKCmJazntBxfiar9a5lHKxXG0kDAK5Pku0QYCFiqVda+EtGueDJeWTOcaFmN8rGfzOfJyqS6bxiF8be9oHyu3M2jPPCyYTKkRP8LukfKu3xaYNNXY62d/EMLcB7irMUXZwXsSgob0DyZ+xlB0eZQNNOYD6p/zKj7i9xHrirp6ATbTGbCPuYCL5siRaA9ZMgiP6RYxTPE/2xJ8oyWjj8F7K+oNIs4RupAqw1QQJLPLCPZqT2KF+d0f4BM7w44NQN248U7cHMArb4c9eoPhlQGARiKKtoag83s+uTH9sJzmNk95UDNBBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vwx9+FZ2/30xewNuv1NGuY/9Rxhfz15brtCjV/5vTE8=;
 b=rEAxs5Udz23cJ4IMoDxYHUrtsAgg++AWw2rzQeZHf17ls325Hv+a1gv6gzI1wJAu3cZMd1z8qMXgqAJQRN7xxwjY9jWr/MJKDHgil7wQCIeks8NFke/M79n3dnnIGWCsmcMtRZsY1jq+XoC6F+tb29TuUtllMSH2NBIWygFdVRg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB2607.namprd10.prod.outlook.com (2603:10b6:805:4e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Thu, 7 Jul
 2022 21:17:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:17:56 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.5
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7y062rw.fsf@ca-mkp.ca.oracle.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
Date:   Thu, 07 Jul 2022 17:17:52 -0400
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 1 Jul 2022 14:14:13 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d628d02a-59bf-4d98-208f-08da605e28eb
X-MS-TrafficTypeDiagnostic: SN6PR10MB2607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ElDJuh1Z0r9hSHBX46UvWUZnaJ6d7pG0H3asfx/t5HUT2b+gG+VQAgC1hMbQM27vtojzCYn9gsR1R6Jzx5uLfOfTif+T5bSjW/QTpCrVeCbkoA7cosQhwXKfu/hKHIdyyAz7Q5nC/XRBPJhOgRyvs9RwVrsRumhLXJlOcVvQEA3yfeGD40a9IVXdT7DynNDBCcYgA4qfLR52gtq2WYBXHgLd67cf16ZEhLdUIIbbzy9yhsVk3NfD3DYY0Je/MsC+/ysuqtFuVBViZUnDPmRUr3QAj/Ph9kF267F0YlJ7XTSuHFLRNkw/STJ1M1ifUGX4q+iXlX85gYNJrx1iesjtcocrW00QcJ6SW23YVeVkg4vqCmUb9bl5hbjjIieQENc7HJEwniSzXiG8yCcOFA7tDw7rFEibV1oaXh+pgkm6dxc9SwE2L/evXoyqPsGizhIkZT7bjo75jfU/OW5aMRzYLMoimRKfa4YsqVSxu74O0TfXK4ghtNMqg/Qc1Mv4eL371cjsORxzueGcYNLBMt3Yxsgr4V++axIH2XL22TbamTJD9m/MOL3SYzfy1TtIINBlTBmrwwTi5LEV7C7X5uWclQbqK/0FYOYZZucnDMo28GpIMomF/FVPpjbNyc13jtNiGFeunrLGw3sqwzCMAx9coS5+5cH+5OenQ35JKD+za0ics+R5zqxKNN8D4vGi/kLIYxIpHdQ0Akve3MElctSyVcx4y7DpY7Vq9Ag9Ud9tJzyqTgZYHmSMIWiG1Q4Xs5BlERPzymWMN0FL7Dp5BmQ7Zf/3DpEsL7PvRHthPw2CbbECpf2FB6FAeqnyWtJGr5H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(136003)(39860400002)(346002)(186003)(26005)(83380400001)(8676002)(4326008)(66476007)(66946007)(478600001)(66556008)(558084003)(5660300002)(6486002)(86362001)(8936002)(316002)(38350700002)(38100700002)(2906002)(41300700001)(15650500001)(6666004)(52116002)(36916002)(6916009)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6O77B7hPaTZuPBebZalp7asL5OC7HvG9FeOSB2K/TNSyKCB35m6D4gI3YeOV?=
 =?us-ascii?Q?Rft9NWZF3gjvIQoVYKrW51jfHQebEhoDEA2TjdkNjWKzDZ1yIM0u/X5JwPVy?=
 =?us-ascii?Q?oPfpU1Cy66YCbbi4oTbWQDTCKnpNl2hMyTsWDi2TqyRBvz+ygFNjniOfn1yh?=
 =?us-ascii?Q?sEvPzn+XNFTQA4KbPxqrjrl+fn/MUDsEpcgvzRGEEH07YKVuwR8pgDMWan/+?=
 =?us-ascii?Q?EsioJGZrxCZoiODYR3gf4dUG2y9kB4RaaFrk/35rMrtCB6eFlyMpMJK29AAS?=
 =?us-ascii?Q?IzylQpTfFDZcYwtGw8PGEv88aUQZSLmgZzUWDMT37wij3GxuG7rD1x7M7KG0?=
 =?us-ascii?Q?s8dqT2E3mj0f1c/vpcmAEGGcD2JNnZ/hsReVmJv3TnwSVNpj+18cTmErGzsH?=
 =?us-ascii?Q?ILDID6+pxYG0p19JE/ZfpKeb2JgMIF22v0gmuCAfsFEcRFzqHVoJa0cQ6ZEV?=
 =?us-ascii?Q?1xCJ6bPKEu/ziF8RkuTUXFAyJViXVlKCNaFg0v6AzxQLEtVDqVw8CPao+nEz?=
 =?us-ascii?Q?1AJxuYeEtw391eSzUbT/jwNsqoV8QFxADMI4qnv0bgX0ivqpBPqRzuCWVktw?=
 =?us-ascii?Q?Onm2EuM7S2IutIu7T9Afo6KTQfssojnhVSexWVaZdwKWqgrR8K0LI08gQXJ5?=
 =?us-ascii?Q?nVzX2K2W7TOLNlFFl8NivBKCH5u3Joi1FH9eLBsG3CIKIVPB9CwhDs2+/pGv?=
 =?us-ascii?Q?J9aFOKXSSMUZ1ujuHtvPWvy+n1WlyA6SR+P8KG3Ugn3cC70WNNHxriC8yIXo?=
 =?us-ascii?Q?NmT/VYg0g1wl0cLe2QqH/ctLe6eYjwQ+S9lvu8zD8YQtO2ZYEbVRWIuq13E0?=
 =?us-ascii?Q?x7N8dZIA0WgiWV3uLp6lF6QBta724Ges9RH2UtwoWUe+fZVmsuVnNeF2dz0x?=
 =?us-ascii?Q?lxNIe4oweLGBWUYKwr78NzhZ+oT3AG+11xszIG6w6/pSoZGvB8/DMY2qcP/4?=
 =?us-ascii?Q?+OZmt25r3LjvQhM7JUKiHc03Jlxg0/q0boL7f4XUPtge/FJ9IRcmOWzaY/SZ?=
 =?us-ascii?Q?N7Lrps8le8hNQiBZovKysa3VtrX7wXkpBohfJ13o+2Rbd3Pn63XyVVxIF1p0?=
 =?us-ascii?Q?hur0rBZmzCi39t7KYLXhO/hEJRoLbtKb3Ov8C6KIQJPJFkurOWgsoKVbh59Z?=
 =?us-ascii?Q?r4r35GAUye8jQR9Y+hPkQ7hoXbHQ8KJAdcVG4JmnENeFm3kvtndsrbIK3KyC?=
 =?us-ascii?Q?M0Gx/QSLutBgEK85+XARGRIeJZFFJtRJU+56+rgqyoVqZZ8XVAuTdJ9jfohG?=
 =?us-ascii?Q?yz7iesE29CI+cIgEP+I7PvcalPYx9iLom8EsEXoIbDLtpT9TS0QeuZRv5yC5?=
 =?us-ascii?Q?s52S5haZodIoLAWV7xH8F2ujeFMXf8u4W5ac6XU6ELo2YkbBBJHF21OMXDw7?=
 =?us-ascii?Q?OJlKgCC4eCK24hy+N38Cs6+Of5KhVIyx/4Nya3ltd1sQvLG/SddvNL49La5z?=
 =?us-ascii?Q?Rf9ZFNMRQc/xUqbEjD+PojsWAHKlLoL01wHjKqRhY8pLZd1W/IZg9dpfk4ux?=
 =?us-ascii?Q?YzmOlpgSJrHs3mU34+tqbmyi63D5rSoCRmUcQCbdmSm88eLTHAlDHEgO5Jf2?=
 =?us-ascii?Q?qeefKuCincY62zvnieJTUhRR76UU3nvJSSO/unSC0S55UbmKpDY79sXMrmDJ?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d628d02a-59bf-4d98-208f-08da605e28eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:17:55.9630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKHLj0Yd2zyoBhP8AxnM6P8o4qRgBD+1kyTI25c2K5otw/RBa1fqPgKz1q9j+pssboEwEeVj0nd2W8IBCB4kIE9pp8LKXLDa3ayTUkVamv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2607
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=743 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070084
X-Proofpoint-GUID: 1Qao7Z_FA2FpAMHaGs3wOawtoiswLg2p
X-Proofpoint-ORIG-GUID: 1Qao7Z_FA2FpAMHaGs3wOawtoiswLg2p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.2.0.5

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
