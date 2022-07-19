Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E024CCA479
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 02:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbiGSCkz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 22:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiGSCky (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 22:40:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B62730544;
        Mon, 18 Jul 2022 19:40:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKxBEs026736;
        Tue, 19 Jul 2022 02:40:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Wx/bQnHPDRg5RyjcRjqI9byF3EOsTuPseOtpYMaoRJ0=;
 b=GlXWWyIXh0ILxsH0dPCcXloHhyt+TxCDePPhdX1WryS5XIFY/6/vI+8WWmzShWFPTQOe
 N2UtNVj08J71ciLN+8aOeb8ubQlilX117+a0bygNasJ7lDKswB7t9JyYvhVaiH4Dhtfo
 dkN9KWuJKOge9xpN4gnojNcsUNYIWv8Rymd+7sK8xhH/IJW4mhUJZ2Cjjhgl5D+O++hm
 kxXBLU7cng8/R48POUYL4L9juroDe3G1JEcPB3ZttQPTwRfe8HB03Zxzk8PVcyJ2Xh/B
 z6JpM6Mo3RWh9AO5/eSGFvMAa5S88SzB5z107cEkgCgGfYODyiU/AdvddevMXiiM8kKg 7g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a4v53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:40:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J0xLSa007909;
        Tue, 19 Jul 2022 02:40:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1em45s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:40:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2IzsdTEFKudLYeqGae6p2nVLPfUEWA4Znhy+wffbkQQ8EY9BXcjBNiQThZi8vf7e1E0hcjbaQtKAwnR2F6NRLFDGhNrHlVAEWCcGFxkZ8IranNaNB9upCtErMo1exVunIbJEDwD7OLFAmLNvqoisZLlVRNNN84n5Vc1E9dy5tws0DbwNmDNjFAw889rfy4tWjc6nfrZdc8AbQ+5P870lVkhev5XuVfqD4P3HzIWRwB34mLdoa4Awo3wISwDPHH8+XMtaa1azBxgsmFzYZFES7fHqw2iINnLDe4IWCRdjXX2XnLsmysM/iUTZ6N82Hpgi9FeMdAhf5WZusADaSNFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wx/bQnHPDRg5RyjcRjqI9byF3EOsTuPseOtpYMaoRJ0=;
 b=a7FPLa7J4jPJJaZCBpwJdQKOfBX8NCW5iHIsrE9caicWUnOi2UXIY9rfYIcEakulLQFJvXV0+M0Nc27TE8R5vmBkLD8wPJXd/HJBexVbw89N+w3M9RYks4VCLk2XwyRfu7AYlvEe8ESlKo39lugTvZtQtYWEItU4nCfLG6Fr3vGf+Ukxm2DhVOQucgMiu1etV8cywnXYhXb31lPadtkzAn0wX/G/yn111gD+x0kT+4b6XD1xgegCIqWaJ5Mkl0ceKRNa2J2DV+1aRe0zpsCWs5AL+TtC5RSQYM8Zn5TCh9YCb6au04OD6j2+MOBab8ERqB5nbxLHHuNrUPbwunaXZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wx/bQnHPDRg5RyjcRjqI9byF3EOsTuPseOtpYMaoRJ0=;
 b=NqeWXst0/Gcq5i8d3/dGwlaQzZMA2AZLgSjBq+BmxTmcQShE1p/GbIWhVCzSScEAKAwONQHhCIdZC9QuiEjyMecq7ZUe1StwRcEa28DRkrWA7HC/dEvm9eLoed5wRcx5Q+NNDGfsF/D0rIk4W8a8k2gxCssjDDRu9jg6+jMOUKI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5206.namprd10.prod.outlook.com (2603:10b6:408:127::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Tue, 19 Jul
 2022 02:40:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 02:40:48 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: delete a stray tab
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r12hq0yg.fsf@ca-mkp.ca.oracle.com>
References: <YtVCFshEJNC7ELid@kili>
Date:   Mon, 18 Jul 2022 22:40:45 -0400
In-Reply-To: <YtVCFshEJNC7ELid@kili> (Dan Carpenter's message of "Mon, 18 Jul
        2022 14:20:54 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:a03:180::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2100996f-9592-4dd9-1d12-08da693016a5
X-MS-TrafficTypeDiagnostic: BN0PR10MB5206:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14H696jUrw8cSjis2a2Mivd8sp6Oq8uh6YnZ5Cu5/f1c0XOQhD/YPWR3fAtRt4ONpRDtF7B48cbnQIMlnNAQnaX7uVy6b2q+6VLoV6/lwUEVBQUQluhcEY7H1MugW92XUkYdSuiJIsREvU1NjR6XrQ/JlmzzWDkgYt5upE4OBjAEW8HLFGMCE3uIgBnLqHPmgI7Tot4wCPvd68FQaP2uOOiQRIrm551liy2FUhF42uNM0uVKVZeQElvJ+Tx+45r3/A13YLpbPXSunYrgTp6Izff2gcqu5WFLfBCOgXtDdMybYEElPPoOrXxs8+6U1ZUo+ixBEKXOBkyv7aqrksWF1nt1KxjoKyIr1Bc4Mqz53AeYVLFPJWeM6276kDswUaLk897cd66AyTVYA2CFxRvHYpPLbzIcfg06slj1wv8UWsm81k2D/3S4Bk0W3OQ+AhvQ9AS3sVZdcwuyU8mkmAcQDa92l3WaF/pgPhDmJQ9+Xixkl5r12fMa/EaIiutl6fQahNt2Ypxlbk5m/4TwLAdqXQ/VFlZFZLz55UJ6cCK3N2NyN+HeWW8UepfedoftQ8qSYUFXeJxdpp+nZ4xdlGSLhSHohkaoNPQgvcysKkH4B1v2Z6pIkumkgmyUNe2kQptJmHlcNxXZyiHdrGRAxgvlyhlSIYeId5706SMzAQFaz3LMkdm8+QxNJtpv2xLnNbNg/HSd3PmzFwZCgFzq/vTqaIjXQtdNZtb+48bqDElkGOz44tAFU1uo5p4vC1mha7gU2bcIj7OxVWZbLiGhLpx4cY4hH6bFt0knkMfvOizlsNm3STveCdHhAr1epjKokMplNUyIgNi1t/PNfgL/9I5mng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(346002)(396003)(39860400002)(5660300002)(478600001)(8936002)(6862004)(66946007)(66476007)(6486002)(4326008)(8676002)(66556008)(6636002)(316002)(54906003)(86362001)(6506007)(38100700002)(52116002)(2906002)(36916002)(26005)(6512007)(41300700001)(6666004)(558084003)(186003)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TPbD23ZYgjGxWKpq8brH8plLQJULfIJC0stHr8gwxTUIbMfn8I/iZZbk2eP+?=
 =?us-ascii?Q?u6KcenB9F9Yy2SGTcFGMpoGnohZzvu/S95OrNng1mVK6fDfAPog2yByZ0bbz?=
 =?us-ascii?Q?+DYD0g7d6i/TG3aDNwL1ypsM+GRuki3bevIZn7x6ax/uMicJWdXFlReOeXn7?=
 =?us-ascii?Q?S8jNZ1DcHmJdVJ9uud3jAKt3Sykw+fBefawGWWoV2DbjLYh6zAOlbUJ0vZ52?=
 =?us-ascii?Q?UgQA98l0xm3E6J1HlcgYZxSGxDThePN3jxvrCeM87akYAtNVEjg3uuKlwtAc?=
 =?us-ascii?Q?em+q1nXZCvH6HKFtjtsqljDkyViqVO0XWcKACnrZpOQop3FEKa1Fd/iFl0Th?=
 =?us-ascii?Q?+JJoicfmvpOaSUXSZPFQa2tHms3qftI0QyNk+PHvgaqdWyrWPeQADZlGFy33?=
 =?us-ascii?Q?9oPuWc4N7WdVEyYTilysFikEzmho/mZy/j46SBX7OOTHkOdmVhrejXJ4UPky?=
 =?us-ascii?Q?6NdBwEo7hqtJ18QQRiM+FrcF2/JHCEb0OOF/F0GibBaenkPEo7FpoNZ1IQco?=
 =?us-ascii?Q?JM8hTFjvoaDduynsxPYQfmSp7XWFCWkSFdgq2ryIx0FWIkfaaZqt+axE36RH?=
 =?us-ascii?Q?Z8Fwq6Tmv13trjG2xNLW5ULZfN84q/8dRjV9Gx75l4AjS+WwR2eQYjzgFXpS?=
 =?us-ascii?Q?mq0blKoLDAXH/h+BEtVyGCnV/9tpzmHARhylTp1CYaVG+TLIHd4epYhbpcqR?=
 =?us-ascii?Q?0V9aGBoE3yt36ubgRbJzatv0u5PcOUVXknAsl2U3RG8ZzVQVyT3JuBd7G0w7?=
 =?us-ascii?Q?QHOZVm7pDjx2NAUpzT6SuenpZoBJ4gCikmOGyhQ9j6RcBSlm24C6/xejGgLY?=
 =?us-ascii?Q?Rw+GxoCRkCkSVhxUyaxG9aWUw4h+tkhwDTyWYIMqXglmEWt7Crug64ia4+oS?=
 =?us-ascii?Q?NHpC+Xs/3HWruVY1Qu3Kzk6psbhmn/mLzVdgDPwCbKMD+3L6ixY4+Jq9dko2?=
 =?us-ascii?Q?v/OpN4u/IbPIVhpmCOv+TcwBcb0FcIuWvOo+uuNaNixAYsCR/3AbhwySEeA0?=
 =?us-ascii?Q?qps4C8NxpuzkcKadA8BmfH6wsB39/q3BQcRqqAZUmMNIEEmrrGhs6tTWV7Oh?=
 =?us-ascii?Q?8rQHnEXnDjlX2iLd0FD0oj//Ww2FNqR1mD5x3SXknloiCMFtcwyKTE1nuOKS?=
 =?us-ascii?Q?9OhrjPMAef/c1gNfOpeSnIC9m95HXZOR7QgZXicAS6CAS3oKYXTqvnafduxh?=
 =?us-ascii?Q?o0G+bNgUpODSxLMr7m91pvxrTSOFuKzHeh/GaS3IDAIZHAro2gjfL7QT4n83?=
 =?us-ascii?Q?EUQEMh9M2Rkksl047kMwXt3P1Vx0sinGh2gyjsnaikjfcieAtcd2mV/mk4VJ?=
 =?us-ascii?Q?aUxTdOKQYte3IP++ZVc4JM3EPHiA4U2ZXDbV3aXHWNfzfcr34zBq9khMXTLN?=
 =?us-ascii?Q?tjTUvUj4ya7YRZAw9pDut8Me/chBMOdffKe2k1gi25MI1Vm1LWZDHEFGdK/T?=
 =?us-ascii?Q?GklP8fzaua8lAsm0LjJ/8Yun/wMt0xR7M7j9b5v6myoBbm8cObZ0U2FBzGHX?=
 =?us-ascii?Q?ApyzkgLlCFflgu+iQA/oeYc0obp5n561nzKgqjkoTWjW2EKrbTojIXwwGX5g?=
 =?us-ascii?Q?q6romVf7uQqa5sI6a5Zy70lZbrNcjkkEe9FNw0cwPINKP9vNDk2t8IsROHCo?=
 =?us-ascii?Q?lA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2100996f-9592-4dd9-1d12-08da693016a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 02:40:48.7174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrIWOQ1XQqA2Dm+nzlVIpok2suG6GWOcPx7adDNBbN9+VQC0N4/74meLF+fr9OyKqdVta4zsrnI5ssZPlX0Myk3rjj+RO53TK2NxLHD6ev0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=900
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190008
X-Proofpoint-ORIG-GUID: Msyggp3ebG9zYy9fMreo42yfjjln60Yt
X-Proofpoint-GUID: Msyggp3ebG9zYy9fMreo42yfjjln60Yt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This code is intended one more tab than it should be.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
