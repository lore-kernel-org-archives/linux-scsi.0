Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84587C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DFAD6128E
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhKIEN2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 23:13:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61400 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhKIENO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 23:13:14 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A91qIfI010230;
        Tue, 9 Nov 2021 04:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+rY946Lhs/x0mHt++NRFmH7bHzvK9y6kqUC+lntotM4=;
 b=eJQ49Ywf7zhdOFnYW86tsl4U7wNKu7wlRVI9ErTLzLk3Uid1azKwM+VaKZQPeokOfCLj
 p/f8C+dzEWLMvspTHGdIPBcHr8NisJFuxFbmozT5bWS5q7qt3GLc5r4zOw0eLbBwwDRa
 9KmaLwVvMWhRtJ2D9yEthybJyUHDAKJUz0T8x084OtBe3e7n4t7605L32sGZP761IKQL
 WFfDAwzh7sipIutBiMfr47/LuRovRhfXFXj0wszTftEeb5dYLKtJ+K6pbHfSNLuMr0Wl
 luc1hDu3+e1d5jE9ZAar9yEWD0OqsNVL+r0Hz9BBF8iVzzQTBunfbrBjiNOG683ej8Nd HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6usng9rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:10:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A945MSJ171642;
        Tue, 9 Nov 2021 04:09:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3c5etv1x77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:09:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDqIFn/m2Us7iJSX2x7rfvKxng86w0IjOdgwt/jJU/lr1LBcFuOknrWwLiCDg+JqngPVfZkK0rmTXjeaIHGcFtZAwmNCLkZgHm0Z1peCcNTYuO6YZzFtzXDh36+Q+Ysrk3WfEEPJmuW/RRaJCwSjKuODBE08rBVuf+GC4fd7Fp/obCvTEN61c88gQT9gb9JqEl0M0iOpTbh1oCmjEx9ns3jKdYxoRwGC+NiVyIGYjtwHpObxF3/HfStj6yj/8GkK3aO8ac9SEljUH1Kj+hoJEc8Doh4m29elgxyX263yx+RpsYQwd6uIvlAjphNhABEGkI1bmcWbRg/lq2DZV+hO+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+rY946Lhs/x0mHt++NRFmH7bHzvK9y6kqUC+lntotM4=;
 b=dvpuF8oYVfdpLAtYUd6LJFjNk8dbEjvb2Q6opvvHOgxJTSEKZk/Wwbh0RZLPa5YigL+cFNKUHHpd1a1NHC0rDhb5nR7bW9qd3dyVNmWuAa0cOko1MouXWSbGrGRkgPi4PTZYFwQWrId/BbUgtDkKNRRKt0BI4bO6Z015l9iyvQBwas0OXyWKxeK7D/Ej496Wmpp4eyLJ9hXPlC45nYmVjfdbeQjqip37yl5MHrrxA+rUXCX4woId5twvLOW85TtbF8FfHW5GCDY++sFVGC0ybENfS5n+ZVmeXsx8euNFFUD553+/wRMoWgvfwKwxBnVnDvp2Zz/8wJ+qwq2blRCp4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rY946Lhs/x0mHt++NRFmH7bHzvK9y6kqUC+lntotM4=;
 b=Yo9u+a8yW3E7bfXOgqCZ+EsxsPutrsfMJHwSp8mmus0Q6vSru0ibcmiID/MMQfxE9RK6ORc2nG1AZY3n0yqc93o05/sRklN0h4ZR32pQoFmJQ48cHk8Yb+o/IAq30dCOQ+xng8AScnWWKMBY4jHGzVY/DRgI7JWmJGuwgW05u7w=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Tue, 9 Nov
 2021 04:09:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 04:09:57 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: Re: [PATCH V2 0/2] scsi: fix hang when device state is set via sysfs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k8mkm0l.fsf@ca-mkp.ca.oracle.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
Date:   Mon, 08 Nov 2021 23:09:55 -0500
In-Reply-To: <20211105221048.6541-1-michael.christie@oracle.com> (Mike
        Christie's message of "Fri, 5 Nov 2021 17:10:46 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:208:256::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.57) by BL1PR13CA0024.namprd13.prod.outlook.com (2603:10b6:208:256::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.7 via Frontend Transport; Tue, 9 Nov 2021 04:09:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8816f90f-9c56-4912-7675-08d9a336caed
X-MS-TrafficTypeDiagnostic: PH0PR10MB4599:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4599398BE0EFEC3FB6BC3D478E929@PH0PR10MB4599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xa60MHp9xQCvkvCs5RXzD+TF3qy3FCggtf2JQ8BCvxJdFsOfHjEYLMo0ljSYqvvnX2zgYDl050tYItqPeXfD7v7uzOaKvVQ2nP2dvmbGGcAPCt//lT8JBJFhId8L5LjTgBfFbp0GTfjL3qNa0voW0Fq3M+1zjzH9qcAEG1BqTdpkAYw7lQ4JDATg1Wa4wpqIOml62+VfenMdXIewcN9f9MaxHn/jGVTHgOa5Jz8vvivErlo68+0sFBhwdSsaU9SrnpXhPa0PHgP3meD/FTlsexu7wKrL+luRpDmGGl0myDFHfoTmdWdbL8CqaQykJCpnLQgA5k0To6rg3/oMKKjSiOqIF/qsCmzlXHNVJYzRMTfa0fj+LXJR2M16BVY3qcWwgwR68VRSm/Vp8Z71OBy6lkcSpLuSrifPKp60shXHsmCp/0p/KI77bmkBqdgs5Dy554ccs/TzhAaoxjnGxUz0Np9hwvWJ8FzRbLAcHYrcFmEPvD+B5GjAXtPBFyueIzErvkdD8/r3ZPO16hKnl+b2sHelOnUNui3hvoaEkqbC5ihcqsKa3WFpXJI1oWeKaajS/8n+kTmZgjVT9eN7A5DySCw28DgGq1UN360K/no/pdFXG+guJfXeX23LyHeAlUHQArEnLvACrW4cG/WbC7Nb23D/WzP65Y+CAKUn+7mAbJ9+nVEnDbpWP/647tApZZhy9LHSdRHgP7JIyx2JGV6AZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(558084003)(6636002)(26005)(316002)(66556008)(66476007)(66946007)(508600001)(5660300002)(8936002)(2906002)(6862004)(52116002)(7696005)(36916002)(8676002)(55016002)(186003)(86362001)(38100700002)(83380400001)(38350700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S2ysyuZ2/Wa95iHDxBomTwfZdb7juYwaOmSBWSWsVaKPU5fnnidWTVSloZSK?=
 =?us-ascii?Q?Z7mluXKQf8zzKlPxq6Ggq9KpYgr24d1BIBlf/vEZW/OsC1vTsraqRJF0/OkO?=
 =?us-ascii?Q?41QyyuVomrJdjl7EJXVNMuclh/U0tMQmW5iN9hvUH6EunoGFlgJ7xs92RdqB?=
 =?us-ascii?Q?AS5QqbKT2b+DTlu242YBfccoqY+W3e/eSikw6K1c0GWsqaygcGLclVylTLq5?=
 =?us-ascii?Q?Chub+p/iYisMMzBSpHlixPrWhzw102W9m7dfjSgQUiKgmVFhCurDSzvG99Rv?=
 =?us-ascii?Q?GeocBmfm+90MNnB1iwLc+WZKt6CtDABTr+sX+U67li1F1ZX2tahk68c4cWEp?=
 =?us-ascii?Q?ZGPTBhxNKBQPqOfwBk0HFnrSeeP+e0jM4jt9xcZ9wlKgo2H16uBCJyu56viu?=
 =?us-ascii?Q?/Py5pSwlreqrobnG+1FF/RHio9gKU/qh7G52WCxhy4fRoJd+SDpygy9RJJdK?=
 =?us-ascii?Q?pHn3uKKUC0n3NiObzVSlia1Cwhufs3Qc9mx0UzhpXYsCAVxmApCf/YfXQeO+?=
 =?us-ascii?Q?OQnykh2YYqTbdXso7yZ+rBLmrqSqqNb80OyLI5eIAwfnrqaGWjSv/VE7zeFQ?=
 =?us-ascii?Q?tyPqZwJx7zvywJrhk9JQV0wdSMvvGDGnZpBFYB8uRFknpEcWJlv6k3CHHMHZ?=
 =?us-ascii?Q?1XzVv9+Oh7dnDQR3aqmLjMVvzvVXQtxU+iY9dQUwyT7qmCyukAQqIi753gsF?=
 =?us-ascii?Q?uHa0IkFYFR0fyLiOwSZiRfTL8ACKUrt9wkc9zK0fPAEZ/Ax+vWbzj7oHiJWZ?=
 =?us-ascii?Q?UiWAkR+sFTh4t246tB1Mtwuse94/8bCj7ZZttygFjUINQhIUPOBxl/aPwPo+?=
 =?us-ascii?Q?PWxRuSZHW0mJFrR/IW9/yfjV+gd8Nwr/Y1C6cWWDUGDv2HaMZDsjE+A7ydCB?=
 =?us-ascii?Q?UFegYeR3kbxjesCErVlvKkN/6NGQOJg+Kowcc4UhdhEZiJpdNbL4U3++qP7O?=
 =?us-ascii?Q?7mntwQJyUVljr7U1//wKpA130v3+4/LtY4g9dPLXdt6+yRqNVyPJe14am3Gp?=
 =?us-ascii?Q?ZDi4BJ1//rmdVdMf5DA2qPaTCsVoYSHp3tFLEA4ZyrK/zc4HIMK2+zAlFfVV?=
 =?us-ascii?Q?IXQv4k4e6KfBZpdHIuAWCjVDRU1oVBeMhugeuasAtO9AK2G0Zpaq5zOMwsRX?=
 =?us-ascii?Q?hoyokAv5vqK0tfS8TrIIaMUEEadYiGc/qj78sLxdeOnbk+ybWwH8GSl9iIm9?=
 =?us-ascii?Q?T0gUcnSMzOlggcMIXYw8MwxyKXp+/xypZWH/OlAzGz9fh8Mf5LyS+uVPCMdN?=
 =?us-ascii?Q?tcx2Yb1PhGwfcFDkrh/E0qxj2r2qXuZVUHF6CQMZGs7V/e4qpRQ3ZjvzvyOh?=
 =?us-ascii?Q?t6lMiWfUfTgrwYFtZVfdnKtxJVzrJ5k72JGZCoCiiaZWQt+VrGYZG7Dzj8UP?=
 =?us-ascii?Q?eNkHPvc+8979h6EvxevNb2GhlyymYxfm01K+QmyA5xcuJB9A3sy7S8h/9BZR?=
 =?us-ascii?Q?+yOdQLm5DHGmaQaA1JLSmUNVCNq7btble6rtqZULa6yJHZOGRtOjvHOxJLFf?=
 =?us-ascii?Q?EXu29U7LKl/Xk9Qt8neIdDpcJRa+XCqMr3F0rmbCD2dElLiM6rTqwdgaYKGf?=
 =?us-ascii?Q?5LIlQV8eOwgGxA0X6RtiwH+IJwaa4ZRTm4AEJ9nL1P7z6GH8YF42z089NnQe?=
 =?us-ascii?Q?OSZml5HR1XY5qhukOSHzil1tL9e+Jm1Srk2XUuFqLTGCXUAtNVS0xuHxHnrf?=
 =?us-ascii?Q?bShEBA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8816f90f-9c56-4912-7675-08d9a336caed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 04:09:57.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YxFtISFDLqFemEu9ufIYeMsG0MEYXNujWnypqzyqy8T2E9wTfbVCwVUktpfovHYfCc0MiGWYp/bvdiAImW2RnGHCRhYNmQAyZkY1NjWSZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=980 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090020
X-Proofpoint-ORIG-GUID: HixnhyZ_9IuMAVEeyBQClTIeD2W6svfe
X-Proofpoint-GUID: HixnhyZ_9IuMAVEeyBQClTIeD2W6svfe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches fix an issue where during iscsi recovery we deadlock
> due to iscsid calling into sysfs to set the device state to running, but
> the scsi error handler is also just finishing up.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
