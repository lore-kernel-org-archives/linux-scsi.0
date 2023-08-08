Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B46AEB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 01:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjHHBoj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 21:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjHHBog (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 21:44:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32DA10F4
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 18:44:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781iNH0009102;
        Tue, 8 Aug 2023 01:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=tN0ncFWkH0e875vxleNanhXdF72GC7bztYbNDsyx6bw=;
 b=mmlo3wU+qZN3c4AaR1D/UJ4EQJpzOZvfpZ1QUJ+csY3/PfU352m3eSsmaCqreS+g+RH1
 UY7hHlol1SYxq8oReFqwc7of2LC8jhL6n//VgsZu99JaIoTUKFWuu4Rbxxd7lTF1Payh
 Sm1niUupcbgom2UKlumDyN63yD8vy631QzwU3carIaNQMAYYbFQWiE/yhY3/qEUDTmiU
 6I5eXgMSQF8A1mETqEuuXFwX88HMTszmoxiEr1Wkrmj2Ucff0g8nvORKd1PrAMvGESRE
 9yaHPQgg6UiSQNVcCaG4XgV617XWCIXta2TJCLmagyl1gYLAN0uWAKGRGPpwC4TQlCwz NA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9d73c3ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 01:44:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377NVehE032920;
        Tue, 8 Aug 2023 01:44:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvbcudk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 01:44:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4hYRvy+ClIutDzLvRmBUyxxxGqTAhCdFu0qochOXcM7ZqI8/bwT10iqU7ZarKkFVFcf4qRy0a4m1D0qKbmFRNVSy/xvqKsVRMWn6VdEixhAS6PwBIUVfDSqxyEusLCeKO9HpOi/1dewYnYALgrf9TcFjbL+Xr3YX+JmlKdX6cF92J1LWPAk0CJP+x7E50pEYXBvPk0VPdCxss9SVWvTJz5HWJ72YbLZggfj2A5j0jcPwlxWVLaKogBo6iutnojl3n3TfpKEXBoDZ3gsOgjEgXdO4vnY60a5dOj0QpEDNeSC8DByafL6i6wG4IKpKKxrhXHCDW9+NxjyBr31JIvfoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tN0ncFWkH0e875vxleNanhXdF72GC7bztYbNDsyx6bw=;
 b=iBXnv7rC1014/WWcvClG9VWrJ+o+Nih7Vd97v9OFMn0Dbaf1IyShvmETuHGBwz6Onz48hRPjJWv0tINXgFMuMoFfM/XAjOInwK8V7sQOFdpLOW5YlW3BKDGPgIEWmEFUk9ZipgeLSiv4TI7/AQReEBdlhF/FjsdFUCQ/AmHjGZSaYU5wp2ByqBhDaJfcmQlFfJdZf6j5YG+ZA6Jd9pcRC/U4s6shn305eNhapOsepcr7bqHqCydngsssXgRLwlEVUQEmbI3TWmUB7uWuWiZr86RvQS2tGMiDNpwzRFXHGHU6tm0XBjRu0BomI00jpyqjyTiLO1kjFjstdqOVWeUvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tN0ncFWkH0e875vxleNanhXdF72GC7bztYbNDsyx6bw=;
 b=u0gOv/PdrdlZ6SSpma4/hSxXNNoSnSgZv0L5qg6lp+LYx8myr+1xab6Nibpbp/PT37Ty77t4xHLz1UtyNQhcLV/qisZlgtcpMOpLI4rUKDvV5vcVXuxpJW3szK70tijOcer6CmkvpWUzw++a5z4cOiJHJvpGZT+wlR7Gs19dZAw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6330.namprd10.prod.outlook.com (2603:10b6:806:272::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 01:44:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 01:44:28 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH v3 0/6] mpi3mr: Few Enhancements and minor fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jlal357.fsf@ca-mkp.ca.oracle.com>
References: <20230804104248.118924-1-ranjan.kumar@broadcom.com>
Date:   Mon, 07 Aug 2023 21:44:25 -0400
In-Reply-To: <20230804104248.118924-1-ranjan.kumar@broadcom.com> (Ranjan
        Kumar's message of "Fri, 4 Aug 2023 16:12:42 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6330:EE_
X-MS-Office365-Filtering-Correlation-Id: 6406684c-5254-4bb1-ab98-08db97b100c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNmXJj/QaJqBd6fuVV/LXv2H+ywzByzuf8Y/9fwz29lhhK73M9zSXFh+UOxf4oKPND1GIC6UUltyw6b5N1v35WKWQ/YrEMpMVOa575rUc3te6iTTeR3hmHCVnHMMp7LuXoQv+KlHgNmQeAbC7Dm/c0PTRI52hsq3vc3Cv3GjrP0PBWBZbNk0/jS+nhFU2+bV7nQQuH0w2M/mTzz4uz+lnaawIVognWquY6dkEVYtYtlzCJHda7Qik5OhCq3vqWd4lKYtN+oN2lEkWkdQ3BeE2lvkPtoXk28wxGktVDh1JNvBRWAMVhbtwj0bYfdhaODMCGQaLLcveGhlsyVF9qOVcb5MrSedOS44LedSLF3ZhZ6adaQTVKoPb3wdzu2IycecY5qQNi3Vzn4d+sXGXYcCssncXxb5m2F4wSvXQY+c1BivJQwFKScfVAuvBDpuUmhu3Fm/nPxAZxT3LtOYXc+sO+DTgXPeUZsIOLltzYdey5D/zomBAWJ70Y7MleYsZQzDbewUI3BJByHUJFeEueJeoY8+xuvHQQu5eVHSqq0ppnf4uKwha5UNLSKKgChmlgdSFOKeG7KuXN5lhHhu568iStI1rZ0QYjNxZNP+tuordeH73gcMP7wQij/akvuFP3K7KvMAT5/1tHdUlDjaLTCGe5yoKLvOWcQ9zFjhUK+HxCY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(376002)(136003)(90011799007)(90021799007)(451199021)(186006)(1800799003)(478600001)(38100700002)(86362001)(6512007)(6506007)(26005)(558084003)(6666004)(36916002)(6486002)(6916009)(4326008)(66556008)(2906002)(66476007)(66946007)(5660300002)(8676002)(8936002)(316002)(41300700001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/qVcpyIAF5y5kKMbZQUeRv5RMadWarQ8mkcVJXiWRLjytjsJdVPyxk+6rMjz?=
 =?us-ascii?Q?+WI5TpuD8SR0IzpEcMnANWwHTsgJ+K2nNtt4+J9/lnRiaBa3EDGbSYFanPPQ?=
 =?us-ascii?Q?FMz9GviKz3l+HRj0NEyjJaNYahYPlBQF+Zp/0GXOqdZllmWH3VyN0k41YmVW?=
 =?us-ascii?Q?6RlzudVx6OzcuUHLCW0FJyOAU/rswrNUmHru/nfAi3HxQFebdSqa/zu7ItPr?=
 =?us-ascii?Q?ODe2ceSKNFvtICA0otKBjPhk2cPdX7UuIYRPbh6iyd9SOjv+YJ1YpkYs4YV0?=
 =?us-ascii?Q?x2CCNClt/nC7iux/AbWVLHPhRp53Nl9A28WjGHD4AsXsqF75pdekv5f2+J6B?=
 =?us-ascii?Q?JAbQmTuzmgwRUqdddm+ECcghlajxNSk07dRyRyRC/EiMpACNIfWJwkTS1Bl/?=
 =?us-ascii?Q?C8AXuP0RVv5jsRlg6J9WUMazxV1wpI9Ol3TNtZkBE4i/hirU3ZehT2aWJUQs?=
 =?us-ascii?Q?rCUhO3txRZUA+j9Wl8EEHUs8ohiQdrgt5S+AhaT/npHSfJKB+O6lov3LkNUA?=
 =?us-ascii?Q?wM8DrslY0BceLu0uXzqbcZEQamY59qysx3C3EdtUe0vBlV4/25omdsibLeUA?=
 =?us-ascii?Q?GmrkXAfHcUx8VtuKcqTdZtZXqYY2CH22vcE9hdLHG8j6T6p/t+HYXFWX4Zbv?=
 =?us-ascii?Q?SBjbYNyFEjWhd5aySsABf2B4A+ybjiGEwY3ax86DPSLxC1x/S80HuH88gcqP?=
 =?us-ascii?Q?/0RRYgndGxQs482mB993TPkZsZ5jUBscqKT8yv0lWKJVIfTSsi03bL2DI2zB?=
 =?us-ascii?Q?vBMYwDF7Ppj7M6xJwys5hCK5MWQJN/ASv0qddlItiPLmUId7KoVuTSUj0YCU?=
 =?us-ascii?Q?QGKa3lVPeJ17uIi4CRGebcIYzRjGLokGzZQCdiDRjgTO5fLxoNWw4HX63gUC?=
 =?us-ascii?Q?dPFU1F8QJW8awXB0tQnR1SantWidAKXRhVU6/ohbZrMSUBEWWI9CfsjYmFdy?=
 =?us-ascii?Q?0h4yR5rRXJFT2/gZv0V5yIV8rwWrqQt4u5sAzS9d1Da1cfu+r1BpPAIrRWwV?=
 =?us-ascii?Q?yz9NnxcMp5NuzOhxyck/lBJlVjLEPUps87VvR1s89zDso8TCDaWXtjRwGcz2?=
 =?us-ascii?Q?b9N5ZVTTUiJDLj9NcIQd7h+OSnlGRLIF/RR2hA8JLxDeMfKHvvg+DiNhEB1q?=
 =?us-ascii?Q?ii/gVlybQ7HUdX6cvS/TGGalsp2bpjoVX1o//wL5nvEcjNgIVvLNIYY4yhAL?=
 =?us-ascii?Q?Bg1+dP7wEKq9tEivPM2K+AMxr6raQA8okab0SMo8d5x4oEndvrvZQyj+aAg5?=
 =?us-ascii?Q?J1Q+oSo/frAAAiHi6oMySyyaP7EmTM3Xoyhcpv+ndzq05vG7qQ7ci85MVk9B?=
 =?us-ascii?Q?RHKcRWZsKj5Mcjdy7/Xai9XPHUs1UY1TWfgwaQK4RTIWf79E8UoK7NNRFcJh?=
 =?us-ascii?Q?TmqL4nbNE9wqtEEr2qWxLxfl9q3HwSVmh00XvpTXPs5NvCVbqJr3gxxyWti2?=
 =?us-ascii?Q?jTmQPw8uDlOVEljcgww7JJryW6O3wWL+toLPTejZYDPBwP/E4Zmce/4rV10+?=
 =?us-ascii?Q?vY2fx4zFBnXk0qtBGKyoq+m06UB6IfgqJMvgW32nHtE/Uk37vawVZVtrnC4v?=
 =?us-ascii?Q?9rWvImHzVxU1kViSUYwRqLafvPxYpG9zsHnozIoi0uhk72RWMpXoSsfrM6PO?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gRXJB0TcMBCVs931yJoMCjOhPhHjJMrJEEKm/D2B00B3Bqnpc+IqgAz86VF0A0m6siZ+xpv0RJa09e5OT+yMN2Bl3FJiwWH5YoZTRbPRbfDZ1TxJZyZH18RTq37WBSbRb5aPW/WxmWirAUyQrYkpACP1tYhfxW9euW5ZCvuliShYh71z22EOVzuvtuP5mAzWe9GeYvoePoJ2cCfuKcGkvZHXDMShRQ5Os49yZXOA8kDgAJ6EG8sVUo+1MOAqj21fJXzG2if4wU8KRSQcANZ/K349Hvkjqe2R/J2bqo+FxJi6JmKRQh8dcnUxSSqVgJf+qkUDEgXLDZwiIC7zEipm2SJeWCN2z2AW90ZxJZ6JayRv+t3bYtoB5H/SlAbLTSr3BR5lAqW3ZWpCATWo6AqzEz2HImBg5phV200rnRs/K+wThhfuEgwu3aiF4U5O86FJ1P2d0cuHjTjTwTgv6IZkRU9ZPTJGahrJ6AadiYSLJQTiT/VmPolAhv27jFigHGx6G4NedMBIuoLqA+ozM2dGSj9S3vg1Ky6FICUbfgsZS49CFsMWXQjL5+mkfc0EhxXB3e8hIcTnJlKg19Itjtq/68T0hYqA0Mrmz3kk4nRYwCXLEKX3hmxydS/St8MYZvH07FAqFLvCBJNv+a0kBY+Q3Lu6cBwxi+YNhfVEMzaIpzavL4Ettqb07diTgP/PzjwQUI7bKKzG3nZ7MHRV0L/a5re3ban+qOw7nKjo3Rirzp9x3wEnIhO+zhok1SxU4G8j/puS2X7lu206c+Lmo0FM5oB8v2qdk49bJ65UK17NgVk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6406684c-5254-4bb1-ab98-08db97b100c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 01:44:28.3132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwFIuJZWcmJ0kWkHNuLLa0Bxdz92miXhNdSXPpvuXtAN3PCuve5y7dboku/X3Ftb9QQk8awTTxCT+mK0jdCxhDRqhC/gll255vbg/bpjnDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6330
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 mlxlogscore=741 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308080014
X-Proofpoint-GUID: Gc-4L4X3OmgKoZvKFdckBM8RrzET5JC0
X-Proofpoint-ORIG-GUID: Gc-4L4X3OmgKoZvKFdckBM8RrzET5JC0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> Few Enhancements and minor fixes of mpi3mr driver.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
