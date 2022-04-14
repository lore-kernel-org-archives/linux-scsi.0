Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8421EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Apr 2022 21:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345361AbiDNVQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245521AbiDNVQv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2022 17:16:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F382BB33;
        Thu, 14 Apr 2022 14:14:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EIrgEq031505;
        Thu, 14 Apr 2022 21:14:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=n15IHJW+oFoBb4qcQ5jHIect12S40geKTCq4EPRlO/I=;
 b=0FQYrzLEiciZkX+PHnGhA6fiBhISH5e5h9zRcP8lkgy9cxww8qeluGMqwzu8e1E2xa17
 Rp27dbrl5F9mk6X1u5b7NyzTeunyFYR0Hq6ziyMYKc/B6bhSI5KWjosMRX+2VajRBG+v
 lXIasT8J2hvkJqo4+bdRWwfOJxQm5gRXnNiHlHz/u4IFPWYhk8kmKzqdysMCDUTbbszp
 AxDklyG+OftU+Ux5SXIHXKpxsS/bc8mt9y1EOLBPxPz8mZKkM7o0oUS1vHbrxB5+D+mG
 6mkD1tRRQanrXcB+PTABotjgM6suBpTM3YFIafZlujHIi2MLiY9xvhlbLw+TTIIYIord hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rse31s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 21:14:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23ELBPsq004643;
        Thu, 14 Apr 2022 21:14:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k561q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 21:14:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUrlyFU/xDKn59hzGcp4Iqx5jTNKoMvdQ4GyL83jUn6zUk0yMmc/szW0BaYbl2GusQHxDCKysSxa7YcpqCPXYv+GlPBMF7g5xxzfiJoZbsQl+YJDJwefqa/KLDUcelT1BHSjZzCMpN6gz2DhZoT8elkJ6P0QerY1wJ1+0hPPcm23tmLqKNLfxOnmgKFw0OT6daEYxPpTDOyznZhv9chYhd1nzoQiIs1bwnqxbedRAO1QdYQjr4RJfeBfizyLDQ00R3dMz63ty1+ya5C84s4XP5+m/U64GXKTm1XJAyAOKXD4DZ4bOnIXB010DWSsboOu4hBUb9dPv4hXeXSvKXSK3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n15IHJW+oFoBb4qcQ5jHIect12S40geKTCq4EPRlO/I=;
 b=UCyFj0Q5EoEPFKvHbfK4jP/U180IeBpeLURApSjS5LfxGHgbPdiV35dNHVutoHtfO+a64/HbYtsDqbkwmZRXaFFSoYY6INVWAg3bZzBNPUjthJcTYAwC0bG9nEfjbFi//FYzVZ+iQsjeSwDpLUyzTyjtc0GgscR5VSmWJF3MbmVB28GSnhjOoORR1Crc72GJUF/+JWf93fZpe6oHrB3lhSgyOCcNueAueeFjaCkhF+9c79XHKY4m9hzSkOvkB1diOVW7lEykpMMRejOKzyOkOnl0DMoKHltExxDsyRQfRaI3u6HmnCxlM/oxQOxjqZwFYhzQ+VYXhBrEPEm/Fz3BWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n15IHJW+oFoBb4qcQ5jHIect12S40geKTCq4EPRlO/I=;
 b=hpMt90ziV4+1b2WXMiKm9tAvdfFQwLoqIclWtv3pzBqbXtu1HWMbfUvsS27mdHaJSlQxi5fFK/mEdWR38eYE9wczASo4tapryXhWOrYlkvnccLP4cvRbt/X4CNE9fIFQ9Anx/kzJvjOfWNp1+rIpRJmBgBK2ZFMUwifVoalcBIY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB4824.namprd10.prod.outlook.com (2603:10b6:408:12f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 21:14:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 21:14:13 +0000
Message-ID: <16e64a18-6f59-bda3-4058-31fed422d82f@oracle.com>
Date:   Thu, 14 Apr 2022 16:14:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Problems removing ramdisk backed luns
Content-Language: en-US
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        mingzhe.zou@easystack.cn, Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <069b69ad-5aeb-5612-ae16-cb780ee067f9@cornelisnetworks.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <069b69ad-5aeb-5612-ae16-cb780ee067f9@cornelisnetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:5:74::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f28d856-6a0c-4959-83ec-08da1e5bb9ea
X-MS-TrafficTypeDiagnostic: BN0PR10MB4824:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB482470F99713DCB1CCF5254CF1EF9@BN0PR10MB4824.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QGIbarx+oJgEYRDooawJvLK/s+2BOQzhcQoQnqVEus9M6kAfqkkqmZ30jsjEyzODVi9PkjFNAYTu9nnlGvChs4A8Ngr+6waCKWkZODCQZFbhkD9O/eSU92bvXineX2usi3sJl7/4xWTrS4a1jlSI7+Zmxq/clAyIYWdKQB+zZiToKhw6YEKQH2xs22jlcIzM1aheHjW6o+IjKCzENoGH2A01BCqCTecAPOZtQFWSHwGDJj2aSK2R3w9mG6NUEpDZU95spXtpwbco6WdXP3cBf8UXNvDpxqq1/RSc2lQcBI+Os5TLcHL+F6kx9Z0GwXAtcO5kPag409rStwKk8M2wk8e6ZPJiPW7JCd3aG8i7Bz7oORf/W9EAiVC8xkAhGjznPtCPK/easo9x34mcF8keHt76XYqhRNf47fmfyPHsq07gD3k22KgQAt+KCKddFgonTU5teTjRaEj8zToTkQ0jQTXjcyU5/0L/S6bpCczb54WtwLFHtmvtnKgpGLER1CNC5siHrn7/eHSgnkyl5estHZUIPzlSOk65Og1qa3XTdSUFzK82X1hm3wGRrewIH4GtNzcDN3ea3ycUTFfQ7SCo5HLQYjVIg0u5783DdizjlG43BDdPjJLJzxtZhfqj7Q1iX1axjISG9LJLpHU6nycceSGs7FoDQCG5OA4AELM2Elo2kXp/wT/fHP2Ert/5fe4CRau2yf38VVwYqkwP+aIGRRrTqKtRknXf2Dkha5a13TtDDSXw35JtX1ePMRt4biI0wg2PrZh8eOSjur+QbYDPeUGx9edRKa2jlzaS1eQ8OshLqAZBB4LBPlzTjaPZqylwyfq3+zAB6OFJhmJc84sBSyOvW6kNPO0c9fCV1W9uxCw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(36756003)(6512007)(966005)(6486002)(508600001)(110136005)(4744005)(26005)(2616005)(31696002)(31686004)(5660300002)(53546011)(316002)(83380400001)(38100700002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDR1YkpHN3JWbGl4d0loQjA2WHc2UWVkT2RoRWt4NVl2S2hzTS96M1pBZzJx?=
 =?utf-8?B?NzF2a2Q0WGRwWktZSzFTSFRzcGlwbGIyUlFpMFJ0anJaZ2dCZDNrVjFJQ0pS?=
 =?utf-8?B?UGZHTEZ5NnZCajI0dXpieGNpUXBvQUxlQllEODlQSGdJb2NMOVVrMzQ4dDNw?=
 =?utf-8?B?SnEzK1YvZXZNdFg1Y1FIVDJZV0R2cmVyUkxhMlZYdXJiSzBKcEJ5QWx0QUVH?=
 =?utf-8?B?Q2RJMUlFNkFNYjVFRVlGOUtrb1VsazJrdmUvKzQ1RDVEWXlQMVN1Yk1qc3hp?=
 =?utf-8?B?ZlRJVTdLOXNkT2NZVTU2ZkNsWFR5WWZ0WDhLTXk1UFE3cEhYc0JVelpHZFly?=
 =?utf-8?B?a2Y5L3ZidUk0QWxBS2F0RFBSOC9zTHljL24yYzM4N1E1bmNrKy96R1hSUStV?=
 =?utf-8?B?RXAvaU1WMk5zdkpnaWY2cEZTWCs2WUdlZTZXbWFHekJGZnMzbkRnZkU3dkpO?=
 =?utf-8?B?ZWEzY04xbjc2cjU3S21pNncrOFZKb1JxdkVuVVpEK2ZXRGRNRUh2MHFSS29C?=
 =?utf-8?B?Z0FGLzNIbnhKQ3NKd1NTOG1ZVkdQZng2Mkgzc0hIM3VpbnBSbWVJT3hYaUJq?=
 =?utf-8?B?WitPRkR6VE5pMlI1SDVTZFZ6enNUM0JzMmVBYU9XdHN2Nmk2R04rYWYweXBB?=
 =?utf-8?B?bU9VZzlDaDFXOEllSFdFNng2ZTRXQzBOU1ZQbkRIZ2Y1R2FCQ2hEbnk0Uzgz?=
 =?utf-8?B?cndBVmdtYllHaC8yZWJ5QlJ0QXNkcnpjY0tZZCsxM1VyL1g2aVkrTUZ2M2Nn?=
 =?utf-8?B?bmUyM2ZaRXVCZTVkUDVDWXdWTm9nTWhiREljOElCaGpjQ0tKY1l5V24vVEtN?=
 =?utf-8?B?Sk5XWVR5bXRuRkZqYlVtZkZIQ2pOTWx3MGVMd3IzTU8rb1pBVlJBVE1SL0xl?=
 =?utf-8?B?UFpycURLR3dlY1VLRG9OM2xnM0hEK0pUendjNFlORVc3U0hSaW9CblVrT25m?=
 =?utf-8?B?Tnl0V2h0R2FUSkxrNE45RnFWR0Q5RkhxYjJsQ3czVmx0d2RlbWtBMzQwMVBp?=
 =?utf-8?B?WVhTSW9WY1hncjBWcG51NUtZV1JxUHVYNm9PS21tbGZkd0h0RW9HejRsbE9r?=
 =?utf-8?B?OUlOWGRuOFBxbkRjM0o2bDQwUGE2R09lT0hiSWlLdUtQTFBjWGhmS3BkNDF6?=
 =?utf-8?B?TGd2YWJuTkwrWVBuQW1EMktWckRYQXJaa0F2TlM1TC9keEhTNi9xbnIveWY4?=
 =?utf-8?B?bStMN2EyQ2ZrUkExN0svRm5INGZpeXVHVXhHNlB4enFDQkozT0Jvd1hWRkJM?=
 =?utf-8?B?N2h5OEh1Qk5EbUNTTUptUTk1YW0vR3hyR0NaZ0RuTHFtNUQrWkJwc2h2bnZV?=
 =?utf-8?B?SzFuT2VjZWxNd0pmRFluWHlNR1RqNXg3blkzUGw3WGF4SUM5WVF5ODdsVnFZ?=
 =?utf-8?B?Wi9qcXNVVEV4YlRGc0IrTnluSXAwRlJHSmJVZUYzY2plVmdNSU5NcjhacEV0?=
 =?utf-8?B?cGt6aU0wVWNSR2tXR0daWkRTK0MwTk9VK0dFMnlUa3JDSUk3bFRORE44L084?=
 =?utf-8?B?NTl3ZWdwanFkME9vdTVWamgvcVAvRWZwTkhCT0J1bmRrcTlDM3NIbmwzeEsz?=
 =?utf-8?B?WmdJNW9kVCtINW9IQVFlQm5Zc3BNNk5wZGFkeW1IeEpQM2YrMi9DL3VlTXdM?=
 =?utf-8?B?c3dxM0dkblBaRE0wOXJJSTJ2UGFwanBXVE1wSDB1U0hmaXdzM3AwNzVCTUhQ?=
 =?utf-8?B?cExZYk1qRFFTTDZ0dWlSRExISDB0UllMRnpidTJCVGZVRXZpYW1COUY5MVF6?=
 =?utf-8?B?STZVbk8xUXNlN0cwL2pOTi9jRTJ5ek9La1hsVzgzV2UxT0hDMUJxQzNwNUIx?=
 =?utf-8?B?aGZxUUoyNUFwbkpxTFBWdWExelRpYlNPUnQ1amV5RWNiTkx6eVBUejVKYkZY?=
 =?utf-8?B?bGhZOTlPc2kzYkhxVDFPWWFWNG1zTmJicFpGdXladW5jRGVub0FiWHcvbjdi?=
 =?utf-8?B?SCs4dlVScmNQdkN4WWxuOVFsR3NmblpwRTR2am1hWThZdWNqU3JnYkFVbUZh?=
 =?utf-8?B?R1ZZK1ZrQ3Iyb2p1eGpHUWQycWRSZ0p3ZkdTN2MvNzJBZHBHU3lBUnZoVnhC?=
 =?utf-8?B?TWhzdlBTQXNLVnF0cUVMZWtvUHd6dUZTaFFGZUtJTUxmckdJK2ljUHl3NFFJ?=
 =?utf-8?B?dnJQL1Jjd3JYcVpwVzFHVDFJMXZZb1JHQWtQSFFYY0pXKytIRkMxRWJDcWla?=
 =?utf-8?B?ZHhaT3FFTmx2TGU0Z1l5UDNRS1E1aFI1endwYmRzNXVKK28rRDJXRlFSb1Er?=
 =?utf-8?B?b1dRS0NWQkpFTVhIcC9zcUErbGliNlM1OVA3MEh5dm9vU3FHNmVnTGpkWW42?=
 =?utf-8?B?b2xra2t0N0llOHZOS1RRamNzLzNPQjNhcjUrS002dkpWd0pscGIwQzBFQldt?=
 =?utf-8?Q?4PCxOQ2WyYnzzW00=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f28d856-6a0c-4959-83ec-08da1e5bb9ea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 21:14:13.8076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUroiiPGGOGPbknrNQOSFHTtFAqWAETcDwjqKaMZtxnfTrEAIPbM8fut/yES8QUM6dFDL6wYF/VnfUBDcjXkbEAdm6NTsbK8z4fEZ+GObHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4824
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_05:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=749 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140110
X-Proofpoint-ORIG-GUID: 4hqIP7JrO_hpLAdHk_gP4hqF6Ek_Q9Cw
X-Proofpoint-GUID: 4hqIP7JrO_hpLAdHk_gP4hqF6Ek_Q9Cw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ccing Maurizio.

On 4/14/22 1:05 PM, Dennis Dalessandro wrote:
> This all seems to work OK and it appears I can do I/O to the LUNs. Then when we
> go to tear things down:
> 
> targetcli /iscsi delete ${wwn}
> targetcli /backstores/ramdisk delete ${lun_prefix}_${lun} <-- ERROR
> 

Zou fixed this in the current rtslib tree:

https://github.com/open-iscsi/rtslib-fb/commit/8d2543c4da62e962661011fea5b19252b9660822

If you grab that patch and are running the upstream kernel you
probably also want:

https://github.com/open-iscsi/rtslib-fb/pull/184

which should fix a warning you might see after you apply Zou's fix.
