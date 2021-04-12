Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C24C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3702E6120A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhDLAv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:51:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42514 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbhDLAv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 20:51:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0i0QN051653;
        Mon, 12 Apr 2021 00:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zqxk3u4/eDdQS1i7PfnABnLbOaszfQwUiRmsRovmXAM=;
 b=iLGJ2gK7kOLNDaFPzLEQIyuAN2uAwcA/K5/w6mKzrxqHL27wJW2y58Iybh6bdUdadO8G
 eJXY+hzd4HBpTa7FFlyY6IDK2CLkinA1OKxdR+g400VGOxNVP8emnPcNUNmLqa7GhcPj
 WFb8wfXCXu8zaOQ6xtk7qaJ+1i/8v13UciJpgyMb+MUUzcoG3SJ1LVeCXRxxl+foItEK
 /+6UZ4XiPBk+ACccx9RwpqoeQdxARwbPHTdNc/eJ2qUGf7bebD28Hq31Tkt1RgOg0Vgz
 usdPnPvLrOAMNWXvk+8Le1BOeixIOXOe/YOyZZt2LaiASifS2BK2s/tYCzuT3H72ZFUS dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hba3ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0aNP8051826;
        Mon, 12 Apr 2021 00:50:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3030.oracle.com with ESMTP id 37unkmf7xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKj0Cn3UHGSb1ntAP/iN1zw1ohyGpfEmeLAUl6pajhvaz3VPcl27MIMo6itzaWBStFlaNU2S7w2egSHE/oBJum1flpOCIexBbQLket9WFybHDDbtwKyj0G/9eOcaDOhYnzZr8kZnIYsB0PtR1Di60GaGmbw42d3PPmtA0Z2dl6ohUNFPE7qFRnT36wGsyf5KCgX4J6TUaU6nG1d9UzbEWvsgtZoRV6nAI42ZOFR87Hg1UVndO4vv3L6IBn56nYIDuTX+RB6lY0ozP7jwxUkF4FxSwca+tdJ4jBJo0pKeNrVcXmj9XbvRdR/O+YV6daJeafrwaxYVInXeHJjInFdM3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqxk3u4/eDdQS1i7PfnABnLbOaszfQwUiRmsRovmXAM=;
 b=ZdHNST/l4baFiwiSJ2XznPQpMc32pXugW9j2QXsfu4GZBvC/UrLiKNTCUdZHPpYzrut5PLbl14bfB2CDe9s/sj+OWdfj4C54f9g9XnjVkpWDKQRNsdideuBbz6hXcDYSjVSHls26xVWQqiiugvYKKBi1ZXaud2L9vleg9yjj4Bh2FBHyzN12e896+NvqzAfb60Uc5vhTSF9vBnFFfk4MEbx5thqJBnyVvUyWm+oxJjXptXoXlDVhb12Pq7o/Stv/WB47wBoKr9HSLKmRITt/F0ORURZeZGNvIt2of7eHMA1xRQgjxcYY2Nfss6i7DBNz0pJUbNJ5BNaRS/u5W1lMww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqxk3u4/eDdQS1i7PfnABnLbOaszfQwUiRmsRovmXAM=;
 b=eUFXpCyzIoQrNIFI3ZLIkUjMJ1p+4nBpcmeThX2d8lWwJ54K64/9WStKTpusED2Cr3Msp60goLpuDB7xA93LpRl+pYiWSb3DUOQXXSGIw8GgQrKm5U061DmdCfodnbg3OTQE/Q0i6CGiC8ZErW9EeY6ZXCbfeb7W4q1Ar7b8Pqg=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 00:50:52 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 00:50:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [RFC v2 0/7] iscsi: Fix in kernel conn failure handling
Date:   Sun, 11 Apr 2021 19:50:36 -0500
Message-Id: <20210412005043.5121-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:5:54::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 00:50:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 608946d8-82b1-40ee-f82e-08d8fd4d05af
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB430776B619A1A09F44BCE094F1709@BY5PR10MB4307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0tdutOCXmfAH0SRQYW3t8GUHF6E0xhz4OBhmzmQb7hzPiYiSVORIqMS8pievLUP01ButiXz9O1XtYtma99jMpVe9Okh6hpRwZzCHAIJsk72MU4ToMe5Cnmveoz8VEpvCvS6XMjj6thYpcu4AmndXoqbK9vXvbNGxA57Dz2UqzNlN4mTNuA1ObakN9lwRCUhXTe0z0vSlLjsAIvfYrRWBC98GGPiNXo4Jg0wm1RhFE/ESRLtaTwWccvOkJiqLLOYvH7ncbDX5metZQE9VyxBxdE5DRfHqZZ1hBfosxOkQIxzVKQumzFXF8BIRWW8C7Es7zQYGzcXv6/QB/OPVIBSEhOpf3i72z8UrMXWVepDY3lzm4pMSNADrz8avSszmOqLlwuLpHyjN53Ay8NVet2mr0I1zUf73gE+b4f40jbfC8dBn40Be1xHx1Px637EzMBWnkOKpFof/FAXao996PtAv/CWo0h056clWvcivTXmdD/7vlunTebfl2nH8D2CYzrMAZzFOP99fatRFP3VU4BN8SGffS9Om9/Q4Jzm7i2D+AgOqZg7NFku0oI4QZrYY+OgPQ7hbKzA+NN6fn/2wI30SELvifMmbZuL9kwqs6IEjm/35lr9tEHzZCowzXkWoNL2SmIf0QImSjgnmQ06RpCirZslCpnKUYLtYgcv1bQ+lHeV8qdZZkObnfQgkuYrIkxO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(316002)(186003)(16526019)(2906002)(86362001)(83380400001)(1076003)(956004)(66556008)(478600001)(8676002)(38100700002)(8936002)(69590400012)(2616005)(66946007)(5660300002)(6506007)(6486002)(38350700002)(6512007)(6666004)(36756003)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qH1MHkPpBRL2jISjnbh29h/XxPVn40oRT6RbkkBu96IwU6iwigIPBwlFiq0o?=
 =?us-ascii?Q?DVJxMvOgFb4/tAj8fhqD6IDH+R4qbbyX3jdx7JKmWYEPJrNYey6WDS+AX2Da?=
 =?us-ascii?Q?Ji6xVI7YEMemlLjOyxq74NhcQWbejaeQ8wdfmhZoVbZ6kT/Mzs2ucwGQyOy+?=
 =?us-ascii?Q?NMYjE8tMS2fUfiXLb7Rxz18NepRArcezJrWeQW2Y8OJXZj+0CQVnNZ+Ng89k?=
 =?us-ascii?Q?4PI1lvsrVckdvQgknFHkCqjqEeB3wQqy2Qse1oslRfTJp8GbE/68kyIdPpM2?=
 =?us-ascii?Q?KJ8hddtHIIHKb67I5ZXM+PIxDyZAl3Q9+dM1hI+kAVCy0yLCqjMlcgEiMHDc?=
 =?us-ascii?Q?2PbUwHX83rpR0BXLFFIV4z0n9MjHPf4MFlMpxXi+RTC2P5O7+NumJLRGC6bL?=
 =?us-ascii?Q?AvEui+E09F3NbaVydSv+3v6E9mv2lhPagS2nPBIjlDtg6IlYdmO9gNOPe9dA?=
 =?us-ascii?Q?TOIBr+w/IskX1Jl+urA58iOi2arrfMaTzD0lNrhWsk6Wdt17oCuiGjr/2RPW?=
 =?us-ascii?Q?0zsnj+mJ0+uXKqfLGcFdsiUF8+ieRSH1iIp0lQfhdwAYU4Av4IWK4UBhl5lT?=
 =?us-ascii?Q?2HB5QZS6Yh+U1foCsiClA45WHE4xQ86uOimSaAYU1hykdAyLQBa5xAnDq2d8?=
 =?us-ascii?Q?G5HBZ0PQ9vMtUX+/SGXA4yIGaWI6XoAdR/cZHJqgG9KV1ve/s9VUKLZTac2b?=
 =?us-ascii?Q?qDbmEpV5NJNTef1FkDjW+aM3LZzyxwRPMKIP6Jm6sK8qGe8JJpV/eH98ZSJz?=
 =?us-ascii?Q?rC/g3HkoUPhrhOjjSJPd0SZNpbGKUDdcx85weD3+0nsOgnFu05yKjvoWXuGO?=
 =?us-ascii?Q?W9KqNMI5b7pybWYQD6siyQ5iz8tkxOXTS7h0F9BSyO29+19Zf4/noQAXkjyp?=
 =?us-ascii?Q?/QuoZgmdaS9d+YPTzcq0EzO94DV65Rb8jkGBkhbxLwK9GZAR2pmVMTifbxhC?=
 =?us-ascii?Q?eDGN1XRvjGahFDn6ESgpHryNLlPX2HQZPO8Ediv/YLa2LMsCePqSv/HD7z/J?=
 =?us-ascii?Q?N1PDwpyGiHxg0oEp1i4dvuHXB+wRG3EciAihTBsib1UaUhVec3m23wb1D0Yl?=
 =?us-ascii?Q?1WIqiC9qFEDk59J1rsMyYWDScP9p4DyglKLCNC9mm5b4MBB/pHjzMf53PCTO?=
 =?us-ascii?Q?5Tu2Nvf/SGkKvEa6uSjNQZp2IveAgtTqA0TNX+2OAv+ZWQUHGefnrsIolRKR?=
 =?us-ascii?Q?kNBeOJY0E5NxPerf32RwhpxzJELirk1SWR9C3PwXcO93vW/7+ex5kNphMPGs?=
 =?us-ascii?Q?XlImZTYT+uyg5VZ7Fzt547xBmT84jSM2wutQG7Z7Gmro/VXLosAktDeal+Fe?=
 =?us-ascii?Q?c8ynNAikeBPYi9Ta4ZF2ZLax?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608946d8-82b1-40ee-f82e-08d8fd4d05af
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 00:50:52.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXhGhH6UsvMEdFyd6LoNvEJTOtT7bRJlNt5dyAum2Q1wa+UTsfL+QsJXZnzgz524dWkM7NJ9TyBhKwEO+bgyfHJbhPFUztDLtUqI/3k4K2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120001
X-Proofpoint-GUID: 0WBM23tNLJabZzEEHCbMx_l0XJecpoEe
X-Proofpoint-ORIG-GUID: 0WBM23tNLJabZzEEHCbMx_l0XJecpoEe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
in kernel space") has the following regressions or bugs that this patch
set fixes.

1. It can return cmds to upper layers like dm-multipath where that can
retry them. After they are successful the fs/app can send new IO to the
same sectors, but we've left the cmds running in FW or in the net layer.
We need to be calling ep_disconnect.

2. The drivers that implement ep_disconnect expect that it's called
before conn_stop. Besides crashes, if the cleanup_task callout is called
before ep_disconnect it might free up driver/card resources for session1
then they could be allocated for session2. But because the driver's
ep_disconnect is not called it has not cleaned up the firmware so the
card is still using the resources for the original cmd.

3. The system shutdown case does not work for the eh path. Passing
stop_conn STOP_CONN_TERM will never block the session and start the
recovery timer, because for that flag userspace will do the unbind
and destroy events which would remove the devices and wake up and kill
the eh. We should be using STOP_CONN_RECOVER.

4. The stop_conn_work_fn can run after userspace has done it's
recovery and we are happily using the session. We will then end up
with various bugs depending on what is going on at the time.

We may also run stop_conn_work_fn late after userspace has called
stop_conn and ep_disconnect and is now going to call start/bind
conn. If stop_conn_work_fn runs after bind but before start,
we would leave the conn in a unbound but sort of started state where
IO might be allowed even though the drivers have been set in a state
where they no longer expect IO.

5. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run
the in kernel stop_conn function is breaking userspace. We should have
been doing this for the caller.

The patchset should also maintain support for the fix in 7e7cd796f277
("scsi: iscsi: Fix deadlock on recovery path during GFP_IO reclaim").
I'm not 100% sure about that though. This patchset allows us to do
max_active conn cleanups in parallel (256 default and up to 512). We
used to only do 1 at a time. I'm not sure if this will allow us to hit
the issue described in that patch more easily or it will be better
because we have a higher chance of cleaning up commands that can be
failed over to another path and free up dirty memory.

I'm still testing the patches, but wanted to get some feedback from
the google and collabora devs that made the original patches.


V2:
- Handle second part of #4 above and fix missing locking
- Include iscsi_tcp kernel sock shutdown patch
 



