Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A64EC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE2D23A74
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhAWEYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 23:24:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54788 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbhAWEXi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 23:23:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4G55u165125;
        Sat, 23 Jan 2021 04:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pZ20lCoM5IY88vUSyLmhFx32uBKZGcmX4fzPxFo+9Js=;
 b=u5TK4u4DMl3RCBdzEQtJMf7miPp5GZaG7gC96wGN+TSW9HJeSSMdHNC+h8uvKJj/Cfhk
 yGGdOMndlm+ANwEDWNlRBqstEK7qDVIwKCeauyshiGw6lZAlSNbWvgAWPIXX9GeWZgpI
 khcKkhmBd7Q4n0w6PPQ5K3a1xy1w8JtDZOwpnTCgO0hYFGEap4yVJSjVoTa/hPfxUYiB
 ymEA2YoPV/SDyEodbEEU7reBGpFBs0ZxqLHAZA2ZbdfuB7uOIWvlMMa/PxJdFQKKpX72
 oU/MO4hmi6ihi2/+2x7ZbgWc1oycAnILWY7orrEByb0afzjEbYT4uH9DgSSCQYy+hyVC Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aa8a5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4KoGL078540;
        Sat, 23 Jan 2021 04:22:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3030.oracle.com with ESMTP id 3689u8v0ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOCMzym967nkd2YNfv74nvms8s+sea+e7GDUc51gnaz/9wq0fU7JQBvVOgiHjF+IFBbYsqZz4SPkrd3tRtwzwLRJyGDSMVlJ/yDIBe6bWzMn0oSdgctXSVy/rUX0tR6OZ/6o2CKHAZGHkepZUpO3iW/XL4f9ZSOIWR2lsZcN3xfpQuJvE8UM9AZkD98dB267mbJnB1dzzCfkapnof3kd1mn+vFP/JgO9XjDDOWv3hkRzrQpvmB0lfvBvcJu7pp6TVdm7zh85X/hJHlM7D42qjnJ2nm8i62m0WS9r6LsfWWHFiKhKTA0nTkbP5BLUWiHJNTmwpt1Nk0OdAzolp5kP/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZ20lCoM5IY88vUSyLmhFx32uBKZGcmX4fzPxFo+9Js=;
 b=mZF1miyFeHHb/FdEA1sd+g8tF/D+p0Dgt+QzSVF9z5Rx0su1XxKHj9PR2aUlwB6v6HNdqVaJVc6ov9aI5cQ6p9pC7OX+VI8Qibp0ctAouBamdu8HJUaIlL1LIolDMtS8bUZlQVw/yek6mFjQBol7/aoGSr2UgZRWOUqi/wfExKukkWX26oBdFNTM5zTWz30nFU7+aSUkhjjnSmpYjnvrPuPn2WmklSaglANRT4ET9dMRdKSdFdCGQ+ZAtfMu7i7bo/0wDfdDkG/6sdKi925TWuR8yfi45XzYtF/9Vi6nu2nk0QBQQzR4cuZNPtQP74XA5OGoIUAKzRLKpSHDBJ34ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZ20lCoM5IY88vUSyLmhFx32uBKZGcmX4fzPxFo+9Js=;
 b=Gx9s+kIlnSoA6snY5nCTwbHbBg2Dow0ZwMrcebFER6UhHzscRu8jYq6YwnHCvPO0Om0XGlE+AmX+59tKd/XZOA3R1KZNDaXFcQyzAR56GkSqWBFPvN2j3E7qv9dXaY9EDgXVYQzwSp0eqHrP7/d4N+Lc3/iyOEEOkDVTk4ZOMG0=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 04:22:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 04:22:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, Stanley Chu <stanley.chu@mediatek.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        matthias.bgg@gmail.com, chaotian.jing@mediatek.com,
        asutoshd@codeaurora.org, kuohong.wang@mediatek.com,
        chun-hung.wu@mediatek.com, jiajie.hao@mediatek.com,
        andy.teng@mediatek.com, linux-kernel@vger.kernel.org,
        beanhuo@micron.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org, alice.chao@mediatek.com,
        cang@codeaurora.org, cc.chou@mediatek.com,
        linux-arm-kernel@lists.infradead.org, peter.wang@mediatek.com
Subject: Re: [PATCH v3 0/3] scsi: ufs: Cleanup and refactor clock scaling
Date:   Fri, 22 Jan 2021 23:22:10 -0500
Message-Id: <161136635067.28733.13879662006883873463.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120150142.5049-1-stanley.chu@mediatek.com>
References: <20210120150142.5049-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 04:22:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d44c2123-130d-4e92-d963-08d8bf568288
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44390906555DF5C3123272118EBF9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dq9rbJWBxWYsiSk2nL3LhkSue0F5OIEW1sburzh1POcs5HK9GsocxEUHrdTq9GtExq0DlAOxxU9CgIiG38L1xfZPp4m42wYxmN4voFcqIK6dH9FUY4pauKjZZmk4lno2Z5Q9cnYeaIe1MZB6pSntaAKgEZTtmfInpudt2ZGD4H+W2I8KEkYH9uLGnR7p1t+unFkp4M3Kjkrm8vUi9If7JkHtZaSugLhnUqoq+5J4JF8xVhO9nlvCbSMNUu1DtreoSkq0o/3vDAh3kghAmDf4nLmS8mtEwTrZDRXJ4M1oSZdIN2ttZEUcKSv7vuXb2r6CrLVoFDoXa/DRA3dM2Y+YgMu3ZZ5KbJiAj+PT9oJreYGaq7mM0Y+KqwL11ot2B95qqUgifMkmRD7EMpQrQFzt7ArCXIyElAwzo6a5+hU9uGXfdTKjZZrHUJkas0i36s4m7Timyq5HN9DLeVbZXQr5SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(6486002)(7696005)(2616005)(186003)(316002)(4326008)(5660300002)(8676002)(478600001)(956004)(16526019)(4744005)(86362001)(103116003)(966005)(83380400001)(66946007)(2906002)(66556008)(26005)(8936002)(7416002)(66476007)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y2JTaHNlM2owMnR2dkc5MU5SOEFxWW9XWFZsT0VnWW5oSzFjM1dBWDdBOUpl?=
 =?utf-8?B?S1RlL1pweWRhY3Z4aUUzL2wzS1VpaFJKdDU1bEZpZ0VUbUdKUnR6b0JFdjB6?=
 =?utf-8?B?S3FyTXBaenQ5S2M5TjRFZTE0NXZ4eVFzK2NUbDU1UUhaN0hPejF0RFdaWGxE?=
 =?utf-8?B?NHV3SWFSNHl6SlIrc0FHVjROWnRhRW50NFMzaWdGd0lHOEFuUU4rQ0tqOFJr?=
 =?utf-8?B?Nlh0VGR4UXViWHYxSXhGUjN6L0hoVW5yQzBwa1VBKzNpTU5JWG5TNjRsQVIr?=
 =?utf-8?B?SU4wZ2hlUUllcHA1OXNkaTVJVW1ETHRHVThQVW52dlV5WUMvMlRqTi9aMHFR?=
 =?utf-8?B?Z3pyaGdZbWxaYWhla2IxeFRsUjN4QkpneXpldzRDcFZDdGl0cm9qeHkxZmxv?=
 =?utf-8?B?eGlPcWJURXNhaUh2RlZ0TkpQaUR3Vk8zbVEwaWVvRE0rMFlxUDVmcTRlQnk5?=
 =?utf-8?B?Wi9GNkNoamdTbWUyaklUVGkwMVRsbDIwbG1GUmg1bmIwc1puc2VhT3UzaktF?=
 =?utf-8?B?dUoxVUhnQVM1TW1IZUxjVTFzdDFkb01qaTNlSHBkeXpSRXZxUkEzR3FiRzVj?=
 =?utf-8?B?N0dTa1BSRDdzL3E5amRwRkxNL2Q1Ull2QVkwL3Y2V2QxUWpqYjZZVVF2MUk4?=
 =?utf-8?B?MXh6eGFyMkJadWI2REoyMzlpRExvUEJkRUo3RGRrV0Urc0VaTytFd1MyK3NQ?=
 =?utf-8?B?R2pudXhLQkZkZzV5YkErTlFFcFRmYUc5MjV3dkFaOU1yQTd6RklXYVpUQldR?=
 =?utf-8?B?ZjVTbjR5ZEo1Y0tlS3oyQklPMnp3Q0lubXROMXBjakYrTU80L1RHWHVKckVs?=
 =?utf-8?B?U3Ixeng1Rm0vYjNGWVFqWFBRRERSa2hMd0M2SVZ4Nk9yTXFTZlhNYXJESVRM?=
 =?utf-8?B?UFdQSmQ4NjBlOElHNFV5L25QOVJuUjRXMVhPQUh5NGtlZnJuTHMrLzYreXA3?=
 =?utf-8?B?YmlZU1VMQW56TW5EMndvUmR2S2tFZ2p1TFU3ZVJMbCtzU2tDRXNhdGdXa0Y3?=
 =?utf-8?B?R29JK3Vob1h1eGs2RDlwSGJOcDRRcmtoZTJaaFI2ZnlicEZDN3EwZ3NncnRv?=
 =?utf-8?B?TUgxUG0zdGVRYjZ1TlJQZUoxaDBocGZ1SFo1RlVYNWdwV3pHbko3U2FUOG1H?=
 =?utf-8?B?SGhTNXgzL3NKY21LRzFMRENyR05nTlJwK0wxa0JXRmNjMzdmQjdlcVBJWTc3?=
 =?utf-8?B?VWxFcDJ6UlZzekwrTDJHRlU5NEZXRWFpLzc1ZmlwSW9wRFZHUEh2bTBpWlpw?=
 =?utf-8?B?ZE5jQlRWNnMraXRzK0hFQllNTWtXcjN4NmNBemcva3RrZzZEd3VEcjdBZmk4?=
 =?utf-8?B?OHFHZnlpcy8yamJ5Q3cwMzFuSUg2WlpyM3BhOFJjU1ZoVGNNRDdTWG9laG8w?=
 =?utf-8?B?S0hrSmxSWkJjRFVpNXk1dlBNTHZHelNPdXFERDgvbGE4VEsyMHY5VCsxalBI?=
 =?utf-8?Q?6nRq0nmr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44c2123-130d-4e92-d963-08d8bf568288
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 04:22:35.3632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lV6a7v4cWv2UZ6gdJX/vqhBhv81q+p46kgLo3IpYDv+O66legGi+lwnTdX8gIAQKAVQD8UHOfQKWZYFXu/Qz4P5XgnbPWvXbijK0AtuiPCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Jan 2021 23:01:39 +0800, Stanley Chu wrote:

> This series cleans up and refactors clk-scaling feature, and shall not change any functionality.
> 
> This series is based on Can's series "Three changes related with UFS clock scaling" in 5.12/scsi-queue branch in Martin's tree.
> 
> Changes since v2:
>   - Remove patch 4
>   - Rebase to Can's series: [v11] Three changes related with UFS clock scaling
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/3] scsi: ufs: Refactor cancelling clkscaling works
      https://git.kernel.org/mkp/scsi/c/f9a7fa345aec
[2/3] scsi: ufs: Remove redundant null checking of devfreq instance
      https://git.kernel.org/mkp/scsi/c/b058fa868234
[3/3] scsi: ufs: Cleanup and refactor clk-scaling feature
      https://git.kernel.org/mkp/scsi/c/348e1bc5f4b7

-- 
Martin K. Petersen	Oracle Linux Engineering
