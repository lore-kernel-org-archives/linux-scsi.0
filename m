Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F45C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E84761A01
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhCYCYM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:24:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55356 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbhCYCYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 22:24:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2FDNE062645;
        Thu, 25 Mar 2021 02:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WOEByOZR1AjAXrxgkC5KrlAqPOGU+pcAHQ8oAFt0Dbo=;
 b=IFzv0cRs1EJGethskUy1NL20V9yv455Sn/icWYNBkZ2tCeEzSu23IZ/txiZuA217HmBB
 n6h3btb6NPpEx5Dg6uaoJ5fleO/QNgNfYMckPeQTwq1j6znTRzvibAZtHnac6ap9yJv3
 pIb1gGwMH1IEko/X2NeaYTJEHBahw46L9jCVY9DCGVkyl4d7g5EMy48QHV1WcnUWA1Ns
 zQBmiz/o7rk9g7BXFfjpBI2Nd8vZEF+5GwH4/V5osDRmi98cyy5X3y27dsEWsK+evinV
 RRPXTLROASKuF78IVhPgz/6JSJAlYdlCgtUjaqVt3dPxEBQpaOhN3u04YeoZna8Dqi4o lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37d6jbmw83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:23:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2KSPg149083;
        Thu, 25 Mar 2021 02:23:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 37dty1b283-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:23:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeoCFswztO2P5+KKD4I1RZu1slyajmIO/atihxgpswxvXivFWkLQTJXA2zj2HwYEJtTTBVsaAmyS8cBgV1bSnRGYJ+tIBgdNT3+kc9u/o3UE5BXwtUt/j/q1zTflj5uLe4to5cVnd9RyiJtJzyMy8zTU5c0MhSsqfzpfwU+0MA/LcNC2/4MY71frp/fMVI3f52qI9tF78GHC+bD6qTwm4jPjf/UqiydQtPaoopNSBl09IfIxpLjCXdxQQMp5i3D98ElyJP5bXAzGrEvPtL2VnEm4bjVdD0/L/uGCpJXawZJLIDeS6jRGQB/93EvDHPD8SHpRTQzQV7ntcIL/tgitOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOEByOZR1AjAXrxgkC5KrlAqPOGU+pcAHQ8oAFt0Dbo=;
 b=h44v+43P91/glTd+1Pz1FSqptAib8s7CKyIvZDn7ANHcB0n/cco7W4QvM5XxRjsufZY+W/hgewpkhajB9XC2p0PFCBm4rD9fcd86vSGpwFIZbtADYxTzRXp19Vp7S7yiJkx7gSzsby8C04lapD8l+0UkhF86lsWzA2T8pwSKTIucVMVIA6u8Vaw9i6yBzSrZqhHuGunuWEgugInLeqdZxZ0wV+2M54oOgXv50iGd2M9BGx4Y5/1p+3SF5yzrK2KA1z0WiWEjB4Oq7UqhO9rgupbUYsVnWb6BPAQMEPgRT3X1sdpB85zTOfdoShd4Ssc1AfnH3lmGGBnSBzTVnelcqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOEByOZR1AjAXrxgkC5KrlAqPOGU+pcAHQ8oAFt0Dbo=;
 b=tQXa6mPjP8Hu6NGtlYQY3PsGvP7+4Zni0R8VgCmeiUVTOR3cFPE4M7L8jMXNc6fg9WsUkZn9Jakm1g40XAvziIBKKKQz99Zmzb+6WD1Fj8rYa/lvleXhHGsxxULmeDCK2CVkH5fu6IfIPq1S57OT3CNiTYrvCk9bK9RvBUwdgA8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 02:23:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 02:23:41 +0000
To:     Yue Hu <zbestahu@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        asutoshd@codeaurora.org, kwmad.kim@samsung.com, beanhuo@micron.com,
        linux-scsi@vger.kernel.org, huyue2@yulong.com, zbestahu@163.com,
        zhangwen@yulong.com
Subject: Re: [PATCH] scsi: ufs: Correct status type in
 ufshcd_vops_pwr_change_notify()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfackm3f.fsf@ca-mkp.ca.oracle.com>
References: <20210311040210.1315-1-zbestahu@gmail.com>
Date:   Wed, 24 Mar 2021 22:23:38 -0400
In-Reply-To: <20210311040210.1315-1-zbestahu@gmail.com> (Yue Hu's message of
        "Thu, 11 Mar 2021 12:02:10 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::47) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR05CA0034.namprd05.prod.outlook.com (2603:10b6:a03:c0::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Thu, 25 Mar 2021 02:23:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55262ee4-f5f0-412b-c26a-08d8ef3501d3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4759C88AB263DF7C3E68B17D8E629@PH0PR10MB4759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zF0LuQ8fYKjQr6FjXGcu3+TYvo8PpyvKZmz6r7eXuvj76/2/IkClU0xxapuGUFgzFOhMNIF2QtQ7zrEY/xxFRSIFpbbvUsUgUnh8fynEJnarbMt7MsqF8lODAbvh1+7bcsJgSmydbkTzyrsEpuIeRGZMMmEWqO5rAG3ml9NOjyhOlMUDfF/yvklNHVlOu1Ig+NoP9an5KFf5wKmqIvc8ksk7TYVPXFqzQ8iucXY+sVDSjFjrhAzWCQsDYQhbD36Zo26E6kbNevU3JEdsxtoYROROGDEmnp/xkL4M3Z/LrCYLrwgKgCe4mt9mrWSoKPyCSV1lLYd8ViUcj8LKUgyjGgV2TtBKgns6MqHXe/MRPOvfaQFrUjxv2gNX/hqI5sGyDq59l+ErXLrVGRW8ZdfmDUwE00KFIN2dtZbSckRJpx5pwLjjlRjf97QEEbA9Yqb1ujFTAJYNXgRxRKgFABWRKPuyVnieCeZeopw/XFrslqmRhylE6UznUghXYAbFB1eRKaXdE6KvA9EIFd9iBhPU6NQ/qrZbsRYBp8vPm4gRbS657ae2HtxaBAuaXSzLIQa8fr154q2GE6ONaOeZbX0KlJd7JG5E8qaFmYmu1W4PkwilqD7d5yyqYVpw8fWQjy/y4KV2aYMndSE37dQpI8i4LdQua+0jqCue/u/oIwub5qo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39860400002)(52116002)(478600001)(558084003)(186003)(16526019)(316002)(7696005)(38100700001)(36916002)(26005)(86362001)(66556008)(6916009)(8936002)(8676002)(5660300002)(7416002)(2906002)(66946007)(4326008)(956004)(6666004)(66476007)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PAqO9ERq3eeHciVdwbcDHOw2LF2/KsazzO5NqcoaC2LgJpP8DdPWcS2fSsaG?=
 =?us-ascii?Q?1elrSKJPylURi7Oifqqec5cFQB7TSkGNX3BXXGyeUsUFD6ck9RSSUToYU0vX?=
 =?us-ascii?Q?RsOrGRyhlu4asAnPfHHjYfzldokxnC+eyESF+d2YS1xGWUIL5WhpVUhrIBWt?=
 =?us-ascii?Q?GyGDHh/r7WsCLJOGyVwzEgWNQ9hO7t9R6/YC/WIV6QFeSQaJLKY/jP0PlikI?=
 =?us-ascii?Q?pi00Fmd4DfnsSThy25CLpA2egy09eo0SkdmyIx5uWHNou3/AO11mK2nIwmBH?=
 =?us-ascii?Q?OJ8G/VfC4BRAKv9YkGauzlStDtKxgPGu+Dq3U/A81GMmIqM6W6o/uTkcZ2iU?=
 =?us-ascii?Q?fTNwag7NAB0Wu/qSxonNK6pblD5Vead9klnuJL86USnjLp2aBMc3eO637uBk?=
 =?us-ascii?Q?Su0386MninaQOQZqTPR5KxYBm7P2VerLqEEl521MDVHhhyAmqfw1EMiBmznr?=
 =?us-ascii?Q?J3QTrEXxA3IQ8VE2IlEPX7s0xXxyeq4EIcHj3Y4ekIGVF1WTY0IfNL5w9U7y?=
 =?us-ascii?Q?Y8luKbkRGxo7BPmPgIKGnxDRn/89/c0VjlIjfws8rWhX/HwFVl8MLL/O6hID?=
 =?us-ascii?Q?auZRL3eFHoMnIwSqd+30Mxu3UcbISKSgIfJxgaS6RfPTxK7h6WNabLpyS7LM?=
 =?us-ascii?Q?IqHDPMPVNh25zmc0t7DWbpV5fLPB8gAaJblx+BhDroZgUZoligcUGfkkrpRG?=
 =?us-ascii?Q?9PxLVZwMm366S/y4YXdGmudI5VDPEeOs7NlmcSpM8yxE+6poe6uwd1kOOeZW?=
 =?us-ascii?Q?Y2jwpzPk4/3p3nt6W13Y5QPIKGF8LLM51NA2TKBvzilk10/SDwEBDM59pekM?=
 =?us-ascii?Q?CtrrrPSNmDZZflsjBVTK/e0KzNkgYvyT+jC8s1ap4tk/RLdlRw7NXr8PoyJJ?=
 =?us-ascii?Q?CSKN/2zzJxkXO+R3fCdvWqKzfVZ3/kF9ZVR9QlvLXDZMPPtBGu9UpKC2mido?=
 =?us-ascii?Q?iH2AxetS//TvdprZ8dDtCMgCsyXUUD5ECV3NLTbduXsfDvfgowPO1CikmNpF?=
 =?us-ascii?Q?waeaXZ7bAWBXdO0ZVvYc2le2oHeQDqNSvZxS+f4uBon8lewcNMlFgeD1/Fux?=
 =?us-ascii?Q?4KXQYTEql/JRtm514xytACBdpUHdyfCCrHHi5oDRvYy8Srks3pkS+Fr+pkx7?=
 =?us-ascii?Q?QZZf7Tzr0AUXLhX6xGgfG1sJvR35MdaXKNkOtNvdIkJbnsyDfZeAMlYzxvPR?=
 =?us-ascii?Q?bQmbW+QnffjsBJFkw3cIfK3a/ITKJy+5c+z5YZqlsoJ2gNIKm8rLyWKP9V6S?=
 =?us-ascii?Q?f9SUbU5eigu84jFXuhSmihemllnOyt2h6aPBuQQZyhHpe9VHD5qSn1HV4a5Y?=
 =?us-ascii?Q?zHbdKx2L7kH9Kd7WfqDlTwOH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55262ee4-f5f0-412b-c26a-08d8ef3501d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 02:23:41.6691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZakh1Z2h9RHa+q0RAIIuJuCyuxj8aJsNwLmGboXzKF1B3UrVPbwv27+UsEbGyqqLkOJV586fyYIDLeJKqHH40Y6ifUI2xsUEReiymXrdEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4759
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yue,

> The status paramster's type should be enum ufs_notify_change_status.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
