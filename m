Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D982C4321E
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 03:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKIDLe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 22:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiKIDLb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 22:11:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB74D1B9CF;
        Tue,  8 Nov 2022 19:11:29 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A939ahN020967;
        Wed, 9 Nov 2022 03:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4wZinNb7GU4J8atxTweXVJf6JAdF7VYCnK0Biq0fjc4=;
 b=TlLYUz+Oh/ajkgKwuzlLXJllD/phQhX/VdGwlW/hU3TAaV42SKaxiMbSO3OhE4OKavi2
 iQg2n80rvjWEydF1ouu9iQqbzHxGAVobG37u4bmMkrTvtkGJz+i5vRog3ij4KdpSU/Z7
 80OP4WvcygNMVRWWepVJxuKbSW09E3Sw030WKVJS0qJ4k1Ni+w9Zm9pN0T63ENjdM3Ef
 jkZkcYPa4hBTOgaRKjVVOWhFZY3lmG+b3Q0vb164nsEl67u2rD3lsbvyRrZvYuIQK40s
 h1Wsy0b1De6x3QGVtFoZyLfVo4F/zzSZkpxioYQZackojJe8LG+QHCLRRA9xDK8RjkAy Lw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kr4168044-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:11:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A92huOe036292;
        Wed, 9 Nov 2022 03:11:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcypndxu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:11:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyWpkJn24q3LHFbH+kVJ1tEU/hPUPSUjJfNCzQTOsOXVfLM0AmqJucbDCD1HMxvAorTERv+PC4TWnxLj36Xg4nH66ft069RkDS4VnY6cOMf2JsEtRw+FUE9BJCFD3pgKDxHMqNUAnfQNGHARBXXbEDhwV2kKGig6bN6AFYj4u29RmpOhmFr1+H3JLohzAjPGVsRgNFX/EM9T1EhlYmtYwQOxWl2qBHFZZB28GlRyvzU0XxmSaEdepjHsD4Q6WpRK5QVxRSy8MYI0NC6J6SutQYXUsowqez7c6Ae6wivRBJtefBo9XYJ4dWJD+Rn1veKhWMb0DWcBTd4C/g+jDeeKdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wZinNb7GU4J8atxTweXVJf6JAdF7VYCnK0Biq0fjc4=;
 b=Wv1m1y4U9wpzAk94rnSe1VT1hoFMfb9VkSVMuA6IslHywnF3DzbPl11q3QESstzsM7SOLCifPBgKuIXYlQcUETnxJcjT/B+nbtWA+WlxHG8CQaO4BLRQmpwOH5m5WLSleyvbgr+UwuBXxQA8CCke3m9xKbl4mRZ3GPT9h4410YyUKDbUQCGFwS5sv+8IAkUl3NBZSAvNU0Udd0MJ//bMCv5FHoomltj/KOLawA3x48iHvTYFxVd99WHChl7+3D1qOsyOV9VweT3byQfE/9nrWyHfYLBnYhPnzTAYDLjNLQJXp5Fe1bkgNuxkbqO18IOZO8if7R4g02fdJ6B1h9ND+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wZinNb7GU4J8atxTweXVJf6JAdF7VYCnK0Biq0fjc4=;
 b=wgvMJdxEE++IEnluYhzmqmxAKj78fBDeld0wum9kuprYehC4aSlDab5TsXfZfWRpF4YZls07eirM/rufc4EGxtYLKlrRobVr+obnR0JEZGraLLeWNWqBh8x45QysJ3vXjJGAM2S0c9DlTd5QivDvDGXIuOmbPuOtb/SgGNLP9Do=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6033.namprd10.prod.outlook.com (2603:10b6:510:1ff::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 03:11:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 03:11:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/3] block: Add error codes for common PR failures
Date:   Tue,  8 Nov 2022 21:11:04 -0600
Message-Id: <20221109031106.201324-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221109031106.201324-1-michael.christie@oracle.com>
References: <20221109031106.201324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:610:b3::9) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 6785ce9f-5859-4ab6-2118-08dac2000d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmGnI9Wer5ytBu1wlGF7McagbS8/rw5qMXhCKyT0PvjwM1DMpFYnQe4M/XoLU2OYDl6fIXuR4Ft090HL8rCL8haIOlRZfOgO2BH8vxuGehq5AxHlB/P7Bc7nhowYY44zw9q3uozc0EfL7+FVrjM9j6z06FoXAPOvGQ+uZjcKmnmIqZ3rqXH0M/A7B47rm1Ejnb9AKSSdL+TT27I3qMrpJSLRcNBVtHfF1VrmxFir5E9dfB3XI50uJMudOlYbHmM7TcEmMQLb3GN9InMdlJSN0+DaaINkSggfKSMLyxlgpVTrm7CBKB5p8uryHNVENQtnFUN/OEcNCYZ09S2WdR79drlAY7iJ9QruRjgMh85Ypbpvj/um0poYpHFrvlCifppxqekN4DCGJXD3qxne52CI/F4ST2h21tTpV+0gkdweXIf8N0LnI8N6JJU7Q6yFOSksZfvqUUd5eJ6er73scERTUo+JNrzimjbI9TwMtOG8JZsLWtwj40AK/96GVbpZ1Xl5QAxTWhNdSJ1o0HJBu4ona05+Xv2It8R8wBh5tC+xhtGk4vJR8H0aCg7/gaBUGEqOK2Nmpak6B2EM4uhxmnsuxC211SVsdi3l0QM/kzUh7CY3qDLxLnkR5c9Uzts6pEeKhF5Oz1qDsohsCrFeIAZIN4ha9hBEnQl7Kyib3KDO8xZcvqTDXoxVVGD6aVe8DLVh0T5cuaROqkg3AkOjgpUICg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199015)(5660300002)(66476007)(66946007)(8936002)(66556008)(478600001)(41300700001)(36756003)(6486002)(86362001)(2906002)(83380400001)(186003)(6666004)(6512007)(26005)(107886003)(6506007)(2616005)(1076003)(316002)(4326008)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mZu93fewMcQzcZL5evAbXhgGoi4POgZwmWhxVOvzVvisw7dL5J9udPOzVSLs?=
 =?us-ascii?Q?K7kO/cHqtjjQfHla3ljNH72Wv7Ix7iQPEoGVmBZS8DwDU2UnFdLYAfHadhIa?=
 =?us-ascii?Q?sw5IhanY6nEfdi19UFWRXiFWWALF9MWRMM4jWuPH5O85dJTdViU4HM9F06vL?=
 =?us-ascii?Q?1Y1RyPUH8eQ3e0DeiCk7cw0djd79U4ItVWBdY2o7avvXNX81FDIX9hV5w7UY?=
 =?us-ascii?Q?Am5DzzLLH9IytfI/WN7+T/vGFTd6cCEPlflbA7BOIj/FZ5lyvPlb3Kpwf4OB?=
 =?us-ascii?Q?F2mQlsCpKAFPNa8QOs2cTp+qAxetrpOLqZiEtsAxjduQo7b5VAkzSG5Z5fD0?=
 =?us-ascii?Q?eqrHPrLGyf6l7Hs3RO63qzV1/IPUTycpiLbZ1ZzkD7qoaTW1s0ZvETkV4amx?=
 =?us-ascii?Q?awk7hMNbrOZMb6Ya+LeHlhfKCiybswL+UApxtXVEXMoQolkOFFh+OepiDSfP?=
 =?us-ascii?Q?Jru4Vvxh0X0IGh++8TQlyJ7L2jbR1lcIdDkXLpHVMS+gFN7PP2rxtpRLBe3b?=
 =?us-ascii?Q?5Re+AY5z2min5dJfRxolLgsdHRw0brcXnnucrui41c7iFWIaPYxI8gq6yFtO?=
 =?us-ascii?Q?jGRMnoRlv/lgwVerJ27Iy+LUr5f+jbHohpu9sm8T+EltemYmBd1G7eN6dCXQ?=
 =?us-ascii?Q?E1Uxm1zXSQj/FXDdO3EnX+s4O+d6goO9xv1tGY0AOcCrgZoqyQkfaLHo97EI?=
 =?us-ascii?Q?VDV0XPXCaEvwn95KqXfpsRM16ygsKXodW2I7ZJQ7p81c3wqOPmkRpN01iYgk?=
 =?us-ascii?Q?9AYtiVNuev/EfB0ORuonU9SfPVpIzddoYLS8FvC8v9awgIvRu/kulKFTougU?=
 =?us-ascii?Q?f2OR9effY17Jpj6qEkyOY//wE2T8xD8E5WR/syN+n6kv9oOXnMGXLCFrfgMT?=
 =?us-ascii?Q?Bqxwxpe0lTTDMexn6KzO4y0JDcbVlKB8jA5hAcwi55+dsh+5lwyhKnsH+FUj?=
 =?us-ascii?Q?EJYj1ZOq6+3TbfCOkvNpBKBVmKiJhEgtEW64KufShWGiuYw5Ki4GNXGpQav2?=
 =?us-ascii?Q?XbzoeMN9f3S1NqSy3urKjd0O+BLuiYmPM6JAumiYvfirlAjuB6lf9Pfq8yj4?=
 =?us-ascii?Q?Po8lo5od/jFhXHVY0IymiSi3qaeBf0ImGuMmdIGoKvnXaSq5fRIk2C9g9uqb?=
 =?us-ascii?Q?pc/bvddQ/Avi7Hb+aSFYYF5HbOGQu8XYVREaf7DzUTd+32tJsSMBB61/3CC3?=
 =?us-ascii?Q?q1Wv3obgYCxNUaJYvC+bv21vyV16LKN/YtgAoDZtiZ3asSwkLWKihbxE/WaY?=
 =?us-ascii?Q?HtPZDStE3A9J2b53h6Nds+5KG9bClY7okkWdgBivB5MRZkd7QqxFKfA1WfnP?=
 =?us-ascii?Q?HJdWi5rb6uNYz2OFjEazki0dPkFuDALoqaDs9yP52hn3lKXHh9Y2053xMEjg?=
 =?us-ascii?Q?7wi6/5w17OcrWk4pIy+djkpt1rEUmSXimGM4EBigL8vp2+N1n7/bR1gSBxAn?=
 =?us-ascii?Q?gh/INcFZFvAiJcNZC+zpJzVhmYC5kI4cYvRe5o4hFvXduKkGmwGMzb8qIzIS?=
 =?us-ascii?Q?W6ejGGGR5sV/SkSzghGj4lfeHEwH35a1h1jGAjXaehlVkQVj8UYA93YpohFS?=
 =?us-ascii?Q?tjRb3Ot7XjWheRJRTEoSxkaqScdHVbV5cdGU7lgOcRCLdcz2GSj85joOdVx5?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6785ce9f-5859-4ab6-2118-08dac2000d2b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 03:11:10.4315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Abe+ppf1VSBykvLruBlfCb6sIaQEUW8LTqmMKP1aKIcXNKo+K0ZS+UqbCdBaQTABylPytk9ETT1wyvxhMSiYAhJU8D97l0xik5fyrEB0t7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090021
X-Proofpoint-ORIG-GUID: 3DdFNvgqsTblZbrUP5zmh7Oglm9DpuG4
X-Proofpoint-GUID: 3DdFNvgqsTblZbrUP5zmh7Oglm9DpuG4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a PR operation fails we can return a device specific error which is
impossible to handle in some cases because we could have a mix of devices
when DM is used, or future users like lio only know it's interacting with
a block device so it doesn't know the type.

This patch adds a new pr_status enum so drivers can convert errors to a
common type which can be handled by the caller.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/uapi/linux/pr.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index ccc78cbf1221..16b856fb8053 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -4,6 +4,30 @@
 
 #include <linux/types.h>
 
+enum pr_status {
+	PR_STS_SUCCESS			= 0x0,
+	/*
+	 * These error codes have no mappings to existing SCSI errors.
+	 */
+	/* The request is not supported. */
+	PR_STS_OP_NOT_SUPP		= 0x7fffffff,
+	/* The request is invalid/illegal. */
+	PR_STS_OP_INVALID		= 0x7ffffffe,
+	/*
+	 * The following error codes are based on SCSI, because the interface
+	 * was originally created for it and has existing users.
+	 */
+	/* Generic device failure. */
+	PR_STS_IOERR			= 0x2,
+	PR_STS_RESERVATION_CONFLICT	= 0x18,
+	/* Temporary path failure that can be retried. */
+	PR_STS_RETRY_PATH_FAILURE	= 0xe0000,
+	/* The request was failed due to a fast failure timer. */
+	PR_STS_PATH_FAST_FAILED		= 0xf0000,
+	/* The path cannot be reached and has been marked as failed. */
+	PR_STS_PATH_FAILED		= 0x10000,
+};
+
 enum pr_type {
 	PR_WRITE_EXCLUSIVE		= 1,
 	PR_EXCLUSIVE_ACCESS		= 2,
-- 
2.25.1

