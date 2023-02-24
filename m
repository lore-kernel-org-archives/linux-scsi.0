Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0988DC7EE23
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjBXRpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBXRpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:45:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E6BDEE;
        Fri, 24 Feb 2023 09:45:32 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHiJtR020501;
        Fri, 24 Feb 2023 17:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TC6mAomnyxtZr2645ZkfzKQiVb1jyBjfi7ZP1TCNrEQ=;
 b=HdhLod3KUp+Nk2V/XB/+Ju92sFSk6x+oEv1sXIEUV3nzmZVqRJW5J9e5rGSiZNF2q19A
 lPc8Lx5nG+bxPlY1W9lkWGMYJzgr27T511+vT1q4s0v8UPqeYvOgIy9ItOQaxekk/U/j
 o/hCd89JnuVeXqSTxCxaxRo4WN6ythDjYexat3SPbmFSxjwFiPIBduBcB1EK9pYVD00f
 O2uEOQAarHUFgi9Tk0eW6qz55Nvz4RZX8E9wJ0SOfEjOraUHKwmhJcNfpODD9AFmFilV
 YnuXj3Xr09diO5oIXOIk8ZrhYcmhRQ74ELNGVcGQ0V9FZElw3p1XGzyPFFvn2+SFVumg 1g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpjadkp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OG0il1030220;
        Fri, 24 Feb 2023 17:45:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn49ssch-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2neu7/nuoZ5I80gShjXUr2MDW7tSXIfQJc7upXBg7JwfNLvOk4TjvoRPDvOLlklUnuwfYdLIoYFlUEYg+EtGM3queWTy9DPKqlRw9nw8Ojqdog2cMNYHiTICGnwpC9Zz8yhL553hj02OeCG8g9wUy6im99HlThrOdiczdBZeWtFvoKF4FOXMFAvxnrrhwtPP8MFy6AUgvs+S1IdtkXijw//b7g/WwBwvbk/EsT+Y+5blS+9+CDg611iDcs16hESBFkN+rircYNeYQ/AhVHeJjOvjPgTzp/gXMAErOXtjOjfCVptoQweUljIBp/DecMR6E8GjsaD1m3d8LenM1Uz9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TC6mAomnyxtZr2645ZkfzKQiVb1jyBjfi7ZP1TCNrEQ=;
 b=XLcSGm0ffqNoG8Hc3M1oCcNAlBzfSMEgiwrXdmEXH7HaRBflX4Rl1RDzHJPi9RnACcPb8BCnkXkGtpkNvM1asrU2hVHAuVrpc+oTRKaXxSbkB2YcHU++Zl0pDXODsSaPR3njU5iAiBB6KjwghzPPsn67AcI0+0VIZK9d7cPlE/PkM1xQH47zbJW1ujTov/aC9t/FCnUlyFuwtlvV9yzP1DQaVgnS6kgi9ejsn2ZKTBB65Hf6m/OJXmGuYII79PNv/i2IGIpGXB9gX+3lez5G6k5VWMgQ4K/pZDuZoy6ra3Z62ozzPCP75jgazPKGMZ3ZiX2buuR/Ry7vuBXvkrYDTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TC6mAomnyxtZr2645ZkfzKQiVb1jyBjfi7ZP1TCNrEQ=;
 b=kAxRV1wVMYsijXkjyiSVYPjAwNYL/4MAGImyKc5mXPq1BrTPg96/WKov4WetudwGFcGx2dakJniWIZvU+tiRYTCIyV/H72Rd7q8LP9sLO493ZNEBprFmiDPhkR/KxFL0XgfpfE0MeLQ69Z1aSm6KkotP93hTfzJiqfUjZuXSdqw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 01/18] block: Add PR callouts for read keys and reservation
Date:   Fri, 24 Feb 2023 11:44:45 -0600
Message-Id: <20230224174502.321490-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0076.namprd07.prod.outlook.com
 (2603:10b6:4:ad::41) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 2294f043-102e-47ac-191d-08db168eddb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V41gLsgffiW3kT/I+UWnWbzAm/9jclG9GpS/M1nPqYi5QcuSwkphZvgdtXHj+ZMl6jowgced5i4WoFapEBBTR6mKSiLShSCVoa1/gyO9kl+oD37nyg6J8ikDWcFHMDRLsJoO75Xt6k3kv8qauhq7Rr7fp07fHQ9t+23qHdTcqX4bkzN84u7gCuzMUVuGkxtoItuXXuPveYZ0s4NCZfTC8HMfX2MmOhNL1iKOgxO0OdoZnhCjFDJoiBhNk7YjOZjP/1nKs7KNDJCi6r8JMh2NRSGOtCMAingrKrq/yKFndSyc6BrjlDoG9K3m3nWFS9PjjXFWwDI2JflQ0d63RXUhr5+yzu48+4S/k5Ak6snNo3cYJ126+qsJtyIejqSRYOK+XIOfx1WwKuLFE6zBsFtvxGJ/P6aGvQ7nUnsefDTBSFasA8EmIGsGiwkB4rfQwCy0hTXeP9upaBkHZgjQJb6Px+qm2ByxZhqtSu5TxDKz6kiwvKX4YCxBGx4KvQMGEr8ctMnhpyrr1TXy493T6XQSpADtihHNIw3NGfZDfRvJsof5/IHQRMkv2654DfdCaMSN2eARx4CRAaYnC2+bEe4gK4Uy4OHH7TvdG/fEPuQqYhvJMRdPajzoK6ojrQaCp47dpWWvTd4b/k+nPjp++uJE7e/vq+7eNpuVKLJz8WNWvB1WR7/Eql18FeapBiRcs9K4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TpOCdgjaPwrMIa6yRzX1b72+qb+zWj3ZXrdTRMI4U+vocUGRtszCOb2cp0Sh?=
 =?us-ascii?Q?fOgsfgIT361eVdN67Wm+fhsd58D0jyg3fDN4OMJeD5aIeaoSrrbi7mELwVsI?=
 =?us-ascii?Q?4YAYp9JFCGfGmjSOQZeAYCDQaWqNRt/Abpbewg0A/87TdgQzo4ROjiWAz3Sx?=
 =?us-ascii?Q?58EJAseRE5BgBDKq6/Dqz91763fdVpTlZBO+6VJL+6QTCZXQoMnmqSKETbfd?=
 =?us-ascii?Q?7FGVwcZgnuAhWk58Ryuvtfub/Of10SBXXZn/WWbp3ExwCrKLSYZpAgfaiGmr?=
 =?us-ascii?Q?vDKUOO9SBvi6X294A0JPcc9K+/PvFh1J+baQUkDuEypRJm08FeEU87wjk+ln?=
 =?us-ascii?Q?gZBKprMNBudOr61biNrtM2oK8z5iErkaMdYT7iKDHVgHixHJxUTgyL9Kr4hB?=
 =?us-ascii?Q?HitlrCrP0q8gHgRZsBi9nR3oUHEd7Xb9nl3T/CIYOAEApmeGPFTHhPMemJ18?=
 =?us-ascii?Q?pinzoipvcl3ms3MmeDw3ktFEOqyxp58+hio16SO6tHEAKVO4boLmkeIyzj5k?=
 =?us-ascii?Q?ySk6IDJWZ30zKlAsAT84BQ7digOkOzqW19OIgAOsSyVRPEPn5lX39vAUVxNy?=
 =?us-ascii?Q?CO1y3m4SNamISoMqX3muJsE4LIQzFRSWjQg1uWQg+B4eyKtkskqS9TK4Hmus?=
 =?us-ascii?Q?dXbYi6B2uFGx/ih+2Z6LlwV9KPAOVBLzBKYQtBR3rcT2W9PKN+1jLUPSLEA7?=
 =?us-ascii?Q?tQdBwVIYev25HRYk6HERkQsru+djFIoMbUfza2xmAc6hmDh5HO9nRUql/r+u?=
 =?us-ascii?Q?ZnzWK4MBuw8RJUIbxCMUmpvf8J9YGM+v/XxHLoczlsbONh5aGPe32b+bgD+2?=
 =?us-ascii?Q?SpRAEt3p206JpuRIjkR8V9uJbMVcQD1epeHp5rYOnCWxFYWswGGRqcz8naKU?=
 =?us-ascii?Q?rP9aJLGbHHYcqdx9aDVwlQmH/oOiq0RgFWvyZyH6mkKWKmEpG3nl/gJt1jUP?=
 =?us-ascii?Q?QqDcd/oVrfkH7y1NootDIrLlAM3h6HhmCJKdQ+6lSK04oY5FPBM67pJ2io+t?=
 =?us-ascii?Q?jo5H/oHVWkNmP8tW6qE62gJ4u/Qq86OlqQcRGEF+EucO1RLT2k5EIMXcJ1cu?=
 =?us-ascii?Q?fX7hj28tYvIm2AqAO0R8woNiYm5kyS6gkO1SMm+QPrDL8XKSljK8XIzXDFip?=
 =?us-ascii?Q?9ppBqFGWjmY/3S1gZcDz2P5Ap1InOM2lA3sG9R1rbb0bqB/ODOJp0DI0+5qK?=
 =?us-ascii?Q?RoZFPMlhhFlM8i62OtEVhYdg3lA6K0MA/+1S6V1qnHNpXvsgJkCYNl74/53C?=
 =?us-ascii?Q?I3PwUN1pAg7aJbsrakx6Ac+hVC9fbPNpyb3sspBrAuI8wwqSg3DQ638glfrF?=
 =?us-ascii?Q?OgOnz3WG6U2uJpJaqjcc1MC4I+CfTVljHjZoW8qyZKyBTh8ccadouA2B3J7o?=
 =?us-ascii?Q?xZvPlzQwXMlJ4hkGGV5wl9KK4D/JU5x3zHxZaXvEpAB91xWddh20YiBoxbzZ?=
 =?us-ascii?Q?JrVXaJLinQKqYWUqDbkNVG045TN1pCjEaww4JYGWc1U+jILgIxpO7hHVH6xm?=
 =?us-ascii?Q?sitURpROJOhQ1RRyhgLL2Bwk4VA+Y1dgxEGI70H+EsFTIelYo+yzaZHOi8Y9?=
 =?us-ascii?Q?v2zg5C3vZvUrdoRgBMa3Z/SpnAdBuk0/ncLkQpal4JX8ReuwyMn5OKXGma0d?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?MRJVFA1lVDwJwLetoXvhE8s7Qgt9JqoXo3wTT7Io/EIcQBtsCkLSIWoA9rKS?=
 =?us-ascii?Q?WKoFu4fYyLV3eGAB6cBK5wlWfImQ/RKzsEqCR14RdC2t71QUis4eQEyFn2qI?=
 =?us-ascii?Q?z9EYo6dFji49VP7/eEl2FCJic7BnRGjxWscY7JDGxhW3tTer4jU5ikTUWTwV?=
 =?us-ascii?Q?hQMP5X/60QurUAx7dyP7rL1HMhvHlK2/GLdcs52njut/EqA7KrwpCAEH9K1c?=
 =?us-ascii?Q?Vfm08mk3HH3Wx6M6qp/VUW0HJnZ2Qj4M7QW1rqkgV/P1Jzo9QPfXpUPfyGUu?=
 =?us-ascii?Q?6mPW3jp50TFjBgjjlVWoOs1SEVkdJK3cN0cyljaLNEh2bE9JJa9eVquuUT2y?=
 =?us-ascii?Q?2oABe9wE77hinRrpLi9xWbCFh9ep9O4t8d2MTpiZ6I1bpwAm2HaYtPFJqzky?=
 =?us-ascii?Q?sE9O4Q129FEX9fd2lulwayFpnX4vcIkuU9J+N5UhTak/i5h8mlSEYVeGmOZf?=
 =?us-ascii?Q?fi1BQ1KAVk/vVJ1UlCv4/PHZL9Qh+2OUTVhe4e1kLN8deXDyaGL8fTbXCIDL?=
 =?us-ascii?Q?6mNXTYzbpczmN+ZyK+RhvwzSP/11WT23qS6y6gVka5aPcQ+PZNvphPEtyTnn?=
 =?us-ascii?Q?LTAOLoOQA1dWZ1ml325I13Hb8sysFlSYQr2n24aTgznJSdJP+9/YZjwFfCdB?=
 =?us-ascii?Q?gcMmNAufgPc+YmN5dVuowUzSw4N3DKeBvjFTVdLaqph5OhcxOxf5mIGLS5Cx?=
 =?us-ascii?Q?lgYTGUm/4JVThAdpl7RWp3SWpV5rwPEsG3JRUowNm+NLp/pQsL1kOphO7Ti7?=
 =?us-ascii?Q?aEEreJ481mFis93FEFVHaMWlNvNAbWUZGSXmNW55zmlmzktfATI81UAJNDYB?=
 =?us-ascii?Q?WOM6F5CYB/kohIJQOTmCtJZL5UrP2E1DPk7F9rWYt6CKYkB4ZASWvFFKQ0jB?=
 =?us-ascii?Q?Oen7dPO6aoEzdvHboKg1UIVQQHwAXR6jAYdgtDFp5mhzXU8mEPquQV+C6nS7?=
 =?us-ascii?Q?qlxRJ/LATMz/cnbgAL64jpl8GGP0gIk7Yz9+3FdRpyeW6xs6KSVgC85AissT?=
 =?us-ascii?Q?fe7kNtVs5F5218I5Fx56vDcawQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2294f043-102e-47ac-191d-08db168eddb6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:06.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bv2Nf2yz5lcDFmCSePjKuDA6Qkf3srojf7QWYt2sWLlwzNDsqSALjZC99wwhk7lzhpybLyIikjXS86bUi8IqexImmO+g0sgDhP6cke8wK98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: BPEMvpnrqkgIzwGqAV7UtARAm42GsJRv
X-Proofpoint-GUID: BPEMvpnrqkgIzwGqAV7UtARAm42GsJRv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add callouts for reading keys and reservations. This allows LIO to support
the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
to optimize it's error handling so it can check if it's getting an error
because there's an existing reservation or if we need to retry different
paths.

Note: This only initially adds the struct definitions in the kernel as I'm
not sure if we wanted to export the interface to userspace yet. read_keys
and read_reservation are exactly what dm-multipath and LIO need, but for a
userspace interface we may want something like SCSI's READ_FULL_STATUS and
NVMe's report reservation commands. Those are overkill for dm/LIO and
READ_FULL_STATUS is sometimes broken for SCSI devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/pr.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/pr.h b/include/linux/pr.h
index 94ceec713afe..3003daec28a5 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,6 +4,18 @@
 
 #include <uapi/linux/pr.h>
 
+struct pr_keys {
+	u32	generation;
+	u32	num_keys;
+	u64	keys[];
+};
+
+struct pr_held_reservation {
+	u64		key;
+	u32		generation;
+	enum pr_type	type;
+};
+
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
@@ -14,6 +26,19 @@ struct pr_ops {
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
 			enum pr_type type, bool abort);
 	int (*pr_clear)(struct block_device *bdev, u64 key);
+	/*
+	 * pr_read_keys - Read the registered keys and return them in the
+	 * pr_keys->keys array. The keys array will have been allocated at the
+	 * end of the pr_keys struct, and pr_keys->num_keys must be set to the
+	 * number of keys the array can hold. If there are more than can fit
+	 * in the array, success will still be returned and pr_keys->num_keys
+	 * will reflect the total number of keys the device contains, so the
+	 * caller can retry with a larger array.
+	 */
+	int (*pr_read_keys)(struct block_device *bdev,
+			struct pr_keys *keys_info);
+	int (*pr_read_reservation)(struct block_device *bdev,
+			struct pr_held_reservation *rsv);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.25.1

