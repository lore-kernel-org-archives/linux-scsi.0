Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EB7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbiEKC3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbiEKC3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:29:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5E5219C15
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 19:29:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B2CPBA024435;
        Wed, 11 May 2022 02:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Njr7Gz+p6NDOguN4tL0swmZX9y8RvKdihdrR3eiSxz8=;
 b=X+29TwhSdGBIc14H7Qhs7t2DURV3vaCeYOZ/5kPZaHy5ZYPeuOseoQpPSRecj2vSJEpF
 g1SLPrneAbZA5M5KEzr2Wfx6X2xD2tfprN27NA4sTSIIf/BueBukbuyuqRpV9UCAFgCm
 114CfHNHCwkb3iwGxn4i7gEVZB3IB0GN+Z0AdPM1yqgRk5KGfIMiKY75pyzUm5hSceoV
 V3eTPfF/cnB2DR30wHfadgBKF0xP+hUhHQwsSePvtsBhh6MEzCQtS7OUWmGxtGDRQcbT
 QZAY6YXERyRvcW8lzDde2dopv6hQMNPPgoCXJBulAwREyeIV3esUOAyu3JSiJUHdRJAJ XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsrfwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:29:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2LeNT015360;
        Wed, 11 May 2022 02:29:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73s896-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:29:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfmLNynIUPmks60SwpQBIF5nx4cOzeZJNXsWuVGdAjC1FGISpjBl4RjqMrXCaGvcITMCpreRn+o3z+6fp8L+ZmthIeLjjiLyO5a4lM4pqq5DJz09J/M5UuTVCxug4YWF7DNBpFYG7oycLTvXX9nKLU9v/wSILm5YeDb6v3jSzLPqmr20X+zpmysEVGz28DCXjGCgXiPlqJBq75MywQnVpSGxyunSMv0zas8kk7HKPE6yjL+9pYv0i8fUEoV0ZoggFU0ObWk9IuojKQZf5vWo0NraJEiw6fveGRYgUYbQ66QWXXnuGa9ZzLCzyG/v2hduR4m1+xJxdXl6RKmSad0V8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Njr7Gz+p6NDOguN4tL0swmZX9y8RvKdihdrR3eiSxz8=;
 b=cDIOVbtCL88qlx/5GXq/xQHD5qZ5CQh1dOwoxVUUKAl8QsKHTYlS5/CEYCkKEmoJQQPEe4S4KFUq8KdQ+6kcXspz8ta3RmFw8m9hudLhOi+qHBLVU+61/gPAGCgZZrpFGjwvuKOlQ35XkWU6Ro3ceLX4WPTiX6iSDJR3whIlCdj37z+NitMiBeK34uwRKX+pblaeNr2JaTj/KB/7olTvai6JZzP8dD+Aq+beP9h67jVxFpBmYyhyi0tA/noQ9YXYq/Jf37wwlsVOLg+zhG9tPir3x9wa+8x+5T5IwpExgplsy5Oclu1MoUnvcFl773U26qYwd3bhOcUdOhUieAdEdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Njr7Gz+p6NDOguN4tL0swmZX9y8RvKdihdrR3eiSxz8=;
 b=ij7o9FdVtEpBEgNJsr+E33BZDJUqZPqsVTkG2FeOBXQUAy3BmaQGf/YnRPcJR3N6RxblYLoXEK7vRaBmMl95XFQnStPBZFYXFXXGinyYG+bwBaMrV8OsknkRzqG50cbOWoUmCWydtvcwejiZnAepw5Zvy4/NAzKiyXmb8vSN8WA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4569.namprd10.prod.outlook.com (2603:10b6:806:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 02:29:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 02:29:29 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpi3mr: Hidden drives not removed during soft reset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o804yf7l.fsf@ca-mkp.ca.oracle.com>
References: <20220505184808.24049-1-sreekanth.reddy@broadcom.com>
        <20220505184808.24049-2-sreekanth.reddy@broadcom.com>
Date:   Tue, 10 May 2022 22:29:26 -0400
In-Reply-To: <20220505184808.24049-2-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Fri, 6 May 2022 00:18:07 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0082.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db53dca4-9163-4c4d-7ac2-08da32f61317
X-MS-TrafficTypeDiagnostic: SA2PR10MB4569:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB456983682B0EB4E8FDBE3CD88EC89@SA2PR10MB4569.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WnAWZL1hKv/sFUPDDJ5nN/kJHVAuH29hYKYirOTOdUceLsrb/xl0drwSPhzPwhAZ+fgmcBtnHlg97CsAF3+7S/IATPum2dqYyp7jd3LhGDGUHAtEzCe+ovjQWEFH2NYIPFs+7rfcHbJoaZH9rg+1JXMGadw899z+B1bK/PfWeKYxB9eTKFjriDx/lkbUHxMB1KMMCGWLWakyokXRgqe4nLjxoDqicGRNs9+qY94lhp4umtLeUzntFOZtqcsl95J1v/+tkWsMebU7c0E/OIo/pywma3Ocf2AQ9XWEOlcqtfrsdyoobqEfQSos2TUSup26tbeQUEKy2ffASB3RD96o03jj8vo3F+XBdLR+6xAJPTskEULMCt3vmJOmX4ThGQDDln9Hti3iqNJUofgA24XT/eJUpGNiyOeuQEvMFmuIEhKzQvsp/omIYUhnA6jEFAznV0xzDHfUMkx+VahB4sDQEwZHUPYu9VJDJYr9HbhEyFyib55GEmIN9b9XfbyVvmaK/F/1b7ei7W7Or1sci5tlakgnj/XH9mh72OhcY9iPdjd4B6YN9X11Jv/1YlIX5K9Jf9SP8gWanfoyAbV08p4feAYptPynAyoVN8OgBydQbyyzmOZUoaL6NKenFaQxj2wSUVgEKJTpqMEIupzMQyy09Rhk6v9fSg0NCFcBjxxPW8pygIHmLKeE0i1UwVOVf2L9RqRFbCq1vSbfojvLiWshBCNiOaE4XkA3nYjKxDx3+QI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(107886003)(26005)(6512007)(8676002)(4326008)(6916009)(186003)(66556008)(316002)(66946007)(66476007)(5660300002)(6666004)(2906002)(86362001)(6506007)(8936002)(6486002)(508600001)(38350700002)(36916002)(52116002)(4744005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8YnxEQH9mqwc89pneAO6a3vYeA3MsXVxEEOdfajchlOi773zpg0siQgxIgtW?=
 =?us-ascii?Q?aDqDPUchNo3UrdK22wIVNVKcPpWT9aB0XpVameEQuNYmW2a2Db6ouP1Z+qHL?=
 =?us-ascii?Q?D5BhuncbAK7kUjf56AZBCmW4rcRE10tmXZS2vUGNTKbKQJ16OS68RKNo/R/Z?=
 =?us-ascii?Q?Iz6bSKHd2yHfs/KqoNlzrAUetKw08s/njK6ti6o0tFnG+Qyl/doClPIeB62K?=
 =?us-ascii?Q?9hGHjEGfUbGl+jib2HkHJ3DNSpkonSBJjSQOngDrm2I/h0n46OmMP7iiK+UP?=
 =?us-ascii?Q?otUjisBEH4RW4ylCm222dxemGCHc8hPvb60k//bSzIsATQAuaNm0TbRditWJ?=
 =?us-ascii?Q?8y4xKRt2gk2j+FsF33SNEXoywy+DJ4Dv+zhvN/KozliALtD/Bs/h2nja050b?=
 =?us-ascii?Q?EUhsNj86LXMDNAauWO3CJs8pG5wGalCsnD//yArYovETECYX+2UshgcmjTKP?=
 =?us-ascii?Q?B2F1UcGZoUiRRKCxXzUkvLC+BjLGt8qcCxAD9WVDfvVDkzTeAqiEJJq/sxCG?=
 =?us-ascii?Q?I02g+qG4SUwpZ8zX42XmqCMCSD0N/NhSuC7UYErml8aU38KAYZ/OsbRKeQuC?=
 =?us-ascii?Q?miFXRHLNCHi0YJqwWyMoPfMhqqV3poRkIYrTRV1ZnqVONY9tBylPUBHI5/Ad?=
 =?us-ascii?Q?eTvpoRU7rnNjuUI0186m0UQ4e5Nt0XmurGXmFa6dB4uQNz5yPxdfoHPFVfDV?=
 =?us-ascii?Q?Nej0zwRiFiqL0x3T83TVkB3YrjBWjxQr/ZkOC/eI0VRyGSzSCtN1BRtfbV7o?=
 =?us-ascii?Q?Ofsv3hKtDxx9RcIfQD1T1afy/B5pKwxxeULO4JtGeRPZ+bD+I5mqFzC32bRd?=
 =?us-ascii?Q?nAEktL0iXiIgtqWJuofzLn84yajGclou7sRR77/TBo+57Xdl+kTTPJmTrsFQ?=
 =?us-ascii?Q?Di8RzL3CZbGpaSnuoVK99VO/HgVRfwbH+xJHvpiWBYpokeKusqKDsMHzGltk?=
 =?us-ascii?Q?hpmHcxeEyK4iFNCLlfIt4Hg0nWvpJHrC1xPhTDtgAU8c+WlYHAiCV408YH09?=
 =?us-ascii?Q?rdQvcNyj4X5ZiSrfPA31ALr0+WbZvt7s9mvdT/d6IwdR36QmpgmBuhAopxTD?=
 =?us-ascii?Q?ELzDnB5eTRYSjoM+FJrUWt9phSfJuZRIHNom2DsOJJ+v9Z5J5K2dIYcfDl5P?=
 =?us-ascii?Q?FqfKqUYxs/Y9D/JUCyHuojKo6s4Vk7T7sMe4Tr3lO4PR8geZxyxmLFdNSrae?=
 =?us-ascii?Q?WL60OLzvYqGp23RDbRCZ2oFygXBTBmqUvX2dyqaM3fZbarrb5Q9/wvN0OLHc?=
 =?us-ascii?Q?gUxVnpJKVP2SFg3mwozetONXV+CTs7fQ5K0Sdc6M9E3KGR1eCx0Hb8yDxHKA?=
 =?us-ascii?Q?J4mPEPSsSQ6OPrenoSFvtYvvjGIB8+SkVecvTmXDYVFojwFUsthvt/rFFQ6c?=
 =?us-ascii?Q?wEofr2RgURGddHGzz8ZRI1zRqU82/mk1ikS5cObFUCQBlJvGe6I8fmBa+C8B?=
 =?us-ascii?Q?VblB2zAg0+aMwp/mkFJCeZ4MqIEKOnqb8zyybfEllR737oNwBo6CNWInUCRp?=
 =?us-ascii?Q?YSa8HYefaBn7seaQdAcyg0BNTKvs1f6jzcMuoKXx3EZQiWWaEI8I5puwMF4o?=
 =?us-ascii?Q?5P0F52CMbliDdf5fI//dv+ax606O2y6FLnyqAQmBg5lSb2Ps/oJSQKXtTMR5?=
 =?us-ascii?Q?BqPSie7Vru6TTSXJtcCCcId0bhSy9CIJRuU34V4Ooz8icYhEmhhl1mPCWe7e?=
 =?us-ascii?Q?RLEIMqKgWRbgqbAeH/VmOAbyx5B/qEZbQBHQrSzdbxqM7G4MJIDyLpETeYAJ?=
 =?us-ascii?Q?0F6zcb4UPc1wh5FoF64/dgGu/t7JIB4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db53dca4-9163-4c4d-7ac2-08da32f61317
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 02:29:29.2338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4Lzm58uNv1iTGfROBDQQ9m7MphcjJ4l5F9YA6y06IxRrbAtogtJKnqMResC21khcCObOXuHCgWGuoz2JkoxFZYVfOz1aWroiLdLymN3U5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4569
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=675 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110010
X-Proofpoint-GUID: ZIb9lCtyhuD4M3VOh3zURHgtzHKPf2M7
X-Proofpoint-ORIG-GUID: ZIb9lCtyhuD4M3VOh3zURHgtzHKPf2M7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> If any drive is missing during the reset, the driver checks whether
> the device is exposed to the OS and if it is, then only it removes the
> device from the OS and its own internal list. For hidden devices even
> if they are found as missing during reset the driver is not removing
> them from its internal list. Modified driver to remove hidden devices
> from the driver's target device list if they are missing during soft
> reset.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
