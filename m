Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE58C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A584236F9
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbhAHDqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 22:46:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51340 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbhAHDqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 22:46:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083T38T148898;
        Fri, 8 Jan 2021 03:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/GvjN9qL7Wbk8cmHvDXjd4BtNWapTAZSkti9AQ6PqhU=;
 b=ibjV/eZQt+FC3bdUdsdyVilolqPOssdxX2cevT0BCTmwqwFgoZzy8M5Rbjymv7tcDsj7
 v88jEjmXM5iW3VvKstF0lIPOLtp6cu6MHXqQt0IVmlyPtD0b9haZWin2Qw/O1+orD5jz
 Sex8ZLWhQy5fVw+FBNsNz8UjreDb/coj2sMEmPF8KjgBYam4Nk3csS92mh/zFNklfxlf
 yUhU78M53l6gCmZ8rL2TRW1EyVUpLhaydHvl+JbDpEyOBBmrZUg3HqrIP1uWTol5SNx+
 WWHoG5VBG1xPCizOqWyd0Di9IBUwU4t1tDkWZAGyVJL6J1ADeXANdgAalLjsPg3N/F8E gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxyqcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 03:45:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083VSfi084144;
        Fri, 8 Jan 2021 03:43:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3030.oracle.com with ESMTP id 35w3g3qbux-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 03:43:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDYcfcvXf2WyXRtsNmIC48RwtjVe99fHF3osuVjeE7EBDP59KfFWJpPVuJ6c/bjKEVBcsLoUOutFQedr9AyLWghFrHE5CtAgfFf4ubtSBzpUGfcQ+y66Orh2OQyEmw7OZCCqcJNj9DYjZau/WM/NhVZfq4YDRXMQ7jynZQ4Zkixv7GmfCW/1F1XtNX1caHR65swQ/I2I+v2TZAQE9heI7W6D3UJ4AT78wVxVnFhvUiv0qsezr4WOD5oTpisVx/Ao4bxCqiyQUJVg33bjx/FAfGyzaqJF+DPi4j0VDx6Th66cqAnvp/4ZSKPeja/c4Ai7pUJG2f3d2o9osA8WKAPZ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GvjN9qL7Wbk8cmHvDXjd4BtNWapTAZSkti9AQ6PqhU=;
 b=Eff81s7BgmrTJ74bng9BL2sT9WevRaMuCFDDT75grpkDfGuv9Vx+iZPzUr588N4LZUY2UJipixum1G1mRYwABIygxS71c4ddrjxgX68rIYhXyy2UILkNzEkuJ/Cn7E3v2D1U+qSjH3sQ4ORnQx6r61lvU/u6rM8UlP6OGc8A6oCSqbHXD8gpENwFxjteqLrrIjwShFuzRJXFZq3gIVo/XefA1aIVP7Z+lpSVL0nQ07tkmd/3YjLyhSgstwnTgnweK0U06VrUQ3FNNDq8mRnsryN63V11IpCW1zrx6jX+WNCo00OJlOK+2wH741/F7IJEYRnzJwMgC3qL0evAe3prXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GvjN9qL7Wbk8cmHvDXjd4BtNWapTAZSkti9AQ6PqhU=;
 b=aZV3xAvSivlA2hJ52AidCm6uXLSmW24OrzbbUIXn5C2iBqpU+x75b6X5zuPXdlzLDddSCr9CgeUh78s6MnpHE/PgEyatclsFwNQ5BDvPw30gEWUtwZLElrneD7xGSiF0xUE/qZTgb0H/Uz5iL39wjgSZnRTQobb1HcrQymMVU3Y=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 03:43:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 03:43:08 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: Replace sprintf and snprintf with sysfs_emit
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kjsccw6.fsf@ca-mkp.ca.oracle.com>
References: <20210106211541.23039-1-huobean@gmail.com>
Date:   Thu, 07 Jan 2021 22:43:04 -0500
In-Reply-To: <20210106211541.23039-1-huobean@gmail.com> (Bean Huo's message of
        "Wed, 6 Jan 2021 22:15:41 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DS7PR03CA0221.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DS7PR03CA0221.namprd03.prod.outlook.com (2603:10b6:5:3ba::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 03:43:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51c3bbb3-a6dd-4459-67a6-08d8b38783ae
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4437D3A5ACC796D13B101A328EAE0@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UVXN4EAbNbRg+EpVRyhlwb1VfiBf8d2n94wzGz2bw2i7J24EC57mZzCj4yfvQ+UwreBK7YEBOAymnBD+76OI9aSd2913OQZDm/6G3jF65MVXIrrUMQLsxRW9bkM/ZlZrlpDivBXmJ4mUFFrGshUdIv3BTiLW6ULrlaRno56peUAwQJIXIUxeXLj0yNtApKpbn/gh2vjs88EFNxuddK9W5LEyvcuc94L7TneOmGg/Byi9m5/DJXT5H+ahaLB/svPTBiKhyHPLBFAdbuBr0yV2Kx6UJ3jKCwEpdM8EGfoVGPTaiSb/2NmWYrPAnBwYOR1JXTSSPRlcPS7Ewfa6U67jv6EIielVdKOxmK+MBAd62+BCqD+B26qnpjY6X56gJYejGHKHht1yuSPjw9jrAmQ5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39850400004)(396003)(346002)(4326008)(5660300002)(8936002)(66556008)(8676002)(558084003)(66476007)(6916009)(66946007)(7416002)(6666004)(36916002)(86362001)(16526019)(478600001)(186003)(316002)(2906002)(956004)(52116002)(7696005)(26005)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?T03eFK46+R0YE8bmdud/OJ/JDAiRKCtmrkE8wg+8+E5iewevBfjKXHV1Emwe?=
 =?us-ascii?Q?CQiO1P8jcBxW1iID++zF3vDcgwjwj/0oXuLbJV/bhr3ZXLieNnTdt0ntlV0/?=
 =?us-ascii?Q?/fQrFSqW1b4HVqUe4/MtGMyIZ4m3jz9OviARaG5FA00Zj/84GKYuF+7EtUzl?=
 =?us-ascii?Q?WFa4R67G/+BkJKT+FMaHC9YIKQhqO+TN8tP6gS7qX1WY6G8CehZFZtSYFHZG?=
 =?us-ascii?Q?neBg2neg6MErJuTVHEI7uNCaqLfMz289HzRWzcG3ekZlCJPfpqmfAM2daAuG?=
 =?us-ascii?Q?lQjJvGJB6/uGXRnmDuwesBgrxcLmopS6kwPcGX3QAYA0o5rUx3VRBXBvcpp9?=
 =?us-ascii?Q?QzTaANXfNZRwC2ptNVhe/iktnMR/GZTClymPk6E2B429y5bEH7fEC2glSSPo?=
 =?us-ascii?Q?ub3BL0OzQ0R7QstLi85bbPlaPmn41E6X0AkZVpMxh8BSvNdis7eZExRncInm?=
 =?us-ascii?Q?H5iO0J9b3VDXrIvVEqfKg8riXyDDcjtz1CuxHqQR+vOS/DI6yz1K1Vh9Pfa4?=
 =?us-ascii?Q?hxbS97NAl59MTp5dtyqsNz5x9EMAuReBa6HXMs4tXupp/awiCKs17vAGzWLZ?=
 =?us-ascii?Q?eXhJT9JK2sxIEYINu0WqKyUlvRyE+p86h8NnV2NL+hCLK3miL24DDCKQ4UNg?=
 =?us-ascii?Q?XmbbpDo44DwD1xtrXcnCLsUpM8ccOyFZexsByGLyizFPkdCgZFXhDgG49hLm?=
 =?us-ascii?Q?udZ0wNuG4RCBd7Ob1qPzPLt9U2i+C8zdNpJg7zOQ2Ml51+AEx/2N6HsSd5Hn?=
 =?us-ascii?Q?TyekYXJ2gHSkxg+iiioXmjDjzBwEnF68c38QYx71wsZWt4gEu6rUno0ZdRl2?=
 =?us-ascii?Q?mjdQOFAFwGH+MwjZFMDLKzRKwCAduE2qi4bn++SD3i1NabqmsLui0jfJgdQb?=
 =?us-ascii?Q?7Ku5+x5OvxIR5U8c9GQnn4fumTskf85nuVfWXToGlC7JIb+q3KUR8xsXG1W0?=
 =?us-ascii?Q?Xus0AZqqHwkA1vD4M3qMuox2EIQ01NRa95XRkYaQwdM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 03:43:08.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c3bbb3-a6dd-4459-67a6-08d8b38783ae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyrNyiEpSpGgJOPj51kWGh6qW6BCRB2VopuLMWm6soaKGXosE3YGIANlSN8UINBT1YesqpVnLWvn4wKXfcViB/ivsBPzAJIDK0f7/3ydaAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=973 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> sprintf and snprintf may cause output defect in sysfs content, it is
> better to use new added sysfs_emit function which knows the size of
> the temporary buffer.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
