Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB917C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 02:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C7A6127B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 02:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbhHYDAZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 23:00:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25738 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236811AbhHYDAY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 23:00:24 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P02vZT030415;
        Wed, 25 Aug 2021 02:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=RgR+cLiTshFygT433uKjST/a8i8FdwLIN5CKjo4EC3JG6l4yto4iSz5BM7k7kqhJ+PTT
 Es81RsDTX93v4GK8EX8EhSX7vFcMA7hEs9gO4GICvl1YoDEHxxWJToh/aOsJVVuh4aH7
 IREtH4pqQ+qq243nuOxkNqFt/7FCFwPoKwSm1zs8w2cqnMilDhJ0mm860DnFZFksw7kV
 oduHZwMqQD9uEBBYGGy7VbldKVSoxlwMuki1ZoxmK9ea5X3YrVN969yeIbnkEeaE+Pno
 hke1OHaLXWz1pgVfJBsvdVXUjucaoMTNAaU/9qcVY9Dw6uhd5zrZTDZl+NiB69gAlhnU GA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=vMQRkDb2neTvNCgxznI00OA6/ZXJRrqkaUOwA30D2+5MDgOhWztsDcDj3lK21TQy9V32
 m9DuypWjX32gIGeCXb8tmLkYFXFELxqZGZuDzprpsrsfFFgOq8hGRwZoYV+EErR0yfyl
 efyMGpO6G1L5stRoZmbxlrIPfPOno58OcbXlYMlZ0HUBm2NpIumQxaI3rpuTIIsLXMLv
 CxTib9LzXsQj0zLfMOmgW9ldq6gYKbcWRc8b1vb10dwWDfsK0uS5j0OaD/Wm7oLc+0T1
 iOiOGGOMSbg5BlMwdl59fabBT1Ipt56kAvE/yxlaTgysfMmsuk+QuecBV5SWq6tVGGKJ wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amv67ahah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 02:59:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17P2tMf8193796;
        Wed, 25 Aug 2021 02:59:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3ajqhfrjyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 02:59:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuU0dL3h4s95oZWmtrbYXdDU6/qGaAcJDu4kP9f7M3yYRou7DHEwOcwQVj+mvZ55pQJctoh6g9ViK6N6zpYnmVAXGiNTDesVW0xOGc3ruEfR8WEChODKHoAMvzHIi3LPeZD5UtLb3HQTScxzPDBXnsGhucH0K/HqPvTcfhPlK9+VDNyWF0pun62LZIAtGLYFwEYQusO0RZsvh0ka4sQaynReeT2lCfBS/CFlHCYntv241OpUKLDghno0r8TOY11osCeE+IYSF0ypP/hHj4I1eYmuOzI12Xs6/zmkEHGbYXp1gXHZkqWcsGc5nJvoeCDRqMeZ+//Ixz3XtokYrz5ZwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=Ltt+JzWjfAdRE2hG0K8JUIgAd4+Hh1eF308Eox1K+zMNCPces4Jy6AOGEVjzYSBpR5EN5fR/TEsfcuFv89AQH5xHoKs5+GjBAhe/KiTcbg9R1c498BckoADVwVotqHpB1k49MYq924Rm+zjHjluRsiA4jIc7DhlN1dPc+3p6HHDOnHYckpDB65ojqjxvX0CIm/sEYz76MnNILCtPh1ni9pJKVK7XjnHSWoIkoIl+zBjkIeNJiLYlKHpzX2UcokFUmCKPj6l6gAulKa944EbTNdNP1rmFK6BTHxITGGZ4xqC2y/hF15DNln3ED6eRSvIuzlfnMvOq10/llx6iRf+ESg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EJrCh9uXiyw1C43OL5ODpmfJan6R8fYH9a+htAJfrQ=;
 b=wQSlL/me7+MsGTkvyMeCyM1CAdym1fS4qtUG2JYpj7mq6Ddn6vxo9BidyTv4sI1+X47F7LUr2jPAbIYVLqNlPpAxcT+9D1LR488C+yAFVLi11qxUhIL4KI5zRG2JFFRe5nyrgmg0jR5k2ztGRTr/mFYNTl2fG5ZRNMu7e6W2/sQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 02:59:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 02:59:24 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3] scsi: ufs: Fix ufshcd_request_sense_async() for
 Samsung KLUFG8RHDA-B2D1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtp6b56p.fsf@ca-mkp.ca.oracle.com>
References: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com>
        <20210824114150.2105-1-adrian.hunter@intel.com>
Date:   Tue, 24 Aug 2021 22:59:20 -0400
In-Reply-To: <20210824114150.2105-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Tue, 24 Aug 2021 14:41:50 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0114.namprd05.prod.outlook.com
 (2603:10b6:803:42::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0114.namprd05.prod.outlook.com (2603:10b6:803:42::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.6 via Frontend Transport; Wed, 25 Aug 2021 02:59:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7bac77a-0b91-45fd-b1f5-08d96774584d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55643336640D4A65FF28AF7F8EC69@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKh3N/Qq+ZTqJjtQFnbVzqxd8JNbvlnnXlHYsH12AYFjKvXc7rGQug8q54dILh4GrVlh4KIVbQbkF+VWzAePNw5kaMnn6EVj18aoouNylHmM3WXCXYYwjteFlSfMwYNHE2mgSjkX/UyrpS2VgJQaQ/URHTuHx+xK1wm4IemfuAEpnc85KrjuyvzNqeQ9oYAE6KPNzNsSGb+iqoVVYpuCMWT9tycVRtvUy1srt28zpCohwk1QXni31XiK58nUKyUN5iQaFvfOQJGujtbogkjpKux4qvBOxd7cfqSdXHLg4TA+8jhUOXSqBeHFBWMpEX8wOnmzGp4m0rCpTGdRqfVO2Y+ANOCM3nVQXinx86OCNjL2Kn4aP69VOermbE1a2onrSnIALpvuATF2S+LEnz9YTNI9yrfPHJW0dQVvTXb7NeRkAwlvgSjSqvAdiBTywPXM2niGLH3WdfFioK/embcilQeD1ziVzGytbybuySuV99r0rPDjgKgTjDfjUnC/8LF1uuB3TH5b+W9QYUREv2+QJIHa6t2Au5N7PvkdzdXsTybueoZaAPJdbvFf4JZ6nsdoGajxHQZDP6+WH5IXB/BcHKrIkBBFo/gtN77LNpStEDA1pAnGawaxuJsl7jyfxJOZJR78lXOoDdRrpv5MdEhOgT8h5O1H9kk25elfo3zEt9ylwyA5oXczwDqlPYjT0ga3ZHoUr0efMr/T0WMhXayMqr23YY0XBUEBEHoSCevP5OU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(39860400002)(366004)(8936002)(186003)(5660300002)(38350700002)(38100700002)(86362001)(6916009)(4326008)(4744005)(66476007)(52116002)(36916002)(6666004)(66946007)(55016002)(8676002)(7696005)(54906003)(26005)(956004)(66556008)(2906002)(478600001)(83380400001)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B/OlHfcCTQgYTcOUvM1Mof5fbsBJxTXiyuKUAu5vMLUnOhKSSF1cZek5NaOS?=
 =?us-ascii?Q?ckKILM/k8MuQbnZ533qpERUjlH/j6gL6M9ZOQhHMsF2RoIJtY5jsqWfiTOJg?=
 =?us-ascii?Q?DH/dZgOhgkHfnroTYbSK/3KQmWwVvCJqXGEPtvg5SRS9AFlqWO0pmS6TwBHH?=
 =?us-ascii?Q?qJ8XHq0jSJ+RD/f3gLotnmzxZ3VPnQTRrrh+bYyOZFuCTw+BNYlTriTAfpU2?=
 =?us-ascii?Q?XHesSPwishF6p01xLRbhhIayTawfz8hlSg4mxvlNXkA2xzn6//b7a/ksullJ?=
 =?us-ascii?Q?vpRpo8fl9wEG1EgJsQOL8O/kamH5u+J9NBJupLAejftbU6AA/I44vCGrT0nm?=
 =?us-ascii?Q?MPn33lfLaP/BxAEOOhKmhF7W2cfx3YVJUsEpiMA/dbGKrg9d2K5ELD8ZKBxL?=
 =?us-ascii?Q?yNoUUJCPRlYAgtRcKET2rg2+DiuDp7JAbHnxhrSI2Cl7qjRFF+R6mOuccEGf?=
 =?us-ascii?Q?KdAY8SaasvMy67qQGr/KhZkMGNYUwys5y6g3zmz3QzZmBkNNAjte2a1s6a3H?=
 =?us-ascii?Q?jpygD7JMh/obEQ/bYVyl9JA3E4soAyIiKwu1+7HYKvSieiguc5gyVVMz94Vb?=
 =?us-ascii?Q?ResfgDDj0jA43Z0etCs+oqsY2+5cJ8gLbtfb1SGKnqzKcnGD7k48WxWmsW+P?=
 =?us-ascii?Q?B4epIBhUT4Ja4TKC8NfdCavv5Rqo5WyP7ZY6xsA9aUa5oDtmKF9IPooUVB4v?=
 =?us-ascii?Q?Z3Hb8gqQjQ4A7xUxfxmYFVDMCJHiqNGHKag2JfFXdjT8HBaZhn8kgxFQsAAc?=
 =?us-ascii?Q?nfAt8+qQ3oDhci3n0SUwzVg1t9hO+mHpivuj4x3XDA2uqgynGfxQ2Z986ydI?=
 =?us-ascii?Q?GwTladOuoBiqB8H7AeE9S8V0JONwhsoebfOKXL/22X0rWs1qxm70RwavivZc?=
 =?us-ascii?Q?WwuRMUerRejQxiOrtQnAxdmlyKwrpYCdsFcF96lz7EESoS732pDfcrYrKxNt?=
 =?us-ascii?Q?NoRtllty30mhCjfFUtO5hq+N41YDE7P6EeSlwLiR+IbEmoCqjZM/Burzs9hi?=
 =?us-ascii?Q?wrVBtwC4Ox5X35pbLaoeMnAPqpr6LILdYjmKqi0rmuOFQLUWHQxbm1p3TEMU?=
 =?us-ascii?Q?lDVs1wPUm2WWoGCd0IaZ5sTn9J1fR3h5VoLNENgkJJU7meS8WSPtcafAn0/L?=
 =?us-ascii?Q?LNlRtu6cC++wwQ+23dlr7wZqYLtXhEMdkJhfAf251/aqvfHFcITUO91laqop?=
 =?us-ascii?Q?n6Zysf2vXo7T16/+XnEuuuROhY61G6C6DsTSHLXSh+JDeuCB55xqiModQjZj?=
 =?us-ascii?Q?hOzijNIu+acMSpKUAgB7Qu2KJm/V7Y//cVEkD2C9IXuHdWLyTpbXTwRjLpPE?=
 =?us-ascii?Q?OV46APr7H9aaWKE/jZD8hg/P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7bac77a-0b91-45fd-b1f5-08d96774584d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 02:59:24.6324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pl1hbH+0jCq73M6Iv4yNbxrX7Uxuzho1MyJ5eKKVkGjeQfhaGguBczTo/AizgFba7TG9RM/oSXwigW1/E9lleunH+bX3KL4mUvFr52+c/AI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108250016
X-Proofpoint-ORIG-GUID: ij6m6rdQeIfJfMlWABGiIFq4Ge0gFbUQ
X-Proofpoint-GUID: ij6m6rdQeIfJfMlWABGiIFq4Ge0gFbUQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Samsung KLUFG8RHDA-B2D1 does not clear the unit attention condition if
> the length is zero. So go back to requesting all the sense data, as it
> was before patch "scsi: ufs: Request sense data asynchronously". That
> is simpler than creating and maintaining a quirk for affected devices.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
