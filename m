Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAD7C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 805BD60F35
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhHJFVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26642 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237573AbhHJFV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:21:28 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5B2hQ010428;
        Tue, 10 Aug 2021 05:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NtbrA/8gCqS9C7b3QW/eZENIMoETd2RyCAICdZTIcUI=;
 b=cinaKwRhLCt6Fiwh9VG2bVQs4zDgDvKXJv8Lj7RRlveAVMgyxbVGADPU8RAHnPrE0ZJv
 vthDneHtEQEy17lQmZ90csFvn7EH6qtpvLDVgwoDqc86YIkZQsQXhHJKztvlwGd2G60a
 ws6qGkug2L4QLKhMJJ9vtwKrGa3WR3L9dCG4rPeIHYF6Al+mTdKqCSQsX0pcJqPkx8OV
 tYWxfzPl08dJaRk+fJblJ+1kuRbMmXUxHmfPMA4sU+4uKfRTQ6BX50J6+rJBDjDzJoX/
 r7xkz8gx36cUH8AW/9iMiEPQ+h3DiHcH5MAIwk9RBn0vsDqq3vtxR2s4HQjd06DpIwqs WA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NtbrA/8gCqS9C7b3QW/eZENIMoETd2RyCAICdZTIcUI=;
 b=SWzBOwb3pDfibm1WNsoIyv1HBqnck+KqDKjK+soiixx6+GMT8e6IUDN7kdJ+75jZOf9d
 EDMpnA+sFSD3BeUO5T3jocs2u+bhSWpca9cMQlFzrJpPnqsMF2RUOMnSEIwRq3jNPoRg
 DVARJVOV1nFycxNSv9mXV9aGv49trs/nsnMD/3Q+q07CWFwE92Pbvj8TljfnHQM6+1ns
 uodhfitWEByG4EvR8Fwj2Z8kB3C4aR7MNQekMCLmNHlMbtDl05cLv86rjdSOWGWJMZTk
 AYFtyne0En5EmzqE/K2sjsYi3J/yc++LocszvC+/gNbya49LjT1vy5NqoIwjoIVnmBAz tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmuu08q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5A4Dh149438;
        Tue, 10 Aug 2021 05:20:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3abjw3rss9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVB+KSxHS8V1abSYvzGUAQJsONUHXyfmUxmH6w6dkeieiRPuRYG3Qa2Y3xJjqlkPEmX+cq1MSXAny+Z9BRADD3FYPT1sq5vOk9AsMdHvIsXS9eAP97syhoQ68Alqii0BL1iU8p9mn2uS0+kniO/SuVBMRqZ+T17UviWS+zmTkuko66JHCgB6mIP2pi8npW3wNsYFkaSRc6qMDUeHFPErIvmVbJGnE8d+bWKnLTdK57F/MJNpE8V5m7aKxJCs6Z7O+tn6UGL/0jKjy3SGiy71JR9SkSkJ9AbsXiUeP4JSsKUB4H28USrr6Iz16aGZmcFBaMutZsvqVjWfXnO6Q0Sy9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NtbrA/8gCqS9C7b3QW/eZENIMoETd2RyCAICdZTIcUI=;
 b=dexL3OTDE89QtUvga+xZCJtuuFQkQrLB1IZU1O2IKv5DQratpdkeeqNi/osxCi2oxqFv2gVvoCBzJq6yXg+VPkaZBxduHz7J7k2W/h/lCu2vuOrO7ODccjLgx9hf1dOuxoMcSNAnCOuLPswPOdnJ5TawuQ7hcjQvJIzB+47qB71MSa0UX/cMD6QPXvxi1TpcGPLGy6VRj2bNhHh1kvkuqN64puAZY3MqMNWRlUkwt5mIqzu3yfK+2HwVa8O/csMiK7tSQP1KCvYJ18zq8819IPU/bzyZNXm5C5NmOXVXGTddQhUZoFUnI8A7j30Lmp5hQuXEiad3F4AivPl8OYA9nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NtbrA/8gCqS9C7b3QW/eZENIMoETd2RyCAICdZTIcUI=;
 b=XQ162EHUkRqc/HgKUbnhx50kK3baMaOhcqT1gKo35dyTRtgaKwM1qcCZCQg/iVO02PT2QJTEGLxu2H0UZsVmkWL7J952Pf7/UxzLkXy36R3BEx4b2bd40cXBTN4pEFyWHhYpil3srzfTIO+efT0s/PKS+wipWDsGR34Xjb7/ew4=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:20:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:20:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, cang@codeaurora.org, avri.altman@wdc.com,
        stanley.chu@mediatek.com, beanhuo@micron.com,
        Bean Huo <huobean@gmail.com>, bvanassche@acm.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Remove useless if-state in ufshcd_add_command_trace
Date:   Tue, 10 Aug 2021 01:20:44 -0400
Message-Id: <162857263914.15955.3244425297967301837.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802180803.100033-1-huobean@gmail.com>
References: <20210802180803.100033-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0001.namprd06.prod.outlook.com
 (2603:10b6:803:2f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0001.namprd06.prod.outlook.com (2603:10b6:803:2f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 05:20:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9f4f6d0-f462-474c-1cb6-08d95bbe9f70
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45972FB28CF579D90091F6018EF79@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DAP6RrLj4pO8f1mDRE6NTo3VZ3XxMhpB56lWzQ+3X72Xja6RgfS5E/16hwV+3IEDnKZ2/IXlFOGDc8VjQzO5xW+iwBbfHMkq+gNbLE2kXO3Zmf/MKEXN2ytPr0lSlVM+JlQtmol46QbK/aNHQ4R2qvmGnwo0iKraQXoGHpvEOs+0IxqzzwX44+yBs6L3V4Wi7U/YbPwjaKLjH+oGurU2eT/9xw316q4G3Xw+BiSV2B3qrQzPuVKmGdi2ErxY8Nh38G/WXUlBVT7m3/OLe4jhnTZ25ElDQPJFEPVDDsxylJHnr8aeWTeq2JAwwnfXQmdE8e0xgzg4AxEyg7QoQu8Kp6El2PXZSuKDNycmtSp4nip8jjlqsDhlRrEjLCVtOB1qmABBzdWpnMpYE4/i7lYgViKae7+W7t704c1vbNjTYfVER+GX+Pc1qhvnfsX3fbIR3mXJXLLf59DqiloBVjIp7+iVPOH8HtoxpwJ6McfpQ4EeH6OqhTojYIGB8eQEUl1+0S9xxGTjpkt2lDR904fQd1Ju//8lxDIzzPlcod0fVGjbwtx3XhHY6KHy0tBAeTLS0IPP244NsloTsrTAGNBML1UpblQ4I1ynICIHOODXuf5l5SF/ATClZMDOUgiglCQpYWSAoGGRsysZWMdchj4pgu4W6bdSaAIFwFCXA9leTGr6QHLW4wl3tT0vh+PN1jl9l6rkZq8xX6IOOnxRVvY+5rHME/Qed0IyDCDVK9BVhhv3F4ZUcFRSjz3aaftD/vZazciLAjZzwWch6MrKLlC8FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38350700002)(38100700002)(103116003)(316002)(966005)(508600001)(52116002)(7696005)(8936002)(6666004)(6486002)(8676002)(5660300002)(956004)(66556008)(26005)(66476007)(186003)(2906002)(86362001)(36756003)(4326008)(66946007)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXN2WHZ2SVEvbW44amtEdmhGL0NSVmdNSGIycDJrb1pGSDg0WkhmZkhnQ0Vo?=
 =?utf-8?B?UnZTVitDTWUreXpEU3BCcjFTUWQ1N1UyRGhnTy9DZHBNUkQzSy9HRS80WExP?=
 =?utf-8?B?bWkzZHBTZ1hCcnBIUE9jS3VON1ZkRzYzeEVhQjU5NXBBakRidmNCKy8xS25N?=
 =?utf-8?B?bGJVUC9MQkVTa3lIYmJQVW03Vm1tQmI3N0ZrM1k4ckRsVVdqRnZVY21yb1FH?=
 =?utf-8?B?OFF1dlh3eTNwclJHMXFwT095bkZZK0RPbWM2QzV3R3VZREFQWWo5d1o5YUk5?=
 =?utf-8?B?aWlobDFjYnNwSGRVVlJFbWxOY3FKMWtCQ09qaTVLR3ZqWnRoUDVWVmRSR1Ra?=
 =?utf-8?B?MTJqc0RFaEQyQWM3Wks5NHN5TzJWYWIyS2praENIclBDRkxTeU41QW5WdkZL?=
 =?utf-8?B?QmVRMFAzQmd3VmFrck52OTI0NWo2dlY0WExudEZiWkRKeWJGanBFREd2QzlG?=
 =?utf-8?B?ZU9sc00yczJwRjc5TFpUaTN4bzVPclJFZU42TStkb0hxM0lDL0ZzQ0R1NTNZ?=
 =?utf-8?B?Ui9SdW8vV2lNdS9DYldPUGJYamJLbTNqNWhuanV4MXhVdFQ2TXFMV1pvMnlj?=
 =?utf-8?B?QkNFTy9paXhVQkNuRi9HcnFEV2tObWJuVGNmcHd3SGNmRXBYK0d3Mm51TUZG?=
 =?utf-8?B?NDZrNjh0bVFkeTJOVTBpUnZrVXhaTml6WThhdS9EMHdYcjc3cnFtaCtjQTVK?=
 =?utf-8?B?Ymp4S1ZjNytxL0tsOGhXeW55RjYzaGZCa0NUYS83dFY5aHlyWFpHZktieEx5?=
 =?utf-8?B?VHFvbzZsZ25wekJSNExnMW41VFhYZjBJZTYzMmNSYlVHOGxHMFdTY1RUSGJv?=
 =?utf-8?B?VG9ZdnViNXh2T3lnVlVzaUtJMEcybGlkWm1DZjdXM1V2ak5CWnczZFg5S1FS?=
 =?utf-8?B?RHN1dDJoMENnZWtYT2sxNzNGOVBMbVhjbXZrZGhqa0dmOFlEeUVkM1V4bWQx?=
 =?utf-8?B?dWFyTDJiWERNSCtPOEo0amtMc3ZFRGlTandTYlhNbHlDYnc5c09XQWxqcjlI?=
 =?utf-8?B?MUpmL2RJZ0lYbFEzdktNdTVaTnEzZUMrOVRiamdwQzZXS2lZUjdvNXVqWTNH?=
 =?utf-8?B?SmRpc1BKa05ZNmxqcElVVW14SGw1ZHh2cmE0R0NtamlMRGFJTjNYYXBESE5B?=
 =?utf-8?B?WktzaU5QUTlibExjMnlJU3NpekpDeTQ4VVFjVTk0VncwMWRCMUE4d1duelVa?=
 =?utf-8?B?TVBHVWlCQXNPb0hmdE5mbHNhNFlTYUp4SDltNUVBWkg3UWNLNUtSMTlOeS9y?=
 =?utf-8?B?ak1XYzZ3ZmxaMExQeHVmeFRtckJldnJIQ3V2ZGJxbkxLczN5OGplM1R6YWtO?=
 =?utf-8?B?WmlPQ1NXL0FUL2xjcmZjelhXMGNzWE5LMUFzZ2xNYXRKdXpxbENmMEVrclp4?=
 =?utf-8?B?QTZaMGtGbldpZFJWY2xuclpOSUY5REM1bTl2SlZpWmxleldQTDVnYmhoOXpW?=
 =?utf-8?B?V2wxeWVvcWV1KzVLbktrWmFBVmx2WEVCVmxUSERoa3FUVXdyVkFWVitHd3Ra?=
 =?utf-8?B?Vno1UXpMc1ZnV3pnNkJxMTVIWXdEVXpJYnU1b1FLQWx3Z0JWQjJQQ2tMR2hj?=
 =?utf-8?B?OWNNenIxRkdWZGJoTjZ0T3dzK1VoNmZwbFprdWFUV3JzRGRyZFhYRXlWaUh6?=
 =?utf-8?B?NGE0ZFRYQjhGZEdJQ2w0T2YvKzB5UFRiQ2ZmRm5uNnRJS0U2MWZxOThZQWVs?=
 =?utf-8?B?bmp1eGswQitEYTVEWkpWWjVoeFp0eTJwYVk2RGs1cEUrcVA3ZWdDdkQ1RjI5?=
 =?utf-8?Q?eQJX7+elkn0zAWYtqGQxRVjPXCcumQK2XUY9GHB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f4f6d0-f462-474c-1cb6-08d95bbe9f70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:20:52.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjejArzAI/Tg4uM9SVrtxZqhDemq5mce6slY7u5J6F0orh9QfQsGikARyCabIX9Gm4zICNgETd5LbHJKuYW1LMeuIDxNSf1wzItpqzDcT+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=973
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100033
X-Proofpoint-GUID: R68_6e8a8zn36meBrNtO-XkJm4tp1_P7
X-Proofpoint-ORIG-GUID: R68_6e8a8zn36meBrNtO-XkJm4tp1_P7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2 Aug 2021 20:08:03 +0200, Bean Huo wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> ufshcd_add_cmd_upiu_trace() will be called anyway, so move
> if-state down, make code simpler.
> 
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: Remove useless if-state in ufshcd_add_command_trace
      https://git.kernel.org/mkp/scsi/c/f0101af435c4

-- 
Martin K. Petersen	Oracle Linux Engineering
