Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0651CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E568E61130
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239252AbhINDps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47490 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239201AbhINDpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNY3GL007062;
        Tue, 14 Sep 2021 03:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6EVS3IMOkY0MVIxIkRGUvfrFl1CwY/vrl1bU0/9tAMg=;
 b=n1oH7zseenhSFEyUr1MaetVB9h4ji7p8wBOpU66u6PPCeg0WHy1dnvhDKolXDKRNnZG2
 I4mhmGAMbDITLE1bBPwUf7oDO0gGdqlE35nMetuMBSnhRxVqPFRKn5Q+XI+AeB3RCbgA
 MN7WvytgiP+WqnGlPDp5bAo0IaxEMVryGTgd5fplJcg+/dzT+phOm2N75rmO224Mpgz2
 lc/Of099Wlq/YJxwFJ4oOoZrhjfLpOWQmIAM3jDOEJNAQC4Jcs4Q9p4PN5INGqbrICG1
 RnBOLV+djUsYzij4v055NjMwnvRYHjd05ECBwqsDsKqzKWyhoGRBjg5fSNl7GZR7JXVj bw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6EVS3IMOkY0MVIxIkRGUvfrFl1CwY/vrl1bU0/9tAMg=;
 b=L2gPnV3UlBPeVa4cavu5FV3yapwBc1JJWq63WXTfv3dq2EbahcTfmcQLk8lnZKfkmLzi
 8T3ko1UQNr8a36aILZxZ/cs7QGwclhFNBJxP2/k4kfdVlRpF7BOntdTf1ifqWlW00OgP
 dWzQ09I6dNraktGEFihPcCrMW3Mm14PxzOHdsu5F8GfyHeeB6e+VoxNLdGYnQrT9vAoB
 LX6LbHitclWoLmw4m+P/fesTq2gTE2nQ/Zr5zw2hO9Ed8B/vffkN3K2vV6rhC87yRpjL
 MuiFJSAz14Kzw4fcTkXjZKQAnsMZWvKazRDEv3bvGejlIQOfVIrGanGCS2gPfqhuynA1 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k8sd1ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f6LH097717;
        Tue, 14 Sep 2021 03:44:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3b0hjuesv1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IixHvE2zCVNOe7TAjIjTtuMsKHtJX+8mnKbYDPAbMg7zrwhi+GqW8U129WMQvVHkZj23Ptu2eS/1Azcd8jIaPxveclemTaUgFU8EW6Tm0gPdXtPy2bdu/GJdzLetIjvkvcnCk5R80Q9YSL6ykkYfF4gQTsgr3z4fkpGKz3jrBepyTeXxIzhhdOEZ9uBhwGSvPfR0SgDvYBegnB3kKaqlQvMPI+EdHxi4mW9f4QGo8UVz3KMVelAFmXJXq0sKx4j/TotYMmbOShmfJZFLMZsTXgqgqkFSGAPxy3oxH1+pM7sTG2nY5njA7v/sxNfRbAMF+Gu+o/+HX1TbP8Fq2SqT+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6EVS3IMOkY0MVIxIkRGUvfrFl1CwY/vrl1bU0/9tAMg=;
 b=E+Ecnmsboy64x1lMIyUewQF4yA3PjJf6TPUgLpDUhyG7+HlA0Aske7DBg2WEbnpjw33XTtk/rLwLWXxitie63Af9H45WJuJetgnED2ZtcWOlICZEc1cH7rnSLXCbahqrovVBfK9xm06S2/obriq0R/B2PcCbZoWQBG4WucKcwVStt26tm9tjV5H2xUMYHSa9LK+hgp6kMXsBb6k/rHpnKcENF1gW5ag9/KFPxy5y6omgsLP7WlVYk6DK8Sj9J64pgJkAwMsylexVzZIm54N51G+5PuszQg9nnSydnwOhrGacOYLT4LxXrsPOK8QaqgURoDC7Mhy0B21r9C6ow+V2QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EVS3IMOkY0MVIxIkRGUvfrFl1CwY/vrl1bU0/9tAMg=;
 b=kZwcCFcKZ5U0xV2Jx391K6sHOcsnD7l2oRretYIdU/MfJCwhP022LE1KzZuz5VfPFBdHXGPPTacC7llZ+VgMfrCDXPYO/a8fewfxm/wB18+V/cU7hEuTVnHVJhnHyjmo7qpqYRrpDQy/aOjY6mksx0L8Da19j6FAHa6l1RM9dak=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 03:44:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>, jejb@linux.ibm.com
Subject: Re: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to SECTOR_SIZE
Date:   Mon, 13 Sep 2021 23:43:56 -0400
Message-Id: <163159094719.20733.14236751619153468258.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210906140642.2267569-1-naohiro.aota@wdc.com>
References: <20210906140642.2267569-1-naohiro.aota@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b81d92ad-a1b5-4de2-e654-08d97731ee4b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4725755B774D667F231291C78EDA9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R1FzaxdaeDWGr0GcVbPjSHTz3eYtRlp9ippwvqm+K5uPGlh2xinMf75zfvm/Ljnoz6DIRl3kZI+KsXxtlDk/ESQtdXh+9xwNeRLE1FXn0Wj16iggcmq9mQMPftIkFyCqsD88cgXfa4/n+X1YYm19a5CrKWSCPdFoh0vNArv5k9FPdBoTN0dltPxiczyFdM0T4IShHj526V1jC1P2nmKo1A6qo9VcG91NkdBdyEUmX7baoCvgLjJ6ysbWcHCzywrdrEXvFJQX++cV9Znr8CaehVaT3rEtYcric3dDgnGSxd0sSh1MiwjwaxnCWOgYFV6AYMKUk9cnlhxB2UI+mE+PepE3qhiTqQg+RH3gvC4IPnxObtYS39N4b8qoW49wEnmrHCrVmLqVHP5bMiCR5NHxOmBz0XvHbFTwjv3Cimbf2VAsuk1Cnw3PiSNiHY9s8I7NhGynFTsXGa2JGWtZr22Dnagg5CYIgGK9w4XGMdL6MVHS916qhq9w8XEyKUZVP3S4K6ymBgNap1ZhuhA9WfsFolnhlKSRRlkhXx5naB8JKFLdvk05hXR7OQz1qwoiXI5qjpgRHkQ7rpR08jo5OScLhySncG1SbA2i0rTlqElEaG0417CLnbJcGbdp4hoQuuZMZqvi59rnD0dlJOPvmkVWnKLNKHK09N5ApEdEzaUC4OKm8+LUBjrfnPOJY9mMulMlp8PiTsuKPyau+8CJe2uv4x2Qz5wOcdvWo/YwbiBrL76UzrkKkM6E5gZ5uscN5K3nkKgergpSxM/4xG/63iu4lPFu+d1VYtjdSLeG1WCnKno=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(966005)(186003)(38100700002)(38350700002)(66476007)(86362001)(26005)(66556008)(52116002)(6486002)(8936002)(54906003)(66946007)(6666004)(8676002)(36756003)(4326008)(5660300002)(316002)(7696005)(2616005)(2906002)(956004)(4744005)(103116003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmdlSytHYnZLWUpHQlNPN3FMWnZhOHNlK3BQWmgyT001UEczbEVCcUJjeStj?=
 =?utf-8?B?WGJpSVJwVm9qQzN1blA3SWRrSmpZeDRKUHViRzZOTkVPSmpVN0dVM2UzZm12?=
 =?utf-8?B?Q2o5VmZhNFp4T2tqTHhHNVNpUW1wU1NoNHBVSnhYbG9qOUlLYWwyOTlnc1lq?=
 =?utf-8?B?ZTdOODM5MFNscUdkdVRpZ2xpQzI0ZEF6Qm04WUEyZmJBSjV6VldCbjJtMjlO?=
 =?utf-8?B?Q2hqdExxOVFkL3h3Y1JrSnd3UHptZUJRZnN3bzFLbkloNzA2ZTV6T1N1ejZ2?=
 =?utf-8?B?bmFlR05CNGJxditNaXhBWmo3am8rWEQ1TmZ3NXVGYk5ZUmRVMldnK21QMk11?=
 =?utf-8?B?K2FJM2syTUZ0RDE1YUc5WGZPdU5xTDM2UXFRRXc0MHJTenMzc2lIY0R1STY2?=
 =?utf-8?B?SUhDZ3lBZ0RPZHNXaEFnRlhIY0pJbWNjYjZ1SW5mT2QwbmFNYm16UnBQV0pM?=
 =?utf-8?B?U2h4V1BBdDk3N0Q2ZmFZSVByc1hjN056bGhqRFc1Y1kreGJ5NE0xVGlocS9N?=
 =?utf-8?B?bC9hQ24wbjJ2V1JtUlRxR1pzNHlZeG44ejNKWnR0RUhBQ2RvZTl6SmhETkZu?=
 =?utf-8?B?NFhROEtPdVdLNGVtK1MyS2tBSVFOVzhPK0NHNHBSdExMNlQyUXQrNDUwcUVD?=
 =?utf-8?B?YmhxcUo1K0h3cjBDU2dwdVFPSTBVTzBUWkYvRW4rOFVDeVh1RVBwTjNsZU9V?=
 =?utf-8?B?VWxvWEZYam04aUp6L002YjhaNzhNOUJ5VTdJaERMN2VtdE1IK0FzZXVVSmsv?=
 =?utf-8?B?NTN3dkc5NEdqVDZ2aW9aYnN6UHdRLzJhUjYvUmsrTmdlUlpLZXdnR2hzRjM3?=
 =?utf-8?B?WlBYZFVWc1BkV3ZLME03Rlo3TG83N3pGajVtWHkrMVBLdkJvWUx5TEZSWDg5?=
 =?utf-8?B?RGROcExKRzVzUHZoNnVmSFFoUUZDdHNNVlc2VzJHTVNHTDcvNDdhZWZESjVC?=
 =?utf-8?B?dHBvd2ROZUFhZTYyVHV5dzJQM0FpeDN1OXQrZ3djZThmSmxmMlVneGFoTlRY?=
 =?utf-8?B?MzhlUHY2dmsxZlJFenBaVFkxZjNPakZ2MTlRMTYxeHRlQ3NHcEUxOW9jOHoz?=
 =?utf-8?B?WFpJQmJyTnR0dWZsbkZ2eVNjcUU1TDZKTkdGS3UveWNPQUpIa2FEVG1tR0dS?=
 =?utf-8?B?UmNlZmFLZlRKRjRHeWNKZyt0aklVbXdmTUlMTzNjK0ZVbDkwdVUyeXA3dm8r?=
 =?utf-8?B?WGl2aUo2MFJUSkJBK2JEa3Y3eExzdlZGcU9iRUtuU1hFMFdSSWJiU1BRVWRE?=
 =?utf-8?B?dXk1U0tWK3VLdlhuM1VRcTZKM1Q5dlcrL1hDSk1DTUZLTUt1Yzc1RXZ6KytO?=
 =?utf-8?B?WHJRNEx1NDEreU9QRXFJWU5ibHo3ZTFPSmdzU2g0WTJxUkg3SFY3eEpCYnpD?=
 =?utf-8?B?d2VEYTRJbVlWQTBERlNIc2hIMkxDV2JLUk04cjhsQnN2VjRSWCs0NjRwSFJK?=
 =?utf-8?B?dnpoWTUzTHVGc3FJN3NOZTBoNnhxRWR0eFBaZkJBK0g0M1AyZk9TSWp1Wm91?=
 =?utf-8?B?Qy9RdWphV3dUOEVBSWtxeTQzclJXc0VmMW5NbHdoSmlYM3J3ZGcvejJYYmhN?=
 =?utf-8?B?UGEvTHcrci9YVzNwRHZjN2hwNzlwVFRNRXNzaWZTMzlZQ1ZHUS82Zk9IakMz?=
 =?utf-8?B?aGRlUmNFbHNuK1M1b1JkQmhQcHVKbU1adlQrZ0gyYTFESERrM0JvUENRaVRh?=
 =?utf-8?B?ZmJoanQzMlFJRWhNMWhFdmkvVm1kYUNrZEN6eityZWNZMmVIb29vZjJleG5p?=
 =?utf-8?Q?W3JT8sc0MQUOy2ns/ZT8v9JiMDIEySPvW9Xr2RC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81d92ad-a1b5-4de2-e654-08d97731ee4b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:18.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWeLbn60cH9RRHpPaSDpk3uvQTVsPtaDZif/mGirAZLVLTqE8yuW0K0bMMqnY5jwegaicWqqpf86O8QmuzdLegEMsdHLkMdfQtkwjoep7Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=901 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-GUID: k2pc3POYS21dwWSWlcjAxTKzk7V3463Z
X-Proofpoint-ORIG-GUID: k2pc3POYS21dwWSWlcjAxTKzk7V3463Z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Sep 2021 23:06:42 +0900, Naohiro Aota wrote:

> Reporting zones on a SCSI device sometimes fail with the following error.
> 
> [76248.516390] ata16.00: invalid transfer count 131328
> [76248.523618] sd 15:0:0:0: [sda] REPORT ZONES start lba 536870912 failed
> 
> The error (from drivers/ata/libata-scsi.c ata_scsi_zbc_in_xlat())
> indicates that buffer size is not aligned to SECTOR_SIZE.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: sd_zbc: ensure buffer size is aligned to SECTOR_SIZE
      https://git.kernel.org/mkp/scsi/c/7215e909814f

-- 
Martin K. Petersen	Oracle Linux Engineering
