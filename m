Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E423CCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbjIEXQa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjIEXQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:16:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B71CC7
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:16:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtYnB023760;
        Tue, 5 Sep 2023 23:16:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=rbTP4okj08h1Wb//0gKjfzNlketfL6wYAWy3bauGxXs=;
 b=DLx/Yb2S1KDqPIRNcO9VwGf25cfAQcGYMPviW9gsLJ5Z5SnjE2nHd1Px2y23EhFnkVqI
 r2J1rkDAvXjC93Kx+Uf9FUoU2cKBE0yuFishVWvgFaa8C62KlXUpkouUbR6ssYI8uG+t
 Hkr/sGDZqGE1VRokGa5nNQg4phoTDFAP9xALPMGEzo2fkYEfDn72ummGcSBnRzsenUbp
 G3AmtaKN05qhSvYz3E9kxfGVd6HhR/R9YRumjiHl4iY5LxqbXfoLRao4VhICW0CX4SUY
 xBxBXbP++CA9ArejdIXVGN+nSak/EUpY2ihFUQnkvuCDeelIEXPY52wW0wRqRV51Ng4O hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdhg817w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MW4Mb028145;
        Tue, 5 Sep 2023 23:16:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5e3fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VArRCZrRQbaLAtbMCAWDQDZdcqNL4YHAhUPmOY9D7O1x+dUjBnw/lLZ8m6pv2OKPHJAfZs55YCdScAY9NsTpSGyxpqS/UXlwoZtA4Axviv193wP2JaDkQ7BSE3/nQ8bYoFnitBH7x0F13MBYpO6QgVypaxZhQr6JzMYUejGT2gm6bHWujufGCufOlcYhTILvZthWcy45vIsFVGTSvRDHJTatk1H5M7k/9LiQpzBEhL/rHuF7m4416yRQt8sc7KOnqX8cNQTVpBz4OUMCOu9fXn39fj7238Lf2rtXXDIuEz+fkCl5j49SfmfEtC643XbvCxQQMFpHqm+slR7Z7hjYqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbTP4okj08h1Wb//0gKjfzNlketfL6wYAWy3bauGxXs=;
 b=et3nmb+uKOIn3WnMEMFndwGVT178rJY3Il48jpN+4PrFoU3YecRCwcew393bfho1SiPNuQ4fWWlRfajKe2K/Q40V5v5wR8Qidjpv5izMaY+gk5D91stFUpCDOEFqAQXDv3vfxcFnJ9pOq+4Vm1+qWnXYhawidXWWJ5FJyzHsgH9XtueIknxsFflRPjQ36TIiMKMO7IPRfA6aOxAZYM/iaR521vBsNjG8EC0Sc0JI/WNoqGJ/CprKXSyZsjKrdObIf/qD+cxjYqfu8ZFG7wD7CGCr4gxS+9cuJiYaaL/Q/eV8LMJXilbQUW+ediDoV2tuNRRVsXFc4LVE0BYU4ttIhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbTP4okj08h1Wb//0gKjfzNlketfL6wYAWy3bauGxXs=;
 b=wuRCfeYKj0VMQU1WzzxLi4hJ8Vvu64EQDPo8QYBPIDDNYEkxCSOS63msbE9D8PJTCtdwlfQxPamZFmF91pSqdRgWD65A+meL3BRES31KnG63F6EO/zCaCqhCRvTB+jE8iFJ1iF1c492OsWnrNxWO+Gg5JEV6vQdYWqkGBJXoI3c=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:09 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 13/34] scsi: rdac: Fix send_mode_select retry handling
Date:   Tue,  5 Sep 2023 18:15:26 -0500
Message-Id: <20230905231547.83945-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0080.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a4f3630-d164-4311-e5d2-08dbae6616cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SqbuYd6VQkTd/8VhTRJjx3T7e7Sui6eFSTmgeX9Ja2dGmGpaWK1WbadrG9ZrJ41x5YT1LwTDoVEUiaMDMgUVnRsi0xrpwzNjiN+kfsHj3pu2HS66uuiUz8PJ9EjwU/xRh1SYUbGRKaKdIB0YXF7NgIyPvnctxIfdWxjjiGl/zxZJExn9xJetWAN5nBj0vJ5TTXsu7HN2zqNlih5XijF28NQwbTF8XRo9KYKaKBJe1Ur5mNcnnU8xfEK5dUfdul+x+y2znSLuTaT9W5ruDNkLUzqIBRzGW7PUOnh3SyNXKPJrhUPJUZ0gQT+7Jo3p8KMkBakfbt5F00EXpdUHbySkMEyTWjoMtT+WrcV5MH9FWDH5YFhb2ERNAo3A6VFv+7lWuOq/LvtgPq9xq8MrWUnQV1PRj0JqIaT5x7I4MLcFAi5MIb5SP/otGfAKk+ikalpI8sU5JmZfMhWWDDBypKksCbf2UQUohagjRpnBDA0ffIsFbmNps0ag3tH1xHa1dRosDGm/3Acl5c7sZYPBn6nMGfZVYWOU+GvJl13AQk4ZxEm8HQwtg7ty2c0Awai7/zbe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1zkBgBwDQcDkf8ofuYKZxppHGN8Ud83hNXSVD/2fu/dWztZp57N2qxrFVr1n?=
 =?us-ascii?Q?k/uOZ3apohmcEMrL/rqWDINCVd85xTsQr2wljxdPB2tvUfm714yzCTcxaCpI?=
 =?us-ascii?Q?qX+hJ2jWSOVGwnQi8Eq6tdLgaQyioFS+/4BOCJiMAGLp8i2qdZILujEnUXei?=
 =?us-ascii?Q?OzdV+GjfgwIF1QFlDHL3Amj1yNP6Dx8VOmcAO/iK9uRwCEDlEUmIXe4OXG4y?=
 =?us-ascii?Q?5C4hRdufal4mTJTqPtJG1d4+rXUB18fc1p6J3s1R6UCUn8Oq+DC0n+Tx6/VA?=
 =?us-ascii?Q?5xzQa1dtPe1Ecz653MKucK8HRBf3aZ1YMi0J72eBDJpdhJlkz70BjPfcppPP?=
 =?us-ascii?Q?x8/BShcWYTuirYqia9Pn6q+D/2Ls1jC3sFZwRwrDzPWKyAtKs7zS014o2dIS?=
 =?us-ascii?Q?nmwQdT2RE8izHiD46JwbYjPJe616MG3X0FzJEXE18ZFEhMVcn3lhuYH0qkUq?=
 =?us-ascii?Q?/ww/1ZsIrqaMjvl6VEn76qYMI7C8ToMsVVxAXp1PjprjoBrU4NfROckpb7mX?=
 =?us-ascii?Q?HtLf1CtsMGtUE0jPelcwFFZDEOK4j/xdUPwVyLry8RKkGn49N3rI+Y+Po9RV?=
 =?us-ascii?Q?O7TM82043ME2YMsAPiCVG1kmgGC4CDHypCu4TYSGem8W2cNX3HxlUqkxY395?=
 =?us-ascii?Q?lBiyxHhImK0k4X05kcwkjJ0sdq4NQqaxieQvNl0VZXOClVrbRxG6Abq2CuoM?=
 =?us-ascii?Q?vnd8xb2HPT+SS3EJ9NIJ9Jz0GW2wBDtkphHqeaqV5V+3sN3qZp4ZIlAj9dpV?=
 =?us-ascii?Q?s+gaz3dllZlAWBJtdbsPgLdrsCRD5RJ8Z9zMKCwFVYC8VaTeoj+Jj+HzKMQI?=
 =?us-ascii?Q?U3Iav1qwgS2yVU0pQ1fM/DOSM+Z940Ek/Jh0IwkGZ2kkWDLA2ItuEqRgWtZC?=
 =?us-ascii?Q?j+D0fG1YgXv8TU/j0H0hzxXCYtMhn1eD9zo1o91FwGUwd99Xqg9ZNdGhCkFN?=
 =?us-ascii?Q?FabpeKVjugHD2LgxekELP8zRKTUkNmO8di4vx6e9/jlDhSJelAz6WbU63ZWK?=
 =?us-ascii?Q?a4238Vll52bdBtOgmKlrzSMsw/YJm4gL31yx02bTyXxQwcQYgTUPUwaId8IY?=
 =?us-ascii?Q?GizB4ifxffvcgEeBmc2Vm9W8C6WctnOY1tGYahXz85v23RRswF5dDZKjcQ5d?=
 =?us-ascii?Q?kd1C3LLEbVFv8KYGUFzgUqTKsYXdGPJG95QjPwRATPiUt2HWVFTrX8/V5Ik0?=
 =?us-ascii?Q?Wnmj9o0JmTWJf04TQWkJPR+FD8GFM5ctph9YoiJqcAhssMbQtYfqqfxaPfgi?=
 =?us-ascii?Q?tng+GaB0RyHPnRPFodWXdQbAdKKeN8QLS+x0pX5HYs/hTzaoOAKRjw7xxjpU?=
 =?us-ascii?Q?hb7KgrozDFuW5eaITYks7NZXCucg1hoBCRMsLfOHALHVahL44HCHqD88TCTJ?=
 =?us-ascii?Q?tUFUCy/AWNHEsEhFysx4RSIZMM20S1rsdDzEwDXdhFvdZ56kkVIfQ/mK9fWN?=
 =?us-ascii?Q?qR4vnM5FiLUIMlvFpTZICzp/31/tVfGKjWzkShmWLbLdJvZBIfN4WyRHU94d?=
 =?us-ascii?Q?wph3eZH7XnzFkRQsn9pvcbM0N/9HzTZv+o+xTSrbRATgswmFjX+pG/T/O3zy?=
 =?us-ascii?Q?VNuE/EOsBsn/PF76aWlGNCD7/Od6WBNMZFugLN46cXCkCtvf99M1XGWZc6tO?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SJUy9Cydg84MrX2/WFsGhgQO4deOF7WYoDHPJJH+bMnXDs7e8PS2lCwkFVB4EMbyAc2XsOZH556ir3iu2fIIkhC/yIzpMtIO11tYsgWlH/pDW/yWInic6ATgmmriv5bw6LQHegS7tZi7lzj3rRF0E2dO2fJfUNY/hvJLPDwk+FG3rAHYORi4wSsROyUm21vPuUxFgSdjOz8CqFHL9Ypu3b/6VR1iDDkAKbHZS8GTIsPvSz5U2Fu6P8wFM4vLmNBcoLckIdkSrLyzgcwlRZQQiYGgQNBaoyA9BCzNr+NcsKlbhW/bnre4jDPDjnJ1JYpeOD8ExgKdki45VlvIzIlJrMfGhgKzSEBimJxXUgeCne1G87XOfGNEtjnoobhv7OuJSVXKgHkXMM6m+8R/lxL3w1LvGgbN2oEVsj6PZ6AQ9X3xYnQzLkPcdOVxS1l1ge2q6nvLq7uR4CUnJLMC4lvBkRU0DzC72ezrpFGnRO7VK7K/iToCSmG2zbgyeutfxryLGJ3Ank0U80sVv2urB6/KYVSaQjtnHERAQ/OVPpyNdRtgH8OZnQJpOTIMtLRysK8VLfY8D5OsFlZwhHd9D/H2AZMq2wGG+zwI3+JV9+5bhSdtvdijEIa0HlajmLTZ6h/2pmB84V2pB+oKyB3ZiUrp+NVLRLTMNx6iKTuX4iTCLeGZ+/Tybgvmey0MtAL1EkPzAZdCYxnSPLe8eWZ6iuCvFoOKPhdCQy1qGh4r8zuKYEGiWonGF4MzxgYBbmUAF2TDDmDngzwejG7E1EVQAKI7tt+FOOZCZQS64k4FxSP5aSvfFmQHNWI/47MIBdsBHr+lZ799xJqx3vgK1RV4YTOP3nOfUmolVfgyh7cKwyJCjJHveIebBYhYQKnFW/Dpnwh/
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a4f3630-d164-4311-e5d2-08dbae6616cc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:09.6874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMGXOCE8umGtO5LguIUX50/6nNH1nhs4KutQymNKWWzNvlFJEplpbCV9q9YmMom3ffmLMnfXEjz4gc2d63eMqbA2KYMOxzS8EjbpULqtGbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050201
X-Proofpoint-GUID: gk4Y5Dy-9OE_JBD-mVLbr9R_v7xt3Ocq
X-Proofpoint-ORIG-GUID: gk4Y5Dy-9OE_JBD-mVLbr9R_v7xt3Ocq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If send_mode_select retries scsi_execute_cmd it will leave err set to
SCSI_DH_RETRY/SCSI_DH_IMM_RETRY. If on the retry, the command is
successful, then SCSI_DH_RETRY/SCSI_DH_IMM_RETRY will be returned to
the scsi_dh activation caller. On the retry, we will then detect the
previous MODE SELECT had worked, and so we will return success.

This patch has us return the correct return value, so we can avoid the
extra scsi_dh activation call and to avoid failures if the caller had
hit its activation retry limit and does not end up retrying.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..b65586d6649c 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -530,7 +530,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -558,20 +558,20 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	if (!scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+		h->state = RDAC_STATE_ACTIVE;
+		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+				"MODE_SELECT completed",
+				(char *) h->ctlr->array_name, h->ctlr->index);
+		err = SCSI_DH_OK;
+	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 		if (err == SCSI_DH_IMM_RETRY)
 			goto retry;
 	}
-	if (err == SCSI_DH_OK) {
-		h->state = RDAC_STATE_ACTIVE;
-		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-				"MODE_SELECT completed",
-				(char *) h->ctlr->array_name, h->ctlr->index);
-	}
 
 	list_for_each_entry_safe(qdata, tmp, &list, entry) {
 		list_del(&qdata->entry);
-- 
2.34.1

