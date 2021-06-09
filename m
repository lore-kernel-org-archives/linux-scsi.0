Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549E3C48BD1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B4F360FEA
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhFIDlb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbhFIDla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592g4H5083678
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nBjNA4GaXC26hV4+toUfuBaHi0z4T/z4uNwx2Qdj/x0=;
 b=lY64dealEFNJP2WXLl9Sw9nsFfbTcfET2o8gsmxc/LVgZjMCp0ID8iLpet0rg6HNLEC7
 Sx0xO/0LBg3zS2R3h8OqZsiG6sPKWGk7HorN1O06Oq3XJ/xKN7qAbKlB2h0SvZFN3oWw
 YzwjTNq5ThiyZ5qOjqIZUooIfd2fMjYMQZ+Zg3LaGuoOTXdu8hJ4XWEx4RX/gCgeWi4v
 30vnmT9mXn3z8KgaRxYgBKJFIcntQHDrlKfrkGRDvoNWNX7E3/BxoWpNNHSJa+3Gc4gN
 RzHZglaJ6eDywzYuh4ZJRt/QiKGYSuLPg3pE4/oTQDTXBnT9ZUFt/WR8PLx/6I762Gjb HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nfrdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3gw082802
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 390k1rhr0h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKvQfX4//dItGnpZ7WlilxNWjO0ki73jZfgiIHLMhhPUqdTrfsj/I2wVhfnA4NKFiAXjSSuL7qmeXPOwsrNkc9D3T26EXVVC5bJnBOmR7b2eVS5yFMf6dNldQlcjAATGWOKGwlR3Oo3vSYyPEZes5/Sxu2aAH6nzAFh96a87O14irQWn3tGbehyJ9yo09iHh/+GZRC4OL3ziQvVWmjq8jPM0BuKLmS7IU5Fscolm5Vv6izIhkCCSV4EpFqfV1qQXB/8lNhVE1X+jvrM33pNRosgoa9Wtqv5KQ94ZMs9lWRfiGPEKouROrEGTApFr2LJ68U2fMFG2SaB58SbBwZp4FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBjNA4GaXC26hV4+toUfuBaHi0z4T/z4uNwx2Qdj/x0=;
 b=kuvxIAbRO4e2AGGF78QG+Nztw9O1i3lv3WxWkI2AmgifoM4hhrpzfaofbkJXTLZW7xQjq7V+HrReBNcoTijcHLCtspIGr9pNrlK1XO1QVbU8unVLLxzy0UrMx5uqK2jm0l0llxqWzPMx5773kuWzGX/4mP/XQJaJ1NIEFEYDdMmrtoAIOER1fSY60Ecq65YyYPbPxbZs+6W1BeORsFBuBWZHzGiAlG96q54AqhWWW5OwVMIuaRjvugIafOCzqkojcobRI3Og62LNOzVgtV7ZJ8wuN/Ly1NmddWu7DtP1lAsXTFPXZDJlrPZ8e8K2VJy6xwvAA85HECzrqdjT2dkjkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBjNA4GaXC26hV4+toUfuBaHi0z4T/z4uNwx2Qdj/x0=;
 b=ABGbQqdYUQm571zyuFW/vR5+5syc8Fpy1/Ei/BFYAoz1/KVyJOzf8h4ZkeB14C5WMnAIof4armasVPMS7R4B9BImKkuM7zXTDHvcfG5NEZjmvjbEpLvlmkIxN0QQH2y4vOb4CRkp3lsW43iM2YxXBZZoD7bhc2QLqCP7bqEBlzo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 01/15] scsi: core: Add scsi_prot_ref_tag() helper
Date:   Tue,  8 Jun 2021 23:39:15 -0400
Message-Id: <20210609033929.3815-2-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e723e8cb-b6bc-4648-6fab-08d92af83200
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422FEC14F95EF9FE96F25FE8E369@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FFR9+psTFR+TlPezhQh8kMbKPaSmVi+0/oQdWF5thy42Tb5RF5JihBV+BFwxaxr+grT/tzXcWexs8BMF0PIsT7WDaqLixzriMdqO4mlCCEt28au/HL2Xfu3C2hhp/nWzaa+N4zPWgBpeIcAc8kmbfK71PEl72dslWz9NAbotSe6ESik4PsvsT236fpOQHlEEnOLrU7z0jL1LxXtdVR4XKHjc8P067qzOGSHOPYkA5vwHAHkWsFla393i6uzHsNzTvtcgEY93HLdT97O6EJ4Ggvukn0C/HIGbY50xs8Oh8tQUX7fMPzZbJU/y2/2rN3H0AVL/Mt3Nc1ZQLRgnU9kaBQh8QYbrGRlRpmHaK5ZamexCHqXWFp19Ku5OdT1AB53aiH3sFFVKt0K19HWNj9LKUj9xpRmR6F+KNlESA63mQWzYF8eSgd25Yg3u69FsxB4p3UgJH6vlGlKeBcKhFN7g+t5UAIfVRR35HQDuizbzKKSIgX0UcYt0Cz01xP9iJzvDZ7LIdqRtrVxaPzg4W1JpJgywr43y774VgLCI7Yat/LeNgWQa0n55EqrLC06CiRpGg+n3dqrXbxh4DzKoUcHwSyFLMJIs0zHCmmnWXolQ5NuR0Dct0ROxDtVVexZALfLB1fN2/LYhZV4x1JNV9CnJTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(1076003)(4326008)(6486002)(316002)(8676002)(8936002)(66476007)(186003)(16526019)(107886003)(66946007)(38100700002)(4744005)(6916009)(26005)(5660300002)(52116002)(478600001)(956004)(2906002)(2616005)(7696005)(83380400001)(66556008)(6666004)(86362001)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FKBeSI0eG7F5ZTN+z+NHQQfuyQ3bEEz87tdCh25/TQqq3KeozkuFPZHc9wSc?=
 =?us-ascii?Q?f/k+1qnmpS7CD+IIMXtS6dhRLI63R2b+nr5qsNISmOOwSK4aG+eLQRyk3fA5?=
 =?us-ascii?Q?f7T0pramGvkaqpATHK17bv83cC+RpJxtOdP4SzOsJfjht5Xdhe3+2wLWD/q6?=
 =?us-ascii?Q?/Nv6F8Z2sywIIgV6o3q3qIhCuxiiazEZ3TPC1suAbLh7V1Jya0tTkH1vUkU+?=
 =?us-ascii?Q?iGUBxKli5W2IyvOlr3VmTsPCQbQ/O9uvwalHEQsCnoUwTsX6DCMt/P7ZTv9D?=
 =?us-ascii?Q?mfLN/JTQxY92rSJ1GVgNTff2hWcmSFTZhljbzLSHyRoe702QpWU5QNADcSR9?=
 =?us-ascii?Q?8a12JsP1POq/N0flnHo2nmZL1oFh5dGQQuYW/fb6/z7zH4qMyNZlhBUVLzOJ?=
 =?us-ascii?Q?dD/kXEuyS7ZqMwnC3S6enXGqDziLWduccceZpgbdVs9/93lrdr5l46WVa225?=
 =?us-ascii?Q?PmMce+t9EEB36RLz88o9JhyIE8RAzoa+U/jC7fgQBHGjAzmG+smyP74PHBBT?=
 =?us-ascii?Q?gtTkPSJ7NPO1ReGhHQjuweyWFv5fnwBIkeSdq0rHcRz9SSOTKlQ94fWbhpaX?=
 =?us-ascii?Q?7Q8oiv37ZlHaqZTb8tdd4UG3oi9Xc742HXGpbR5ks0XoxXlwT6CE63MI4wX1?=
 =?us-ascii?Q?pHkO9BA+ueg8jUmE28rj5VPXAMELAtP9GcmgU3XtaLV/OvvgojSupxiZcMzq?=
 =?us-ascii?Q?4CclP6N2N0z7LdgLHWX8iNLFFkmJ/1TGNL0mpWLov0FNT0PpadmrYVm19Lwv?=
 =?us-ascii?Q?z2a7oTrs4Za4vS4rHHHIMFWxZplsFd4mWWTUU6WD+5NrPKEvmGy9VIO4eZRm?=
 =?us-ascii?Q?wlisi69OAKKgujgjhOkLMqK+8sUSGFUsdIKCI9gQZ3NSUoYyYrC2NZmfMPeE?=
 =?us-ascii?Q?Xbk/TSqjOulGKb8NeReNWAH1VyjvgdrH01f5w35SIcyZWG+ix39N25jhZjZ3?=
 =?us-ascii?Q?kEgyQIrdVrxwkJMwpYIYkak+s+eytw1+32eDVtvYb/w1CnISLSAvOemmX/5/?=
 =?us-ascii?Q?9XJ+9wMZo+V//SfDURx45L+8AeXIrBNRB2dwqt+0i2B9AZIkkBqErM+RnWzl?=
 =?us-ascii?Q?G+M02I5zthJHj7MajGB5RC3DlmojFTgFa0dWuEXsYYaY4M8H2tkFPsJzKP1S?=
 =?us-ascii?Q?6/w+e168wu1lmDdFVHjQo4/2y8Dli1N0khrBDVKohUBK+eRu9lVnpB8s3lAM?=
 =?us-ascii?Q?wFNLhtTyKN+dbz+aerzF5nAQXImScJvIleTSGqEB4r8pz00z4toFwzrGma4q?=
 =?us-ascii?Q?iDrLU1vfI7g9rTc3R2+Xn/yi1hsrlrinXyGXDoL1ab24eGq05oBjB8NNbjDA?=
 =?us-ascii?Q?ZkLALTTGvwy5brybdLuAeXw3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e723e8cb-b6bc-4648-6fab-08d92af83200
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:33.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+KJlQ378awraft5kgMrmT8e4MvE1CNIXfO3v5++anqWT0sE8gv+zYXMoWD0XbQpDjmRcV/i7az2sa6Yh0GKgP0JVvedOJRePZLQj5fC4AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: QqdOomG7KV_tX-MPvTSHME_jnTXmzPCP
X-Proofpoint-ORIG-GUID: QqdOomG7KV_tX-MPvTSHME_jnTXmzPCP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are about to remove the request pointer from struct scsi_cmnd and
that will complicate getting to the ref_tag via t10_pi_ref_tag() in
the various drivers. Introduce a helper function to retrieve the
reference tag so drivers will not have to worry about the details.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/scsi/scsi_cmnd.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 779a59fe8676..301b9cd4ddd0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -287,6 +287,13 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(scmd);
+
+	return t10_pi_ref_tag(rq);
+}
+
 static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
 {
 	return scmd->device->sector_size;
-- 
2.31.1

