Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6ABEB64DA
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjGJVo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 17:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGJVow (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 17:44:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E1EE0;
        Mon, 10 Jul 2023 14:44:51 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AHEkNF014126;
        Mon, 10 Jul 2023 21:44:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Exk/UTQVHft5PNvs3T/b88CdOsrZPbvupBPycvFeLLY=;
 b=bLvSIQ7AnQkSwxz401MkhaSxI5KXr52Unk+0V/lLrDMTeQIEB+cr0uGZeoAAOdqG8rI5
 Jx48gnYS0TNLGaLnoUlysdIGI2VbwnRX0LK94HwbmAUwNPYXT4wtGVvMk8Qk/Ukiwaf6
 MXT3xuH7CNIrlZ5JMzPy5WiCSGAu+rWXnK+fUeavhljYom826Ba9gGoUrXXrZUYz908D
 gJ3Yb8ysOxigq/7rN9sgnDIoxTeIFwcn2eM9HCr+tcUnk/oRiQioZxzQqRR927dZVXI7
 jZ5RXYvNkfG0pLmpl7Wjofb+AcJxcimYcQ5TB3hahUCFwAlq0jZeBdjzImZcgQcrp7g1 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2skhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ALDtCH022849;
        Mon, 10 Jul 2023 21:44:49 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx841rq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2M2aT3E7DR4UeAiXcwiiUi9M5HD4mmFPe1vpv26ihAN66CdGM/P9Wlrr6Krq6iEi31zdUlPFpcjlitjhPIEH+eY3bLDplTWGSbruwKD4fJyRA9W6jeaUJiqvZYbPbiBpVAuvXtjnKXqFzDesHUsgZ5giU0n+36eyygr8Y3u4tIQGnoLLe7FsJkPC21sfWnTZw+SOb1RPf9978lN8sNluZBDtJUPicEZzNJSeu4Oy0UsmVwIRmyXqCgcem0ADABPyiIhj+MF0LgPDC1j7RaXyf/hxRS78i+7jEDTJ7yXY52yOweim0xYQx6HbX8t6basdu0dgOiIzdlvf1VNZN19CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Exk/UTQVHft5PNvs3T/b88CdOsrZPbvupBPycvFeLLY=;
 b=k4b8kVMck+iQP2qG57Oa5HlZeWL/PoJDovcvDBIsn0d5LXrdjMmbE+ObsrZkpw+aJnAaVrV/jYRRw1YLQqjkmehKZd7fm0a+lt7gBPo5LlFm7OGJ1+2w5Dgf+NVnnEgt9OFEJNJaErsVsk6CB4q0ho4tFojr8ovruN0pEgOnyoEo0ubOU6IgNIKG9j9tnr4sxFqytlrCINouD1rhnn1vj316z4dWDSfpZBKOoQr4DW+flUt/e5ylFmgM8bxwukZ/00W/CtwE5H9zb9JMB3sEuoLNinmW5n5x9WNsYzwugub2y16AK0aq4MvVHJEsTNClTTdB8K2MTGYGl+fmO7+P4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Exk/UTQVHft5PNvs3T/b88CdOsrZPbvupBPycvFeLLY=;
 b=qqt1ESYNNhuhRvHhepVYV/POUmJ8u8FCPYwZg0qyL741j2Er++niZizFrflY+CY/1lZOuI6ykFe7uJ+Pr8i/LHesifIISPmTj0C3o5yArDZCjLZVEgpu6n4eevMFasf0V3p9oWiwXEuEixsRBNQkMyRObrW/XT+MRi6gHkA3K04=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by CH2PR10MB4117.namprd10.prod.outlook.com (2603:10b6:610:ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Mon, 10 Jul
 2023 21:44:47 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71%6]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 21:44:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/5] scsi: target: Make write_pending_must_be_called a bit field
Date:   Mon, 10 Jul 2023 16:44:38 -0500
Message-Id: <20230710214442.6718-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710214442.6718-1-michael.christie@oracle.com>
References: <20230710214442.6718-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:610:e7::23) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|CH2PR10MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: e45a7e61-95d2-403f-f432-08db818ee1b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgNFhZt8AkFKrgC+pFPN1osLJ6rjmykVcpXPUakeQbBykioSDsmGmC/vN2jDBTppu5p00qgwUWw+xuh0cYIqsHe++OlH0gbQ4Pr046y7CbvDMZuzvZ2oLZ/eMPhk5v/TRYUeF1bOVnSSuo70rtqZ+V3Q5jlfDJQ7tNFWDnr4HyXnZJkK0TmzLzSR8J6Aa8leP7/DUaKdTa+UWX2/9a1COOF7cAI9K+ZQYoA0m0ufKsyj4AzfXg0HpYCZpcL/8bPJouf+1QTTds892KOPHU1mU0aAWgorApZaNXKji92Myfw0y8LwSUgaGf/ckLOL1CE16BF3C9ozvohSOMW/6xm8RF942T43FW+x1DmmAx27KnSPL65iDP1RpL+khAw/RWykrSosUtOy615zkcMz1l0P6FHwmNHuaXC0qEj9JlLoggVQDbD0TKjSCXtinvxtA58Wj0Lm1GYb2RUEjkkdTY/FRC1EsN8vjprZwps5YGcmUqBS0fkpIWONzvUfl7lvXTbHWfDvo2GDYdYUavo8Sd3cvnYS7uR/73cDJGQwdYVoSBTbWgo2UhMCBZrfMfKvdf+L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199021)(6486002)(6666004)(478600001)(450100002)(6506007)(1076003)(26005)(107886003)(186003)(6512007)(66946007)(2906002)(66476007)(41300700001)(5660300002)(4326008)(316002)(8936002)(66556008)(38100700002)(8676002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pb5K3kUUHWfnyExXiPGQaxhxsNd+7gxb5d7pu3PazfFLGQe0zwnJrwB6ZBc0?=
 =?us-ascii?Q?8x+jRvIC91TNj001wPKn8SXr4HS4PkWn2UzaaCvuGdsOs87CqKOrxDl7mPwX?=
 =?us-ascii?Q?SCYD6FEQu3TPBVnmVy5Aj3zF3Taloywg6B8+sOqifMa7LBiQA7uqin0kbAZc?=
 =?us-ascii?Q?HFnfuuAbR7lT7i3wagZzDWFYD01QNV7Bgr2HtsKDTWUCEuIvhty1Y2OsTOC0?=
 =?us-ascii?Q?TakHPsawb9S7j6+I2ZgKEIqsBNA5QN9UUvpAlT2bdKjkq3cME6cX5VbY1GpQ?=
 =?us-ascii?Q?U5hGmnJI0FFT2f3QcPuL6Qyd0AliX8wtK+8E82yhpPGgQyBmVSB8ic1922SA?=
 =?us-ascii?Q?epc/VmgjA8QTWqSH5RSScvoqcvZPlCDuWDzhA8Fr/zI6+0WeVVvNO7zi1BaB?=
 =?us-ascii?Q?D9JhMDz+NO+2RIDR+AhNzgkPOx9WawV1jki6tM74s1/AQSe9K7b+SPRZBZQ6?=
 =?us-ascii?Q?LA6j32abRIl2hJbbJ3EIy1KYmthDsVJKs5n3n0UOblXYcMe4otvN9/WK94At?=
 =?us-ascii?Q?oqnU5h/pnGwFvpVZ1roUzOYjKqwk6qZu7D4HWLu/oMXGYLKkcqqSpWcZd0b1?=
 =?us-ascii?Q?Y5RXi185QntynuB9mlnJe6iJggWR6A2bOwNopCcAnoLmFnhhXIYXAVITE70v?=
 =?us-ascii?Q?90LW23tPGsRVu70L1ZZrMZbLaFxSUIMyldRSjKH4wVOoaCfuDMzN8tsRVPSw?=
 =?us-ascii?Q?UY2ZdbcMBqg+iafMKEWQTGIqJjcALfg5qiD3z8DhdjOJfMaSoYZnBW6WXFmV?=
 =?us-ascii?Q?9vM90jVpWnAwD/e/5b/CXFxUkGy7ZxsM/rEL6NFxG85x359JEKAci/I4FS2w?=
 =?us-ascii?Q?x5KZkH52qvvaY3DdLSSNofLFXfA0sELc9zbN0fX489Bjr+3JcLlO00WzYhcY?=
 =?us-ascii?Q?xIkhBI/Vj7bK52CLR9D+LaDunVipieKVazgyjdqqHd49k8TXxMsUC/uaseW9?=
 =?us-ascii?Q?y7wqVjyJDKzp6KeTSeb+aUUMPDGApsxf53Ez0TK66+UZkC/DVGQd/PzdA9u7?=
 =?us-ascii?Q?wkYNYvKdrx+0fWhFYFKKH1Ktwe924wMNA/zKh5EtcCV8+87zH9mAnZwSuhRD?=
 =?us-ascii?Q?RPBtFhcn3AO+L4e2LuzLczDnYeor5D5KJT5JVlZPL/qWW51izB8KFjlubYy9?=
 =?us-ascii?Q?LlppSB/V5Rz8ivmJ1aO+m0s48tiVde+TS280hUbeSP6PpYoJ3Bz1f1prnBgW?=
 =?us-ascii?Q?vY1JDwGwGdi0pGUnSJGctrMSNkhVRy34rBD6NYVS2LqYrjoZWd5CSYoBhtjM?=
 =?us-ascii?Q?dcNSxlCvTDdPhAkK2WnNIPlpaTPABnZ1gh5rcbpBHGydXq6d+El5UeKRzaFa?=
 =?us-ascii?Q?w92GxBzJH6lIYp7j5INO9GEGmgEuUyjvczGu38qH4T3YYWqrQ8VMVanDqJ7m?=
 =?us-ascii?Q?3AUJwFSgdRq4eJ+XbUMNRp3WHJcjDCHdwjxOzJkqMRDCsYp+PbOdkw+uc1wa?=
 =?us-ascii?Q?46keSmcBroulJ7IeX9Zm83YKl3f4SSYlhn+i2TvPjoUARH3Y+yyVmS8LfJLm?=
 =?us-ascii?Q?E5mpaU1Zpgp3rZ9ua+O3TFIBDexyyytNx9fwq8gebG2Nl9Dv+CkdhyCjRiNS?=
 =?us-ascii?Q?kishz84BMgcsljkT5u5/NG+b2j4sN/L+2viWRZ/Vp44hw98RIVOnEPD7UXCl?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AOVptyzZV0NnrUNBoPLS0ChNfELIHpCs2vN3+VD9ehb53/ubfxXMKA/EmRj9Cbwn78SAC4AEJTNXH2XTq8bYvMhQV8nA++SYhMxHZMabSCKNf807lLg72G6ER6yPAoYCWtPBXgY5vuHAX7Afc2+GQq3D4kX18aWM7bwsZAeBQkTwzXD8QqC9HQdckZdzCru6ffNfFvUc+gsHPtD4OuF2vf1+mYxb8txuLqK6+sn0w3a4kfQg4tQJH08hC1oeR7BquebpB1fGN8VZV7DSs+hsduvqTjqBVdMQAU0DhDQw8KATWdyUb1anyDa0Zgn+d7St1TRhFjyVCZsyBXfrZgJA6ojd+ZcCM/jqebxsmH5DJ5CxdoJiZKSQCcax9AdInjhTf3QxfgiReKxJTsGQoQIEgC8H8Y7o6BIM6FUvwxr9dgI9MLun1swvJ1MQEfwq/KChvNhCl493at+eRvDJOABlzL4xLR8meiYddfxWY4qDiJj3cXZqZxVgScts/vLOPt4kzMmUgbxlR77dkMuWN5vCaeHdkVLPf50tlDAPOr4Gl4DdEOSbXCfb9TaKoV1RRAKfMwoGTF8O6UAqMhvhkk4BQ4FhNqIkqs6LjnblIA6Tfd/BUHoq6wQhFLqIL+epwaiBxZzvYSmwIXaZyLiBk3HoS2WK9LmBC1taLhBuD4gaDfxOZFD3OedTmyEXQIgIJzfmVhII1/ToeeMtrk/dSeHpZomMzxXsXkWp3qKBkCEkNfKWxdMM34hCVnxC5vnN6l6KuaTgIE24fEFM2CYNIUaW5g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45a7e61-95d2-403f-f432-08db818ee1b9
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 21:44:47.6942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPvnJsLhEY6PWiU9u+/gbm249uPXi8lly/HHqocR3g1/OUnzLSi5fNl/iCxa0cWTk11nwAt5p4w5LfuCr6KohX1t3qXYtzU7/4I33+2J2u4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_16,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100198
X-Proofpoint-GUID: 2IGgM-KFqpm6gsJyHBoTD9lqBJA-giQq
X-Proofpoint-ORIG-GUID: 2IGgM-KFqpm6gsJyHBoTD9lqBJA-giQq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches add more on/off type of settings to the
target_core_fabric_ops struct so this makes write_pending_must_be_called
a bit field instead of a bool to better organize the settings.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 2 +-
 include/target/target_core_fabric.h          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5d0f51822414..620a04e23be1 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1591,5 +1591,5 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.tfc_tpg_nacl_auth_attrs	= lio_target_nacl_auth_attrs,
 	.tfc_tpg_nacl_param_attrs	= lio_target_nacl_param_attrs,
 
-	.write_pending_must_be_called	= true,
+	.write_pending_must_be_called	= 1,
 };
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index b188b1e90e1e..2a6c4c935666 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -113,11 +113,11 @@ struct target_core_fabric_ops {
 	struct configfs_attribute **tfc_tpg_nacl_param_attrs;
 
 	/*
-	 * Set this member variable to true if the SCSI transport protocol
+	 * Set this member variable if the SCSI transport protocol
 	 * (e.g. iSCSI) requires that the Data-Out buffer is transferred in
 	 * its entirety before a command is aborted.
 	 */
-	bool write_pending_must_be_called;
+	unsigned int write_pending_must_be_called:1;
 };
 
 int target_register_template(const struct target_core_fabric_ops *fo);
-- 
2.34.1

