Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C1AC43219
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791E7619F6
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhJEEhf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:37:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5126 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231730AbhJEEhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:37:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19534b8F010255;
        Tue, 5 Oct 2021 04:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nH79UpLhvtrVOnfFW+zlOTmFsFf6DCPQEMvZZRmZX74=;
 b=fBQ/SuIak06BNLMo4PB5boBkzexSKnPue4Oel0oQiEAwGV82iRq64ZUENo5s4DGLPqM0
 GWk74ipdVOZmiANnCffUIcN8YNUgcKhpyWRgJPAbhi5DZUsg6QTfSRXENxy1k9M1AO4a
 Zml1WSaOnSev2li0Ec2vNkoJ52Mi61IS7Yr5eYgxMdchODA8lY857atHgUv9LgaZwz2k
 Vbq8LHQ6eb9fFtR2PwCiBiE6X20lKqqF2dkATx4wlRDdZcH1OYKxP0XtKF1G2HAF6Rv7
 NtXEtiasOxGicLCHesbPTf5IiVzBnt9QFS3E2d+9Ss5J210JGPliTtCgBgj4wGOYhcbt dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3upvr1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMa054346;
        Tue, 5 Oct 2021 04:34:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxtozG3VgjGGWkZdPaCrzKcV3qUTeawaLTgfPtnojNOtygl77z240DL6/2Gp0XW1wyaKn5amzbNt/6acBFBbWUQMi+sCVG+zWtWxwC9gMHMJrjB3X4k2WvYyN/gKYQJK3cbI58dMeP6lNqIflpaSxBgHYkhqFEVf6FPHBOm8gu+lRwZM6vMEloNY2faun/QorgX9KnlSdkvknYRgnzMZxWnmo2b8CnHElTmAVCQcuSZXfttsFZMN2eAz15RTxNrh4jASvYOeRwSiT4GrxKQBLVT/0crtRIhMbsM1WBngQNs1rX+TdesZcmctWzNx0WjaZp5wPBOBtHY6SwPnf7YMZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nH79UpLhvtrVOnfFW+zlOTmFsFf6DCPQEMvZZRmZX74=;
 b=R+xp7o1iHrfmDxvzZxym6E0XQoxDtu1Ckf8sRKLFkzlMvUxS8xaDIcxZsehOkidCcKbpXGxsyFaZMmwZ3741gbh/bF6tjxQUo0xil+BQBKcHxY1TpUxodsjBUw6Vu65+GSc/DX5nvL6doAIeqRaI2WTDJbet8helXsRIOfoP1m8UZP3ZyvLDh516Py+s2ycXXpNT6LhQHy2L85gwvR/i9rXzZag5afHtkHk9uIwUnEcW1eLbeRnDfT+Q7YZaexnz3I/1yLm0OZFCO+1D7S5zcSHn+8P734bCenD5gF5XLgK9yEnxkMD152iY/qnS2vvB7VvM/kwLGFBVtSvnZlrwXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nH79UpLhvtrVOnfFW+zlOTmFsFf6DCPQEMvZZRmZX74=;
 b=gbt1JEtjySua1aPG7PlK/ElPgm8Aa3ryUFeHq/p/G2gCuWoPEzOqEJD6JP+7Z+BLE49Fb1Y4ytrLyOhnSn82NJnEj81pGdkSS9RFV4IWEKO/TGpoKmB0tEAmip8xNapn1jODpdRBcnG4LIc0Yu6EtNn34BMSmHwjeccJPGX30bk=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:49 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Colin King <colin.king@canonical.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: return NULL rather than a plain 0 integer
Date:   Tue,  5 Oct 2021 00:34:33 -0400
Message-Id: <163340840529.12126.4973850088173843604.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210925224113.183040-1-colin.king@canonical.com>
References: <20210925224113.183040-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eec2003e-f6a0-485d-dc43-08d987b97782
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950B40D38980859A161F2EB8EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXR60DtSK9Ayq6RpsGigl16Yj/+X1Gm1A0a1cNx2L3E8ZhbzkXSGkOz65P1EAC0l76brTCgvYMAv2lQzpX9RUkN2/QfveEGNyE5BnoPVBqPWl7WqgPtrWK+9a4LDKvci3ls81BcTHrcHjfyN/kKKUsB7Ezf5ywVYkTGQonbX6OgyvhO+gSTiwdNus2N7bpoCFhCQ6lqCmVA7ZJwYuxLisT0x3wSCPEZwyWc3SU/5kzchurdLkeDIgGW0Y4qXycLnetxXhLaYenPv2co3NMDtGTj7czEX/EFvCx7dbFJrlePQqt9y2SqypsDwTNcMspP4L3bhQzlYsJJAeytXn4Yc7k+cNEe1H/hBtZ+r5uckyR1kxwVxFCaIh1utBHA2USb+d+4C4gnFSn7yLRcRRkz+Bu7N/uYbvE8XHbQNUAURGXZ6yDRwSh9FQGRkf0tQQMW2CBrxAvDdrXdXSN+D3K5XadWwX+dAXbSCJ9VTjb6UHO43SQLjH53qMEoDWX/N3vz7wahf5fEx/CNXck+ETCVwBN7kF9sHMcLBcC0zwIiotIUywAdztJjZA3TNt77srMhTl1SPn1y5uPv/wSzEsimU1G0eWvqd+NxndGs4AczPFK//52gudv8FOvSKfnUaI61aeRBoxAAQ6VFo8/BXYX0vNvOAVRrv8gjd3m1+BHc+hhizu6+cq3uXNJVDMaQi0zqhUhGuWML32x2mdp1sTIrD4ZOAd9uuIYU5EF5VrmB1CE1yonE5hMiOcMJsLWjhjt4KnXbtoRGRkbLk8nVyJWNGkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(110136005)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmU2bkJmREtPQUVvVnFuZEo1c2xRbHNic0RsNzZQZzd5SEFVR3NNU1FyOXND?=
 =?utf-8?B?Vnk1bXNLdGppQllwai94OVltempibkRTT3lqZ3p2TWs0c1FsZUx4YzlldWFS?=
 =?utf-8?B?TWRhMmk5VXk3bmlBb0JUV3pFUUNuSElLcFdIUjhBVWJvWnh4T0o5MGxQdEtN?=
 =?utf-8?B?YmVHTW1KY3E5NDdCZ3hxZ0pjeWE0cHRMRzJWM1EveUFOZ1JXWld3YXg4YndJ?=
 =?utf-8?B?QzJ5QkJkVTlLREx3SjBlakFkWlFDT2c1ZEpNa0FWbEI1d3pQZzBtRzZDb0pW?=
 =?utf-8?B?SEdPTlI4Y1RtOVJxVkxSM3ZrSHZzdWFULzNQN1hsWldscE5DQU1TdDZLRERo?=
 =?utf-8?B?aDA5YjRHV0wrQ2UzR052UWY2d0w0WTRGdHNCWjI3anJuMnhBY3AvcUgvWXdX?=
 =?utf-8?B?Q3pHcDUyaThHOXUrRURZcUVxaGE2YmdaVjdFdWZtNnJZZWVJRGwvMW10ZDFX?=
 =?utf-8?B?Nzh5YzFENFVCMEFvbW5kenFVRTNKVTNKdFlUdzJWZ1E0VzAvUVNRbkFqTEJR?=
 =?utf-8?B?aHU4MTZ6QndSV0l4UUFYdHVJL1J3SUtza0RqZ1REZ1gvNDZweERCN3pKSFRK?=
 =?utf-8?B?bitUY2VnR1JRSlphRm9tVE5wTGMzRDlyOUJVRnNyVDZDcnNZRGsxelBFT2FM?=
 =?utf-8?B?WXFnNVlKSWJJSmpjNEliODhEYW5sZVhSMHFIbFRBc1RqTExEek1WdVFEc2dL?=
 =?utf-8?B?NnMra1NBY3FEcjhja0RSMmFnSmZnYVhuZlgwazQ3TzhrL0RwZTg2d3puYzFz?=
 =?utf-8?B?ZWNQYUpzQjNqdll4ZmFRcEljUVhNRU9IMlFaZ3hKenBGRkx0NmdKTGVTOGw5?=
 =?utf-8?B?dXU1NFBhaCtPdGY2bEIzTXJJblJnMkQ1d2xkOHpPWllTU1lRZSsrd2lzc1dN?=
 =?utf-8?B?V3hmRlk5SVBSYk4vWjBFL3lLV2lTbnptWGhGanAwQ1hVc2hKMVpYejJkUlNu?=
 =?utf-8?B?eEtEcGF0ZERZdWJWUTFDQTZsUnFQWUZtQ2ZCd3FzbTVIaVBYdFB5OVB5eGdF?=
 =?utf-8?B?ODAxSytkM2xaZjUvYkRaeDBtbGdtcCtrcUp3cHlsVmlqUm1oWVBDZ1NpMEFF?=
 =?utf-8?B?TmhhK29wZFZWUEd5ak55aWFuL3NGaXZiQkMwMlgrSDlGOGRHQ0lhT1BzL0xu?=
 =?utf-8?B?cjMyUFNVSkh0M3MwWnZtZVJyOGlYRmZLeUNYMEVha3FUSjFITzREeCtjaHZT?=
 =?utf-8?B?VW5FdkV5MHVtc0ZQSFloMjBMZzBlamZNMkZkQTRKUEo4cFpKMjBxQTVOQkIr?=
 =?utf-8?B?MGdUcnpETXhCaVpES2NTS01NYXpyZzhGQWU1b05SUGovRE5YZkZCUmdtWW1S?=
 =?utf-8?B?Z2hUTGRqcnVCeWVWY3lVM0dVWWFHRS84ek0xUlZMWmc3RmRORWxLMExjYnAz?=
 =?utf-8?B?Z1hETjg5M1cwbUVQZjBHYWpHL0ZUN1oxZU50QmZteEFWeW9HZUEvN3lnUjNM?=
 =?utf-8?B?OE1XWEVKY2g2cXlKUDVacGRNeCtYR0NQeUVvMDBVYUxDZUZxajNHWFRQUDE3?=
 =?utf-8?B?Y3B0WnljYnhwR1lGMVRFRDhnSDVwVjRPL1VFcFhPZkVadElQZEZtUnV4Nzlu?=
 =?utf-8?B?c24wZkh0aUE3UkdlVlV4dWVnVWdwY0Q3UmJZN0xRQ0tGcThIYnJkYVlGMHQ0?=
 =?utf-8?B?YlhmWVBGOUhwWU1BZDVtczlpUEUzK3lJdUdBUk1EbDJTVnVsclI1a3B3SUpX?=
 =?utf-8?B?eXk0VWFtakUrN0hORWs3YzBXWmFRbGJKaWlrT3Yyb2NpdEVxa1V3K2h2RDYw?=
 =?utf-8?Q?E8CSbJJDJ5M/vadcnXynjZveAc+wQHxyGyJiPaA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec2003e-f6a0-485d-dc43-08d987b97782
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:49.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fTCKCzIAnQzgQEtoZVaBnYaJLeFRZGgATikOzD0j0LHKD7Uk3sAdzXh1OxwzkwT8y2rEdJ8Ifoz/2ITCbZVSdDuFvTYWKrHybgai18r6cI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=955 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-ORIG-GUID: 7Z7uFWEEJbWHFK4t_sBJj0aVhKOCHgH5
X-Proofpoint-GUID: 7Z7uFWEEJbWHFK4t_sBJj0aVhKOCHgH5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 25 Sep 2021 23:41:13 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Function lpfc_sli4_perform_vport_cvl returns a pointer to struct
> lpfc_nodelist so returning a plain 0 integer isn't good practice.
> Fix this by returning a NULL instead.
> 
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: lpfc: return NULL rather than a plain 0 integer
      https://git.kernel.org/mkp/scsi/c/5860d9fb5622

-- 
Martin K. Petersen	Oracle Linux Engineering
