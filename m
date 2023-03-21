Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92895C7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 17:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjCURZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Mar 2023 13:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCURZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2023 13:25:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7A1199E1;
        Tue, 21 Mar 2023 10:25:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LGnFja007402;
        Tue, 21 Mar 2023 17:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=o27T78HDDY1PxeH4hWlmFBuXmUY1cusi3lQI2fHan6A=;
 b=IeOrxktKW3io0B/iGeG4DhhB1BC70Fmm0Sb5Zb2CtCNMyTnyJqheEstd5MQUir5wU5s2
 6w0tOBDpI5ZO8aTEBjj2/JKa3A0OvbANF0O19gnx2wdzEwkI6DkjWipl8QiI4lCsjuLX
 hRTdSKzsp5cXTSfg3IMN8ZYP9fz4NaQjtEi2xWVP7qOtGfwaPH3FwnqMv18W8AxR2FP2
 iK3Z5FZ9mr9kzteIasxY7eF1knbP11gL47EZZjgWTxOhjw6KlstU0B5xJnwU0jb0NHk8
 N7ZW3EK4Ty7iwgha4fVEs4F1gg7qWNLfTW+H9j/t7baUROXPOK4sLXd4zn26QxGvo+WM WQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3qdpvv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 17:25:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32LGItkP010422;
        Tue, 21 Mar 2023 17:25:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjp4qv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 17:25:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJxc/h6N0m0EVKlyAVjwrvN8tZGBs5xA+4EmldIZHDXsK7b+o9oJ0KdVlOWRu8IrMXCfoQDbxlUDVbv7kEnuYj8r58qvworYTXzvpfj2BsTQ9mZYzWARcJqe1rfm9cRnsGWod/zP7WDuVMPcH/TnFPp11BvTMCu6GTRr9JEuvKTx1OM9DiiDQrcCpkJD0L9vJqtLr0BPPs6QX0HAivN2rVuSlqhijXQj17tx8A44f9hZ4jyxJhum2VVZk5sJaiue9I/BqU1kucsiPOtMJMMTWiK178Tc5XESD+cYHc9Sc2Iw4sBVgq+4N8+hl2VE6ifOryUhtzZsETAVUygu8ioNpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o27T78HDDY1PxeH4hWlmFBuXmUY1cusi3lQI2fHan6A=;
 b=Tg8fmMhlQoZd4mJwCNC1mbimuGNUXEkchiRYNinS0IF5js6Cy5mb0UYoIRICyqoqEqCKT+ufwnKLQVkMKVM0OGZkIj43DXuAQN8jIC2XebsUZ+2O9sRoAUTJk8c0HjeMQMYa4Igp1ZQq/WQIw2El3r3HcnP61DlVsIf2QIcQHP4S0Rysr6hdMtQBgzgBgKRSYFk0kGum6w+s0g0y69lA605VW5Px4EC7L72v7sQ1r5msvohJeYszQFFLvuV08lvkK9A4Mpe8amym4MR1X0MZ/kLE9w/lYzjzLNEX0N2iGJVPO6nlI23dntFIZD5GK0iUlO4B/Qg1qEcDnSENu4Uvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o27T78HDDY1PxeH4hWlmFBuXmUY1cusi3lQI2fHan6A=;
 b=QrAS3b/POpHmoRwv4QWxuWOSVkV4oczOMRgAKNbtWbJxsQeDgj5y1qRN9tQuo4HCyk3E3VRW2qHWfSBArVeEtH937N6/PC8lFW+Qg7qBGV6CEScmYWGXlxr6SDwFiNa1z8FeT1aWk+hg947UVF1mk2tFJ+TKiaCf1DTD9hhAPs8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY8PR10MB6633.namprd10.prod.outlook.com (2603:10b6:930:57::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 17:25:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 17:25:23 +0000
Message-ID: <f3521b9b-00e3-4bf9-4f6c-91f5d9321388@oracle.com>
Date:   Tue, 21 Mar 2023 12:25:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 0/7] vhost-scsi: Fix crashes and management op hangs
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20230321020624.13323-1-michael.christie@oracle.com>
 <e1a96cd4-e520-caf5-7d5f-1de270c4fecb@oracle.com>
 <20230321031147-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230321031147-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:5:54::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY8PR10MB6633:EE_
X-MS-Office365-Filtering-Correlation-Id: 5030e15e-212d-4b39-a673-08db2a314070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y609YIhgk+nQBHLXxDXwliaQOOMQwtQqycKiaVByJJ4Cy/S5CHErMKCvvfgXByeD15XllvcmXgv9RWagUwCCtGo6REj038GYeRU2jNxxG64HTp9hhGCdH385xJGu5x3BS7hPLLNu2u3Smg7qRHzfpmjxD09/7ywEAzRHZL9UKHkF21hfR8Ak4+A3lAPMi6DHfsGbkCYZT51Y8KAqjM9q2mrp64LafVX1chWkYtkxvydM4+4Kskwz0re17g42V0O+rR1ZpfuXamUzLeI6cHKJ4iAHqdTnVYK+2dpb6fWow99yKb4ev3zi9Vvyc0ndo2pX9dhxBcM000giirzhnLVlNYyTAdfScaK4OAzYLsyKM6tOIwEAs4Me9r5JCZ9ML7ouMW9aQCoplSEamJ2afhPIpkxTGjAPuSIo6JzBQGjCri7JFeBAoVQMvtnGlsYtBQJunfgEouIP2F6dI+CS3h+ObnCPxR7w3TaE7bARXsYeMs8RC+aq0XBRUEzBEtD1O21Bo7HRhxtM8hee+254PiMnuGhAeq/RqgjFbO5iB4h58KO8bE+AD00I1lVuUls72z1AABcw1v8rFVod9DWBUEBEwOXB0Ymj9+lauabnrueJvtjppygD7p5MTNL2txuhwqOmJP3SWlxgGJVxZQ07sWpce8J2wCMOy1uYUPWmh2pVv4saeN0D2Y5Af2HkhTjKo5qBl0BHzWzml+Hivu0lWbPm6BFtxsor5LFbn9AkcxRQ8Tg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199018)(38100700002)(31696002)(8676002)(316002)(83380400001)(66946007)(66476007)(5660300002)(36756003)(66556008)(8936002)(41300700001)(4326008)(6916009)(478600001)(2906002)(86362001)(2616005)(31686004)(6512007)(53546011)(26005)(6506007)(186003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0dnZ09kWll5VzNCQVRtS2NXRlFiQ3lYaWFTVUhoYUdkSzdQY2pZUDFIS3Bq?=
 =?utf-8?B?Zll2Wm1mYmlEcnErL3ZzbWM4M3hyK0VQcGZPYlpqS3JDaXVyRFVyWmFrM2pN?=
 =?utf-8?B?RGV3NjZNQ2l2UWQydU5TdXQ3dWZWaFpQMm84aSt3SHhiRFJJQjQwcXlSMmFr?=
 =?utf-8?B?aWhiK3VKcHgvUlQ0aGpGbzgzS2lFN09JaGo5MS9NMW0yUlBUVDJCWExQam9M?=
 =?utf-8?B?OTB0VUFQQTdsRUhpRGZYNkdubStjYVlPYmVwTlhPQzV6TkVTcUJrUTZjY2FM?=
 =?utf-8?B?RkZFMTVxMDA2SGdESTkrVTJRREptSjlZSzF6aGtMWW80MlhEb0ZYK0xZZGtz?=
 =?utf-8?B?aEdndkZxZVVsM3lDb2ltZEJIVWhtYWUwaU5RQjRaak9lQzRuQXNTTHJWUkpV?=
 =?utf-8?B?dXdNN3lQc0hJd01wZVE4TVJvNmkzWVkrd3ZwV2c1cFk4bEJ0d1BTdStveVJF?=
 =?utf-8?B?OUVLQVBKL2lxeXY5RFBQdmg5L3R0YVRNNFByM2xVTEhHakMvTTBKRFp4d1o4?=
 =?utf-8?B?VjYwSXp4K1ZianRzWWxUeGhINWhMbUVDT3lqbFM5OEhUU3ZDRTltN2lVRFk1?=
 =?utf-8?B?a0trbTR0bTZBaHQ0NHFZQkY4WmRHaUpwSWZWQy9VVmRNSE5tNFdKUlNtRDlL?=
 =?utf-8?B?d2hDMmljeE1KaEhMdXpUK0d2U0x5WGF5a0Y0OGFSVzY4d2t4KzJXTjJaVGs0?=
 =?utf-8?B?Q2RPNjlOcHZURGQrRkp6UFZMblZvcytrTk02R2lMQ0VYMXVINjNMQlQzeEw1?=
 =?utf-8?B?NVhxZ3kwVzdpNWs4VTk3TzJqYWpSWm54U3dKb0dTVER4cTN5UEIzY2wrVkUy?=
 =?utf-8?B?VG5jYUNHSURWM21ScEJzdFZCVWxyeW1pblRCK1Y2ZU5OSlMwRk5JSUV3ZGsz?=
 =?utf-8?B?NTJLNHFscUJ3bjkzUEVRWHNTdndPZlZkVSs0dlRzdndDQVVkbEVtWkN6aS81?=
 =?utf-8?B?MlVkNGV5SitwbEc5Sng0SmRZbVYrMnZDRVozSVQwNUc3RzFYNTZoeURMQ0pE?=
 =?utf-8?B?a1NoRjVHUEpvdVNNRWJJOGVqQzFUT2pwMS9DalVjd2FiN1JicUVBV3RNcW9E?=
 =?utf-8?B?YVQ5ZkQ5c0MyVWxMclBkZVUwb01Wd2hiREFZZUpyY21aMStVdmJsc3dRRHE0?=
 =?utf-8?B?RVM5Vjl4cTRqSU00c3JQbVo2QmJjOVU2V3N6blRzLzBXZUhrWGE0dG5EUjE4?=
 =?utf-8?B?WXpIUUdPcWhRcGp3VHA1R1daV1BUMDBxcUo4ZTdxdThiWlZFQ2ZqL1pVemhN?=
 =?utf-8?B?N3FtRFBaQTd2UzdBUjQwT1hHUS80U0IvaWVYeDljL3FVOUhuWmVlSTA1RjNl?=
 =?utf-8?B?SjZWSnhZWjF0U2ZxbUZTa0xtK2tZMFZhbVRYQmpsWVBFWlZEbjUwMktrdEdu?=
 =?utf-8?B?Zk84NjdWSzFrV1RMUVNYT3ZWeFp2a1ZjM0tUdFVCOTYweGFmakpZZER0N2dE?=
 =?utf-8?B?Z2ZOYTYranhvWkY2dWFGWGVDWnM3aSt2QldHNFpOREZsREYzaCtCVHFoV1JN?=
 =?utf-8?B?cFdFRk5lSWhHTk1hcUduM3Nvd2ZJbFgxaEJmNFUwaGMrbS9QY0pjY2RPZTJ1?=
 =?utf-8?B?VjJjNkZFQ1ViNm9lYkQrWnQ4ZEhYTU1TbWhVY3Z1U1Mxb2V6K1dNRWdqNW5H?=
 =?utf-8?B?YWdRODdEUjBjTlBZY3E1UnE3blcwRmZEd1NoQ3dhMzQ2K21udVo4ODJVUkxo?=
 =?utf-8?B?Y2pabEdhK2srZ0RtWEV6V0c2TEw5aWJUY0lZNWUvbDBYVE1XYW9pazI5NzZQ?=
 =?utf-8?B?VGlRMGp3Vkp5OXFVZm12bStSY0lKZFVmaXdOL0FyOUN3Z2tLc1lRL3JqeVVw?=
 =?utf-8?B?Nzh5c2dXa1VDRlRNTDc5VHVrNDQ3ME9kM3ZscUNnTm92NEQ4alNtVm9uSm1T?=
 =?utf-8?B?Mk0wNzRQWnhnQ3VLa1NGcTljcUhJUWt4U3NrckNVQ3k5MlFrZ3ZJQWM2RDRx?=
 =?utf-8?B?QzIzRW5pVEJUdnd4Q041WnAzU2g2NUtjdTZ6dlQ2SVpkRVNrWHhXV3BwVU1H?=
 =?utf-8?B?Z0VXbGdYdFA1d25Sdzkyb2s1MExuVUR3ckJ5V28yZVhVZHorQ1BwM3RiOWkw?=
 =?utf-8?B?QlhGdTVVZG5ORENCZUJvMStuQmtwQWtoVHBRNUhaMldtZnhSZ3czZ3dVOTNP?=
 =?utf-8?B?b09tV1p3OGlBMWo2NCt2YmtOR1pVaWsvT0ZQK1E2ZWY2eStMakRqSDZRZG9w?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: y/5uxNcAJS6tB2/4hfYpGxKkyrcKaEcmn29zrLKN756FGXE0mG8QoGHtsOcek5tAErFG0VymAK7D6gL7KDnMYdKCG/G5TIpmgcaPqQh6wiWW7CXrsc+xLVLDfoifUHBTKZ4NGW1EDX8SmxYic32vHkPDfLYaaNWTNrxjzfnCyKA4/vNaoYnP5dE4aakEcWkg5GGQyl7xAJOe/HwyXheF72QjDdtBz31/AZ6N03e4i7zVU7qQUZId34L9YsbnmOX0ZN69lGWEPIGNW+k8fU9Db6KdyasPIcWeGReHa5sagQxi6tGBe09wiQkW1+FRP5HoGSOpCEaNZmXGScbNWWmvVsHoIIoW7ZlD+mVFEk8U1lRo03ug8Vrfzqf5yUIIZzMSr5x9kR6Qfn/FOVy41ToW39oEtGW/Dx+Cvk6v92u1p8PjUGhGUm2RVMrhemnoL48tw3+q7cppTmwDBjTKVZvaQiZ5S69SgC7IXy7Hcmu+7TRFbZmAHG277hUQoL22HOt3S9Lemga7gJTB4v/uMb9ymiXJeHkSRK4KSCgbmcdtwlcYoxl4felBV7sJ0IRMcgGwY8wLl6L+Oz6onUFy1btoIbca5uSVaTQzATU9pIFphQ0mAKEmzrnXx7n9Bj+VMrYdiS/5/TNsJcI704WJcTCGQJDi0TFDJ/PEzqtGOmeb3wfnNMoBzu7+HbfFvD0whyitBFDfhRb69PVHh1J4cLca51v6exJCnx5jtu626OvRTtWKAhA9gYtXUgi2eLuKwMrjfu9DdAtvl8MUiPyk99ZrXrfIrV7udjVKS5RTe6Kf7Ts//QKJUadlPtyR9wo7H/5Rp/PfqDSbq3T3+7/3LBq9aFj0VYVGW22x6ZfIfrnLzzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5030e15e-212d-4b39-a673-08db2a314070
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 17:25:22.9382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+Hvw0MiEW2k7T9E3FzTJCVR0Ze+PtglPOWZ/ogQKmOCeTv/gXH0BAYc0hTz2SAW8SHreJj+qdFH54A31RJuLOwzasJ2lMkzfwuRtW0yPg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210137
X-Proofpoint-GUID: Kq7AgRoluo5WCOMhEibRIUlkHCkKdTZb
X-Proofpoint-ORIG-GUID: Kq7AgRoluo5WCOMhEibRIUlkHCkKdTZb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/21/23 2:12 AM, Michael S. Tsirkin wrote:
> On Mon, Mar 20, 2023 at 09:29:50PM -0500, michael.christie@oracle.com wrote:
>> On 3/20/23 9:06 PM, Mike Christie wrote:
>>> The following patches were made over Linus tree.
>>
>> Hi Michael, I see you merged my first version of the patchset in your
>> vhost branch.
>>
>> Do you want me to just send a followup patchset?
>>
>> The major diff between the 2 versions:
>>
>> 1. I added the first 2 patches which fix some bugs in the existing code
>> I found while doing some code review and testing another LIO patchset
>> plus v1.
>>
>> Note: The other day I posted that I thought the 3rd patch in v1 caused
>> the bugs but they were already in the code.
>>
>> 2. In v2 I made one of the patches not need the vhost device lock when
>> unmapping/mapping LUNs, so you can add new LUNs even if one LUN on the same
>> vhost_scsi device was hung.
>>
>> Since it's not regressions with the existing patches, I can just send those
>> as a followup patchset if that's preferred.
> 
> It's ok, I will drop v1 and replace it with v2.
> Do you feel any of this is needed in this release?
> 

No. It can wait for 6.4. Thanks.
