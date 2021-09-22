Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C241AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF2FA61166
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhIVErd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28550 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231929AbhIVErR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:17 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M213Ft013587;
        Wed, 22 Sep 2021 04:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=JotWcaigCdVmUjPCNpGv2r47G02NYrqIguSwP7Yi9bQ=;
 b=BrDVBrLooIiQoQqylppauL82K0r5P976H9F5+WtAdXMI+FozmAdmlZXrffWOT/wCUlxX
 izH6oyw8R89jY9bbIqePRwKS3sY+GvuL5wntBr5q6vKz23vvEBNQhAxAhIPokHuaSNSA
 As8zFY5UoGjHaBAJ66FEGE2lw7hnyKNuDnShTCHfOyUR5MZKmKdJQ4S1ki1McMPwcsok
 YybuDc3lyJKO2etQdk6yNlsjBZ383BpeUdIeWS7tf5bpErZc1pPcAnDSnZcBNhx7qD6W
 7OKxSl/AtJoEfOOJMEyt45Rjch5QW4l55aARB8OsF/xQ2Gb906ho11i1/thBYpOyCOvn Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4s1b69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4jZs9178811;
        Wed, 22 Sep 2021 04:45:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3b7q5mc7nu-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NashB3+a/cQ+9RMKOBiXavgxqgQj4EB8+5QnPl20UGPZRpKdnp/Ht3gA6sJXP19aLi0+11UYa/tV+RNWc7VkWMy6F71Jj1fQ5kNt295evN4zxNqBOz3rsQTGDkYN9LLUc2RE1XUtyuNvG/s21qnlp0/CFJXq5rcUYujxY8HwOVIWSVl7tVIT6ErXt/+YbPFeMqYgChRrY7lqTdXbKwh8a+NrIwtX21ZoHrXUlkBp1O0DJglUGxZPWRa02IaNp5nJitkJJH9vSO5QlBwTo+JQXNms3tMTJVODMI/zX7zhygjgoLuZW90IARH4GMFLShe7gAd5p9qcP+qfkVnMFCH5xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JotWcaigCdVmUjPCNpGv2r47G02NYrqIguSwP7Yi9bQ=;
 b=cvGEO9S8FX8FKM1ypQRKTDVWlI5lM7H79ThhadVQDZm9qmSykA57Zy/bEmul8++3tD1i1peDvmRTHocrweB5sfce0NxSN20MM2HZvtJ1gqR3TlQ+msYW1if22CaM+3vV674pxol5M0zROwBeWPoXqxg96XbdDxyvZD2jDVIBT2SMORx5jtrcRJfYBWcg0SQ+/53w9RQzqI4hv2ibZjf3hxleulnJ6F8+3fe2TrUpoIuqcJY5yWqblGccWm4G+PzU68vNwhNwiFH+GioHlveGzz0gILYGWNS0ENVdHPeu77WOyPHBZhrRoYL5OteJvkdbLToU/s7LAUI24WZ232/l5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JotWcaigCdVmUjPCNpGv2r47G02NYrqIguSwP7Yi9bQ=;
 b=VhfnkU3VH4o9Q8ZQeXfwkdRdTl/0fnd+18l1O8ea21/Sc5/WckC4JN7e7Pr0TZW/P5N1Wn4+9wWG0r9+/VL+/5nuJOjEOf6rK3f47kCTn18dHaH2zJz9o/YOJCcpWCkXU9Kcq1vl6dOhoRSzT3RT0Q+3uDfbzqOm4yJN9RGMAIE=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hare@suse.de, Muneendra Kumar <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        emilne@redhat.com, jsmart2021@gmail.com, mkumar@redhat.com
Subject: Re: [PATCH scsi:fc] Update documentation of sysfs nodes for appid
Date:   Wed, 22 Sep 2021 00:45:22 -0400
Message-Id: <163228527481.25516.10148464763732805960.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210913015853.2086512-1-muneendra.kumar@broadcom.com>
References: <20210913015853.2086512-1-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43b7e203-22c5-4411-1b1c-08d97d83d2b8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB445601ABF983CB9F2E3E54018EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LROZr6XJKWfcGSs2rATdo6vDBvEsTHqSSAyuUgIEEim9lhHL7FmgiLWy0+aqcyC7L1MRaY6D3R1S1ryfpxpIVRzZdWZ7UC93X0ON9RQ2iYCY/y63Wh0RPmpMPk22NOwlM+oa3bOxE3OhPG9wa108LB00yNZSqedoGxnaZJBqppRanTYn8mbcBru4ODg8NdTlv7e+zUilQsJDNFFb94gQWaepPNft/fn0BmpQoNuRzZ5FdnrUN8QYtm0H6K8Z9/YwYJ7XQk0BG//9BLcXFcUNPcjchFEE0ejSJ5emEVC6eqbG4219OJH5eNpF2l1u+zDO1uqX94XiqUkXXj62aZ/4c8oo3m3o2cbnkSyz/+pGP7WKSEFY3Ntmjd9XI9gyc9/NAqepE8dUUhucnvUFs/ccTnDXeXM89hj0MXAUKHzo8hW+9ETTqYQ5edPW3Y08+LbzFf4K6zxQ6vLNHgUYarogwOrt2dDhhGmY1tVlnSzkG0UrDQR8HMiB+fuDL26QEd2oiAtmmKh3kl66eZGLSeWrPuAnFMXpu5wVfhXDR2mZrhEHvZnj10xrV5gdFd6NtWrp11PX/Up6EdFjCOF9RcDmXkAHNd/X+NJow1FfRfzqsRpnJZxFSiQfE8pnx5MBaCPxeJ91y9m306MH/XEK5ICiB1tun2DaMoi33qJWiUNiYHZuvSTXrA2CVq9341Iw91P2d9gDdNnWNQ/3cmfapK176MB4kxzK0Tq6PylAQK2tFBQ4jEL6ALshaijkLrEC21Gje5ZnGuPrpWSUjWg+rCqQmwbXcsLFQZRArBRk9OSWhZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(15650500001)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nm1rTzRUR3NnWjJMbmN6YVE3d1UwOGpub01aQzV3TXZ6YU5UWlZRclBuQUNG?=
 =?utf-8?B?UlA1cW1Qa1JMbXNuZ3REMHRBd3kySGcyRUNYeWRGS2hNeHVXUUJOQVVCTUZ4?=
 =?utf-8?B?aWFQa2RLZU42ZWplb29QWTdjc0ZiNm02TjE5NzJaa2puNzBPRXA5aWlhQ2lB?=
 =?utf-8?B?b0lwM29kNjJ4dEhsYkZtTVFmb29CeWkxY2tYaDlLc0UreXJ0bDZ1OW81TTN0?=
 =?utf-8?B?M0M0K3lZaEFjb3BVdjR4bFNRc3lPUXpwcFZBQVJkdHYvVFJiRCtNNFdJNVpl?=
 =?utf-8?B?VFhIdzdBVmhEU0lONkJyQWI1SlNLcDVyOFB5c0xnSk9yT3dXeGhqRThrUU5p?=
 =?utf-8?B?TjEzZkw1a0dyRVh3ejBHSnUvMXNDbEpBUWtqY0FuTE1XTmZsTmQ4WURJc0Ju?=
 =?utf-8?B?VnhPVTRKL0w5cDlHY1d1QktNOW52SytuV253NGZjY1liQzdOTjNQM0lLYlpk?=
 =?utf-8?B?UWh5V3ZmYUlvQWtDSS93c3J2VjdWdjBDdTJYa2Zxa1ZrN3Q5aVVmUjZQSWRj?=
 =?utf-8?B?VW8rbnFpclZRY0lTR05MYm5QbmQzYjBhc0IyZ3VhYnZLYTkrUkpVYXBGbUxn?=
 =?utf-8?B?SHdkMWgxZ1JoRUVIclpkQjZOc0dJUGxZL1FUdnRhcFdkTXB1SnlQZzV6R3Q3?=
 =?utf-8?B?SnYzN2pUY1pHRk9DNnMyZm5jeGJ6bzQvN3VMZjN4QjZ0RHVGRGJ3cmFyd05h?=
 =?utf-8?B?T21ZcXF2YjhZRmhnVVM5RTlzSy9tUzEzQ1NiOE9UOW5EUVk0UVZpcUdjcGJq?=
 =?utf-8?B?K1hOMFRHYnJ1TS9YM0ZsM0cvbSs2eVgxRHhuMWEyMVRIVUVsY0MzZ1o1NG9n?=
 =?utf-8?B?Q2w5UWtxdlk0dDYybSttWG9zTmo3RFVLQzN0V3JtelYzVkhLOG1HYmVkZWVm?=
 =?utf-8?B?NTdwVldPZk5JaVA0bUpIM3Nxa0lDVWZmOUY4bUdWUXdkRVg4bVZwdzZwdUpk?=
 =?utf-8?B?cVpkNHF4Y3g4OTE2akpBT1Irb1EwM2FtY1ordGJqWFNnTmdOc043bm8zUUNX?=
 =?utf-8?B?Y2twK1dESlpkendWMU13WEozZTdJb3N4a2F3K1ErV1MrUWRQTmhySHhuOW9S?=
 =?utf-8?B?N2s5aWpNMTZWcW5ITTAzcEJZQWtIVzY2ajRGN1VLbDZ4NTRzZkxsVFJlQ29r?=
 =?utf-8?B?R2dYbTNhS2pTSHhveHJCZXVjdnRDSWI3eE1SWmhqdmtmUWplTDc5R2J1d0hJ?=
 =?utf-8?B?VlZDd3VHMlY1NTUwWXlCTitrRE9MaGgzYUIvOWdqVk9lQzhFaWZubGprOXhU?=
 =?utf-8?B?ZmVYWmxhZTVlNWpTZjBwWTNzZ2o5SVFERmtUWHJmNFNQWkVsZnFnY1g0NDJT?=
 =?utf-8?B?amoxWGZiMGdzRmhKSys0Q05DVGxBR1JjRkZPMUNRR2Z2bzA5dC9wOExTNzBS?=
 =?utf-8?B?LzdlR0huVDAxRElBQTVwbWlCMEdZdVlUVUY0TEtJVVozQjZUL24wVXc3cWxZ?=
 =?utf-8?B?YXRGWGxnby9jelJseUoyM0hPT1ZwQ21Rb2U4dTh6NzhDL3Zpa0l3V3ZQMzNi?=
 =?utf-8?B?KzVXcHNjWVovUFpGUVdZL1RGd3l1YTh3bHlBZGp4VlNXanFwd2tQMWRXb3My?=
 =?utf-8?B?bEYrS1l1bXZ6cWVvTUxVSnIwWURKSi9NQXdGeWM2UG9vZEdpVk9wWHdLU2VN?=
 =?utf-8?B?YzZLcktsRkNHMUNkZkpDRkJrbE54TkhBdFUzOWUwOUE2TDE4dkJSVEZ6U3V3?=
 =?utf-8?B?ZERQZTZDcDBwV0dtTDdxQVBjMWV5dWRzdzV2SWY5cnBabGF0Z29GN2hXMGVT?=
 =?utf-8?Q?tfcY43ZGDM1+R8CZ5dPc832TMGdGtAWv34Fd+cx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b7e203-22c5-4411-1b1c-08d97d83d2b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:38.0677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29E8w/FIB15BSVEL1VNEFKA+HKCsqtr7hXvwp0PHOn7WsE/Fw0ehAMaa289SvsnSvjM7C+xOHBG061Fzx4RUk390iSVVJ9AteiB+NytCwcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=914
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: MksjSd6Y6DSo3WjTzvAfB_JEI4m9nybI
X-Proofpoint-ORIG-GUID: MksjSd6Y6DSo3WjTzvAfB_JEI4m9nybI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 12 Sep 2021 18:58:53 -0700, Muneendra Kumar wrote:

> From: Muneendra <muneendra.kumar@broadcom.com>
> 
> Update documentation for sysfs node within
> /sys/class/fc/fc_udev_device/
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] Update documentation of sysfs nodes for appid
      https://git.kernel.org/mkp/scsi/c/e9d73bfa8e04

-- 
Martin K. Petersen	Oracle Linux Engineering
