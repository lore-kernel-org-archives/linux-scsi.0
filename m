Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9C1CCA481
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244773AbiF1Cd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244858AbiF1CbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:31:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73B12529E;
        Mon, 27 Jun 2022 19:30:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S2HwMf031758;
        Tue, 28 Jun 2022 02:30:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=f2OuKbh1EcWytAx9zQDoghqJiI19M+su0WhERB2G5ME=;
 b=iliWrw7wRno3ZQd1f16fIFDIqY+dJyvRBp7M78aDLH9pR77+JzoRC6R9xcy6RpELMfjq
 JHsV/4exd0jPMGOBzS4wtm1oDq2743LHSFVGGnnyDMrkpEgywru/8TG7Ui3Ow7nCx6Pt
 afvjsKwYymHMzhFOXMsmXon4ylmQShz0ewO31Qs8o5g6bIuDCR9O3rJD50TcHHYKDzIO
 zFDpgfzfAzFBS+Y+lFLzf3Noyqg13za30DggUM+lOtSpqnuhoZgVDhI2+QAzwHNLKWD+
 YiwwsbvbWURsXit8HWEz6BE8I20N68QopPdI8azmHdkLGIyA1XHMeK6vl1/l+nEDlo7l yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwrsccrkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2KJsB018705;
        Tue, 28 Jun 2022 02:30:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt1t5vh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIz8Bx+SIDO6tvvpcCzk2ug4tRF85kKf8uapbREkbH2yCDNPExdpqjb5mMw9Owfxd7sMPXqQHCBGeKeEC3YQkZv1jFsbl8fPxm1WJvry2Eh/yv5X6bFUmTxa9r8XbOimorpEu4S1lJIb3MEwvFANzZiVjuPSskm3Xhaqro9f+3np9fm/qwspRhkidttZ8EJiFDN76AWLiPkPdcwqZOGh51dfgWnidTtNidz4EIla67USup4h622+x7pfcoMa0KhAWZzgAmFCPzNqngXgVOHPWwuWP7KFoZEmTHnEE4G0UAzy/4lcpM0kk+/uxNjQNXfu8t6GDVRAQ9aGHiQxS0pFjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2OuKbh1EcWytAx9zQDoghqJiI19M+su0WhERB2G5ME=;
 b=kFo8hnKDOA3BcimWnC4bi7bZMCD2OigYyLY9uNQ4ODHGJGSAFmjUMFuooTePlGdpa6CYKPVME5QbJKyMneKDVU/fWRfvh3KQHyQ1Uq0PgFw7/hrwQJBdYgZjlb4F4PAsLnmXlv2K9bHT7li1S6LgO+vDVsjUh5BI6PmsBVSBMpposO9+TY1fUPJVcrXdwAMdhuN5C1J5fk4SphAGSlYQrYRmLY8d/C6X5yO5miLvEqC15GCTirYFUTXh0EglBGaF5WeGnV6UnJvznlIMPVwtBgqpvAI1+yGv7h5m8aIY9BPCqegrnCicSVkQ4B6O0AvAFaGni13fQvCju+z5lUVPKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2OuKbh1EcWytAx9zQDoghqJiI19M+su0WhERB2G5ME=;
 b=r/R2+pK+r1ET5zySZqwbNyT1exU/i4Fo3wj1ed4QOKR6lasOirybQ2UI+g+z4r+th85kLq7OzBmtGfa9r5rxjlkrQTWYdo3ZnttMo978m8XSALjHQYQFzQiYUVu8UtNUazePj4gPrnckSEkpCSC2VngLfRFhNN1XOq0PD2Byt4c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:30:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:30:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/5] scsi: target: Add callout to configure unmap settings
Date:   Mon, 27 Jun 2022 21:29:50 -0500
Message-Id: <20220628022953.20948-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628022953.20948-1-michael.christie@oracle.com>
References: <20220628022953.20948-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbd55ea5-e939-48a5-df0a-08da58ae1a32
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1mmdJg76kE7OAniOFN9F8kLNB1C/kzO8ImaPykwWgV9d9iY9OKnHC5fyjX56dPuqo7KuwnMN1ROoAyTTqLFMdVhZJ04WGV93UEPqhVJzqJkdX45SlVaAt6hfTAVQTGkxQR+LTSE6jivfZigYpcWIPyGK+UY14cGDodvFTuw8qpIdsZZZ+Ylj4Uo1oUFnM0FusS3zI3+Ou7V1KJitSeLl2JxAZ3poCnPYwkwkVMdtMtTpJQbiWS6cXpW13x60M8iUH5dIX5bwSKenwBjvmJ1njJ4no8Zl0SyulX8/HDSvuXj8t0Hu/daI9YeK0zrjLRI4TcijRGAmGTnwgfVFEcVkQl5lxJrTIOVNVVPdX0D0MnsQuvtwSsc+FpqysO0hnowP1tFlxP8dod4bpfxUuecGqiAsV7P+lqgkgfZs0Ks0Toc79Jp/ICcYWqVlwz21I237tV04MAigXTyGCRS7HePgYujyv0qAsZMKD0VvZMMP5jLsCD66JG05K3Ynvstut0Kd+jlughiVyE1pddSnDZotAB2iK8m7bYiZqnUmez/w73ysVqRhYeSUkjAgrIRc/bYXJugGyC6q1H5egnwlssg3AII8ZGIn+t9L0Um5zoFR4mVI2Q+xFfJx7M9i3IJmZLddqripG3BpAumZnPAjNX2KW6MFkGeDFXuLb25jcresOP+m0x8XSACenCnV80wpQE6PggWECxL0O1YCP+9jXXXRnTeM145O8twSGAQCOzqAbIaI0DtkqbXL2j16bom4Spp8yKHAjTKUyH5Vsc4o/TaPNQnOVjVbMaQzjG2qKQh/rZOHup7uH+TWJN7CTE9Mw4j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(396003)(376002)(346002)(478600001)(26005)(83380400001)(2906002)(52116002)(107886003)(6512007)(6486002)(2616005)(4326008)(8676002)(5660300002)(186003)(66946007)(6666004)(66556008)(8936002)(1076003)(38100700002)(36756003)(41300700001)(6506007)(38350700002)(86362001)(66476007)(316002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TsM/Dxli2qHxrHw4zEQkJS3ANDh8U6UHgb93zApsbMHIxNo8X2uEBdXsgwFG?=
 =?us-ascii?Q?owQ6Il3VYWcSQrQqlmfsooMaQe86iV59f7kk9XGWqjr3v1MvOvrmSkU5IXRg?=
 =?us-ascii?Q?oxaCfFx7GgljoM1VK1isJNgNzlBSDY+p3KyqpB5ute8ZkrEheA666hovwdyI?=
 =?us-ascii?Q?lOKNNh9vao8Mz+fuThokujIUbrZzJkg8gOX/EwnnQwk2Bo00dfzMPEQ2Q5sX?=
 =?us-ascii?Q?zdjh5g2YBptmBIB5WMfrJ6+kZbea6cqFeaDKtTJdFVrXKHHVDcP0YVCLwi+b?=
 =?us-ascii?Q?y/djqEGVquJcC+tVTa1szu6fgzS6vnmoW2pbV+lkRRQH0qDyQY+/E1EurbnQ?=
 =?us-ascii?Q?HPVQq+Ij+9M1Vl1nEPTcJKvX3BuVv+cJHLxgC98qJ8m8iSeK1hZ9L9QhAiNw?=
 =?us-ascii?Q?3z3A6Fdtupu73eLIuDdGWGS5w/jDVUAvbLf3nuo1aCZ3JLam4uQfehgq4+sJ?=
 =?us-ascii?Q?EgWxsbuUjtcJ8CRURYfM6mLuc5BG5NrS085RdasmOspra7B5asJFyKFNv7di?=
 =?us-ascii?Q?0xHE313vin/vjHL3enQmSw0q1nelTQUCwxxk4ORk5PDi/dPM0c7CjCGL91FK?=
 =?us-ascii?Q?RdrYZEUTPyc+jUK+N2S6+OweBJfUNL+bS+cvgBGI1EGodHaMvPgTQGjngPrv?=
 =?us-ascii?Q?NBsi1Eu9CRXByDa5YvR+Gwz96y++6Qml3PjzZkrKs9NJbWBRekoOQO7nxV0y?=
 =?us-ascii?Q?sAMyF9VlMaj1nqWRHhqrsqONgI7FFuPqvOQVeJNW+YXFOejG30OLRR84H6Y+?=
 =?us-ascii?Q?7E0HdLY2k2PEdLuhbZ6aM/3GHm34uVwr6UOSUHhxUnpdzR+ZGJHqaXAHV9Gv?=
 =?us-ascii?Q?dfvsdJQ3ZqvEvMvBpDsan8bVnSaDUyB92H16h3gRk5fA1TFo4Tpyyn0VHq0Q?=
 =?us-ascii?Q?vZeSYD55B23uco3qpuGVLsgAqS2W6U/Jgquh8sax7kGjVfn12rEHLgo7q4pO?=
 =?us-ascii?Q?W2XZsY0Fi7hk+DIu79qn7lq2UVg60xuuBFa/5S+wlIu38Fm5a41TAQ5DMYFy?=
 =?us-ascii?Q?6dlWtade8rEZDovRWe6IG/BX2kv8GPHrTN9pFgY91shcE35DuSOjWa6qNdSK?=
 =?us-ascii?Q?Lf5kwcFzozwM71TGAJR3VZupY4bsTO2SZm2ptB92VgPIbDXum6GwDnOgy7x3?=
 =?us-ascii?Q?amK3feQc4D2BWmGSCE3ERsX7DSer7UEXwL7Ocsr+H2q63Z9Bph+n402if+X7?=
 =?us-ascii?Q?Qj7V7a5jpiEwcExIbzGpju/rGhLJN2R4oLk5QQcBpX37RJip9SP7ABcMBX80?=
 =?us-ascii?Q?IqEetyjqjiIPZgU/7aj3xyP0IA9qB1O/JeIwZEb2GbSK2xCbtstdMaR+MBxz?=
 =?us-ascii?Q?sSaFc40rjwxgH9oAxtIEkvUhoCvvkaW+SNffZVh/oQMgUPwDH9DwQFsLMW9P?=
 =?us-ascii?Q?u6sr7/KgLsDOcWGWRp098m0yQL6EMM0AwgbV5SUo3Qm4kIR1RB0d+BEnf8vE?=
 =?us-ascii?Q?Sw+MaKGlhUlaKIHVhHa5IoGYep85fZEXYqgTnkoB/Wp3nO97zAS78IXklS5V?=
 =?us-ascii?Q?9Axy0c5T+pLdXFKclPOgeyvAi7v1Wi2Mh7m+AXvXqQG5DaB5cPkNOO5106Fr?=
 =?us-ascii?Q?uUKIWcGSaDe0ElziHBcZzzCzTMO6SvwH3GhgRn3wU/801Xv7mpl50xONRyKu?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd55ea5-e939-48a5-df0a-08da58ae1a32
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:30:01.5004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrGbfIHHFcTLgTYQu24DzE4qnhgjtpy4fF2ftRjpMNFLHx/5gazpU5XKJ4GWpHkQYdB5AABJOv8fRWpf2AjQU+51Iqw996Wu660I40CEXrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: gdJnnZAkyFQdQN21oWQJUrbi9iQGDpAg
X-Proofpoint-GUID: gdJnnZAkyFQdQN21oWQJUrbi9iQGDpAg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a callout to configure a backend's unmap settings. This
will be used in this patchset to allow userspace to setup unmap after
the initial device setup similar to how we can setup the other attrs
post device configuration.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c  | 6 ++++++
 include/target/target_core_backend.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 25f33eb25337..086ac9c9343c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -960,6 +960,12 @@ int target_configure_device(struct se_device *dev)
 	ret = dev->transport->configure_device(dev);
 	if (ret)
 		goto out_free_index;
+
+	if (dev->transport->configure_unmap &&
+	    dev->transport->configure_unmap(dev)) {
+		pr_debug("Discard support available, but disabled by default.\n");
+	}
+
 	/*
 	 * XXX: there is not much point to have two different values here..
 	 */
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 773963a1e0b5..a3c193df25b3 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -37,6 +37,7 @@ struct target_backend_ops {
 	struct se_dev_plug *(*plug_device)(struct se_device *se_dev);
 	void (*unplug_device)(struct se_dev_plug *se_plug);
 
+	bool (*configure_unmap)(struct se_device *se_dev);
 	ssize_t (*set_configfs_dev_params)(struct se_device *,
 					   const char *, ssize_t);
 	ssize_t (*show_configfs_dev_params)(struct se_device *, char *);
-- 
2.25.1

