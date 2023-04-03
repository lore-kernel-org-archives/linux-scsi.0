Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9E1C7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 01:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjDCBlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 21:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDCBlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 21:41:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E0C7ED8
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 18:41:28 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332MQsuj013062;
        Mon, 3 Apr 2023 01:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=0V9y7T7QLvNRQsfkLy9IodGN6LOhJP+6hiTf3t993oM=;
 b=evSnTkhDT0iJOfIz+LynNR2+cxpCm4XQ6xEDxa7n0roLrjIgy5bTLSPRKlxdo2Jc7JOq
 RMaojh0r16zynPRGIpDLa7jN38Qc25/gW29jtpPXxCMA77cKxhv3hGb98jAahmBgDCM1
 WPsaAJA2FVyPAy+mY8DcegirQs7vAFql9TqmxHuaW6MU0Hh7uacMDK1ENjGrOhPUQjnJ
 NQ3jGaYFrwKHz0wdSrzw7v94P8qJG92t/pSyEqPJGaYO/PskPNTXDmuFW8f9ze8/LQiH
 pLdhwl2Y272K8zCKvQhjOpQiM2sTnkPsXQOzW6iLX0ni8HQErkFKDljeC5gPyfPsjqS8 TQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcgahy1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:41:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332M1Ofr017611;
        Mon, 3 Apr 2023 01:41:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptp4m0rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:41:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KW64CWXkcMYeBgkHQV0azUEN4pjmGS6GKsRVtnb/9u/cS5YDH4Qk2QCTp5NqVJbAVEM1ScGZtWAob+vssadcq1e1ejT4WUAB24/R+Od98f4NqWCKf3qKBm0rTtCTsfr9LnnEt0UB1zym7KYiuPWmopDI5gqA3LL7EK5nziGZep7AZL/rv1pPO5Sxb0cV1FOXFiyoYPKbQBC1Qn3Edse4Kp8zf6PSeMN/Q+/vDkaMntDRMMg6cVw5CWxu1M3wQiAEJLWQfu6R3g2DGMkFUBvm8DBWtfwqwJ4yN2j+Noe7GQnhASENj9RPuRqV/NKU50ANPu8UJQG11JWDt/ipKB16yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0V9y7T7QLvNRQsfkLy9IodGN6LOhJP+6hiTf3t993oM=;
 b=huVi/R5NVrwNRmWNXqDAgjYGcW6CMF+P0h9sQV4jFlo/bhjpgELhe/TTsl7cERwoGpSYHA4CcJ/aEPYf8Ssz9j9TEjZiYhNcYrInq8YnhPDLI+my/ZC9ojxEkFx2x/nAe3yiAU0yY3/fSJtG9ZK5KGgk+Mq1Pr+HHUZF9maIfUd7p0yV8dX6e6g3vhkjg0jUtk+wbcC5XQ9B8BXTGqBHkmIkV72BKMIWY955+Jw5hnA/tvuqpX92wj6qiHzlccHnhJdjfUStYnZ0CA6ARhuU3v1eEHvgS7qutD0dXtd5tZuMDsa5FSVJHv8XCB0XODAZTc89F+SI18YSWAM7SrBfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0V9y7T7QLvNRQsfkLy9IodGN6LOhJP+6hiTf3t993oM=;
 b=SjcxY10SDAGcE2TY/wvxGVL/XCbNcJ+/Y+J0wk28us2FZjXwiB94kjCzKakXsR2JvEfN+fcBw68nynQlb13DbfOK206evQ2EwnxAfqCd8L8j4OKwCs5JKLEFOKNFVNEU85+gIchhSQL0Y84WjkSbHPnLVMQNJxIqHe9ziEPnk1U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW5PR10MB5739.namprd10.prod.outlook.com (2603:10b6:303:19c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 01:41:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 01:41:20 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Lunar Lake
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfdhwxmv.fsf@ca-mkp.ca.oracle.com>
References: <20230328105832.3495-1-adrian.hunter@intel.com>
Date:   Sun, 02 Apr 2023 21:41:17 -0400
In-Reply-To: <20230328105832.3495-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Tue, 28 Mar 2023 13:58:32 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:334::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW5PR10MB5739:EE_
X-MS-Office365-Filtering-Correlation-Id: e961c33f-165e-4664-faf9-08db33e48666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: az3uEo3Cbj3+Apqra82xQpfoZ1ejQ0O/XYTeKgYy9lHif0qzyLaX1wz9muxl/dtSSZlN/F/UJbeW4S0NX+nBXRlfmg4jwCiDY6qcSYaFC0Vg/F1ePn41afC7QfkHBe5+HghKQMTU+sF8VZ7ZZUdWg6qqEgqUs1yTD2h2Ot621j60eETYOw3rZLip4BsM1Kc6MSP34waApgBqPxBhCPM5K6Qc0cH/cfFD0GAUpHugz8QPrctFjk5za+CqurAfUT65wjl8P3916/t6Jb7duWyuTW16Op6ORya/wq9qqsT4i8XgsE+3mtrwOZumF7vlbIE5N71cS6pYCzuz0RMJXDuAAB8Tf9w9U09nq6qY+fc7ceUxDEpvpgcxV1kkNlles+UxIpKTnTHVKmX6f+/57CvlmHlacgaaShVfYwREH385xw794OEIY5COqwAvIk572SWCNozGxzgrxcEaPGl1rF7joUA8qLnLlDDyKF5Hqq+du+1UEysJDt9GOBBzuuWKgtsrfEn+kOBCMD1T+FoCqnt7Pm6Lv3Hfzob3NqBpEQLfFL74Q6E/PUcZ0Hj//eu2FH4o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199021)(2906002)(558084003)(6506007)(6512007)(26005)(6666004)(186003)(6486002)(36916002)(5660300002)(8936002)(38100700002)(54906003)(316002)(4326008)(66946007)(6916009)(8676002)(66476007)(66556008)(41300700001)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n+7LY0S8uxCd/2gf4MM0yTHNKgTczojexsILRimhDVzoiADvwYeurWFLMakc?=
 =?us-ascii?Q?FodzMLyiSEoek6UB3kkx7HIbR6qklb7b/bhpYiZ8r0AHWDH+JeEfKAcw3i7f?=
 =?us-ascii?Q?14d01eyn+dwvLBUsfNJ8jxp3cwjkXIgz3qy+3ytvMCPSnnYPMvK7NG3IA5+0?=
 =?us-ascii?Q?1lmASuZdYCnJhgOJUWY5amtij576apyzJoRyFRwfIJtK4sJMJCl9P1jpwsI9?=
 =?us-ascii?Q?aQWdr3tdB33D/EPcPyB1CGEN5o9U7/JoRFshgNlrWEaoHmbGpJ4PmbHcVDFc?=
 =?us-ascii?Q?26i9V61jD8XgdVCJeA9TDprVDIL0CB8roL0tJ+kFJfC8SyZUxilHyR+SQmHB?=
 =?us-ascii?Q?sf+oEAHsXmttpe56MeLktIVaquVCQ4Ir2H6hlKfJ+X/+QFLlDGLIukL61wfA?=
 =?us-ascii?Q?lgBQAw5Bo8exzsjYZ5JGj7vFYHGPvRFmgjtMqMfS1Dlb3ScByhavPGDCV52F?=
 =?us-ascii?Q?fzyoXT4Oh8TMjlfFgOFmYEMF+VPA3AumCopGe9mWRMgZh0Qu20WL118mBbW6?=
 =?us-ascii?Q?8MUIgGytHA5yn2ZFrTmF+fNkUcz0gYyh4dgpsh/3gjOsP4YzYTLzFUdb0Dnb?=
 =?us-ascii?Q?+wV02gTZCGPephvPQfaQD9smXpeNsyK+qqphhNkhnZWpqInzrP+6ssdWt++K?=
 =?us-ascii?Q?Pma/kei6l1FZpSZV96JNbjdJLjadJu/ZyIubi+7W/6tW2PwneYhUQAHqSxm3?=
 =?us-ascii?Q?DA7R9TE5o2d+w9wkRUltHpKCULM8QKHatQ98k8CHemJiW2rxbMUpqwsktvY5?=
 =?us-ascii?Q?DVQBZ3hFzJlm3Fp9t5kP4g0eQ+HOI10+sJkVzHjQteHgCe35hVpkr/CBdtq4?=
 =?us-ascii?Q?jcuLs2bxdIz3OnTSxkqZB2Ly87ZPp/kK7uFxhrS3WNzrjCX+zppTT/SuqIZf?=
 =?us-ascii?Q?7udF+4kxh25sMlTlkJBWdBgs2B3bFFfp88r+MzYDzZDMM1NgTKdioqoUtYP1?=
 =?us-ascii?Q?nItpKxpjNtzdhvSLSpTrzpSoFGgzFs8jixOKD0RgfSo1NoirukTst6eXe6p6?=
 =?us-ascii?Q?e1hgkIH7dxBwu+8pGDgymuOgdZXFhfMj67U7PrFL5osTvv5LIk+xcipGt+PQ?=
 =?us-ascii?Q?SDkZNLoRpgI6Wr5yzlt9ZtgFd2OjSYgEzv1aeDbOb6ylWhC1NDICme/64h19?=
 =?us-ascii?Q?DQybZmf/+FmJ1fs4bs/f3hRayGRvrcJgsJBtuPF/6zkLpplWVMd4LFtyURTG?=
 =?us-ascii?Q?/YFqyBGYww8I24ci+XjludN8m66sftxRGr0w+AVqw7fWxUxCAccenT02VTlv?=
 =?us-ascii?Q?Q9u/0VxESTI0BwwXcBP3rjkmi8puj0GB2Zc599t0ltrWBzDkfMe7J2JzTjtA?=
 =?us-ascii?Q?nYsMLB0O4owZZeuFS8w6hI21qb/63DyJINV8ycGYrwvqdiK1YeQrZxq80qxW?=
 =?us-ascii?Q?WdErlHm3YxN0nqTPer/iFV1hLiza+yZk+T4FIdUUv9OgHxKGYjwywf4l+Dn8?=
 =?us-ascii?Q?5hweICl0fIEdQkCyw8hdfpfl8cCuBcK6x1QSHh5f/zBUWmlRYEsDWuaxbSK/?=
 =?us-ascii?Q?wxBn0lLy2wCBPd+gu485VCAShgeSLMRqf0bQc/5su9FBhboAKD4PM20tella?=
 =?us-ascii?Q?bicsIMP2sV5yF05dcgepRsN7SoRwjU8VFYqE1fErpOG6KvFYgybyCR3FvF+q?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GQryv+hHAmenvwQZfs0ZsN4DHgiIcdHgO5wd86zHoLQDRTy7eRaS/Nim7sH126ObWBNDQY2/HO1noeF9Q30AINTcfVuyfltSrdo9u2hA2Emg/eqxIGxPCdDJU3bsrxUAIVsMg350w/YLwEivVkKgrbBFUTLUJK7jHfWPY0ZxAqpuMeJIN3JDPOxq4mq6vKyUULA1/98mp16Nn+ZznjZbTCaoD5BBKCA+ohgVtAOfaYUCJvbFI8myVJQAAkQ/geEwVRDy6mh8IGCMi3/fjA6g4VjMvlZLWhf6xol+80rDt/FIWn08qXfDarQJENEsotJqoqnpZG8gKWE3DypZXF7d0Tj7rv27VyGJbQKv9KcqQ5r1G9fvzlr7FMd3wPuEiCc9mCPIIUXCLvOODSqB8H4abGrK4oE/Te1oziYesak2nlgsiXgL+AOlTtH1Cr+NnoE4qni4FN088KU4yva3TyJgeGEbOQY6MrRMfrLYxmJ7rFx1QehISnoOfbE8I/8b3BELiqgoZFGhOQNG48B41u06MfKDLqs4RKsaYvkVmuuyozHaXixXaTJGTRHILYJZDTAZrFwJW1SCf68ngk546sANOjKS2Oqr5bnBijKinGpAZDDAWPzgxskpy97eAzlKrcB+RZyeQTEIdKplWF0iweOVe86z7QWPT8Ay1fwAllxiuWTG52ild8KLtoceGb/Pn5u/ukLD3+kjkGmeEc5Pu1TII3+TgRxg5TmAhXET48sCWEwV6Y9S9wHTo28MPQ6VWEoW0xXwgiO47yJFQJCGhjXpe5HJN18lAFLrI40a28FsUT5OETdw5ZaSrCS5HCYcV14RlWHGsoBhNF3tV+AFTFStnbkZ7+y+0CwhymMqta8iLNFCyCYYScOmqheLxdWmjBj+JYfIo5OlYvKXkBofDH5xZA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e961c33f-165e-4664-faf9-08db33e48666
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 01:41:20.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHd4RzLOL0Dyzkb5ZAMrG9LD3F5vLkaMDh8QXYOajETQ2wDIrQE+ctCd8ktJXc6OK/dt/1guJJHtfzt4h1xDL5Ye9HzxLLTHi6Cs1biHTpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5739
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=883 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030010
X-Proofpoint-GUID: lIEN1bHtTZnayOB-KpdvtoTbKusv43Q2
X-Proofpoint-ORIG-GUID: lIEN1bHtTZnayOB-KpdvtoTbKusv43Q2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Add PCI ID to support Intel Lunar Lake, same as MTL.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
