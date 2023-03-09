Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40DAC6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjCIWe3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjCIWeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:34:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF0EF7392;
        Thu,  9 Mar 2023 14:33:52 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwvgK008483;
        Thu, 9 Mar 2023 22:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=aw8CS9AivX/mRr5VbhE25CZGu2e2Hz2RIoWPM69Dm94=;
 b=Hnjase12Yrqrl888pL5pL5x9SxLA/MEwdTMb/wX4BMIKbEXLywRKZizqfMQSRjm5ZX+8
 Bx2AjqTvzvaH9OtkLOXjBKdh8JUJ2QCq4oul0/2jzXb+4BndhGathrBbHT9DY5hV5k1M
 Bhzzrj6cYWSwZtduup9wBgeUKeJXqTRCygAwNYJJtReVAiLZWe6X4uigwNgd92Ulqh1u
 LYGAQtlo6oD0LbzKL+iQJW5sEwd3Ck23omJR9DFYnY1ZQq6vQXD4+5ZNvJIh0P+Xn8q6
 OeJPTZinU4sZnhbRHVAopqdc/xchpkveibFzL8hhpSiGvVx05D2RaD018H3AiWA5a696 EA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417ckyr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf1GZ036551;
        Thu, 9 Mar 2023 22:33:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g47nhjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNB6IT5jiP7OoXBTe9qn03+Y2dqPhKygbB64KdkoIrOvLFN45HyniaK97QTnB3HtkGLTeJQl3iG/kFkvWrf9if/drmFM+g4dmurhsrHc0ol/DzACUVbieQa+zdsVn0pWvitmT+Zo89eJNO42AS0VVXOqMTxZaTc4r0BCHsYoasYDtOZz3zSG/0DtJOS6uWCGjdXGjFoTpIajQP9zFBMsSikaUMt834vX1ymcZKVcSERxSjHTCJLCVJuTxEssSywLz81T5fxwIz91imK7m6ghp1/2id9vUhjeSzZkcdDCPDnrsliqMpK8T62t5n+87amnobaGUWkSJ1zxAaNSN4liow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aw8CS9AivX/mRr5VbhE25CZGu2e2Hz2RIoWPM69Dm94=;
 b=hiJ4QS8Ve72ciAQzawxFseLYddDXWdUamRX+63eZ+pPFXajts8jmONulT1/iLYVpnC7b/DmDk8TquH4IzHiQyKylOCm+dEnQJul2n/gpejF0xjN6/CGWi6JNVdc+wijArZiHOkhxZmC3q43/XavwzZVIh0d3MEowMoXcrzgN3jvHfFJqdZ5lZx80gLUaMpfyFuKh5D/tBPcFTgPi6+pYY4tfMc29cIoK4lRMtBoyUlnSjjKt/bNqRbQpbdgT7pTxcx4Z+U6QcopXdYs4cWzzMomrjbI/D+ncCdqrlHxk2US/ttU5CZZ/NYP7Oxgyj6m6gUexsA0bp3EDkEyHcwJtrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aw8CS9AivX/mRr5VbhE25CZGu2e2Hz2RIoWPM69Dm94=;
 b=RBKPpXrehc2zvgW/q/XnBJoWlBgWROvUOyjcLA0TpdGjM4Jmx57y0NrK1QaARkDFQd2QFiK7eV7XySIdL//DzZI2wXMYcqDzpaV2E0RFHJN6mhma+JHg0x/EVmCyvYCL+U+ItridafNpxdGUtN1ES+9zNbHKvZf26Uq5uThqjxo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6782.namprd10.prod.outlook.com (2603:10b6:208:42a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Thu, 9 Mar 2023 22:33:41 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 18/18] scsi: target: Move tag pr_debug to before we do a put on the cmd
Date:   Thu,  9 Mar 2023 16:33:12 -0600
Message-Id: <20230309223312.94595-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0078.namprd06.prod.outlook.com
 (2603:10b6:5:336::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 012fec80-82a9-40e6-e8bc-08db20ee55b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ha5MaFQCsoaEwMxYy80e7DQ1l/w5EM6GGT23NXidzBD9GuuZ33nIhoews09psypaFA/qx/dzzWTyYsVkYUYTF+wL+KUjTfvaaTlj6cAYfY+ZHeutHdeO1xjP2Frx+bUDuNrft2RM/xZKrWVQWSsNSXIuEpg9o6cKhGHBdkgFv2PZZ9yBCaQfnG7WFlaylavwgOruxBZe9MezuxnfTjshDUfHQ4/enARiiNlAMAFoza6J7F5MZMoI5vnXji/f5Q1JCj6JuAPPg4/DuK1EzlZLM39YuKdBDCwNLBFZ+z4x2E+nDGgiytZT/W8SQMwC5f4htBtpIEUr6GL79VIzcB/4NrLvijWHItulLHcsyeDZBk2TEcacrHH9erEXuYKO5CDUDLDZxZGn7M3WnqsdrMG6q5xDuyFXflJlaLYBMuXrHppllRypgymFT4VtW0Uav8TlIcv252Nw+fxbcEe2xERKMvDOS2fEBXseTAnum6MZbTKki4iLHZCzVt1A/cRJ1N6eME9Hr0ZhI4DVvguUtyRNrgt6wqqx3UraFNBaI7F7klpFABMXzfn+uoZ+rQYXHh8jHvk/o0s0WYOhljIusZs81rLu8Mq5/7wH+F2HW/S375LAViv7CXxJHEWCRtOde50MoSqsAX/3B0ktVpIXTs/84Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(36756003)(478600001)(316002)(38100700002)(6486002)(2616005)(107886003)(6506007)(1076003)(6666004)(6512007)(186003)(26005)(5660300002)(4744005)(66556008)(66946007)(8676002)(2906002)(41300700001)(66476007)(8936002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sQHck7fbAUaItfev91nwrMmrpRE5z/9iiQ+jv3Qv4m0L3GgUfnUArbdg51MD?=
 =?us-ascii?Q?Xy5zpsENE/QfoC1hyLuXL1ezF9TfndXss01jSohdTMHEH9byDc3ZCVwooj+J?=
 =?us-ascii?Q?VTGjJ+32LcrARYeW6kUHJ5VNYEh8jOxuyycW02TGYAdqiV7dF8uIwpbKOHDf?=
 =?us-ascii?Q?JJGxo8OtaLELLyHjvtgT/nWg4IHuV4sGOFitsTWz6Z0f3ljTC0NtJfIlugKS?=
 =?us-ascii?Q?imqikByZ3Mdb12gpRTtbp7wyoieQQw/SudjwzECg2tc/DPAVdYKd6UIPKR7v?=
 =?us-ascii?Q?f+y720fN3PmIMtRwrd97Pjhs1mVp4BmAJQsWOMH4PCOzl2DhjJ+Sa3c+um5A?=
 =?us-ascii?Q?iukut2aUBEe7C1Jl5Lq001xDA+KbXV/kJ+MsnPDF5EkcTb1QdBBtT8Qzou4j?=
 =?us-ascii?Q?QDo6n3gdpO71DPfD0odgbTQzBZRF05zRSJt6YJzBBXEWuULEBZth2tuqbVKc?=
 =?us-ascii?Q?7of5F1W8IfPY0VHTa0Dy+a7Pscj4kP7OUWt84O7+5Ye99+4YC9rtUpQEjNPn?=
 =?us-ascii?Q?SUZ+1XI52AfKD1q+O3X5u01f5re3sXUpXSU0AMFcI7hRH1yLWTBNdF+MxRjV?=
 =?us-ascii?Q?Cdn9P475PAKbiJxnpBJG3YbIQUUaBuLS17FjbXNNIgFqad+1P7PZFfWzaNsw?=
 =?us-ascii?Q?vZKhoAYo+MPxBU0GLXI0pCqO9hITkIdYbX+uVbe//bscC8oRrJbhSfXc+92r?=
 =?us-ascii?Q?2pWiEcnhTO9C0a3w3sWqrgympl7Rioz6UDy+4EiJL0Lb/myQfGel5QM1fGQs?=
 =?us-ascii?Q?XTfqVLy2yXvD1/Fm2l0Csc5v8Q7Dig/w2+5xbgQHVs4lMqhU65+uJyN56ltJ?=
 =?us-ascii?Q?PMd/JFuobw2e8NFt1uU2soqaDZDXthe82C2dqtxbCirSZM3HMgeGyLcYK6og?=
 =?us-ascii?Q?Bgfynr5TAELO7fVuF35Dgj0L6zfa9LAeCAq+TeQ3mWmmQTOjUPKtfKl2knrc?=
 =?us-ascii?Q?t9uZZGQruIKReeGg62Mb6WLELFGFkNwrVigo0L9qWkpRqX3CjFS5UPr/bZc8?=
 =?us-ascii?Q?tbanMpjI1wtmLZSMK439WyvP3MTPdHllE/cgP3mrNvXrpUCdzu9Opua4kBeY?=
 =?us-ascii?Q?AhhTxRsd+J3wHgrz4Y4iDj2mB3++GVJk2jB2RR5KrZdS3MBmIFWh1EDcmTEF?=
 =?us-ascii?Q?VamEfi2cLsUD0674tLtKagMewkNEr28U58wjS9yDmL2DRQ3298CuPhSIiAGt?=
 =?us-ascii?Q?zaqhBxFhnENGpswyjY0NxCaywS/s9ZHIPRnW+MUT79crai8VSISXt7LrAMpy?=
 =?us-ascii?Q?Hwz3/9Iay5SOlq1sUwjjcbbLyOgEuw/HueZ5UPhYh7/rfiFEYTYgNhVWMM7O?=
 =?us-ascii?Q?yy7IN8oaflUtMPAyMm11NRXCyoO6OShpwtx1DmRbI51TPveP3+5yIzLt76dc?=
 =?us-ascii?Q?5uPP1QhAgCRQp7Z62ypRDlPqm3YohcEjjm4NtKBkdwmq7muV8ufQgm2U/9yF?=
 =?us-ascii?Q?ReRTQT0JYHOEIHf92GVo0mOXWDoZYR0JPm5gnT3ZsxwVcFdR6pGSWCf4+80I?=
 =?us-ascii?Q?+BeLqTTMMIPt/NK6XOAkuigZPDQwaSgwkRkWDIe3Ape7Kf3hbb0u2PAxkg1n?=
 =?us-ascii?Q?YvVXpqVL4wCcYy2v5rZ5ohGC3aSmFZbKbKbOIg9hn4kKXjKTsoOxftF9ZHbf?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZhWT+As8JEcraul8EtX8kWkQxlMWdb4gUO/WEHgR3V01LcsP5xkUHxaaUA+eI4RrC2dSq9YCjUaIajov+sZHqTirgIQubHNRTuVyyTth/Tqb5dttBEfdQe5jJVDcSkgZHUhA3ACLV40ri8t9E4i0bJhUAIC4Kkl90poUjkE5jVND1VSLq8oiU4w/5U7leNil13e64HMF6Akjhv65O75bSO8Y88Jmr66VsTOG+hryqDQug4aDToqU8TrEFWw5IyalrIdq/SOyBtl5Gp+SvFarNbHZNe+EHEs/f/4s6ICHQQeM7EyeeuPwL/FhAOm3ubDJr/FcU1fs3FQ5njsSFwQ0KgwL3dJLjzkWArfmByAQ6gLeOlcQDXppU8CiBHOfSHo4c3e1gQQm5ErvThTahRIBwtQ9b1SwnTaFsp0+7sJ8xSKA5V/D/kCruTUWukkonXsQw/c37x884pSEXPrDSUtwuB1k2L2YBW+Yx9XV/aI9ZwSdFdwrNHRiqPH0fLdrQ7xokTiLwXTdJV7xec10Km1XM0N3F7UiBS56PROGQVWT2tpqAvpS1xHNVotTrzMhwrBqt9a8stN+RdjPjtKU0OCTDd00TNSOADL4c3Hoc5yyMspKBpqMy3ZBYI2ilfJNDgkbmPzlx8/12dlbx68x8s99y8g3ixcIK6A6iXbte3KyY6OgTD/F3+OuA+QKKroWRW10YTuLHsycKYiZBY/ImR87qBIpUNbnxlteMnBBn1r52fV6kSEqo20e+fSJgR62toFCZU1eA7U8M5WDPxpAcIQ3bXWPpazoICCuAWnJmnoVd10GBYLY0bDy8jrugdHhSFw6iIcQlC/5zuQdYFoHufsGO+NBeT6KR2zibOPb/0RvuEGxO8rR+9AvfhSU3N/Dm59H
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012fec80-82a9-40e6-e8bc-08db20ee55b7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:41.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZ5iXQEgiTibtzvONcG8s71oILM38a/LRdFqpPXLaP7yczpZhc1vp6nfV2lW57FZqrLPO7sP+GDO/Igzq8dKEl2T38DQS33Kmd0NXGGF1ko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: TH0dcJGqImK0Bz-OyBTKz0jZvvIzJ3rE
X-Proofpoint-ORIG-GUID: TH0dcJGqImK0Bz-OyBTKz0jZvvIzJ3rE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have to print the tag before we do the put, because the put could
free the cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c260cb60f5cb..a39ffb8133f2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2970,11 +2970,12 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);
 	}
-	if (aborted)
+	if (aborted) {
+		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
 		cmd->free_compl = &compl;
+	}
 	ret = target_put_sess_cmd(cmd);
 	if (aborted) {
-		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
 		wait_for_completion(&compl);
 		ret = 1;
 	}
-- 
2.31.1

