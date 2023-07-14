Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB4BEB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjGNViq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjGNVi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B068D3A81
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4E8H003214;
        Fri, 14 Jul 2023 21:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=LJMee1VnjufLcgqGqlFFDdvzFDPxZNYpwlP1KqDbDWs=;
 b=3tQ+RwSLWjI5HCVBzXt0M4545fDxXfqCFQHfUBCiNDkcDc1cSU5F0YzZHjrAAkeQpmMY
 tVGHaiCACLqjb0muqUUd0T3ZUC9uyX3e4BIFpMtYq99+yxZv4pGrhK/DCwbW99C35OME
 yTrVabOXDTu169pMD5tCOUatRhqyNTJ6DKgpO+My3IXWsUpSCXxQVMZ28Yg8yeZfy2wY
 ipjiLD1d4CmusZqUj49qxIarRp7kH2txptuBNnbBoVhvyOSDKrYx0Amb0WoUFTOpQEmv
 yqojMcVwK1mL2pYgF4gdVgOPQfEkmn2s+VDQCkMPB7UuMScpgd65JXw9l7+6GL25UJPb qQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqnct9v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK1CO0032984;
        Fri, 14 Jul 2023 21:35:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvrs4vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qx52OHGA+YUh7pEnU2cHe6ZjXgH95gctdu7gVJXTdrCPo8c6rSDvn07n4ADWp9+DbOdKVCcluRYjezWquD0+a3pG++0GBl4/j2OSROU5IgG9LUSdGbhzqDbJVlLFtyUNuZEhULUJBRko+Jl+BO69RIH0rjM4G/ks6FlvnBlc2lh34Zy7vb+dFjlAVfHLRi+qnw2KTyo71HN/uUDcMP0F1ycWCVbwN73TqtvBP+PVfStBx+CVwoVCMZGB9wC0sdTkGJ14aKbA8+CIoR8TE+iDzWE8NnJKzaQAO+V6/8Ox/H32JvBBW9nxf9OIWD0QCbBuqAm8AKx4AqducgS8sKoY7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJMee1VnjufLcgqGqlFFDdvzFDPxZNYpwlP1KqDbDWs=;
 b=Yv7IiYuY+F/KWi1YSvhzTK3K1VSBl8h7SsQnvHq5odSuVz+IDdfDacIFPuBfXWn++o8xLVJ15CVEWOFSPOtzMmKV+yo5mQsEG/d3nKU7BcbpDq45zlDIl84BWVmlV+8WCNhJj2VtFIF6XuiR4Ygy6j13isFb73fiuB+D7yTqUlxihnFYuakW6aiteJKKEGcmNLMvJKoze6LqNCJ04Aj7nfZJ7W6nN8WbgRMAoBPc4Xlqr2A42flmRzNceLnlUKm//0y2SffiqE7BSn7PDRF8vtoffBXeHLPPaGyvTRniJEn93Hp4BbIMkHdZyk6nWpUkOC5PIrmsj4ivFdUiwdEk4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJMee1VnjufLcgqGqlFFDdvzFDPxZNYpwlP1KqDbDWs=;
 b=lMUut+hAv5g89gAXapwLr07AhjuPtRSJNk/HY7j/27zUxPetD4TAK6W42OCUjoc+H7ZkKgRmCxgD+H90AqKyHhAtKL95wVmsWG4/pQX/qKkmbQzi+/byQq5SryX/AEEJoXvqefDL2fVlOWXcdab6jpjvpoM1XIjrkKGGtU0mlZM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 29/33] scsi: Fix sshdr use in scsi_test_unit_ready
Date:   Fri, 14 Jul 2023 16:34:15 -0500
Message-Id: <20230714213419.95492-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0086.namprd06.prod.outlook.com
 (2603:10b6:5:336::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: b4d6a1e8-3e7c-497f-ccdf-08db84b23351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EPuLzDd50H7+DoKPLkcj+nWc56+uwNcoGMCo+8xEsBqSz453qPdmpQY1Z301qIH0ouRxZzZKqFiMqfTnkIQBPWqCG3Tkbr/uAUeaBYitb8K2aN1oVhcXF5buGgh5BCU/jMO0NtSXcacZsr9umyJ3MgHky4YE/3Dea0MbgkY6J36XeUhU6kBoayFlRGtJ67d5K2Cdcx7EFIQMb8B77KljZ7qaJdJ/ozg5ykWh2PH+Hk3MQiT4STpJy+I477K0DNLv3xN77spLISOFWR/9R4ptgd7F2eyabiPOMwDTOcYWG/nlW9iw7WDjDmPzkVclFNjUnNLaxJgCiikKQYBWasLGvuxJ5Rh/9sMj0MnYTmXsG5bFwxLbkEwstochVJ8rmcLOx0nNf8OEW0il48UjGKREEB8Y+B2dwLyzxm0AmWSkq5kSB3QeLh689+Mp/Dif1KuhsfnK0OiM8UVQuhkV+oUlak4Fzwrx7FqtQtYLLkHRvJG3tFwIpGhkIEAGWvLsJRpSvZX1sVvDXCGJ3eDa4tLhzfvBtGXw8teGympROMM+AzajrjxOi+Mus17OArXM7kdX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(2906002)(478600001)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uaLToTvtUG/qyAWSTmozR47fdrvWN7GjdvsnjChrb9E2+6O4vw155SnqRWSi?=
 =?us-ascii?Q?we+Mo18iW0MxJzUB3FhwFn6lD1qw5h+ACThAbJH81sObfix/9Mxr3ZG1vJ4b?=
 =?us-ascii?Q?R+gITXMFP4BntD9+9rWyIwTDZVxN2zsskcicJZVl+G5I19ztwHDS+Yu/MxQX?=
 =?us-ascii?Q?KpS4Pb8xRFU0kerzdYIe5BHoKEUEhaMNbPWOds3+drNz6VxSvpQrMjrR3FvJ?=
 =?us-ascii?Q?lpIBEMZJlagb7XRS431JToiFqaWEJTn2eYcH5BCJvBa/bwgszHEcmRSsYcm2?=
 =?us-ascii?Q?x1buposFRI5pPhE3TJVQ70/dToebAPD0peQ8ORrDRueuZwvAbce6Xure+zWb?=
 =?us-ascii?Q?XsY0477VkA8JtJnGpCJR2HzDgOm2IIOQjJd5pQvmz0oTLQKZrIQ6mwDLmjLt?=
 =?us-ascii?Q?gbp87sLs637ErakRmJGV6+xe6hQC7rXS7oIQRbThn6Uw5Qdr/i6nvXfYSnQt?=
 =?us-ascii?Q?YCPnhVzcY9kH4W6JR511oZL0Yh+NSF1Kedn1YJTrAM659gTlckeSNqbo1qwi?=
 =?us-ascii?Q?5VXLjGUy2WtoEyvdgUm3XGSvgo5m/xkF9mNojr8VtVcYoxV+sYkr1HNGati8?=
 =?us-ascii?Q?M6++DP6guHVzmOe1ISwGEdky/436HQVWVnlIeVUkPIlxiEsg1B0RJyj+ilIU?=
 =?us-ascii?Q?tceNcsqLUZnCAZ7TD5TcojVgeod/O/9jECR1oLVRosuvZhSpOKKMRI4L/iw3?=
 =?us-ascii?Q?tyrUi21/56WsktJ5+SgQ8beE3Bz/39eHFZ7SpRAUXlbbJ4uyRa25VYRrzBgd?=
 =?us-ascii?Q?nPM8RGuemIXCaNR3bBLlbPu0iL8zJBEcg3bhlKBa96899otiEi1xI8E51PPP?=
 =?us-ascii?Q?FVyyFszyuHPCIjC3myNe6ovd1Yle2qZn22a1Yeq8JVi7AIuzsJ8hw+sCCbcH?=
 =?us-ascii?Q?sNKpQ1icMXEsZ/24Kvxaes4o+aClE94oKFqc9sNz0CQh3kq31KUxtkhoxKAL?=
 =?us-ascii?Q?FQVDhEgiNLURiUQnLtfGuVVG5/sqKjAxn4RYjJ55wr5sLcl47wIHI0SQMp95?=
 =?us-ascii?Q?hG1YsrfFpiwrLKUI2KKzFZs7miBlFe/rRRt6oj37JqMIWOd0sNh2tKiT6K+j?=
 =?us-ascii?Q?QQpQAEhJUnApIawoKLvVq19RmJnYwD+UNLuA5JptU8Vl9paMbNyN9FM+tUVW?=
 =?us-ascii?Q?1HsAZ//BIMAsIMl3wxD/zGxLPAK9I41TxLgukCdICdy6ndaiIXAiUslUjCwA?=
 =?us-ascii?Q?+9fUk6peaVHq691KThgMKrxdvuVaCHSzc8APxNdLoHyfFf+tgNqSGL1ncpjm?=
 =?us-ascii?Q?t6K1Mz95gUKdl4OSP0baUFpS4dfqiHRZ17NCIJQ0pDxsm8+RhocrGIFDLU4S?=
 =?us-ascii?Q?BYsR9Q35qB5nhmvSedVNPo0i6C4YcCKkpYyjfwOw+aJG5UsWfn6rTfDYcnNU?=
 =?us-ascii?Q?7zprp2CuMDOfWETfdAtOaUQz4B6jUELZOyCpRwQbRtCqMYgblDW33NpUOWaP?=
 =?us-ascii?Q?NgMc15vm6Ew2PtQ8FTYJnGV9msDjMcVcgoJtTkJv9DjqI8oboGbdu07iSUdv?=
 =?us-ascii?Q?Y8AjlZcao836Xj6bAcyyd0LJrPqvISlmjZvidciYFVic2I4NkU/BZJH20R/0?=
 =?us-ascii?Q?VbmTXXQ1QInAaIAJnZjNmA2ZR156ZwZdlvCQZQ1rF8xqufLkhXn6b7BpsblL?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: id8SnC2dlykDeVxVfo8a2LmjckKGeQMGhayvB9kzjwjsutEg5VuOtmHYIkq6N07YV/gR5NQmZLZa+Lj0udpDdRRACu9O/HjP+hzwMJcZjisbd/MBxvrXCiWdZMEE5B0FiJIfBhb18TBCsoI/b5ZOHCzzTJpMTtcQMJ9ADJ6+D28XIJbh2FDfW8SblsbtCKeplw6OfbGOKSbzATqSXxKR0hR6OJPU59G7fWfiQcRYJ91iJ1TC4lhe21h7xs39bot6yNsRgKF4gIThDdxil5ISFK6jesiNGx6DOsNgrjwP3NRZ9AlB84tcPc56k9G+9LmU9tlfpoKUZQxaJFPd4cRYiRXDuBhG+pdy20HO5QMpegsvAiyVOT7IPesXFmo/nMwib97lFz52W/MCKPjO2Y+0aU/v/ZnEnaXQpmrqQKdq1IdCPx3gAluOIkB4dhg2zUeifcuOLurUpVxzmb9Tiz6bsb45Zuc732VpK1kW3g7Sdaw5G7rWQWWlTcjX6FjVZ6ng9CIINjbi3XCpRa2cBUoqWtiDsxD9oFbHdBSVlG9PVDK4dN6rL4rHa7DWGZOhUm8IcMZ6vxJG3nf0qKIkq0ffl/Ijmacs1MelUXWjmz/9/2GKs8YVoezla14kSymtDZP7Nl2BxD1eRyxb63p9A8fIWoLpibBBMEb1jmNa0ZSw6R7YvmHf4OkUj6s0m6ej/OMvClXROhyu0mknGl9uZgGPZRfrJySgurDh/Popz9Ac7dPNLWeXW0968wOC3HDSbj+KOmKhNefHlUAUBqllp+e3mliztUNhn7OCfgJdcdb8/cwFr+DOoOIKmR9kB0pv7UayMzWK6yE3FLVINYPXc1lmLacWzT+QuJPn7jTBKm1mWKhed2ws9ekf1DIQCg8ngINt
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d6a1e8-3e7c-497f-ccdf-08db84b23351
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:10.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZcAmayXSZoJ+TZmPBDfubZMgysi6b4N/dH7JxHplF4eAm8xooMTCuHqikqnwIow5Jftfr7q35bVHVzvgnhCerN149v7rXbHRR2h6i6/REc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: zQQAz9NYzm28UuGyoZq1LeTdRPA96Ttf
X-Proofpoint-ORIG-GUID: zQQAz9NYzm28UuGyoZq1LeTdRPA96Ttf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 26b21e20ef0c..393cc4fd87b7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2319,10 +2319,10 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
 					  timeout, 1, &exec_args);
-		if (sdev->removable && scsi_sense_valid(sshdr) &&
+		if (sdev->removable && result > 0 && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
-	} while (scsi_sense_valid(sshdr) &&
+	} while (result > 0 && scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
 	return result;
-- 
2.34.1

