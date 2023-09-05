Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67762CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjIEXXl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjIEXXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:23:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FE3A3
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:23:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KnmE4009395;
        Tue, 5 Sep 2023 23:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=G3se8qOZYIPUk3elnvLqI+cTEJztDD16IrXEJ/DKK50=;
 b=L+ObTvM+BkfU06DTm4DnoiG6mXjVoiVOuWSEzJsiuoj8wlL27d0GzkkOhHlgCwIaerLU
 pZC+JgkQaQ+Aw8fXgHsD3JgAEmsD21f3GlOoritEWUwrg0VC765/8bdBmShxt90Hnd/T
 YIrVuQTmHmo0jX4IvsfySGWhMUohC+UsLdt5WUIlxTKiwYeZJj4J9z8Yv6PqAFnLBfqc
 efz3Cx0ZYUVq1dGqk8laF2DU7h8bJ9LC4OqjPn3t7tQxf2a/1oihkibVwNWa3PECwAeF
 DPB6m8fOODm/e+6oYPTPF644p4uYfW1Avanu0BiylaGNC89Q1qfYyKrEdXVVzUsx6yCt Wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq389bu-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:22:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M2ToV037100;
        Tue, 5 Sep 2023 23:15:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpc5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:15:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n69HN0y457vP3PlYjE5kBEcT0hlD8XGl2rxq11iLat/Aj2PMLvjmm/OCKU6xt5FmxDrTfneV4pyPAI1gelg3mWmTO/oPkHq/5jx2s5t/HJNWO1QkN9NX3m9KdLJZrS0Mv68xw3B/WTqo1lfAIel1K8AiF4dpmS+7ZgbK/Iq2UW8WP0c0DTZfg91a34w7bGuLGwKLru2ynrMdcwdEp29aix0GrvCSLTUEcmOPuBqWNGJHgWYlck19f7rnCKyekMzrbnGHF/HhZzSMrdWJra9gFV4Z+Vbbu/5dxVh0QqouGeMO/qxaAf80SuP7g7dHV7No2FVmpy1j4n5BkUTEA4hVcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3se8qOZYIPUk3elnvLqI+cTEJztDD16IrXEJ/DKK50=;
 b=SRv5e9imU/LM2dul6oM17b2RZWoGqX3968e0hfFn3ayS6kh2C7Y43LkGckKd14To75NmNpUNzJmsE8ejWyicnWuJqj+NsBw55aXco3ifMv4NLL0Cr9xoTgiwaTtytfrCGmE6LSNUB0tfIx7qwtoSjpKmyLYG6toePp3Pm2E7eEG4K8teb6s1JUeka/OPaZKAHGF46JNV7a4vduFun8s2zaF8HBZDYfik0sZaPtH1SXEoH4eUQGSGqUFJl5zFPhYu+eND1ZhqQ6wmgdYB1OdNn9urimu5+VQOPr+cHPM/ILvpsUThWFaVLGddMSXTJiM3vb3oNEZusgmTLxIKbgrqhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3se8qOZYIPUk3elnvLqI+cTEJztDD16IrXEJ/DKK50=;
 b=Du/wkQ5KbTySI35C2HSkmq6qCAjUxW8PqjcBmfwRGt1bRJba/W760BfQ3B9310oZDhKtL7cY7dpFmVaoBMNd7ZNhcPF2V0dfvmlU3w1XRdFSSqSELGtbusTxDdUkEtzou2RqVUbc5ki2Bg6EYrdDVhDdX7VXza33Q7CMC2CjyzI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Tue, 5 Sep
 2023 23:15:49 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:15:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: scsi: Allow scsi_execute users to control retries
Date:   Tue,  5 Sep 2023 18:15:13 -0500
Message-Id: <20230905231547.83945-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0018.namprd21.prod.outlook.com
 (2603:10b6:5:174::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d8940e-f81b-4db4-eea6-08dbae660ae7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s33Td6Hu1JuhwfC7TETZNlXKSIzEb63Do1NtIBFxj2OZ/JjlIQtV1MOQZNZ/VZ1iccN2UfWkN19XHuO9V8Cx6HU96a1iatHa+3figxt5JGedGZ47o6mSlJNtmrihLEH71buqEpvUyWKyHRv03u4bE0B2PCYdp4+VHS25xB6z2uXiHoWqsIbACMm8qL6R6VUZs+ltysD2bXwOg+pKookHPZ3TKH1bpu9suFPv6vb7IjkhPPaGihq7llmSr+I2soTfgxK3ktiIqN5aLKSij8ZTTRBIKGQkRlyGQ8LFjzlG28MV5DLCqfpEZ7iURD5N4f+NkpJDfV6e7kWesH8+cHkeHMnNHiNB+XBphTmQRHubIGrM+Dw6I6cw7JEIUGu/t234cLSE5KqPkRzVJxDRaaeJO/+KqEifUoXMA+Bmo3vzCndJaDsO6kkDGDmXbjZ291Z5/vJvZLYk++A3L5TzLkMynTEvodVmvdJFlaXA1kqcPqw1DIDomqFXF6PvJHAUs11kwsMq+hnYbtdyqwmQbNI11ou2fNaH6PFEElHn9dPBpS7Tw2qmGNfFvVFcB1D6Bpfl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199024)(186009)(1800799009)(41300700001)(36756003)(8936002)(8676002)(86362001)(38100700002)(66556008)(66946007)(66476007)(316002)(5660300002)(478600001)(2906002)(45080400002)(6666004)(6512007)(6506007)(6486002)(1076003)(2616005)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m/0vGSdtlYsyRFih90hsEEQj4YyiGlKT95XC+6Wmumpbt3XOjFZdjNKBKAyI?=
 =?us-ascii?Q?QlwoTZbrwcEHxTE4w411uTDrI2L1femDnkeBqX0XIa8TcJnkCHQGmtjW9o2Q?=
 =?us-ascii?Q?OLzewIslTFsk0AWg8wktBCg1K3kD6I86JpQs1x+sPO5HNCyOOSXACVjT3Cji?=
 =?us-ascii?Q?9b1sYGyili2If/g9g+1fE5P+jQ3ZvEEWTjwpsLKs6WiYlND2+CFK3LzYWZu8?=
 =?us-ascii?Q?AiTwtp4rmK2oz776JA+uU9p09t0636zEb1o9a+VSAgiukSOrb7IFe/UGPWRb?=
 =?us-ascii?Q?v0e+MEHt/N+3YLTcaR0eJmGTIAIFAS4USsYGlNx94sVCqzVpXFSi/pmpC6/X?=
 =?us-ascii?Q?v4I0r8SglAQPCurHL6RHXehmgujUAQNdQ8nK4NkfrnZezdCCznFRi8vf8qEF?=
 =?us-ascii?Q?IPI4J2XLDb4iucpUOoP147Z3OjHS0rqnZL9UxLSggDXju+JX5KOiFP2j5oRF?=
 =?us-ascii?Q?chQmMZ55mUzNsC9CGEc1P8cBUv/4yLml7pYkxGFnFtrs8f0w/cFrfV0L2OSR?=
 =?us-ascii?Q?5rV41RZwCt/4WzGJVNNV/g5lArxzUW/bafTx0uxcIEBEDzhaVlpSwQB7esOW?=
 =?us-ascii?Q?+Qupi780E4hNTb0qad1R5nP6NW0ptrZCjQb3f+uKwOyljFqnN0qTY1GzmSu9?=
 =?us-ascii?Q?xPiqyXTeuJ5Q6Z6oXevdkaOEXz1WuDv36ut7QyznHNQo0dlYcklt+e/Q9489?=
 =?us-ascii?Q?L8QqeEubwRMe6M/Xcsgrsi+S/IJu4wzhr+XqONshl0mhD8XhRed3gCE/gs2o?=
 =?us-ascii?Q?69Vsff4bcxt74QvzyF9xR1Bq4UNpt26fp52mbP9j/cBDXD/nY2Zh7G1yCgg4?=
 =?us-ascii?Q?kcy3x9y2qjnzb6CYTDIA6iY7eLhnxM8qZ1KRfJ58Aao6PfKi8ww+cEXMSa2u?=
 =?us-ascii?Q?VUJXZY7QLgUJx2jMqWrCZaRRgwl/qEBjZcizEz1OGgLOwfvBpO21pyJaelD0?=
 =?us-ascii?Q?LQh+zuybS5EdVc9LSoBNuA21dBSgbOB+v9d/uGEPmqHP8rGOM5Qx1eyphoMR?=
 =?us-ascii?Q?nAZRZhcva/Xf69qOHRi171edD4n1jKtEq6S14ValZEB0t56uolO/55PGTq64?=
 =?us-ascii?Q?mp5sH80pCwdcGGEkpACjicXfe+mKnbEw6nXBR+/5fBKW8WsMDbcxTUksnL8P?=
 =?us-ascii?Q?1d7MXB0QPQ4m1MjEKwuxAekuDEdNTbBSYFfBpuQnz1ry3/izRiUp3ezUYnzT?=
 =?us-ascii?Q?1RW7ZwzWeapmYvMtexskxBloP1b4wkSuB2wYdn/ibUbpjjbA6y8SyncPDYri?=
 =?us-ascii?Q?Ps8dx8J091N6isZHNkynRV7e9Qf/1ZwdJBYPSI7beTuKhtnc40xOU/ZttLfL?=
 =?us-ascii?Q?XmkeB3dvqcpRTefBw5U4DFX5Ui5/uV+O9TLFl8NlMMKqdmy37mzgswLw6PZu?=
 =?us-ascii?Q?0hnsxUXq9Mcp4HNHnHDxjIy2XVRjDk70gpZw4cyowYv0V72XTfbGLnxIKXpo?=
 =?us-ascii?Q?4TKmo4UdaZQFuhe80CdOt6sHSl6RELJFMmmbKE7U96S0bMtHATTPyG+1A5F8?=
 =?us-ascii?Q?GnzrtX5orqzDg9FkrWgR2HuA7KJNKHVP65XHQSo/4UBkiHcFxv3TnvI9Yavd?=
 =?us-ascii?Q?B+iPutJb6YuRSFO9siOCvEiD7rDrPs56EKl305UkBJMpJg0r9y3+upkE6+1/?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 890IlKeU6S6V8gozmQn5XqiRcH+YnrSbYNXNr/LHN8HlScFf0YIWpUGqSAg3UKnOC0tQNsOA95SeropZhnNE8DYuHW2wB4dRZdPJPigaChtSVep+9r0NPTfRJf9nxMiOMGqAHCWJgCV1l6jZlXUWTcr0Ll/ExALPGWZnEYF0HJJzuq/uzAMYurD+n1Rmuos6ezFAjzsjlu0Tno6L/MViAHEJNg74mkZl0gSWpGjxzyGCqf/mcA3wQHMBR/N9SVY4X0+jaRiBFXeD3NYyF7FUf1aj0ZN7fqvSVGMQNjocysRE/DgJkCLnukzRCxhU6U7cl7uuPBND1D4VzDytfYe15Qc/daJF9KCOz1zLYKjJ1fiLCfx6MYRbOnRIxx7L/f+p2EY11rkgblTmDGUCcz6ESH2YE/ClHkkKedrKJ27UfLfFCR9oHsr5CtXIa6dowKio+u9oSje+hwjahh/C7jL0IeylkId30koFbDvG0tAXNPt8D64JUEt20vfYRRVSfjSsJhmTQYOh5LXupfg0eZENZmgT/35z2IFr7eaSUTCuIzV9Apa1tjH29LlG93yjB5MQMHwIkojbapV2DHUk3rwIPiQqisBYeqzgEdGWo7VZOb8GuU4rwwheBj6KpzQBMdrvWZZYACMXrg4lx4QvS6HcTlsymuVFPI0q3+WFmS55fE+JbCPyW465wJ0lyFDOqrLeEJWAxzgHsWUIWrkv+l2ohXjDYo1qd3wK4Qus8losiVTU/je5KYJFn8S8hGXrP0B48hsPurnnEBMRw8jDldujzznsfuSyADkXmhMPrKQwAcq6kQapbvMJ7inuQ+M9MGZNVDyfXUAx9GdgHg3mufiXbNe9ytt7hg5PpqhB2jFNyNbrHyLl2WhoainWglRcPnkg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d8940e-f81b-4db4-eea6-08dbae660ae7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:15:49.7340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrKeG/QHFzYzvOXWjO042cdz/BWAQ4CL9PxnubJAQ+Fq0cDMXrs3dpQU4/T3NgSKPmswfWTFPuth8hmINsEyioaMPx/LwqtpBN7cbX4czkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: vNt2qzIjxhJ2NOD3KTPAvAfbTHQj_fwK
X-Proofpoint-ORIG-GUID: vNt2qzIjxhJ2NOD3KTPAvAfbTHQj_fwK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 6.6 staging branch.
They allow scsi_execute_cmd users to control exactly which errors are
retried, so we can reduce the sense/sshd handling they have to do and
have it one place.

The patches allow scsi_execute_cmd users to pass in an array of failures
which they want retried/failed and also specify how many times they want
them retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute_cmd users. We just have the special cases
where we want to retry with a difference size command or sleep between
retries.

v11:
- Document scsi_failure.result special values
- Fix sshdr fix git commit message where there was a missing word
- Use designated initializers for cdb setup
- Fix up various coding style comments from John like redoing if/else
error/success checks.
- Add patch to fix rdac issue where stale SCSH_DH values were returned
- Remove old comment from:
"[PATCH v10 16/33] scsi: spi: Have scsi-ml retry spi_execute errors"
- Drop EOPNOTSUPP use from:
"[PATCH v10 17/33] scsi: sd: Fix sshdr use in sd_suspend_common"
and instead have sd_sync_cache handle ILLEGAL_REQUEST
- Init errno to 0 when declared in:
"[PATCH v10 20/33] scsi: ch: Have scsi-ml retry ch_do_scsi errors"
- Add diffstat below

v10:
- Drop "," after {}.
- Hopefully fix outlook issues.

v9:
- Drop spi_execute changes from [PATCH] scsi: spi: Fix sshdr use
- Change git commit message for sshdr use fixes.

v8:
- Rebase.
- Saw the discussion about the possible bug where callers are
accessing the sshdr when it's not setup, so I added some patches
for that since I was going over the same code.

v7:
- Rebase against scsi_execute_cmd patchset.

v6:
- Fix kunit build when it's built as a module but scsi is not.
- Drop [PATCH 17/35] scsi: ufshcd: Convert to scsi_exec_req because
  that driver no longer uses scsi_execute.
- Convert ufshcd to use the scsi_failures struct because it now just does
  direct retries and does not do it's own deadline timing.
- Add back memset in read_capacity_16.
- Remove memset in get_sectorsize and replace with { } to init buf.

v5:
- Fix spelling (made sure I ran checkpatch strict)
- Drop SCMD_FAILURE_NONE
- Rename SCMD_FAILURE_ANY
- Fix media_not_present handling where it was being retried instead of
failed.
- Fix ILLEGAL_REQUEST handling in read_capacity_16 so it was not retried.
- Fix coding style, spelling and and naming convention in kunit and added
  more tests to handle cases like the media_not_present one where we want
  to force failures instead of retries.
- Drop cxlflash patch because it actually checked it's internal state before
  performing a retry which we currently do not support.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args


 drivers/scsi/Kconfig                        |   9 +
 drivers/scsi/ch.c                           |  24 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 106 ++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 100 ++++----
 drivers/scsi/scsi.c                         |   2 +-
 drivers/scsi/scsi_error.c                   | 112 ++++++++-
 drivers/scsi/scsi_error_test.c              | 170 +++++++++++++
 drivers/scsi/scsi_lib.c                     |  34 ++-
 drivers/scsi/scsi_scan.c                    | 102 ++++----
 drivers/scsi/scsi_transport_spi.c           |  36 ++-
 drivers/scsi/sd.c                           | 366 +++++++++++++++++-----------
 drivers/scsi/ses.c                          |  60 +++--
 drivers/scsi/sr.c                           |  38 +--
 drivers/ufs/core/ufshcd.c                   |  19 +-
 include/scsi/scsi_cmnd.h                    |  35 +++
 include/scsi/scsi_device.h                  |   2 +
 16 files changed, 842 insertions(+), 373 deletions(-)



