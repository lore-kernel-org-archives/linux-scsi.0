Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2978CC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0693364F1F
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhCSDr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56604 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbhCSDrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3TUJC075072;
        Fri, 19 Mar 2021 03:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LtI25NhhES3CA4aQ1jeEV1zfPgxU3emE/VPcHcISoRs=;
 b=SbV1Js/fHv7NYRCSFH60OeRsGA1rPe8mVE0OemDoSO6xK898jElVN29x6csjN0Hkzb3q
 E0N2fVZ3PGv930xnzPbgoDmGk1S4suWjT3th84xAQ32Y0juDt3bSpzYv3NztXp2Jcar+
 PHdQQxpkaWQ1ldMGytSKbGoeUGJ70GMWtmJgRAeiTSm60/klCe2bIbaHbNVrIQTV+136
 cY3TVhxJwJPpyUYZqWn6fhvsz1olPBB9tfQ9tATM9X2Ku4b/z1V9QJFIrOmt3IXo7gGH
 x+RY9zyDcU7HLyIiFgu6HmPaDNsEhq2KmQmDCXxuDUCi/NQw20UqNmtkDxS89bvtoMJm og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 378nbmhhde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U9Wn175143;
        Fri, 19 Mar 2021 03:46:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 37cf2v0dn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUbpbAmGa+WHdAcs7JmPg6knKHg3kheTryAsRwK9KfRdpb4hKxhes9vo4nvHgmDpMnVo27fdzxtGV3cbxFlCYoT8FUx2N7XCUDbQWwRip5KWO0o4OG1c724Y9Jfouz4PfrWn7VJRA7GK60L46eyuL2uonCZqhXJ4MoKa2G9ovvMjL8N4Smi8DboeShR/oafMiTJWyR3dNfU41svZYeIczNs8Qb9j0D9/xqshgoHUnTUKAueouUucmJ8jwV06Cy6jkPNzgRh5Qjp7/6x4RFT59PWQuPAvINi21pzpTFS4spR0VC3D1FW6B30ZBT+JXIoqIMmI10vDW74h/HsZfLDDjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtI25NhhES3CA4aQ1jeEV1zfPgxU3emE/VPcHcISoRs=;
 b=TTK3tw68gzEwFv5Ch4ZFAFacyOBWRpvGuyq8rM1Mrydv6dKVEZPjezIGfLajbK7P6JbmhT7KX+TtCDpu1KnexS6/pC9dZWeHXx3m59MCI3QlJjF7x1TVuHL1i07ThZIfJ22lHWHVHP3lS+SVLT3T36bHqdXqx+8SgqzhQDNPV2YyPHrpNQ4RjXJ2GLAm9mkDcSyYLwIWX2PYDeE1ua2VS/g6dyxgpkWS0Gv3QrouDJDNiSLUlmZ773/1Lqb3yW6DaX3oG367W/ZFI8/YIScVCLEwL2AFaMo8xmppXt0MGr8wGEPcjVPWdqpBU0/1GrSByhnXnYR+OKpAlium+EBrGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtI25NhhES3CA4aQ1jeEV1zfPgxU3emE/VPcHcISoRs=;
 b=P0I9K4idERqHPDmS1AV30B0FMqUxZ3gwmA8zjkw61c3jmKrcgb5ENEL4F79NbqKAqHTrYzxMQ4ouDikrQ3+zGGoxh/rMv+cH+AtgbBHdbyG8rSxqesG7/UTiQPbcyQxSycNeWEl7DkanZgpGaaELog0nLp4v7abcgpxOuh+AyFI=
Authentication-Results: connolly.tech; dkim=none (message not signed)
 header.d=none;connolly.tech; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Caleb Connolly <caleb@connolly.tech>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jaegeuk@kernel.org, alim.akhtar@samsung.com, beanhuo@micron.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        ejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stanley.chu@mediatek.com
Subject: Re: v3: scsi: ufshcd: use a macro for UFS versions
Date:   Thu, 18 Mar 2021 23:46:33 -0400
Message-Id: <161612513552.25210.14724545372813795454.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310153215.371227-1-caleb@connolly.tech>
References: <20210310153215.371227-1-caleb@connolly.tech>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:46:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74d9c33a-0118-4239-8e7f-08d8ea89a1f7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46160F2F7B9C9EEF5D16DFC08E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4fnXl3pzisA390hg6HSpSRnqihuTuFFMYpE8QB04LRctud9TVUPApBNIlq1BgSyLwHBjS7I4PPjxU4ifjm+IXvXsUCWEhbloohga3NtDymiP6dGvLnpZfQW6/uGt+1qhVB2WyZ0h6YG/wiwgZ7H4uMkZgZdqfGZQOWtjAcgthW6uA7CTZ5QLGCP/fRW1F+bAzZkB+ExwNsZm5Yf+ZJf+iagByVMnH9y/BPiMBLYiwmm01hOiPD4kEbiblQIqCFguVFSHVWtrDl+VO/4H2n1EU8D2uKH1dRBJ6M+9VuL+MBcbX7CUypTVphInycMb24XhlXb0LSD5L2/Dt0tMFDw4DLywbSzrDPLVhf74Ps7WGocaBeNq6OI3qhZ22P420Ehdp9n36AP46ILtJVcapeGb0JZQP2757BBLZBCTiXRCPu/6XiuhJAvUSvjB1hg3yb6S7RO6ZfftcpyeY6+dwjhiQ89Kdde31FDVltI8n1NXFshog31CqNLMR8RHlMTMBTdWRYXfRppymnKxH/XxUnshUtIiFnV/lmhRrpTA5OMz1gPGqH3nHr2df5blU6DTeAVybOEEtNGwryXPjdSQsmsTVW+sJTRJRD47/2w645Y9ZNiyq8jXow+pw3G7qqcNot5Tq2MbN+1+eIi0dSZtvmDU6d0sXSr2nZmwdBJYARg8MRmdUNmQngQTT7z9yVVu/jo+y/TshaLy45vsDdz4gosS78h//h+dF8SxaLTiD9/His=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(966005)(316002)(4326008)(478600001)(4744005)(6666004)(66556008)(8676002)(103116003)(38100700001)(8936002)(186003)(6916009)(36756003)(6486002)(16526019)(7416002)(26005)(86362001)(5660300002)(956004)(2616005)(66946007)(52116002)(2906002)(66476007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SGhaSUNFSFVaQS9WL3lFMDJqcWFxSnJZMFgzOUkrckdlb2tTRmFHVytHSGV0?=
 =?utf-8?B?bEZGUUdaR291bEZHdktjbDgvMGhGU2RqVWt3dWlGcFhZUHJQNHBGMkVCcUF5?=
 =?utf-8?B?Zi9GbnZXbllUZVJkV1ZTZDRLZEFRM1FCdWFIdXdlVkFhcWRuZTY1c0dPNHZ1?=
 =?utf-8?B?d09vQ2FYNzVoaGRzN1NtLzUyck1nQkJFaWJxQWc4aXVaZC9PVGhlemhkZXkv?=
 =?utf-8?B?R2xZTGlQVWxSajB1N2p2NlRJM3FuUEdJcGpRckNIL0JIOUNFZGNMZXRBdHla?=
 =?utf-8?B?THlPMHhES0c4YklXZ2NMV3hnamlGUStxTTdIYW5hRjFZU2FRcDJoYnNQNEw0?=
 =?utf-8?B?NUtOWmk4aUJ1K0hvYTg3ZWZDV2NBMUVGRzF1YjlKak1uaHJvVnp0SFR1TjRN?=
 =?utf-8?B?d2xORnZPK3puNXJRM0ZPV2ZBRXViT09EQWxZSW0zVkhZN3lBeHRRS1BEb2dk?=
 =?utf-8?B?cHZQWGZOdDA5ZEhBYXNEZnBmaGJJMkZFOU1RalRHc3NRT3NsM2h6Zy8xWmwz?=
 =?utf-8?B?VmNnR1AwazU4TDBWUTVJUktLbjNQQmVUcGRHalpNRzRhV0ZDU0xxSzMyQ0xM?=
 =?utf-8?B?dXpvTCs5MW9rcVdCekI5UlZpc3ZpdWg3OVlMTjlZM2NvV2RDRU10QlIxNHUy?=
 =?utf-8?B?aEM4TFpYbWNHWlladzVhTSt0QkU2VE9YNWtWTW9CTHI0TFZKRCtKbmp6Q1pJ?=
 =?utf-8?B?UzNyUlZTdTAzayttcGZDUlRjdmZ0VFZpazc4Y00rY3k0NHVBTWRiV1QraEVo?=
 =?utf-8?B?TWR1d2N2clZzZk04QTh2aytxUnJRUDJFZGlEbElORG1YVUQvb0FiTnl1RVNE?=
 =?utf-8?B?Sm1mc0xFSHNFT0ozeGVWTlJJVWJNc0dvNzJKZTcrWll0M1FFdUhweDFQTi9u?=
 =?utf-8?B?UEtkdjJ2ZUhvMTcrMnIzdU54Rkl6dVlkL2tlY0xWWHI3WFRlTEVhV1VCK3Qr?=
 =?utf-8?B?WUxZTjhsM21RUDZJWGRHcEFiUFFYdzI1S1JjUkRQWUxmY2xsU3Znb2VlZ0My?=
 =?utf-8?B?VUVjS2pOKzY5SmdRMHVoWWVXR3AxSVlEbGo3SU5qWEx3R1dERVlyQmtQbEZq?=
 =?utf-8?B?ay9sNll6cmxBRDNoTGdJMFVabnJjbnp1NUUwbmpWRk5ZZXdGL0swSEhNSkN0?=
 =?utf-8?B?YlZpY1dKS0tZM0VTc2w0THFmWlp3QjNSbDB3RlFRMUpkZ1JSY0Fqc2Fjdy9l?=
 =?utf-8?B?dnM5ZklBMUlCZkdTUTBENUFpLys2WEQvK3QxYmZTUjZQeXRxdTZUR0x2VDJh?=
 =?utf-8?B?bmN6cGFjckhjdHhLTksyRkZSN0JodmJyQlVUb3NjZmdOcG5KeGRpUnFrVlpH?=
 =?utf-8?B?NnVBb1FOb0QwelNQYlBOcTRMQVZZemdTOWYyUlJHaTRpNVkwL3Z3K3lQaDR6?=
 =?utf-8?B?K0hXR3Z2WHFXZS9GaENBRkR5YWdGUjNKQ1ZreTc5NUxYVDBNbktqTlVXS2Q0?=
 =?utf-8?B?eUoyb0w1ZTQzL1RzTnIvb2lBbDVtWURkUmppWUlzbkhhZUlkYVpsUm1DZm02?=
 =?utf-8?B?YzlHam9qS1F6TkFSM2svNDF0NFFXMitVZmpmUDBpS2YvNXJJK09XcllFN2hk?=
 =?utf-8?B?U29iRmN6cGhSR2hMbXhyZnNhWHozT0RtbDd6bVZmWWRkL1hKVU83eWVsRUs0?=
 =?utf-8?B?N2xZWXIwYnB2SVpLVmR2Z1N0S0tTcXFZREkzZk9CejhXMGw1RC9kZk4zK3RZ?=
 =?utf-8?B?cWE3S0pTVFF0RWtNTFo1YXNPTGNsaUtVOVNLSG84U2lQdmN5S0JZR3pyMWRk?=
 =?utf-8?Q?aw67s4kYM5byBgIwd1K2IEH9WQYaioR518BP+kg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d9c33a-0118-4239-8e7f-08d8ea89a1f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:52.3312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/egrF4g8VYYxgBMdz+WSNknSiTcxKTkRpeScdsbVk70BKxfbOR41Vu5+ZsM5O6EExatOL6dBoADEjbU9VNVsAa6T+xsn9KQofupckVABqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=811 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=983 lowpriorityscore=0 phishscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 15:33:30 +0000, Caleb Connolly wrote:

> When using a device with UFS > 2.1 the error "invalid UFS version" is
> misleadingly printed. There was a patch for this almost a year
> ago to which this solution was suggested.
> 
> This series replaces the use of the growing UFSHCI_VERSION_xy macros with
> an inline function to encode a major and minor version into the scheme
> used on devices, that being:
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/3] scsi: ufshcd: use a function to calculate versions
      https://git.kernel.org/mkp/scsi/c/514288180178
[2/3] scsi: ufs: qcom: use ufshci_version function
      https://git.kernel.org/mkp/scsi/c/f065aca20a26
[3/3] scsi: ufshcd: remove version check
      https://git.kernel.org/mkp/scsi/c/4f5e51c0ebf0

-- 
Martin K. Petersen	Oracle Linux Engineering
