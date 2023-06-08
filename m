Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB347C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjFHBFw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjFHBFv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:05:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6F12115
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:05:50 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357MqDG3019371;
        Thu, 8 Jun 2023 01:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=JU51/cURsYmBG5AU/n5yt6AXuQp+z4UUhSxd+ONxYU8=;
 b=0+zADCPvfy1hAF7UJKSEFTeM9G0szslOCInfpVM1gzxke9Ea+h2p3QHZ3EKft46S+znG
 uz9d5+widZ3QO0p+7h2Z0uug27vkQ4HGMzTWwtq0pd1T6Dpf8aPlL1tjVqk1oZJWSqH2
 ksyTe477IZgxefXk+c9igPGTcsbS6fKkF7lDpWuo9sagfrVpH8WIBF0/+DscmugOlqMe
 CAJz2TNqhPqTPo6OS8UFp5VznR6/MKNg5VTFtR68fB+CYf9SdlmSc9+MO/VTOoGM3+Oi
 froP23c+siIxG8BsuuV6nFW9TS3afoA130BandtznYyVB4QYrCdmlKf3RchvTM76StHe 1w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6sk61g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:05:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3580Vpvr037094;
        Thu, 8 Jun 2023 01:05:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hy394-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:05:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STjPSmh3DnxpO/+xbWHUy070R4NcOKP30m9WDSF/9jPq8NWVvOMZVX0QakocUlU/W2yYb6WpZ3cRzb3NUqch34GZ5sfpf2k/RA1RZXFsFdro5Gyl26+vdPGvDtG11fEWMImA/cRyg+8KwAWrZGcaZuT/E1GWOVrViL71HfYKxRq3Ae+W42TNOrRAEMbNvX7DUouH1TWuTholQymB+u9ENGcAQqClyUh5HrtOHYvCRS8JUI5NZYh8NRZn7WcUgBcU0IST4Opminm53V3xN+nfxADwxADSdjGLw6zXs+XxrL7CZzPSwWC/im5ASggwDGrksdqkmRZpnSOuHt9fa3ThNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JU51/cURsYmBG5AU/n5yt6AXuQp+z4UUhSxd+ONxYU8=;
 b=nYW7UxmvhXmFBBCqPQoDftY0KRIIzYqEnJq6eiaRv+CzxDuV2keMFwFEDkecC4Ds0thBJVD3O4dgOVi9a0ypq3b++o7sfG6iZzfam3yuahQyMwDQTdkybLFgXKw3XjAX7BjH190tDUEpNIdy6FkvmQWlI3aKyzZT9aDLB+hUM54CaJfMroWXmJT2qQN0HP2ASKtxbSu04me5SintLriFlLAKv/A4JokHmxjrHUoYjT5QLupTVmqlP931G3KV1QUJjinlnBkpMm18FupECZF8FZElFicd/P5cjq+qKUhNHSa7+2But7vJdV6oX1IcH8yeQUHyTomr+WJErdHz65P+qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JU51/cURsYmBG5AU/n5yt6AXuQp+z4UUhSxd+ONxYU8=;
 b=EVvO1uV6hO7/3cxySgPStxfsym6ZOMoEfeeMFsbEyKF2I6QrKjGVXGHqgtt+spcqc8UCCVJXL2epxEJ1EKKMRcpeOClBESVSKGihJaiYKf58bIpJa37LI6fiDyooHyiK2qgOhV+EdWoX/iGVPiGmPmnT/sFKjJoDwAJ/Iv/byp0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 01:05:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 01:05:33 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: Re: [PATCH] scsi: ufs: Remove a ufshcd_add_command_trace() call
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qim69wu.fsf@ca-mkp.ca.oracle.com>
References: <20230531224050.25554-1-bvanassche@acm.org>
Date:   Wed, 07 Jun 2023 21:05:27 -0400
In-Reply-To: <20230531224050.25554-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 31 May 2023 15:40:47 -0700")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0201.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ee96162-eb54-43e6-3dda-08db67bc75e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wqbw4BjJzqtU/2Swe2ILTMS1iKADnS7ReQdqim/OgIWk6eLh/OYh+t0ax4gRJ6jHjCDTxzHz37I+IBXsPwRUHVvFVzIIU8a7MYctS3K+9DsmYikYLBbWb0d6DhMIGH8nLd734gAHAOrZZ25LjXvTireUg6THCy8XAYe7+Q8ezUAdd0NZrzQThs9swuUgSdjKbwfWkElOV5f0tGCPhkXZEtkmTT5htHJoS9f9GM0YndHq9wTaEYtB4cvnUToh34d9norcqwUz7zYm625gDvJcO0mvzlSVRXYfZdwBHZfOJD34hvCGPxkkBNvRPzRZDadvHRg0RSJIZUkCIBOgn4dsqD4I/N3SuN11+jRFxz+O7jZoXJ6U0dFF6jciSsZ5Kd+P0nE/jwNr/9t1+KlBRLleD2Rcw0aN8mLfQPgUEw0AIMNs7cZMBovu3DvwgiWaVbKlssQ6AEcCy9y7YymHefpMnAAbz/2ySEXzDW2eDuXKQtzmt82nTaI/pPrnttM4/uKOfHsVz5jVFdkwGruhQF//SkbT+xs1Xp1P2GYaa1YrHY9PfCnYmXf86G8+ivUhKdmO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199021)(66476007)(6916009)(54906003)(66556008)(66946007)(38100700002)(4326008)(6666004)(478600001)(36916002)(6486002)(2906002)(6506007)(26005)(6512007)(316002)(41300700001)(7416002)(558084003)(186003)(5660300002)(8676002)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?McwSQRImCyNpcci3XPO5vi/Ss/Dg9WdfYsJAc8bG5qwY8nQotNp++0L4c46e?=
 =?us-ascii?Q?zi9IU7M+oRcQ2yqlRjLO6GmePa5WJjexKEq6cr2YffY/OmsufU4nd/v8jsB3?=
 =?us-ascii?Q?7agNhyA7eOhpKynUM/wuRQZfAvpSb9BU+dPKi0tInUpexosDXhuWLVE/licG?=
 =?us-ascii?Q?oiFUYSqEOpsazfBtNRxi2ZNmj4HstZ6GBTF8QtUl1LMGbiufthICUzsQYI06?=
 =?us-ascii?Q?YtdYb9BoWVVZtskUNm1nKCyIRo0BwQ13oBQ+zJOPobkN6OGLnMysilKf2ODv?=
 =?us-ascii?Q?F8PUr7lryu0yC4uuc4hrTvmDt/4vW6iBMH66s2LQ2wAhMRXi9WvOiGwssrHD?=
 =?us-ascii?Q?I3zq0HC8i1K/ZtVWcZPIZ6ABX3ecElbg5K02V2IAzdFvHGUzASNN0RcmQfp1?=
 =?us-ascii?Q?N9tGuCPYwT/kB9VeGOc2m1R7XTQ0s7KHSM443xYkRfoXxrcFbqsYTqu0dd7c?=
 =?us-ascii?Q?4URPbJ4dM5GYrMn00OqAYJrTvlGAM06L9rZKJ8oxnKlqjvv2MpEuonBUYbYL?=
 =?us-ascii?Q?NmT8gCiYjTtn5PW0hQIjhjPVeeRft53rEYS/0GEZSRaz/0R8nwm/R9WWfxR5?=
 =?us-ascii?Q?cQ5P8UBvAUobN6SpfKPs/8jeRRnNkZ7zHf0xdnLMOZPgXEu4pUkHBQh3L2qB?=
 =?us-ascii?Q?s9srpmcoCgOPg+RFPsipKY/V3i1vceeM2QiWF5tX9ATLpBXgLa0e47do0Sme?=
 =?us-ascii?Q?FFsBPC++jzqzjeBZlLy4Dastna/et6i7g6ttOyikWxI/17jicDUDcTbZ4sRj?=
 =?us-ascii?Q?LGVRczJwonyUVrmqRlfDpKz96xCVONJIL/jF/JEjFRfSgirKXbLoUnoW+LtE?=
 =?us-ascii?Q?wOeVNK4S3mkdT7eSDU9LiVwHYyTc4Dc+bSviEY1Bk0cYFTEGNqzFJmGTbx+1?=
 =?us-ascii?Q?SaGLjonOo0BM/j9Zm9yhNMkLR6aUuBjJOOF1riYJsbkoL5VnAASY565D3TeC?=
 =?us-ascii?Q?VunhMlosWZ9FoiIQKT5jWor/QRBS+Nzfc1zJZGOcY8lxhflSBcnOiuxXzYdr?=
 =?us-ascii?Q?QHgJpC4LW2qeQ2V1u2yASv0zovc/opqNNpCfoWhOhHe+uPXd9cxy5L/zLF8X?=
 =?us-ascii?Q?QgfpYM/nt9CuiORb6BHRA9fTG0B/uvfljLfDgR9op0alUH45iWJVGrOzYmZv?=
 =?us-ascii?Q?Q5e95g94uvIKChrZep/cK/0Fatp+7n78/KsKOOdW+lbiKNycbNC+CDjspXHs?=
 =?us-ascii?Q?D6I2ryg8U+i6+1S3yC3ogKBfyp6P8dsuEBwbk0juIn/28PspSXTpJD9L7Chb?=
 =?us-ascii?Q?a4fnxm3+pvbeEAXYBFfi2r8vQJvpKaHdZ4MhKiMtmpg2hemkJBffGbBtoWNT?=
 =?us-ascii?Q?5XPzNHFPE2Wy0Az+DQp2+wU8BMdVte0XGm/grfke6q2aVyBdjYgbLjIxms1e?=
 =?us-ascii?Q?Gs94b4jSA3lOo+RR9jkPiqiRYPQ2Fbl278qFXmBuxDou/y9h21K5PA8sAcfX?=
 =?us-ascii?Q?YPHBMNKQaqJ6TyPPYMeY35FWmyZ4dOK+nEUleONSx+2Tf55Q0QewSMpLhWQM?=
 =?us-ascii?Q?wP2IfHW4JJgtTw0ZKNEZoueKS5fKa9pVoAiLdJvgk9kd1ImNelrG10PDATBV?=
 =?us-ascii?Q?kWXU/fbWbPPgFkhNfGUZnO4Ei4Llf2kmKQG8lkJM2Kz4MGM7TNtC4qDzubE8?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?t5qrd2qBki6hhgko2IW89Q4R7kn1Wxi4iSPnTBy2tkkhMwR8aE+EEjlF9fjC?=
 =?us-ascii?Q?v3UYzRcMd85T7Ep2ZsyzeRVMPFu5EmodVs6YBy+ol8VpqhcjfNB+dfiGb/dt?=
 =?us-ascii?Q?kMxHF2LLKVaLDO8Yuc429DWPSJSYPuiMuyNBwMGrH99reIGM46d/P0QN3qzz?=
 =?us-ascii?Q?+T4jX4hF+Qe0LwL0fzHw6lrIYEoxhsV0xsmv/SbM3cmZuLD8oV8wRTrTmCno?=
 =?us-ascii?Q?vifPcFIXz3S+TTLkZ+pzGpZvqW4IR6AtnSWTQW7dpeUeX4Sd6tDGUfBYTN3l?=
 =?us-ascii?Q?GuYFHBSCWGiUcMp0bJB3HYP+QZeExAh8AjtWqDWp2U4QPifTHSW8p2R89BZR?=
 =?us-ascii?Q?i2eftTSDz9f+5wcHB+5IRSazMXaNVGCCGAbRHIgKvit+wrqBeaGtbRcEnOgN?=
 =?us-ascii?Q?WrbuLfS6hRp+p94YQwA+oxn6BMN2YItbK78/ybN+2eTpvBUL+xAGzgXZF03w?=
 =?us-ascii?Q?rX4EB+wI/CFcDCcWqZaR+Gw7+hPJBZlroALw+h0+9vL2e/3lR7AIJ7f4Cyop?=
 =?us-ascii?Q?QnD9WQW2VJo4oNwnQMwiOk265RtyFq7Anih5qSoeNt6OdwPytDcgUcPivWJJ?=
 =?us-ascii?Q?E53f0yNAnv3chqyfX7ZX9IjvAAgqXb1wCk5rPtbteMpJ2vUqTKuNUGLhdo5j?=
 =?us-ascii?Q?p3k/mreNlOPSlJIahfyvoZIlzxIv3HOAbIAzmrtaeYfQFPcNdRIeXk9gQRAR?=
 =?us-ascii?Q?L5J98yGP866CACa510/Ld7E0xQZmvacSxKfJ588kRkYdVnlyH2FEvaVq9+U7?=
 =?us-ascii?Q?5w5acv131LO/4uf9wlnXFDv66LoUkBzon+hAQ6AMQrM88Q0LVq+b6C4V7vA/?=
 =?us-ascii?Q?vPYNYqNfIGxLoREMD/vNbY/KetFYpjt3yNqQOD46wB/5Qf4fXNMUU0gnKpTY?=
 =?us-ascii?Q?bKHD/6e1XN8aBdN2PcCIKQHAHJYvkpybfjHv7eyP7uXrSV4RkSjwSqn8W4af?=
 =?us-ascii?Q?/DBM8P9klg4rwP8mCKnKK1XsnNga4jhVl7pZvSMjWeu7KQxKoO38mTiaMyVE?=
 =?us-ascii?Q?JL2vW+Wkpw73z1d6iDdOUv6irg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee96162-eb54-43e6-3dda-08db67bc75e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 01:05:33.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0Hpo8cdYekrNeTjzzi3JCXk9knlkErT/2Rs6qjdBbE7P0Lj1l7F+rz27GTUumARRH88Hq84kctkd4eYCg9FIwOQVDe+pEWQ7o+MFs158Ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=988 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080006
X-Proofpoint-GUID: gz1-kr3nOOImR7KhWeWXC3BlqGkgk0O7
X-Proofpoint-ORIG-GUID: gz1-kr3nOOImR7KhWeWXC3BlqGkgk0O7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> ufshcd_add_command_trace() traces SCSI commands. Remove a
> ufshcd_add_command_trace() call from a code path that is not related to
> SCSI commands.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
