Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B066C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD6723403
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbhAHDdG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 22:33:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbhAHDdF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 22:33:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083TKJk009678;
        Fri, 8 Jan 2021 03:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ycv+L+blUPQmCBMJQROV9DwJ+8aVZxm4tOxyk3RvcGs=;
 b=DYkzHp1UO3G5NTIyn869knNgKvA3lGgd666st0YCZQWhPSTLsNJnIF4bRbeRkFLjEPNv
 agGHZ4HSzXLPE57wJGaqQinR/O1g5RKIy17ZvUny8G8IknFROF9f0IyQo6oyObFkFtiL
 ly+61jSi168A5FXi415AxZXBiwMcgyl/QI1RBsvHxEoRmieMlVpkHq7B606ZfsWGzfm7
 t9LfIm9O7Dllaao2gdrXIr92t6NWDusmOxpC3u2RGzlCno77An0nAyd7xh5jYmYEcDOq
 FtXeU2NG+9Xrao5yunpj1OFHQyk6lyvoQHlTsy7oe4AP7Z8gSesaCwZiFCQFg+GQY8os vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepmfat9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 03:31:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083BTWF032539;
        Fri, 8 Jan 2021 03:29:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3030.oracle.com with ESMTP id 35w3g3q39s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 03:29:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TU91NYgFgz3Ni1KNt3arHP5qxtN84U5gtsSUP/AlEx7ZiRK12oJmW93/izmVSUrU8o83D/x5znfyj63o1cQJeN4a479YJotUeGjXNg1st44/xkimEnDOTx8egJcamK/IsQe9edQhKSLg089OZPJsMe+iKLjWdkaxF2DAmbB75fUudVe4WwaM4KnFrPOi0sw9RoYFyNRHFFryGGUcTGTuqM2fz/xEh2yAqF6Klu0FOwSB2uzSofXW77UJ8snbeGlHJd+zTr1gQs2b7NW581a5MeWZgH0/rF/X7yeYkHP5r0j0JXIMinlh5MJjRbDhlSCM0mvMHjQiYM33U+SfVOb41A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ycv+L+blUPQmCBMJQROV9DwJ+8aVZxm4tOxyk3RvcGs=;
 b=ObuzCrynvtafVeR7aFl+v8PsGom22CM55gOqpRXdZcrxN6+Q9C+ny9aSnhe8pLOkBGLWPO2oyyrHBZaoglfR1NSWhDyFrvr5oaymLpppwmI2EZHSqY+dXPxT8U38itXC5eLopysnf5mN7BlnMVwz9tTL6xY2KZC1Te8hiCfMVywASYRUliqlLkHtXfZwqFLGGESGXqGmAjQX7iHicjk0RbQhGPno+Qc0Yt5yyfl8E2kOIMkrZBoIrO0Zywb71uAMFjl9+UL6tftADkS4eiula3HrhrCBOspdkeDHNU4vi6Hp5Rm2vjIEVo563jywQhNjwK3f4pjQ42RNiIGTLvNosg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ycv+L+blUPQmCBMJQROV9DwJ+8aVZxm4tOxyk3RvcGs=;
 b=R54L03KAdDFlrhbHy1OKCfdPNToqz5IX58rJZZG2Cp8Shu0B0ehkCTMcw5ux4tnyyfcuYkDKM/Leheu3hKkxBSfyTl2PAI5jo2kKjk02A1JesUYfLqhVvci59wCjmqtuGEDpBzEsMRvRJ0wG9zTbLfS9ebKMW60VEAxj9wByl/0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4405.namprd10.prod.outlook.com (2603:10b6:510:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Fri, 8 Jan
 2021 03:29:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 03:29:38 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] Several changes for the UPIU trace
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfd4cdik.fsf@ca-mkp.ca.oracle.com>
References: <20210105113446.16027-1-huobean@gmail.com>
Date:   Thu, 07 Jan 2021 22:29:35 -0500
In-Reply-To: <20210105113446.16027-1-huobean@gmail.com> (Bean Huo's message of
        "Tue, 5 Jan 2021 12:34:40 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR06CA0011.namprd06.prod.outlook.com (2603:10b6:a03:d4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 03:29:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d70a6cae-1b56-4c17-52b2-08d8b385a0b6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440508000D5BDDF1DDCF7AC88EAE0@PH0PR10MB4405.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCiM7anh4TNjOfVCHx9JuX2oQ25j3yIbW1XGu9xLi1LhkdaCO0ZVrA11gYzNZG7sE+RFeZmM2mZYSsm0E6Mjm5TMXRJW1anQeW9ZfdvTmJ6p0DoksHVHG79njOLk3iQsoPpN8NhKzV8em50QKRANQY/AKfAP95ag5pQl8TfgtSjHG5q6to3yRbqz4Qh0qMs94ICjdAvtGQDCHmsznG4TbYf0DZf9gXkKLemUX4InmEZaX52zzylqShfjGQ2caRYudHLtdCdTii0BauFpQ7pwPOEzZpqxAYoMrAebltU7RV9QnpMyTHQYD96j/JeapUK9I89+VxF9PnHwir8ihRq2tcD6tLkaWvGxJRYO445GsR2eaHhlD85GRn4qetFgkNwujBiJBBORJMKXgo4853O6uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(366004)(136003)(396003)(376002)(66556008)(478600001)(316002)(52116002)(36916002)(4326008)(7696005)(7416002)(956004)(55016002)(186003)(83380400001)(8936002)(2906002)(26005)(16526019)(66476007)(8676002)(86362001)(5660300002)(4744005)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9sBtMAF8hHsBb0aYXRz96uYqE3kPxkR/n0qhcjgVDSy1c5nEDwXnZ1RIS8FM?=
 =?us-ascii?Q?/5j8xg/SEk4aahCut1iSH20Tx9t1mquH0vWKFSezlBngm3KAh3bDTGzUiQml?=
 =?us-ascii?Q?/DX7JVkHL7HkiZTku9B+x9WZe7DJX3v2+32ctXOSQw5Dow5987zinS90dcbK?=
 =?us-ascii?Q?1YpeEmedyGdYh1/3guLVkmSQZzfI8SXKWZ18AtwkxvgyMZwl+D53DDxHogh0?=
 =?us-ascii?Q?84DI9f+MyEYOIYJwWX5nM+JyJ04C2ZIOqposRp5BahbY4ZmQSQLUGYFuhYod?=
 =?us-ascii?Q?DoGy+STN6GJeDlvOAtorAMvdDikJhIqJ+erF9FUiZoVcNlIT9og1elh7KWdS?=
 =?us-ascii?Q?yFOPCHlwpJYu3gedtSoKLHRuLauPL4BNktLUliPLaMO90Cdomf5VWJSCu00W?=
 =?us-ascii?Q?L+fsAaalAtVPuj+FW43ZdHMxS+UfwFw4ijVhNIJGlS0tP5Fl2SP4VIRYQzTq?=
 =?us-ascii?Q?4pUFBJF0pdnzya4STHbgawu+Nwugs2FaapN6gxb3+RUqXGJ0Y3wNFs967Jzu?=
 =?us-ascii?Q?1viTjid3e+8DiijYia81ZO3a7xpXB6Y5AX+LR68T8HgAUyWlV1selddxhELz?=
 =?us-ascii?Q?5ZSg7Aw2aTqxwJRMpUaeNkR3aUOe+7INtzzu1Vgv6lUlG6ofNdRBkc3Zgqrt?=
 =?us-ascii?Q?wymAOXO96usYQIT5SFSQ62d5h3jAKwpiu7BtJperW+p8BOixu32v84858YjQ?=
 =?us-ascii?Q?n6GR/PSx/cjdDwiLt4FRfqF2YucQFsgtmLH0BAxdiTvPw/hWr5PqDYK5Orbt?=
 =?us-ascii?Q?zBqJpD2LsFoKSgsGYgf9lUXroHqin3K3iYJQYjV4sy/Mf0iQ5Vwi3cHztFs3?=
 =?us-ascii?Q?Gm49eGEKKNFD1cc1YIgV64uCXzSyQ3xOKdW2SZhcbeJFE8QmZxaJznSTCFBQ?=
 =?us-ascii?Q?b7LskQ0AnND3eI6dkkwaw+YxpGyuqElsKu4Kei3RezNtYWhNJNPVNPl1G61P?=
 =?us-ascii?Q?YlrsAxfTpcpmrxXTAL8gagRw93WUNKx/PXb6rJTpPrY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 03:29:38.0006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: d70a6cae-1b56-4c17-52b2-08d8b385a0b6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2dKyQ467mkOL8kE5QsmO89Zdl1LBYU6ezIEsxGg5mpnSO3SB/fX/KcnTj9p9/rfWbUQAIK2bB6BrdYKZ5Ei7fZ3k4xz4fCrak5x0Oz2IZX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4405
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=964 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> Bean Huo (6):
>   scsi: ufs: Remove stringize operator '#' restriction
>   scsi: ufs: Use __print_symbolic() for UFS trace string print
>   scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is
>     disabled
>   scsi: ufs: Distinguish between query REQ and query RSP in query trace
>   scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM
>     UPIU trace
>   scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
