Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0E3C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 20:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbiGGUzD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbiGGUzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 16:55:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F0E2E9F9;
        Thu,  7 Jul 2022 13:55:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KDGms005689;
        Thu, 7 Jul 2022 20:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=haCe4FiDTwcifFfon+xu05WnX7Nzf11bkqRWQDOG6kI=;
 b=qftJCPnQstpekR8PX7UtcAxw5uysI78A08AOqiNwsWKqwxOL1RuyP8L54iWgLhOKW7H5
 /9IGWcNDTvcP8Yo/oFinAESwIhINPfWeDyXxZ2QcgFLDNdOJB6229jswmi/S/qD4Z/4/
 7EvaDFN+3nRetW/Kzg2tYhxZ7N3k26uaaNLzR6JC8s30W/lY3Jawc0IfoxRyo2hAycbw
 KwGOiQcnCOAEGrpueb3v6/bqF7ytjr9paUjDPwcb1V4NtDzvLDCl8jHHTiN6jTDb8Tzw
 SHjKIGvQ4bDUAXKBOxHcK7n3tYOSCIR3pOj2QQd7NYBs+P0M0cyxkoU9XTn9zYw8KJeB jQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubye3xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:54:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267KVYkc030937;
        Thu, 7 Jul 2022 20:54:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud7b3x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:54:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWqGOqjQomI8lcXb0VLA87O7MNHxUskPRMVN8GWmORo85ANVt0zNqAz+fVRjirAcU5Y0bQF9170NbIMK433A7GyGl2mwtNuRgo5feIjc75fn8c87Qn3cfMVGFgRZAdnQRezdVAY6vw9/D5HYVGwJxKzF5ygeU2G9FhZkCQKdwbghwTj35ux7b30JHtF3u5Zw6n3V35zphQmQXtJyEEOO8db+iPgHLHiulwNKWu9u/xCpP9/ecFwCSW9q9QEka+vd+PO/dkvxqM7xLU3Vl8DwU7wl3pBN3NiTrvCcolnjdXfmxRUXu6P39wY9aK19Vt+OEe0L1DT5G9I7/SC+j8YvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haCe4FiDTwcifFfon+xu05WnX7Nzf11bkqRWQDOG6kI=;
 b=A1eCM/3wx+StNf/NlieLCo0UWnx7hvWat7DS1HcLffcMb4eo63RYGVVeTG/c5YQox5NyciMq1C/XfHmOytcleE+oeEZBEteoUYHyYe8s+ToSxE1C0hCfLH6kjB/V6akZh50G2UDpGxX3BRqD8fWOLJagVxn5JswO6eHOo/chv3ETpj5mFxTLX2XLP87V3ytHZgsuEU5PgBot25yMhaSzqW4ZO7jIq+MeZk9C+cf4GmjnlPVgLtvAXOPCBVyBedaNdmpJjVHtUfnY/XuCvzXlIr/43D/lwrnSMZyvuXjKhb+0CuKnp3tdbK4x88S38r8tW698OomNuhTkSXEQkYP6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haCe4FiDTwcifFfon+xu05WnX7Nzf11bkqRWQDOG6kI=;
 b=h+8rEU36jK739PnWGz4Kt5tVEd8DNw3HAh4GJXVZKR/jDsGhgd04U8sUUtuHE9+Q+hSDs5VI3QWNTCwfXj0YK4K/y3hwi/uOTg8TeWznvwTOzGt7rcNkMlMxZDcg1UPEPM1FIXZEkICmERi9pwpgG1Pwf0fvkNXiWI8FsfDMRlc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1403.namprd10.prod.outlook.com (2603:10b6:3:11::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Thu, 7 Jul
 2022 20:54:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 20:54:55 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] target: UNMAP/WRITE_SAME features/cleanups for 5.20
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bku07ifo.fsf@ca-mkp.ca.oracle.com>
References: <20220628200230.15052-1-michael.christie@oracle.com>
Date:   Thu, 07 Jul 2022 16:54:52 -0400
In-Reply-To: <20220628200230.15052-1-michael.christie@oracle.com> (Mike
        Christie's message of "Tue, 28 Jun 2022 15:02:25 -0500")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:5:334::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bd7281d-9d12-4cab-7534-08da605af1ec
X-MS-TrafficTypeDiagnostic: DM5PR10MB1403:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+ewyEZAQAyThXfAsgLv/tshHDnEy9lbUT8d6vOoqZXgwUY6US7SyKlhr6p59Hu9y4qnI5nSHwy6XdMTBRGTMlFbqKxzSoEMzTKBgJewBPd9TkBfpbWn9JZgCfgiKwaAIJhjPdJl6sFX3PknjsTzqdks0y7l7xJqWcYZvoty8Vnq5uCI3qhdqjT3K45i/S8S+5ab5LDiaPZnH9Ia9f519DcwfO6OQl9j5Nm2OFCSwuivRJ4p1OdZIK/s1j50kVmVsDal1F5V4Rd6Fzkzpy1NlO6xjEI260vLZtsDZDbwV/ykZUar9O2dTzadljk4JdWC+coL70khhteg4nlj+LNbvx30l6N+NTZYe2j0PFYhpC9Mu6owW9p6FUEAX38tVYtjG18PR/ivQZWpkAbq5CR4A/t4+cKaCF9whp7Q1eRxnPMaQZ0TiHhgjRVX791MtQh1dD1W9Vv3/lmMK1pNoFTZM33302gLnb82Be3bvowOd14k21hqqbgO10OVpbyY3BFKo6BqZ7wVSE6Qj1+57VhMZBKhcW3AzN+Vo/ZYEJ57E6znoYzkh/RCMyBcYlOIWuqEKFUtHwOM42K7rwtQyZGBK6TohbxPm7K4+oW+8Dp8valeaMHITeegrWTLbJO0avZtlVJ+QKQkvfjt3xus18WzhZHfjyv2v8jpp4eii/0HrGtJff5MZZqBiQgeMbKgsB+RYWNPiJa7dNRBtLwbqiTvzk++UqrWuCpdvhT3XsxsFEg759miZ2reVdRy5FSfsZtqHyvF3GAbRH5zh/zQR63AuBwiXRdyFhXREPaGnl95DEegwnBKMJ893w7ZXy7DXaGF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39860400002)(376002)(136003)(366004)(6512007)(6486002)(5660300002)(36916002)(478600001)(558084003)(52116002)(8936002)(6506007)(86362001)(26005)(41300700001)(6862004)(6666004)(2906002)(38350700002)(186003)(8676002)(4326008)(38100700002)(66556008)(66476007)(6636002)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k2Q20oHKTku1HVJZ+yiaEGF9zeAMLhDpvj1BZ5Q7SRERbRUfJHT9JWiWwYFf?=
 =?us-ascii?Q?o7tG+c1xHPQ0EkbPNzdVvET9RE0AoiKxcHgfBzf8E8vDgdMAhN0BljMiv4sK?=
 =?us-ascii?Q?xQ+vo9aeIRNzNlMsMYTyAPJlnQe9APsE0SwH+0N7531ROD5vC17+U1NHe+34?=
 =?us-ascii?Q?HwJXVeIaDQ1cBn6rUtTVBczAfguORHNRBbDFyIfqb8tWa2q2NsnvPml3llUk?=
 =?us-ascii?Q?HK4nFIInjQqq8nnKlQ0Dl2xEshSeWB2gfVnq2wZyKhJCpxdAjmmRbNdkuaSf?=
 =?us-ascii?Q?yCmOsf0l18zKYpRH2Jb0ghOMneyTdw33HBQ0pAqb0/fx+/pkweWoVp7iBaKK?=
 =?us-ascii?Q?Z9Oa4skJ2jEQnryPaSv1mVOchLxFNFJzu2VzhYRkwsEeUegDTeXVg+KJ2aBs?=
 =?us-ascii?Q?Bw62ErFmqRj1qrdsJccwT8g6CF7TNN3YXGFreIKrA6uw+lc1Sx9IafE5HkwC?=
 =?us-ascii?Q?6CM1xn4bjv9gblR1os+PpahOOiytFaEwsTBVFTUVoHCufNHU62i/v02IJax1?=
 =?us-ascii?Q?Y5kKJM+/NBldtDOj/kfe67ju1K/bxiiCytv6+58C3AuY6xc6Ba13kUyIv1Ys?=
 =?us-ascii?Q?fajS5fMPwEH+pr4vGCUnFfQSoRS8uKljWaMBmLzOthXY0olGLvoKqDRsXG9j?=
 =?us-ascii?Q?26nx3YxtjYa+PRYpiCgrbuLl/8EXqHH2zezsxqx0GqEGTZ09v9NQVuh7lN47?=
 =?us-ascii?Q?q51ESm3YNvgU45fXlYTc/TSB4xEoAWp1BdINpoan+AD9Cfn+1jBKn/V6vfSR?=
 =?us-ascii?Q?k++DEH+64bYJMO8Br2HYHAOKSpHEqkWEMKP0E3EmkmAzcLY4szYglRikxplm?=
 =?us-ascii?Q?Nbgdaro4HuJZjm2+efdnII6ur2HrmYNG40CjSTOFSYEaf5qtVXEoGfVyhfeO?=
 =?us-ascii?Q?R5fQ5dFGbjsLGugg2U6o2MkHIMW3dk4A/G/key3fHISzkoCznwafEStPmgiQ?=
 =?us-ascii?Q?1zZEKAQ1897+J3ce/ieeZf8J42t4dlovCkXAgoRNjsH9isS7r8A9DVba8SY5?=
 =?us-ascii?Q?1cuWGkppd0K6IjKsMSGTIZSB6OuwHF46BwUPLC9G2MGfpjYFWSvhZ6k8khjv?=
 =?us-ascii?Q?AhtYH96o5anwkdirMwhNxaV56KtgG4rdIkBhoExbGJRCNcPNcHX6f+rEwktN?=
 =?us-ascii?Q?Wbqys7fw8Gsady4W5rfc8Sbw9fcSbEf2P9hHX1A9vjn0lB3lkP9UEWGpCSTd?=
 =?us-ascii?Q?j5PqNrcHiRJyunL2tEAHKNQvybSYam3o0PLbn0nAFG/FQ8OYspdlnYhzlLtb?=
 =?us-ascii?Q?FmJj3HKaL0gp+kywth3epr0V0e8zJUKnjQstsFxayIo4hpHCXFMDkmVOul4J?=
 =?us-ascii?Q?vvS7bD8bi/CppdRaPOWlAdtbFYkfiocq2FeM72Ks05q8cDwfw4dzYR6DOHWs?=
 =?us-ascii?Q?PJjznT1Qy//WAAOZvqWRmyo56K6llxXuTmP/2uSs2d4chrA0Gy3R7WF8brUE?=
 =?us-ascii?Q?r/fRtjGiw1rCnYq4hk2AZnuFUUrwRHDLLtMQUMSuk5413jbRMDS8czOVxicy?=
 =?us-ascii?Q?VbZ9U7Ou8Y2SSBMxWp81bQ/kl5/RvQL8JalvFutTbt6XGCAWD63SqK2ZUFcL?=
 =?us-ascii?Q?oZabuW9dnk9mm5QHrC2bnmdZdpDOatidctbTdNITNezEmWmN/qF2zNkENZ3j?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd7281d-9d12-4cab-7534-08da605af1ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:54:55.0818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VuPtJFHrh1Gqc5RKy3e8L9KnRyp+gd2OdE89qNP+uXEd+6AldObnbMJVN3siDaqPQtM5LXEo99VZXWfgz32Bj2BIDp5gE6c0+xbBkfFEmfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1403
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=712
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070082
X-Proofpoint-GUID: _aXZ2TN9FdjbV4LwcvCQtC_GzO2d0r3N
X-Proofpoint-ORIG-GUID: _aXZ2TN9FdjbV4LwcvCQtC_GzO2d0r3N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> They perform cleanup to target_core_file's WRITE_SAME handling and allow
> users to configure UNMAP/WRITE_SAME after we have done the initial device
> addition/configuration.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
