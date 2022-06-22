Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA89C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 01:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347920AbiFVBPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiFVBPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 21:15:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7542E9FA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 18:15:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0Ix5v012251;
        Wed, 22 Jun 2022 01:15:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=WVep93zjMeCL/wFXBUppgVmQkv+bUlyjrbVMplidvMw=;
 b=A9zC51SiaziYmqoEh+tmMvGezuq6s1/7P7fcZ1j1Pnv7kzGOQ0iLBTkTg22fOQmOHi29
 2u5P6pvZThIPE8iqmJrop0afWBokkNNvcofBqZWtmaobdeZWU6yXsjaqPt+xCzYclBUD
 pXyYIqUWp8AyNwE9TK7t+jQFJSJ8V2R5rYplfQT9ycuv9m0Iq1OISu+CNdoRYnqAOY2K
 303ijMS7RsE6ifcCSGck3gF5GSjipWcbPUNKzAKAmHUNSzrXFEVTfpuNniBX7qUT5h9K
 Ssed9knJ3Vh08z8Xkjs1EyNfPpa4vuxuJ50HdYCaQMz1iScuA/ApMffh3AbCjVpyGKXC JQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6asy3ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:15:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M10klN001925;
        Wed, 22 Jun 2022 01:15:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtg5uxv14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:15:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8DMv2uIqe8oeHDaxALolZ79CG4tfpL0IgA863+8QJDd1d6SCNbllzEhxW7z6Ydgu40IqfGAmsWOLZ59VtumF1akZVnD0Z2EhcEXUWC33XeBVS42EwAm96KesNVCC/5nfVR19Qk2jW0WyKTVagP8rXLPzv1KaJPf6ylKhnmjPqBbVm7Gu5K9xt3why1bUadNopBhtxqT1OQ6UCp8tO9zCyGw6qpevdDDofapUFlL6nAsT4IGkbB1toB5woI7jPEEq/D4N8BdB2/d0DVBBLXnZUyxZkwRHdWuDxOkA0pw3VnqwDYFGVulfj2AaOhsrZpIgtIlUWlGmJvrhZqBjdtCDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVep93zjMeCL/wFXBUppgVmQkv+bUlyjrbVMplidvMw=;
 b=YO7OiyxcWqd2ptOPx48COlg8y5FDOedPX4/PtcXCWa+8fGu9wUTEEIbGjez9rEsUGnjJmaxplkXnGAhVs2K7J2tjg3fUmNRBDviSge7BUmhvigxbEQfmz/DHmjlEHKX/+0VXZdOFT+uJx2VNHnCkCdyxQpFd4G1yOJkA/DQL3179B0v9qWsGCnQo4sQOMGyudgJg7UGbmuD2rN65ejmKa9oh6M+0Qudc79g9BYN+v0I5vCZ3AK25xJ6avwpuYOHMBXbGkO6mUN1WThJ+kpSXEJ0pLAqBmFuU91cwSrSyOpm0XXhcVmKs7HEumEjKixFJUtjcmm5KTWkvkcSqKuI0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVep93zjMeCL/wFXBUppgVmQkv+bUlyjrbVMplidvMw=;
 b=bZiaLXF71ewImZV0pR+9dVZeIlfotHqmMA3ZXZvtsw3LqzTv/z86zDTLdaxYl4gnhBpFrvkPoz5WX0eJfyYySxwQy/lb0Naf3+TArvH7Yx9z33XAzYdnSrYrRyHw8S5CrW6bz5FEWHtJueqhJxtwifVUUDsqPqsSCehGsivEmY8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3643.namprd10.prod.outlook.com (2603:10b6:5:157::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Wed, 22 Jun
 2022 01:15:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 01:15:33 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH 0/6] iscsi fixes for 5.19 or 5.20
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfnxjy6v.fsf@ca-mkp.ca.oracle.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
Date:   Tue, 21 Jun 2022 21:15:30 -0400
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com> (Mike
        Christie's message of "Thu, 16 Jun 2022 17:27:32 -0500")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:8:55::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc37e7e1-6975-4c94-e2fa-08da53ecb463
X-MS-TrafficTypeDiagnostic: DM6PR10MB3643:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB364377AE330FD50DE1C6C5D78EB29@DM6PR10MB3643.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP2Y8i1RV6IcO8gpfdJ0RiuSwQL7Zirj0k234kHj4mmn/DLRSuGagIXUaGPstxeRXutI87DPYnI0+yVE3DkRwBfar3AHKYX6xOqGRfuxg/dDRg5zRw9emjJ0IMt+xEFu7ifeKVeXz1qPMHxTTYD42h7nYMq3/Ml3tTkon/fQwUqi88p9mu+fvXzLoE/tBjFyABP8RjRXbJAhYOGEQ60+yiZxM47+Ex225QI+HUy6OCJ1nfJy0hY/TUOm691f7e+KgKYdrH7GULLyqiHiZxE2Wm50VLusEdmmgKU0D03jdZbA/4NvH9oWyz/tCU8sat5MGFtiqfmGFpqlWzu34/ce5W/zq4VUP/VYEatk/hLQFsWYeaC3dCno8zCeE+gO+7vVwpZZRLh0AcyvgoQFdOAlhyR6l9m7Kseme0tvGbqJVkmVDF1rDKGR4KuasBioeMbmhmsPNIEgxr59/zPSD/T5acU/eEDkDPURj3bLi5UZN3C2Cs3qcNXyxfkwzTzspEYk73xvTWthvhlHxFv+ozX3Ls5BiNPuI4UcfdJZJYDhbBHZfQ2QOlAjHYaDWvN+/JAwdB5NM8nI3n3fKfo6QcQEzjsqRqdiTQiPqKTRWOmV3+0w99ftCO4LQYpTVtRiNoDZpO27o/qjMMBypUl+Q30AfxqaOqqtrLO5pbICXGIcl3slI1QmV03JaZa3752t71kJZ+8ugdUxQHn9FxLof6Xl2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39860400002)(136003)(346002)(376002)(36916002)(6506007)(41300700001)(6486002)(52116002)(5660300002)(26005)(6512007)(4744005)(2906002)(8936002)(478600001)(6862004)(4326008)(66556008)(66476007)(186003)(38350700002)(86362001)(66946007)(316002)(38100700002)(8676002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mvoHiZm/sQXaZkLxzykRLt/wHvqSYY8ohZlDQibw8imtg+vSfRvH6uCnbFCV?=
 =?us-ascii?Q?5N/+qUjDOlkKe1NdEKE6Bqkx6YT9t3BHfGdyo0aIjEXXvSLZXyj/sPhg/pm4?=
 =?us-ascii?Q?0Xfrvp6WF3XwUuR2HTqd7Cy+tg9dsVBTeDoKRW4bostfsN1rWnwrvOuFXIlw?=
 =?us-ascii?Q?TDD3J6KbV1ZPxJVZp6egekmbLQqjNBYoJUKQU8NxG/c7R93XdGxdvFkNMVpV?=
 =?us-ascii?Q?SU71/3NpLJDywlnUaFE2jEDZA4F6fnPMmPUiBPaAMf9tRa1m6fwBzIxZgDS0?=
 =?us-ascii?Q?3tVmQtGgmPJhOh3MfVZl8ICn0UOeoQgBODJc+42TEr7xye3144vecliwWnu4?=
 =?us-ascii?Q?udujDAWWp0RIv4z6OGITn/xUT/vGlaFv4Mhs/FGaTMMIxyXe0v+ABxBinRgg?=
 =?us-ascii?Q?/y3Rv33nhaIRA5t1gLs4K+lhX3PLzX0dLB+92TP6dAf3X3A0SXCjP180DHi+?=
 =?us-ascii?Q?qbsuranBQxYECI1J0R1dvTL66qogv1Q0Mn+ux3BFxUEJKvSoBlhzWDOZt96S?=
 =?us-ascii?Q?ao3gnWvNd0qddJ8ZFrUs14fPah5e4ROa6CGVn9IdJOIFaxYmPetYZ9AT5ntV?=
 =?us-ascii?Q?MMkamzDokooQmex8bFbkkVgMv4mb8hYF5rsvxC4rqQUS8ic4xG4vKqQEe6u+?=
 =?us-ascii?Q?Kdl2ga3nQndiT2xf0/RqDfTv3tD5muaF60LZtWCnCti38hdBs+cjPkawiFM4?=
 =?us-ascii?Q?tLy3DqjKu5ekFiqcn403tlFcGHwvNrACJmCq/yW3b90lq9IDEjpb727dEIzU?=
 =?us-ascii?Q?NLCT5E20xsgH1NDBc7OESngtzQNanIZeYXeRGZr2lNXrFt6A42kBx7kNoRRy?=
 =?us-ascii?Q?w6vv6lwDx3wImg64IY844Of+UWkFJPsFxx/SLcFcLuQLUN0VxYbRdGaGRCNk?=
 =?us-ascii?Q?4qbCj3Fv2w9oLUmZf8glbYtYvA8s8kj5OSezCrtx+LmWEiClTVb9A9sp5XFU?=
 =?us-ascii?Q?HmsskTseJ0z0LbpPHSkuXAX1IYLbiQmGpkHrw3DRmgpxtRMypPuZ029xTMUw?=
 =?us-ascii?Q?v/68/U3DbMYrrbV2n4yYs01MQD+cZV3ZqR917fIWFGNJQpP4oiigbOSFJJp/?=
 =?us-ascii?Q?OGvfenYTYbcbR8i9PnmvgwBBfSF9/nB1Gm8UPj78QKqo8XSRTHRTMM2F6R9G?=
 =?us-ascii?Q?QXzR6cPVyjkLIEWM9heaOcbIUM9fnFykIwu3/BuEZjmLp8j+/2Qa4XiS+oJJ?=
 =?us-ascii?Q?SZ3rQJjwNek7gJ1z1SeSceDtqOXskQLDIP7LlUl9oFtL/6OjYVojWsaSbSzn?=
 =?us-ascii?Q?fvkLuO+vFjyqJui7immKY1SgkgdjTDBE+mkyGcAA9Vd27vKTBskg4kq/4ZaU?=
 =?us-ascii?Q?po/fPPq5UmNpU5UybtzCWrja7FCOoJyaStpPHs94gtjq9XJtLUXmq6lin6RR?=
 =?us-ascii?Q?f/IPQ/InsmuPbR/lzD42lgK20UGFRtU3U8eJN7Sr+5diIBwzDpCRqcxC9FCc?=
 =?us-ascii?Q?3jW4Woi9Tu0oWr9x+cxuNR0ZQIB81t8/pt6bX7zLtCv6zK5OfaHr6isfroS3?=
 =?us-ascii?Q?EhaVDX2ZwV3vg/sWboc1S6jDSGey8FCSsw9aZf6SmCh34GR8GKDmuEDATwOf?=
 =?us-ascii?Q?YrT/5TN41QNiZSbG8t7yOsOjSg1EXUYxZyNNymTQ6NAUjyivC9dKJUPvmNpe?=
 =?us-ascii?Q?7+VfUUNOAnhSfs3SlnnbaCz7W2StkzZb9MhXfGE3LZG0h7A2ZU4STWThFPdU?=
 =?us-ascii?Q?tBsjnFTC2zGUpyYC/yAcWnRNez55cjW1aODNmHqAZZhdAH1d+R9/mx2ymX87?=
 =?us-ascii?Q?QER5g0XWu/2U4mtS2CbXxgSit3tuaBE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc37e7e1-6975-4c94-e2fa-08da53ecb463
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 01:15:33.1887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6Zpj5VE96mfj+VTLFEQwwWQclFvqPA4qTAqbD4u4f/ZL9t4GT/0RiJe9QstLya8I59mx2GaIx1rlPVqDKGWgLtBkgPiIaafs7DNrnuF7Ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3643
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-21_11:2022-06-21,2022-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=872 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220004
X-Proofpoint-ORIG-GUID: D0yw65ov_JVxM3MRC7C7Vf8igkMX8Chs
X-Proofpoint-GUID: D0yw65ov_JVxM3MRC7C7Vf8igkMX8Chs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches are some fixes for qla4xxx and qedi. They were built
> over linus's tree, but apply over Martin's staging and queueing branches.
> They do not have conflicts with the other iscsi patches that I've ackd on
> the list, so they can be applied before or after those patches.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
