Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75056C77B75
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 15:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjEEPoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 11:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjEEPoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 11:44:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23F514939
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 08:44:29 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 345EXsIX012500;
        Fri, 5 May 2023 15:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=E0iwGGvbcx/g6pk/WpRC3Htc40gj/1cjfY5rH0Q19CM=;
 b=Zb1oP8DdHoyAy3LuzbTmYz7j/boCmOhNY81bSm5MATu5wOYrAfTpwOtaVyzWqJbuWmwS
 ryQ9bGIQKZ8T/GyBzU6RntnYNCHt/oXpGfCjm9ObfEqKfjxmz4bPTt90kid3C/eng4nu
 z2QZGqHK/7Cow4o2mbUrrkluqozp2m2HYo81Am4+dcAL24FwI/JzijNalfuUiC5etIJ+
 cuAi+A14O81Krlr1YNx5xzLPzrxa5YD/gEu39AzXKZHj27nNgUE9lEg1+FnYA6pwwduf
 uAo5yZ0qKgT7jj7Nj9ikOdYNy0FkvXcHNw8t/XZKjpzrB/QGom0+d7dmE7niWNfd+kM6 Qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u9d5d77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 May 2023 15:44:22 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 345EYhiK020956;
        Fri, 5 May 2023 15:44:21 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spa1dsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 May 2023 15:44:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiAN/UXSRpe0OauhVKLQCHX5KjJWjrcyYhTacd9MBoi5JQJXHVhLp+iHgqUcXnz7dHfNvfsdrcc2YwgUJK9vi7HtZ57NpvWggCHGazNnGNcxSHwBz104xPQt6oM6hz0lTUrH9pcBDK/z8WIG6QiqbngQkmXPIJewpWSKVCPwIeAhP+YsvlP8mGmfDLciASKqRCDIDzJEEikF1s5TxP9MWLqsIp7oSVrZkPfZMO7mFJZqlxbsmgIRM/HmMVkn65/LPd+HMdrx8W5bO663lcH78tuIpxdJlj52KHLO83QubtVTDe8Gt3yrb4AbyHkWERBYWirTQcS5y2BdAdGBITA/vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0iwGGvbcx/g6pk/WpRC3Htc40gj/1cjfY5rH0Q19CM=;
 b=eMKVAhWsoSQdCCD3uKDhcHe5nvk6RwI4o8h4lpBI+GQG87O5sDfVRQUWbPLRXP2y+CJWCPQhIzXf5eZNSVEczXjv9njjbucHuEwIpWAPRVy2lz2tXQQGmG9fZ9I5hX6eeMjWFK2EgfPeAYL1L9QbagRBEVfpEqMWZWc30uONtgN/XR6gZPzUIqXWdLq8gckGdvyjQZ0+6WZvDpjuEYUUHZGuq+NfQ1mto7BfboKmRWzG2cIZyEPJm1n+BfN5b8fSDh83hiPAFk+BV7pwKEJPG8Vz/uKgj+vtk6RV/BiW7iOR1ri5lxmEpRI+cvIjEaS8+KVycts/PiI9AlWkpJF+NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0iwGGvbcx/g6pk/WpRC3Htc40gj/1cjfY5rH0Q19CM=;
 b=TJ7OHs9Xh8ho7ydWaYcIRWtG2z8sroifI+S8r3iobxVuIiRVavLbGWGpc+ALPf+SyeIoYipl4rl2qAOpvptuB7c2Q+Db4UoEwxxCxeTRV0kZZ14Oc8R/2EaFJrS7ytqZ1vf9pmu/jP+74ZQ2ywPZeBYKL9qLd3e/JE0fIQdybG0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6945.namprd10.prod.outlook.com (2603:10b6:8:143::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.27; Fri, 5 May 2023 15:44:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 15:44:18 +0000
Message-ID: <289f3cb8-f0b8-5f6b-ae0e-aa5d9f7387f1@oracle.com>
Date:   Fri, 5 May 2023 10:44:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 2/5] scsi: core: Support setting BLK_MQ_F_BLOCKING
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230504235052.4423-1-bvanassche@acm.org>
 <20230504235052.4423-3-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230504235052.4423-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0059.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6945:EE_
X-MS-Office365-Filtering-Correlation-Id: ac55912b-0061-438e-ed67-08db4d7f96ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kg0afRIgtbkK4PxGRiOw7jddOkPVXEAChZFkq4SoTme/9mBxirq4fTtSDsYxTRXHsSpnBGx5GAAvN4YGS/DfZOi4oPNlfihU9C7Hluem4m6eAkd56HrJeQr3hs7XkQVbTOw+iaA1q+5jXAW3ZrBxO+kbwltvUt4c6riArwnh8sssktZMV4prm92Hu4dUESK95+jYWFZp8Mv6M1UwMH6GFgSxDuLerIvJ4bBTBfX1n3hEn06ilqGQqV4JsuD9Epeu0dXuUF0idIlakGfAQIPlia82rvZ2eSkN2EhpChsSsfNRTJB4Cdr/JjRbG1iCUAfEv76/CaOvDbRY6ZXCgBeg5Kih3UqcvHIrAlzRpLdjQTyTz22zqQyGBecc+rBS3EhzVgs0oOkIQM4xHF4D5p40LwQFaHdtWqzBDSy4+x5Pb8vBY9vrQWLVTSS/vTckUJNH4zH4VLVJ0JxmWsMmtudha39TvfIGLWiAysJKIh3CkpFCKZCGGBJmLO6VtYyB2I5fKix3yKO5qjKt4q1iGe+bUwgpmSGonFTG7T5s5LZGPaaThEdF9fjOQIfgiMmhVoNCdQVMNdbfWr8T1kqaAJKESi/sTpRYuZOHgT+WpmYDU2iFtcWbW1zzTfTtiCKPao7jGKJEk4TOy7CNDwRb58K8qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(31686004)(66946007)(66556008)(66476007)(6636002)(4326008)(966005)(6486002)(478600001)(316002)(110136005)(54906003)(86362001)(31696002)(36756003)(83380400001)(2616005)(53546011)(26005)(8936002)(6512007)(6506007)(8676002)(5660300002)(2906002)(41300700001)(38100700002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjFvTjk0MStzMnkvZFRMaWVHcEFGcElzLzJLamM1VHdic2Rvb0FxL2E5SWpM?=
 =?utf-8?B?eW5ITW1EZTB4V0k1UWw3ZVhFc0lEUUIvR3JCdXpYMEtGSncwVVhKV0RrSVVr?=
 =?utf-8?B?STN5cWs4NFNQV0hyNUlLYWs3ZjdvR3I0MlJrTnJCSkdJWVhDVG91OE5TVlB1?=
 =?utf-8?B?WmNmSWFMc3hYd0pETGRqVExHTzhaenkxM3BvVUZiQUlwTHdEWk5yYlNJRm5R?=
 =?utf-8?B?RnpUcWJzckhzNU42eU5kQU1hWHhBV2J5U2RiakVjcU5ya29OcWFQZ3FuTFYy?=
 =?utf-8?B?ZTNudlBFVzJpeTV4a0ovRjkrbnVUTzE1VHM2QTZVRjczaFk0Vk84K3BWcThI?=
 =?utf-8?B?R202bnlNb2Jqc1ZYME9sWlVJbi9RQWFYRWxvZVFSd3daYXlTMUhXelRhR2lW?=
 =?utf-8?B?WHhvMm9kRlRuSFg4d3BCUFBscDNJY29QZlZBZml0dDN1WVdwT3pWcTY5QnA0?=
 =?utf-8?B?OHpMSmtseW8vR3dCMy9BMExTVE0rOHhMZm1Ca2YwSTN6UXVWODZiNEdmVWdx?=
 =?utf-8?B?d2txejhBazJUeWNoZ1hxWS9HOFA5SGNkby9NdVNTWUg4ZVl5Njh2QTQ2VXRG?=
 =?utf-8?B?NHNDOURCSzhRNTZGSmY1amI3aFFWaGxmeTN6QzAzRSs4bWs1ZGNHN2VXeWt4?=
 =?utf-8?B?SFp1TVFwbDZrZWVkQzY4MFpmNzMzNFBJMUJ5dGF5Nzh2RkRETC9ZYXBMbzgr?=
 =?utf-8?B?elROdmJFQlo5QU01LzQ1VVErby8xaEptdld6clBYM0srVUF3V3k5WXVQeTN3?=
 =?utf-8?B?aERNaURDb2ZJWU9nWkdpa21MbE1DSFA0NFNuV3hWVjZVNEx4YTFRVVpKdHBE?=
 =?utf-8?B?ekI4NXY3MmZmWVNJZVJ5U3lZMk9OUnJrdjdQeE1NWStsZWk2bDBUMW13aUhY?=
 =?utf-8?B?am5wS2d2eXdrM0JCMjY0WXNZbFE4dUlML3BHMVdTcUcva25QSHBCajg5a3hX?=
 =?utf-8?B?TFBlK3FXMDZIYnlUUTlqWnJIakozdUZKMmtQNHBQOXdmODcvNGxzV3FkV09s?=
 =?utf-8?B?d24xeWRMWnBzdkR5OHRxaVJqd1g4eG15NkZCTG05c2thNFF2Y2MzV3pmdlpH?=
 =?utf-8?B?L2ZTS0k5ZWtnN2piaFBkY0g2SnZ6ei84TEMxSEFUY0wzSHFpdWc1NTdjVFBH?=
 =?utf-8?B?V3V1b0dibGdtQURHQ2pSUUxVQWhxTm9rcjBXOGtlbnVLNjZFdUpqN2FxN2ZJ?=
 =?utf-8?B?NUlxU0hDUXlqbnhVWmVBY29yUlFPQWVXU1dHSno3NXNGRVIwRVdXc0RZN1NM?=
 =?utf-8?B?NkJHZEg4c28xN0o3SDlWbFdRSzVmUWJERlNZaXBKQlBpRUt2RVpqSnNlYWR5?=
 =?utf-8?B?WFF0VEpzOWs3S0lsK3p4dHE3T2ZVV3RZeUhpSEY1eEYrU1MzVmVHdmR3ZWpn?=
 =?utf-8?B?bmlhNjE5bHZXVG4wU0VLbkEvR29nbGZqbHZNWFgzdVlLajVxUzBGeDJpeUpF?=
 =?utf-8?B?Q0x1bFBEMTFRTVFrL243c0g0YWZPNHJWWjAwN09xcXhEWm53SytNNzJSQXJX?=
 =?utf-8?B?QWMrdXNhSGhuaUpyYU1RRkh1ejJIbTg4dVlHdkVsV1AwYm5MMUo2cnRjVURO?=
 =?utf-8?B?Q1lwM0xhd3hxeUh5NzF5YzErcHl0R29zempSU2Zra1pnSGhueVA5bDFlZDVG?=
 =?utf-8?B?bzI1T21TVjRTUVBLYktFNUFjNVdreUQxR3NFd1Y4SjAxNHlkVWdwUW9tRFJO?=
 =?utf-8?B?Vk9RclRQeldTNWplMkVRVmUvMEtRZXg4Z2YrZVpTL1dnWkNENnJ4SjBGU1Vp?=
 =?utf-8?B?ekZBMnhzZTRIR3c0N2drVnBRMFJqU002eVVPMXFxdEtSSjFhYndSY2ZxY21Q?=
 =?utf-8?B?MzVJREViRUc3UE1NOHpoMTY2NEQxc3pnSmM1WVFWMHRtK1JEbUJoajZEMEI1?=
 =?utf-8?B?NkdBbzVBNnJYbDcrUTRyVDhrdGpLQnNRUDZXWjBNN0tSZ2hMMmYwREF4c0l2?=
 =?utf-8?B?VUdCZHI1d1RJcFhRMWxscWljaGU0OWFUSEZpdUlzKzJ0S3hQRFp5K21jSDlQ?=
 =?utf-8?B?QXlQMFNWeGhrenZQQ1V6TU1Uemg2Qk9kVTBadnlONUhZaWh1RzJkalNtWkFk?=
 =?utf-8?B?ZW1xSDN1VnNzNDhqS21xR2ZOMDhvNUdjWmtSZHdtZ3dUR1lVUkNZV0ZQY2xs?=
 =?utf-8?B?ZGxjRVd3ZjJEbThIaFU0TTJxOHJzTlpCYlQyem1DRVVqdC9QNjNLSkg2RXFE?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ps0QIdM8pPtY1R/9nWvyjer5XUfJU59XrCud/oCQuNfGyqanDQrSxh5E/0SwAvJy7jDhnYRr5poCXKn96/p1eSFGIE/qWiIU7VpDUrP7UoCmhVaQfDMwvgtj9dTvTAxjihgkFnNeo0ipnDFrIaUENfaNwQx12Z5KRIlJzOn1z1JRMR75vh/s3AldawZ8iknIJGSZO0KiSHjV4aYckA+JHZM2OUnsjCnHKrdMW9HHyoO1soOddVjTAxyJitikEIoGJkXvlrMmeMAvS51AvSdwWqn8uuEW8C+B3oFiBkQ9W7YRwRI5FE/ZRFisRI1iObY4SZKckwltDihVep2fxWATyIBYvBiXTMGCxskOaxnQFLWjWmCkP48UuyNQI6zwCiU6tIh3hs4fXJ329FqXa7tIhjKIp8G7ptOszJCv822CjMpNGXfZGQrdj+17l+fmtFQPIJSD3i6aaHo7MLQpqMmYa9G6Cb9TNAvO/YpSaNEyfPrLTvb9fgvER7571ll4QdaatDb4t0FpQTtJQkDKeKfsyzm5WXC8smGdwI6LW8JDLiYQ3FVaKNzeoaUz5DWocWsWFvrMoNHqaNiYucJm7+ntEHxxDfulpZKBJr/5zWFVVFPJ/6iv+wA32NhQSBoHv4tKkZupubZsQQap5u1h8++ZNCYaQa8BZPhgP1Fe2tGtnpGfO2Yy/M8iLoWi8iaJGNfaWQgbP9HrpuIOrDpq3MNAH4/6hNtsh2Mb7nTUfZC7TC1bdSqjEl4xDXgOEKPY4btDGx2jdBLYsiovGruEmAJeiC2Dz/igOLtLAs4G6RsvFheFwzVxLuhyI/iZK9BhgPihqEn3Aa4KwWJHbGt/b0wC9ApNlTTZd2MMulkFDaxUFOU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac55912b-0061-438e-ed67-08db4d7f96ae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 15:44:18.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IaMyCNK0dX5mVJJdaO+dNZgiY/rIPPlI6+PRj4RSHObZxTssdIBY4s9kl0Y7J1XlwqfhP2N+RR19NlqcV2Ekz3L4akl54Z+LVdj8WQmlppI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_22,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305050131
X-Proofpoint-GUID: rma5UT95yXEmJwk53Y3IuED0PZYPx_fS
X-Proofpoint-ORIG-GUID: rma5UT95yXEmJwk53Y3IuED0PZYPx_fS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/23 6:50 PM, Bart Van Assche wrote:
> Prepare for adding code in ufshcd_queuecommand() that may sleep. This
> patch is similar to a patch posted last year by Mike Christie. See also
> https://lore.kernel.org/all/20220308003957.123312-2-michael.christie@oracle.com/
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c  | 10 +++-------
>  include/scsi/scsi_host.h |  3 +++
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 758a57616dd3..894af68babc2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1982,6 +1982,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>  	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
>  	tag_set->flags |=
>  		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
> +	if (shost->hostt->queuecommand_may_block)
> +		tag_set->flags |= BLK_MQ_F_BLOCKING;
>  	tag_set->driver_data = shost;
>  	if (shost->host_tagset)
>  		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
> @@ -2968,13 +2970,7 @@ scsi_host_block(struct Scsi_Host *shost)
>  		}
>  	}
>  
> -	/*
> -	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
> -	 * calling synchronize_rcu() once is enough.
> -	 */
> -	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
> -
> -	synchronize_rcu();
> +	blk_mq_wait_quiesce_done(&shost->tag_set);

Reviewed-by: Mike Christie <michael.christie@oracle.com>
>  
>  	return 0;
>  }
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 0f29799efa02..37a8a2608dc2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -458,6 +458,9 @@ struct scsi_host_template {
>  	/* True if the host uses host-wide tagspace */
>  	unsigned host_tagset:1;
>  
> +	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
> +	unsigned queuecommand_may_block:1;
> +
>  	/*
>  	 * Countdown for host blocking with no commands outstanding.
>  	 */

