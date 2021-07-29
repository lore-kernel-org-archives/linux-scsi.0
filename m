Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D85C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75A336103A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhG2Dh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:37:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54522 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233684AbhG2Dh2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:37:28 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3aHVw005074;
        Thu, 29 Jul 2021 03:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dlZCEGEhHesh3Ac5Z4pe98cGDo8smpgyTj2S0GRX1U8=;
 b=NFZKxASoTcy4Rw7BJdCTxZLaUoSbfBQRqPoSAzuEHQWVDKItv/8jzFhahJvbTXeeNMoC
 6HByMwWheILRZL9QkT/b+0RwFZDixyyLvAMLiwn9ZP1GObQiGwIrVQKR+fjbBDKW6PkI
 h3ouWAwBglKvBKXteCE7Lq2G7FHYwTONRxdGPpzgqYm4aSituXvpV+QGUSSfWYa1b2Mx
 UAxatH8g3TkJ+hU3H96ZuI2RbUmmTHvTzGb1FBM0yIB/awggaHcVRnUsQpR5PmGLDpsf
 x2koI3rtBydazwmzps/i52RwzL3livvL3hVWsGQYSh1opGy0pP5trXuD1KfkNTTShhbz ZQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dlZCEGEhHesh3Ac5Z4pe98cGDo8smpgyTj2S0GRX1U8=;
 b=SRCHS3ZK3s4L95prb4k6SUFGkLfAB0NruoL2cBTEud9VW09/FyV5fE2A5EIZ07JdwcRQ
 ULuI62pNxx581Qnk1YEaTRqmi7ZwdCZMsm3cOv2m//Ay505ifGvrPLVTZyATjUSnWef5
 gTrOZ2jCu9pMr7+ffhR1IX1R9Gkl88Qv36seTTYHQ54FzhBJgwArJtVYLDlCrHStjSq/
 W4Gwwt6hmXSuD5pCKU2cNmQEJzaipWX2GK7/CcsT+R5Kyss+JHzI6/DhoUkZ4RuoTuNb
 +m6SHtC/z3vjng5FZP432vnvfWFcguZ3gkiaxyqTJO8eeBrlZOd04LAXZZa6dm/SccjR Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2358e1yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3V1mQ035570;
        Thu, 29 Jul 2021 03:37:22 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by userp3030.oracle.com with ESMTP id 3a2356hn1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHB8i7gjAWpR0jqAkHet8HEqC4399LuZAKqGODfA0DGBrtgorNy5sVN2aLlQNgAgzEFCx3fItSzfM9MFHXBEKeCt9s88HV6SNBkEhDtyIcO2rGhCT20lKGNjDlfH+qp/0WbA7hroNsrhmJ5wZ282xQIceFysqEOiUIptQWaG9He5z/0x/Wci5CEppytoz5J0XHZXjs+PFfbreS328CW0MsMXnm82SoFq/Eee1aAZGco4RnXHsF8ZbmIv96T8zeV3tdvaQ3NklfG+rpdegpPJeCVVDmWbFtXxlO+fl/S8nqpwtjlq13vbV6oBRhus6nZ96R4TlFkeHxjjHX0b3hZWBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlZCEGEhHesh3Ac5Z4pe98cGDo8smpgyTj2S0GRX1U8=;
 b=IIUSlLwvto3WIo20ig7kIq7vMa7L3ATUn22zs7EozfKbpXZp9YlYvlS55GK8pAjh+uWhnvORVqhidWToDEfy15rgV6Jo4BGHip2f3G35PA6JYmKykd1WB2PqUuwoR1MyYwkdJdK3H84m7y/TRJcNxKvbsSqej4DED6Nm7uD/30ysd1QOJ3PQa7U6DXWqVGxkXsotACze3b2STDGNvfi/iZws4UktRrgazw+d8wyq1ftEZWks1QH4O63mCJD71zcx23XLvPtCwxODaV/PydEnrlePEkaHV8i8QQvxYmgLgCL4jobfPy5OzooNswDYI+mDO6MRew4BnEXApY7dpZtwCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlZCEGEhHesh3Ac5Z4pe98cGDo8smpgyTj2S0GRX1U8=;
 b=RCtvanwudQStD5E7rjrQjztJKAzUNxj0/JoVZTn/+afJZYtzGT5Mtbf0TO694r1LsmzL8OJGq+xwkpVJxt9gWSe6xHpbUy3aYBbWGsKkTmkrWkfOCY7Ia9XHT0idjOVKo2T8q/vaBm9vsdrPjqRek9yp+1/Z/QZdeIAQe0x/XVw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:20 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        thenzl@redhat.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH] scsi: Don't print target alloc failed print for ENXIO
Date:   Wed, 28 Jul 2021 23:37:06 -0400
Message-Id: <162752979291.3014.5816178429832700494.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726115402.1936-1-sreekanth.reddy@broadcom.com>
References: <20210726115402.1936-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01e137dd-63db-44af-15f8-08d952422b5c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15491542EB08D89BC632446A8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /K59nQrNOxfX0he0W5qrHbTdmqEovmh8pUMZIs+ddsdqr0+xULq6X5o2hja8bvT9J/lnZjq5jwUXfgawZoOS764fqVLQDicF23hpD14Qt8eoAZN38PafccTZ/J+xAo2IFnFbakoVbvKGaHhcRFhSqkAfmUSekfq4NDmkc1NMcDq5kswYtLCZyYfKW0J6dvJoe7LuPm2lrWp3bltuvEz6Vt+z2iax2DziVvpNmGTHwtbTs0p35BGFRjN8J3ImhqBNHsVvsxpurvcGCTPxa+4MMPuNE6ii7qWExVwOyf7jvNwOiZKlBri0aRfirj0is9gqg8mnpE/o5ORh3SjoDJQ8SKy1aWq42bzAApdS/swRpC895g8xAglJOwzuWFzjCobUvkZAC9fUp4McftnvU08N00P2H95/QeqOuxT8kpvQ2aQPxtIZvAMbX/I9wmtBHpHB4AAusIoy/pqT9dC1WuNkWkD63vXA07NXSzmRtHT0NpJfcoS5zcaLigw3vn60zvVNtTNqLfPCLgTtc7mBjYdcWn2rlPCODZErxGWXIHYBnUtyNNqET9kcS1sW+Ldf6MSEIEfPhd3UY7W3XV0zXGqenmgVoNEoyS2fIHc7Rnn8ogbTYEOdDQWMHxO9iLHmwAflPDb6RYBPpm9hYme9aeKE37uirm/vM8I4Ou9DF44rYe6Jrb0uAa6otXZfjCoPFCqRplqXWsaCtF2duRmadhK0kJF5kLIgKXdkIlcnuY3FAsxtR4KyFoCSnAM/hGkv6ncCfgpMDogl4ntewmaCelHyCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(6916009)(83380400001)(2616005)(956004)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzNRVU9iMkoyQVc2RDRXZWxhM1JtV0pBL01jRE5KSDh5ejc3YkJMZExaS2Jy?=
 =?utf-8?B?K0JmWm03bitHUUkwOHpLVC9wQ3laR1hoR0NBTHhRb2lDZm1JbTV2Z093VE5V?=
 =?utf-8?B?N2o2U2t6MTlYM1VYdEM0bnlTOXBmR0M5UG5pWml2NVBHMmkwT3YyYUxxMmI5?=
 =?utf-8?B?djRuTVNKZ05aYWp4OFh1Vzc3ZlRIUjhVQzFpRk4vOFd1ZHJEZ1puSUVzMzJP?=
 =?utf-8?B?NHhPYWpVWDFkWXJKUUJpSmdUUGVlSFJzQTRHRnJDOFE4cDFBZEFrRG4yQkZI?=
 =?utf-8?B?SENpTFhvZ0pYWDFFc1V6MVE0Q1BXdmpHMFh1Y0wwYm5vR0hzQktoUFFUOVJE?=
 =?utf-8?B?cXpRcURyTTJ5OUFaYzcrOEhzSFVrWlpBY3hLUUMzZUhLclJyRm5yczA3N2R4?=
 =?utf-8?B?eXZWalpTbGNrUDhjVUVjSkt5QWZMc1QvK0FDbmZpeUpUR1JzbzAvbEtIMERL?=
 =?utf-8?B?ck5ISDJzM25KSDl4Y2p1SFJBZ3cvWEJhS1Y1WGhQYldFbHV1VGdCdHZacUh3?=
 =?utf-8?B?dkFnZ1FhbTRGU0Q1VXhmSVlGaC9XMHhmaEtRTXAyMWdwNXoxMjVhZXFCakNw?=
 =?utf-8?B?S1Z2M2lPQVI3TFNNeXlzMmU4ZzRFcEVEWFNXbUdPdDF3ZURFZUlsL1dibDN2?=
 =?utf-8?B?RkQ0N29OanN5WjNZSlFNY2xoemVHdFFEbURuZjkyc3h5VmlzN0sxTTFPQmxU?=
 =?utf-8?B?d2kxK2R2U28wWDJDNWdDbVQ3U0tnZVFtOWY3S3VRM3NBc1NPNTMwOEw2Sm5i?=
 =?utf-8?B?OGYyOS85RlM5WkpwMElWcDlyenVPaWowbXUzaHF4cUhZOHhVRGJPaG5FK0Iy?=
 =?utf-8?B?NDJPNm9BVTlsU29WMHBvWDdHb3JxdmYxeUl5RGNtM0NIVGVBcCtPKzZXdER6?=
 =?utf-8?B?ZlpTWjkzdWFPZUdNY3Y2OUZNLzNFdnlZaEh1Q3l2YnAvbDRkSDBuWTJsM0gv?=
 =?utf-8?B?VGhPb2ZNelVXelMzWmxYMDAvL2xJVTIyaVQ0eXU1QjZWOUp0Q2ZnWGVyTG1P?=
 =?utf-8?B?SFMrcFY4WkRJN0dkc05Ha1pOOHdvUWI1MkdOWVAyKzRlTXhSYkoycjFFVjZ2?=
 =?utf-8?B?QmtPUmFiVUZNNGFQbEMzZW90ZW1qazIrNW8xemFFNXR0NU1ldnczMDdnMHcr?=
 =?utf-8?B?ejBtN0RkQVZ0K3pnNmxpcXhuVExVdjliNGN2aXg5a0YzZWZkMHlQSWJlRDNH?=
 =?utf-8?B?clpqK3kwbU8vM2wzdUR5cmltTU05bnd2anVQMk50OFNCZXN6YUJkeFhDR25r?=
 =?utf-8?B?eStadWxlTFQrdjc4bW4yRDFXZURGVXJRWU9NTjZmeHVWQTBqUmVMcXRXTzJu?=
 =?utf-8?B?cjlZWWQ1bkN0SHNXNGxhakczUWptekZadVc3NStwc3BLWm9TV0RwcnB6TXFk?=
 =?utf-8?B?RUVNTlJUdlRoeDJIWjNhU29UbzZmVldSYjFNVEFOdHNlbHNOSGZMQVFJRkhj?=
 =?utf-8?B?ZSt1LzIzN2o1NHJXR3VvK2h3QThLaTR1NTNaR3dIYmQwMHhmcFcwWlR4dWJz?=
 =?utf-8?B?ekpqT3VIK2FoSktLNlJTc2tIRFhYMStHSm5ibmNqVStXZzY1eFVTMm9MZDJ6?=
 =?utf-8?B?Nmx3a3BpNm8wcEJYTWRidzVnc1dROHA4NzVkcHUxMWxLTkxxQm5TN0g2ZnRu?=
 =?utf-8?B?dWJHRTNzQXVEREtJNWpvVGpwRGNjNllxaWhqek9vRnBIa0xOV21pZFlTblpL?=
 =?utf-8?B?RGY4OVhzUXBzNFUwTlJselcwTzRTR2lMM2J5cUF1K2l6aHlBTTQ4V2llYjBm?=
 =?utf-8?Q?yOkxkUM2qGnJbzBo56fMYfCps4EXBnT/BAykqMO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e137dd-63db-44af-15f8-08d952422b5c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:20.0530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LpkqWiM06lDWymupCwqh1nAyWYD2bfNWMsND6xw7DFvNBHr/cpzx2GsPdhVNPTbH6WxqJMTcAuWgYaobTGAiiCTO+ozp/T1xFGXZbZilXOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: 6dC_FtTjj5Ll9J53uhhbHrWSxvzIZQ8C
X-Proofpoint-ORIG-GUID: 6dC_FtTjj5Ll9J53uhhbHrWSxvzIZQ8C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 26 Jul 2021 17:24:02 +0530, Sreekanth Reddy wrote:

> Don't print 'target allocation failed' message if the driver
> returns -ENXIO error value for target_alloc callback function.
> Driver returns -ENXIO value if corresponding H:C:T:L entry
> is empty.
> 
> Removing this print reduces the scan time if the user issues
> SCAN_WILD_CARD scan operation through sysfs parameter on a host
> with a lot of empty H:C:T:L entries.

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: Don't print target alloc failed print for ENXIO
      https://git.kernel.org/mkp/scsi/c/85601d88eccc

-- 
Martin K. Petersen	Oracle Linux Engineering
