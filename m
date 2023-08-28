Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCF2C83F12
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Aug 2023 22:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjH1WKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Aug 2023 18:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjH1WK3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2023 18:10:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D8CD7
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2023 15:10:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37SHxPbw026672;
        Mon, 28 Aug 2023 22:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=tBhG/BFZ4C6nNh4mbo5/r2dZI/FSqS4Sk/0Fjuu8S6s=;
 b=F5Zs4lzmqFPNzRzzz2yrXM7l88hCd9m9qR+kyuLwNspT1Y9+jEHQ7g+6ic+sEsHz8P4h
 qBsyJhRRyKcQA0R54N+NCny+3gjr/sUXLzGQLNjOq4EW0h/adP8+JBZirxTPiz8A0w4Y
 SuSc1iQbbeJjTW6u4EKLetNK76MIAvczn4nDeXmlna2cTP+k0UViQID6MH7nAUuskiX2
 9x3LSKjEFveuj8r7QqwjA2z5lqDXDTAEl09aln9S0c3cHMFMPOxkNRT+dhLeEG3F74IG
 h7f/CuKwBcpni0M6fjSf7qStGYpNRDyBeRpmR9KPLCCGLynD2Lea4rTqLvcw+3/fa8NQ 3A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9k63r7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Aug 2023 22:10:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37SM6Ni7002069;
        Mon, 28 Aug 2023 22:10:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6gaa3a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Aug 2023 22:10:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNYZojtGUs1KV/xxYU+gq1Xsi3+zP+6sjt1u/eE/Mp0mKCzoFl2RdLeXKJdbO2B7VYZEjFTNo9icT5ZLtCxKQ5j9Z0CmkP1Z+U78nuIkXUEwUdjFj1XZsybSFjwcpiE7ad+4V9260LiHqAdX6E8L8Vx238AQljEbrTy1Bbs1MgapTWWxapVOu76Spzd1Khs+D2GOJo7dd85JC7OWpsjcMhiX9WtSdNOLUiV85524LywLzr2hlAllRG7M+uJwMPo5UTphpcBTd45kyl3BzvslRURni1h2QwGcBxpQI9jTFqvguY71hjHX9dWxl7cuuNGyAJOEDuVLgJFcwwyW4EkpeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBhG/BFZ4C6nNh4mbo5/r2dZI/FSqS4Sk/0Fjuu8S6s=;
 b=JdC3GjVDuU+3KILapQh6US42MtH9JzElwqlKxAKVY8SWVhJ1et4PjrOAkBewxPvCC2kFXud22kkUAIQZR90hT2FzQyZs+6Edvjgd5T38DwMwAxzJmw60PQ22XZJtk1QGdvrA5gPQcdieMJSNwj0OrF1P3u29kiQ9jOKp2jqmbBDHMcaXWuu+eMQRY/EDqI5nko/xVOg3kHX8TdaTK5u/T7eSXYMor0HWGvJ1itvKm3wTRNPBostY0joaQSaokmGohxscFB5RJ3Cpy80/GkEDH3NkNuTiF4oQiy4Fw5WTAPg43ZFkrs2sr+70RKhlbAb+QHHt7PA2atl0dnWT3hWkTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBhG/BFZ4C6nNh4mbo5/r2dZI/FSqS4Sk/0Fjuu8S6s=;
 b=tREnIgb5YKeqk3EIqeRyiiOSSMQh0kaSlo0TOBoCotg/4CYbp8c4E9gHBbsUFS9JNIvOkzC/z177RVeE4TYXm7bIk3EmYoGRir+zxVUofgwJWtRWx0ukT8wkbsGuFEkLobEX0Hiu2M8KLgjfnHr+Qsh0GDhkBYEDnAJXAqh/XcI=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34; Mon, 28 Aug
 2023 22:10:21 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::cd07:dcb6:e63f:c599]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::cd07:dcb6:e63f:c599%4]) with mapi id 15.20.6699.034; Mon, 28 Aug 2023
 22:10:21 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, martin.petersen@oracle.com
Subject: [PATCH] scsi: megaraid_sas: fix deadlock on firmware crashdump
Date:   Mon, 28 Aug 2023 15:10:18 -0700
Message-Id: <20230828221018.19471-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:806:d1::23) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 028b604d-d395-4830-95df-08dba81391db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqF6eTpcRxtoo280EMkf4vziuot1VcQ6Z4U7iEUC3gBhCK/wunDjd3cVNndE1oy+3h3YNHpKjoKvMGbhdPUa/abR71s1GMeBZU2iEaMVfxKuhEqGjFARb3AeXyESJmDOwgqT8r4Wyf6sPFLLmwPcGtYVCQqbueHuQkuySVL8z/sAU0IiyKqO+q3TvIUQU79ywFJ1xWSBCTohnoaStlft0lZT2PjFPY5/0Lnu9QhrNpSMr4Wojuhy5zS/X2zXdM/NWclzvueH1kaandCnmbZH4R+gEr04AakxZzkL1qaS1Z6YutM96PMpv7ncGlKi41dBb0VauWDQD4RzUnpxf0hE0qd+HhSOeRUtfEMMqWNEbAXkOKjU6+1N5gjjbGOm51VD3pgm2jry+ykYjWi2lGBzDF0X+xLXMOU28mNV80H93LkEMNZzgUvi5vIEzBqVwVyAzsaJ9j8Ra5Oi00/dkF57RpmiMRCYV+x906JYTCCbWuY3XIK1ptTzFyUoblv+CN3lcdXLWaiYvSKBwgkPzxdKGU7l4JN1nOAuc46Ra/2C1hUyw0I1bRJVT/Ol7s2iFRSZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199024)(186009)(1800799009)(6512007)(6666004)(6506007)(2616005)(6486002)(1076003)(107886003)(5660300002)(86362001)(44832011)(2906002)(41300700001)(8936002)(4326008)(36756003)(66556008)(8676002)(66476007)(38100700002)(316002)(66946007)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZYu6Gb09Jmk9SD+CLjGxHWlvqJEOMssJ6GyG27ZzfpQPfp7EbHLfMqPtPYh?=
 =?us-ascii?Q?YPXLKs2SkcfN4/qR3Yt1JmkEgdH9LdUWLXMaOSzN5OjWS0eVaVt0aWO2Uh7z?=
 =?us-ascii?Q?75CG8LQZ4G6d1Y3tURPLHVrd2kGQBvSv7mKSDJpmjmZs97cRMdRXV/LTwa1H?=
 =?us-ascii?Q?KdI9gXWtlJzipLDa1swNIghWhxMV2ZFbSYOuvzKJ7NJuNLFsTevv0EEO75Zb?=
 =?us-ascii?Q?nh9Plmk9HFfhEnfgSS4hKjRjt8IcBXMqopN1kdsmOa/EenQM4aACg+/6DVBj?=
 =?us-ascii?Q?BCh8+cqg2vzkAYHnwzUWoSwsz39vhnhbP/kAd1Vk1IqlKpkm6cHRpuj1u76N?=
 =?us-ascii?Q?u4luSpvc+RksclDa+b+s3aP35qAZ70wwLEbohGfRasm13WDM+F6d7pQ5EYOR?=
 =?us-ascii?Q?2Gm1AsXXpAUZhCbs9VMAfOn0St8P5hYL0hwHrWSSdeiQGdy8kyGzyrcdJgmH?=
 =?us-ascii?Q?IwemwcxI56pe3T+EM/hr8ONuoOXp6eGS6M2UoOnvM89xu/6ZUt09IJIPKUE2?=
 =?us-ascii?Q?UkBUvf45sLXD13oEktn6stQuNRDy09ZfWu4csdhbzkuPm26bt3SGO60r2cWi?=
 =?us-ascii?Q?oiMnX4Dwy5WTsNJaihnqN2jJDEx+B+XWTvWOfr/1iV3/OS7GOUrIBSHUhpq3?=
 =?us-ascii?Q?7eCAQiGYIVVz4iten0+22fAkLohJAbSb1bW1aMMZMWbbngKsdOyf6eXLHI34?=
 =?us-ascii?Q?WZhnDlmpZRls5M63yYas6DYL0o3qhqctA2DjhEPo61T143+IEw5iQ+9Z/JyR?=
 =?us-ascii?Q?2VpBywDIut6EHAZjG1x5quS69JzvjXOyl9+WbmQ5O4xkBjIaB4jTB8rwA1y0?=
 =?us-ascii?Q?zhxurxugNkbyHR019WJNY8x51yKWu4jk6ShwYaddoRDxl4eeareiAe6FjNwH?=
 =?us-ascii?Q?Fo8Aeyx/cPtdNeEYZJLfuTa8bztWlOnihD8gnhnV15pbqTxlQeEVdtFgetan?=
 =?us-ascii?Q?RSB09fQtKVf/g3RNxZWiurs7hotIExpzOkKFzM48vLxHuNaagQ+exbJElj6p?=
 =?us-ascii?Q?dNW6KSxrPebO0jAKJevQf0+RRuwvJtcz38/dpK70M5DYr0rLrp6CV4qYLKzd?=
 =?us-ascii?Q?qG3Dr0fvzvBl3MQR9wfri+KvDSk5aQE3ZwM0wW3BVjLsblgwyZzA8S/Hf4E3?=
 =?us-ascii?Q?GGNq+1R6sBq9JmvR3KZzk2AnDNjs0YzNs3PJKBmnBf8IXkuo9JuRleDpqBLJ?=
 =?us-ascii?Q?Tt30G8RaERh9uzh45tlTLkOZEfiXW7RzfLM5i0nXvJSpPQenhhzPmyrN7k+X?=
 =?us-ascii?Q?7mU6+IeGYgJ/wg2+FtuxS2BIUl9OSBk0nIqQeKArexU0tQ2JQZ6SJf6KBFKe?=
 =?us-ascii?Q?V2u4Q4xzt0s789TjM4CUvaTletYZEpog7lIfcA2eQR1OP2cPqyzkgEWJugq4?=
 =?us-ascii?Q?/seJx073mWSZY1YOCkBVFkV5zjrAhlnA6Rj896rhsvUgWZB1lR5+vOYnkWQg?=
 =?us-ascii?Q?PGzFozs9CfLeTpjHEYz34/oYEx0Jn+mNVQKkB8cyD0+q79zATchLkLtpXFSP?=
 =?us-ascii?Q?u5qZ2nt4OFcxT3z2tuNYla9kLFnO3ZtaMEU49jQaJCLr2fmre/JZMhJeczxy?=
 =?us-ascii?Q?PJ2mt1eCBzr7CnM0EgknNtUzZFdaq0O6c2fCkEtK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: deJbysI53eZcuI+TN6rFn7QroLHj/P0D8GWD+L/O0bXf7mlJaHxfvtJWRHBwNuVrd0BvEKCZU0jQ4MJRH9kGxVgxFCgFUo9DIKJw3kwa4jUX/SprRcT67qDv2MHLPbGiwSOnqVNV79VjI5dLcAH2xVnezPwT5+HaCFOkPUV30RZCTOkBwwK5zrphY/dveyii0SbDafKYpeY5VBtCSRkKklYmkuPtxuigVwIkIMEl/+XDbY8q+9OSVdPNHhFVlG0plZT4r9L0Yt+cQPBWG/n6pfZ+fc4j7M5S8YLHyqTYfj0HbCNLeA3H7B2Xfq8RN6B/L5uhKLAowC+/2GiaLWzXnzqva3IgxgoPnzTaf/DuYv/8jtB2nzoiawn4n/7ihOBRykkTVO6voktW/WMl8cM1L3irrV995w4WjdWjDcivUBdhhIn3c2aK8GzM3q70gbPkGqyZNErmhluoXQoXHXRCTtGjJl+lTcMaQNvLq/ixK5+9NnVpnzjzRBeV2oKlrBnV7u4alSGQEwXFI08YxPhipUaUGS0P8Id3qE1qHjyVWAei5chtseUWpPujF9KRq4RrMh6T/IyP0dKtbVI1u9xtJYUj9LuNRJJs0Xby635SeDHvBhF19hTBbXM39YU46ego3ZR5/HkpM/1PN1jxCrX2cPzTJ4OPGiJYV7omNiRQC27Si82uZpEcrGBEEPy4Ef8aT70Ohn02i9W6Ok3U22gcbTCVfqu38E79caScGP+/oAawU2cp3kxslGeEOGhbfRULGIqCXN90BJLKDtEZBO2hMEv8TqC0vcn9wDCfvEAa90U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028b604d-d395-4830-95df-08dba81391db
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2023 22:10:21.0326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rvo8pDFL6Yd8fuSQrtBX6yF4c2VTnOvLI04Ddsa7SGMPOS5op34DD7a31R6rStQE5d/rySNfSjVXDR2uzOricg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-28_18,2023-08-28_04,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=949
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308280191
X-Proofpoint-GUID: SCSLgpI6qHsMAeeHXKlM1B7nSUN85NAu
X-Proofpoint-ORIG-GUID: SCSLgpI6qHsMAeeHXKlM1B7nSUN85NAu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following processes run into a deadlock. CPU 41 was waiting for CPU 29
to handle a CSD request while holding spinlock "crashdump_lock", but CPU 29
was hung by the that spinlock with irq disable.

  PID: 17360    TASK: ffff95c1090c5c40  CPU: 41  COMMAND: "mrdiagd"
  !# 0 [ffffb80edbf37b58] __read_once_size at ffffffff9b871a40 include/linux/compiler.h:185:0
  !# 1 [ffffb80edbf37b58] atomic_read at ffffffff9b871a40 arch/x86/include/asm/atomic.h:27:0
  !# 2 [ffffb80edbf37b58] dump_stack at ffffffff9b871a40 lib/dump_stack.c:54:0
   # 3 [ffffb80edbf37b78] csd_lock_wait_toolong at ffffffff9b131ad5 kernel/smp.c:364:0
   # 4 [ffffb80edbf37b78] __csd_lock_wait at ffffffff9b131ad5 kernel/smp.c:384:0
   # 5 [ffffb80edbf37bf8] csd_lock_wait at ffffffff9b13267a kernel/smp.c:394:0
   # 6 [ffffb80edbf37bf8] smp_call_function_many at ffffffff9b13267a kernel/smp.c:843:0
   # 7 [ffffb80edbf37c50] smp_call_function at ffffffff9b13279d kernel/smp.c:867:0
   # 8 [ffffb80edbf37c50] on_each_cpu at ffffffff9b13279d kernel/smp.c:976:0
   # 9 [ffffb80edbf37c78] flush_tlb_kernel_range at ffffffff9b085c4b arch/x86/mm/tlb.c:742:0
   #10 [ffffb80edbf37cb8] __purge_vmap_area_lazy at ffffffff9b23a1e0 mm/vmalloc.c:701:0
   #11 [ffffb80edbf37ce0] try_purge_vmap_area_lazy at ffffffff9b23a2cc mm/vmalloc.c:722:0
   #12 [ffffb80edbf37ce0] free_vmap_area_noflush at ffffffff9b23a2cc mm/vmalloc.c:754:0
   #13 [ffffb80edbf37cf8] free_unmap_vmap_area at ffffffff9b23bb3b mm/vmalloc.c:764:0
   #14 [ffffb80edbf37cf8] remove_vm_area at ffffffff9b23bb3b mm/vmalloc.c:1509:0
   #15 [ffffb80edbf37d18] __vunmap at ffffffff9b23bb8a mm/vmalloc.c:1537:0
   #16 [ffffb80edbf37d40] vfree at ffffffff9b23bc85 mm/vmalloc.c:1612:0
   #17 [ffffb80edbf37d58] megasas_free_host_crash_buffer [megaraid_sas] at ffffffffc020b7f2 drivers/scsi/megaraid/megaraid_sas_fusion.c:3932:0
   #18 [ffffb80edbf37d80] fw_crash_state_store [megaraid_sas] at ffffffffc01f804d drivers/scsi/megaraid/megaraid_sas_base.c:3291:0
   #19 [ffffb80edbf37dc0] dev_attr_store at ffffffff9b56dd7b drivers/base/core.c:758:0
   #20 [ffffb80edbf37dd0] sysfs_kf_write at ffffffff9b326acf fs/sysfs/file.c:144:0
   #21 [ffffb80edbf37de0] kernfs_fop_write at ffffffff9b325fd4 fs/kernfs/file.c:316:0
   #22 [ffffb80edbf37e20] __vfs_write at ffffffff9b29418a fs/read_write.c:480:0
   #23 [ffffb80edbf37ea8] vfs_write at ffffffff9b294462 fs/read_write.c:544:0
   #24 [ffffb80edbf37ee8] SYSC_write at ffffffff9b2946ec fs/read_write.c:590:0
   #25 [ffffb80edbf37ee8] SyS_write at ffffffff9b2946ec fs/read_write.c:582:0
   #26 [ffffb80edbf37f30] do_syscall_64 at ffffffff9b003ca9 arch/x86/entry/common.c:298:0
   #27 [ffffb80edbf37f58] entry_SYSCALL_64 at ffffffff9ba001b1 arch/x86/entry/entry_64.S:238:0

  PID: 17355    TASK: ffff95c1090c3d80  CPU: 29  COMMAND: "mrdiagd"
  !# 0 [ffffb80f2d3c7d30] __read_once_size at ffffffff9b0f2ab0 include/linux/compiler.h:185:0
  !# 1 [ffffb80f2d3c7d30] native_queued_spin_lock_slowpath at ffffffff9b0f2ab0 kernel/locking/qspinlock.c:368:0
   # 2 [ffffb80f2d3c7d58] pv_queued_spin_lock_slowpath at ffffffff9b0f244b arch/x86/include/asm/paravirt.h:674:0
   # 3 [ffffb80f2d3c7d58] queued_spin_lock_slowpath at ffffffff9b0f244b arch/x86/include/asm/qspinlock.h:53:0
   # 4 [ffffb80f2d3c7d68] queued_spin_lock at ffffffff9b8961a6 include/asm-generic/qspinlock.h:90:0
   # 5 [ffffb80f2d3c7d68] do_raw_spin_lock_flags at ffffffff9b8961a6 include/linux/spinlock.h:173:0
   # 6 [ffffb80f2d3c7d68] __raw_spin_lock_irqsave at ffffffff9b8961a6 include/linux/spinlock_api_smp.h:122:0
   # 7 [ffffb80f2d3c7d68] _raw_spin_lock_irqsave at ffffffff9b8961a6 kernel/locking/spinlock.c:160:0
   # 8 [ffffb80f2d3c7d88] fw_crash_buffer_store [megaraid_sas] at ffffffffc01f8129 drivers/scsi/megaraid/megaraid_sas_base.c:3205:0
   # 9 [ffffb80f2d3c7dc0] dev_attr_store at ffffffff9b56dd7b drivers/base/core.c:758:0
   #10 [ffffb80f2d3c7dd0] sysfs_kf_write at ffffffff9b326acf fs/sysfs/file.c:144:0
   #11 [ffffb80f2d3c7de0] kernfs_fop_write at ffffffff9b325fd4 fs/kernfs/file.c:316:0
   #12 [ffffb80f2d3c7e20] __vfs_write at ffffffff9b29418a fs/read_write.c:480:0
   #13 [ffffb80f2d3c7ea8] vfs_write at ffffffff9b294462 fs/read_write.c:544:0
   #14 [ffffb80f2d3c7ee8] SYSC_write at ffffffff9b2946ec fs/read_write.c:590:0
   #15 [ffffb80f2d3c7ee8] SyS_write at ffffffff9b2946ec fs/read_write.c:582:0
   #16 [ffffb80f2d3c7f30] do_syscall_64 at ffffffff9b003ca9 arch/x86/entry/common.c:298:0
   #17 [ffffb80f2d3c7f58] entry_SYSCALL_64 at ffffffff9ba001b1 arch/x86/entry/entry_64.S:238:0

The lock is used to sync between different sysfs operations, it didn't
protect any resource that will be touched by interrupt, it's not required
to disable irq, replace it with a mutex to fix the deadlock.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 21 +++++++++------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 3554f6b07727..94abba57582d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2332,7 +2332,7 @@ struct megasas_instance {
 	u32 support_morethan256jbod; /* FW support for more than 256 PD/JBOD */
 	bool use_seqnum_jbod_fp;   /* Added for PD sequence */
 	bool smp_affinity_enable;
-	spinlock_t crashdump_lock;
+	struct mutex crashdump_lock;
 
 	struct megasas_register_set __iomem *reg_set;
 	u32 __iomem *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 050eed8e2684..c0d47141f6d3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3271,14 +3271,13 @@ fw_crash_buffer_store(struct device *cdev,
 	struct megasas_instance *instance =
 		(struct megasas_instance *) shost->hostdata;
 	int val = 0;
-	unsigned long flags;
 
 	if (kstrtoint(buf, 0, &val) != 0)
 		return -EINVAL;
 
-	spin_lock_irqsave(&instance->crashdump_lock, flags);
+	mutex_lock(&instance->crashdump_lock);
 	instance->fw_crash_buffer_offset = val;
-	spin_unlock_irqrestore(&instance->crashdump_lock, flags);
+	mutex_unlock(&instance->crashdump_lock);
 	return strlen(buf);
 }
 
@@ -3293,24 +3292,23 @@ fw_crash_buffer_show(struct device *cdev,
 	unsigned long dmachunk = CRASH_DMA_BUF_SIZE;
 	unsigned long chunk_left_bytes;
 	unsigned long src_addr;
-	unsigned long flags;
 	u32 buff_offset;
 
-	spin_lock_irqsave(&instance->crashdump_lock, flags);
+	mutex_lock(&instance->crashdump_lock);
 	buff_offset = instance->fw_crash_buffer_offset;
 	if (!instance->crash_dump_buf ||
 		!((instance->fw_crash_state == AVAILABLE) ||
 		(instance->fw_crash_state == COPYING))) {
 		dev_err(&instance->pdev->dev,
 			"Firmware crash dump is not available\n");
-		spin_unlock_irqrestore(&instance->crashdump_lock, flags);
+		mutex_unlock(&instance->crashdump_lock);
 		return -EINVAL;
 	}
 
 	if (buff_offset > (instance->fw_crash_buffer_size * dmachunk)) {
 		dev_err(&instance->pdev->dev,
 			"Firmware crash dump offset is out of range\n");
-		spin_unlock_irqrestore(&instance->crashdump_lock, flags);
+		mutex_unlock(&instance->crashdump_lock);
 		return 0;
 	}
 
@@ -3322,7 +3320,7 @@ fw_crash_buffer_show(struct device *cdev,
 	src_addr = (unsigned long)instance->crash_buf[buff_offset / dmachunk] +
 		(buff_offset % dmachunk);
 	memcpy(buf, (void *)src_addr, size);
-	spin_unlock_irqrestore(&instance->crashdump_lock, flags);
+	mutex_unlock(&instance->crashdump_lock);
 
 	return size;
 }
@@ -3347,7 +3345,6 @@ fw_crash_state_store(struct device *cdev,
 	struct megasas_instance *instance =
 		(struct megasas_instance *) shost->hostdata;
 	int val = 0;
-	unsigned long flags;
 
 	if (kstrtoint(buf, 0, &val) != 0)
 		return -EINVAL;
@@ -3361,9 +3358,9 @@ fw_crash_state_store(struct device *cdev,
 	instance->fw_crash_state = val;
 
 	if ((val == COPIED) || (val == COPY_ERROR)) {
-		spin_lock_irqsave(&instance->crashdump_lock, flags);
+		mutex_lock(&instance->crashdump_lock);
 		megasas_free_host_crash_buffer(instance);
-		spin_unlock_irqrestore(&instance->crashdump_lock, flags);
+		mutex_unlock(&instance->crashdump_lock);
 		if (val == COPY_ERROR)
 			dev_info(&instance->pdev->dev, "application failed to "
 				"copy Firmware crash dump\n");
@@ -7422,7 +7419,7 @@ static inline void megasas_init_ctrl_params(struct megasas_instance *instance)
 	init_waitqueue_head(&instance->int_cmd_wait_q);
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
-	spin_lock_init(&instance->crashdump_lock);
+	mutex_init(&instance->crashdump_lock);
 	spin_lock_init(&instance->mfi_pool_lock);
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->stream_lock);
-- 
2.39.2 (Apple Git-143)

