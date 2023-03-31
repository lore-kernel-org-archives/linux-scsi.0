Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB78C7619A
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 02:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjCaCdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 22:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCaCdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 22:33:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A797CDD4;
        Thu, 30 Mar 2023 19:33:32 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V01lJv002321;
        Fri, 31 Mar 2023 02:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=rgaKSG3n1WSGtUVxjot6tXdeS+Mf0Luj0JfgTz/tM1A=;
 b=MSHl7KDKXxBaL1HRLw9AnfCmQreUkWpbliV02ApN+h430+IMxB1Vq9eydHArihpsUS8b
 CPkFysGu4ntPhAWEFWPPPh00aW1qyk4ts2DSBkaJr9vg8FPFi4QOSIx6daMoglqjpHou
 sntNwrXlTdy66wb5jDQ6Rq5PfflnbrCiV35TMtHRK3N5+8+7VyipNwZvxlPwIY3xwJCb
 /UDQl34UuVR/WoN7sLHWWrXBEl7St51SO32flJE3ixB491GwTGGb+rQNNQdD47lT4mXT
 81u4N9rgs8w9A2QhQTL68ArzcPOKdJGwvdG4Ny9mEZXiV4b9WEUdprdQkRvBW4E4PTJx 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmpc953dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 02:33:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32V2Ld1I010910;
        Fri, 31 Mar 2023 02:33:27 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdgytf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 02:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neGxRem0J23b1NgueXdyo5bO1YDDeHXfWHaGaO7M+dgjyBErfMmnShrLNadHE1FhU7fAvy2Lza1f1pklxo5cy7kmkXNpC/kReip6BF0cyDsvTaLbZ38nzC4Cm0kSn0I6GZXGPNNq+AflOepb3DH3o52BwOXyRVXJLKlsWVOtKGpTi+Lpnu0RcaZU5EBY3z4/0YP0eRB+lQvdx13R0WASG8g+0eef8osn//NzXnYtNE/bVKtW8hIjVS5ccFWzJZrpETuaGwNjpdHZcQAbfcFXzRAbSA2HPSe2+kKDITOkRRyUgYmEk53XhCR0JbmPcOjvhbMOsgo0u7AkW1DGhWNJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgaKSG3n1WSGtUVxjot6tXdeS+Mf0Luj0JfgTz/tM1A=;
 b=FfG8hqhDJFaMKsUOUO8V4mPcaCOjnDszNVfzIN3uW81C/0AqAjXWHzFsLX8s20Cy6ne0vKlnqSNSc+Sg/by/KyRUDeAB/wX4MIgD1Qf+F7J+SGhvsAjo9ycQ4el85qU55D56smp22snLVnddpLt3f0R0g0eDyg4pX7M+CKHGJJtr4fqZLOP6zVk4hkohvIclSIaWroN+tpIOJ3eY2SyYbFgviABiOigMhH9Ubbg6iRXJVJuTuyAhwP9hi46wmTSKIhZ4YodFIUiX6DVnhXVISSrZehKNdLqxy83V0aNbsKyvKA1g1oCBKF3ASecu1Lqd9/wUSLnRLnugVKoxffi3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgaKSG3n1WSGtUVxjot6tXdeS+Mf0Luj0JfgTz/tM1A=;
 b=KfEGrpMVaRfCB+ZKfqnN9yei96Kz0Pw21ShXdX/6P+2yz9EFN08AcB9DFx/ysS2tp2WFBUnJ2Naej0k27oyNc754zWnkPsvU7HWYAcvi3tNOYbbH6GGBEqcUhZtwFOvIJKjjpYpIL13Bli3lrmm0pf9wHU8HfMW413VUfsd6nQg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4200.namprd10.prod.outlook.com (2603:10b6:610:a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 02:33:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%7]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 02:33:25 +0000
To:     Stephen Samuel <darkonc@gmail.com>
Cc:     Stephen Samuel <samuel@bcgreen.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: UAS error optimal I/O size is obscene
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilehejy6.fsf@ca-mkp.ca.oracle.com>
References: <CALp1NBjzaCkqcHnW9rJ-o5iE2weU-T49vxzLjWirQ1T7c6CDGA@mail.gmail.com>
        <c5890408-3723-0ead-6d9e-7ab7614d8392@suse.com>
        <CALp1NBinKrC=ShrubZJj4ETZ3bEauT5Y3hQqM22UnR7G3QWDzg@mail.gmail.com>
        <8f3c9920-abcc-c419-d798-f6b84a96735f@gmail.com>
Date:   Thu, 30 Mar 2023 22:33:22 -0400
In-Reply-To: <8f3c9920-abcc-c419-d798-f6b84a96735f@gmail.com> (Stephen
        Samuel's message of "Thu, 30 Mar 2023 18:43:51 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: b500c85c-9715-48df-625d-08db31904dad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2iZZflxXWcrabHxI51UsLyePyP0Y9g3eBOjNjIu46OS69x6GJ4b+/RD3ncPKdm9hPonuNldUPMepo0xDMu3KsoaWhn6mUiXHKrjw674E2VHCziF+1R2AaTc+ofJAd0YIor5XjYqIdENxH0oGHB1WBfFa09gWwBtMTwHZdND52Lsd+XDEZ7PMgTRvBhC0Hp4si7c83kJTpPoBgOlOTzpm1DqgmhNwY7ERkiWoqs20CX6ZywrMgEvzfa1F+Ai7CdPVXxMBNiDhJmJ+Sg2YKAdXx6IBlqGN/9814JEIJG4jvRmam2UW1tjgs8VolA5t/S32AqXySer/DdqMrQg3LDywq5iOt+yzsyS/L5WWENk7hz72L/GH4CrgK15Ek7ivGNMxLO2iRpOn96k1IT/lMmo9Q9BdkC5NvUzHxuni+vjSe7L1MiOI9+X+aPuUlYNc/i4LLQkQGLPZDN1KpPEGgx1OXbbXAJMoKCBg2UZV/kGmplgWfoMsxEnmvcvbBbW5MvrjuOiczTbWNf5NWEozmMbDYE/sdSsQH4W2AQCwhJ2s2lGzZLvOYr4G0Zfv9jxTXZL1bRQQrxbieUnAbnrMUa46JeK7teVdHfI6Jhntq7AEWrcNHzOi7mQFRjqdOw90eGPo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199021)(186003)(41300700001)(66556008)(8676002)(66946007)(4326008)(6916009)(316002)(66476007)(36916002)(2906002)(6666004)(38100700002)(86362001)(6486002)(5660300002)(8936002)(478600001)(4744005)(26005)(6512007)(6506007)(194693001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AoI+9bYJ2nK39S9r2FIq0Ts9+Uz6ctYW0TRZxFXCCh8VnN0m9mPs2S56pA2x?=
 =?us-ascii?Q?ls4FWTRNnHdO3eh3vB1AboiCjHS1qMRPfPkgMcq3D8YDdtSA3/KVzlRyUagk?=
 =?us-ascii?Q?PhyJqI21/Le/iUKbb/WAQtpWUzV+R47OB5w46ClTw5+KqMSOwxlAOPpdAQ3J?=
 =?us-ascii?Q?3dwcXkXvkrnDBHZijze2S6AfIYKbdDrrxykbdTcX+hdFusFDpBBClvFJLtqa?=
 =?us-ascii?Q?cHAtSqobVvNX8eDrOUssEBPMgieNcajdLIApCpEWnlv74gREG3Nmgi5OmidB?=
 =?us-ascii?Q?NaP4+wBmUIcKbF05VHgmEWek5/BZC/5ij3EpXxGySTk9QgTa47+b1V9PFgHR?=
 =?us-ascii?Q?xNURKkQS4GVRFpAUtLNOE/mQPYnicwl+u/sqzIeiUMAM4WFpBC9BRjQ69BYr?=
 =?us-ascii?Q?tfuBvo6V4y9t+JLwARPXLVnDX5CrWq5eDe7/OLUYluadHZpiXopwWJn9P2wi?=
 =?us-ascii?Q?ACFyQJ/oSCjkEzLB/47FZo3rEi1pgXIKnq20o07yPKhGk6e8W2ANsETGMJ/t?=
 =?us-ascii?Q?Skkah+lu+h2F8kTGxCXWU6bjxfyA5/DDHZjbmYCdpO229IyP26qvWqjzGLGK?=
 =?us-ascii?Q?bnYNlK8u5ABzyFkmhfxdZWX9D3EpgvHfZfeysjKzUM8S9g1/PAO4ntDcDyMS?=
 =?us-ascii?Q?JudIO14J4idLLM/M9pc1YIdc4Xbbfj69LVPXUOgeu+fAUVQfy0SQMhUjFPYj?=
 =?us-ascii?Q?X8IZcQDVkc2wrv/cRmQqdbixlzsDxSBdFr7C8v4iLLZ2lAI/KRQdmIwQoldI?=
 =?us-ascii?Q?+9afFqClPDNeqCzwGOYtCxFejwWI8JDqiBssd/rjFvPthk4xnPCPdb0oz0w3?=
 =?us-ascii?Q?Cesmod4THwzW9jxRo5oNcq9UOTM1eeUJoxrulKJd8nmSvfNOzqTX69m4jH93?=
 =?us-ascii?Q?VKnAS2OUjs+UH5QnasxTiAp3UfCN4gmvzkuLVB8hJD8f8yoXNy4TwEV8xwEQ?=
 =?us-ascii?Q?qCcfKEwzTShZA/Mt02yXOjfakyQIMaRiHzDhhG67Sx2xv/rFP0dIB42l1ZRr?=
 =?us-ascii?Q?27hH0l6wgm3pq+bN9sK3jDJr3JcVlzZoM7SdVUf8qe6NvHdfMvEPaYlrMoTb?=
 =?us-ascii?Q?71KwNUFNAqXCF2ZrQ5VFO8ovn9JPaI3ugJ2FpnL7ny33Bi8cFVZ0ciJ486nm?=
 =?us-ascii?Q?oH/Xfwzv5eJF3+2fbhW3uOimfrBaJqz9ROoNjdGcVhqebcz3/dBfnkEwdV3k?=
 =?us-ascii?Q?7fPnCJUG+4nMNSk0W9PxDEB9fFOKzCJnbNM8Elejf5S7Ml3SJmNIBF7ZsBjn?=
 =?us-ascii?Q?vUrONnwuh3yA99byaxxXTVQJq8KbgHrD1/hP7cdmOQXz7MDlOlJ8Jiii4FNx?=
 =?us-ascii?Q?y6mko2YFYryAJnE3Z8OIp397Ls37pdCXf5RGGBISvPXW6uoRnW9QpOZwPNAm?=
 =?us-ascii?Q?XK+CdQwzBLbOipR/RYz+fc65KWlUCZb+8FuL/HIUVrGqykt//OtD0J5gmL4+?=
 =?us-ascii?Q?U+eOezjIhkPmSsO4ITxi4bDb2nCrq+yvPsRzK6nBb8ykZHBzBa0vlKORGHdc?=
 =?us-ascii?Q?lCozLA+rtS9kmgXdo27YIgmPPbAKd705fr3p6q7Tc0fueGC+0nCugxTheldi?=
 =?us-ascii?Q?W2D2K/TG+VOiIiVI2Hi8xrj6x1SZwE3lDQe2T5BcoWkV2bqWVrnrPN+XU2jS?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: s3W9JGDagmNPQ8M1lvyiwhYQLAt0VGctLvEzELBqFJtGyO/1a5xCtby0/DqiWN1REfMzRH1XoCHdWlaDOr02pE2R3phd6nv8TjRP9LrmImcgIjHcPaGSIID/hA0LZ2Rx1s6pdihMBrdIab6F/5O7vzDnFQLNbWD0JwOkZ3E5iVEOjIO6UWFD6oiv6IoG2HDAs2A27hZyihM4bSenZR+m2EXzzyEXyGUR76I/aDk3xRP8GCQOM/sNh27Xr0wJSlTPEKZEK3bIbt1fto8Hi/q+gLU2t2qko21WEfyfFxLvDRQ+D7E9BeE3nwVQgqKSqXslXaoIQkHt93gUR5pEsxcDeX1fRzkz5FReXRwdZytOJCt/o2xf25LcfpqPZFFQ9x8RBRLxBNItZTFpVWdUr+SLlQdhJhv4xUx8XtLf3itBw1TvwwcDhSv6zp5+17r0hTKzV8hoea/EYmRypE8VRhiDauJtPbO5eYTEdiy36w7uvFMyzYKPV9jpgcSZYb3m2hABJtFxaXtIGeO1IBwkPJVa1g840s4ol1hPVw7mDZkIrKxxXiF27bNwH8AxF9tsrREG7jNXRJluriB/F0JthAnzQm1i+MrunJdRTXSmO+xb4+eyPlB9fIx//s4kYqBZZtdXPwo2wS9qvocnHsHhj69MH4J1t5BSugPripaDJYVUs/ABvaE1Cu+r43rUNMTSLTxQnZHpEr/F2Y+tGTOjY9VrdJV14k8y7nNoesafwCICg8T9kknoArOgrwgX4CvAiyuDvf38v3uW0C557ytMqu53Mr7P7oJKVn/pk/ggDxyRDabr8ebN+2sAG32/NpmIBO9Z
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b500c85c-9715-48df-625d-08db31904dad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 02:33:25.6588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcICAvuyLCbszmW0+tcFdvmkChkKm8yDpY4njFIdb0bkQDHVnV7zLhqrPq4sbNRl0ts5nu8nKMgFJCiW0c9+qQreswROPr1RlV/vAzZootA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4200
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_14,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=726 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310017
X-Proofpoint-GUID: 8s2sYoaJ7XKQVVaMmaEo4OWKyRFPJic5
X-Proofpoint-ORIG-GUID: 8s2sYoaJ7XKQVVaMmaEo4OWKyRFPJic5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stephen,

>>     > Sector size (logical/physical): 512 bytes / 512 bytes
>>     > I/O size (minimum/optimal): 4096 bytes / *33553920* bytes

> [    0.000000] Linux version 5.4.0-144-generic (buildd@lcy02-amd64-089) (gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)) #161-Ubuntu SMP Fri Feb 3 14:49:04 UTC 2023 (Ubuntu 5.4.0-144.161-generic 5.4.229)

This issue was (hopefully) addressed by 631669a256f9 ("scsi: sd: Optimal
I/O size should be a multiple of reported granularity") which was merged
in 5.19.

-- 
Martin K. Petersen	Oracle Linux Engineering
