Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1DEC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A17CB6101D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbhHJFRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:17:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47960 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236318AbhHJFRb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:17:31 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5C61k019330;
        Tue, 10 Aug 2021 05:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qqHoy+BbHNhVhZdPRD5XngDNI5u9+JdHeV2b1qGm0FA=;
 b=S0SFJvRFsrEdS+1aG969tMqzCngLvQimMBfGmFc1UYSunh2bFWZNrTbBSZ73HRceY7GK
 V00FsxzLTMxi4HJMjaI9SbQV/uRcwrD2Dy3mN4TnW6iHC2qjDTvQInM8zeQH4Bsv5vND
 v15CmgDwWSxcHM/5xS5zKBIBNEXsCYqCix6bd5H2eOrUmv3kTg/IUH/3tYpSLuAbXNe8
 jmHu7ZpGcD0niMTCj5DmLbYvcX22HJSj49TGz5sV5AvkWhRsaeXAYtxGKgDwsKokU0VM
 9lnPE7ToM+iSenMyNUojxKY7CC5GzqwG5GUQacbqH09H+YU7akqRMG33Vs0LtJ6NdHiT 3A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qqHoy+BbHNhVhZdPRD5XngDNI5u9+JdHeV2b1qGm0FA=;
 b=wDG9PdEC+jaPhoXaz5kq9X6yBfxKoEAU/UmL0CIknZUCnlMtSWvZcMJ3bGJdG3rwMhl1
 Au5MquEV5f+uYt9OEw2pyFUPzH4VL1czRQQT68M1ZX67p62Lf10ErtvJn3jq0bCp9Y6L
 lENpIp7XdtgInfMDMwmVN5oErsulTqsPZBtTLUwSzdIktG+LSwv0Yynnvhmou6DLawHm
 tqPm5e5hmKklp48rJxrAhNZaiMKYe6mqgbSjyUjRfd/dApKguW47OyWp4ulnqQPAuVfw
 ZUHVx7USPAbgYHI6YlzaeFBH9E3g7dwRzD6UxWY1dvDMuAC+AtbX91b2JY0/hkRiXvHE dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0ftna9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:17:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5ALhU101125;
        Tue, 10 Aug 2021 05:17:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by aserp3020.oracle.com with ESMTP id 3a9vv42xmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:17:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MumLAjphBYGfuNNohWNVw5NE+2Zu0NQamZhZ3evvwNS4mDhkQ2aavMMW1jNEACmMEkbL4ItpbPe6rwNIfVJhCon0CKB5x0inPj2YG3jLZBBVX+d4wdNDDhMzWxZwJS8RjprzJejC0UJ+B6Eu9wPIGJXQvugEzKcmUHiqIdHkuAODkhiaKI8wbsfPj0fLWlKyq7Qzcx5A1OKhTr+tmx7lzNGbZqTRHMOQ5SpR1huuHSag+FBva4AGDpCM5lRviqSjCw+o0TbszNasa5AyUbP8mxVPmVWE7MEn/CW/ilX3ZUqJaQEvTJ6wf50j+13JtMmCwiXKGUvMTNT9R7PUGFWVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqHoy+BbHNhVhZdPRD5XngDNI5u9+JdHeV2b1qGm0FA=;
 b=dUKDMGfmsaTTxOhBLNQhSk+ICr8mopo6Gf0wSVlLDhl0Fqf1KiRuX2EhAVuM3OSURAS3D5KuTQNqTqYQMz79C4Ri2YqlU7+WIKE19wxoU44dhRZlKVpXNk5bcp3pxnYYnIEB6kMGSnJLax8vPrUcbpCPju6YJwsb2NQ1x0ucbJ4w4EsajLIaTGaDWID2urmBCUL3qspZCVWzo9B2BTbZyNXCkSoAjQCaqwf2smreYjIjGyaEqSRgHEe0APYwl+VKXvnwYExuNbQKFXBIn1O2AajTNrhAOatQfrD+hcQhBz4LkondGemkOqbt4C/yZvTBLvQ6EklhMJheqp2kPzfgeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqHoy+BbHNhVhZdPRD5XngDNI5u9+JdHeV2b1qGm0FA=;
 b=AAHrYpxFa7vwBbGYdafIyvnHF2nXWiDMlaT4p7D0V6vmrgkeKyRbn3Qj13+czlICZNLll5NswVi7/OLlU/OFDDn/RZHiDbTXmOse9/tADecB75yVEnsspUYwrit2DHKLDGCGi/EzTb/SbQcVZf0GXWXkufii6galLGPGHaeP6hA=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5580.namprd10.prod.outlook.com (2603:10b6:510:f4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:17:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:17:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Colin King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix incorrectly assigned error return and check
Date:   Tue, 10 Aug 2021 01:16:58 -0400
Message-Id: <162857260240.5447.3970232883623374421.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804134940.114011-1-colin.king@canonical.com>
References: <20210804134940.114011-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0112.namprd11.prod.outlook.com
 (2603:10b6:806:d1::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0112.namprd11.prod.outlook.com (2603:10b6:806:d1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 10 Aug 2021 05:17:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac03e008-9fe6-4192-b661-08d95bbe1714
X-MS-TrafficTypeDiagnostic: PH0PR10MB5580:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55808DAEC89DAB6D10BE88548EF79@PH0PR10MB5580.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5PGGSHH0lKouUxjY1FR1IY3oD5ZZZboEz40YNmST7WGmeTRGLxekGLMK85PyLKHxe9jI4D8HygUhE9PICn8j/oZV6y0FcXQJzsRFLu7GE/Z3wAXTALk+qnmTNXOfnMt25b+pWuu6uuww+8ORFfPlDJVl2kDWOKVsoA1kbFjDRIqiOgOZzA+gdm7i1CADkirHz68IH4gri5DIXXmsTkHEtUlFECYlIcS5otklDAjgBkP5CUTPnYVaj/2ykoB07tzpE6WCYMRJhaivLxEDwXWYSg6gkXtS31hlxPrfqOR64b61ManKaLY7g5N1YCPoiCxBxjvNZaCXTDEe6LAAt5tuKxm94jn/LJdvrdrSBqKkNMx/HAkI/u0bO1VFonCuX8GsSRISJpDmSXOh416r29vphKTt95uYOgipwpPrW5HBEndtVLnQ6Q6dqJ2UWSTAu30Vrjioe2NKiwM03PQDoD1XEUSk+VHZ+mX25lInQj3VKPtVpp0KxpwF0c0lIVeuWyzWEtA5jGRp53sRyp9Jp6nsx/KnkUjd2p00SAn17R5ySYc6A+Xh0Yp0RLtyZ6TG79VzRXDuEqqMmrbTz38T0C7Hyw3D0jD/DIVGV1NegP5hIXBw+lZnX0y4/IqJfCBpaJOd3Ual9aX/+0JPcfA7d61wG2/X6AVwO+7ck/Jo/KqIMqvjIN7dn/IpbzBtYTMKUyRrHj2FxVGsKMpcPvW4pbpzjxJadk8Fy8P0BDTvWpmcqLpmNuApBJur+agGzRyOPOj48DsMfvYZJwWXonB7MoD8D4Exgz5/cYdeI9vsOvlw7JEUKNsCgA0c/HTuqI1owjJK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(376002)(346002)(110136005)(4744005)(38100700002)(83380400001)(8676002)(316002)(6486002)(36756003)(38350700002)(103116003)(2906002)(956004)(2616005)(8936002)(4326008)(966005)(66946007)(478600001)(186003)(52116002)(6666004)(7696005)(66556008)(86362001)(5660300002)(66476007)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckhSNGdicHhMdk9SQmJoeVZzalNYaVJsMDFjR21jNEZGTDBwZmhuWUxyLzhq?=
 =?utf-8?B?SDlnKzJxVWhzYi9VUnRLN0w1VG1heU8xek85Mm5kTHFhL09zMTZISS9xRFdZ?=
 =?utf-8?B?NHNwZkpYVHlobVN0dExkSzdMV1IrR0xLTnNnMldMTk9sN21JNnRvRVdXcDcx?=
 =?utf-8?B?aGdMclFVZDNUV2dmYWJWcFc4dVVDRlkrTG9sUzMzemtvUVpnL2lDeDc1bGk1?=
 =?utf-8?B?TExEK2REc2VtcnJwTmpvVC9vRzlqb1NEWUhJbGpTWHM0cVhnN1BkTEZIU1M0?=
 =?utf-8?B?WHhudmlxYiszMnZ5ZGNQQWN6R0JTK05tVkhaL1FOS1hLYXV1cnRNU056Tkxz?=
 =?utf-8?B?U1g1eVNIdGdGUmlFVnJ1cG9GVWZOTTlhZVZiNjc3cUdSTU9VTVJ0MTliN1dM?=
 =?utf-8?B?V3hFV3FrdEVjVVRFakYrNFFXalF5bFVxNzBtL2UrSm9XQ2cyL2lPZkkrSXVj?=
 =?utf-8?B?SVJPNDVEa095MHFwYW5ZVk9rY2JKSkpYbjVhZjE2L3JaUW9KY1h2SFVsNlRS?=
 =?utf-8?B?S0xIS2hUcUtydjBiM3hUSjRWNU5DN2VYaGI1dkZ3MlZaSE0ycEVTK1VENG51?=
 =?utf-8?B?cFJuTHFvbllzSS80ZnhaK2c0cE5WSWlsNlROa21yT0VXSUxwdUw5T2M4L01l?=
 =?utf-8?B?UWIyVWZTRnZ4VG1oN2tGMW5RTEQ2aGJ1eHhVTnd2QXZnaW5yL0tXRzU5Qk5X?=
 =?utf-8?B?djV0ekg1MnhmdHJsUTVERzVYYXBIeUJ0bnZmNWhjcCsyam9iV1RhL2htNWFt?=
 =?utf-8?B?WVQ1K2hnYkY5RXBVbzJ4U1h5bUdxamw0NnZxcWloU0pOejFXVzZEMG56M2t6?=
 =?utf-8?B?OXVhRzhlaGRub0xqTWxEeDFvLzJ2K1JYeUROTDQxWXgyNmNwSzhERlJ4K2pZ?=
 =?utf-8?B?U3EvYm1ucHF2SSsrRE5mN1lRWjFzWGh5ZGtpMnRGOWkvbXdPbk05Ry85ZU9u?=
 =?utf-8?B?QXBrbEtLQ2dHSVFLYmR4dWdraEU1alR0MndoNEUvc1Z2Y08vd2xEckluUVph?=
 =?utf-8?B?ZVhpK01OdXAwWGYzajQ0UEZaSnZPNENqNFIwNG9iYlYxQjM4Y3B5YThhR2l3?=
 =?utf-8?B?NmdPaWFzUVRLTmV5dm9naEFEU1hDYzhoS3ZZZWlYRThkWU1SaW1DMUZ1Qndk?=
 =?utf-8?B?akZIMlBONHBtZ3hNaFV1N1Zwc2ZrNmJCdWxnVHExNFV3UHlxeS9pWWFuT09v?=
 =?utf-8?B?TWVrbG1GMXZ0aWRZaEFjellLV3IvS3pzRVRQYjh5SG53ZTFLOHN0MERxSTVv?=
 =?utf-8?B?RmNWV1l0RU00VWt3alBUKzNwSVBLSlFFdXpSYjRXNW9DeVc4YW5XWlh6UFR4?=
 =?utf-8?B?aXBzbzBYUUx1U1VML3M4bm5iTXhzWHRVZTZKcGVKUE9nQVdxL3BwQkhxNSt1?=
 =?utf-8?B?aThJVTF3UE1OVzJ1STBnZ2M5Ui9LYWtLdmoyd2IxQjVMa2xNaG9uUmhtdnVH?=
 =?utf-8?B?NFM1R3ZJT1ZGaTNFRlc0UEw3Qjl0VnBOZjdzK2JnV0VPbWo1UnF6ZG16N1Ni?=
 =?utf-8?B?WW9vVGdVQkhuNEg4ajltemJ2RTFMQjd4d3FaSDkyMzNyUllGN0J5Z0crbHZw?=
 =?utf-8?B?Y1dYbFhGTCtMZHNLdVJERms4Vm11Y0dxSWVKZFBUTkUvN2VnOGVXZDJQNmZK?=
 =?utf-8?B?R1B4SzR1V2E1UEpLL0RIWTFlUGtnMnBzeTRkU3dOV0dxczBmTjlBby8ra2x3?=
 =?utf-8?B?b2dYQ3hWR3lLN1p4NnpLWFh5aWdtMDB3YU9BeStWckZHT0xBTmtoTzlKN05w?=
 =?utf-8?Q?GpnJXAhW2iywNrqMDEZXsBXo51hSyXBaOflqG5Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac03e008-9fe6-4192-b661-08d95bbe1714
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:17:04.0535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HF3evYk4Lhzm8nXqdBIwDmrXuwmLNex0atpyCdtdNgpGcCKSoLi/dP+Ci+P591YTz3klfi/egNRyfgM89mz8O606qeMbDdJmCdv1Sdi1lzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5580
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100033
X-Proofpoint-ORIG-GUID: lDbfMYOGfCpAlPMQqcZESy7p3HAzJQ-W
X-Proofpoint-GUID: lDbfMYOGfCpAlPMQqcZESy7p3HAzJQ-W
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 4 Aug 2021 14:49:40 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the call to _base_static_config_pages is assigning the error
> return to variable rc but checking the error return in error r. Fix this
> by assigning the error return to variable r instread of rc.
> 
> 
> [...]

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Fix incorrectly assigned error return and check
      https://git.kernel.org/mkp/scsi/c/40d32727931c

-- 
Martin K. Petersen	Oracle Linux Engineering
