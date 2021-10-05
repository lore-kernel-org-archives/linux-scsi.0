Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E73C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3F86136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhJEEfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:35:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23758 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230457AbhJEEfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:35:33 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19531wk1019448;
        Tue, 5 Oct 2021 04:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Kptb1oU4r28QPg72U4CoGR/ESk/gVOk/1n1fnwJ4S10=;
 b=hi5Pm4q29JUHrlobY8rKaC7t8iaAjQKWNOr8DLW8Htpl5IMgdK6DzvkBuZhzeuhqRG6i
 mq+PiJkyAauo2/u7H+Pe4d2JTj9DceBReT3lEWo0E4oV4U96dzHbSkGQX0LtNWExmxec
 A2ryeeTROKswb93V0so59Xvw4m+NYo7JDb9kZx9QnOsmWffiaUMUkKGb9UgUfSnxDwjj
 hZtuteaa/4br4rxy/Zx+QQoA0Ay8pfachdpYY+j2hWtNrVPqhgFnlUk9JQ24/+YhcAL0
 nM9CCbDARrmtJHaFzBTIGfIMcSAOkLxJmxlQe4iDxsJDnWbDeGWquVH4It9by3fXlxvj og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3p5cwvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UeRF029951;
        Tue, 5 Oct 2021 04:33:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3bf16se2aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3dtW1k9ZCzB8k1+en8AoMZK0LQm5zr/we7YOHA1ZmMl/nkPxxivtwSUSk+nj6p87nQoC74xaoNRMXuvRsH8yoOvOtTYepOhIImuqESuO+OUu6U23V7jXHg54y8xME8wOYRGepO4yZoJ9mDI1DsKAH/DFlsVW81nSXsz3SWc4kJWIzmqbTkAWnKwc1Ew7ld40tez5SnXL9iXOvDfzaEoJKcahFMTyeY/6dd654mqKdcu8OIAltjiq2nfwUg7SbjeCfbrjKRxmsGIQqA3XsPaO24M6ybJlqcR4SdwlK+RT03SQMbjPVskzxKqnppE4J+Sc9sVucl3DY5/UYiwdVzAXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kptb1oU4r28QPg72U4CoGR/ESk/gVOk/1n1fnwJ4S10=;
 b=XnDZy7HZmAN8LB4d+h/O/e+58ftpqbuVWR3WEAy+6dt1L5Nq70MWvJYWF3JjOzzvXBuM1JyfPr+xu7o8L96CfZs5zCEsTIrswye9BtRedt/4J0Z2eXFstJZ0k/t3W4LU68z9bbjfkeAxGP5uS0EhMpYQOi5W6HLQJXYZo8gnKnmBfh4HLRC1VCqTa9PPKXrhcwMIiVilXGQemICW9ERqBYrfs6FcJAa8tsAWE6nsyzuk8EkfXpAyHe0zAO44YQjtHlJXFi4oAmq5atAOz4jDeXN+/E1/CWPOlVCLiyOpE5FmVoOTKkmiCDNBPeaeQ1lK26g3ZHFLMPmhteii8uADkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kptb1oU4r28QPg72U4CoGR/ESk/gVOk/1n1fnwJ4S10=;
 b=aD7fH15KJRHCUvv1PyZ1sZqw4l2TGhNUirYshJTktCuyGOryl4hOoi33Pr4XC5kydZQVRQ4CPOSkb7inn7HTWe0PCFhYIuLJQhagGxoLVvsmGYB0xB/t4qrpHVJuWvb0+pgbzaso7C5Q82w81rCFWOpHAUzIXZtu34hhF+byt08=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1885.namprd10.prod.outlook.com (2603:10b6:300:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 04:33:12 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:33:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>,
        linux@armlinux.org.uk
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, hare@suse.de,
        linux-scsi@vger.kernel.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] scsi: acornscsi: Remove scsi_cmd_to_tag() reference
Date:   Tue,  5 Oct 2021 00:33:01 -0400
Message-Id: <163340836499.12017.18152450497268944484.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1633002717-79765-1-git-send-email-john.garry@huawei.com>
References: <1633002717-79765-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0096.namprd05.prod.outlook.com
 (2603:10b6:803:22::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0096.namprd05.prod.outlook.com (2603:10b6:803:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Tue, 5 Oct 2021 04:33:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66ff8f9e-fd8d-4224-829c-08d987b93d6c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB18858840BA427FCF946F36888EAF9@MWHPR10MB1885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JlAX+PqUI4I8MHA4V0PUNTqNuu2OBEMo2TsezTDuKu1e0v+KjaQima3KqS6mxu1cb5Fs8K6e0kXklwnNtckr0M1RUj7Vzwwx7uGMcYxeMvVbNSDUBlkTM05RyP5ab/X2zXQbeSeNYgSsl84kUH4+I9RJxaWdthh8gBJBgvPRn+7mJOFvk9+0QpF20vicD0gVq2IIysZZm+4eyoE/FMbLNbPezOsqqT5xHsTo4xiokDaE2D3xGHY3g5vQl3383tuJb1QFcb3IQFCin6+qBKN4apYB1XuWNrrZNSwoWNHWoVa+ZvHVQK3ZbQ4reBuZ+A9cVVtgmjcoZX118zZCrp6OTN9xp2lW5Q0KTu60jQmRweqNDEInrVOJFHQME4Y47wfL9BF6nyBQhXpuDDe600F6oEMakzdoxxiDXC6jYe1mrM/6rUKWYaoLyDXUc/UrUpuJytc2bYWWS5nozzEOdD32/U8U0BWACpaKdp/CSgdAHCxuTme19uZjuHv739l1+AYlLfQl/NnF2SqiO2Q5JfbA9Ty3Uz/fL1SqEeSRBxbNRKjzNbj55kKWKP7edlXQtoti01LnacziX9N6UJL5Sbv+4vUJgJ5PBKBBWOV5ebrrt18aGQvdi7857sEYHyHA3nqMzRcFEZ8O+Qt6cLZzld8NkkW8sgk1aNqbcUP55zR37fGOSFA9F4zu1uE31U49JkaACZzpvG3VrFhyeMFE+Xhn7yx3qwQ1f6sMJG8nRTmoyWyxnrsmRp7N4ZnCt6wkHOAo1T29N94BLmBjDploYpR7UMVocWMpxjuMaFOeUU8mNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(956004)(52116002)(7696005)(6666004)(86362001)(2906002)(26005)(36756003)(4326008)(6486002)(4744005)(38350700002)(66476007)(38100700002)(2616005)(66946007)(966005)(66556008)(5660300002)(8936002)(103116003)(316002)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnhOM1EyYWRGRFhTVm9BNTNvSktaLzV1bVdXcmtwSXptRDYzMVBJN0NnYisx?=
 =?utf-8?B?T3dQclFZQlpFVmRhSU9TQUkyNFpPS0FtaCtjREZuaE9GeFNLNU8wWFd6djBt?=
 =?utf-8?B?UXZJT05WMUxqSzJCbXVkaW9uVldva0FOSDRFRm1LQ3JTZEszQUg1dDZCZW9i?=
 =?utf-8?B?WTFPSXRqY1hKVENHWFdpUnFIaEJTNXBoOWdOa0RDYjA3NElmY3ZsdVN3TkdD?=
 =?utf-8?B?UXFramZOMzhDcjFqMTU0QjFLNU5SVW5LNjZlQTVrSWowb0RYNFc5Z3hwT3c3?=
 =?utf-8?B?eUprNkhMaStxRzhyOWxkTm1ERW5JOXhkR0NqTTRFYk1CWW5IbFZsL2JIVFlY?=
 =?utf-8?B?Sk1WanBqcEFncTF4dVBIb01GUVNYeXA5TVdad1Exc0loSVdvdWtMeHlSYVJN?=
 =?utf-8?B?ekZMUThmY3c3RjhtYnlWeVlvYUdNUVloOWdiTlBxYzN5TGlYSEk4VUVvbmxJ?=
 =?utf-8?B?dDJSNGVhRlZUZTU5SUNzMkt5Q2JMQ3lSVGdjaEFvd0NqNXFWVWp5azBhQWxF?=
 =?utf-8?B?L2Q4UFd2b0pyd1Y0SjlHenhRRmNTYVRZMkZ5Yk90RlVkdTNKdlZERFZPQnBs?=
 =?utf-8?B?S3F2TkxFVDZmQWIxZFVEU0JoYUZ3V0xGZU9sTmVNMlBjVGt2VVJJQzRneHVO?=
 =?utf-8?B?d0lmc2twckQxRGFHMFdWMEhaVHJKejJNTEJjOTkzSWZjTTcwemYxR2lwc1V2?=
 =?utf-8?B?K0hkcHFhSmM4aGt1Z1NTOXdYNitGR2VtVTBjaXVNbXprZkZBODRUeUJJdTZt?=
 =?utf-8?B?cTM2dUFsKzRoWENZQWJ6N0VGSkNpMml2L2ZxZUUzREd1eWR5N1N0amFGcWVG?=
 =?utf-8?B?S3pYdmJXdXFSS1lMd2d3ZkNBUUd6cDJ5eUFlU0c2REEyZjZ6TW9KbGdHcFoz?=
 =?utf-8?B?aWJ3VXUwYlI4c0Q3ZG5oZWRodEM3ajlxMlBqTWFTRVdMeFZCOWxiUkQ0R1oz?=
 =?utf-8?B?OGMxaWU5eEJTQ0EwKy9oeGxHeElkZ0tJSDlPWWtueE5ERjBGT0VMM0d6K2Rk?=
 =?utf-8?B?MUs4dmtNY2NSK1lxeGc2eTBBeGhCSHBIelFQS3huRFVIT1p5R2w1a1kvQk1k?=
 =?utf-8?B?bE5ZcWJEVnNUc3Zyb2twU2oyZEpWUWordWZQZEhLa2p0NDRvT3prWVNqUkN2?=
 =?utf-8?B?OVUwanJudWF1MVp5d0NvZFVQMmVSRTZ5TzM1QlA0dzBPNXN3NjVmUWpXa25S?=
 =?utf-8?B?TU9Nb1F5ZSsvbndUK2hzam1SZDVtRHprWEtNa1dZYXJreTdpUnlSSWpLNytM?=
 =?utf-8?B?Y1ZVajRaOUFQUi84MUNpU1VNbzBERDc0WkQzU1NDcHhEcU54OFFTSXpiUmtp?=
 =?utf-8?B?cmtIdEpoMHFFNzVhRGhqQjlwOFJ4SktVVCtObjdSV0ZEMHJxQmkycXZSUkdm?=
 =?utf-8?B?eTZiYnpJN2ZmUEovLytGUnBvNEoyZG9GS1NFangxV25qMTZxWStxMDRSWWhW?=
 =?utf-8?B?VnE0RzlZSVc3a1VwRWFWbHNOeDFSWXEyOTRkQndHTG5RTnY2bkVRWnZwUkJq?=
 =?utf-8?B?NFMzN2ZRSkw1anE2SlNlWndXbEh5azJqRld6ZFBKTkNKZ25CbHlLOTEwVzJq?=
 =?utf-8?B?dE96TkYxY28rbS9CUE1YZGpVdVVXNVc5NlJvWC9UYTdlUlNScWFNS0JGczRi?=
 =?utf-8?B?VS9JQy8xMWpRKzh3RHkxcExuVjQvcWNwMlRoVU14VjJmKzYvTXoxTHAyenh4?=
 =?utf-8?B?UkI4aldINVJONzRJUHhVclpSNkJlUU9Ea2p2ZTVaMXB0c0FxcDl5WlVFcEJ5?=
 =?utf-8?Q?6VlSTPuP7SL5Z4g/GkOIaORFD5lgdhG9UUWnyZN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ff8f9e-fd8d-4224-829c-08d987b93d6c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:33:12.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/2ckaY+o+26/LmmajXC7PKGPS88CNaFsAjcbQRm3ek8UaBEcQC9UtXJw3rzDpNGPSR5DVP4Zf65kBPgY+xd7zhaYZBQw1RCjuA2jGEQwzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1885
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050025
X-Proofpoint-ORIG-GUID: 7aj3glbkU6GtXSJIxGBvaxITjUkzF_Tw
X-Proofpoint-GUID: 7aj3glbkU6GtXSJIxGBvaxITjUkzF_Tw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Sep 2021 19:51:57 +0800, John Garry wrote:

> Commit 756fb6a895afb ("scsi: acornscsi: Remove tagged queuing vestiges")
> mistakenly introduced a reference to function scsi_cmd_to_tag(). This
> function does not exist as it was removed from an earlier series version
> when I upstreamed the named commit - originally authored By Hannes - but
> this reference still remained.
> 
> Fix by replacing the reference to scsi_cmd_to_tag() with
> scsi_cmd_to_rq(scsi_scmd)->tag, which scsi_cmd_to_tag() was a wrapper for.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: acornscsi: Remove scsi_cmd_to_tag() reference
      https://git.kernel.org/mkp/scsi/c/c5336400ca8b

-- 
Martin K. Petersen	Oracle Linux Engineering
