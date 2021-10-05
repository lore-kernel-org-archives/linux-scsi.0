Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51114C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38CBC6136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJEEiI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:38:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65000 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229955AbhJEEiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:38:07 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1953EWAr023902;
        Tue, 5 Oct 2021 04:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LfYsz7LDOoLeYBnv4CR+zbrWFFXh655MZtU2j+BR3FU=;
 b=RWI5Z757WsDdVPgSbgn7TyHME0hp9ZBcHqE+rWejerRW+hq9yh/E3ptvwAeI35CsaOlh
 KqtZiFtDB4wO7dsv0Cmoiv0XqD12r9lo3iE9B98aksp/PWbJQMKZLb+itNVXxm+0AnCD
 b5Uma9RvF2vbRPV/dIucj1Q6YZmT50RmCwL0gTA9s0AHKbOEOMFgcPZ6IXbocR2TJvBr
 RO6GJsoDxKr7wPYatU7ATOo5/JgCpKiQjZ3NdPEJg3ag6KHJVO6ZX2eT/hjoJ9t4jMFE
 aW3jn0fw2BpleTgvKKnTMAPchePOW4qz4SmrK8ToDHze5MpNpW1WeZ3o6Vz+8DWO02N+ 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43gmb5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UIIM054118;
        Tue, 5 Oct 2021 04:34:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hux-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSsOBFSooG1ZGlYxfeU0n9STso7AWvOhOYf8cuo4YrgOGOH1HYcGlDnvVAYVRBacFGyxJL6NqsE6yXS6NXYWZnosN8j11hSiNhxh3ligCpifhHeYjI1wmRJVp9XhqCvHQuncg1ZCma6wWNaA5X7wdmwOkdlO03n5WN7AZcwz76YfWVeHLABWzTy7W4JQW3UsvgVnqoIn1JmmOByaNdSCE2M3ea0jmLPJGXPVJGJ1XUi5n6IkIsSTVi9rAuTyMGQqqhsuGbhgL5s7CrGXiq8zr46uTzEVc/9Sw/xcVnmfstIG4SRydbVQSfceFlvW1aGK82YA8hb97o+MZEQYo52baw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfYsz7LDOoLeYBnv4CR+zbrWFFXh655MZtU2j+BR3FU=;
 b=LBCUpfV/g7w+XQ+TgIhxBL5p4twxbbWJPayKiz239zml6qaZ15uZN9/d54hFFsw9xW7o9xs68+R+Ku71YJsT7xLU8fWNgry7CqCSNzz21isNHMsBy3NU7/vdWYXvyufubZhTEjmxTzsccBOMn25gnY8zFJbsnS8sZLNLpAO3HQejFEGl1U8PRLub3R2MBLXbMLJdrv81oF65/LuSWFmmr3R7JsVEjvLBhUnZycZczLJI5aRWnQQHS0dbdvwzGvEBb1FwjgaRa6wnJNNdPZBhuTZSOrT0AdI0W1HyD+LsZzGUk+qhO9bPhpui0ZhihxApvYPKuycnyEkq3xwNoYp/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfYsz7LDOoLeYBnv4CR+zbrWFFXh655MZtU2j+BR3FU=;
 b=htdzuw2dJSbWewj6WnxzYwhLs4BrhiKpS20FOeC9ikneRE+fN+IVxto8CRQxvqrjjJuR3Bwg0DnS70x7QBA045M7rK8GUshSBN0CVuVthezb26q6/GcVEcQM0Tny0wq4wOCR9l8cpiWvcpNdAYSwQ2NDcklcNkfDILwkzwZJMtM=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR1001MB2320.namprd10.prod.outlook.com (2603:10b6:301:2e::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 04:34:43 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org, Michael Reed <mdr@sgi.com>,
        Adam Radford <aradford@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] scsi: qla1280: Fix a function name in comments
Date:   Tue,  5 Oct 2021 00:34:29 -0400
Message-Id: <163340840529.12126.3774012366473171933.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210925125324.1760-1-caihuoqing@baidu.com>
References: <20210925125324.1760-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8664d2cb-4b31-495d-4e5e-08d987b973fc
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2320037532033606C2B582B48EAF9@MWHPR1001MB2320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8WHr5nUARe72Ucou9UtCZdA0Vv/PdcBI4AX8G51hm51g2rCIVDYijPpUXrJM4ypGXNBLoeX6eTqnk17ewjLlrA58IP00A0r+lyKlSubT2tVLdgnmTLZBzcdHpVh2Msvlj85gNDG7AQRlH/qXC7Cc6Ma6PfY2CIlVPAxBjU9E/xgFcWtEyzNC6mYxJ75PzRwkx731lSxwuQzVZu4A/PKh19C2eKxs+IyTOaKkYYuwMXuDT2Rzk8cx7TeSkkciZvys9C0QPYDizEi/77uPtl8fWHT90SQzFhf55pZLb/UVoA+afeKz1Wx5etwMfDEx9mVZK44tkFJtSA7Hrd35+GnSid+lbl9qTjOhOCO7rdjOjUcxfdfj5fGrvd9s2f+gVcaODFKo8N4ZOtpte/V+jRRANjtCe2/TX/TQzpO05wnU31+dgC/2FLdjOYUH2oaYiQGu68M8IPDKg4UIG9gwtWZSky9hmlRBk2+zfkecm3M0Ezyu/VzMFPeoh2rBoVKv8KQX1qHxvzIjH9tYgC7CTBAjxIvMGVc8/zkHCiskv/MJdX8eVI9vLtxF6leM1gjqky58OqnMEVYsf/egH+lw4B+0yKdm+gEpMTL2zjHBDnQi+/LObALl6vYdFH9sSWiSuNs/VKwFel60AK9bm2WvOljIjuO1UsjU0Cnvgg4FZqOYxXA/5XvMfhs6IKmHpEnvtAsMzrlxEPyxFzI4GjQWNQgJyrCUR/GkLMIpzf+Pav19TWgxXpDsVBPXM+IIjZY4A9bd2GHy+Dhmy/itSXalFggJY1tbfKcms5W9VYeDebP8t7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(956004)(966005)(2616005)(2906002)(6916009)(4744005)(6666004)(5660300002)(38350700002)(8936002)(38100700002)(7696005)(36756003)(66476007)(52116002)(508600001)(66946007)(186003)(103116003)(4326008)(86362001)(6486002)(316002)(8676002)(54906003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXVsNUljN1JRamtJL3lkZnNvUE9QRGRHV1R6WE4wdnhjK1VXT3I2bW1iQ0ls?=
 =?utf-8?B?cVRKd0pMWGdTa3VxRXBNVlQ5OGFEdUxPR0JlUkVoYXFhYWYrY0hBdUd5QTha?=
 =?utf-8?B?RmUrTGZyQWpPdVhUTVVtK3VFLzdxK3p1SWFHRTZuaXlMRVVWMVBtRUNmcnR4?=
 =?utf-8?B?RGJ3NkFLWStFTVBiY3M3THNETXRpREdJVW44cmE0ZnV3ZEMxeGpCamk0RHJv?=
 =?utf-8?B?VzlWM3Z6enZuUUJYU2YxL2d1OERueTlxK1hJSjdGcE1OZnBsbHgwMlBEeTNC?=
 =?utf-8?B?dk1WNHo3MHdUd01VSklIUUtCYlpTeEdkb3R6MURzSFRBTE10Wkx0V1BBY0tE?=
 =?utf-8?B?RzVRTWg3VnBrVUU5eDA3di9BSEtzQmxIM2ZCdzB3eEM0cDI5TCtsSmNJczVo?=
 =?utf-8?B?WUpIdnJXdnhueTZGejZWdUVNM2tYQnBYcStzYkl1RThBNHdlMnkwejR5bm1q?=
 =?utf-8?B?c0d1ZjhvWU1EMXN5V3VRQ0g1bFB6NTJ6M1JUd1pDWTdRRlpnWXVuK0lTRE03?=
 =?utf-8?B?SzJNbFJCNGh4cVE3NWgyYTRpWWtsZDlZRnRCdXJXM250QnRNcE0rZ3NmV3c5?=
 =?utf-8?B?U0NkOXo1aHp4ZG9ZaGtoeDJkQnB2NVVyR1cvZFMyQldKaThjU21BakNLUmVZ?=
 =?utf-8?B?dXlxTzJRSHFkamtqSXFQK3dVTzNORGswT0t0WVF3U0JRTHBtQ2hoM0trQlNU?=
 =?utf-8?B?WVJST2NjblBUZkZ3cEhIVVV3ZHgxT0E5SVBibWs5V0wzUDVKYVYzR1Zjem9v?=
 =?utf-8?B?WEdlZTBXcWNFcm5FZ1RiQUFQQlQ1ekpWdnJzcGk1dkpWaU5zZGtyeDlIYzVZ?=
 =?utf-8?B?K2RtRTU1dEk5ZFQwdFczaElsSm85blEzRzdEZHhtZ0hXR3NOOXVYamdaVnUz?=
 =?utf-8?B?VXpvdW9MNDcxcjlsWFlSRVQ4VERnQU55TVZFMENuVGdValpvdmoySHVCRmlz?=
 =?utf-8?B?aUpWd2wzMTJaYm1Kc3U5NzByZjhXRFFKLy9SUnM1UE1xTGJiMmhEb0hFR2li?=
 =?utf-8?B?QURnQXVnbUhqTUNDanZNV0NvRnVZVkhBeUJrNnlHZS9RQUx5TVVyNkYrZUpD?=
 =?utf-8?B?MjViZkI5TDVXeHFqamdRYURSczBKYlVzRHgwL1NPeElBWEZqTXloeGJUV3Qx?=
 =?utf-8?B?TDV4U2daYWl1aVgzd2FPa2Z6THU2Z3pUMndRNTNtbWNhaG1OSG1ZVWhCM1Bx?=
 =?utf-8?B?em9CcllwTVYzcmhNTEViR0tGV1dJMkI4MUdMUWkwVENmZW9KTlgwdWU0bUk5?=
 =?utf-8?B?cmFYdHQ5VWFrKzhkWnQ3QjV4YmV4dmNZZWV1SVZ1cllDclB4d0dOSVFaRW9L?=
 =?utf-8?B?OUM4b29NS1M4dGx1ZWZQUGJtTUZmYlpLZXlKMGczVjJpdENjYUtWa2NzZmpM?=
 =?utf-8?B?S0g0Z1pxb2M5cURPb2Y5TzBNSkRTdmxFamF3bHIzMXNMdnNvSVJMcG9peGQz?=
 =?utf-8?B?azB3d0plMmQvOXBmY3F2amRVMk1LNlpWV3hnRkN2Tms2TXhRdWo3MUpmRko4?=
 =?utf-8?B?UExQSDJyN1RmVkZFV3VrQTJ0S0tFTU9UZk9BdnJ0NGRSeGV2UnB5NHc1L29R?=
 =?utf-8?B?SnFEdldvQ0d0WHI4cnBWMTR4TFFIN3RFYXNCd2UydmlTVlp0eGNJZllTY0ZR?=
 =?utf-8?B?THVjVExYU2ZybklPVzBocU91WDJzZkkzY2hxRWpFSTRtY2tva25vRTVOZXd2?=
 =?utf-8?B?TjRvbmdlbFFrVFFXVFgrbHQ1ZGZuelNyVTBPRVFtbkVZbmJZZnJRVzM0NHBC?=
 =?utf-8?Q?q0Sn4diSPYbyUIByRAUi2c9TAGFPOO/fXj0spWm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8664d2cb-4b31-495d-4e5e-08d987b973fc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:43.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AA65fLErTTGJ5n3M5YNTomgqUTM3llqEyEDJM8he6UNS19SRDurIfQSj1xxXeVRfGLhstdG0xfXet9C2Fj8ufeCjThwFJyf3YTmRJSzImHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2320
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=936 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: dSxkSuLRv_YKW5NktbGYxF_UGC4aY6va
X-Proofpoint-ORIG-GUID: dSxkSuLRv_YKW5NktbGYxF_UGC4aY6va
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 25 Sep 2021 20:53:21 +0800, Cai Huoqing wrote:

> Use dma_map_single() instead of pci_map_single(),
> because only dma_map_single() is called here.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[3/3] scsi: lpfc: Fix a function name in comments
      https://git.kernel.org/mkp/scsi/c/8d807a068090

-- 
Martin K. Petersen	Oracle Linux Engineering
