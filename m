Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A838C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353972AbiBKWOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:14:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345839AbiBKWOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:14:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8B3D42
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:14:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BJc2e3011225;
        Fri, 11 Feb 2022 22:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=C3dEZyRlQx52e2ZmW7yF18vKFK8pSpDzXYjN6gM19jU=;
 b=RnOwkXGCRLu5nwfZZdl3P1uUBfNZdUx7KL8ZFsOfSS2pHDiCn9+0RStq6pT0Jaw2I2AY
 HTzpm3t42U17fWv7GvuXtjFw3M6RGC8P7wCql/xg6ggM43xAMozeKEde0w/ayRqGysX5
 iD046KnxDC0OO+6w4lnbpbHlx+tSk39vQpU+60cKOjj4Ixi/40mBbWtcIuy9CoZLk3VX
 Hu5N1hapr/j6+a2yCS2Gy2bdCRnykUVepaYhXLbJLu0pvEAFZnbxi40QDVLsEOZD5fN7
 s714BQWuCtEGodJRtsuXvpzWPNnBTnGA/54zwZCTtjvRdiQVesC2UojpfdX/EVgByJ9C CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5njr1nef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 22:14:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BM5oan126213;
        Fri, 11 Feb 2022 22:14:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3020.oracle.com with ESMTP id 3e1h2d3ym0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 22:14:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsqdrUJGIZiGqiBvZgUmeMdOkCftSAap4OHMkfhsSI0bUpPmn1oC/wy1VIOIDuaV/OeHPspO1N+T4bmCsufU3/WoQc/og69kiQH3MkJG8Xhqu7sM3exKF2vKqMKpF5gxodgwEeExOxBj4kN4kYC+POowpAazZ2FD4AZq5f55qWxmtPJyWguqG25kSWgIdzI2G7etfYReBMFLvvi5/mtH/pQNSylF/lTwpba53jmhmfnO4chn8XuWTs8hL/De2FFSV8dTxJpV60enunQJt4Df3P8tUwulUIAt1ZE3sqJNS3qbFm3o5AWPj2N3XWyRdZ/05Ehbuh19vIEJyGBrNTLGOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3dEZyRlQx52e2ZmW7yF18vKFK8pSpDzXYjN6gM19jU=;
 b=bXochsQZBOSJKrBGwEbSG6xhT3PO0/jV3/HmUuaQV2GocpxO33uKlNXGlz3+LByPQ9UCy0O60MvQ70EzQST4LDCxMgUtxiMtAbuY69djIvKUKL7CHaluEDWjxFlMmjdyYCSZj0ZLU1y2xXp7JEMLY/dQu53m0g2entu2i7V9JTc1s4MvLBh/Uknf4PqEpWE5J7lmNvgFGPtJcHSrFIZVoFL4e7wIoac5Eb9u/1PgS9ICFngf7LcO0WjQIyR2zsJwnZDyDFJ3HJEOkW8Khnkai66evanZMd5cApirmi6tIj4psjeMV4BqKE9/Rm5Mx+do03GuFp/m5tKEOrimtsVY5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3dEZyRlQx52e2ZmW7yF18vKFK8pSpDzXYjN6gM19jU=;
 b=NSfjl1NdjnaYCPsVCmno4FDdf3pDcR0IFKldWj2NPcmBIIOXpny3zm8ypGERf6Atuntg0hLwD3GwsoUzSJDzJpWlyNhTNVcRs2QMAlf/klcckdB50XBo1PPm2nWmMMA4LjUrEubBUSns1Y1gf+IJiFzq+xws/PHtHqZjyzQU888=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BL0PR10MB2897.namprd10.prod.outlook.com (2603:10b6:208:7e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 22:14:11 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%5]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 22:14:11 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>
Subject: Re: [PATCH 0/4] Some small cleanups for scsi/libsas
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18ruhoxuj.fsf@ca-mkp.ca.oracle.com>
References: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Fri, 11 Feb 2022 17:14:08 -0500
In-Reply-To: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Fri, 11 Feb 2022 14:42:54 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::13) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6610af24-0b1a-4a54-b58c-08d9edabd48f
X-MS-TrafficTypeDiagnostic: BL0PR10MB2897:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2897A0F5794411DB35DB00768E309@BL0PR10MB2897.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjR/kxodvDTdpuRAqDov0uFm3cyNJsYQEHPkG9d6bR333eM9E2ZFwwqVxqip46IRdBMM6UQe7waHNufFR+4T7go1qd76SpVIIDXWitX7jQPbfMS/GZuL0B0sw0BTg2MpZBrTe2ujIcOGNd0KfCB30Zq9qnczzJH0R2DQ3Y3D5O5KKhE0TN1kUXJnOLuIIr6JHNNWzT/rsDGpjP/9L1ESTdQ92n5abWsFvQsfdFcy/dzXiVCqwl83g5xJd86gRE9n0yhCoNBJB3Us+WvmWOp/ZCVGOI6DX73sbd5wiee6tdakiC230J9G8MJ26PcA48ueO0gEIno2MnzmDGiaweYkbCY36eFV52jZkzzWQR8cJX8s3POo/ce59yl2Y5tR/vj13Mwu/POu2JPM1YHMA4hXv6X7BGdy8pjJgFJTZ5lmk9PIFnhmG5zekCQnJN2KXHmzS8nkk/+MrBJRB8JL7ny1UP2OxKo1q4Tmlw4gQhBftSzmKol1dfArHh4caA3mx2HSI6isjN3Nx/IJeEikHXzVS8y41V/J9TuH5xhrV55FE1r8GcoWC097BKS9xx9dd2R5c2CfKVbgqdxoVTzpY9rADMDF/ZdXjhemvIhCq0ZNiS/X5EJB8ruNp86wi5yRiu7XtC2eWXGxijgg+4AeQ94YAHxIpUeRBxvqiv7TfEu0UNFATJf13+uGYXgpQ32Luk1ftaD/3yB0SYbZ3stes1whlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6486002)(5660300002)(4326008)(8676002)(66946007)(66476007)(6506007)(186003)(66556008)(26005)(4744005)(86362001)(52116002)(36916002)(6916009)(38100700002)(38350700002)(6666004)(54906003)(508600001)(316002)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hk9ZdS++d5k7dECraGP1e0l1gdfvzAqAf54b0IjJMXMnRA4OB+Pu5QuCMm5E?=
 =?us-ascii?Q?z0Y2JObxTTZfkTFv4T/9ntnhbqCNlUuHC4yjU6ybZE7eTJKQNmVfmL2WQ+5U?=
 =?us-ascii?Q?wSQKlLk6cYKegL0MnlzumnYuN7DXSn3D4Ww3hurRjo5T1ptphDTK9KT164yH?=
 =?us-ascii?Q?nTcMtnNpegkyFXb8N8KuqAvmD2JkdXCrlBUvxqEmRMs8C0puIqr6raret8Ij?=
 =?us-ascii?Q?4+97pGK0YXHsiyUx45uD26+gkvotHXmdEJgLRVRbm4GMj2NdDtZkPrpqJAVy?=
 =?us-ascii?Q?Yd+lH0HEKxX3aboH+9CcVRD8LtKx7wb5k5wLhkGXpiBeQZ3dINuD69iJmWCz?=
 =?us-ascii?Q?iyvvenhravmfaB4tRI7/yjBf549mImrMFcpB8pw6GY5ygPSjIHdGIrhXjJ3V?=
 =?us-ascii?Q?in0jsNvrMvU2DgUp7xfdcwBjB3bKxt2ZbCVbEfVPSKKRx9zItnWYGGZYSwOd?=
 =?us-ascii?Q?9Ue5g5zZ5NuDHP/9KgFAMZ3KBJ+gBO4tHbX7LIP0dkKxpqDq9c0a0UB7oaoe?=
 =?us-ascii?Q?EsgATn0kJtV7uMYtTWP+/+bk8d0w8CwYvEvvHF5vWcXYSaU7KIH4iPTIHbfF?=
 =?us-ascii?Q?DZiUbcJyrhR/X48KOnKatIIRBTGQtZJ2K9Zyvh/G+eMhUEaMJ9Tp5RkPBK5/?=
 =?us-ascii?Q?Bdy2C/lMB5+fDyR4L5IUUYHfdLw2zLZl+OTxlMTmQQZGk0LAMNhtWgB43Hk9?=
 =?us-ascii?Q?ykew6KS188y7Bcp+M/goCRiZoeIjRP/zHwBu/mtHh4EU/52IoxlGUReI49tQ?=
 =?us-ascii?Q?K0vkC8QnmPiAXKHQwVLA6yQl1RjdwSz3NslI2INqrod1dNi3P1PUl75BLIht?=
 =?us-ascii?Q?jJC+VAEPHTDHvRTXPVN5Cgp/rI8UlL8N06rkGBxmmHCwFAAkUZxiJ9MpsTrc?=
 =?us-ascii?Q?hTaIcfHV42FcEO7Oz1Oo1mykvRhaxuXRnr0wrEgfz7JFGMwiLwmpG2Fk78vY?=
 =?us-ascii?Q?q3dtjdjH0st+rk0h1C2I0LLoC07AwrOI4pbqbsjuMr+eYBHMix1V3gxWH26+?=
 =?us-ascii?Q?lEKYF5o61RkkECOKugTtFtZsbLZSjL7m3YHhNGxhPGN12KLiwR/kjHRqsZK1?=
 =?us-ascii?Q?Nr2DthbOYu6gnkHTKSYweUua8LBSSGfpbZCMqhYQdom+Z0d7JgxXBp7pLxw9?=
 =?us-ascii?Q?0xMJbOqn6GKj4u8sVNJpUVADc9XkOu7q6oSHOAoT7R+BqU7pvj7o0WS955bT?=
 =?us-ascii?Q?LexAtR5vLgixGnMn0PDWH7G9UdT10PYCkGkQZGUe2LN/ejbK7mCh3uEEN4g3?=
 =?us-ascii?Q?m2xFAA04+Dz8aVOmHO7gm4qbZ0T/I2djAD94Kk08f6FOqcVLrt4sTFFPSY7C?=
 =?us-ascii?Q?DD31eCOPpnTqrXdngp7RyfrxestBudVCYJGE4lNiqoa+BBfAdLe3RSppYg66?=
 =?us-ascii?Q?zCbVSaGKk2XCF3dFIDD2gbqVacOEib0iB0HHeZFsDzhQ0vYJDSt+zL8FdlJi?=
 =?us-ascii?Q?JHpbDy+w6G1UhJxFCSiJxcp95UGC+lU24GhmyvwHNRP3wz5cReEiH+8vPl7D?=
 =?us-ascii?Q?/pRHh2ez8iBUnxEMOiE0SQz8QHkg46iPTcwX8vbmlt91QABemf1skY7Xf0sB?=
 =?us-ascii?Q?aK/Osb+8Wc/tlGsQSC4nQCknPgI/rk9gsZqGT7lKYaO7eAMDj9rICjDX9Kr8?=
 =?us-ascii?Q?bRnBWZLN51VW7bljRaRoav5zqzianS09oIsqv43Ur0MXRw/gqMZqzwJL21L4?=
 =?us-ascii?Q?oP7bcw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6610af24-0b1a-4a54-b58c-08d9edabd48f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 22:14:11.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6Nr86ApnP6J04hjMaFpnPsyOG9WEebYbMoe6DFPnIWOsVCKAKhcKiywUnDy+Xc9oGE2Sh9KoDrWkq3tUPWNmOwhRV9FCN5FgTojhpthvoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2897
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=925 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110111
X-Proofpoint-GUID: GzLbIXoq_uxA1FDMPXM1yh__Xc9cgjwZ
X-Proofpoint-ORIG-GUID: GzLbIXoq_uxA1FDMPXM1yh__Xc9cgjwZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> There are some cleanups related to scsi and libsas:
> - Use void for sas_discover_event() return code;
> - Remove duplicated setting for task->task_state_flags;
> - Remove unused parameter for function sas_ata_eh();
> - Remove unused member cmd_pool for structure scsi_host_template;

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
