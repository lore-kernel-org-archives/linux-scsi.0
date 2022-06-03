Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F13C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 06:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbiFCG6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 02:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241955AbiFCG5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 02:57:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA54DFE3;
        Thu,  2 Jun 2022 23:57:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2534e53E011580;
        Fri, 3 Jun 2022 06:56:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=T+1sOcxiuLfnoCwBW/EG4H59MzkjgoaQ/9JvtoMoCE0=;
 b=XundPj8Xkq33MWzBnpbOK5FDkmRIJnXI30BhS76l9tN+IbuSjypxGhLnKxYkGT6hJFny
 twoLGjgdt2tOJdnYkcNS0G4ZLPXf/NovvCvm3+r60eVO3NFb+D2NVr+zIIdmOUXl/wWa
 aD7JSOv3j6rg8HDZL2DMpERlLgafa0IoqUdPyOAH9TvvfigyBCEXXfAF/z+PzKC0e3u9
 1AjHqDIRfrsSINKUKY+4DJxT4SyMZOm6a2rNMnYfMzpw4jP8+MIV0VxrsHhjwj2c/EwD
 XQ5dLRTgWDY3OsoH9oJeGUkpJ/Kj+CKah7sPeomq4asni9pAgSsiEPsSikJ5whlHY9V9 fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc6xc595-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:56:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2536q0XR027501;
        Fri, 3 Jun 2022 06:55:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8k25ntm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+rUgjeQjw4x8TjbaBUOmdWrdP2b57BpGu1VZUhakH//5bvPQ59qii5mVVMe/JfTv5uf8gP88TZFUZcp5jnYHkd1lQmPhe2eTKOGiQ+CdvA40uw9THlXwoPt6Rk4IhGiw7pjY3XvKztp/mqmhbvgemIWKksk+qjKG8tU6G9kDU9FqaR5r6expGzaYOkTyiHfp9QodD1tsQB+g92O3k8S/KmlAV5v/VKB9+B420h3GGmmi1ty8f5gOsHrsUy2HE7qr6HncGO2Y0loW57zUOnRPcc4pzZUPBqPLNAw3gp8CoMl8uG3l36f/tSn4doUYVBrgtyVz0hmG5wHlEhJBPbksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+1sOcxiuLfnoCwBW/EG4H59MzkjgoaQ/9JvtoMoCE0=;
 b=jM8yBN6vZEkUeX+vTEFzJS2SeQcx+awXi1jULVySWrEsOT7q24Wb16PYtZ05V3ngmBRvcl6usqks4mH0FoQNF29/nWSe+XqPFnFNHfz5nmLTfp21tjesa8EhZgvsM3WO0VXu2Pma+ooU7gA/HCpRSho4GyMekQEoiqX+m9lLUjES4oN1LFOgGNMjfFWC0ZRN8kjSCQwPDPWucW0P8UVYtOZPdX6fO7Guxi5SeAG6NewToJwpgyU5YsPoRQtyFi9Wt2fmqHdg0bZ0/m8fbgW53mLM0GyN0THHNSC3gZTsxBzzB1V9lf9NHQCoPHb4V79H4C461JmzJJODe6JVRe32fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+1sOcxiuLfnoCwBW/EG4H59MzkjgoaQ/9JvtoMoCE0=;
 b=S8DZXxTRrMJ0MWvaIKh5kEJE9C/7ZVI9eR0TvvIx1WgEMDmDehR4sGPGQQ7BOEehLzDvxzjR0toE9SqB/aVkp4+n5sTy25ZvUtiCu3Y+45lQR6OMEgG+AYMZZoB+mHGJ2MRFy2awqLJEI9p681ovwYz7oRX0gP7IwmxZzeo4MiY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 0/8] Use block pr_ops in LIO
Date:   Fri,  3 Jun 2022 01:55:25 -0500
Message-Id: <20220603065536.5641-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 111f33ba-bfcc-43cb-04c8-08da452e1506
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2789C8B54607C55BDC1D7D72F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yRX5ObvkWymcVW77kj5guOAOmW9CgylTQOb0zYu449XiyJugOsKeru4yS3qpu4v3DLWWQb5n7PhwwpwUhMdwp48/LB92Io7Ntlz/Pg3c54GsJnY0H3zHJwgfq4N5UpBS1iLmtWcc4/OG8a15iNMExN/UaGKwpEOVzZYiVY3qvF3GQBPyW/cedcAn8Emh6aJ8KHUWlQaEZvRi/iKi4DUt9t1CEKlBwwzwNBVIKO6Zs/QB2TZbZYSQzZkfOLA2zpDxQzkIuIPzL2SJRDncYxHauvi86v0DHw9um0lYPKD0YLjZg9YbPiOqJZsjjSxol2goj2rJrYgqyGZ75s3vz1KUSyyK81l6VUt54m+9Ke1a8dz9qfAvjKVzgocNc4rkJEQeUme+WlqwI9AZyT0TIKnd7OHYMgf0tRxmVXVxbi13qhGIieFNZOGIhVx6h8n3aP/ss0qTsFnFzKezo+BOtncZxdKnfB2o4Qg6AXSxwmkGHZZX1P3bOMROX4L06l2AJck1wmiv4dNGKQD6iB4kgV7qrEz8mKiS7n5IJewfoNcBEVhxV2q4PkKic5cHI2nwP2dJ28hUMBGzABAwzjflHM+8imKrNFNM+0CXgBgbzo8R8B3xbaZtg9CA1gGW0HMyIR/B4zn67kLro5Crd/0YvU9JBWbQUrhTLx14KW/yJBs9apS1pQxzSU/2OMp30wiKCYLWE7a+he57NTieJAT8UDHU6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(66556008)(86362001)(83380400001)(36756003)(8936002)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TjDcdBAeN3bO+7ocnOjFIug3nCwW/zNdtchyazYc/nmFyAIBPCwGCuX51FDL?=
 =?us-ascii?Q?75UnJn7iIECZE8q9Cs/0i/Q0Yhvwy5AsOtl6KV1/bXi+ubRIDCSYep6VnlqX?=
 =?us-ascii?Q?aRGwNZ3vrjse12PNfDg7Y/xRZjCBS9Q9AgYQMzzQfdt9UpRlaumaGNbDcmnw?=
 =?us-ascii?Q?ONZK+8Fp4Jdwwuc/yQZbeQuMZZAZMC8kNa5f6/AnJJp5P2D2BjeRAXiDXXB9?=
 =?us-ascii?Q?w+YIOc8/rcLjh4eV9vvqnGWDN+3CEZ44N30tGY5NCMaMufWW109Iwm1Ia4oz?=
 =?us-ascii?Q?XvL8873l5a3RcklXQrRbfR2CiNJtjlymdhfDSSxOi8zJBP+yG/GSZdE3IRlP?=
 =?us-ascii?Q?5xTB3RVQykDd+i3RC0CVYnoltQX1vOt32lrJC2qP3AxoXLYdQ+jzTA3pW375?=
 =?us-ascii?Q?6iUBc6oQd2NcIfnJ2b+xSa3Pp0R/pkN+5wLhkzHyKxjZsI9DuNouLB61z4p0?=
 =?us-ascii?Q?2TbmEL1DuboppCOjMlC3u0W1KOpQ3bBIEDs0Ay7OVeIRCZTcCD0jphH+BEjb?=
 =?us-ascii?Q?9MhHQug3zVZ27dXdZ6fC6qTMGzMamRismnemb5iJpA/xQSB1Ud5Tobwz4M7z?=
 =?us-ascii?Q?h4Yw4fRVcj/E9DAL+ryFTfFD6uh0KTeIy552P5iU4K7F/4lofiHKdL4MVNIO?=
 =?us-ascii?Q?N2WmWJKpDSYPfljLtBA3icFMDdFQl5oMjpvy6RJem7TvHHeVvwOyZnFLCjLL?=
 =?us-ascii?Q?O1He0KdMpJyuOqXucf3byo4m0dloyD+s45b4FPe6mJV154PCI2TtIbqtb4aU?=
 =?us-ascii?Q?9RD3zgOzSXtrHmN6nq0ERYnePjR5wsXPp/3sseix33m9aX3zvijarI9tEBtv?=
 =?us-ascii?Q?Zs7ByY2Ls+nppIdLdedpQkPlxME/eUDGGNExzbFbGqDJsMI7v9ncdCKnGcd+?=
 =?us-ascii?Q?J//2f51+Sc8gkEiTIyCo1k2qPJXv+RgU8pik+dzpLzp9izhj9NM+3zs3M3w8?=
 =?us-ascii?Q?QAiLhQIQZYdMpoEpcHi+REuAYorawXmsoR21vJG+hJiPAA2I9GRvKiHzKHZU?=
 =?us-ascii?Q?rkF9ZGr28ndDkIdzDQggFm+RifJFKgInnAjCwK0A58Zlv41/9ODQIfQWSJ3n?=
 =?us-ascii?Q?J1KoB4EBNqZAk6/1TE+xbcbZIL++cjqxBBcxGsPTf1JNjuFETjGbmQ8gZNZ2?=
 =?us-ascii?Q?k3vuRv8AOB4SzLORfEM+f64StB0G0GaIrAsN68zZWY9YqvRzFwG6/FGDX+g1?=
 =?us-ascii?Q?A25iWtap8LY9uH16mUlmfn4Cjc/wvoyZLwdItk2rjWEJZ06WDYWET1cbDovZ?=
 =?us-ascii?Q?DK3Hs79czG4nTT1nrY6+LEIshQAMQ3V1vWS1X7G3JPyWhjXULAjFBbmf2qCS?=
 =?us-ascii?Q?LSW2Ww0DjuHpawMIbAqhYe/926VVkmapxLUiCnOWpGU3UPTB7oZKkNXvU+5m?=
 =?us-ascii?Q?zSquslCKzATR6IP8LZ2+zV5Hg5Ezit3omUKLX07BeS3BviPdoN9KAedNzKaI?=
 =?us-ascii?Q?W3HVMbRe3aVStBzaKnh6PPK3FDzChRsYl1n3nLN7NFP2bvmTJHlkuikGfZNF?=
 =?us-ascii?Q?di6MrlxSM2bdNQ+E3CPYsGXOtcPsdOdNLexKXm0dB8hdvHvE2i55R3sx9mYL?=
 =?us-ascii?Q?NdrM2Mwzfi8QsuJP7zCDmOHP2szh7Yc8/cxt6bcEPpxTSRF+2IefBMttQJj1?=
 =?us-ascii?Q?r4ugze7xhHGQVD/ykX2SiUlrRhD95FAC3kz/QwNcjX2YfDMQYx0fLaXnteHx?=
 =?us-ascii?Q?KczxnCgzTiuxMWoG15aQteUwL/x2Zxg+CG25WuTTfcWkvu/Q1BDFTw30BZ5s?=
 =?us-ascii?Q?32V0uYhzsffT3DBy14sjfW6OdGhKQc0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111f33ba-bfcc-43cb-04c8-08da452e1506
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:45.2999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un/eM7IHFFYQDRWFoCP5h9rz4rF2dq5sMzmnYTQFtEAIV5KsFvmtvM7EPnBq0B8z6GFw5keaG/LnfXqcCUvrLsQCST58ItOU7YM+0GNeWHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_02:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=844 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030029
X-Proofpoint-GUID: fY7ER0yNVY8Mn_58AC0cgYK8T9G9hRQC
X-Proofpoint-ORIG-GUID: fY7ER0yNVY8Mn_58AC0cgYK8T9G9hRQC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were built over Linus's tree. They allow us to use
the block pr_ops with LIO's target_core_iblock module to support cluster
applications in VMs.

Currently, to use something like windows clustering in VMs with LIO and
vhost-scsi, you have to use tcmu or pscsi or use a cluster aware
FS/framework for the LIO pr file. Setting up a cluster FS/framework is
pain and waste when your real backend device is already a distributed
device, and pscsi and tcmu are nice for specific use cases, but iblock
gives you the best performance and allows you to use stacked devices
like dm-multipath. So these patches allow iblock to work like pscsi/tcmu
where they can pass a PR command to the backend module. And then iblock
will use the pr_ops to pass the PR command to the real devices similar
to what we do for unmap today.

Note that this is patchset does not attempt to support every PR SCSI
feature in iblock. It has the same limitations as tcmu and pscsi where
you can have a single I_T nexus per device and only supports what is
needed for windows clustering right now.



