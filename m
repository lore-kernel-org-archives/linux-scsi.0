Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD373C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC1DB61102
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbhHFDWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 23:22:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42406 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhHFDWR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 23:22:17 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763L86X018074;
        Fri, 6 Aug 2021 03:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jdDMDV7nb2kaPlbKCpuwUhGTfkoCCRNPmCo04oqCvR0=;
 b=pGrda0lkLc6SF/dQ0Gn7CpRooR433tLrudpTtuEoOOks4Turk2DqvMjECeoQAbwLaPsJ
 DwadbFFXGa2P6EZZSkaFvc4Bvc6svFuHfiFK9XqUI38MbmszpiSEgryqKPnHV1YP6BBL
 4TB5XLj6Wvk81lZsLJ0XmDsxeyTSLIoTefowrIaEt0zbcDHB5OGvNOmrIoScztxq+IND
 t+NFpJHKLw0Q2IWHqwLajxqfLAGvWqQvPrH27MygjMvfXwS8DIAmZkYjGa+C+JBvOzm0
 9GcxY07R845u7GXy3MaRQRRLWHTblkx4kX1TMaL7vwS/MpIOYf46MrgVBMepnjuRX6fQ mg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=jdDMDV7nb2kaPlbKCpuwUhGTfkoCCRNPmCo04oqCvR0=;
 b=g1rBErBFx3OLGNW5GIyjC9dXIvSkf5lQr9N2Ms1tGYbTosYs1/+tzOkMuummaLL1Lziz
 N/ZD+npOfcyddPzeibV8noFg/hoyTXlk2b8FXEP1UZWPB+KBKGY5ECPb4Zd5kY15FMiN
 TGmq7Y0hr2bENBSXGnQ7kgHt0rg55wWU5KuR6M3Ff67SH8aG++qRfuwp68HulRczPX7c
 Ca8AcW1vo8XN0gQ/h52B0Mi2mfK5KQv7J8fliil0eNrRi/yE01Pe1HYsOqJ+DT91N1aM
 oPjFvbBFI6Blyxpr/JWi55FPw6ICZ1fuC0XbtcKqX9n8gH6frbYNfzD0ZEONfbSeZyOA 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqv3tm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:21:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763KAHi155777;
        Fri, 6 Aug 2021 03:21:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3020.oracle.com with ESMTP id 3a7r4avc9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:21:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQefmSWQBbq9pXGEC0VP4aW7rFOY04KD2K7P01EiXBFpn1XYLhh0/XhizYMsBXQWbFgmOqBJqNlVlEG6zBcCfFEXvtkWeThkxhWCkmo/ujCWk2U2AX7bh4QUA5Qj5EM3/zn6gtN/m84cMJ5ko1JFLFKTaLEUolbT+AG/NOryqGGXHbIL2qET4Fs5upQa8t3FkKZieGea/yPogiS6BVTnlL+gmnvAEbAUANZAd8axsK8AUg7u9MFT8wsnjlqiWhlB0Js2ue7CtL9e5lELFA5rxDxNXv+ced+AKdQkYJQdrIwb1A0mtJPYQw6PJXDs+3N0W3CNNMfG087/NYvvODqjyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdDMDV7nb2kaPlbKCpuwUhGTfkoCCRNPmCo04oqCvR0=;
 b=YouFqVTiv8KCNsvytPGAKunP/ekvfdD+LtADmykeGLW7SsJcwH7kwLhx3DETmyngoSzw4eMcIgzfmuKbRj9O8gQXpZ1TqRt4ARsxOs2mUo5faz5kRKGtJMWABnVPb2giKfaqAoMT7RtVFPWscT3mix+mmfNkC2Q4q5LliicHBj4e7EYq0il7P2VwKwRCY2Wf65tWcYyZXyrj5crexobwsmH1azlfhET5ux3OsBKbfGHjIeCbvHl43t+GZir/iLnrItEdKf/Cos42NxEtnWvHhUfz6KkcyWS69GW2waMjgO/pGXuPo7IEVCzHoXDF8/Ykv/KzGDQOPaSqo2xADUZ1vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdDMDV7nb2kaPlbKCpuwUhGTfkoCCRNPmCo04oqCvR0=;
 b=LySfsxReHsxyfPsjfko0yMVW7pdrnerddidsqypB1nwWaQXhbaWMYv31voWgzbFloa8dT/ktvkwsDQTBMjr9Rfz/l+Le0yuHi61Aas8YQstU1jIyu9kmQJVXE6DkIbaZQcibUaqFJmaC0jW3TA+QJ2UncVEddNHqO8GGO5BoG44=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 03:21:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 03:21:46 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, cang@codeaurora.org,
        daejun7.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] two changes for UFS/HPB
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eeb7febp.fsf@ca-mkp.ca.oracle.com>
References: <20210804182128.458356-1-huobean@gmail.com>
Date:   Thu, 05 Aug 2021 23:21:42 -0400
In-Reply-To: <20210804182128.458356-1-huobean@gmail.com> (Bean Huo's message
        of "Wed, 4 Aug 2021 20:21:26 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0040.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0040.namprd13.prod.outlook.com (2603:10b6:a03:2c2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4 via Frontend Transport; Fri, 6 Aug 2021 03:21:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 302db5b2-27a1-4032-056f-08d95889523b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46637B6695F48467F8EB58DC8EF39@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MbqwswRdV0ggQQ1RW8z5z9R5VHRa+FBrh/z1LUMJ1mAKAtsax9/a5FAUqz5dhdFHtbDZX0Kv13VdBlpA+9O4wq6p/4EVvzs7A1RWFOdSxHKA+20udLxOQY/xX31eoRpGUwm2jI3zTVZCZvMhDulR/7gfvhzm96st3SS6zvMlm1Dfs/lg2UeHEqd2GHlQmjAmAzPdL/ZmwEpM3jV8YUvgmAOfzlPm3sPD/S1yljSun1VZym0Gx7JeIrCK9WmmdDHPz8boT3L+kePUGJQ1sJputYGnbycmBgIt1r6eNbLwd5dq3YfQVLad+v/7NW84JQ3SJOrpk5c/CcMfwoDtbB9LD1xFRlw6Eq8H+E5tc0YaDYiMFAr8rujcfRXOBUCdLeH6qNl9g6trISQ5uqqnJiq/Faiil4TQVg4j/4GF+yixbQknBljdHmpGXpLvsCCH6yJphhZAqnHh43BubHkx1PrEa+XuSvNBo0V7yLkuyYJ3x+uiy0+t2HzDCUXGZl6JMgjEIWBW9SOnbJq6wD5iaECVV+C7xVfsbzBONPBuJPTRVpe5bDvaGJrfRKom242FjkJXcsx+jjYaQe43sWQ4dB3K8EBk9n/C3kEGQF/ny8ws3WVyCTA1SZ/EDt4iuvMQ0nApGCSBcjQ1kWXcwM7KbemgrLMJV5P/UriAftWH1FboSbJZNOhuyONVy2Hu45gPRPBddQTYYS/HgcbrwM+bum1NiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(66476007)(186003)(86362001)(66946007)(5660300002)(4326008)(7416002)(66556008)(26005)(2906002)(8936002)(6666004)(316002)(478600001)(55016002)(52116002)(36916002)(558084003)(38100700002)(8676002)(7696005)(38350700002)(956004)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mGfdzf98f31grmgaVMcGLJQpxHlqjThv5X4G43L9zGl8pnxNSc17CG0Cf+ki?=
 =?us-ascii?Q?Wl2slvsEI9a94H9n3DwlTF7ixyTjrSmZZcx3LYloLtX2cprLRO6MbHpvZBzU?=
 =?us-ascii?Q?TXtYv3Xgakh8kiqK9RejFGUiyJBpE4R2ARREZ/bbyTisFyithttvwGxEv6rn?=
 =?us-ascii?Q?ssU1oIaJP1Xd+Hh9/C+D21j6VrF2OFXAc4waaJM2fIMKSbx+i9wBQ2kRogi5?=
 =?us-ascii?Q?eGDEWtTmVV0szcS06hDZ5tSjKw6vpuUryqQyO5mu5mDJZUSi8Sp6miuqGKBd?=
 =?us-ascii?Q?/u4sbwYvnynY9uc6rve5tDyCjwAKQ9V9MWnV/bRhYWWcR+aD77Of1okIjAYz?=
 =?us-ascii?Q?GzJ9523QsZSsvqzLmU2k/4jE7E7Bu//qhH4+7F0UiGJVQW8fMq/psq1hZOXC?=
 =?us-ascii?Q?OVrmwuAfkPKS/1Lbo1//U1h1IWYcdP6XLyqk3+QnvJZ502MjkT4YJLbp35Xh?=
 =?us-ascii?Q?7dxDrC5ehm/VZj/gevPq1G8KNV7SjaIK9BS1g4ZCHxdIxXUFuosR5yfBMlug?=
 =?us-ascii?Q?XdmU66bZSIE94AJhwPPBOPdgydXVQiBh1sf0xcnKgBGeUHPVVKsxeoSUOiXD?=
 =?us-ascii?Q?urXwKiWGdWOghze6PwB9A0jgMFwERbZiFl+LstrLv/Z88hvMZGhaDUteWsJT?=
 =?us-ascii?Q?Rav5Zy1qhFWbkDOEWXVWpMXUZjWEBiDQog4otufqdmrpgS++4J0ILEQGpET3?=
 =?us-ascii?Q?EbtYwSFU5nNQQ8NuXj4xGhLZzzQqNhECRvjz60lhC6uSe99ZLHf03+pDzGVA?=
 =?us-ascii?Q?YMyO9BxqkpwxLOVWqWY+xTqH28XXszpZzZe3Y9bVr9qIQ4gCyPrBjj7kxqSn?=
 =?us-ascii?Q?l+5gc8w83Ph7W6sPcdVpdKEZuNt9/gDkXUNWfhKUu7W4WRBLfy1HdV+/Ekr4?=
 =?us-ascii?Q?tQbLhaKgtmt6qmoRdxwMF05h6bd7AiaQkSb3mUtdO66IJU1C9RwpLAx4azHh?=
 =?us-ascii?Q?6usO6FKFgFokM2pj+pbXCGyMM9+mkbgPMVsVEQdQOm928NxuxhMXnT8cL0LX?=
 =?us-ascii?Q?M+uDFHUBQc+4tZGQA+zTDA/AutHD6MvP/JOhHUT+TrAr3SZ+coHUl1oN0USm?=
 =?us-ascii?Q?bm1d4XNpsGosrIcwZb0JgwFA46kNuZQpUDUc4AQx5FiB4Zeb6cCazpfzOUrH?=
 =?us-ascii?Q?5eTOWw2nPPZx8msqGlfT95BNSxwazI/KKaSdGmfV2xuxU5uJk0qV7HkKWVWB?=
 =?us-ascii?Q?CKd85Y9oYBUQIor/dJZB02Y/nr9illyXspu2USxNi4bg9E8Vz6Nr902biG+P?=
 =?us-ascii?Q?ph/L2iS+sYad6+wkKMXIrOOcyp8wrLmzrGE1jmyjcckyqbc3MSIQjJm1P5GX?=
 =?us-ascii?Q?JnkwJ7Va/zquuVPluq3YAhf2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 302db5b2-27a1-4032-056f-08d95889523b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 03:21:46.4233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAqbc0bxQBLvvFaBuFVaIBZCMqKLlWblYy0TjYAk/Q9T/KkKR9Dw7uN3zqsonKybU9lR9A7PzRkW1a9qujZy1G1X09zjYrbCnPUkBaN+zrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060019
X-Proofpoint-GUID: uziiS8Xfr31n5Owvh88rCeEJ8jOctj3w
X-Proofpoint-ORIG-GUID: uziiS8Xfr31n5Owvh88rCeEJ8jOctj3w
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> These patches are based on the Martin's git Repo 5.15/scsi-staging
> branch

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
