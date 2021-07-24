Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3C6C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 758D860E8B
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhGXBe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:34:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40896 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233752AbhGXBez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:34:55 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2CfHd006531;
        Sat, 24 Jul 2021 02:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9CnETXCoXfv+mPI0IY3JOS8tkksR77JLOGalHLWMSes=;
 b=kYxS0xC+ytClUQ1X2sg2CSBEd6erry5/j0BEj2gMlF41WpzABmwAD42Z1mkAzULXV+b4
 7l3NETDdek28Ag87gmg1BP3UNgG1AgIeNBQsaR1QFitswp+UaltEtT8YVh6BYIJkUt4z
 ll7jdyLkrV6ig3kE+TrLMSOOh8w6EsDNJCpy5SiWGt03GkQzYbQRJKPekvoIfh9jiCKr
 iAUxs5NDl2bDSB1j1GBoQG8tu3evuUJPkIe/GVRxc/TZScs9sqcVh3TxTjEn7sBGGI1k
 L7ZC2BaPvopTaIk+Ihaj6s5E5iCIlEkoceFhfU2Xh+x0P8jfCSJKs8cCxRPiFnkUCGca /Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9CnETXCoXfv+mPI0IY3JOS8tkksR77JLOGalHLWMSes=;
 b=gys52lS22ST5f5yAE69sWlGcq3SqxUw1Hyd//GlXPVeIG9l+cqS/kvFxQxITCyYppFVy
 9uA2b2b+LpjcUx3z/ataOi6naAzrvnUGp92i+laeYdiHkrbrJoiQJvlFRMV8PiWVJNWw
 1PFJlzI0bIxYcSDPzMjJs66MC5DYo9p84pn4wlybX96xY5HlMzqL0QOn0z8lT+qpAIA+
 G90lqyMc+SMGd9JGhvR8QT1GbAIVgRsecfJrSitN8IXD3r7QC1jpvdaOG1bX8CbpZADk
 UqHSbbT94JDDtZ14wYuw+5Yw/H4L3G+U70eYSjHm6Yo+KDjB4Sm1bf/zS0olyLstpd5R Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39yj7fjc1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O25R3p188062;
        Sat, 24 Jul 2021 02:15:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3a08wb21gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGpoTVKpaje1ot9pLPFNd23QLQcTREoaAKcNnXYv2WZ4MLt8btPM0dAbp1Z00AJQWpw532kTJZruXOkCChMjeT3npZd2xx8hfoXSlPm7M6M8whR9IM4gHg8PSL4LK3QjBoxJs91isLepXXHr1vr/bTNRs8L1NOUvVOKw2tr9M8tA9D6x1E9EkVeTdRI4UVVBBSatbVwUCM7dQWDpZ38BtPN0joUrnV+S90+45aIrXVUYwmIkiNPoeeCoHto6MW63wmJ7mmzY5O9LGpYt8Rmx9tApNR5OHidYNc9H9Vtf4GdyoY85m89xvRVY8bWoIQ2qnjua008nWCOE8KWcUnrc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CnETXCoXfv+mPI0IY3JOS8tkksR77JLOGalHLWMSes=;
 b=Yv6D4uyQmlKnS9DorkzOkDH4Y58yYN0d2XStIKLR+714sn91sSc4++YKmJxoN+osPLJ1YcRiJsLawR0svP8psb56/QMwA8VLVnD3y8lIvWdlQEBGVNFqVmjaoQofPnLm471Pm1eDPx8fidWtqVuJpV1TW/IYSwb3wwvEzmw5De0181/Iy/k6BH8Ct4xZXgTNiMxClDjwbFXbHXnjgCM8gSLa7UqAp1rn6XRFCzQskG8rrcxsYxrvPEZMIAIhnHrCizSKyWmNAOhOlNiu3dCOAjaHvoCPJT8qFt/Hi4wc4Vk6HTL14tfOBqs9oQ+MDmjQqAslcWXVE8OWOVZGVNHtRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CnETXCoXfv+mPI0IY3JOS8tkksR77JLOGalHLWMSes=;
 b=I9+8KqjmtiivhfMg8OmndEolKn0pArkLgy1H04dBseCgd1sOQZQ7tz3nVyWvJlRhV3Rkf4+MxyNUQyqOGtg7iQCtctm+B3lWsqDtvZsVh5j7mNdC8f/BsfnVpx3nKrP+CWLNPBYAX93hWj844jjojCkcy8560XNbW/tgk5V8EhM=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sat, 24 Jul
 2021 02:15:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:15:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     avri.altman@wdc.com, adrian.hunter@intel.com, bvanassche@acm.org,
        jpinto@synopsys.com, stanley.chu@mediatek.com, satyat@google.com,
        jejb@linux.ibm.com, Keoseong Park <keosung.park@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>, asutoshd@codeaurora.org,
        joe@perches.com, cang@codeaurora.org,
        Kiwoong Kim <kwmad.kim@samsung.com>, beanhuo@micron.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
Date:   Fri, 23 Jul 2021 22:13:53 -0400
Message-Id: <162692235522.25137.16055407630853050493.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
References: <CGME20210628055801epcms2p449fdffa1a6c801497d7e65bae2896b79@epcms2p4> <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Sat, 24 Jul 2021 02:15:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c488d39-3747-4f4e-8826-08d94e48dc27
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB464788612C985FC28A649DEE8EE69@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NTlq+4GPaMgbJwSLua6RYdNd2UzjsdHgaVSk+o1gVJMTKzp2dzW+30ZU6tkGllpfA/Ff/XPBVpwokaNW7KWLVC/rK5fqe9RmeIftFdVBO8hyCN3QgxqPRpaM5AbpabLWPSQxeNuhR9NFtw/BgN+fkVZUYSLAaoiHxmpm0BEpVhgcR9dCOphUOuelhYZX1zYBrKTRSGIg77vR/tFzSCkI8+W1NnzKRbQ/Sx16oL/Oo0IJXHAIVIS1gWT4+6fBX4q+nlseRsNgN2tG2rs4bNWkTbpFlPXETOAWrkbyeU8/DvdUsAfw//lnmPwgPHlisF1jcoorbcWtqMpaaVbMA9Plw2Ki4rRJAJPHKrDzkrLvt4/cTi9MZSUOSumsJfjC6wcrA6C6gXrkkE2QSQOyLAoK4nh5jRQB29T6CPdt45W+5ZNu9vkifyDLtlSp7wgFGO37gegw/IdjrPEZ5g4Qj25IC+bE28cqDDTf6IMPCrMyVil+/dZypy5pMNu5jCqEpgOEvsVTpG4QC/e1MY2yoXQ5CDGpWU9alnyFWsNLgHxCrPjMjfpnkAIH7XZ3tmqaMfpor5O2GFtPyXyCNfzR6N7G5vtGOTD3J6sDI6G0gxHZSRP+OTPelKs1egvadN3K7Ovcipo+0VuYlhZff5jzMjUkw8rALTVpjn3gbUIw2zeFgltp1cBm4cHyNWBGgrvR5hNuNadJNHkfXW3YFZY5kNsq+yNr5rlJySiFvKQPrTKyZ46VF47PBGEQVOkEr0fsM6nSDQeApoC3SZbfrbe3U1+LE+n+NIdBKLMiQf7DKQNyOfzgV2dG51OiXZD7BUmkjPaA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(52116002)(7696005)(110136005)(5660300002)(107886003)(4326008)(316002)(6486002)(4744005)(38100700002)(478600001)(921005)(6666004)(38350700002)(86362001)(956004)(66946007)(966005)(66556008)(8676002)(186003)(7416002)(103116003)(2616005)(66476007)(8936002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW9uVlUwTmN6R3owTUUzVE1vbWlWeTFWMnQvdVl2anJwbzBkQVZVdnVLK2Vj?=
 =?utf-8?B?NHVNaE9kL2h6MHBqai85ZTBibzY4bG83R0NiTnRZQTZRT1dvK2lreGhCZENt?=
 =?utf-8?B?ZWZHRTBDU0hwWDRSTUpGMm5SUkdVSmRTWGlZRCs0ZUFZdTVkcGdkZWxpL0Y3?=
 =?utf-8?B?ajZiejdDU21UMW9xbkhIUlZ1dnE5NnlnVFdDZjBGY0xhYnpRcUlzcnRpaGU0?=
 =?utf-8?B?TVUzNjYvWG01ZHZPMDV4TXZrWDBjK08rVXhDTndsT0dqZWJ0SncwQnhZK3l1?=
 =?utf-8?B?ai85M3F1aitpQUVjVDRSWjZGWDQ2dDhlZmZ0Q3BYRnpYQTJ4bXpiK09Ta1A5?=
 =?utf-8?B?QjFweVdDamw3V2tQYy9FQnBmbW03TnplVk9xVUhoL3gxclFqTFRyNDNLRXBK?=
 =?utf-8?B?QkNzQk1jRi9hM3Z4Zitqc2RKaFdUYStEYXc2QUpnc1VJRlBIR1NRUU50c0JK?=
 =?utf-8?B?SkZvT3paSWpndzJEbDd4WDZlSmNWUVBHK3dBNzFhQWxBckY1VGNtTFRpSmRj?=
 =?utf-8?B?bFozeWNVbnh4MS9rMVBUbzQxWUdMOEVEQkIxYmJvUFNvTDJWTGdmRmpubWMz?=
 =?utf-8?B?RU9hdk1INkdNenkzYTJ6QlovQnhoRUttYXZ1bjIvaHlKWVFHeit6K01RUEhB?=
 =?utf-8?B?bTh2MTlmZFdpd3lhQlF2dzBlcks2a1JnVHpJY0s0SnVYaGV0c3BrZ2ZsZzFL?=
 =?utf-8?B?bVFRQlBkVEF6bklnQndxWEloZERUL2pYcGY3VndiQitMaHVXdE4ya0xrL1hm?=
 =?utf-8?B?U25FSmExUFZqTW1RZnY3RE4rSGhRWDZoVWo1SUFxdlNxSksvTXpGa3RMK3I3?=
 =?utf-8?B?a25xNEpHZy93RStqaFFxcWVJSmJYbUEwOVlZOTJJcms0TFdvZ0V2bmgxRWtO?=
 =?utf-8?B?K2Z4WlJGbUZKTXZYN2NodTdHUmRaSHIyREpnVzRicEM4aFhRK0hvRUl2RXFD?=
 =?utf-8?B?VVFuaTl1akhqdnVmcUIvSG5jbTRIZ2hzc2JJd2NCcGI5QlplbHVvTWhLMXZ6?=
 =?utf-8?B?OVNGTUF2Wjc1YlZGbnBWOFRRblhMVDg5UkNmRnI5TTE1WDV1d0M2U2RBcVFI?=
 =?utf-8?B?VS9JSDFtdmg2VjVEL3F4RzN0MFVyeVAzSzVseHZTdEx4dnNQWkYyaHhuYUhK?=
 =?utf-8?B?MDFLSk9DS1U2eVM5UkM4OEJaZmFWRlRIMDZYRmNzeEZKak1VOTYvZldQS0p6?=
 =?utf-8?B?c0dGQXNld2pxQitMbmhWd3hhZkhEMk5pRFBVQ29sU3V2TkNnWUE4c1dwemR6?=
 =?utf-8?B?MWtXekEyODZrdjZFQUpVL2FUdElNd2dBY2pXbkZ5cEsyWXdUbU1iSENEUWUy?=
 =?utf-8?B?dlp5dE4ra1AxVVpSYkhLSEk5cnR0QlJtcFJsVW9PRTg2Y3ZYdnV3VzZiamc0?=
 =?utf-8?B?UVZ6c3hQTjkza24xSENaWVZSVUp4SE0yR0dZY0tPY3JyY1ZSOVV2d3JlSFAr?=
 =?utf-8?B?WEdLZWFqMmovNFYwT1dwbjVvWDl6TlBpckgrcTcrYWg0Nm0zZ1ZzTjVOSitI?=
 =?utf-8?B?bDBmdFFmNk5RZlB5RGNDV2ZvbjVwSmV6M05WOFlsLzZsRlVOUy9jcFpEUzVD?=
 =?utf-8?B?VlZvejd0NkQ0MmYxWVNJamV3QVAwelpYRzNWYlJ6eVExSVBrOEQ2K0lnd2hL?=
 =?utf-8?B?U3NnTWtuTi82Ry9PZngvQWt6NjBtY0ttTnZPK1pLbGh5M2NQSWxBVnZqbCtq?=
 =?utf-8?B?TGZIT0FOWDY1UHB5cGNWVE1OTWN6Z1Y0UjBEd2FoTGhMMlJST3BZejltb2RJ?=
 =?utf-8?Q?uz6iEQkv6gpxIJgRftSY3RHlSqVXXrEMYkQVcn5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c488d39-3747-4f4e-8826-08d94e48dc27
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:15:09.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wUKEd6LZDeMqGdRMFo4kgicfNrDv673A5Pp5FI3zIVTRwAYbAuikD0+5YzXvZYjSFK7AFxbFui1X9UDJpe0AQiqsFQj1v70okFVAGaQiYDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240013
X-Proofpoint-ORIG-GUID: jgq8WxUg4-b2TwjCJT_ubwuX5StjXlA5
X-Proofpoint-GUID: jgq8WxUg4-b2TwjCJT_ubwuX5StjXlA5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Jun 2021 14:58:01 +0900, Keoseong Park wrote:

> Simplify if else statement to return statement,
> and remove code related to CONFIG_SCSI_UFS_DWC that is not in use.
> 
> v1 -> v2
> Remove code related to CONFIG_SCSI_UFS_DWC that is not in use.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
      https://git.kernel.org/mkp/scsi/c/1c0810e79cb3

-- 
Martin K. Petersen	Oracle Linux Engineering
