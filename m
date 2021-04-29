Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E8CC43460
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F84861411
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbhD2DUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:20:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54586 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236909AbhD2DUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 23:20:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3DSSX166026;
        Thu, 29 Apr 2021 03:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dpBdnAb48/+X5fX52VKeMniyH0hFxnh0QNgMEPY0M70=;
 b=AglhVv0XiM2oo44umCoUC5mEd9pSuVGj1Zd2WPnr8HQiH2Kt2toHFz7Phc1bcgHbbri+
 D2XPdZ1iJEsWAh0BOA5IHp7jNOxqwQQl4tMeW2XrjL26XFoxB4wT7jag3aH+IkmSY+yD
 fg4lE14FtBwoXedORMjLIH4SkEnBaKV2AnfoXMNGSjGRdL/xnyHd6bDSN0c3X8S74wmJ
 noIAttHKJWMuQcmw8L2tMtzLXI0U1kbvHWs0Pe9ZwZeI+AlDS1wrQdfDXBbjQsZO2dc7
 oIw8jAS2z8neOMyxpWfIRc0o247G8i6jCWj1e/VAhcIB5W2W2UieJEdwFc86s8nyNd0g ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385aft2v4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3Eq2w154231;
        Thu, 29 Apr 2021 03:18:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3848f0es47-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXzEGhXFoeU6HEUgjuWSUDGmyKwT0f1ntp5LUXB27kB1CcOUGPxCZIhNKZhSDVe+XWpkislLEdVNCF7NE7Wwu+G8Vy/Exen0kEY9F9ahi7hrJNcNHlnYSaTfsfxe2RzosvR661k7Aq9kuRkV1eNtM9zw3BWHt6uURZfo7Yct8kWep/x/gQpUiU8vdyFVomwpMQrhowEu1JEPcr9sBoiaxZV6s93FaiPvZmXTPUQM+JEV2pfIud6TrBRYn2qbHB0JpFGKj8DNzkQQYpEFu6b/5vfujh6UCEMKNjaVZNNw/khtMreDpLaNHzGly4kC0j300paEMXBrZBME43xHzkyYhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpBdnAb48/+X5fX52VKeMniyH0hFxnh0QNgMEPY0M70=;
 b=ES39hwcAk3aeX7WQgVbIuw462o8gEz2ig2y4cTsvCK2MQ8mLqnAd1z+eAOXBt8suBWt915k/62BKguOuwn/7abmE5KnN/TOCtw1x+K53xsSF1cRooDaeAGbmZeC2AfsadPXHzxpdcuR7q7M5/qFk+9J3Si4SlEEvq1Gj0Nrba1ttEca0XNJ6TVqHseIG01Rg8TGCnrFBvXOE7zayoNtowz1cpWSLj/jmp1a/3XSKiVblwPp02kJdOSVX48hH9trkGpcabD27B62rFSNpQaMmIbt4IWV9TOItdoLzY1uvSli5p9LsvOITlEl3WOxqHHisy/uII7Qdc6/pdbXFx6Bb5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpBdnAb48/+X5fX52VKeMniyH0hFxnh0QNgMEPY0M70=;
 b=rQzP0NwJN48veonm7XD3Ym1GIIrlTdFGOJtitBV5VvKEk7RiEHyo+XaLlsUX8V8xMbnTdX1rcpjUrLaQfHsKwQzn5kod5qGtwNPwaypalGHAKU2sp0/GEleLkBlFwADozGcy6pRK7yjKgCrwnljaDBvnQFNwBWR0s7nSoGjGlSo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Thu, 29 Apr
 2021 03:18:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 03:18:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH][REPOST] lpfc: Fix bad memory access during VPD DUMP mailbox command
Date:   Wed, 28 Apr 2021 23:18:48 -0400
Message-Id: <161966630051.16262.11900505953215510836.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421234511.102206-1-jsmart2021@gmail.com>
References: <20210421234511.102206-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 03:18:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 194ccf3e-24b5-46b6-f4c9-08d90abd8601
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB480585C2E3028F541981ACEB8E5F9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1Q2AZ3U68n8PSqHIXh4hO1AP9iptBlKppaExDHptWn/YvN6iN9ch4P1CVG/RtN6zwpn/yk56xR9o26cAEJJHgrUWXK/16iE6d6SdS1TOpo9eFFTFnjK3uTl0meR4mN90lB8HqmimTIJPyvp2QnRNJLqCxGj4ShOFalRghaYCA7eUX47Hw3AsJaNauzhZVl2zKzeUi40uqTsjRKz+BB0LTl5FfvLCIrtSE+f6Z2KGYBCapyvMCgUSwfBasWvmeewvjEIs0QUu8rnxWstcYJvvJvncmHg3ZW8QDpCpjIYfAg/IDxOgBVeIMID1y4RJ3Z6O8nS0F8/DRvIYdDU8ggBFIN9Po7QSvH6p9uWg7mGkmMdcs2qNUNO4T55DQJwy2mqAzpKnv12O8fIflc50BaoyF+3LFtlkp2u82K3TdSg9tgw4JlVBP2xUkeA+Z4O8XDDndpxbEvz5AEuWs+UonpFB7rXDl6oomhvsIdrpK1YXNarrFd/dQBXdAhZeuDq0s7RBP9ID3jljzzF0ayn5QsZrxao5Yrt5xyh5F8XpAznyyT2KfPfGg1Q6B4P1ZPak3Wb3XqNn+LJt4NKx+ZLetLpJLXUuhXt7z9UI7jOO6SyKEmvT+gtx+VxWPDxwfyWQzhsNFygD4sOGGTX3bhCFplsjycWMki1NugwoSlpoU2CcUMF+OHVanYTW2OfpP0iYk6YsTAvslv3t+7G75mdPka6w0MdYpqIUKYEKSq+SnLsy2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(366004)(376002)(26005)(83380400001)(36756003)(103116003)(5660300002)(4744005)(54906003)(52116002)(16526019)(186003)(7696005)(4326008)(316002)(8936002)(66476007)(66556008)(38350700002)(6666004)(38100700002)(6486002)(8676002)(2616005)(66946007)(478600001)(86362001)(966005)(2906002)(15650500001)(6916009)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWtzb3pYZ2VrRXV4d0pGN2xxMHFuUUlpbGlUNGUyTE8yL0V2dENFcE5yRkQ4?=
 =?utf-8?B?amlDMDNTYzNzNXlxYjZZSFdGMURZbm42czQ5SXdEZXg3YmMyaFQ5eGJzb01H?=
 =?utf-8?B?S2hZTmI4UDlBaGtJQ1hoTEVRWmxJbFRPK3EzTHdzMHEwVjhQenFQUnFzc0ph?=
 =?utf-8?B?aGFjN3BwLzJyaFhjQU1adEZza0VsTlg2SGFXd2grWjh0UlJTR2J2a2RZL085?=
 =?utf-8?B?NjhETnpOcE1sUDlpWkhxNHY3VWprdFBJWVEyVEttRHpwWDZrak1zUlc1ZEhW?=
 =?utf-8?B?a3V2R1U5ZjFYMzM2S05ndEYycWxNaGNUbm5hVk5vRG9qSlYrTGRuc3RjYVJ0?=
 =?utf-8?B?Q3REWFhFVFNwWGk2aWlxTXh2Z2o1SDMxSjl5bWdkUGtqRS9BaVZJYk1SZHY3?=
 =?utf-8?B?ektkeFlZM0tJdHpTVjI0elYyTDJkeldheWFnaUZlUzd0OEN3NG1VZHpEbmln?=
 =?utf-8?B?QVpTdnhIeU5kT2JNVEN3Q0dyZUZFYk9yMGQ5MitjdW1EcU0vUXJta0lndEtO?=
 =?utf-8?B?SDh4L3YyY3hDT2RzZit5MjhzbS9RS0twOFFwQktDVG9aS2MvT0pNUGplVEI0?=
 =?utf-8?B?d3VHa1NtK2t5SmRqMUpKWG5kcU9DVlpUV0Z3dHhrYk8yeFFhY2J0eThiMW5n?=
 =?utf-8?B?bkd1ZFhjR1N3QWxpNDBteWFxQUkzQ0JJdFBTVm8xSGNONk1BOEhJSmozVGZi?=
 =?utf-8?B?Q1Z4eHNPbGx5UTRSV3BoUmdXZ1lGRUJFWEVVRDJDVnZjRTJueHZjNWRFWWZV?=
 =?utf-8?B?L3ArcS9jVWcwME1QdExkTjlOUDFhL3NTN0wzODJCS2lFYUl1Z1kxdGNqUU40?=
 =?utf-8?B?R01EdGRDbWwrS3hZNUs2MUQ1dm1RQnVPS0oxamlITXlzZHh2THVTeDFhenpv?=
 =?utf-8?B?ZVFSN3g0c0JEK3hkMEhNVGlEUW93bFVHYmdrMjBzbzRmTVBtTEpNV0N2TzhW?=
 =?utf-8?B?NGhaWWhyVEtkK0tENnI1UUthTHlxNUlpd2M4b1Mwb1IzU1FTc1dwMU5QZ2Z2?=
 =?utf-8?B?S1d5TVZOQ1ROaHUrczYydDhDV3BTaEJZN2JGQ2VpREl5RGVaTHdNLyt1OTd2?=
 =?utf-8?B?SlVZb1lMd2xGQjF2b3hNZURBR0JYdkZySDgrVUZkbXB2cDVRdGNYeHdxMDRy?=
 =?utf-8?B?MHBmV3lLaEVMekdScWpwc2pVYXUyNndBUGNiZHJ4MEEyRTA2TUttb0g2eHB3?=
 =?utf-8?B?ejVkRkNqd1UzZGF4MmxtTXB1WFY3TGczVlFOQzhEVGlCczAvei91Z0ppZGZi?=
 =?utf-8?B?bXFUYW9MQWc4aDIzL0JCT1d3NmJRWG1XSjJucGNkeEN4N3ppTXJmKzc1eEU1?=
 =?utf-8?B?c3NqemhjVlFmTytNQ212NURsdmFGcWNIc1d2SmxHN2dQelU2OHlCenU0c2Fo?=
 =?utf-8?B?UWo3QVR5azVKY2h4azE4UlUxaU9jWXVNVE1IV3ZMVEFzbUF0NFUwYnRuWi81?=
 =?utf-8?B?bks3TE5QOTVHU0xKSXo0Q1dQaEkwTEtEaGtFUXBHSE1KOWdkQnUzQkpCMlVm?=
 =?utf-8?B?cU9XWkpMRkI0b0FxSmR4cEFENHZqK0pvSFVPYnM3VUI1T0x3RG5NcnRRN3do?=
 =?utf-8?B?MmFUdm1PZmJBdE5wTUp0U3pCK0pXczhXWER3VFlVczJmMTNabFd4aytiMTFQ?=
 =?utf-8?B?WGFEdDJnZ2ZyTjJNMHNTa2FERDAxOWh3V1JoTmhzMkdoK1BodlZ6YWlTNGp2?=
 =?utf-8?B?dHZEeW1tSUdXOVRMcW5DeTIveExqcmtZdmVkbVhHNE1oV29ySE90eFdlYVZY?=
 =?utf-8?Q?S5ByukYaZqJxsstZEZ1+ZWl8cyEyyowaRA/tMmD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 194ccf3e-24b5-46b6-f4c9-08d90abd8601
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 03:18:56.5018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvBDJADkXRBy6TTegNuXAEUJg+UN9/N/uQ28d5jtv61HFW6P74Y3lq1Z2DIx7BFsHM+kajgYCOR5KYQVxQymc1cxv4HmhO05DETO464TvM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290024
X-Proofpoint-GUID: -wIMY5OU60uAOilKtHEAaVHWN1AXoCPs
X-Proofpoint-ORIG-GUID: -wIMY5OU60uAOilKtHEAaVHWN1AXoCPs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021 16:45:11 -0700, James Smart wrote:

> The dump command for reading a region passes a requested read length
> specified in words (4byte units). The response overwrites the same
> field with the actual number of bytes read.
> 
> The mailbox handler for DUMP which reads VPD data (region 23) is
> treating the response field as if it were still a word_cnt, thus
> multiplying it by 4 to set the read's "length". Given the read value
> was calculated based on the size of the read buffer, the longer
> response length runs off the end of the buffer.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] lpfc: Fix bad memory access during VPD DUMP mailbox command
      https://git.kernel.org/mkp/scsi/c/e4ec10228fdf

-- 
Martin K. Petersen	Oracle Linux Engineering
