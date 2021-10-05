Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAADC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 02:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6DA86138B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 02:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJECSH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 22:18:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20656 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhJECSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 22:18:03 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1951Fsvc010243;
        Tue, 5 Oct 2021 02:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/PWGT/KO10xxoXQk+plm/AbKhFrmQAdcgHfN28C9TAs=;
 b=ZBosHfbNLt4mHIBw9yvoy1ES3xVgmtZ/K+VS++eJgpKQMTsUEs7Y+ZqL8yOjh5KuACIX
 uN9RFpDMfzZZtBSZfmigFzY1Wg2yVwy7uUQBhOwZzVIAAp24mjHnbwpvYAqCh09vUS+/
 8cN5EFNgqhOvSF1Ljis4xE6/R0Kcs+n6VJzFbiKoIzoGbCD8UKkThn5oSlJ94WBskX2l
 NqBzoh3iUDR2dNRQXSNOV5TN52OH9skTtJD+XGTIPHeHTUsk77Ci4dT80jsV4MqyL6AP
 BWvZPkxkk2jAorv2I5/2bnx0W7nsQrUn0mBdjWb0q4DrkbglGTtADnZdLJ6QpNor2M51 Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3upv9c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 02:16:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19520dAI068190;
        Tue, 5 Oct 2021 02:16:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3020.oracle.com with ESMTP id 3bf16san9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 02:16:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYKBgSF57nZXqefMq3azJhmOOrEaVN2vhz/eNN5CVvpaXOODdIka5WlSBehyj32qOVUcKg/Rykwse6BhYEsWDe4oEqOSZCWNozqEc//+1t0VI5t4VS+v/FgY634JxUebKgHZffe0oLMMGQ8kDqgWZNL3EktaJK7KnC9+uYAA7rttpu6QB1lX1FKTFmAmnw8LUDtl8CqMa3ST5QQ3lDQkynO0G02k0Qu1KuKzR2Q3i4YLiSJpaCoXfByCfIvJe3wN3WTvqNI4oNOmKxGHK0H0NU1cu0U8kMSfB0kNFlZyrZ7ueY/xz0dlVFdMaZ+nxL6c/k7/JfjDKxBsWt1+G/mO0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PWGT/KO10xxoXQk+plm/AbKhFrmQAdcgHfN28C9TAs=;
 b=mjcJ4a0Wd4tculXy6k/ue88TteLVsCiM89NFbZGV7EDNWsXbxJ8iv7H/zBNJUvac38+dXzGTZE/9axZjsoRaBe/qk8eUFb9ZOXjWvaKlu0kluSp2fELfHoqqbG8XcP5dMlqcyej8+pgCmttstI9oW9qpBsbpLeswN59WFrq96OELJikSoP5nB22qVRlyGwVAU6V6sA4r4mIJGFCdQ9OWQuuGMP90FbEdjjrP48eJlN9Q4EI9goT8jNGM5CZcPj2b7c+mlKh1pL5Sg3qjAd/1UoqoNUsO3orhq+9VQOq5sOVNzARH2FzTyANjh439U4Yu75XBA3hRaKvbEGFivRbsGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PWGT/KO10xxoXQk+plm/AbKhFrmQAdcgHfN28C9TAs=;
 b=zFzcOhitdl+iscxvfZ7WU4AvtXmQtEZ+10UYQF6t3VJDn2pa01E9svSGbqwPGmCqG0uIt9ljZCwgt73a5v59vvBA60lZ/i7TxK6fqQIaEOWu1Uyvu1DiMJ0E4ImbsOBwXAZYMf5sp7pdL/rtvaXOW6teyckcFFC0CYOtuFEnx8M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 02:15:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 02:15:59 +0000
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH 0/2 v2] kill clearing UA in UFS driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf388be5.fsf@ca-mkp.ca.oracle.com>
References: <20211001182015.1347587-1-jaegeuk@kernel.org>
Date:   Mon, 04 Oct 2021 22:15:57 -0400
In-Reply-To: <20211001182015.1347587-1-jaegeuk@kernel.org> (Jaegeuk Kim's
        message of "Fri, 1 Oct 2021 11:20:13 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by BYAPR06CA0022.namprd06.prod.outlook.com (2603:10b6:a03:d4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 02:15:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 562b362d-0930-49a1-7967-08d987a612a3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4647C781E0EA78EE78C6B51D8EAF9@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +IT60vRdK+bJF5QDXlmbbY0GWou2YTinfqRCuPp8LXSPhktTGamiGo7uOKraxZ/Mbg6JcwwGslyEoo0b9ZVqe3rEzv+x/ZIC6ASvvGmSmeHojfVLr9ULPHiG57n0p03a/maPFxeKryfmdl8TpJG0WsSSciqW2OFVg5Ufsgr1RZ+IU+yiiApstkvJoO5z4qm+3cRiJ5VAIN8FMen9v8AxcT0tXfvjoiYIfZsabeyX5jT1KBe1ZGmea83p8vPm97Ga52IRsC6fW5UtCiECVNJ69MdBSCVS7HUWk9ndp93/ilcX084bCXLSdr/JN1lg9JoEz/u9rdpa7c+mX6yPKI3tYeOOj9MifufA9MToNsYeZLP0J6jdNminLUg/6XlElus7nz7yEbEl0U57LWj61allsrVgL8qGjM7oBKXRXBwSDP5LBGx9yKtXO5vlwLdygbq0wtuqz/zszUblFH61x+NW/5Ry9mIkn/DP23/uugm7Ggl23q6OES6c9eAA/99G+PI5kVbAmp3DKLuE4ZDSj1kLsTt/S3pQeqOmOsYqpW8UmR6UQd2puKO/z+qbN56JTAeqrzm52yUEz3qUwd6gNMa8sww2RbNU7NLLkrPOy0zBqY1s9UCyQ5+LX67VvIPNwcMi0xvBfkTLuWNFiyK28+SX2Y+RqIdy/klndwVBtSvX2GlgmFv8Tj23KyMBbhZMLe1uzWfPD/BGGFqQe2I7WnrtDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(2906002)(54906003)(52116002)(36916002)(7696005)(55016002)(26005)(8676002)(38350700002)(38100700002)(186003)(558084003)(508600001)(66476007)(66556008)(956004)(7416002)(86362001)(8936002)(6916009)(66946007)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RMpjamhxjcuC44DRuwD05Ho96RnBsWzR5RyATU3d7GA3ITMZ4LnxcZgY8gw/?=
 =?us-ascii?Q?VrOYYlcAGTu6Rqz1+Nki+m9KoGLI0HBwa0ROKsSpUOQW8sUnqC049uhpDW5t?=
 =?us-ascii?Q?ZVEvU6S0hRyvYXv+TrzxP0rcN0pk0Wz7+iHW17+N+x2g2Z0ZMqV8qGs3HunO?=
 =?us-ascii?Q?pGrzO1ieE8ABBMJJxp7Dp1hovxl8HN4ugqQyXtcDvseoTxnxX4CUKRNDMMG7?=
 =?us-ascii?Q?+e/rxMxnQlkdb5j3+sT0bKfLwTtHrulsNDicKbOHYMhcfOSze6S6BsjJ0IXp?=
 =?us-ascii?Q?BDWnN5cPYyQ1FF9qnSruyQXi3TFqPsCzwNoV8KoUQirTgCH4CUBWWvdfPdKz?=
 =?us-ascii?Q?hNK19pdqcTBhjJ3lC9epcqJ1NdTXD2EEnBrLJv3o8YUBukCr5knK/u+3g2NT?=
 =?us-ascii?Q?t6SSgc6rS9rj+kHk7KZ4Xp35Z/s2t+qm0zVsFb//jTwZpYfkzUQuI26nTp+z?=
 =?us-ascii?Q?MncLJZjjHRF2u2d1KIsZhljpMPjvLFXw3SHy4qWbEfqXbtThUQ2ozG6IHlml?=
 =?us-ascii?Q?E0EDq/c82Tc8KxxjHtsdZnIrdetNpO4WRHdya0sbHN1U8BbwsmDxCbUpATVZ?=
 =?us-ascii?Q?bex58HHMUvoabzudPCsk7Fm2bZ2wY7W5jEqIKHHS7B9x0zSu3sh2MAlN7imf?=
 =?us-ascii?Q?ywI5kygAKVHGdTkRoIluJ6ZI3mY8uz1IYKhG3bOLo27PmKw/AYuo79xfcvhK?=
 =?us-ascii?Q?3OY2ukXv3UrTMEePeahsojazt4ZZCLHrVt40cTunwA3nhpUK8S72dm/BdWZ6?=
 =?us-ascii?Q?qgeS9nsBpT+Q4WnZaBkgRjp9g31PlWMfae23RzuzoZew9rGAf9QOtVL6LPFN?=
 =?us-ascii?Q?3xLAZg4FzMvnB9B+H343qsmp9ORS2035/WhboLGer+XR3l/obrnTgout8YX8?=
 =?us-ascii?Q?3iuuWtQ0PAvmkVyxop4BMt6nXFI7z/kA2aYtCQz0e2GX3u8u0R4qPWYv/Mk7?=
 =?us-ascii?Q?wxBvWDmu9FZE84llPD7P3gb1Gev1Zs7vxZqon7w8Qf0L+m5yzRVIlHtYDR5V?=
 =?us-ascii?Q?pw9FoyP9Li1PHMRZ5qZbsoYHUz0qqaO0j4VagNP7s+Im5+F+KKbgkQuQKjgk?=
 =?us-ascii?Q?zH80IVVELNbsc0qXNW3LlzTz2u8wpwNT+kVM16fs6hYRd01rIs1sH9vHvk4b?=
 =?us-ascii?Q?Q+thLI8K8nD4trp9Tv1GwkLGRHutm9N2OjRP6kbSP05XFjBTQui9CHbMsOdR?=
 =?us-ascii?Q?qHaTAWEtpgUS0E/Klh4LRegwFL5JgiO1h+XL0X9bbGu1u7lS5VNPxopeFgW1?=
 =?us-ascii?Q?MYB5WQUSK/cTNaarH+eYuJWQRDIEu/NaBfdsCvWUljBEOO/Ygn9y7FTPnRG/?=
 =?us-ascii?Q?NvSsD5KeuO6YfFV4yIhEvlT8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562b362d-0930-49a1-7967-08d987a612a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 02:15:59.7735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lBWASX0qplFI0RAlite39WYeAq0I8CmH6RIjIdSSuLeb3CcFiH3D8+QFGQtTpbmSXGNnIr/97kpMwCpQLpeMP4fGEldddUy2MSu8CJ8WNsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=839 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050011
X-Proofpoint-ORIG-GUID: tHPRsSi6hHB47E1mPxWmV1GBO4lJzrVi
X-Proofpoint-GUID: tHPRsSi6hHB47E1mPxWmV1GBO4lJzrVi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jaegeuk,

> There are some issues reported and fixed when clearing UA on reset/PM
> flows.  Let's avoid any potential bugs entirely by letting user clear
> UA.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
