Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B81C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 22:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355974AbiDZXDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 19:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244571AbiDZXC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 19:02:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ECE66C83
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 15:59:50 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QMOKr6018608;
        Tue, 26 Apr 2022 22:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7ZnOVHENUKcUIpcT4TcmXLrVRgypnauTHcIEM7ZFbRA=;
 b=tf8qaM/qmYZpJhNLsxoE42s0dOO1kQQ2iveFZfdGz4LRDUctIst2PPO4bdNwxziyAzll
 5TK6+88rokhFLmoVFCfzxksBsvvhTMaREW+7n6kWG+Ln2U8a2O3aQHwotRDazb6tyS0P
 /tgM3GaxdIdQena/4AFyWwt6Wjbte3fDbYNNSI4LCT4qjfjVAvgpnmuMFWNy853lHfam
 uwJ/AH6HmWwnfiIWaAEuI71Rm8T64gxtv9q1ReBlytEbjPGLe4BeLxIXS2RU41kjKk/N
 BOwAkY3B4oNNOxc4qBda2/q0uA9J6Eh/HHRa8itBKE/ILZpSVmy3LNO78FXaCe+K43Yp KA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5jyj27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 22:59:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QMoXAe019818;
        Tue, 26 Apr 2022 22:59:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yk0eb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 22:59:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsU2G5pHW9ao2bxichO/qy+6lgTn10jZwuXtKP0ZYLHUOdpZaEQOg3ruGnNkE2FOP3yEls23hDD0/ACDctgYGCP4002pVt8A4GYuoKE/B9IyMI8l4/yedgIJL1kDl40mKdzW9ODImXhQUb6oAgpkeIfC+ZUaPc6TXQwAukldJZ/nyZ0tidNddBK1T3gQWf5hdUqjghQSavuzMxPqRdVs7Hnx/ZUUFLe58oQ8fo5HsV9jEw1H7SZFfU4PoTBo9KCGBw1GxKs/N0M9tRQRjCSCfN3sDa7Z3zJT4jqbP34uJI9vp+36MjghH32IrKiOoN55khyhdGRZE+yjXiweqx4rHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZnOVHENUKcUIpcT4TcmXLrVRgypnauTHcIEM7ZFbRA=;
 b=UFhyIGytP1K/CSh0WOJVgCYdCe3MF96Xj0CpFozFNQZew8pWegKIzkJJKQ2Rea/XmCjdMdrImJTWE/zH33+v5L4EHL5aqZOUVFgGoGMw1tKGgt+QAOBDO6CZNkzMwO9kkWkHtSHJClkiwcTHquscytLf0hiSg/3srBlgFPavcUPNHG/LgHiWvSYsnWOs+z5Aqgpy3LJcx8pOjoMXAQipKBCq4LL7XexutAEE+/PGGeARyW21Ggzi5L39BmCIEwc3NQ2cHFBrrDqoXX0DGuFRO+qncSode6klaWb7nLKsJeqQ+8ffYPv2i3h6ELLTpDfqlRMS9AzmUJQ5nTiq6lbGSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZnOVHENUKcUIpcT4TcmXLrVRgypnauTHcIEM7ZFbRA=;
 b=qMMpXHoAUm75c0Nq7V56i4OKlLVHwh8AY3b1gSXaXuSMULHqLja2Zzi2QvEy+LMNPp08MnNNXHc60VVHyf/DiadkmBXWQhAymvDk6x9mZ7LLn1Y9h42c0JZG12d3Y0Kj9wo3slYUJxIjc+YA4abHsg8o2CJTMeCoT7U12XlMcFs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3834.namprd10.prod.outlook.com (2603:10b6:5:1d4::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Tue, 26 Apr
 2022 22:59:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 22:59:35 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, hch@lst.de, hare@suse.de,
        himanshu.madhani@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH v6 0/8] mpi3mr: add BSG interface support for controller
 management
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfpzo3hx.fsf@ca-mkp.ca.oracle.com>
References: <20220425122334.368142-1-sumit.saxena@broadcom.com>
Date:   Tue, 26 Apr 2022 18:59:33 -0400
In-Reply-To: <20220425122334.368142-1-sumit.saxena@broadcom.com> (Sumit
        Saxena's message of "Mon, 25 Apr 2022 08:23:26 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0194.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 341c8448-6570-4673-52bd-08da27d86ed1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3834:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB383419548F07ACB1E1EB3E538EFB9@DM6PR10MB3834.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qq/lhhek5nv9r0cTXUQYvAPs4jefCPwNal0HrrBeMS6usLDXrDfqMPjdgDP9p4CCWE95/b3G1FCHhtRmVejFd+hW+HElNZ1WJwUVQIqBxnXA2QCx+xcGgMtC9qM0BkzNfMxTSSs02y9f9Y5PvW1S5HUgzuG1sgUpiJWq1q72n8YDamvDWWC90Yyj3xBkxa+f+1p6UOwqQsdg6gXGuW1w7P8G8THiTmkGnwvTcQAdCE7FvfcfJ7rePVZo0wYkLWMtso/1nO8k12gPDb8y/EUXdqBNrI76tT+9CId4SuOda1lO38g+l0GMkC8+X6N5bRcMis5ddCFOVuN2RDdoKSee01R96+PBvq5z1ofCeFj/2u9asbEiS9/vDG2X7Eb7HANDPSnz8HHrX1zGagtijiqXjYjiO9lJ7gl4zp5U8NUDCCHvaxfvt6vPaaay6ZNfPI3BW3biGh3MCbzvUpddRr/cME8yI92+d370TF9pQCOLNQ/uMJ0TAnmzC5XXWYPosfIIGhM/JKnkZnscvGm6+NdXXYGtzJgoEeXGm0PIk8zvZEekzdixcxxQgDDCGn+u63s/SczpYCUg00VGmevaL6a9ko+3dYnsjANcu/wYsBY0AjPEuwlWsrNPG81TwZ1tJhGhcMDpchqjO5rKne97DLqqX/K5gkuDgY+hxAfmUnznbwuis1WlPMQzCwBnUgaOcuAt5H/NNXHjmL8/d3z4TkjjqgYMAapH/hGNlsg0f7zUGMc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(66946007)(66556008)(8676002)(6512007)(6486002)(52116002)(36916002)(66476007)(4326008)(316002)(6506007)(186003)(86362001)(558084003)(508600001)(38100700002)(38350700002)(2906002)(8936002)(7416002)(5660300002)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RWd7pKwhPWrUQPAdFBS4JUW5M+afJVaNgqLCYIKVxsiGmT6x8sP9bvuFt7SQ?=
 =?us-ascii?Q?/vtrugKgFRKdaZS4csEe5PsBrnxkLrsUWa3aXnKocxqQZOIS1YZcTD7+rMAl?=
 =?us-ascii?Q?y5JpwhDTyHeBmy43RFZjEXEnLZoPTeQv1ZC+zeUdptG5mfEx9vqjb2O+DEmc?=
 =?us-ascii?Q?OmonIGAbtfhNLhqhoxtxJBKzYYbW8ZmUOW1glAegZWfme7UZ1qPM67AeThkE?=
 =?us-ascii?Q?5czvIa4RX4PYQxA7tXHb2frpp57C64nlfibVbj5ORJkmEasaAXDy30kjTyEy?=
 =?us-ascii?Q?HGe91P1Uf7PzOnstOZSEU7nzADihA/hOQPpLNhf27XwVezjz5OD5ECb6vhsj?=
 =?us-ascii?Q?5vmnVrfFJDfZIEk2la3DMPs6YU4Jbft0A/9Cui2eVDE0nrql5+GqBxATJIzU?=
 =?us-ascii?Q?c4GNi+qoQ9TQsk6kD+P5FD2iXkM0zGEvTW8KN/qWInGjemZnLJyHSK4c/zAn?=
 =?us-ascii?Q?aMQhTHmQn0jG3PvlhNCbnLBwmXcBjBvFMh/V7ikAhalZtP/N/SUxSnN9JZ/O?=
 =?us-ascii?Q?qWjnjTsxEJqhAdNsC7jtZTCWA0HkxT2cVcAdfLzcl+Xa3Urw09iw6dDHmW34?=
 =?us-ascii?Q?tSw+M/cLMYKHlYrdNP/Im8m7wjxzy9+qfy7Xmfc6aTDZixMmT03HlFZrHIPX?=
 =?us-ascii?Q?OK8jBY8OR1uT/yRBoDnmIPDMxb+bH1dQP+JU3zbS939VxO4uBJko8mAHEPnA?=
 =?us-ascii?Q?dJhGhKpGDpCyhCqrle2+WJSmv0v7adMo17e63l+BlHeo8u3au82J7AmuSzjJ?=
 =?us-ascii?Q?keiDP3VgvZ6BDQoiXE78kiDSZKl2E4I6eq4XRREPz/fqJ1cKE4GPk8hXGczk?=
 =?us-ascii?Q?LQIE2XTm7zlp8fInGf3xRP2axPmrPJJZLNf9hQFQfxaafXuzbhw6An6H8g/Y?=
 =?us-ascii?Q?388Aki0H7KUyzRyPQr2ZyubXJB8MUE9CqvraXz84VPeKLBFenDYrt3OfUpAg?=
 =?us-ascii?Q?zgy+slweKxyMDcppuvOmFIaskryK38Hu+bNlnfbnxAVUOPha3rjiQG0qPpIv?=
 =?us-ascii?Q?Vmsg4JS/RXHocfKLA0RSR+0ImB5TzgnQ9E5olv6aSH+8kgwHkI6U/r6aHUxH?=
 =?us-ascii?Q?AIwJD+YTRZu8eOx7/g+C3kck7tS1iTgtl8y9mybpwEDO8Du8d+g3BWD9LObz?=
 =?us-ascii?Q?OzYDNmLBksVLcPvCw1smhh/dCZNTMmJD53wF5MzF+1oe646FbSlCDvP3VM+L?=
 =?us-ascii?Q?AZwheNJe7zJFH8Z0jQ9M+A3IO7Dy/eh31WmLXoMelWGpF47c3Qzn0yRcFG5C?=
 =?us-ascii?Q?eHWQEgt2JVbQdam2G7fknXcTn8sijHdVxwMHEl4BTtrVfqlOntc9ENPmqwrr?=
 =?us-ascii?Q?UPYFIJ9BrvtAwqLdkm7LmBjK5QaOiiRI0cz3KYdqcNvw/SrPJwk80q7DZRp7?=
 =?us-ascii?Q?cF/Omh2drKh7UAvUoLPQGljHwAVOGnufYhb/X9rSDKQ8LAHaAOsMcKViICQL?=
 =?us-ascii?Q?ioknM8fnCZjpAq6NP61nrdalAyOVMLWrw4OtRV4ygp6dcsuJAds3Ah/T7Pf8?=
 =?us-ascii?Q?Pigjhu06quQ7r8QrbAVKfmRqfA0gKMhd2PZOD//NZJd9UG3FWMSzJVRb7OpR?=
 =?us-ascii?Q?OLYrdnOcpycm2VZNSTy0jO8kLJrkubT5/HmyhKeVzp3LVEnCHLEtCDOljU4q?=
 =?us-ascii?Q?BsqiydvaunZTZ0UqNRIGfXd7oi4PPsqdGe12u1oDUWUfhbKlJtW2uBlAokSz?=
 =?us-ascii?Q?G2vUqzLJ5eR/gKs04bH2YuIHLGDa0RDGdLa6A3pKQ/q3GjxkputI38VRl/YG?=
 =?us-ascii?Q?z6GxZsUCe8+VwUxtG/p3SgqMsWJJyfY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341c8448-6570-4673-52bd-08da27d86ed1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 22:59:35.4164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbyDgj3enynKJuwgyYku3YV/dUshqiXeoS1xbHu6y8PscGdWgoQXJmMe7voqUCiAPiX8iEeO0JaKND2YbL3fYWwoLEc4qCjT8uTqaeqFsAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3834
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=524 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260142
X-Proofpoint-GUID: 9DAiWgDPJODrRUCVwQes-M0nipAkoVMG
X-Proofpoint-ORIG-GUID: 9DAiWgDPJODrRUCVwQes-M0nipAkoVMG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> This patchset adds BSG interface support for controller
> management. BSG layer facilitates communication/data exchange between
> application and driver/firmware through BSG device node.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
