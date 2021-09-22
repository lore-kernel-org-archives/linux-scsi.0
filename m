Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B4BC4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4D461156
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhIVEqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50100 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231684AbhIVEqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:38 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4QgFT027984;
        Wed, 22 Sep 2021 04:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nwvf8Klh2uQtEdk6NW0Fctfykvt9cJoiCT2W3ljzxOI=;
 b=ZttyfjIz2HO9CHgDGjaiwqj3+q3VRf/2D44sB0rqdoHuEzfUNsycM+S9s1nRDaSPv6D1
 uTPoD0su6zIR1nogovijBea8AXL/dh5qOqtT/PaCj64SAnJWXFJHqSgDyUUHyra1P2U2
 m+LklG3t39cj1I1amqUfS/CmQgvaRp508NdBE1HnREmygwvT0ibpxXsweYq7/dYTO+s6
 fCv9UY8sqm0algdOuDZbT9L8J3qxiyF/647CTCacklFW8XavuUFVY8RTXz5UjqO/Anfb
 Y9yM+sQi81s34c+q+ZL6rtCgGtSzRSzrOdHKlBHcWb6Q+8uTjcZ1TPwclg6NWzbyAKSq Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9d75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4ZZLk145589;
        Wed, 22 Sep 2021 04:45:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b7q5mc79u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8/jPgEu28dDuLeFMsl20GzVt46qYx6GwBE6XIyqC9zpAJouP6i57C+SQFPauWtIsM9BXMOwGvjZRYpAkPV4XEIpX3d62OODP6Lt9yDVy5qy18ZD/weSkiLQLGiO7X7EtsPAiztkARD90M4DlgXH/gOauwej2QOERItGJ1XwmLWunIZo9RLEj0oIjdF9wIes4ADEptOccZJEs26jQVvXDnL12cIBP5qrJ4FVKsqI3ZZzhJeBPdDQRTzcc1RofAp8oXQnpzRnJEGN6MqwVBE706s1Zi7l8twYMlRuNixCK2FoNinY3o5EDbErJ1SLPa89LwV9Nv1RllZGFeDsu9S0uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nwvf8Klh2uQtEdk6NW0Fctfykvt9cJoiCT2W3ljzxOI=;
 b=XGFVWeUcH9ho1Ej4pFgUECp03oCialicvndqH/Q126INvAo46GPuK5+c+6YTt9bvq8rYunFEaogKsxkWsysHSzZniq3CLIFYC8RjnwBcmSzi+OGuIsuCSpMjKg9yRL667DtaZYGV48o6pi+SU9GVEn+sWHQQUJO3DgSdAUR5LmKIACxwK9ohFhMKLrklq7DEEZdxNV7kTUaMjjbvHUmxlx+SkRVwcFY2W8PctXERE4DdNIkrVZkPIW4nUGYeByQtAJPvPg2oy2LGvnLtbb3AfuyY2uKR8iT+UgmqX2qmEmmPEWsJg/h5JbIkbe5+2cdZTsxPAFpfHG56Vu6iy5qLsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwvf8Klh2uQtEdk6NW0Fctfykvt9cJoiCT2W3ljzxOI=;
 b=mVxusZWTEYLzXmLQAtHgUIX/f5qxaPWD1C/YhwBvTxEJEzEWUlKt6XVvadMBWXe8oYQcCzver0pYEgDZk0OOqKseRgaTosNDSoQQg9DNOf1rI4jJ4sr6fAXBSjz6V0Y7LI4XZ8552a/evut/XnNPgPoQxkgpIAmFLk/lnCupRHo=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:45:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Justin Tee <justin.tee@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: fix sprintf() overflow in lpfc_display_fpin_wwpn()
Date:   Wed, 22 Sep 2021 00:44:49 -0400
Message-Id: <163228551952.26896.8384124235528663186.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210916132251.GD25094@kili>
References: <20210916132251.GD25094@kili>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:45:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44bf666a-c437-40a4-82be-08d97d83bd6a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45185EC0AADBB35A3DDF608E8EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KikuFhCYZl0bRLvGOIhx/BqSZsVkN0Ebyvh7b09YFZ44dNFLAbWUnMoDDRUKaCs19mwO0oROAprLKTTdh3OktuF4f/fcyFdRuCGzxEzYTJhsL9bsexjAfcHF1Qwuq+vF3ZftKmz/sbLrYEUtI0WeKRA52SvYwa4vMA7zbaDCBMXjA/Vsgr6IYUGiyoeGQVOtyRann/iXB5MElLqhje9Sq4EYOUO+TJIJl++7cS9Faey/l+T9Pz2HmPA/7YnqGUzNcBsymZ5fbuYsBjVrHln/n+KSTPiWfDAU+FMAV2JaodOhKhpearaYLQvpcPg1TGDTG7gb3QvbvAprfyYsJHqIXpUaDXkvsnaLAsG0nq+Zq0sdg85LeFSxshn6UF7KR4WCKWHExa+qcMplTFWhdnVtnFoTPp/v2FayyLCdTUe25fvnCTUSTI3S9hai9oR2+/Yv/TGxwx2hpiDjOm2QQ4hQOdNtvLHV/xsUY/Dlj3M2NU5EFuDsTI3vvHuGCi61RnqMkBw6yyakhZQkw8MIoSxqhDcQv9db5DhW3p0e3gQQedBDp+LFmQMEeDpv1hxMuaR46S8gHp+IgVarWTgJ186Wb0BySXHFxFZgp31nU/f/zWA46MTj6iv7pKAN+gIOnE07mOBhrp7Hq+1B4HNkLkNXkxWzOOcD4un2Ov+fjnoXO99rW3MhaZWartcqemMnBqDsWnt3DG/CDAduRsQ+V8prLXjQ8m2CvJYvgkE/a+ppE6qy9R/Wf+5eLkH08+xCbDuSIqPyBr6FPsvVeyPtIcK2r96sDc8sEbhZeUV4kyvwIms=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(83380400001)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(54906003)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(110136005)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bW1qUHNGQzFncFVpbkNMRmRRR3FWdmhsTVFEZThXUmo0ekdTbGNraXF6Smh3?=
 =?utf-8?B?UkhsQm1RaFR1NGxYYXY2UWZhRXlOK1AzUnpVRjdUYWtKYkV6UGZqc1QxVDkx?=
 =?utf-8?B?bWVEMkt4UEhHNXdRN3JmTDVaazdaNkRwMllEaE4zY3hySHZIc2t1cTFZM0hi?=
 =?utf-8?B?SXNmWnBYRzh4UzdSYkFQcjc3a2x2eFFOTnoxY1d1K1N1aTlKK0FjOElybWRM?=
 =?utf-8?B?UXFLRVJQbkdNNkEwdEN6My9DRmpZVDBwdnErWEszaXZMWXJpU2ZhRkIrRUFp?=
 =?utf-8?B?amtEL3RVdGVkTG9tTmhiczVBeVhzODZybVMxY3ZLRlNoMnRKd1lvVWpRMnhJ?=
 =?utf-8?B?Vm9yRGlWWGVsMkFSU01DZnczOWNXOTRCYTlVUGtlbEZsRmZxVlpQRm9WRk9x?=
 =?utf-8?B?Nllab2RzOUhVMy9NQ2Z3UEQxRWpIY1ZYOUFxNVR2QURFVC9DL2NtYW1YRGUr?=
 =?utf-8?B?U1cvSklKSlRHNm81M3R5blllMjBlNVAwWTZwMno3T3BaSnl5M21qRkkyZ0dt?=
 =?utf-8?B?Mjl5djE1NjZWM0VtL2h0OEhyMTZRNUkxWnBMcnlmOFNpRG1iT3A3dGF2R0FJ?=
 =?utf-8?B?MTJKRllybVM2amd3cGtBTGYrbE1relVaUHBObDJ5ZWcrS0x0K3BWTVJaMFdp?=
 =?utf-8?B?bmxIcE8zVmx0Rjk0MTFTKzU2NUVIN0dTL25RWEk0a1daUlNmZnNmQ2pKQ1I1?=
 =?utf-8?B?dXlHVDhKNjIwYUlzeUhuQUlJckpMaFdqOVQ2OUtaVEluaWgrMytFVlJVc3ZH?=
 =?utf-8?B?NGJIRkp0cU1TRmc4ZzAvVUE4VSs2S01XQ0l5VnJXL3J6NTZqU1lyQnR4d1VZ?=
 =?utf-8?B?L3JkeFVaUUwvY3VwQ1NIR1BDM2NsK3lkak9LSllvZnkrMWtzNm5jMDkrR0JZ?=
 =?utf-8?B?VGg4d1NDM0d6TUI1M0c4T0VWSGVWZ2REZStZNnExU29laWkxTU1heGplRC9C?=
 =?utf-8?B?Q2t6Ymt3eFZiQUtlUmZmKzcrMlQ2cFhUMzZMSW5DbWRPTE16Z0UwY2pramFH?=
 =?utf-8?B?SVkyVWdrVTQ4RHFUYXNvY0xiS1R0QXJyTlptRUJNY0V2cGpxMEo4NFUyYUVV?=
 =?utf-8?B?VXNJekg0SFRRL0hzaVp4K1RHRmNaNFVXdGR3L2FQamFLQlJzUUxTRHZDOHF1?=
 =?utf-8?B?S1FXU3h0UUxCMEJHM2pTYmZKNkFNL08wcGxPN2hmSkNqUFhHRnFQOTg3Zncx?=
 =?utf-8?B?a2JJTjNBRmZZaDlZN0xxUkUreHhicTNUZkpJaFlTZE0xanBUbktNMGJwMkRm?=
 =?utf-8?B?NUwxQW5OUHIvU2pqbnV4NDZ3UnNDaFY3aXh6VlUvOFBReWxxWmxPL0crMCtH?=
 =?utf-8?B?ZEx4a1RxV295Qi8wNGhiWkxGdXVaTGFWZUc1dDZCUVJrZFZGZG1jd3haUmJy?=
 =?utf-8?B?M0VCckFKTFJWUnc3VWVWQjZkWk4vNFVuS2xCOEt4dUJBODNuT1crYWZ0RXc5?=
 =?utf-8?B?ZzY5SUZkK2pkVCtEa3ZnVjFoZ1phMUdreERhQXhkMTJqWXVzY3ZIOUFZVS9l?=
 =?utf-8?B?WjBuT3VlWjRrN0QyUlN3NkZncERpTjBOeldidVJqcjFLMXI0UzZWZ1Jydzcv?=
 =?utf-8?B?QWpuN3VOTEF0eHJLUWdJbVM5K3NCYk5DTEpUdUYyNHF3d0lWcXdZN1NKRUpD?=
 =?utf-8?B?OXVKc2k1b0hQZCtoQzdQV1ZTN0dhSU9VZGZjTTVEN3FDVFBNRUdpWndUSkxT?=
 =?utf-8?B?T1dmcEZJWmoxY04vTElkL3hiODRjRk5XMUR1WGQ1YlBiczB4VFEvblh4OVV3?=
 =?utf-8?Q?JPT1j7zagaFN8rCHAQfEKUVrUg9NhIKH1jp5xWq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44bf666a-c437-40a4-82be-08d97d83bd6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:02.3529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDIIUh4qlh+K5n7/GgMEG4HHhPX6mnSgfmm/mI2k3jfHuZkWiFR1OB22QnHFX88T8LRBIJI7wlZZBZKUPcdXcylNI4Iz/0tG5BqwfsTLCfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=992
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220029
X-Proofpoint-GUID: _sTmuW6ozPwqXwgtdH0VHnqs7zicLmwO
X-Proofpoint-ORIG-GUID: _sTmuW6ozPwqXwgtdH0VHnqs7zicLmwO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Sep 2021 16:22:51 +0300, Dan Carpenter wrote:

> This scnprintf() uses the wrong limit.  It should be
> "LPFC_FPIN_WWPN_LINE_SZ - len" instead of LPFC_FPIN_WWPN_LINE_SZ.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: lpfc: fix sprintf() overflow in lpfc_display_fpin_wwpn()
      https://git.kernel.org/mkp/scsi/c/cdbc16c552f2

-- 
Martin K. Petersen	Oracle Linux Engineering
