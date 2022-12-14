Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DACDC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiLNXuT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLNXuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:50:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559484664F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:50:15 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwYEO009136;
        Wed, 14 Dec 2022 23:50:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=rwch4g6gTK+7JAJjSbw3xhFfFtj8Si8niaO3xjiLUOQ=;
 b=R1IxQcDDlZpohQTGOv/Ax+Y8z1eWLvCqgaxNpmos2HYIwSDuG9dTLvCVVrO6U7EC5JNd
 jIGBxY07x9LdHUNAodiORV9XQT+WZqKFKw0v6Qy3fV55ga2NWsfcCeXIGMK1ocFXgEt3
 XOTcbFmIAdnRq+9kb3fzRUvhIXnmtjXQG/CB5ZCrrX5wfVbR0mdl7jtjdak2X9M/pWie
 sjbh7LkfU9HvSmaAE1zSgyX3MhKH4ZXQ5O/zemozorrOxjJOSB1VLnNZq2m71BwUHoWz
 z/5onIjHiod71i5+A4sVw5jWGedd5IxTz4JGf4C62no/S4O+1qzhKVrsosDWXC74Cozy TA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeubp68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEMGp1K004050;
        Wed, 14 Dec 2022 23:50:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyewunma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOLPmt86hbpcivm51h99K7V5NI8vLogDI6fOWjKkTcCBpZu+4TrpFxv+DZv2SmMNBjIj47yu/yHgGrZ7e6HDu/orbBuyQ36rkVAZ8xgZKqv6PsxOwbppCX6mtLmnVqYCvlWj3Hl9CGm1Grg7Q+B+51LciYO4VIAVvyclkRwaXSVHlaObxt/9LReXmOWokg6XhBV6qWHe9lLJF6B20Rko3B/9zGXKBWFAHUQjbCi2qtj/RxOEeVOO6znMO0+WrmIS1MoDh9ySoNJi3m5yOGFO48IBF22Z83cSuALsrCMBwwReXwveG8BTUSYvVUB+jquviJsEAL1SuQZ0xaw6UJ8KAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwch4g6gTK+7JAJjSbw3xhFfFtj8Si8niaO3xjiLUOQ=;
 b=UisKev5fv0zswKLBOTBKBkusUntz9DsyxZvmzAS0zDMJXiW1gwm5I+kNSKwAgXFXAq60lbvKp+v+NGWMbVEfSIrNlUI3DTsYa+j4WFjD3E1BR1vBgtmTInkaU0NPbzw+3oJ6VmpcGwpXwyEesoHJOXV8+xw+OrkZPNQQqXsn+6QeiKNJ5UrBjequ92dVMoz1G6jxsMsbwakK+ps48tZO73H9f7iF/pTuihLdisa39biY7UKeYZNiNT88B3+k7VDr72LY2D06qFyX/p3gklDCvR8MtgOEoxRn9Aj5pgwkRVOPOn4JWpnVHWBe2FjV0Tp/kdUNlm3MYwM6Ej2Gd+HmnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwch4g6gTK+7JAJjSbw3xhFfFtj8Si8niaO3xjiLUOQ=;
 b=m14aCKARnJplm6lsMejZycDSqr/5GXV271vTf1ADdj7dcVOdyJucPC0QijlQrGQLWXekX9x7tCvwkgFxau0Eo/zH0GtaCs3Q7pULiSbm8zqorVQReNdih4N9isz1a5OSl22fzGs+dpYIWiSrStLZOlDltR6rgsqQPti+kJI5BjA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v3 00/15] scsi: Add struct for args to execution functions
Date:   Wed, 14 Dec 2022 17:49:46 -0600
Message-Id: <20221214235001.57267-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:610:38::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7f0809-2840-4ea0-8443-08dade2debf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eo5wENoW3RFqG+32kR1B+yG7dc9ecOE2DUPEIkz8wZDfHWFzaEqOYjqSX7Xb6WbVaVMVl5C/ahh58xZ4ZQaoUQiLQq6m61EyEbtTISHF/mBDO1fNq7uprszk9VoHT+v1W1jAVOp3jcaxLVklKG7NE9KmqteBh/g9qlbcRg1ED5lltAb7srdTrOveGXCDOjYAnlIBnwm7bcKO0sX5raNgP3IYhQ0TgM0LXWq9SMehgxzUHSQOSI+yUh05t6pYKE6t5Lm7SHRkiV4utmouNZPRY+EFP/7s240j0QkaBkhZiczZr/P/Z5wx1DDufQlOMMwE7mj3F0HO3nucO8IAV/WMLqmNwoV+m0lAJlQFFrp6uXShJ241JkxSguEPtSqYZPV8TRf93vGnktvGb30F2J86OTrUjjv4FMuR7PXt9Fmwg1yNCYVXwfU8aP/f4fzCed5VTMGmiMBmFVilxarrAfhubvh1kQOKai8SWS0ZS7E08KxouFAB8tJhB/loY9LVTXzEdcxWCCi71YgMKiYNKd/1BZ3SYy0985dP7jRLeFVdsd4weq8/l18MrgU1me6ErqyEQy4bTn32NVwMcZFUUGwgAHr5dLOqId4l7VGrs7VhQPvYjdiYvgCfREz5LNXH/plDSzWgiRctWW6DtsxCGhG3aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(4744005)(86362001)(316002)(2616005)(478600001)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KxLNsDdHHwVO1DgvpP7nZAYeHNPmf6qnh/5P26/9vPFRhu+Vr11fqZUqjlm+?=
 =?us-ascii?Q?/Co2ej+CF2d7sVSFluCvJggRUctmYlC/Fq23i53eGhLBrBAMcDpvwVkgLW9Y?=
 =?us-ascii?Q?haN25Tu9HHg73niwWRMT+Nhc2PbVVWY/ShQyyxOuSxe89zRaAh54sjSvg8Ss?=
 =?us-ascii?Q?5JdjGphlNnHPSu/cH3ci1iQNU1QxjezqWHYZwntYfeVW6V2fFmyGou9HtS4j?=
 =?us-ascii?Q?qTijtEFt44Q3Y8ijbXZKjiCS8Q1M176VO6Ocpl7jwkjlPlYEfWA90QhzQzQM?=
 =?us-ascii?Q?JKgCyjafzUJwjSjuHjXKf5NdQ9sOvj9L5RtKu++JvDu1R5UNZvGkrhz8RJ3Z?=
 =?us-ascii?Q?WGRMVtGfHPG5+2gZBDLF2Iu1ToXQoZfhHDnMzXtHDI3kFbLHhUyEuFpxEeTL?=
 =?us-ascii?Q?c94unB3WWlUYHKEAtjenheqM6dCJ23ZrLi4hYDT4hp93+ek0QNFRLdpNbTLG?=
 =?us-ascii?Q?cWEC7kPQRLMAvS5vVDNHHIKqEFJkxAEnA/ieSaDgFXDT0zEwbgHieKzHJZxJ?=
 =?us-ascii?Q?Ky8rEkqzxleK+qmo5HAAUEnI50tHTOQAUsy6D9r7zGOeyfkw8ZroZ84ns2Yd?=
 =?us-ascii?Q?+wuLZGM8Gau81hq3QApJQvm8S5UhvKF72QGm9ko/ek5hiw8xwsfrWRg41+9C?=
 =?us-ascii?Q?DnUzVgtDmTXA1ISdVvLSGHZiBTyNRPoN+tacWU8PJw5fq18sH+qEOXEykfgi?=
 =?us-ascii?Q?A8TJbIH9+rmJJ1r/eKymcFo09WwkYok9izs4CycTthoCsm1rfV1+UDjrb8y3?=
 =?us-ascii?Q?6RBZlOk0y6caJ5uE6Iv8uTw5cpuFIA7H5RbQ9Z6stAq1vHOHge46ewgbt8jZ?=
 =?us-ascii?Q?4Eu5N92MXwQMPLGfiuGFGAz2BTymp/nFr0pinYBGLb2KDAdFDxw2Ty/66M90?=
 =?us-ascii?Q?1sEv1rBZCusSyyEd8YVG4yrsFHNaBh8aPf6KWHO4DbOKMBbIl5wXx81XYTil?=
 =?us-ascii?Q?2HME7WBJddWfZ1NNsfkH0+v1FdbqXrcAcmZT2tq+XPUUx8GsE6u26lxJ9dJc?=
 =?us-ascii?Q?Wyu0RGXd/sUbcYvR5o8ApVoGpFT86LrSz38NXN80QLx43bOxU1gyeJO0X2Rp?=
 =?us-ascii?Q?3hVrIkJoEVR3r8VtSt9g8etCz0E9Hqr/rCTTtK094GjQIG7tfXie0eWtrdpw?=
 =?us-ascii?Q?TNXjwZA/4gN1j5+KYv6vt2vV4tDTy5xgJ/48xv6Obf4XANQ0lWi6C4e7tZsy?=
 =?us-ascii?Q?A1MBXPjPG7YluR7yyk+llno/Dnh+qg4ZEzZ1N1iogac4zH0TzQldDK9FqKTQ?=
 =?us-ascii?Q?iRjx+QSWwkwMzRX42kmpmswQyqpDSFJR/jNEQbCHWAVUB68Dp+nWEkiBgxMo?=
 =?us-ascii?Q?7ieq4J6SFh65V5YwoaE2W45tlPJ0RbCKlpVWSjcql7lHOtKMBW2m3vqak02Z?=
 =?us-ascii?Q?j2lM5teOaMSY8KGCC6aFECeD9sSEAhyZY+QFGopKICj5mwgSDvnWzEj8LuTI?=
 =?us-ascii?Q?6wxp0ZheXfHU0ge5Mu2wIqQxq3VB/XCkM/T0KnZ7wcgAuomQLwohB28mmPz8?=
 =?us-ascii?Q?llO47HelhWZ1Ck1JgfHLPI/fny1WPwBH86GMr8qeqAaztPjvEC9ccmaCZJ+b?=
 =?us-ascii?Q?/VEPuwyrxXu/U+aCJLlMTe3ogkPDrgfg+rKmx32Ur5tKRrboG0rvfMgmZG5B?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7f0809-2840-4ea0-8443-08dade2debf5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:04.1383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4aWR1zKBEsQ6F+XLMtwoVVp6IS0gvWdEdmQqftlg/DceVh44BNQ64r+G1B3968keDJS4eSofj/BOIOXkj46K0iM/Phw+ZWOnTOOmtF9h48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=892 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: JWC3csof_84lRHbV4yHFufjS4tj-5kx1
X-Proofpoint-GUID: JWC3csof_84lRHbV4yHFufjS4tj-5kx1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's scsi staging/next branch.
They add a struct that contains optinal arguments to the scsi_execute*
functions. This will be needed for the patches that allow the scsi
passthrough users to control retries because I'm adding a new optional
argument. I separated the 2 sets to make it easier to review and post.

v3:
- Init scsi_exec_args user's sshdr as "sshdr = sshdr ? : local".
- Use just one sense_len check and remove the scsi_execute_args wrapper.
- Just use one scsi_execute_cmd function and have it check if the args
  is NULL else use a local one.
- Pass exec_args by pointer.

v2:
- Fix RQF_QUIET use.
- Use the more standard way of passing in a struct for passing in
  the scsi_exec_args struct.
- Pass a struct scsi_exec_args instead of pointer and add another
  macro for the case the caller doesn't want to pass in a scsi_exec_args
  struct. Then remove the NULL args check in __scsi_execute.


