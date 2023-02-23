Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3C3C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 00:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjBWAUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 19:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBWAUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 19:20:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B882069C;
        Wed, 22 Feb 2023 16:20:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31N06HsJ014640;
        Thu, 23 Feb 2023 00:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=tqVyYg4OEvRXRA3VmR7VD6Dt3XXiX8YTF7AbWVE8EGw=;
 b=vrjHywdkgLFijZK1WnfV0mhPGMSc5zs3TajzUXjx/+13DNyyPG+1Tcs51QbsCzrtcIhK
 jTcEDgv2iAFGfRmKAoXtQEV9usXCwJ0X6OjhxWUsenPKPGN/UCkHDtepMlh0fW/H9ghf
 4Fjv29QQdzoi1Kp8lqMT/SiLvVCqN7O/mI6Fh2GuGMRWPrPNPs0+dElNfKsvPDAI2Xiq
 P3oAtwUFYJqMIZ137aj6MzWy0g0pLBJuRSTgtJx0zpel5uwvRgNhGx3b0dofGw2Gxr1c
 YobDigJ0fJRvVfDZkk4jOl3ZSdQzFZSbNlFY7MzV/QaRtfvoJqFBapVCLAMZfy6xD++J Hw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn3dsbwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MMqpsU023257;
        Thu, 23 Feb 2023 00:20:01 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn47cj97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 00:20:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dL/rpAqQHIM7sHFwKib1VT3JjfMtAkCB2a40MPnwlvJuJwW9oId4Wvaby2r5JeLqAJznLtsq/7G0UP3Q3MVwzeeYi0B7uFkI4gMi4PeNADDnk7cKn1MVz5lvVZ+DPhr8OiAYQfZdLhsiSCdAEwKWvwnW84pW8WuiUI7uGqRaCwvKXfmvRc/E1qHH3nolQP185gU9KlgQx/nRZ+QGlOfsAbRSx3PdLaDJs/EGKWGi+jN3aMRLrj5t74adBaW06ebKZpTrF5YbbkA1e5dt0KJFDviu8hxiGc6cKHlOhvEPnk8hLCb0kXsf4B7qhgLDkwY4zSMhAoKl7vwcwE2b2R6ijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqVyYg4OEvRXRA3VmR7VD6Dt3XXiX8YTF7AbWVE8EGw=;
 b=XawitOIVHsRy7KNVrHs0RlYrMDzhIL6jk/5T+fBz1dmPXcOB5ouJy64Zlo+gf6Qe0vhtLPymINZfZ43NexSDaXuqNjpRjB4nJkCF/rqXmLvpbaSOhwMb+HkXb7AFWWnnYb686sZtQG2wzpMvV/NMi2fZjeIyDhzZayitN7fQs+NGaShUnXdPN2jhsy9TzHNcpDYk87Z6fs9YZHAl8rNdXJtSwjWE9hUR81KvRgKFpDpQTv7w/PhDAsxGp45dMqLdVDTRSzVKIkk9dLuFzIxRuv5JSP42fhWfvlGNYaYtBstqemPqqZh1AC9tDn/4bTo4mNHg8IqBUhtp58i1L3ANRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqVyYg4OEvRXRA3VmR7VD6Dt3XXiX8YTF7AbWVE8EGw=;
 b=EJ9WQenCDVSymFsay/Sly+sJTsPDWH8T7VMZ7aRtdgu3H+EaFsumst1j5XY41jQXXwo1azqfaeaRehdm9sXY/orcbJuUlf+aNjUyJadE8JSKzyqMvpMvX6HnKB+S7/AKSfpvgu2hXtkwtGLrv7OEQIInRm8Mu1fnkCAfzucO4g8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5286.namprd10.prod.outlook.com (2603:10b6:408:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.6; Thu, 23 Feb
 2023 00:19:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 00:19:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH 0/5] vhost-scsi: Fix management operation hangs
Date:   Wed, 22 Feb 2023 18:19:44 -0600
Message-Id: <20230223001949.2884-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:5:120::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: bf0bdae5-aea4-4b22-ba40-08db1533b284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0rPdoKP9M7o/d9BbUW7lNHaTAMpLZYOoZYVKFjTWCjKBc60bJYAqPmYmRevBzYw5An2Xtma/sElnCdgHUKD3oVznhVPjULTSBbpiubB2U0U4oIW+7ZZgkMQvjyCkP+poKcWtd9JhJp/1C1scU6/IxOoiHxBgjoy0urQ9PKmkms3D66dZmAyckCuGyyD87bKYsFxdZg/854etUUNYMpVwIxhxkV75ekx8HZqNLvBblETZleJWof7NXxC1xGDARR/mIZBPXskxCJqaz7myno7nQbeN6z+67YOBxioeDKByrtf1IVbk4B7522/p/cAPp7rCRP8a8Rmn98RO8bilZ+CJVXmxlJ6Mf5/ZqSYUEYsz2jSByc/y1Z2zpFh4HVdwHszXWJhnw3QCTQ+ACt0Pg/Gx7HOCmhMN8mPi3BeorT6W9+leYO/Uq00nDWbKmZLG98Sp9Hp40X4fDzhaGABpiq/fmVbxvRnEB91KjUebCAtYRMe52xu3p8JXuLJT4t5gSBPI+DxvUpLwArbc0kXuYFwDZszikgzv08eQ3e493MYbV7Rm9g69irJOZVrGC88JDJaxpLCkDK45wIaUNASQ3zM32EyS3hpFRJpRm7XgWdQxX1Y6gbAdAAXp/1LsLMGuSWhwQ1E34yPHPwT6Dzqf8EanA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199018)(5660300002)(38100700002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(2616005)(26005)(186003)(1076003)(6506007)(6666004)(6512007)(4744005)(2906002)(83380400001)(478600001)(36756003)(6486002)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LArze2Dsa2HD85rSLnfg830EZ11foek7AO2ZKgJjTDhRPJcLr/Tdb/wuSLlz?=
 =?us-ascii?Q?l4e5cJWpdBicFIIkySIoExgTNDIAbXsFJDjPMZiOfbR3uU1OHs9eWYQlNchv?=
 =?us-ascii?Q?SFIGqgXBZis6IBE7aCjPO/JzeU0TTDLjzeeiqNDgy/pyDD6IDZ0v9GeehspB?=
 =?us-ascii?Q?+6kswWGeX0ftAMZYNggQPLoKvDhGXoXT2G189WsoI4uEy3Ku+PKsDwupEguh?=
 =?us-ascii?Q?CHbBFRszYp0VU66dR3on267w7gsRw4jAYes1f7CdsQ4XqgHJhoRiyYubcnAf?=
 =?us-ascii?Q?islsC5GlS/boFV5vyc7Ga/uMhyx+c8sXX+KPyWH2ZOGRJv5bpuKaeObyK4R2?=
 =?us-ascii?Q?BfoYJQkDhpUCNdGm/osjdZ3FyBzG8YflsROIfY42JGqDRZAUbQ+rWaJy138c?=
 =?us-ascii?Q?gpzKPuu93V7C60yOcZHlNwD5Oq6zeLeZ+immzJpd6uwkPuKaQbf3XW8QGw2e?=
 =?us-ascii?Q?pi947lavMtIx15PJWLYIEO2OWJxZuEzyDIPHdF0dgAwVWBgHdcj9fY/XryvB?=
 =?us-ascii?Q?GcUjQxSINe6PUHG+ipAP9z/RHKokTfNmQEpek8UhaxPas2gM4/PAaj4vwsXi?=
 =?us-ascii?Q?E+zRSA3ZCWdKdgTcCOOwKi14iH+41w/HenzDyg6kqC5eqySfw+Ki396PJ5aZ?=
 =?us-ascii?Q?TkxgwmZTXggBRH+gHYogc4QAY78EjQT03xUs1+5PYWlK43P/SsgKoUgXb4SG?=
 =?us-ascii?Q?BHcUWNwZTYJhMc9Hb8UXLHB7mpJFKC8RM65W9j/wUpKkWdZraWmvcdTJDPUd?=
 =?us-ascii?Q?/8CQK+rLWXMnC0dQxVvk1B1uSOBnFE5YlSKUwqdb6+jhnNLRMR2CrrFbYNk1?=
 =?us-ascii?Q?AuQAW+DThmCHoouYmA0xCWfRXdNIyu133FpZFm6WLFc8jAYlRhPiAMkQYkUX?=
 =?us-ascii?Q?tCDivGMT5F10zlg7jS1PeNBq0D58F1Mog472KETkYx/h88aEN7eSAdUtBqbd?=
 =?us-ascii?Q?pvuZeroUS0azTr+p0t8i+8TLcQZv4jY83iKOcdY+Sznr02XBaRu2u3RBrhYY?=
 =?us-ascii?Q?6GXhqGCM8mQ8JhsfoiuLW67vg1xuU4vgOGArkUbqFVyPXXb/hrEodhSno4N4?=
 =?us-ascii?Q?Hy4gDnxFcJhyl7Oqkuvw91B91RshDyRWiOSDJEqP7z65u8iQl+NCa/oovqwU?=
 =?us-ascii?Q?mnziRCc6QU/1Tm+yqOyPWVLsBp3IC61dx0g+yt2zE/YxcQvSDncNThK3M+iX?=
 =?us-ascii?Q?q9jjWlzolZgON+UEDCXYrCLNGoBZeZcWGE5Uap2SbtYbSv1bZroLOnZS2+pR?=
 =?us-ascii?Q?lydrtbEZUqpTim+O0S4nZm/KGaSjqajMg/4q4bNcdC82RfNyP6E6uexQDzMd?=
 =?us-ascii?Q?zTvGmY64ll8ebVUsF9gvDT7OyJguAlku4YhpuHuA713hEpwm+rE5IXZknkcu?=
 =?us-ascii?Q?9OnwANwb1V20KVxNRNdsSiQFU6BPf56g4yBhKNbusymH7G95/v7YtxPKyDlY?=
 =?us-ascii?Q?CfHk91GsxHnTw2N8Q3mg5NYxmdbReXuWIwvpV2J67GeWYAmfDHb70HFp40mg?=
 =?us-ascii?Q?VS8q2JTru2FNGDkhNTcBRyIbWJqesjGSG6YG+zJqR9KYMvtRjhGemoC8Tvfj?=
 =?us-ascii?Q?x2Sj8WBbmlVWCv5geJE+cgHWFQbNnR/Eht1AfYq4lU53E9ybz2jcn1RvXC0o?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pqA94jowf3hc5rDSQHi56mzYq8bt1e6SxXlR0JvL91Pug+5TLt2eUFlxWcyKqpL1zqeg1kXBabBpg3XVjnvNd8fmM50GOJvW7uBjG1L9GiZsC3Fwim5U3QvWXHApEHjylj1Ydmkxq8tJOurtis2Naum5TxXgOqSB8LTktCoONnccg2C5vHz06MEXpV6TgDkH/Wvhnyfx2nj4a32AbeOZAAuy9X1S9OtFSnjnKOb+J7EqCBd6ul4Ks3B05T2EET1S8Kh8SIprc/tAHFMp+VSgo/+vk/7gjJ6AaREzUxtJKhJsdkOs6VY81hoAPx0WMHID8HTOmMYWzg6uv02kCiRoNZzqeZuIbdBLUAlh+hG2zhNmGrJBtQtAlIOATAr6RBOvENBjrN5RO3IBBZLhGUKe8BjBd1YBPJMY8/bdjzXAqOVjc67fJF48SlidcQ7cKLTg3a/DTOdY3UB/6FRSJbX5qWKMyFiKvBxUVhkgcgsejOORVhilbR+EfsYT9864kp0MvnNqN8AqzdNBCUhnkIvGx1eIOiaHgpGYUp4W6IwS7AwiQkaIKArJGBFna+3Aets+3RPPFTCLIwMkNBfsjWteXeW+9EkmOMMp+zlinLD8a0xTy5TUCZTEE3UGzaq3q/f4fCTIabWqDVg1TButSVNz4RSHP43aU9O3RPluQryBNa2bHOhkCvz4QR3BuVpZqeo/1UtT0V0k+UqAbCmRyAjZ0LwgXFoOQqAtdn4mKbU8/CLRz48up3FjJTAEgX0SZ47siadZlgiPqMc/5YgFW8ehYfxoMkMcVjOAhvU4tmMScZmc+uN8VOlS9BZBMN4DJNL9kNW0d9RNCC6/gpXjugighdtrc8wCD9VsKGjFlIcWUrI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0bdae5-aea4-4b22-ba40-08db1533b284
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 00:19:58.7021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vP1l9MBgWTnBgOx64pG29TEQI3/0vtc5DJq1Qz7Xg6/SHiRsdbpeWgQxMUhRWNpLEVFp00NGakNFYYsHJIr5CG2xvjfU+6iGHHFpE6yseOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_11,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=990 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230001
X-Proofpoint-GUID: A7ztthnPy8ZL8BqCw-6ElCluiXqyqEPh
X-Proofpoint-ORIG-GUID: A7ztthnPy8ZL8BqCw-6ElCluiXqyqEPh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus tree and also apply over
mst tree's vhost branch. The patches fix an issue where management
operations like LUN mapping/unmapping and device addition hang for 30
seconds or up to N minutes depending on the device.

The problem is that we use a global mutex to protect the list of tpgs
but we hold that mutex during those management operations. So if you
are just trying to add another device, it will have to wait on another
device if we are in the middle of clearing it's endpoint and it's
waiting on hung IO.

This patchset fixes up the ordering of how we flush IO and release
refcounts so we don't need to always hold the mutex.



