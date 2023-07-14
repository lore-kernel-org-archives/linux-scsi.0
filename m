Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1662CEB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjGNVef (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGNVee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:34:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDB83585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:34:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4j5w005231;
        Fri, 14 Jul 2023 21:34:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=8EW21UDDagGMjKJy89eeljYMCMhjma/Zc0tb14bD0/c=;
 b=Hs4OMTUVC60AFKp92Q+5D0H3IjFrgAqwu+293bpHpsdBcsI47ZODcdAjul+1M53OdxnA
 8fI0ns3dsYXYioZdVFa71O0dNTMKSEzJuKBmvzTVoLSm+n8CWxKkDca1tnHhuU6xuVjF
 S7b4uWHi+sU9RPOGJhrTiSJRTUM5Jxdtlu1WoazsUgQNWtrPmOUBlzy8AWDlkPRGqFEt
 IP2QsZwgpxVlWK0ycAONqkUo3LTan9cpBi4dlzXkJkZ6iEueejqHv1G22whiLkQsIC9n
 FSUyGc4abAg8oQLPrwQNnpgDG9Gxz8qNktth+j1PQna1A+bj5yeHyo0JUcWUEoplK7vp zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtq9tad8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK4ema027181;
        Fri, 14 Jul 2023 21:34:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvyh6ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgO1aU+mxB97ThM2ybzH8/7tIK5rGdRyOwdmPkMgLbicHfPXSCVeqAoGds7kmXxK0fhlbCH7gWv+vVStdkcT3W1XZS5pKcCGJJd0EhdsvmIUfVNg8H3jn5Mm/8C/MX9rviJb9WIKRLUo9dhRPopjHXJfpOGmxYuqed8fq92m1OkNBgwFLAhMDIW8suXIJOkaXKQSCqxIbISj2M0N+o4m2I00ua2YOPLsu5qpTv6lvXJNnq2cNRJ4aW0sGczkjntOJ3bSzhiFSsBakfv/2JNJmSXDcyahXwvLDKRHbUi2q/ALzCAyfnHU28pQjtkVgavEFJc1bKeO6ltD7fa8X7ufFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8EW21UDDagGMjKJy89eeljYMCMhjma/Zc0tb14bD0/c=;
 b=aLBNfpW+lm7kOaV1FEbh9ZpIngq257ISarAHnyRYttmuvGcBf0hvv2xFeLwYjwp5O0RIJm1Yq1QjY3lzS6sGjIZItc/Twws8QECQwyU1i6tYuhRxuNPk8cflFM8DHznTIMDTiOfFhWziRP8cx5CZ5jlZOephQJvqAmYLjY2cGZOXYQsiqh9qS4Tw8TJYcaYZBb6blukJe6G+u4rWwafcwul+KaoPUOUo/szVNF80KgM6txw/abD0cvQa2TLaGtjr+NvDHxiJvQf8jMiY9rCPNFr7j+XIkA1VxIB/LTFCX104//B3eO2ksuNolpfBtbdVDM/w9NIWm/BfEO2mTERqpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EW21UDDagGMjKJy89eeljYMCMhjma/Zc0tb14bD0/c=;
 b=o56xJ+4Sd5kTYn68zWIrkdABAnW7VEHRUjd8nNLrxvJs0Dlls4mQAtMT+L1+umtRIFnA2CuqFelMg8ycVoWvm0ZpApLJBeR3+4ojctJAdAZbuDj5c4RxwPWzyGZCNLj9HZxQwBtuFrObky7O+0HJRC8XIaD/TdLvz5Vx9HGqf7Q=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:22 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v10 00/33] scsi: Allow scsi_execute users to control retries
Date:   Fri, 14 Jul 2023 16:33:46 -0500
Message-Id: <20230714213419.95492-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::18)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: c9f4a881-2b8c-43d7-2f25-08db84b216ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNz4zZKAOVHGiUKKbTDn7geYQT+ECNUhBpGL5QxbDLNEekhssUQs0ecA8OWekYfYgMkKnX9gHKcctIsdLnmR3sJ1UcHkvX0TH1kPm/M/3y4KT5gXJuZvggLTiJgILSkRbb7ylg5zxMc6gWfpThgq3x6qlILlBIcSKTk4y/VIp3i08m/VS3KEpkOp5sjgteSE4mMxgH/cSsj7WibVxez4ppA4ulaiTYRVh3UjJ71g0X2kwceXLuWm1CZoZXbpbs5O6Ap3W0WAfPXJbr/OrhSDNk+B7GKXfN2N2dP9XfpJdcTpth4qHSuyYTBTu1H0rvbFV9oQRQ69bPi3YzANqPk2zRPR5qjxhJg9/NC0cKHc9S1DIlOEhcuMNSndSwHJRmkYeHYHxLfCQm0rwrIKqqkqapkn+z3tAqQNZiDiFCqukBRgIX7RLEtgeHHMKX988YMRQiqz78fgoEV+agTwZKiH7Q82Aex9jFO4dlX3SHWTQSrT6AvDleJM5/nRJG0J/24jbe+uU6ju3VLnUPbk7ojEBZuC/VBJLiXENQFsw+knAZ+qRJC0h8viLVmCJRsNt42n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(45080400002)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ryaE+Rniqw85NtYqtiLuSix65ftXrpif4sJeav3alZcAqxrtzSAt7tHb2hW?=
 =?us-ascii?Q?64n0dTSX+fLPJ+RQYe65claqKlcgH8Y12NGJwjTSldhdU9mF0vqpgNxz+Mnn?=
 =?us-ascii?Q?vUyJYid+18q3W/ZMVQ+vhAx2gyD+zWTAK1Z/5/3XbCQGkzTCjGvcbEzGVlsi?=
 =?us-ascii?Q?z+XlqyL828mSmhVkKeJ4W1ZcP+y2YHe/AGbOnbPZNp+UgdM53TTar4r+A0lO?=
 =?us-ascii?Q?+jwLQbn6cFVmWwnNsBpFWmhUP+3SwTGkpGNCfFhgkO+hl/iF8O5P4ag3sbSG?=
 =?us-ascii?Q?ZN+kiYSoBhHiFdtZgY7nFCAC9aCw8yYgsj2+kNEIordJHl6By/mRtJNr+vTk?=
 =?us-ascii?Q?CLPqi4UjGAflM4iiWJJYvSxDiN6p8GoAK4XIlZbTkzt5ft4OKhU6wdXL216n?=
 =?us-ascii?Q?ddkFDXXZxbj99pKE5zvbIjAtydFjeDLTLTXbtdr7qoC0j+V1vh4fsq2Sgg5r?=
 =?us-ascii?Q?NTme6panbWEDiKDRa2fDrkn3/q1vkea68xcwuM2L6xLVR7NSfbR6HH6mltuA?=
 =?us-ascii?Q?sWrPR0m9fT8N0TTUdDv63c9wYZbuVry9JYow1oGZtjTp7ETjLlcNHnX6UY0T?=
 =?us-ascii?Q?fxHBR+wHmCi0QMoOL3N/njpQwTNTGoddTA+s9XUu/2ORGIIJKNRbRKgHs0bt?=
 =?us-ascii?Q?8E+wnYT5htGT+uTov9fi1VfCJ4rJtoAb6cqY8dL7g6/x70a2cvmTMjOC0ROK?=
 =?us-ascii?Q?BOXE956thbo8pozQYoo1slJcB8KJ2DReYbQ8jQBwyk/0e3s4mx+4if0tuM/4?=
 =?us-ascii?Q?2Qy/xgD9YrG8P9k4vtsyfcAcNk/q5N/IWRo8FxOLKx9F9L28YrLfvMJGL6xH?=
 =?us-ascii?Q?SfrCUk0gD1EdOwi9HI5Jwuc2N1rFlW511sDUp2TTfdqDujEkMYxbo/h53q5Y?=
 =?us-ascii?Q?YPgBGGrdUcmsBykNV4kvGFowlfzuhAi8RxffTQQwPGe/2bVpNvbksGaZSr8Y?=
 =?us-ascii?Q?/c+TdIxvRSrRhGsnXENDqT5MCwvQsUQf92lfBt/DEaYBpvCuR9CnL3Ro/PVe?=
 =?us-ascii?Q?cQwSLAGzM1Eq9zFLpT/rOC1J0mlt2Q+j4UrSTwAJwk53r/feOlSp1jErCq4w?=
 =?us-ascii?Q?1Yq6yr+vTHnnYle5O7NDxP3tvUMtc/84CQ30LUVb5Lp/pzBf+Y4v3BNPT8jI?=
 =?us-ascii?Q?tUwtdkE6OnBSRR6ImjNwkHKMPf+bsv8FN6B6lSmjGORjfOngWJbadksS9o0i?=
 =?us-ascii?Q?6LwKN0eZR+B0v6SdwLLMXSPH2pFT4Nchin1QCBGq2XATU4dd+YzyPLakopAL?=
 =?us-ascii?Q?scRUjZYia0waiGBdQCEg/UKkytRKuKwWBcxxldia2ZB2OvfJhJZEGo9pJAFH?=
 =?us-ascii?Q?8L1FkC39cZEMVHpmhft1gRKHkEnOUOO1xQtAn+tzTU7xFdf/pBBWzThlnHvp?=
 =?us-ascii?Q?A10xHlwpMrBg9HHGUczlLw17IlBQROXJ3sMJo1w6i4dwhLJ1veKe27O9o3vx?=
 =?us-ascii?Q?bgJYGwtI6V+V1cSthXPUpzUpoXhCsZkIslWmWFLFLms4q3j4EIIJLAAOWcmw?=
 =?us-ascii?Q?5AURRV5N9mUS9UZ6Mra4beVi/nCOCkhDOwMLbJPNxgMjwccZku2puILi7n2R?=
 =?us-ascii?Q?gcSHNgLwL+4U9vQrn6GP1DZezFMoV/0BDhUQ0GQSuTjEvIrP9/b7b3YA3547?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hKmtNuoh9DK61TfnQAGgRiITEcA20oLJTN3d+o5OFcw3rSlLfk5AlqKalalDcyF1tFszVbtQgewENzT+SmIpbpXpSOOK0c+wAIBb4hEa+Gd7mY8r2H/eql+waGmE1ACtGpUQkMcLXJD0V8QLMXjCbvQNIujc5JQhs2gx7iBfyuQfkObG4RXxBZISCQWcuyDI1R4d950RQTjfzshqK33jaU1BHl+mCxn3sBmqR29aPslWnpj6az1kVuhf6NMoDuROJFwihOcUGEOZKZIvPjdXQxMMyS6NHyh6kedIXUwE4yRV6uqnIoREp4FTISUQIPYa9h4kOXvhKL551PR2jGO9ZRtqyjuCuuOKTqGBzCVqO32N2ZgzC+HXptjDbR7GenH+h73WVnQwLZZtFJCR790gVs93taGzGohsGw201cqyD2lt423pRnS+M6aGyThaQ+YrXMlY1yMvjnZWrVceB+Ex+DEN8CiSRJe+3ujbERy3aCSPCbdCTFiRM+5noaqXDGfKwOo7/ydn2s3gsiflL0cDwSuKrcLqBylq+qGapy30s8qImfFq9OvGnhn/dFH1KuuOO1EITgt3Rc1TiKb9jes5Cr7rv3rEd/o7LR5NtqTI+YsM4ELTzUJ2di46EDNchZD5bX+bzbwX4fMha+IfrKV4ywidbt+XGzwYaZxYuJTqc8KKYWGzOTw+Ev8n/MqJkccOSWL+QyYokAqDqNJYS5Y/rtc8rUIgexzGQ93WpLA8ag4nHuyHaQg1plMGEjcJO27dezqqsCiWo/za+0rambEKGuD7M8qqX9r4JP40USP2FmNT2bDnR94VQ3igmv/LbTqpovbBOVZTB/vRv8ldwoZ0Pa79y0ilgVmCCDbTgeF4sc91xUSk8zbfXh54sZhWMVav
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f4a881-2b8c-43d7-2f25-08db84b216ab
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:22.4380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Wie03uPShUiKEvDa4PryO6YsfY+p4tRZDVoGsIAavp7IDLr6mgkfWUlROeB72G5uSb+w+7w/zzPTdCYgpeKcA1aabRHnFt42PGnbx71dqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 5eipKxDaWckbKhXMfd-bc-lzUqwln0Gs
X-Proofpoint-GUID: 5eipKxDaWckbKhXMfd-bc-lzUqwln0Gs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

he following patches were made over Martin's 6.6 scsi-queue branch.
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

v10:
- Drop "," after {}.
- Hopefully fix outlook issues.

v9:
- Drop spi_execute changes from [PATCH] scsi: spi: Fix sshdr use
- Change git commit message for sshdr use fixes to try and make it
more clear when we need to check and when we can check.

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


