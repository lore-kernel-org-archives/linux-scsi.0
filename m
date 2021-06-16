Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BA7C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EC7761055
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhFPCjb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 22:39:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53048 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbhFPCja (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 22:39:30 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G2aWpK006894;
        Wed, 16 Jun 2021 02:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RZEojGqnNX83FfqYO+mcie0eyC3TP/MsgJk9hiIZtNw=;
 b=S72M3TwGMax1WmdokyP5F45oYBfC0xE7r4lpX8W91CWcS31Eduq+zvx4D8d0244jceV/
 vD7NQuwE8IklyKIBAkLknb4A/GHeCGVl6xjoTyYAZtptMFiZOiVO8QY2LxeX/uJRCbVZ
 3Jzm/JrFbsBEr2TCm+g9wG7RyQq5zt5dk4dNiYqXelLoJIQkgd8wyNWdb3q+J2vDK97w
 DSWCNywOfVP880MvkOfatINiYOjLcMe3LjEPt60r7HZpEmnx+3htKgdCL6sqSeyrvhSk
 n8R8aBPw3qY644ZcuJ7+HdIox1YdjSIsjOkxd1TdTqn+WRSe67h3HjlMg84E3F4Gzxmp kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1kssb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:36:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G2ZFh4171667;
        Wed, 16 Jun 2021 02:36:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by aserp3030.oracle.com with ESMTP id 396watweq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isczkk4wCtQBlm7C1PvNRyEt9HmxTOexamhv/vQZd0uKt+PLGOJEvwDzKKMLmHZ8U7GEE1RuqL/c7Pov5lf5Vi1xv8v5eNaU1jaewwBRcJvd75u9tkzvk35C61F1/qYjV21BQFAvueNVlSgDOvKJubsgbVxRYElRYxq9ptyltFxmDjw/41fnZSOcSX9DAiHS//wkvbJfBiMr+nsjMr89zyDcMdgmrcdZldF40H8jRKHvEo6zzBci4LTvFhmOBEpc5vWrDRfG7ntf3x7A4fg7bxjLBCvh1RuCCvbabDgdzkW/81u/06mYmGWowQpttqKo//nUiwYywOceqaRjp5yw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZEojGqnNX83FfqYO+mcie0eyC3TP/MsgJk9hiIZtNw=;
 b=atECsvfWO81fTlgi/0gUreiP16pIafNT4FCeh3ss2WLaAdX60Y2D6dmMD2ZvkVJAIU61d/ulWrnzqQVxRSucAZV4WFGvF98vXzHP3WUfJIazxf0AESfp6/KBiaXjOJBDftW5Eo8VTFJl8wN5XXCs8I/SdC23fj9svzD38ghG9Jf5ozYMk5v6PWKRqWydSMEq7noWoax/+Ppze71sKnOn6LXXT/7LcON0EOPHt81kJN6Md2jD+ni/ljhrv2waWk3OVGsN8XPNCduCpx8lMywswo4aFfocMB9vcV+p4A2IHS6JCZMFYYpJBcfY9C9Sw332/7I0gAo34PqOchxrhMzCmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZEojGqnNX83FfqYO+mcie0eyC3TP/MsgJk9hiIZtNw=;
 b=J9biaXxNGU8WOjeq3v64ZjP2qsbYDj46KeH5hcn4MhDhZ+kah//R62rojIObYWLepvQLRwFtxcgbU9BobN2yxmDzzSnNyEgvBuQ7WiE1+CMVyQ2KTw/nz7OwoOpBC/pInPZCQ660RUO1jPvyAZQ96OWf+JTxLLfdljWRUnR6o1U=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Wed, 16 Jun
 2021 02:36:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 02:36:53 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Subject: Re: [PATCH v2] scsi: ufs-mediatek: create device link of reset control
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf7a5ydj.fsf@ca-mkp.ca.oracle.com>
References: <1622601720-22466-1-git-send-email-peter.wang@mediatek.com>
Date:   Tue, 15 Jun 2021 22:36:51 -0400
In-Reply-To: <1622601720-22466-1-git-send-email-peter.wang@mediatek.com>
        (peter wang's message of "Wed, 2 Jun 2021 10:42:00 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0272.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0272.namprd03.prod.outlook.com (2603:10b6:a03:39e::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 02:36:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e28bf18e-2741-45ad-1ebf-08d9306f9a42
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45518C8E88ADECF9952D0BC68E0F9@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hMBJvTEJbPmz7vB20Q+hN/ln8HO3+uGHAQFXEGumQK0Pkz8dcrSwMEb6qa/P1Z/oainMezy619ghtFYGZBVbYdZjwdVznORF9cUF0PEsb4mAxX7X4mal5aVWgj3k5uS13OgAfVbWSTWE1nNQixENszUv8Kqr6h4q5PP6LSBMq15Xi0ggGtFuo2xJiza7c9WDDmod97wcNT6HAoaLjtxZG+q8Q48LvlOAknMvsWCZ4na8lEOdMGK/3801GaKZo4r3sdY74tF4GcXzyk0CKouM1THCX+DNW4flwC77pKo0Yx2lwM1ieIuAbOpldzER6TStjHZ3Zvk2hHsIbg+10786KLwrB5x15kKAw559LsOXL9jcN6umd51EcoDw0Jt8OsvFdNQIqcrfMWEB2hz3TjrAblib7rG+tiIiWhcX1uSvB+4m1FhL5TqCAdDp8RrJN0kmWxeWwVkBFjrUYelU4JfiO6yD74WEf/pDsdHzeWElhWb03r+MRpKc3UbFZPxaSHhTFuFhuAh0j2howOxzJ+DyEOFjrw+6uicPanp8wEGtJh0AA/VtzxbHsBKNS9eiTFKgoQvYcCNZ65n4r1AC/G2n00rIVnrjf6ar5nF52XBNALffvCR8/HKOvZfVYny4ynCNdHayPV7/uh9LZhDHeg+LPHBKobXHotT/iSoYZTcQSS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(7696005)(52116002)(316002)(36916002)(86362001)(4326008)(8676002)(7416002)(6916009)(4744005)(54906003)(5660300002)(8936002)(26005)(956004)(2906002)(66476007)(66556008)(478600001)(186003)(55016002)(38350700002)(66946007)(38100700002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NBJuqeyckW8thBu17mI7Et10Ezubmnt9RSnZMbKGxH+OkHlTaX8ARwjI04cj?=
 =?us-ascii?Q?h0DtMnw6kPYoUdZP4UIsswPMdcBYJut9TdtKpsOu1oVXQ3MpJGVGmpftj7hu?=
 =?us-ascii?Q?fseXAf2fkTgo50AtB8MkF5Z7PfiS7BD2nOZzWz5LO7WQDHlOwvu55z+7aFRk?=
 =?us-ascii?Q?2/WnLtKgRlo9m/tpDEYhN0QgSSqRCtgEyI2zrCM2FYMaZ0QgpOUE1dUCQNNr?=
 =?us-ascii?Q?OSsAipiuGHpCgVFH0xvxdZ8uRuusKl5mSF0RlVNk8nvzPlJpfzYsZLVYA7Qh?=
 =?us-ascii?Q?CZpymEKJamnrlwcWEBa3/HZG4fTy3u877woXrzhW9zYQ3vFp/qDvWuAyjwQ2?=
 =?us-ascii?Q?EnARpLGfIqiqvi9RkbWyZYh/vsLHZ+/oFiMANlrM8/h9VJSiu0YKykBekYv0?=
 =?us-ascii?Q?U8l0hyweCaXSOx3iUfVjMNCmo4bKeT9BQ1iC2uRPpVNPZFunQA6nzLfwuSBE?=
 =?us-ascii?Q?pq6xMV1T2dOhSEc15JkiBJy2IR9ZzhxIVpOYAXUJRvoUh+AO+MJkH0loYe6i?=
 =?us-ascii?Q?NaXIGIK2pUKgs1QkON+xQWdv7lNJydsm8kIAaXqokPLsm1RX44SS+sXf46xd?=
 =?us-ascii?Q?EiBaUGxdCwDobHM8tHbsajpIAhL9Z4+waGOi2EvR6bYuDvrs6uWtXKF/uc0f?=
 =?us-ascii?Q?EQwhyq5S7VeUpiTRcbRmwaDCqyFnBRK4/61F9BW1eDAahVGHYzQzktNQKKED?=
 =?us-ascii?Q?QBi6MDAfhdqPVvq6yl1uAlx7Z7C1B5Usfq+MUexIqG1mkL16Hg/MMuq7D1L/?=
 =?us-ascii?Q?wHdYXEjjY5pNMm9gfzpZ7G9NCXmG64Vnnk57mSwlQ8sMJRMDqDxvbu3aYpyF?=
 =?us-ascii?Q?OO24dDOhPcP0Yff7y7e6En5gyXg2+MSEp+W2Eu/OU3Ny8uBmeaUvDNiWme6W?=
 =?us-ascii?Q?3viKD3x+LZqHvY2oT6EI+FN0EbHe6sgP8+0ird/VoJqVkF75Ct/CdVdjoLVt?=
 =?us-ascii?Q?rFB035bFTKI8i3JM8HOxEqZhQINRARYwthHwRcdqGxr2f/8uN0oHbxVEi2Wy?=
 =?us-ascii?Q?v5R27dlazJ0u5xQeGvMauzy6ATZLmIvoE8/ir35X+v2MyQ8wY0C4DppHCk/+?=
 =?us-ascii?Q?S5gF2xwVNm/UaRYlJc/+6zzLKwPszu7uRhleLvBrf1A2RjF8zBCVXK1+Ftqy?=
 =?us-ascii?Q?4mtI1KUr/VegAO1zMJWOVzCB5CVcDSg+ji8uRFpzWky0tS8MXfi56tl5inhW?=
 =?us-ascii?Q?N27G2Kw2kfHnyN4QSjzVCTFUvaIM8lsuiKKtRqxYI32Z2mUb4wAsExfLDefN?=
 =?us-ascii?Q?OESUzNvLVfDviwq7VMzgxhT/+VrrxMAEVtuUb32UWp/j4Jej9EtyPUhPhMZs?=
 =?us-ascii?Q?3yVB6YEiGrQvzA6joShxr1lK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e28bf18e-2741-45ad-1ebf-08d9306f9a42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 02:36:53.8009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+JCIHVCDHge0aRu0PNEQKntt2lBaNvTrYITMi/OipZtatWxNrZI8/zrQUzn2SDh2ygzNI+Mxy5a1gS6UXjypdKFghlPASmBpqWHw9IDDdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160014
X-Proofpoint-ORIG-GUID: LRBAyvm46gLzWlapkDt4KSuipJ7f0wBS
X-Proofpoint-GUID: LRBAyvm46gLzWlapkDt4KSuipJ7f0wBS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Mediatek UFS reset function is relied on Reset Control provided by
> reset-ti-syscon. To make Reset Control work properly, select
> reset-ti-syscon to ensure it being built with ufs-mediatek together.
> In addition, establish device link to wait until reset-ti-syscon
> initialization is done during UFS probing flow.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
