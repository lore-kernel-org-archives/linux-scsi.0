Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B59EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E27DB613AF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbhDMDPk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 23:15:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46382 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236976AbhDMDPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 23:15:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D3AudU141943;
        Tue, 13 Apr 2021 03:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/ag8b2PJiZLzraYuIQsaMrcakc89a6usVhd9/Qf6Js0=;
 b=S4mYMuP25Hst7T99Pjk0guV7eXM+LqnZVzvbfHkw7EyVSVLxdEi064XPzeor0yx7rBMk
 biwELLVR/mrciWkrUq1ttQlCtz/T+5NRFrCPzhrLZggoakCAh6lq23RW3PM4iIYEkdEl
 ydyG5jb/AF0c7PMAHv2XlANaxhKBQwGLpDrN9+pCq/9dW3aUVd3G/ZjnaGJdL1VxO2wP
 uzmFPfFOLE0226/IOeEeGQFPFwl7cLuMdkkPidaeMl51qpsyVpjYfBydfHtIBJ1LgzsE
 qo4ioBMfaWaVLVOjBBqllJ4HHRMOPv1Oofe16EWyNnGTuaVn7WBrE9m/8AOK+dJhHG1Z cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ymdkju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 03:15:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D3BRDw085532;
        Tue, 13 Apr 2021 03:15:13 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2054.outbound.protection.outlook.com [104.47.38.54])
        by userp3020.oracle.com with ESMTP id 37unsru40v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 03:15:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H37f5HLjNphZDSfOQHohMSCVsg4eHDfE58ykfULzaWk6CgraAjLKqz1lvQ5aK13GfPMV6kFCnxNQAGfgX/euNRdO1uMvViz20RLwlhrAPSbfooJjbEUCPybjZGaSNwQ23BE1ZkBoLje/xX4dDhtXlBrNtmfw/dPoxCfOPoqja7z+GZUnr9SeJMYPMQ2qwkuSwzfCo2BM5oU/G9nSKD6QpIcHrYEWIJWZON+3WVTZi5eXGsrc69Ea6sopHzpTkK3kNaYk5JA4L8wKCoVjduV1mwAjrSKRr6UEvuqgIzm0Dvl/CcRDq6HlbZxkF5RRTJENDs3rXS1Caq+CaW6Gq9z11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ag8b2PJiZLzraYuIQsaMrcakc89a6usVhd9/Qf6Js0=;
 b=EJL108s0QZsyfxrqak2P4+a5pgEj1/OErJ/Uk2ZBdXaSSbWkcWEXEr2/aR7SxejIw1SaNsuOakJEu1cQSnytZ4nJysp+PiQI/1h0nNp5fJxB3Q99CJETatQP6yzKvnVoc3y+oYExxGI8+Eqsxu0uKCNiRFYl4YyZ7VPHrl48jwP5j894yX91WFB3i5GxXYzbZszibczegtSfivsLD/GXOHV/yz1ItKtblXAFL9sUsEGqn+ShgDAgriGFwpG0Mbnqr0cCfv9yKd0Ox6MeiphulaP8L016I8D7Gr3GpYrJ1PffqQbIBcsvBrqH21ebE+/hCCS02+XbZHWzIQBJouxzrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ag8b2PJiZLzraYuIQsaMrcakc89a6usVhd9/Qf6Js0=;
 b=z9XIwQkhT/2iAJIRvsh8Mhijx/Ulrm9OwAUObZljdy0NGnveAfTcsxTD+58nGYZZey0MDzx8buPHFTBOsb3zEpwcGQuFkEGc80ZcogsRbcP0jZ/Z166hEwbqVSC35TunGT5YCkBNxnCWMzWXryPg4JAcTW6sv6J2dlUgHbN+FhM=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4454.namprd10.prod.outlook.com (2603:10b6:510:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 03:15:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 03:15:11 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm80xx: Fix potential infinite loop
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s5m98p7.fsf@ca-mkp.ca.oracle.com>
References: <20210407135840.494747-1-colin.king@canonical.com>
Date:   Mon, 12 Apr 2021 23:15:08 -0400
In-Reply-To: <20210407135840.494747-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 7 Apr 2021 14:58:40 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0094.namprd04.prod.outlook.com
 (2603:10b6:806:122::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0094.namprd04.prod.outlook.com (2603:10b6:806:122::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 03:15:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1ff7a60-d16a-4a93-ada9-08d8fe2a590a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44544C0F144CE499A82A97FE8E4F9@PH0PR10MB4454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: no7tfqoNd/wClEKCdHmbCzOmHthhk4CppBbm0n8kuTaGC6J/ASILuoCQT+E4FFncscgcthLpv/Ygh2+Mg1Myk63wBCmidLYsMUGoVfSlWCT4I6mxwNcMykrC9xckfVrzetoxzvLKmBGiWKNZyyQ5YFnGcIntVipJzwB0ivUGohPsHpWw4s9HrOarG0dCt8RCSqFvVLphw30nq3Yo+YyKDQzDNNtWw+IJzwMpx5pIbMCruHMJ7KLUOzcqpwttPmRG/AR1XFrqeAoSMhwtk7SlZva73XG+m5dvzmGaoScO67D5pMgOzLl9Nn8qy1qTe+ShNCf8DYto1hpYKP+qAMjv2wmB5HuFm9lUs66CrmaJLI/IEPk6EFCfBjNt+td6o7gGHqspFCmn4Lxyg304KLyoOHxP1hgeI/quTAqCsY8bHiAIDgJ2kPaGb+j/8vLtofUn8pydzD5m3ENMyL37mgPMIgEb+sgicWknxYF4hNxOWTGe9z9etVqH8E8cWXVpmKzi/oWuxzDFbZ28kXSstSwqs9f9IyoRzow8EW0RfsSsZJB3MITVL2m8zaYYT9NfFSV6Sv0LCfGs6Bw3ylJIMiFzEi/9zQrcr9oaQpysUK/lYDhTaSU1NrFHoqmRchpCC6siFkPTlJsYGQsmXE/4x6SZ4R+IZR0sXMnBmnq0o6pKamo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(4744005)(478600001)(38100700002)(86362001)(38350700002)(8936002)(4326008)(5660300002)(2906002)(83380400001)(55016002)(36916002)(52116002)(8676002)(7696005)(956004)(16526019)(186003)(26005)(66946007)(6916009)(54906003)(66476007)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ruuLm3VIsKc0Ci+K6dI3gEnIuG6JJEO+xfRDJVAcwjWOnEDWVuTvXMMODYQo?=
 =?us-ascii?Q?jlhbczUHl6/f3FMq1gcGiWeSPR4Lje9Aqb5B45WI42VGLg4HO53mWl8fMElQ?=
 =?us-ascii?Q?epTlZUPObiKYHzdEJ+FgM/ZvFEqU4M3jg4ADnOMNe2wI83OL04whN425hTcl?=
 =?us-ascii?Q?EjsPPCCHQJMzt+Z28PX8f+w6deIWGcgbqnZuCnvSUBbrYJvCy6ohO/EaLeN8?=
 =?us-ascii?Q?RRsA+aAshRIjTV1vR1b94+bYMdkDvU4aF6IUbTsQ//K44HjjIC0BIMF1Rt6J?=
 =?us-ascii?Q?dqD/X8VvY4GKzKQf8Kz4KJ8ioFBJKqWRrxBMFBuuuhfz8caoHlckv+Yo9iQ7?=
 =?us-ascii?Q?Egap8RLmrxIrj6NmFqHtzOxl7BY455vmfAoYRt8VHCzA7XfeI9rvko7SX5TU?=
 =?us-ascii?Q?yitgohKj59qEkfjvvbDUN9LKLWWsCGKMDvWfmNKz84GEEYy4RPYRqc6ZuIOG?=
 =?us-ascii?Q?Yh7BG9QMoYk0J78MLjiKUvFmr2bIhmwhgJcfeVr3CKDyckiGX5nw2oC1HkKr?=
 =?us-ascii?Q?Jb7LACjbUoG19vWQN/bthnzzmZZouLcVtD4FcbuZhwnRoJS7E8CFoLi4H4P/?=
 =?us-ascii?Q?qHmu0ZBmKyo7Ok4s66I93irGY+pDA0YA5+uB5Gt7n7y4cRi+05wPZ5IW6BhE?=
 =?us-ascii?Q?LvVsoV59URUHayf1PjUqGnT38zLPXYma348RCUEDQxeuM/GPEl0MYw3MKgei?=
 =?us-ascii?Q?fnnFNRtG71G/ta3Xjvy2ehU9cljL/t5ZCAVeqSdOkKwKlOVcMdoQLpSOA5KH?=
 =?us-ascii?Q?G6Rc443JV3p+R3J4vr3uyhA82K/4yArz0O6PsllaRLJecG9t9rvVpUhNnUjo?=
 =?us-ascii?Q?QkyQ3UhgGWe9uUBxWup4KdrutbusdCE6Gp3j0Oxvuwg6IOaPqkO3k6HT+jDw?=
 =?us-ascii?Q?FYBnmJIOwn+jJgz5x6BhIl+ytO1yR5YFCl01XdhC1+PkeyFNO7zKcet/Lz7K?=
 =?us-ascii?Q?KSdCmyr+J31jyIWXNiRnY/ltDdp/ybt0qjKclgWf6cYCVktJ+A/wShQX3zxK?=
 =?us-ascii?Q?z3m6y2NrkmlBR9sG9zqrY2UhrD4Ugkvjo7l5o8x6EtUes6biHZ6c+a5sF2M1?=
 =?us-ascii?Q?XaL5BCMzGw4c5yVVfkmEITra9m4w5G1BWm6Jwl7rZLNw00FVRSFC/jrcdSKs?=
 =?us-ascii?Q?po5vWCbMW+jlNEP1bV3POG71omSNW0fz6yFQZBpgrWsQujwb0m4CIBauA/GD?=
 =?us-ascii?Q?gRux6GAC2RV7BzU4GDscEcJuaHha8tFtoaPjw/Cun4RfIzOH9U4JzV9rSoMC?=
 =?us-ascii?Q?tQqyAxTL6QsWWilQR1bwiggEc7TJXo+XY7FzGh3xY6lVL6TVX7kj/d0CdnGZ?=
 =?us-ascii?Q?fhWwnd0nRd07nN0blwG7kmFo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ff7a60-d16a-4a93-ada9-08d8fe2a590a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 03:15:11.0202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJPGfYNs7y69f5fLn1NX6zp37J20elWeGtetaSM7DtkLnzJ/XpPEbRNGzbDg6EC1xHUEwCyAxN+42HkAbVKt7bv1zneUJ2rDRWN51GsPE8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4454
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130021
X-Proofpoint-GUID: W7PuFY6r9-6owF-03GDYkGTuZRckeyBl
X-Proofpoint-ORIG-GUID: W7PuFY6r9-6owF-03GDYkGTuZRckeyBl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The for-loop iterates with a u8 loop counter i and compares this with
> the loop upper limit of pm8001_ha->max_q_num which is a u32 type.
> There is a potential infinite loop if pm8001_ha->max_q_num is larger
> than the u8 loop counter. Fix this by making the loop counter the same
> type as pm8001_ha->max_q_num.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
