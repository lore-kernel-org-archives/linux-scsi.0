Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84D4CCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbjIEXRk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbjIEXRe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E801B6
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385Knnut009401;
        Tue, 5 Sep 2023 23:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=hJi7gF7W4IMBy3HnZ99YekM/GbZ6vP7twLnLbOd91OQ=;
 b=EG45FpG4jrtV7ikBe3Kk9M7/G/i9L21cSPw8cS/LvE/NQHRzIVRJQvuUIj1wtHGa5Q48
 VFu9jEs31UJhmqrXHs8eSAy2TAy/sjy8pD6IRTytZB3+u88u6Mnyo13SWPxxHXtLonXy
 vWgC9gs0hGnDrTcYegil4FNo6cfEehTQRYEXJQ8D7a0YakVSI5DKNkLZlp53ZCaWePCq
 MFu6cNQ4j36Q/ECTpknHY3nUjAJCLbnLNja9dED+Glmbnipj4o2VZfq2Lu+F3MsPKoZt
 XlR/m2P3Ei4IB4AUcdEzrmz1rIX2tV6TWnt2P+pkwVmWvQFhIRRWo9nPq0BSeMVK6XKk rw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq3894q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LwVYm028173;
        Tue, 5 Sep 2023 23:17:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5e4hn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPcQ4fkUwVfcXEwBnPdKeB+L3vjHFdDAg40Oa7gH+IkT4+T/TNUB74vGZLxp5k0VPmT3S6wtWb3mISL0bOb8jY5tMPVd/D30k/IslwF0tTpd7MtATSbttCxCrb4fC18txV4WlYUXgiImPzGNrw6e85ItAT2BpbhvDs+9J9vjJrz+dEGecTcr1IqNdfNMX5vlVcUJAQUbUK+GhmTIydY6yBwOSdtR5UPpV6uKm8di6IfwfVnCt3S337vxr/F9wUu4GJfj314yPqyfHsSPX53JNissMNUWH6swzjv8Vi3ET/jf3sp+lviEvib0bYAj0prWSEVatbXayf52GtDn1ESu/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJi7gF7W4IMBy3HnZ99YekM/GbZ6vP7twLnLbOd91OQ=;
 b=j1BWPmKQB3bVp7Ew+7lLSiLY7uKh0/ANi9RMhVHbYsCLtrfd7pvwURqRQqR4rYQZwBSTU/Q6M2EVT9bkdvSt/T6DZ6cE/9XEybO7Ky4B6qKRJRHAPmrm2zyoWMy1r/viTDsWtLydBfjaA/5pOu58tUXYV5IyMAK4i56Z2oYkYHANi3PWkvxuelQTgzdliPtxMY8ozLsiRu1zuP1uDDJqQvTgV89/E4X5GWXGuCEU7gGZbx/f60izNfVDcxagRAPrGOysAZ5ZzS+SHkULxODr4xkygfQBZiKzx2fdn32MLzO4Zo1ki9OHf9BrbcZ6VF6eMfR880Uf3z1rhabrS5RJxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJi7gF7W4IMBy3HnZ99YekM/GbZ6vP7twLnLbOd91OQ=;
 b=LGdWt6mL2R7h86PYuyOZ0dFcTFauDm7uilOPVPG9P/HIqc1YI+DMop1X3fBGpNeXBTiZ8yajunjGLTqcrWs7AZWZnv7b6Wr52CA69WkClttCZ8U8XtI4gbBArEVe+24CC6yMsSa+0NcwXwTglJhtQWND66HM7B1IbpknaNvGeC0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB5748.namprd10.prod.outlook.com (2603:10b6:510:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:17:16 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:17:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 34/34] scsi: Add kunit tests for scsi_check_passthrough
Date:   Tue,  5 Sep 2023 18:15:47 -0500
Message-Id: <20230905231547.83945-35-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0144.namprd02.prod.outlook.com
 (2603:10b6:5:332::11) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: ad0a3bbc-d065-4c9f-0c3b-08dbae662f4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6dCynh/PqvEvYfQmpcbNP4Wda/6iKWv7y3//j3oK3tsw6HuOoxDzS1g4EpfPfSJ8O9j5+z3iTgVuYAxIRcq5lp14TatzmUwzb1uGEx3tDWHI/fyV/jTKwJoEDpy5Ome3xrshh4B0wkKBwevWvJOjtgMBwQI9c+ybQzmNRDBFTh7PepPeI0sDoLs7MUvnrTRpLeOPqCUpzuzhvEvcrGVsniCSqcgI0PxxHGSE11LzxJUsYq+QvIpu8v/BxPnUO21qgkP8IkasuN4K9AVmmnDIfA7ZKbdEbho4iVo1o6ZbB1unJzOSRuzjJWT+IBdshm/Xa7gQC44B/LHlptmjxrD25T2ZVXOyZv/idqHwwzv76kQLojo6XffAaEvu8g+lGWtuX62Js57a/xYlt1YoWI1NISsLsbiLK1j0nwnjQAIVDLLWiZ3vJDiPb90pl491dn0YCSLL9BKXnTVw7FUozd+BiKUP+ifCCFy9sy5bmDhNjHkr/p+cxP4sHaHyvCJ2U5izwt7Ahvz38CK1ritYEZmEGuDprXsvrYc/P80JX5uhjVjqfU6+GMkb2vwdN5fc8pLp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(66556008)(316002)(66476007)(4326008)(8676002)(107886003)(66946007)(2616005)(8936002)(1076003)(6666004)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J+CqRDJ5Xk5q75uDqJjcuqYM6eSXX6EMFkwouDu5ijuK7xYULuaA7YleqS3Q?=
 =?us-ascii?Q?Xbcb22/Beyk7W56qAEXTGUeUs7FWI9DWto+5zZY1azsa4aD+ENbuEaI1IBO7?=
 =?us-ascii?Q?FSa9IM9lSpgu++6Wb0e4NQHVWfqTLWWERqgh6d3p958EVh9AWfrE0c+TvlYL?=
 =?us-ascii?Q?PJzu+BsBy83nHxQ+NC3CwZZomdcVCaE+PCY/wrtteZW46cS4Tdyw2zMfDKDe?=
 =?us-ascii?Q?CZl5zp42ABGYiCZzyRcA96MBW22ZIfNs55kmwR9srxCsiY2KdjfyL8e5bghx?=
 =?us-ascii?Q?CAKzKKrZC+reLZGRuExtT1AgifOQpJUVLcrPtuG4oXnIVmiXlnyd5rpWupAt?=
 =?us-ascii?Q?o9zRmorMKT3lVhTz3lSzjvWaoNv3IojO7Qe9x63JXvUuk9fShFcyJmBx6zFk?=
 =?us-ascii?Q?Q18rXZ8/Qcvh76HCpyYCXHKgPp04ZhUQ9S7yErwpPHCRpgxqgYGHY3VE68vm?=
 =?us-ascii?Q?b1jCqPhDI63abeYsrElS5xMUqENegDkcRKnGjJzw8LMFqDB1pa/YVqkTvxHS?=
 =?us-ascii?Q?qSV+6OPm/rAYG3icNBSkRWjFTACCPnik9V4hPMoeZ0mAmIsUanYpuNDMe5RU?=
 =?us-ascii?Q?no0cfPLe4YwoCRTmOEf6cLcu64zJQqsdVm3rb1TkVNfm+h2rsdV8zWli/dgN?=
 =?us-ascii?Q?bmRlTiLyLoxKVVyZeaI6lvaZ7W2IwJrBQuW4eQeSMD6lMkThzYfKsPhLEqqX?=
 =?us-ascii?Q?o4Ge3mYVLOFOCgUybiK+sWw4ECIk0mJRDYjwL+gYHRJwLHg4MijBeO5QPFUe?=
 =?us-ascii?Q?K1JC5UxwZA4D6mMvFEFLlxwu1JqVhCFp0kLwdUSlAg1BuU2qVIQWmF+RX0H7?=
 =?us-ascii?Q?zc/wa/sbMMA0XG8VtEjzlsp/atlzu5IRiKrzDd2V7EQVkvbXLHlWkkcXw11Z?=
 =?us-ascii?Q?lqcgFJ3TUNyR1Hi5diKDiasgL2yjqQ9jWgYoXYwLZ9phBXDLVbZbx+1s5Bh+?=
 =?us-ascii?Q?UCnY0vCElNkZUNbYF1oqd2ygreUuiLRa37D+ELnTmD30uEOdMI2SmqgYqjJC?=
 =?us-ascii?Q?GT67zVcJ3Sdpuv3P+z45NjmAlr0edr3bgd8pIwsf43KWQYnog7w1Se8l49up?=
 =?us-ascii?Q?YRm7gLsmNCMzlm0J38FjJu5znJmRHaQkMkhSp0pTv3NEQuSBliEVnBzPegbn?=
 =?us-ascii?Q?3eQ7oC5/X//y9k6wucjbU1mpzv0a/6f4wK+Ca2up24/L+mEPuB0niSqg64Mc?=
 =?us-ascii?Q?CkulqKQNxiaYySd4Ur5Mb2pt8icz2qT//zE1DBRCFa4gZef4myFDJNEW5C1e?=
 =?us-ascii?Q?KuOG7ofAPsgEhaiwB64NuC7kjZfHo6ObXX7nQiIJ2Dkog+Bi0d61C7zWatTU?=
 =?us-ascii?Q?phf8nwuukXYhxUbDimNSQn8xE2OA9pIgasIcRCsQKw80H9ePWo4NjZPufQw0?=
 =?us-ascii?Q?j30gKsOJimpugmVidP8GVgqEd1n3WSu5jTGW/TZ1Z7t+Vj5RGZpG7NaecCY3?=
 =?us-ascii?Q?WuSwbagCeCD6hIuQ/GCMM2z5dDsHhI1VjqP8HGz2OOekF07W+UePFppAH/yB?=
 =?us-ascii?Q?7udta0M+ToiiNvtX3Fnf5yJJhxmIrMIL5YCAVA5lmvfLdTlwZw39FUD3/IVa?=
 =?us-ascii?Q?2OlJCxOetU9Ffm9mAH743EBYX/jWVGONXKVlJhlBnghAD1h9By+yoBd6ZNtJ?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Cgz07qgpYfxtieECtnH2QFuTIz4EN2vJ6Wb1UKWvAroS4/rJ07OeOczmAy2ubWkyYqutnIi11UMS/Z3kAEZ/e+NsDhteZBU3RUcgPzPCRNySW1yM2yKTjqUyGOOvBQqrONa+JEd01ESomFSHI8aW3DWy5K9Gj28FayV5eCVU8dE/B6DuISA7oBL3nYQ0RMYw17RJKCX4ttlSUU973ZykfMlM4SKZShm9NVYmvkukj69AqqAGoLgIp050Q9WbFELFaBJLSDPghDBq6x7f2raWWOLUR85Z2VPGZsdKxBlzvzm0w/AO2Rl8mnHKnov2+UOGr83GpE0cr/zgC0SWYFtw37i+GpbHnGamQjlRBn7RPXf7u1UV6E/+zV2dMRBHzrIHENCzT1jwV42PjpN/C9SIEPeNKva2z7guhBH0E0Cbmzj0T6QIKBPEZ8y34hrS9eVhPGMd6MSylXoyPpEk709UG1G5+3Q+iTAkz7B/6gab89bfcOIAQKQriEbrCqaICcw7cqo0RmInvUJX4oS6Qvqk39+7aooeJOpofzk+X3KlirRKOgwQ2TilLs1S9aUNIhr6eMvDk+DJvgZ8mvY+E/tDjXWkRfwMgqUwLM3HVy+cx+WBqVYxPg8NaNp7PUM0jZa1R/YTndWMXxK4O4nwYHa/SqL/kewNTw32b02MmJnArFYShkhX7U+H9AYgKFOL/tnluO6X3ptWghAxhcMJzUH1elQZjEopp9xig3AcI6ewwGOvgoxmNhyt/Nt/o8tp0cH1/juy29ADUBjYaGNHburuH/930iS8QUB6R58uBtiBWR955MeTNejMSkDDecZ4VYHH+iDXrWSXoAgPpr/+bADCS5ZbGGIcjFW2RdMH2AE8+RLewgINrAH4NLPDXpXb2gWH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0a3bbc-d065-4c9f-0c3b-08dbae662f4c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:50.7617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPXaaYhtsfWBPwOpxfBKEjiwG7aQNb4bmkCfEpm7O7ZlwwBpzpPMBzTNXffdtm7fi7cVPmL2A3XUHk6gmWbTBYwHb/tAokKhywA3Emtw2e4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050201
X-Proofpoint-GUID: _DgxDDwGG9t_QKkHaDq85gnd0cyE5NqB
X-Proofpoint-ORIG-GUID: _DgxDDwGG9t_QKkHaDq85gnd0cyE5NqB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/Kconfig           |   9 ++
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_error_test.c | 170 +++++++++++++++++++++++++++++++++
 3 files changed, 183 insertions(+)
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 695a57d894cd..b7ffb435afb5 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,15 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_KUNIT_TEST
+	tristate "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d2fb28212880..f12ab199a03f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2663,3 +2663,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#ifdef CONFIG_SCSI_KUNIT_TEST
+#include "scsi_error_test.c"
+#endif
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..c01201ad8702
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for scsi_error.c.
+ *
+ * Copyright (C) 2022, Oracle Corporation
+ */
+#include <kunit/test.h>
+
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_cmnd.h>
+
+#define SCSI_TEST_ERROR_MAX_ALLOWED 3
+
+static void scsi_test_error_check_passthough(struct kunit *test)
+{
+	struct scsi_failure multiple_sense_failures[] = {
+		{
+			.sense = DATA_PROTECT,
+			.asc = 0x1,
+			.ascq = 0x1,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x11,
+			.ascq = 0x0,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x11,
+			.ascq = 0x22,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = 0x11,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = HARDWARE_ERROR,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failure retryable_host_failures[] = {
+		{
+			.result = DID_TRANSPORT_DISRUPTED << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{
+			.result = DID_TIME_OUT << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failure any_status_failures[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failure any_sense_failures[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failure any_failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{}
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+		.failures = multiple_sense_failures,
+	};
+	int i;
+
+	/* Match end of array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* Basic match in array */
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching sense entry */
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASCQ_ANY */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASC_ANY */
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching status entry */
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+
+	/* Test hitting allowed limit */
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_TEST_ERROR_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* Match using SCMD_FAILURE_SENSE_ANY */
+	sc.failures = any_sense_failures;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* reset retries so we can retest */
+	scsi_reset_failures(multiple_sense_failures);
+
+	/* Test no retries allowed */
+	sc.failures = multiple_sense_failures;
+	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* No matching host byte entry */
+	sc.failures = retryable_host_failures;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Matching host byte entry */
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Match SCMD_FAILURE_RESULT_ANY */
+	sc.failures = any_failures;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test any status handling */
+	sc.failures = any_status_failures;
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+}
+
+static struct kunit_case scsi_test_error_cases[] = {
+	KUNIT_CASE(scsi_test_error_check_passthough),
+	{}
+};
+
+static struct kunit_suite scsi_test_error_suite = {
+	.name = "scsi_error",
+	.test_cases = scsi_test_error_cases,
+};
+
+kunit_test_suite(scsi_test_error_suite);
-- 
2.34.1

