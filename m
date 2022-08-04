Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5679C00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbiHDDlr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbiHDDlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9FA40BE2
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741iGBt017412;
        Thu, 4 Aug 2022 03:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=nt21gt5cMTM/0MqyOyZIh2gV5kGoCeRC92v8sn88wHA=;
 b=g3DxaOgPBQEFXR87MAnSZtQsX9yVpeNPrOm7S7jNx59ujNd923a5KVGUAoVYG2mv24xw
 jHD3NO02JcWm90ek4sZ+CQC6uzPZ16HQeBbWla/ybr7sr/bk/gOvmhmB27YF6lROfmHW
 zzEn31D4iK1SFAIy1UXfKKsmJ9f1CGcmnMs5hE/kRvkJs3IJjSgQoGPvkHoPuQaMTUK9
 tOs1emT9Rf79j7T5X0k2GaZMq8O9jbQZInoiNFHSUo9XaNHS+J1CXLUGAgzmiOaF32/a
 0WP/UJTOy0Hqmk8EzwBmNbkvQWTRYIeD7/Df7t4l5UiCOp7vZ1qkSs7ZVDfSlgeSTFQE mg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9ucvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27434jEQ010909;
        Thu, 4 Aug 2022 03:41:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33u06w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGl/j6JsJ4y9BtQFXpCzqIkocE0d+uJEBEF6uuG25BQKTGI80G61xE/7t9hnDz8DyXt5rBjSeKaGGUwzAnhjjNrbMTyLDH/HPTSMBzXfQOBwNJmLXr/DZyc2I+euaBVT1sN27fNcgROWlleUrOVdF8g3zZOYlQ352TcNAKxUew6Ivdz8aog0r01zeYlkzRiO8enzmydr/8Uqa3b4FIPpiAZN30+KbiZyqnBTrSpX3By5zq6UuZhpl0+ooXWkKMLKEElYGa48GfchCWPnqDJ2Cl2nmgmq3imfb5qgjLoBaujJ94NmrpBr6XdhrUjsjA9AXnj1W74mNPv6x6UNopofvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nt21gt5cMTM/0MqyOyZIh2gV5kGoCeRC92v8sn88wHA=;
 b=LNSXq8fXFLnPu53crYzKL01BZL983N4NqEVkd8r1moquLfkL6jJQVdpM2AAyNPW/zQ76y9Vpmnp4fm4nhaWrWKGenKYN96FzrgEhbYmdPRwb/qE2GXGjPtfy4umGLaDBPXIfPPNOeYwvaPrUh+XANI1h2+pEAXllTAkIybCnzmerSs0r/ErLozj8y4Zg7Lwu1nvZMSahq2KXeYeQ56mi1vxpcaq6rEIRXhi7T2GTrMP9Ux/Vhs4HF1PE8Y8QiFvW6Jbm9Kfht2j+KaRUV6hgFmQ7aqL3romDV88Z/7MExRWuULgmhm02DyScdGhIVfUQuhBucMhqNO0t6L805Dgm6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nt21gt5cMTM/0MqyOyZIh2gV5kGoCeRC92v8sn88wHA=;
 b=WvC5NL/xapyrpmN9uiVR5Y6QlCpPUmWLj5GtwTNNOWDqLr7CRFm8m8AwRcyHN0BmgaBXBU4t2qc/RiD6rPikVqzHJBCFDS3q/6xXF2stIbuJ0BKODSVFErdnMLqHoYuuYvgHLwrEz7kOIY2+JPMgy8EfYnICNfWuV29C+epCHAQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/10] scsi: cxlflash: Drop DID_ALLOC_FAILURE use.
Date:   Wed,  3 Aug 2022 22:40:57 -0500
Message-Id: <20220804034100.121125-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:610:e7::7) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2c1f88c-0700-4580-5900-08da75cb2d5a
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eTkOmk6tJWXixM0SZ/hG5/rRIbfGXd4LBkkR83IODjZIunQL69tkGoeAUIQU9dx0gqCM8XPXvMOz2c7VC+J5rVE2Oo6Kg411VE9Fj6NRx8Ed4H8S79erdMUgDP+kGfpnQDdkV+LcLzcPyqu3hfHclZ3eueVYHxgqmgeAlOCztkGKMokp50OAftEMo+Ge4KvqhS7SZWq1mEgHc8r5EUBlfRYtHbMvmnrMoAK7rucYmSLzZMeNoaHJ7Ltf4B2l9APNg3mQNIcjhHXyafH4k8zNpiBl4ySzouWpkDmaXTtHN6JGv1h3Tky6/kidGSAhPWw483nGwKKZUFEpcjQkyr+MW5LBvw90WinPxjEgFSscjRhTwHr7P5zbRLY+00hHRUtBrxfMvFhqK9h4p/cpzXEW6TPLGYDsPwEcYhZNy7CBAJNEuH7EUtPr+RYSZJkvEfa6QmoxMTtgj0zjBfDMwNDlRR2nXyv6mcoJz9VY8i2fdPkMl2JWpxXBxTLuri7puqJGC7c1dpzTgw/1siTaTmKQ0//JtBTmF/kH45kDIE7JMbcWFG+lQqVuvWFzQG8WayPo6WLkCB8mK7hoFPsZ5tOcLfvbzE8MLwZX6aSGlo7x7ug0+d2wYOYJEQR8Nx841ynkkx6v8Of+GEUtyOMgKJUuHekF6NDjJG8dr5NfV7YhvNcYdVelluzRp9w5Ew7DduBoojyH5ZeZbk0gSWjwr/PQ1dPANycjm65Rhu0H/pp61zLoAKgpJ9UzlLiIdLUFda40RjQktPQ9p2jHOfDS/m0yEsIjpaQjbtU8/aSGC75Cj0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uncndggV2ILWFrMO0etE3ka1dwqXVFaqZIvXnyDMdIRWf2Oi1aY46q8ZyXO9?=
 =?us-ascii?Q?ocISyc1hi/E4Mk1uqjRdzWvX9Ss6CbIGvSv29DG17IXrl2uXOALibLTma/NV?=
 =?us-ascii?Q?+YmQ82HJ1v7cQMHoTl/qpKpyCXwwotG6QYoNHSEgu6Rd7VqpNbxElGckAUdQ?=
 =?us-ascii?Q?wHdTffrTH/Cp2x7OOBuRpCy2wiHcdSWiMkJg85u+p0HMaXVFBjtBS+SsptJ5?=
 =?us-ascii?Q?+26lJhNyFn0mb5OHPpTPhj4Rl9YFZdzdQ4MEjENj3LqkHiaJfMfANPI01SCf?=
 =?us-ascii?Q?sPrqmx2KTQhRZZzE6ivjNpg6ZarVq9ECH7BwfAiCyfY22ilghMhHe7T9m3W7?=
 =?us-ascii?Q?dVbPWFMc561I6S+tszleih8pYlcrQlK85fslJxMcprZzo1dD0yiXY71RuGEF?=
 =?us-ascii?Q?VWIinveLwbxutbbGDPL/mbuE7Hu5Ou1WInfsIwYi+DCSyI32r6oN/HvxwHqI?=
 =?us-ascii?Q?IwivLG6E7XtuH4ySNE0zI7sgzwoqKXUcdGoJD8vPO9nMf2pxlLeBjmYVqXoD?=
 =?us-ascii?Q?AoP35fMaGCb8FlkzQQzW7uHH7sgtGUF9ENfZzp6FaWnYesj2guKkpIA6lFgi?=
 =?us-ascii?Q?Q/bXGrcT2mp96u0AepRsPnsHpnZI+9X49OgM473zMmxY4QD6RLGw4qkddg2E?=
 =?us-ascii?Q?FU3xiXWTZvtOgTlPd+R2RkqSks1mcRUexYHAt0YVqJmFib3KAlN/wGvDVwt+?=
 =?us-ascii?Q?a1ISE+LiCRsbokk8WE0IRHr7blNr2Vfp65rIcZT5fq5qmaHq8TLlGtuxEwFO?=
 =?us-ascii?Q?hjQJs7loJGUWmknpe7xDVLjkSzh3rUjTtoxE1ySsgZHtl21rOgIelXGpJeMa?=
 =?us-ascii?Q?DVw/MeMnwJOuqH8r93D6DeSvbgGoxoQtn7Z0XptH1FxAIjXfv47BPxTpeVue?=
 =?us-ascii?Q?se9WB5g4SBM93GawYgnk+AGR0m458F1bIJeOfv1t91eZXye+3U1DMwQPjucE?=
 =?us-ascii?Q?4AcsggG3jEA2VWKhm7LSuAIdVB7sIQysDfWMXrRV+agG4xDCZdmsA7B152QE?=
 =?us-ascii?Q?c8/+8SgTQdpZCUurr/KGXDS+gWRXgGMrGaJLijdGgCe2f+6JYKwIIp6hEd1V?=
 =?us-ascii?Q?l5iV2D5lubOf1psF1bKKw2RvSY6/tDA0f3xs/ipmUmltJv5sbMKraHPW0bfD?=
 =?us-ascii?Q?keASjBdAVV36gT6qUf6Jyy6z5LVBUFTsgJYver8AWJMrZuwgzHE2eQy0CTDY?=
 =?us-ascii?Q?TJ4prSiLLvCtNyTh+xO+0rWOWz35J+Yv2VxGHpKfRg/RF66St7xp55KkhVzE?=
 =?us-ascii?Q?ywa39wPaNRlvUEPJxUn/SxWXhleO9TRlbIMxdBjn8djr7kf9dSBblpjtH1iv?=
 =?us-ascii?Q?ieF+0BT1LZrpHAViD1x5ein7dab4xLPyQ3n6tXbUXG/1OK62I6cso3x0XIXm?=
 =?us-ascii?Q?mapdnv5XwXxim93xfu4BTaRlGOn4NQj3vtK0wfTnvNgUCwGf+9QpbiARFLsW?=
 =?us-ascii?Q?T7EeIx524y+CCMI4QGhEnmwrSXC5ztvnf8zA32hjPdOtTDf9HwLFy66jD+WZ?=
 =?us-ascii?Q?CE5j7U+0L3AvJqGgs0v3n2F7usWWEgbbwNXVxMnp+RdWA+/LPwGUCPzAetEN?=
 =?us-ascii?Q?SwtbK1ZBAj8XiSuKtv+hzYl25hf79n0ihYeyCtRoyvb6ugMEG3JT5wFsiRDQ?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c1f88c-0700-4580-5900-08da75cb2d5a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:12.7303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgv4kq5X1AfWDQZQO5EGxLbWpoFhj+/0xXLRwR27qAVR3fGbde+J6BBDxWIbCCa03ELn7sMd6RU2ydycZ5ZSGUB+nfiqmponV5VxxaQ1UvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040015
X-Proofpoint-ORIG-GUID: c2QgWaPrlnW3m-nVCNKMnunoB-xdAFIt
X-Proofpoint-GUID: c2QgWaPrlnW3m-nVCNKMnunoB-xdAFIt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_ALLOC_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

By the code comment, it looks like the driver wanted a retryable error
code, so this has it use DID_ERROR.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxlflash/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index e7be95ee7d64..cd1324ec742d 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -132,7 +132,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 			break;
 		case SISL_AFU_RC_OUT_OF_DATA_BUFS:
 			/* Retry */
-			scp->result = (DID_ALLOC_FAILURE << 16);
+			scp->result = (DID_ERROR << 16);
 			break;
 		default:
 			scp->result = (DID_ERROR << 16);
-- 
2.25.1

