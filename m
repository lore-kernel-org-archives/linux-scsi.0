Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C2EC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 040F964E90
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhCDERs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:17:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47728 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbhCDERg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 23:17:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12440W1U136282;
        Thu, 4 Mar 2021 04:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=QL85T8GhbaQZdOFbHXHsSlsIzn6/tNIH03AEvgSLQMA=;
 b=Fa84uEPGXnYoqfqELmt5QObZhNbICq4JgxhSkqDZU88TRR7ShihIrg6z9SArZckItPP3
 nYeljOxhd1nXQfMNGtTi9OMhj0CfgE2+X6wIHmMiijSRtXhBRgksVeXj0Blp9Sn503Z9
 vZyZEH23zUVsoBeGkGWnAuFU0FGLfEVTmTFkqHq6AqzwvduMDcxDen7zS1N/hXO0IrUo
 7Cq+8p/RbnRz0cC4plc8wB0sDO+r9x+0vm2Id/uzDQW6zpGwbl6UU3JiQJ083N7AYiRq
 0xjgckFJ3cNln+q9Lcoob+jde5raVmKJ9+Tb2wuzDaERntzW+59GgiRZPDVq3ibH0UtX Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 371hhc733y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243sdKt058393;
        Thu, 4 Mar 2021 04:16:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 36yyuuarf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVd0bPaXSvuh8dosUrwxP5kCbxoggpVjfCeDOkL9FMXi7NJ+5TVeTyRMnvPYnIfC6ZF7P9p3gmA4dhdx65ssEaoLLeu377/FrmXTpaWVoMuBkKa6NkC1o4bkQbvLsTZwhBP7hmVu28RlKRGEKA2vJi9LX0eqX9xrjYnAchE3bvq2jm8qnkkWS8FFf2QXmn08A3YGzXBPIRP4Di1MQvLrMElFDT4cpuaCEWIV4xKTuIkeuA4fjvhNfbZzcFo42q8houYjRL0/6ENB/X+MftyXmy9xkwpLQMzY7CEzbSm3iA7uN8zgSObSaFkoGFRs+BbjvudsjZ6O128D3Chbb683Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QL85T8GhbaQZdOFbHXHsSlsIzn6/tNIH03AEvgSLQMA=;
 b=gdFpBkM5395ttvrri3HJ+QP76lOJBw4KycsyOuLOZEv0Uxtjr7spoxs8RaM4lCPvpNv7sbJPb7IWNsYOPHm0cUWXG6rZUnEGnEcw+zZVLAhE4XQy9S+t0JCxPu2meahm6jkvI/b8u/G/L81xWfUn37mu5NeyQ57a9dV/3u4tKhsFxBHus6ZeQ7IF5+sP3dT9WVeltbFvHno8viBE9i8DpVjQMT7eHj8ewPUqQHaKLWD41XxPY/Q9EWBiuJJI6Lanv7/j3PVG0j8gnjN0CW/CwLOPE7rOkrnZGErc95jyWL2bsXH8LiICiSWPbbBqdJ1LdbMnMqTxTLRYI7FN7+CSbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QL85T8GhbaQZdOFbHXHsSlsIzn6/tNIH03AEvgSLQMA=;
 b=oEHBfVCZAbdLUUf5gSRtnxzZcH3ce/b0oFXBaXVKthoFZJVzBPkbetfEc292cs7/TZLxLgxHQmiUySDQ3vlQmZTLBm80t3aNP2CPWFfxFx10tEcbA0spV9ImZMVFv2enr85+D6iCryWx6LY0VfOn8yUc23vhucr1heTpxENf61A=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 04:16:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 04:16:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <huobean@gmail.com>,
        linux-kernel@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after ufshcd_reset_and_restore()
Date:   Wed,  3 Mar 2021 23:16:37 -0500
Message-Id: <161483137625.31239.965550193595620091.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301191940.15247-1-adrian.hunter@intel.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:33b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Thu, 4 Mar 2021 04:16:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 822f2643-c1cc-433c-c7bd-08d8dec451ca
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45525D6E42A1D437969CC2B88E979@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCO4jEwnT9XvkPiScDMBw1acNrGTzHGiio3mL7aXJoN+2YSk8PaLGR8Pswu3+vpUV6MmNsFp1PsozBvNQeRRP4on2TyZuUhLhg5rHPGvz+Tw2VRjD9BUGCZMley+ngfny8aTTKe0bUO3y1ZlwEn/VNktYjE8SOzWB6axqr74U9sLFkeAKUSD18RkTCuGx/tVlaP1RqQb/FwJTCrNMZyfzsnnC61Lba/3RDOkBMEHxevVCxxKZg1N6Z9Aj+n6HDj9nY8MlzKSonjbYCQX5RWxeIw/t4y+uidxWyL3myP3Qn2bWjRzqxFRhOFTEcT7CSWZeTBRdOtzbid8qMIrxM/AneSdWpz4qT85bStSVsxLTk/DDKCuqCpv60XoR1Lv2aN17GFvKoUISZVkXSg6HOKmwcrGMIigCp2OkYDYDK0rdo6pLZgGWZRRlG9/jxaXBtG1NCeQK8/bZDOxAei6OTLLhFWs3oNN2B50vWjxSTExnEOWDDwXaWN7JaK3Ij0ibQM1wv9ghba0cG7F9qx4imOuxfhdiumZb8plpgNn7uASSlhdtkC50cNAm/9178MBmnP0UW6IvE2IUhtXMlSe88aKu2sSM1L281L14GpNvVsUU7M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(26005)(66946007)(6666004)(16526019)(316002)(6486002)(66476007)(478600001)(966005)(7696005)(66556008)(86362001)(4744005)(2906002)(83380400001)(186003)(103116003)(956004)(7416002)(2616005)(36756003)(8936002)(4326008)(54906003)(110136005)(8676002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1lJN2VicDdqS0dtdWtCcnhYRFdjL01XY3dHcXVDM3pGL2phSDVvOEZHMGhW?=
 =?utf-8?B?T3lBdy9EV1QwTzV2MWZUS1puQ3NHU1BnVlFVWHF0dlVWWHNUWFNJSEFZeEQz?=
 =?utf-8?B?TzNqYThCYm5uMGlIbG84cVRJOEluOFRCSWpkRlpmRWgyZW93YzdDa3dWS2hD?=
 =?utf-8?B?TTNDYWg0YTFWaWxBME1kcnFhQ216ZjhUVHhlQzllZFFVSTVrMnhndkp2QnZw?=
 =?utf-8?B?S1Eyczh0NmpDdENCc1VVbElJQ3hxVE5yVWZ4WEVZVmJqM1NUWjVMRmJ5WTQx?=
 =?utf-8?B?aWJPQldUN25uWVdlam5FSEJQREF3MHphYkwzbmRxYTZSNWYxVnIvaFlhKzA3?=
 =?utf-8?B?bDh5SWhJR0JzbzVVaDJ5T1dHVWc0Q0phaVhpc3EzeDZ2SnlhMklpZ21lMTdt?=
 =?utf-8?B?NEY3SnlIUFI4bDE4dkhESkRWU1VnT2t0RVJNWDFmL05uS1R4Q0VyUlh1Q3Yx?=
 =?utf-8?B?czJ1RE1Hc0thdXBYN0F5U0tlZ1F6TUs0cU91SGdGL0dXNU43UE52TEFCazlG?=
 =?utf-8?B?RXdIRnhzTWQrRW1PdlFVTTR1T0pmTFhEekFqekpLbmd3OURLbjcrcGVURjNU?=
 =?utf-8?B?UWpXcUExRURFQUtEZWFTclB2aUlBcG5LWHVBSVBibVc1L1BxVXdhSDVKVGQr?=
 =?utf-8?B?OHpPQzJvUUF0SnhXVVVqcUh1eHhpeEhEaHc2VWVRdmJld00vbG5DUVZPbi9X?=
 =?utf-8?B?MDcrUjU3cXZ2aFFKQld3NUtVTHdmR210TlpwL253NTJJSStsbkVYN3FvNDU4?=
 =?utf-8?B?UjljSUpEcDV5VjBoSnhtUjNEK3JLOVM4MWg5V0VhOUN0US9uYVdLMkM1TytE?=
 =?utf-8?B?WUNPQVY2a3lFZGU3Wm05WkVFT1BWYS9HOEVMdGtaOHhIMnpBaEtPUW96cGRp?=
 =?utf-8?B?RktsWmVSdnJ4dUtDbVlLNWRNWUpBU1FLMXRVcTBZd2JwWWZKZTg5ZGNkMXJB?=
 =?utf-8?B?Ti9iREw0VWdoclNnbFh3enlDSXNwTDNJNlgyL3RxSUc3RGhtblVrYkhkY3JU?=
 =?utf-8?B?NUtvczlsMHRUbU5kMG0wTlk0djAvUVAxRnAwcGxXRVZPVGVBYTI0L1lFK2Vj?=
 =?utf-8?B?eVpjUk5TUU1SWHJNZkU2ekZMenBWWHJRdDhBUmFkekNhdnUxTEt4Vmo0blNh?=
 =?utf-8?B?cXh3bXphM09KUDBCOERscTZSUGNnWXc1c2NyWWxONTgxWXdwbnNTYVhyOXFz?=
 =?utf-8?B?QVhrUEQ1aFNzRDRyQWtvNGRDVzFsam8zZVF0L2V0ZndJWEJ5OWd2OXBYbDdO?=
 =?utf-8?B?UGdsM0l1WVhnM3pGUTlLckdKUWN0dmhuUWJOV2t0Z1NnNFdVMmtnWWYyQjRN?=
 =?utf-8?B?NmpjYkxmcllyWklzZ011Q1dYWUhJUTJ1K2pnZmhycWova0lCcWZKUmFpY0lj?=
 =?utf-8?B?T2x5QUJNNkFkeUFkN1lzdDdZaGE4TDhpS0Nxd3ZzK3VaT3RYZHAwMFYrSjZD?=
 =?utf-8?B?eHNUY2NzbVlTUTdBYmlEQy9temtsVlErVUVkbUM1c3pJUE43NXNSaDFBckE4?=
 =?utf-8?B?eGxRRUFYN2xkRXhzMkhXWGtVQkVwMmVvSXhzWjNHZzJrNlVkSGNxbmZweDJD?=
 =?utf-8?B?N0ZQb2V5eERUYTdwc3lUbVUrWmRpaVIzTkpFTUw0Z0lwWEVqS1Z5UWgwZkU5?=
 =?utf-8?B?cWV3c0ZsbmovV0VIbkxHazdRUU9BU2d1NWlFZUtvQ2xYdnB0RERjMk5mQlZT?=
 =?utf-8?B?UnFjejMvNDYxbzdwZjd0MTdqQkxnRmFUY1dzMTBQakkxbjBwWFErOFJnNGRR?=
 =?utf-8?Q?goUxNDtpoz82j0bNY0hX4FF98DbsIWRxhr6RAbW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 822f2643-c1cc-433c-c7bd-08d8dec451ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 04:16:44.1728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNOdGWhSDCjO+4OfXFGN51EgMZwYX8g+i+5fpVspcsDHWoQLPmtfIrKK7/DaA4gvVaPFM6+JjdKcZl20UgFb8yGYBk/RKq1A5JFVRUr29AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 1 Mar 2021 21:19:40 +0200, Adrian Hunter wrote:

> If ufshcd_probe_hba() fails it sets ufshcd_state to UFSHCD_STATE_ERROR,
> however, if it is called again, as it is within a loop in
> ufshcd_reset_and_restore(), and succeeds, then it will not set the state
> back to UFSHCD_STATE_OPERATIONAL unless the state was
> UFSHCD_STATE_RESET.
> 
> That can result in the state being UFSHCD_STATE_ERROR even though
> ufshcd_reset_and_restore() is successful and returns zero.
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix incorrect ufshcd_state after ufshcd_reset_and_restore()
      https://git.kernel.org/mkp/scsi/c/02c2fc6acc43

-- 
Martin K. Petersen	Oracle Linux Engineering
