Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD51C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 049DC60F44
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhH1Cdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25668 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233309AbhH1Cdp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:45 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17S1VpXY013818;
        Sat, 28 Aug 2021 02:32:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tDZpd+6kQzA5P0L89F7wzcOhCfyDSXtH/MU8JxdDOIE=;
 b=AekxQebxvIhOaOnyXzogRZS2/VBbaDM1CDu7lR2sQLKPtGsTJ93EfPbm1dAqip6G31sF
 xWwChU1hdL/L4fVonFHFkjM6nlju/KyKSd/HuJ2lIAcVWghoERhlaUzvafrLow/qQ5+k
 bgOQVmJQmlBODFzatapiTOJqO1bzAXOZqsPAZRgVQkRaKQNlV0yJBLw49Mro2c1AC2xI
 EyeImdvyRVhi/UezSPasq/LjSaQxsBcSpUwzSXx3VQkqfjU0TyeDAKuItRLyVrxS4zRw
 lxrXkO9ry3wyQGX6yOsF011+J27reM3fZEadIaWTQa08wgNT1HjVy1dHxdQMSB4/B7j2 mA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tDZpd+6kQzA5P0L89F7wzcOhCfyDSXtH/MU8JxdDOIE=;
 b=Bkt1om89kx4n4G8Xpepoql2ZQsfQpsP/WCF429xtB5vfVukmZxIWpXgEFgwqJst2S2oj
 vBE8Imysof3RDQ2I4SdEr5c1HG2CDcf49MeMl8YLEexIHFsBNf1mMxHL9sce/3/jaffo
 W89dp3F64rA3Ov9ILv9kubwuJNi2HvjyOkM2WgzXymHUhOPe85Swf5EuMa81R40m8plE
 3i33NaMZSMPQxkJa4JEJo4mz7fAUxCRvrZL5tr0obtfEQh8wB5aD5uJteMBHLWIzJgGX
 o6VrxxdDyfouXEJoGujVaxNBRzCJG/EeZG0jUTffWqyEe3sY4LJklQn1FWRjBOEBRaWm 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aqbjbr146-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2I0V4170058;
        Sat, 28 Aug 2021 02:32:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3aqa8tnj9m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jU38FUdkp4IOgg84B7hHoDT7AtpzlNx3ZvuyKXdGP7HdoL9097wZkn8Av2OkUcbAEtqkLXLWOFXVMXcxHZJ/tB5hIzvepUnBOxIpN1HJz4ebuPm/ZXVHMptjFGR+lkba44XXYNNudOBrpRq04EU3Rn5QlibSb9zLcJxHcW0kXKea/MLsjhUaLyjsIM9+SUbCB8e/VERgnjVCM6O/xpCfUEI5P7v3uJyEiM1GHcqpG+UpR07gs3M3XytAwAVC0HqpS/tzEMJBz3G+wj3xc3a37BKqyRxTDRMqyeHrnPXIzaZt1+ZID8L1f6mo/O8xPT+xOxd8iK01QP8tcvA6DIhPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDZpd+6kQzA5P0L89F7wzcOhCfyDSXtH/MU8JxdDOIE=;
 b=KDhmmL90aR/hSBvt2haGLvdry6Ab29+VZVbAC7iabfmh6uzJwb0NM3+UNqvgHIqqq0kte6dLj8mia1FQwtFPohtoM07wQ9U8YGfVddBwR2ZXQwJMMPaYdOSY54yY5EjXTM/Bh0tq1opFBMFiVD1oa/9gcymwgp32a4fVu0A9+Y88dRrLpgsfB0sCer9WY73F/ACmu1cXBuc+iRZjsrz9RzWITKhkp21Hu6cSeEkorpN08xh7GnwLABP5Dag0wAhY9KFR9+WIuC9p2wzjUeRz4bmr+YKpYUtDF5R5NBQS2ULoeiM8P+p8BUcRbwzuVOiDuNDWuc7ycwjBWW9T0JglRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDZpd+6kQzA5P0L89F7wzcOhCfyDSXtH/MU8JxdDOIE=;
 b=weTNASpmyG95ZAL0m7+J91GBt4Ww43m3iFpxHLcA7DuJ5vDToBGyL4hplLJyDWJrIoN+cW9lc4Wq4CuBX9HYxM56yUcQhPKJlxRosDs4jecAdg4hghk62LC3VpZ66xdqcHdk8ZMZPq3E0L91od+tWapOlZsQ4yt0pEmNQL+Hf8A=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        oliver.sang@intel.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: scsi_ioctl: fix error code propagation in SG_IO
Date:   Fri, 27 Aug 2021 22:32:10 -0400
Message-Id: <163011776502.12104.5160450335159885107.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210823133458.3536824-1-pasic@linux.ibm.com>
References: <20210823133458.3536824-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4151920-457b-4855-9147-08d969cc167b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55159AA220E3F7CC7D7037088EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: daMId8EHMhuWvQ2qDa9HsrGFmoOyvzdaivm6ECgFwHX9E4thsG6CPLqst0UVgyUeOlkjZVmTQEuGK0D0FrS0rLZOHwDxWJ+KPnSb5LuESOJlkEV03omfZgAbE9UcxzFOjS6p8sIGutZUbbRyUQ1CjN0slJNgWNS8IDL/N6oju4PuGYAjRVIBca0X4sKDbqyhFqaQSBLpneYRFXB8aiMSb0VPCAeN5Wd/aijL2QYHADYnXOtUt1EdyPzVXgcBpq3fersdrBDhVFczXiHWiaDpUYx6rHhhQrkejqW7GgpCEUuRa+aRgkGXYEdmLqTM9EwY5ioSwOvGiSTv94oKoxMUc/03gPdBPnNJ77H3H3sKX1Ic+TdVrVKGleTzNsyQtbUFg+P0K/IbZRkX/S4lxSdS7kaWIWex4sobrSCAJuIVtioXM4h/6+vHtIFKYTrgysDgEafaCT0ST9duFCmKhbYDQtKGDUhVrsFh9TisuweCLAGQ8egzSuy+114g8Y17TNIGY+iE5mgmeIpeUmh1jCC5TmM80MIs9JxjsnixoQtfm2jPfoXQx9+baM2fD2xFfGLOEVQHWfhl0ILxV9QXxQQ4mE+N1D1hVgJIEfkgtDZzOyYsimLNE63qZ/w5p6qAN7+O/M1Jrt8a0rAzf2nPnR9hClrfjoX6IxOHkahr1WQx2vUl1NetfzPM3crp2ECt7Hl3LGi57A0Z/hbnK3XDc3wJ5N3qj0vCbl8v2bCIvrULCcmTfUWbfsyC+BKMhRMpZ1KFEmutLXScMm2HBBvUjtPl/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(558084003)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(54906003)(110136005)(7696005)(316002)(7416002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(103116003)(66476007)(66946007)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUVKdWdZaHVzNHlkbFdvU0RaLy8wR2gySms4S0l1aVd1N0VKUkIzV2FQR3hO?=
 =?utf-8?B?VTI2bVluWXhJMlc4ZDhKUy9xQk9sNGRBdnY3aXFXazRwWVBVUmRaVE5SckZa?=
 =?utf-8?B?ZkxUY2VnWjFVL1ZOakZiYVdCOEdlZGhkNVFLNXc1QjFoNTQweVFRSkNsUnVr?=
 =?utf-8?B?dFZmenRqTnNQaU50NTFPM0ZLNnlqWHBpa1JmZDNWdUtNcDUrOXd0Y0cvNjYx?=
 =?utf-8?B?WGR6SlNvQnRBempOVE1XdjFDejV5YzE4b0wzUWx4dU16VlhBSTVmSzhVYWg3?=
 =?utf-8?B?RGdrb09QT084dkhHSzNqZDV1NHNaWk1NTzB6dVpJaEhWTmRMY3NEZXNpbUw3?=
 =?utf-8?B?NXBCU3FzU2V1OGhCOFRsVmEzWlpscEFvamF3RjJzalRvNWFaRzRDRFpTdWRi?=
 =?utf-8?B?VUYvM3pCSXNLaGh3K0UxTE1YRit5eUd4NXFlRjVKZG82cUgrbjJ4SU5yRHds?=
 =?utf-8?B?cDhCaHhOd1NObW9JNlJWRExpaDNFTTBxck01Z21oQ2k3dU5seXZRbXcxTHhG?=
 =?utf-8?B?M0J0S2xORFB5enF3WXA4aUU0TnJVaHhEOEg5ZWlXUmtQQVh3eS9xWkF2dUZi?=
 =?utf-8?B?SGE0Y09iNkZXL0FIdEtTYnpQcFc0eVBlS2V0cUtrZHNObWE5UmRodDlTZEhW?=
 =?utf-8?B?UXg0OVFpM2RFYmoyenh4OTdEMmx5WUI3KzdDdThNTWZLTEg1SzI2OEpHNkZa?=
 =?utf-8?B?YVU3OXZxWmtLZ3NpSnZId2c2OTIwNjc4Mk1adkwwWnZxNHhJZXV0SHFmT0tV?=
 =?utf-8?B?WmZoMElJR2pMZDNnUDRRclg5NEpBU3orOUVqd011Yll0R3BXNTVxTHNDUW5x?=
 =?utf-8?B?Smw0cVhtSjNWSWQrVTBsNy9ZVVdscmhQVitURVBiTFNZdGhkTjFEMzMyK3o0?=
 =?utf-8?B?NFg1SjUwd3BuK3VxWTM3aUVDeEtidHpZc1J0bnBJbVZOUjd6cFdvSmJKb0dW?=
 =?utf-8?B?TGNUQTRwclpCSkFSMnROMUF0UG9KWmJMVXZ0VUlvVlNlUlY0ejkyTkd1UjhU?=
 =?utf-8?B?MTk3c2tVRzJkV1hqQ1BVMW9RdDBhaVozVkRtVmdKa3hTZFBDdkYwWlRMWkNI?=
 =?utf-8?B?Rm9hdzVBaGNoSVBiRGdzZ1ZvNE16ekZlOHBzc3A4YWJLUU0vcGNSS1RFRkZL?=
 =?utf-8?B?QXZuajFsYjgzMGM4V1VwT0owc0c3YXZsRUhTUDhiUDU3MnBLZzFQUlJIUnlH?=
 =?utf-8?B?eTM2MEJZR1dIMTFXclcrbVVRSGVqdzFCN3VwRWZiUXo4RnVJMkVxSDBFM3Nk?=
 =?utf-8?B?Ulg4UGlNTk8xdk11b01KblZIRXJuUVdtWmdBYk4vRGgrVUpDU0o5dzFHWHpN?=
 =?utf-8?B?QUROaDZFdzZMTUNXWnNBL3RFMFNvME54NU1HUkVPTnBKenA0K2JkanMwWjE2?=
 =?utf-8?B?d0RXdU5ZUTVmU3R6Ujk3d05od3NKRWI4Y2RtOS8zZ2NxZFpLVW1tN2NEcXZw?=
 =?utf-8?B?ZjZ2bHdDSHdhQ3o1NGt6Z1BkTkNwaHVKdnlpRy9Na1FzdlZNdnhPWW9BbHZG?=
 =?utf-8?B?aFh6TEJDTzNBNjloYTZhZnQ3WnR4SFFPL1RKMnhVOGo2eEYrZS82dEg5eWZa?=
 =?utf-8?B?TWcwSUdsWWxaWnp3ZzJCWCtVZjU1WDlzWnNYbXB5OTRlc1FLRDB4YjcyU0cx?=
 =?utf-8?B?NFlrc2VsenhHdU1nbWN0SHhuZ2RvYUZ5N2pBWURqMi9tVllmdFRNNThPREUv?=
 =?utf-8?B?VjFkcjFnZ0FmYnBXTWYrUmJ3cTAxUkZDSHAxeU05NTM1U2lWWmpaTnNrbHl2?=
 =?utf-8?Q?wFX0mMK2U/V+CR4gXggln74lzbfj+81B3H+DDoq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4151920-457b-4855-9147-08d969cc167b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:32.3218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kz/+cmX3Avaeri8fIhI4fxYibYhGzxglIMJRcXywktJto6FcHS4M5iPgA0BapdvUUYGYUXL+WIq/qKCopSnVQwKd2c8iyBmfx4F9gPxsmTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-ORIG-GUID: ae5wdyUK14R3tQby9dZHjOa_qieWk5x6
X-Proofpoint-GUID: ae5wdyUK14R3tQby9dZHjOa_qieWk5x6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 Aug 2021 15:34:58 +0200, Halil Pasic wrote:

> 


Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: scsi_ioctl: fix error code propagation in SG_IO
      https://git.kernel.org/mkp/scsi/c/04a71cdc46a9

-- 
Martin K. Petersen	Oracle Linux Engineering
