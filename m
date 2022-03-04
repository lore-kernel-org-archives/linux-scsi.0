Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBBEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 03:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiCDDll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiCDDlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 22:41:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DA717B0E8
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 19:40:54 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240c5Kk014127;
        Fri, 4 Mar 2022 03:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=x+S3nehU+GMWpQrhwNDcG78YzPllaG1nSvovTncK7t4=;
 b=LHJzDXwDIM1EU/hK7XHvd5P0r4lUdrK1rg4/cK9B0juYdm7sbWOMCyNWCWBHIpBioqQN
 KhokXj93IzwPqvYz1ZR0dB6NanjgCV7maEmAJ6s6n9aSSvVxAcKBbTnrj0IWf03qJ1KN
 RcC/3HB9LpU0UEgf2W5F4TrfaWH4fb+qW46lGJYyzHDfauPEg4YayMDlRp0KJIHC8V1t
 W1lAiPVPMbgmtTBvvrtXt2iQSaRZrTA2+WaS4UunF9dY8wEVMhiqGyvCiSrCs+Q0RJmE
 ejTrAR+LJby9yHh4NVPHUwSGfvQqah5DUv4qmCTI02zBIvIeIyCSgplu2MDuUowz2xa5 Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv8nsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:40:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2243aDTg107993;
        Fri, 4 Mar 2022 03:40:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3ek4jtfxt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:40:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3avsJIvrN8nkuJtQtVS+KjIHo7WF/TF4qR9/xdBRcj/HcYhnTK0hC7kVBoSHTPbhBdXbpcCbCjDb6gfkWEh2Ma1GBxqtmnhhdZpEegnEBpIJTV6PJxIrq8CpH04TGzXI3X7lhXLLoNNIy83LOSmpDtgKDb2ycTQL6iQqEhrGOsJeXwDKXdPPylWeZ4guUh3V3kAFGAlXPQSpVIP5R7j+TcgeqhhOTihtHcaf6KWAqXz0Q+qvJXdk8nxrIbtBMJ+am4i1TNAuS7DCuddecpCWmRcWc78rI1C15PUDGZhFfYsAGtVQ2P1j6QT6j0EQxzpK62acjjlFaJrJwXblMpvsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+S3nehU+GMWpQrhwNDcG78YzPllaG1nSvovTncK7t4=;
 b=ULI6jvmCPPj4PGVLdKNDantzS8FKLXLDMfBXEmL/nZ8koj9h2xsQcGt0I5rp+ognR4Rj792X7iTCh262MsBi0IsC1DkNALEZf8erKTDu/bpAjjthlFCkQgWOJKYqQYb/qhWjAwiQ9q3nlkh15DSB0KpGNBCrWx+dCMQ9oPeAw+LPdJGZxlN+b6rIuqA53QC5XqzCQLrQnK2oT7ZaN/If2Pue11UjAACr7m/QgCPYixssT+7c+6aVhbDbtjB+aY3w9ccfvW1B5jANuDmI/WLWreO6f+1rshPXLvBr897ZRZn60jao9wkV3iY9e3gWfJaKAzAH10uw3XVEY7sQp4WS9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+S3nehU+GMWpQrhwNDcG78YzPllaG1nSvovTncK7t4=;
 b=L0BPVRTPLDkx8JymB7xxA07fo//GuTfqCZfPyc4QsEZB/FAmv7wQda9JLRZ/Ti/GIE3/mqklS2PL31h1w745C8Fjqt6csa3b81080xmvGyZRYvtNuZrOvTMV1hiTF6jlIALPYKLiNop7aQrqz+em+6j5AXJQhLVvM2lMgRhwhWQ=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DM5PR10MB1497.namprd10.prod.outlook.com (2603:10b6:3:13::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Fri, 4 Mar
 2022 03:40:44 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:40:44 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/14] scsi: core: Do not truncate INQUIRY data on
 modern devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mti6tmze.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <20220302053559.32147-4-martin.petersen@oracle.com>
        <82c21426-4d23-1e5f-ef9b-212d623eb8f7@acm.org>
Date:   Thu, 03 Mar 2022 22:40:42 -0500
In-Reply-To: <82c21426-4d23-1e5f-ef9b-212d623eb8f7@acm.org> (Bart Van Assche's
        message of "Wed, 2 Mar 2022 16:14:44 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:806:a7::30) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41ad079e-49bf-40c4-f180-08d9fd90c32b
X-MS-TrafficTypeDiagnostic: DM5PR10MB1497:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1497EE28B3683A98BC6B2C368E059@DM5PR10MB1497.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JErlQXp+MgXZaQBZ4Ybi7H6hMG5pXbbt1MRjFJtT3o36rsL28a9TRgf11p2n1HWBIFPd6cZa1/sUqbBQI6D3W6Wtr2AGdptuEXvsq6LLMyd9aqJXETf2Ti51da+0oW6sJuYJ6q5WiBH66F8XOq7deE14pJDhOcXLsNwJVqfqWTAB1BilKbArHxHGJwoLPMTDpUcOmyWnXCl610WNgTLik5DqVyLIAH1V4anawfaHgB5rPG2tSG9lAYWyErGtRk6IjJoXCztFzZq/RITMTlFRMh5Ef+56RBmA+qL4I1Br6I6Wl6ZGv47cof5ZDN++iN5Sx9k6PRqHP/0o39TyZBjVPzQwhmqseeIlEROHBnflWaYHKLSJJ2ZjM7jELPoEk/Mmf6WKgF5JEyYJ9cqlGfRSwEeUh1t7JVibFrTZxJ1kFihJGOjAO0dtChEpo2wp/IjkxKHJZBo/4dkT8e6RmMkfv0Awpu3yY4AEr+17U8ZEkJAj+X8ZUVRMoVoxiYZDWswOnmhXpTVhMJ8NBWWkW8A1dKz7vPltvC9oydkmM91d/+UVqxr9gzGiPmlnJ6m9JYKeh3ZR44LjUD+Ef6yGuhVjXekH429vZuVUa4iIfpypYXq7qxSWkQ052g4sCwoBzdECgvwykSwcCgvIMdENQZzSKmdBY4CIWPWgU3oVXGMdSJveFs0xloICRoChVQP1tok5a6L1sb6+1xqbmAtzr4Rngg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(186003)(26005)(38350700002)(5660300002)(38100700002)(6486002)(2906002)(83380400001)(508600001)(8936002)(86362001)(316002)(6916009)(66556008)(66946007)(6506007)(66476007)(4326008)(8676002)(52116002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kdEW0oWY0RhWrIzIirRrc46NbWH0MOkK7ICdZ8Qi7d6L+eub8yCuqZe/jXwB?=
 =?us-ascii?Q?Em6EHBf72/i8ZlEyABZ/H9clZOj2z5VYtQGB9p94KTm59nh9sBIA8BiehGuJ?=
 =?us-ascii?Q?zKuD5BjMfx8k9ZkfGKfI8K03kftlIABCNjDzYiTtJae+AVYALVyOG/HfX3PV?=
 =?us-ascii?Q?d0GkD7eI5G/O82nLkjiKTQGMxfHSHfvOuKoOvNzEi5omKgFKpq3ebUAUWR7z?=
 =?us-ascii?Q?jsiABtwnwBwotekkm8YcZbpEf7WxmvWM4y/fb99mGlDlB9YRkZrZmnOAC9Ig?=
 =?us-ascii?Q?fwaAmGhAG5BJFzHCBONuzmS6g+rHJgAlpwivw0kj3FxDvkcC1oSgr7TgVgwh?=
 =?us-ascii?Q?toSMu4BgL6HWXWA07toG5YgHdA3khbZ/whmMlwcyqMbySN+PmV5ks6fwv+Mo?=
 =?us-ascii?Q?k0YuAfR7eXJQmSwkvw0tU55KmXI9y/IfTaOBXfor+lBSBYMTCcDsfeVoVxDw?=
 =?us-ascii?Q?YeBg0/VlvDL3aaTJU0lf+qMmKhX0zXrFxSBrhhxKMCjSWqn5wTf+qRSqEeeo?=
 =?us-ascii?Q?AyCWH+MNuYbMZNolchgfzu0UTWY3q1kiq3ms6OqAaJLNdHugT7oL6kNmxqcg?=
 =?us-ascii?Q?7zvwH6ofvtV8sqEqFzQXMoQejBop99DY2lZTjIix8MVa4dFU1niVh5stAwky?=
 =?us-ascii?Q?OAR6EAoipkP/YxNLhB2gTsWUL6sc2t0WAKGfHni3VC5cBluL3Lsppgr6ZmkT?=
 =?us-ascii?Q?oAkCpkWKC3v7PMBDA71NOxK6QkZJdKDhhFKamFDBQaiuzZstU5fdZE/vLazB?=
 =?us-ascii?Q?Mc6tAhcEonjuoBQTOqXXeNoiG5nDvHFFS+UWk6jskKbntN5dRv1GzbNVzc3X?=
 =?us-ascii?Q?9r+623obdpb4ifauBsBY4dD5lwLWYwv4dTt7CnsNfkliRcOzr3Zj1IKyXdnt?=
 =?us-ascii?Q?Coj6xGx0m2k6y8NYpWyDX8ACzkuJbHcZzBl+2fy3PZDncxCVYVwa1VkUgMUM?=
 =?us-ascii?Q?3fXbcZntEUdZ6SbRR5TiOysxlZxx5zeuthtLG1daCKHgZC+hS1tuOTFqNXY3?=
 =?us-ascii?Q?SPh7uZ67u6B9XBqCWLBXzbA9k7k0RI3VMKGR1whto1UZS+NZUL6e9RqDpSGw?=
 =?us-ascii?Q?1ndEhRnEsU0QQ4dgwbKfqGA8tf5sAvftppFiHlWECWNAG0lBvTa73FK9c1UN?=
 =?us-ascii?Q?PCHoNsodR8rw8pIXCADB4zHrurRkYFZIsXgS50MNcG8UzTGCVzwyhszRlwUK?=
 =?us-ascii?Q?chY1srzab917kNl22w1s3JauCdYfcqdX3GB27lbDe+TVetN2hD9dvEE7BzW+?=
 =?us-ascii?Q?j3Bc3asF8M5UKzYnoWJRcNSG/sOEoRXgon3FMFL/YcWnlWE+0WUmOKm7v2x4?=
 =?us-ascii?Q?E/oyydLcBE4Awy1c5UNC3ITgRQDR5E/wndA2UaNe62RJO7gzuO9xutcaEbMG?=
 =?us-ascii?Q?6M8I5lkvJVqXHH0HaFl1m5TLf7rEs3HT7rqffI9ozynbrsc6pK5UJYgcDVSD?=
 =?us-ascii?Q?6bsrZ1IFarackvupOZAAzlJ6NjkTC2ZUeCzRYOI9yj4GuD9VwEE4rI/hg2vi?=
 =?us-ascii?Q?VMteUhStkq623P8D6Rp+p4wUNpF6ZdLBwbw6BvAHi55QaJGQOMGmP0wp650K?=
 =?us-ascii?Q?GRrh6PayTOKR5uY+6W3I4sQi1LnoXSnTzV2iDC3c7AAV8/g0UVpTm9MvB4R+?=
 =?us-ascii?Q?01u8k2AVzgn5J/NXPTMhRZ6ui4RvtKOZELoRoJsR0jLhSEGCsSYtK/JDTLWA?=
 =?us-ascii?Q?WphggY3a9zlMHh+7/yK4H6NTakw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ad079e-49bf-40c4-f180-08d9fd90c32b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 03:40:44.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQqmbrnSu+Rh9KqrDzOZuh+Qlp3imCBu9mW9zFr6W4gpEm86qjGvX++x1PSANNXUk6lxgY+cKTCJ8MAu3TF2EDjBmHe7XjMjPyZUOOOKWos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1497
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=897 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040014
X-Proofpoint-GUID: ZYf7Xe1WF-wtaZTEnBL2Wdag2KcWyTfJ
X-Proofpoint-ORIG-GUID: ZYf7Xe1WF-wtaZTEnBL2Wdag2KcWyTfJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Do the benefits of this change outweigh the additional complexity
> introduced by this code and the risk of breaking support for certain 
> devices? I'm asking this because the number of LLDs that sets
> inquiry_len is small:
>
> $ git grep -nH '>inquiry_len[[:blank:]]*=[[:blank:]]'|grep -v scsi_scan
> drivers/firewire/sbp2.c:1508:		sdev->inquiry_len = 36;
> drivers/staging/rts5208/rtsx.c:67:	sdev->inquiry_len = 36;
> drivers/usb/image/microtek.c:323:	s->inquiry_len = 0x24;
> drivers/usb/storage/scsiglue.c:77:	sdev->inquiry_len = 36;
>
> Does any of these LLDs support SPC-4 devices? Can this change
> e.g. break support for certain USB sticks?

The intent is to enable more modern protocol features on devices
attached using USB. I was concerned about blindly increasingly the
inquiry length and risk breaking older devices that we know are likely
to have problems in this department. At the same time the conservative
clamp on the inquiry length prevents several useful features from being
enabled on modern devices.

There is a risk associated with any change. This patch tries to strike a
reasonable balance between avoiding regressions and accommodating modern
USB SSDs.

-- 
Martin K. Petersen	Oracle Linux Engineering
