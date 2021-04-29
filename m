Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BE3C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8BEC61448
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhD2DUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:20:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbhD2DUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 23:20:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3Do0t175178;
        Thu, 29 Apr 2021 03:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ORKpHMGxj9o/33grozAHVCMXK56m7HOJE3IGthcflXg=;
 b=rpBwdvbvSU3YZ0Ab1KLfixu7L3GCrbO8LwyWy2k3fe1J6GBFtDqJMM1D6xEFhSgr9rSv
 KAl4tMoEcKKAp5mh1vPvYHYVPS6fxfc4RlPXBz6hOuwsjxoiArRWD0hSrdCtUUGvcpFQ
 AnCr/dVzrfp+JA3B3rT+ncdLFSXSWnqDeUSRo0NNl0zmUthMq0/t5uanWKEI9jFHlC1l
 qBb5Wa30xQnHh/5hK52K4fKJrw4fQ00OU232GNhqjGRSgHnXdX48U9JZcBaLDLUBfu9o
 ZysBSNgf1rXmlW3NB0POVdsmfJ95i+xzIGWYCZIdT0JqjmaU0IB62U/0EdB1yfuzI8H8 gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aeq2w3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3Eq2u154231;
        Thu, 29 Apr 2021 03:18:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3848f0es47-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:18:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwIQO95t2rYXbqfquUES6mg4WpEKutOsL3wlDQYcUadDYkeCsBSTp3iT35Et8m0IMNDClJNp37R6hcf3e7rk2BGlp03rklmSXPFn+Nbid8KhBr/McP/g3sS9gWhm+//YR4IRw6FhWYACmClaJWdCKNkPFfdD90ph3GAhH2VujPVYKkFOem8xpkcHFyejLFt5IehX4n5THG2XcPlwAUrPhc5NV7UCAc8DGZxnw7fgrgGN1/mSFILMmHEL/zBrF+nF6dW0AveD1dALPDurEYj5agitO6iI8ueRpu1VjI4OWoFl/bXlN1OIclKZYqUdpJp/XuuyZOjJdm6L7NCZJ9p0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORKpHMGxj9o/33grozAHVCMXK56m7HOJE3IGthcflXg=;
 b=XWYft027ngcS6i+gsz8c3Kwgp/TMLM7xr9IMSTkXaFkmPoSOiMdXSleDRLJRrB5CXiZsYbIlXCSLNrk+SLxzB+6UGcyxNKHn4x81c3uw/f+0FL+50FXHzQCle2CO+EIYx2x+1IMOU+4AaRrntZ+hHRnjzW5Xhk8w9tQ5m3jWx2pjCJHokwW598nOGXf8bKc5Lib258c25WIrl6ca9OE7HtGdftlg2y2kbR6UIaEXz7W+iiEQU4ibi8SOMLYwxi/AsR++omuxlTECfGkyla9SS01LpKtfz06LQPInfU9k+vFVjLFPAVtDgYa/jGrqL/JqBj7rrycgNM798/VugT8mWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORKpHMGxj9o/33grozAHVCMXK56m7HOJE3IGthcflXg=;
 b=jZKtfcN/l8kcXAHlHcVs3OBCT9774NDxupxtmFD7qgl+YMWQGX2F/vkG8NAcmYADcCzWm1HghSasGZhU8T/39ycKy6CQPO0PbU0vcPOD/wq6/bs0qQ/Iy89x6vnu46leFlLglEyy5Z06eGVWTRkxFkFecDSb3wZktK8hqg+A5ow=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Thu, 29 Apr
 2021 03:18:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 03:18:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, kernel-team@android.com,
        ziqichen@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] Three minor fixes w.r.t suspend/resume
Date:   Wed, 28 Apr 2021 23:18:47 -0400
Message-Id: <161966630053.16262.5821372155612732675.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
References: <1619408921-30426-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 03:18:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcfaf7c5-d4b7-46d0-996f-08d90abd8592
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4805F91F9A4A10667A7A834E8E5F9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKg8b15imGT218aX3UZPd+BYZm9hJWFt76LZLBAqMGsFUJnK2T4bd9zYF2iWn512/wFs+zzpo4Eo+kgsWMkPJVQsAvZIbCwJSIEJFknqVf6Z6Z9ezAX3yMVpFBjX592vfQGH8Ma9+8tvQk4R2o+El02rIOFVemHcJEtK3SeJhLg/4ciUIeYZsU4jcPUI57Q/XVBDlFO5kMCncg6iQrOd+EbfsVxPxrc1vnlPyGYDlCOBFxvlFOPlo5FraQuGU3qTlNLw8sUnJ16VXdDmRXYAcXV14TX2LljZMu3H+tPKDlD3rL/JXab+PzcyKZsFJf7OT2VQypeaHnv3tqbDcGXPcv1SMKOwwSzwJjyQuGGuStbsvN7AFkZPkxFxVtsyjQ2TQoQEKTA3NvFN9K0fsqoD9R7n33aeAXGZQO/a0OEar3n986tZ+CWB7qMD+qe0+fflLt0KgHVCa70QW+KdgEU+KgyH3wHcZT4cG0Y+i8QY+KsHTQxPJPNv4bLCwVoT4vvWuryuPHEksZuxFAYv27UemqrqhZNLpvJKjTACPLOS/ASKC21Tqmn1VfMthlDRK/bq0u7Njm/De/p1Xfq9jVpZE7Xy8cB/iTRHIDHRIWi+hBkufCNZkkFMRfF1adT1nDyuL8VZIGfHlNHKc7/JHnjHCgdNM/n75hLihGrqXHZf2yPDiYcrRDyuV3dbMOF98JFXWXSLLsvC1TfmKQ+kzL9udWv9ap/ERhjPpCIdakYrrfc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(366004)(376002)(26005)(83380400001)(36756003)(107886003)(103116003)(5660300002)(4744005)(52116002)(16526019)(186003)(7696005)(4326008)(316002)(8936002)(66476007)(66556008)(38350700002)(6666004)(38100700002)(6486002)(8676002)(2616005)(66946007)(478600001)(86362001)(966005)(2906002)(15650500001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UTFQVkk2UkhHaUFtMXBvcUoxZWdyZjM4TGFZeEhKMWhZR3NVSmc3bFRUaVdZ?=
 =?utf-8?B?eFNacm9wdGRPcTFHSkluWjUwek5mZmJDWXRXYWkydTVEeW42NWQrS3VQYzI5?=
 =?utf-8?B?SGV1TmZkWjAzbDFQRDFQOVh6ZjVQTjQ2MVllbkNmc3dEYUl0VUNUSjNVNk5Z?=
 =?utf-8?B?N0pFOVluRHNzcktaUzVhbkp3a213RDJLY3hiazYzc3JtSWtwUENCSDJpV09m?=
 =?utf-8?B?bmtKMTdNTUF1TjZBZHRkMllHMHpTWUt3UlczK012aEhldXY4R2hLV2FzOENT?=
 =?utf-8?B?aEVqMkhBNXk3WnEzSWZ2UDdHV0dYVDl3RldUVi9NdHNPTm56T1MwMnhHY0Jq?=
 =?utf-8?B?bzRvQWIyaTQ4c3NzMURJeEh6YjR4VmUxSzhpRGNVR0l6c0duU0tjMDFKTUtx?=
 =?utf-8?B?VFN4dS8xcmo3THNHN3FKdkdOdWp0eTZFQzF3TFNnMVZWZ2VPZDJvcnlqTFow?=
 =?utf-8?B?a29NVklxQzdheTdtZVVjRm90ZUNEQ0piS1ZRTjE4WUZYaXhwWHovcy9CT3Bq?=
 =?utf-8?B?VjBrWjlNanVGTFR1MFJ6am4wRTNVS29zbEpFbkxQS3JmT21YUmN4TWdTSGMr?=
 =?utf-8?B?ZVpxMHpEMW1SYmtzVDZlb1FRS1RCWWhJQTBVbk02S0I1VCtaYVFxZS9rbmNS?=
 =?utf-8?B?OWZCTC9yMXp2c2kyTitUMXZVWXRiSWg4VVlvYTBhaUlPeDJpTWMzMmdaR05N?=
 =?utf-8?B?T0Ftdmh5YVdFNEQ0QTYvUkxXWUFpVTVTU205a3lHSEJRcTRja3NhbU9EOGdr?=
 =?utf-8?B?cVEvNHhaZjZSVlVMODliNHFBbTdidVFtZC82Wm9WNlAxbjNyWW5GbXFSUUhw?=
 =?utf-8?B?Qm80UGhiK0NydXcxdWpSMk5VVUxxS2JPRFFiRHRrQkpTKzJjcjJwM0VENjE5?=
 =?utf-8?B?anVhNVpuOXNLYWZWME9qR1NURGVtaTY0Z09laFU2WUw1UzEyS3lsWTAyMVpy?=
 =?utf-8?B?WVFyczc4SmljTGxqaDJ1dkpuaGxyQk9NamxIZDBhOTRHZzJ2YmFTVUI5MXV6?=
 =?utf-8?B?QytQQkNCbGxtZk5pSjZxM0hLY1lDNkZ5NXJUZ1dlVjI2dzdFbnVkQVV3dTNJ?=
 =?utf-8?B?bjU5amZrbjgyNFV3azZxQjRkZWdvQ21IS0grZ3ZocjZ4ajdlYklDamhUanN6?=
 =?utf-8?B?Tmk1eEZmd1JsQktEaWpYZFo2UTNlaTFPWURMN0gyRTJ5cmhvWExEYURRVzlU?=
 =?utf-8?B?RTJiZEwwSTdyZ3FIeU5Hc3ZjdkZpM2Nma25KL0pMcHZobTVlVzIwSkxqa3d0?=
 =?utf-8?B?Q290SzBpcUtlMCtmaXB0RlgxekoyR1hwTlN0OUdNajlqVFoxaTc1cEwwSHhQ?=
 =?utf-8?B?TEp0a1hjUnFPQno0MWNxSVJxS0RYdXVZV3NZbUhaeVd1OG13WEtoSjF6eUNG?=
 =?utf-8?B?bTl6NEtaSnNmUnFQRXJOdk91d3lKenBFY2NxL3FzV0w0a1poZkxhTklZSTd3?=
 =?utf-8?B?TDZYelZsbVI1MkFyUE1HR3ZQWGYxVzVMQmg5YVZHQnQzMVdkV1pWRWVGTWd6?=
 =?utf-8?B?b25QWHFuWThrcTFCUDVXWHQ3enN1K1dkUUVnRGRsMk5tUnFFYXhra2djdEpq?=
 =?utf-8?B?MjNrZ2dPS2ZqMmZyZ3lvd2tWRlRFczNtbFc0V3BGSnpUb0RqbG0renBrbXJF?=
 =?utf-8?B?dHhpckszaE1KN0xKRDg2QnNtWVU0UDJrMndTOFVDUmpSWkw5MTVmS0xGNUVB?=
 =?utf-8?B?cFFHT3Vwc0NobE5zcFp2MDdKd0NIaVdUSkQ1K3dmVkdPSGlzQmhFL0FVV2ZD?=
 =?utf-8?Q?xB3OBAsjcHWT30AnPO2O8o944KH4TNXzDZhUwBl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfaf7c5-d4b7-46d0-996f-08d90abd8592
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 03:18:55.7292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13EUfQN2VtbBMxT7HhnR35C7QAkYJReuzV2dIVdk3htLz857IIqrCCiB6lXfQ+qtm72V1LCXe4DctYDUVONiAE0j6WtZF3SGAgMlhFnoBGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=987 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290024
X-Proofpoint-ORIG-GUID: Q1gkf7UQJILunmZnbh6jpUcirxDw6Bsr
X-Proofpoint-GUID: Q1gkf7UQJILunmZnbh6jpUcirxDw6Bsr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 25 Apr 2021 20:48:37 -0700, Can Guo wrote:

> 1st change can fix a possible OCP issue when AH8 error happens.
> 2nd and 3rd change can fix race conditions btw suspend/resume and other contexts.
> 
> Can Guo (3):
>   scsi: ufs: Do not put UFS power into LPM if link is broken
>   scsi: ufs: Cancel rpm_dev_flush_recheck_work during system suspend
>   scsi: ufs: Narrow down fast pass in system suspend path
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/3] scsi: ufs: Do not put UFS power into LPM if link is broken
      https://git.kernel.org/mkp/scsi/c/23043dd87b15
[2/3] scsi: ufs: Cancel rpm_dev_flush_recheck_work during system suspend
      https://git.kernel.org/mkp/scsi/c/637822e63b79
[3/3] scsi: ufs: Narrow down fast pass in system suspend path
      https://git.kernel.org/mkp/scsi/c/ce4f62f9dd8c

-- 
Martin K. Petersen	Oracle Linux Engineering
