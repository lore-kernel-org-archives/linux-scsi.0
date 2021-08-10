Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE67BC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B11E360F6F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhHJDPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:15:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39024 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236470AbhHJDPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:15:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3B4EC014737;
        Tue, 10 Aug 2021 03:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=k6WRi3KS2R9Y63WnAiY9QCmndkkdiUBSxYB+/9/O1UI=;
 b=um7dXdMAZbjiDWeA0IQhQRTtxEfgaGuXeQH6G05gVR7ZvFFgVMkuYf5W5BJ24/ZeUkYn
 f5qwHgsVeEmzyOPtp22i9uZPIdGuCl3nhQrqkWDmpZTYlK9GKEo0F1+wYV5l7Xv0tgnY
 gnwTfOEKXozLDR6pfzS0tPrcjX0j3HyHyZzDL2HeP2jzg+HySPIUlEXxf2rWGhC4a7Mk
 hxgCuW68O1F8vxbfZX5MgbAMDmoGG3Q38u6w9+suF9f22DcD7izmFeW3Nij0VcNrOGW8
 XqVHGKvndpOOuKYjhUYzPYrASKHkLH7d501guPG1IjLwBCQqQSilfrEZU+fo79+sHUwn 6Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=k6WRi3KS2R9Y63WnAiY9QCmndkkdiUBSxYB+/9/O1UI=;
 b=0f8D6Q3kVfcmBn+xMsELWgam6qZaozsxyUdIYGlHC9+9/ZZO63pginrocc3sucuzfIIo
 iLEcIKKtYJQ+jW4oMbJ8IDdcs4XuFdFpb0biNBhXUfrbxWaMWhwtOFh+vOL1nmiUOIb5
 WLHl64XrImZR1Ng0DAzXr/k2RJntS/Oe/gaAu63wllt1rfsEOmGlFMOPh3izJWhWW0G6
 V/NAIw6gE4phjmt6gm1Asosi5qKz+ioNvbD0M4rBC4jTjEq3zOVcZ96nuNdyt3XYi9Zb
 pDNv/6NxNgScGxMmcTOLqHYPi9dmfnbgNkdWKjcPtw8W8SXbMwJL6k/b5SaqGb+smYOk XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmutusu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:15:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3AVnF112701;
        Tue, 10 Aug 2021 03:15:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 3aa8qsbf1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:15:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzkjqbcovt2cX9+Z+n4tKVNHXq06qDuDarMBz+k3o0cbZteK8Ro0b/8tmF9TJMkOoqV32+VHgN77kn6dENGMs1VztXtk7GiethlEhsSKHcIGXUS5T/rHMPum3NTNULC1ajFVVaSlY+B9fG3IGDsONrYHa2JC2YOR5pizbE7HaHtgJ/OGvcP7HeeVNumOUGVi6o6h84tkY4qW4BUpr/f1wKNCtJspRYkg3ZyIG8gQ4Yu2VX3o4BwIGNkkuHPaf3TJZZDbH/BUV+XMp/7OtbERTRiiYjJZ8r1J37qbJEo1WhUDLQRL7RKrtkecaBE9xI7m5tQLI3MSoplr8sswq3k29Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6WRi3KS2R9Y63WnAiY9QCmndkkdiUBSxYB+/9/O1UI=;
 b=GeMyjxQ9/jPyuuANXen1SWPCmuIymClhMAolZzqIc5LEGnL/mIrOrUI5ppPCkA9APgSOxjr0M7kiA6mWtQ4gEzLyDVVhHn7tJdW7pbHnQjlnwyUJdOYnmdt20FynTSb1er3SaZ/TCmIKUUCvkMePzgixehBlHDZR47PwigYdZY3SulRIWzW+9u4n0o26xgRR/zxyUumO8zhhFK4/W6/pbbRQLWpZzD7w8EyOf6RwyR/zaEg/ttQgK+ZZMKlA+r+Z1YEUyjBgNuQuMB5G2Gg45syFmK0Vaa3HWoqn+q/F3c88rOElQNKrdV+LsOwV2AHNWFWOyvh1WWC1zESChk8PmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6WRi3KS2R9Y63WnAiY9QCmndkkdiUBSxYB+/9/O1UI=;
 b=tgSND9tk/Fe+Ck1TIUHHUA02cWPh20lX5minUfuh0RFQ64WNm/Un6BMv2K+4T6TXtl7X9uC+c2DMOp6qK0ldEmcgqAXwO8HvFfY/4ywwaGcqeowwiRynsHtYerVkhOu8FN/7+r1vIehslIAqNcMy7iD+FdfSDeIJBLT9/Nhpqu8=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5403.namprd10.prod.outlook.com (2603:10b6:510:e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 03:15:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:15:09 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: Fix unsigned int compared with less
 than zero
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v94evvm6.fsf@ca-mkp.ca.oracle.com>
References: <20210806144301.19864-1-colin.king@canonical.com>
Date:   Mon, 09 Aug 2021 23:15:06 -0400
In-Reply-To: <20210806144301.19864-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 6 Aug 2021 15:43:01 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:806:f2::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0003.namprd04.prod.outlook.com (2603:10b6:806:f2::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 03:15:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e475a8f-435e-4d9a-617e-08d95bad0f67
X-MS-TrafficTypeDiagnostic: PH0PR10MB5403:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB540315E46566E364B9704F648EF79@PH0PR10MB5403.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jg9iOAIOCg6WMZ2pSsijWjxR1+M4Fr2rpASZcD4J54hH4lHoQ9lLEZYTvjvW6NMpA/b2SrVyhvazq1/wtiLlOJqHt3vNTd/iMBjtjJGK6IM5W9uMPrdTn15uHJtAdXXT60VMQSW43utcEzj/EC4mea6eyVy/6KEi4MQOJmo/56rOdWlGObLdPSxBRRTNPUbK4D5iNvGw6EbHH6qc4673yGJRO4oDrLnHm1TveaVabCBfizBpTTIJV39zhrR/T1WFzYJw8FLWUWIUjr0nQ6djIJ7DWEfqFrwenbV2pr7PIpe4WY5upEq+5wnV6VtkRGrhPEeXUoV28wWQx2uplql99ijGUCtFJbFjAh09oI24TG76r2dz1tR62KcuM9ap7t6OEJi395RQgqNjV5mdIeVaf/Eig1gqZfti58bNoZwsfbj9gwL78AuTEIxptyI0UTjuGlz2qC/UozN2nlu+U1Lnt9akIyPTTOj6xNyWOV0W2DTi7uFnpIf7EV0/iuV48FM1b4N96X3Gd5rXK8HZg9r30MiRrlaQ682hs9PxMIIe1f0zn0qyX5QRnN4kgD5bfadZsdxMAIq31MKMOaQBwu7LaZL4gywXX01UamHDyQAg/t//+XyPwK+HIoi87XSO0muoe3Paz5tQORRlgWQwOFLm5vz/9Zg2VecVmVJOXhJ4hdfglDIsXH/uXSpAZHZubK2yc7aSCyD8D/Cm0t/UCTBQyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(346002)(376002)(396003)(38100700002)(26005)(38350700002)(66556008)(6666004)(6916009)(8936002)(66946007)(66476007)(5660300002)(558084003)(4326008)(2906002)(8676002)(55016002)(86362001)(478600001)(956004)(36916002)(54906003)(52116002)(7696005)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zo7ilJlVX1+g0xT5pM4sYFFdcdrGYkY3aE1hMAlCA4CScSCkI83sm82buiaI?=
 =?us-ascii?Q?3KjGAZbuVdS7B7MLYQutOCsx9dXLS/olLXc9NEcco66gd2h6uy23J5hBmsUo?=
 =?us-ascii?Q?O4LwMx+n1nSkQEEazxhb8r96QfWNe6+Phx3hX7ac7bj1iV+6Fvrg3PE3EzBC?=
 =?us-ascii?Q?7Tukmgw0NmL/OidaKDWn+O7gJkhZ7HDScGrOz9m9pML/6N8AsAD/7Pb0j1Zk?=
 =?us-ascii?Q?7oWBHrr4p3XnWPmnF5J+d3JNX+IEyVhqVpE2s9760vxeFxv0MQbexI5R2L8O?=
 =?us-ascii?Q?JToyxUZ3u/fQ3G3tNbn6zWJeMNH1Qx4k25NmNzoBcTmmVdq4JI5G0kj8Kk9/?=
 =?us-ascii?Q?srLiycBmYFJbhy7j4t0phVtXjphTB94ZGI0NLIK/06PAyUaWkoR89QPrt3sm?=
 =?us-ascii?Q?DLyPgxZ6VFn8aFWSfInaN7Y2N6neQSSnvDj/pXXUJaU/Uz+mFG5fBhm2IAR6?=
 =?us-ascii?Q?WQPtBRwTpAJasSr90z1gbGldV6MKQN2RDMW0H046FXM/5JWp3qlR0RhrexAA?=
 =?us-ascii?Q?tZZ0hbKt/be23nnvdRuvKbqtvxZwrFn0Irn65vlxDhJe/eHnOtEbzNBkQKGP?=
 =?us-ascii?Q?q8GYN80UBlBE0XrrEWtgbQeupL69xPunvR0Q9WBAthtMYKOFv3Lej3tZ8tyW?=
 =?us-ascii?Q?rRxPKAMZ9lGuzp1YUSbRcoCrecYnJPYfaj7oQ7SX4CRu7wnzqp/FqE3UCiAy?=
 =?us-ascii?Q?kxRSAuBdnh3ZXsHidr5GZMxjCKf0cx8fx5Foo3bOpdOMC8ziceE/mQdl6w5c?=
 =?us-ascii?Q?Zor3eoxc1dTjfD/uWTfoms9YYIUfuvfe3SWkkAnhfKOI5daHMGDaU2jbbZ1N?=
 =?us-ascii?Q?+daTx79wRljrMY3R9fKYaHXyl71mgMf4wry/Rs85+GTEktE3ZOh1v12lPoKt?=
 =?us-ascii?Q?e1DT03S6Ubt8EUBCNsiBXrsk0d40dl49X65Z0TTShdB4jY52gTob56yN7a1v?=
 =?us-ascii?Q?dLdMKDv8FYHlyenuVycfw1UJ5/NgdY1/wDCw1wrG+bdP6pRJsNpP5BhoRbv4?=
 =?us-ascii?Q?pg81VhtbsAm7NvfwskPQPouOnk9VY6cQX1xB/uI4RsReS8cbpDW5VPlkVp1C?=
 =?us-ascii?Q?GEXAhgcB5jq3nBmiiv6xvQxcbUU8k5zj9qJarEg7eO7kTE0xAVSfVCkTKewo?=
 =?us-ascii?Q?Tw3urWeeUgMUWScrO3oY3AoHuiuBhFA0U9WNojWu1GAFSZSJq9PKGd/FaT1F?=
 =?us-ascii?Q?+iUtuYPsnVJnDa4+Ji4qq03wCc984647SeuLov/8sCyvvsXG/MidH+ehUoIW?=
 =?us-ascii?Q?5A+2S6yNE81wX7UzU/NKn1EX66TKvAGdvRbFdOy8wOFneFsAXrT+9bSivfeT?=
 =?us-ascii?Q?BK5XkW58x4EUr2rD7Fp8E09W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e475a8f-435e-4d9a-617e-08d95bad0f67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:15:09.6355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JPuzsdPGXxrZjUelbAcQow0HyJVGXyU1WP87lXwUfdbLI4/PwvuWCR5BpiI28Y2OiXgxmxcpZuhJry6fv/7ysdQZIuPsBB5hm53LpyCwbfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5403
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=998
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100019
X-Proofpoint-GUID: SSFRkYQBSAFNwJma1Y38muENfLYJ9UPY
X-Proofpoint-ORIG-GUID: SSFRkYQBSAFNwJma1Y38muENfLYJ9UPY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> Variable tag is currently and unsigned int and is being compared to
> less than zero, this check is always false. Fix this by making tag an
> int.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
