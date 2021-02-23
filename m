Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5128EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E912264E57
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhBWDZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:25:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhBWDZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:25:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3A2EU139463;
        Tue, 23 Feb 2021 03:24:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=UFs8LZprPrGgoPYvRDqD2FNoPcSpgiKha1gKP1LAlrY=;
 b=b3cHoNwdopOqSroPIopGRE2lPa4rUPvgs1L8m19M419XP9hTDviMizCJWK6Ni8Q/1e/F
 6AXhowywJyZXJjLjy8dgvjIf66PYYYp147FgwywSEH4+bRuQfoAF5Za/W5RLC/zabev4
 2zKCEbhdtoQ84MUaor6ljMX4yjfvOXOSL7n1VIA29FIzguYlwXNUsCE0XsgDrUuuJsUJ
 PpdigbKxU5+q84vTQ9B4nnToUAuYWDfonuQH7Y6Yq73Hd5t9c2j+X451PdBKvlGVJAwe
 UZ0dfXdCwWI+5lhZeh3WiganMqXG/OGnOFH/s+Z2El/o1h7pVjtnchuDPwF3ah2nB/Cx ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsuqwsbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:24:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3A8x1057474;
        Tue, 23 Feb 2021 03:24:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 36uc6r5fhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:24:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZG5uSRok1L4uEw/ve0Xs5UbSUT9lbeUHscjk0NNgz2JCJ2lbyWyAc+XjESkxVRcJb6v11jrk/J78tadl0fx8MeIxsYmP1xReztFYoe5V3/S8GkcVIUPmvpwgpRFvLKkD9GzOg3PjviUrvoUlXoDIRGHqZ/9fvVjWxMIyygk5YXEHfLjqH1Mn/zc6FbTz791NmnEdgTXwEmR6e5gltUd92dbF5tfWcjssVm7aE3MJoZMhYpg+6J3mUwPxz3upqF10MZ9wrKP5tTJJce8mg1NXnWKKvQQZSy6qq74IZX8GIv8og+8xvUhEWHlToM1aYKpWsWfj7oKRy82T9dPhgDlgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFs8LZprPrGgoPYvRDqD2FNoPcSpgiKha1gKP1LAlrY=;
 b=Cr5DTCNCu4HswOkaglWFVgNhpQXcmMb5eHP0/Rh6pk0CKuehZi/eV4pXygHmLNnzuxpCWVRL7g2CZnUz4rnQBe7nJYw9Ac93m8R53fIHhPVlQJlf/gH0GuVPzlSLs/LQc661bhQlrq5PCKMiU4SbdlOo5sOfLnaZf+1JMSfRRrGREWL3c8F3Smnso2ZzP9arSMj6sAYWFu4Lped8vx/vsnscM451483C+q7MwA1++74+isintvKxRiD6UvY3UvRHXaSlguk3Nj3gV1jSwulNN7QPOeXLVOVgiT/XDt1wivVx31KVbrlw5HeDOzXCc6VNfK//8xoT9C2hhCoFphTY1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFs8LZprPrGgoPYvRDqD2FNoPcSpgiKha1gKP1LAlrY=;
 b=FwwWObB3Xe0iKjV5h+tXRyoxKS/2PL/+Qnxj/V1PSZmbC7Q+fCm8cUeP9cN9Lcm3SWDTPv4ITvgiud7Pda0ojRJkSKFJljeWky+W6UBFpO3G+aeK9Op0JAVVzHh5/hGsP65ZgN0iDPH5ja6fIu1zEuP7Dvo0UurF/D3p6xMsnOA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 03:24:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:24:00 +0000
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH] drivers: scsi: aic7xxx: Fix the spelling verson to
 version in the file aic79xx.h
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czwrh3g7.fsf@ca-mkp.ca.oracle.com>
References: <20210209143146.3987352-1-unixbhaskar@gmail.com>
Date:   Mon, 22 Feb 2021 22:23:57 -0500
In-Reply-To: <20210209143146.3987352-1-unixbhaskar@gmail.com> (Bhaskar
        Chowdhury's message of "Tue, 9 Feb 2021 20:01:46 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CY4PR18CA0044.namprd18.prod.outlook.com
 (2603:10b6:903:9a::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CY4PR18CA0044.namprd18.prod.outlook.com (2603:10b6:903:9a::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 03:24:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60354e7c-44ea-49ba-dc78-08d8d7aa7682
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440890CCDBD6175FF0000D9B8E809@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zugBOWKA2FLqkvthKirFhWgOCwXh4BZ7TzWJj6KRl/MIYcjlu5nBTvcUHG3TEKZv96PYwADN7/fqY+7QC3x/WdBakTQV0oHT2P4bg33COsDAJPd8IIJMraxlV8ipGDObG0BZCMGyX2dUFWm3VCwN0k+Kz+RX1o0KVHVfqMoPlGd3k7M1uYRT4yOZrVxLHBB82r7PQqyPSloWQJDPfikFeZ0xo9yDdyG21Vp7ekcE+hk0TJQ+/5uwz3ez+YkfT+WXNgrsO8jrPlgh6Ti5Aa8SxEvor9p548ApynuXzXMQ2CA231FoYzYym21HezXC6uREVQH7871xb22EGUYzsYlF1Zok0q0A98CACzxNjTnmKgj3VeUmpNGlO4WUi+J1BJgwgbmzkn2YOCZf/5KC0eXUmRw7rORbK/2KE3UcSrdpcaVOqwrjOr//cdsZczYOagE+P1MB++zJyNC4qF7Q42viVAIFcVb+9MKQQJ+YF1O5/9///JexEkk+3DGjycJ0lDeskxEU36ZyUGr3Yo7luwkAvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39860400002)(346002)(7696005)(5660300002)(36916002)(26005)(52116002)(6916009)(55016002)(4326008)(558084003)(66556008)(66946007)(6666004)(66476007)(8936002)(86362001)(2906002)(316002)(186003)(16526019)(956004)(478600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bcgBvsNyfhQflnijbEups8WBV1/ECUFGlHljPt0Q46JumuBR944nxi+PzF/6?=
 =?us-ascii?Q?cY0xumcy3fdHHFNLF/Trn/aDBrLZDV2lROuO3CUms7ZuY2zlx37wehUV21vG?=
 =?us-ascii?Q?2SGl9Y8pl/Cs84vs6xgkZGbV7Eq2ImiTDcM5uFb7l2h8ckMkAhf3hKiIwmT8?=
 =?us-ascii?Q?ryaVSZ2RJfSD0kK29scNxoUIX9tqS6s8m0KnCLHYDJ5Mic5ndrZqHLX5Cxb6?=
 =?us-ascii?Q?1ApjHf6i5vWUCUdmmyyiaEDVkySxVcCwCTbAamuSb/3ErccxSQrcU00ACIeB?=
 =?us-ascii?Q?182+g3g55D0Ya4XZJaBW5Y1vmaYTgxc9bRcblfnCNXXqRHGpvwyDHGEQtzfl?=
 =?us-ascii?Q?qaVy9lRpOsYCCXG1Fj7yGpx4ieqEML3GswwOtALsw7H981vcCla2U/GfTBpU?=
 =?us-ascii?Q?Czx2Xu2bTaaaAC6aKtRquFlHGmk7thofE6TfISmwN6HGYSP742frN32QEKQo?=
 =?us-ascii?Q?Gn4r7sVOS6svpphPau+LfVOZBjW7TakRNQUwS6sNaVrf0tNhCLZcOgjMgH0T?=
 =?us-ascii?Q?LVgxfmG7BA8eTAsaYZyjRKj4igysLa8pdzbUOdp49tpb+33B1HA6DMmar7Ow?=
 =?us-ascii?Q?BfeU2fxYLxTbfApMVIg6ihWFy5Sk6L+qQxwLS1PhjYwcePJphxWMBQsefU4u?=
 =?us-ascii?Q?fCCq6KeLZfEnVGxWCIaQ8vLyRAvhmjaGxRCK1+JeyRgqBtG4AGCMkHC+X6n5?=
 =?us-ascii?Q?y/OZeqQ+oNgrxZCVOWmwO07/OIaJxTBA5rPXYeqHAzp62MiiV+GzXOA8AK2P?=
 =?us-ascii?Q?qxw+g4Aj0wrCAJVGcjcXs2shRWzPIXjEFUOLo0Ukv2jBw2/FiwEth8//ZH5F?=
 =?us-ascii?Q?GwycB2eFRwteFWTZv05f0M5nduyNg4+NWYCMD5M5M9pb5A9sNBQOucDGx7mI?=
 =?us-ascii?Q?Up8xpHYsoxLpoO3fZ+0G8WYSkr3692cUtqKG4F1UnlYDAoYxiPReCr4Us06N?=
 =?us-ascii?Q?pXd/jYwcUSu6WzPT4ZyFkEnef/758g+F2PYmDwysspo3M9E2nTLFuKTonHow?=
 =?us-ascii?Q?HhwtZHOaNGloudEQc4hq5JCaEQVZdLPJ6rav9ayQh3XgXf8wohu28W93504g?=
 =?us-ascii?Q?8n8c0NdKHcXo9e+nizyGy7gCL1c9crLwU57ZUQlM5YTFJJrwTRuxVW1ckypq?=
 =?us-ascii?Q?FjPQ7kx0/Tw7+mns3f0JvCnjOQ0k4mOBckMPVMmSnXiaWJLfkxvOo/1GqlQV?=
 =?us-ascii?Q?VoILSzD3s5uNTEzekdoGuZwtmbZq2oQxeAyoWvrdSJaze/iB/7r+pRWbadsa?=
 =?us-ascii?Q?ltJ76QIlLHNyINP9xuyBhEnefyldwi9RAQaVxSJKwll1WE0RagbwJh9I7Uvb?=
 =?us-ascii?Q?nhQoHhoZue7iEFu//Tuu1DGR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60354e7c-44ea-49ba-dc78-08d8d7aa7682
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:24:00.6919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOqGbh0xddUAWX1w+daHeVO42xWmTwCkOmuM/P+AwggoNLiQd8om3U1uY7Jc+A5oiH2nZNsRKPMRnfQNcB9ZnotrwHq1oqNhteTzr9cTxfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bhaskar,

> s/verson/version/

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
