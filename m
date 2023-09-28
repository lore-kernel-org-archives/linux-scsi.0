Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3113E81815
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjI1CJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjI1CJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8208A139;
        Wed, 27 Sep 2023 19:09:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL7Sdl003996;
        Thu, 28 Sep 2023 02:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=b2ohtSnePw0MUBlQYUzZ4HRx6DfTz2jCK7A/nfh6CjU=;
 b=axEgQ+JdOgeTeEfWQ/U6aBUw4ngySfM6Kb/kTdxEWbQRmGLHcN3I+ANh9nbTZ3+To026
 Lox2rY7ET631giORgs5zSEHS8GfAR6TVZ8PhdR7OWzeEriH9+46A+b0lduKKszEx+uXM
 CceyU74HhQw5LgDXBS1UeM85CgTnd1e79Obhe4lmeissGD8fFhs23Smv0Tyt04kfD9aQ
 yzJBB+CPbHDe9EcDYR+UqRl9gRLpUbttE59qWcVd8F9OMsTHCG6zAsY4X0m9hM4XgJlo
 gA53x7rAYw4dT+zydpqsQo45+tASjEHlJpOlpcP8C5y38TyReRrBoADwteZKjk9B1axP 6A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9rjuk1bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RN0Gsc039385;
        Thu, 28 Sep 2023 02:09:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pff0f1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPRELxzR0JOehcFNQJUFlUNS7gxCl0+L54rXLXBnib4cHfJnshyvC+zcDibYxdc4EZGmtZRsN67Lo8u9aMq/vkHwWFt6vuV+C6mpRGuoEujo/BwH5grOTqBTj/V80YWxGCFIfTJuAJ7YtMfzHXQBgnJazTSvDbqSWvorYamhcKU642lUuoVCfdpJcHHbES8FZRFaeRCuCiP9prr+9ldlIgssG3BuuLuptN76zJhtCejtN5IMRVReMy1Nyc/13ZH4sPY/3WwZYIqwjQ42RFyyrJjs7If1pOQmIFpNbi92FuqUgxPBaSSLGackLWKUA9paHs6Z6jwxvti62rR+zHkmQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2ohtSnePw0MUBlQYUzZ4HRx6DfTz2jCK7A/nfh6CjU=;
 b=BO86X5o5EWW45z2/EZhQ25hypaBWFT3UhyCW0aMaYrDF7ruuptBVvcwoDiE4GVcJYXo6wmA5RlWOx0zJuNVhxVLOI8hZcidotK/duLAAW0lvFHPhSIIQ4VjwKmLWi5bhgi7bGgOA9fDmUZ/XlKuDGHRuE5fgfFnzjuQOyLqjq7aAOiDgUzlzCpsAGevGrQ4hnoeQiAvWMSrT7qNmcsPnIgtpl2GJajVf3bftFol8FESPWr+iV8d4MzkECMC/A6pTUOpgKteqtoDW8Rgn6zQLem8OGxessKVTc9kGtVV3Amc+Rl1pz3ETucDE+N8AVICM9NJlnIdoLPn6DqiaoGHjQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2ohtSnePw0MUBlQYUzZ4HRx6DfTz2jCK7A/nfh6CjU=;
 b=NN9HHXGEJwwbZz2WbV9vncVIA5wp3lMmj3Wumei+Ng8E8WiG6hTD0UXHpfvXgCKe9ez/oYetod3XxceaG/p4pIAWookDpGxhmnc1feWwfaluHtru3m0roFb5YEbrR66S2aMDA3PmYa077njsh37GQP6v2un5wP48V7EjuOTyeKo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:20 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 8/8] scsi: target: Export fabric driver direct submit settings
Date:   Wed, 27 Sep 2023 21:09:07 -0500
Message-Id: <20230928020907.5730-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 715d8e57-aad7-4082-4b44-08dbbfc7ed6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksQXm4wMFWoJmzLBnt63smXUsoKo+wN8iXKtb7e50FkOn5XeK7WQww8pbvxMYrzXL+y+/3naBEtZOrV+zsGtyHgsV067orMQNG4TkeoP/eQBSv+ksCNSlIhaPRhvWxYb30DIipQCou5dBtz6bYmVn6dYqVaz1mwDa3kSg+5A6OOX7Z8Q2hxvgKSER9pnj+jGVwnYioc4LGJZO8X52P/GgfP2PJvBZJaKLemKTWrB5C835piEIknWyyiKeqFKgnyfnUNtEYs4LGbIouMiqOvC1DvrvqjbT7YqaHABjt+GBfx3GnIAajRn1zQyqelYTOCmax8eSumBjRnL3oFQrzh9DkMZPqAoy2T34mTJufGwajcbz5YxX0yWAeiqdDCMTuOSG7F7ew8l6fFFGIFLZCUcGtb99LQaBdVaF115Vvr/8blwl9bvf3foyNI3tWsfdTnmBEZHVUfHLS22rjVhg2b9ltAk7SN0hCfXnZ+0MJSCWHx1kDhKDbYpfoMCTDtSE2HyRL8tt7hUMFVYadWqE+ji0EhsD0Prxrrvo5MBdIQmVpLup9VD/KxPqG7Ck+Tdg7XM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hR1PZ2bgqNiDG8y24kM+qe/lZGQWELgPZEHh+djPhJA1gm3MOh3KpfzAclWX?=
 =?us-ascii?Q?BBWgfA/xDZKN3kjlyekQ+5x5HUCijs2oj1OFRhuwTBEgHo2gD0gKmSRJSuMJ?=
 =?us-ascii?Q?hoWtwDMhAlIqQzYryUI/rZtKoJ50oQKfjpR8EBAURruEYjppN6ugz1CiJ1tI?=
 =?us-ascii?Q?gJKa9+cjymGtDqlxQzYOh7uHBtetDBnOh9E7wdqScZ2cYwNiT/F0d5OXMQVZ?=
 =?us-ascii?Q?CktiadLm5LtkmpNZPAqtFoF6KQ7+e1LO7Qtuvp3aSdYJYJHn6CDprTg7SONN?=
 =?us-ascii?Q?saT2H11iLa1TBThBEIxUqtMX3K2mlKtkhvKyLiEtFVuvL0zg47no8iObUsHT?=
 =?us-ascii?Q?LURIm/EHc1qRNnSPDm6/L+XDDvJ10wHT7/dlcAeQ1CCHT6UQTfAxaBv0Ditb?=
 =?us-ascii?Q?FADbLwCBYL+V7q/xJR26q1y5mrvmaTCXtX2InLA5BQ4A0c3SP2NSjkJUo3jt?=
 =?us-ascii?Q?9Y+Uz7j7+iMUTDyOUUiHLSyK0R1qwTas+fagYyh2wE88x2rT9rH3SAFb4fr9?=
 =?us-ascii?Q?bcbIN1LW4kjk5lStaGXpo/sXQToq1eMnz06N/cShaP2PRdRFi3WQhOmkBlFj?=
 =?us-ascii?Q?r0kcF3LoUGFyTKhmzYb+fiQI7sLE798kKSmywnOyFrG0/kY9XfX5Qyk95eKh?=
 =?us-ascii?Q?7PgtYyrSfIy02v0deEM/I71GEUetXGPSdYr31Kq8Ma67+lrEykxGZQm4k/9l?=
 =?us-ascii?Q?eVhw0Vi0nVqwcJADLM3+Fsfhkt6cSHN1w6I027h7LuKPqz0GM50LSY05uEP3?=
 =?us-ascii?Q?B5RN1AqvP1TRfG0aqH2ztVGRnoWBZTy1Xtk+imPnaGr01Dimb85JoN4bVIBJ?=
 =?us-ascii?Q?UeaH5YjiaspqcnUAG5z/WgmziM+WIosQ3J1I9Rq05kkgW1tHxOydezA2Cfm/?=
 =?us-ascii?Q?Rg00IcxasKBkNIY27g9r7w9JCyG6AAswh6oSenHWhTsnKCW2kIajh9kbQgF5?=
 =?us-ascii?Q?j5TTC1jtcVRRTNjNEJsSyqIX/sRO3z+ByBX+l/OfnVhmAgFxPMn6mK2BaNBq?=
 =?us-ascii?Q?kS7ID/UAfAyR0jK59eDdQ5OkCLuvvGWl7yr0lzrX1YxYQJxAlc+rABGxDWtf?=
 =?us-ascii?Q?WqYxJehiHnHVh4JfmNI6Dr7bjJkTcUMPdH0UYk/KFPLoBBg0ahXDDinBg0XR?=
 =?us-ascii?Q?uuFLe+PbIBoYZAu3sVQjvrL5r2J+2PuW9pYUoH88mmIhh0VLBb76ZVVYAXKg?=
 =?us-ascii?Q?65UrxWT3MY6Dz+6zr/Eg4ZTLBuX+bMwgAHxBGkRkQsHTdx6OJDv1IqTIjFl8?=
 =?us-ascii?Q?vAYcaKPxjkdFqfdNmxfpByBvgSpOrvxVEQecpirj+dTeCfmSIYtkUnEZB+8D?=
 =?us-ascii?Q?QruqrX6UZjhoZN8eCe7s4MFNRFuqN9ASk0eqac/Qtu+jE1F25WKsgHsbSHkc?=
 =?us-ascii?Q?4iiry8orYQFlGOidO7V7NQoHjOpTnVwNHRuCHje4WQFXSYsHWRDa7Rqil+tw?=
 =?us-ascii?Q?rDa93U7+HyUvwMQkdDqNFPcS5EKadNzMBC1LYpMrMfu/Ch+yx770grJiuWFD?=
 =?us-ascii?Q?w2wX7F6FVHEW4wbJjOPPcTd+RLx6FkqKYjTpYQFeDGymufD9jKxfS91cFcN9?=
 =?us-ascii?Q?NX1vmW8gEKIpWyLYIez7MIHOMuo9iVLKIEN10jUcbqoTK9O1/rsybfQ1lMyA?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Nj3VM8ZaIinM9h9p2bFSJv8m+f9upsjPFkM8w8ZldWlHU3I2xAkqbZoQwQHPtkLzBlAKHkgW+F4mxr/taFYiyKyV66xBkz9m7nO1LEZtvT2dlcZFBCDtjwF+3nqTA82B+s28XUhTDyHMdC+3TgO0rPneqdx5SA+SlppFIR74Mq27r7TAH2kJ2d0sIIDLZxQ72+fEr4n82ybHGsUfBleyS+jBtwjrcDkibl8NE5KxzkIH9quiZzy/Hc4MYz+XtVtELtNEeStLPidMsb0IuIcsJMhAAOtymK4HoqECTTuuoRV+KDg3VGV9st7zs1tDMQKMty9fVuZZtBtAEpfufcGys+eE17k0hxQxgvrEkD7jTAlr4d7Otr7B2Qs8nLeqbDPqhAGsHOyxFIW7XuRWhfaDUA8u+j1O6L6e5rxf8p9duWWhWAiUSRxsFior3zFMpEakTamZvcPCSSlsgAxNcGq1/A2e0qGG15RIadhzM7V99ZMir8rNWL9SDyEbsQ6jZyZkSYqx46rlJ1oCHtMamSjuE48JD4AT9keBE7gUvJHG8O8oIgAs0xCF0rsz2hVrBsbFVh6CUjjl98OIvYEiVDEbPJ+1JKBZsEYz57KQwEfBcojxxLfJnA+BuzpVAjbiygijHGOTuSdBWF4HOZA6atrztlzef1fk8qnjgdXKP0+8fZULRS1L+Ay/fLRvsqfJLy0gCDAapzf2XXHYENvCP+esLDAY7FCVgMJ2PbqgOwnFCMlmot/7A2wUyXPBjB3ZxHLfUVwBQN19KbaNxCfmpqpxOw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715d8e57-aad7-4082-4b44-08dbbfc7ed6a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:20.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CluenCnSfPLwkRIkIbCbEPj7P9Kdd3nWrvaom8gZYd+VoOU2xFAwp7ltq7yatm6+FFKgEO53/qL1e7lDefKnEiNybdB/cU4uACGSJSTablc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309280018
X-Proofpoint-ORIG-GUID: 8yGyezJ_BA-wmegJ3P89LWdIB3ao3UKW
X-Proofpoint-GUID: 8yGyezJ_BA-wmegJ3P89LWdIB3ao3UKW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This exports the fabric driver's direct submit settings, so users know
what the driver supports. It will be helpful when they are exporting
a device through different targets and one doesn't support direct
submission.

The new files allow the fabric to report what submission types they
default to and if they support direct submission:

default_submit_type:
1 - TARGET_DIRECT_SUBMIT - If the user has not requested a specific
value then the fabric requests direction submission.
2 - TARGET_QUEUE_SUBMIT - If the user has not requested a specific
value then the fabric requests queued submission.

Note that these fabric values are based on what the fabric driver
currently defaults to for compat with exiting setups.

direct_submit_supported:
0 - The fabric does not support direct submission.
1 - The fabric supports direct submission.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_configfs.c | 24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index b7c637644cd4..7156a4dc1ca7 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -1065,8 +1065,32 @@ target_fabric_wwn_cmd_completion_affinity_store(struct config_item *item,
 }
 CONFIGFS_ATTR(target_fabric_wwn_, cmd_completion_affinity);
 
+static ssize_t
+target_fabric_wwn_default_submit_type_show(struct config_item *item,
+					   char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sysfs_emit(page, "%u\n",
+			  wwn->wwn_tf->tf_ops->default_submit_type);
+}
+CONFIGFS_ATTR_RO(target_fabric_wwn_, default_submit_type);
+
+static ssize_t
+target_fabric_wwn_direct_submit_supported_show(struct config_item *item,
+					       char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sysfs_emit(page, "%u\n",
+			  wwn->wwn_tf->tf_ops->direct_submit_supp);
+}
+CONFIGFS_ATTR_RO(target_fabric_wwn_, direct_submit_supported);
+
 static struct configfs_attribute *target_fabric_wwn_param_attrs[] = {
 	&target_fabric_wwn_attr_cmd_completion_affinity,
+	&target_fabric_wwn_attr_default_submit_type,
+	&target_fabric_wwn_attr_direct_submit_supported,
 	NULL,
 };
 
-- 
2.34.1

