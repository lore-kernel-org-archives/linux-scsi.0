Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B6CC76195
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCUCaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCUCaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:30:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799DFFF19;
        Mon, 20 Mar 2023 19:30:00 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4SJ2019672;
        Tue, 21 Mar 2023 02:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=F1aco/t98zkS6V7QZwD+XY1wdCFP2dwmpRSDGD6D/h0=;
 b=vWZQm30FAOFh3ptrBN6jjP8x/Dw3q+mTRP41bdGfiC37hSuwpYR1/MyZSzsVS6wxqCWS
 uJG857yNSQOOtNZbcD+GaQktrday97RrIUrrPRUu2RCFUtWy37yQLYgCnmRNFEd6bsmQ
 9GawMTsBwN/If6I8aA+YXmxFB/k9JH03rjlrkATw0nIX73ees/hLkIqUbh0FdYZznWhA
 MI2ZIvo2dtlMitgSUWHSXzT0Mu1MYiTDyGn6iiU+ZDKxmCuKt5yJqf3klM09wONHVKSh
 J7YEC4rPEjlDmH7KUD6Mpk4RN6UO5jrdDZ1tat35MMrVcXPHqfuseDr4UQLdcT5zVv/p TA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3qdmybd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:29:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32L1C9ZG038918;
        Tue, 21 Mar 2023 02:29:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3rck1hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:29:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFSDnDd/YGC2GSrEtegDzzrQ/I63keozpujX+xGxTM1ukiPjO3XTzhQtWU+sLAV9ndJg3H4q4FOTk9bWYsRDLMslhyXqViFrrP5lrwRuQkPEunj7gnAlDRmT55TEHXzuh7Xc2YxmDqqU7OTkc36/Bsbtcb/5dZPhPZASfabj/lUrUgZq8JFZqPljEWUT/7deXBfqlt6JpF1krIUHbfFHQLP5sLIyD/9qjhQANhY7vpraZ60qQFRRceyxL8OItnTXEZsap/VYErHxVpY8BQ/Olf82x6BxazkRGy0UDJh25gmeEXyf6wkVaB8I7rrEPJj4b/YIzcfzMJsmhnUfDkrByw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1aco/t98zkS6V7QZwD+XY1wdCFP2dwmpRSDGD6D/h0=;
 b=l8FXwbCPTIzmFgtCqgRhNz3d430exy6IGrhqe6d4O4WhRPm1ZOU6p8zIHyE6JEW03b2eXWVRRBVMINLe4dHbIP+uCbnGHzz3OoELF6yfiVvn6sbGy+Oe6qXt/473cIkLdJcCHL589v2QaXF5fikdUQ3irBkyiLIM8wsGb+JxuXnhQIq96tbTNEDIBfsUh0Gww0OkGVz36uo87pYWVEmUggpM5rdFETzcGH94rm29TfscAjjd0h8fPy4xox5ebIbGDEnlVVkQjcLZloCw6+Nv9Jiiu2IcYnWfLzYXtfFe+zJWB2tMW7gKbL6R3FM7kNDJnhFOt+j/sTGoAoZOq8JUaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1aco/t98zkS6V7QZwD+XY1wdCFP2dwmpRSDGD6D/h0=;
 b=oZ7N18ag9tohkT4C2OcmezMgkjiT+YwroSiuyxKkknVEllpiAsbSf/tZUwY+NaTswqDWUuET/4cBgFuJWt7zl+aSWWuARsTrHsgtqWVBEn/ApQu+xAVES3TT+De/tnOK6Dp0is/fxMUMwqHO8hWZdbjDpCkg7p4HCyDr7JE2umc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY8PR10MB6756.namprd10.prod.outlook.com (2603:10b6:930:97::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 02:29:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 02:29:52 +0000
Message-ID: <e1a96cd4-e520-caf5-7d5f-1de270c4fecb@oracle.com>
Date:   Mon, 20 Mar 2023 21:29:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v2 0/7] vhost-scsi: Fix crashes and management op hangs
From:   michael.christie@oracle.com
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20230321020624.13323-1-michael.christie@oracle.com>
Content-Language: en-US
In-Reply-To: <20230321020624.13323-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0139.namprd02.prod.outlook.com
 (2603:10b6:5:332::6) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY8PR10MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d88e3bc-d728-4cde-fec3-08db29b426ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZM30CAjDv9M/T3rnek53cqdI0xjSOGGTqRNTJQqSqfW8xaqpo5qyWRd75UvspBATjLvpCcMMsm5NnUsJfHjRFgZQ/Ao/9mw4VjxIZN2o8hJg0+35TGId0vCjL/rdapRPp45pAR4C3D9Jl0oma1EBbQzD2jSije26TdUztbdBv4Xv6nuz4Oxb02tZNLnBtsElnPR5KIkeK3O+AQuwFHoI3bhkXQCdZAgU0C6MueIeoJSDm0Zqk8FJQ2fIzJlkkch0ndjMPU/71c3rQfS+EOozYJLBX8k1ALMxH02vGYo1X7Nugku+S28C6m3V8UtZzJogxBV/Cvs7uF5P6A/ua2STvYQ3mguCwYk3DWJ5PN14Cw9GvSbvah3PgT8438LwmGcvNsJYmbvP02lyLsZLfdipVGhhGskOcskWy0Do6aktXfLATlW6AQRYZVCf993jSKrGxPoPS4z4Kdv1MsJ38dAkhpgDcHdubyiK4Dy8ANS5IVYaB0LjXnF2o1+mmiATQZJJz6ZwGR92ebQtB0azb8hD3QtQ39JiGTKVWT2PFmBFQ7qaZGWBlrbXPT66y3PklXxSZa91wnamsGVr0iAUhVBqJSJYF1Zt+xrNzmNfrNigResfGbvjywnXlbHw/JXVspxsebbDMTn9Dr7JF0a0hMSrbojnnIgR6OJ3ifpM6vCmodlYNX9i8oItpBWAz5HH1wmlCdYmteYdA4sOuO6WuCxEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199018)(5660300002)(4744005)(41300700001)(8936002)(86362001)(36756003)(31696002)(38100700002)(2906002)(83380400001)(6486002)(478600001)(2616005)(6512007)(26005)(53546011)(9686003)(186003)(6506007)(31686004)(66946007)(316002)(66556008)(8676002)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUJJcUxDSlpqb2dBSXJYaWNCNjgwYlJ0Rk1PRXNyazY4Q1Z4YjFzUHpkWU1s?=
 =?utf-8?B?QllkOCtvRmtmaloxdEFhMXZWMnBnNVJ6K1BIbmRYRjEwcVRjOWFWUHdhM1R6?=
 =?utf-8?B?QmUwSGFQeFQ5c3p2R2pIMXlrN25HdnBmdXhLMTFpQTlRRTNRME5PbEYvdG5l?=
 =?utf-8?B?K1EzK29weEtNVlRaNGtxbEc0cVJkMVA3Ykx5T3J5V2JaV29GRWJ6SStETHdk?=
 =?utf-8?B?QU9nbWRScDRHY3N0Smc4dlRBZFZDNXBmVkVHWm5jZ1VUYjlycHlMaFl5bElN?=
 =?utf-8?B?VTNGNTd4YmFpWHlOdUFBSzRyVXlhM292Zk8zMVYyQlhaTUYva1VhUllqcjl2?=
 =?utf-8?B?WlRndDZ4MHA4K3RsVGtYME1Ba1lNYTZUS1VtWXBZVXVsa3BVRk9rYVZqNnpw?=
 =?utf-8?B?Zi90VnEvdjVwaFVtaUhFK3RvSldZMUZUNTFYZmlCbVE1TzQ1YTMwVEtHVmdi?=
 =?utf-8?B?RzE3ZnBOaHFuUndFaUVvNU1HdDhRUHJMbjRNdEJKT2VWVFVjUkxHVS9rQUlI?=
 =?utf-8?B?WHZ5SjNPaE1iMStDUmtWTjNWM3gxOUVaKzR5c3F4S01rTWU4VytmV1ZWYWRO?=
 =?utf-8?B?dnY5am9sQTdGQi9ibHduMFRFNkxiWisyOXRrMk96dnE3M2xSUitGLzVnYUth?=
 =?utf-8?B?eGZ4aFBKS3hyazcvaFVTZ0NzSWc5M2owcnBDVE9MLytGalMzUk9OdjdySGtk?=
 =?utf-8?B?YXNKN2V4a0M4aVZaY09sSUMwTTZQbWp1cG1Ra2RnZEV6alY0MGx6RHFYcUdp?=
 =?utf-8?B?RjBxNjhOTVNtRENmYlFnMHRjSW9iZGJ5enFOek1WU2ZUb3NmOHhLYy8xSCta?=
 =?utf-8?B?eU5wT0ZKajJCVEx2MCt2V2JrNzZlZkpiem16eGhUT01ncU4wc0JyS2tKRE5m?=
 =?utf-8?B?a1VqNzV4SUdoN3BzbVpYSDV4SkF2a2hsQ2VTazVFTWhyZTVNV1pJS25rR25o?=
 =?utf-8?B?ZWkweGQzV0MxbnlWejQrTGE3Yk5Pb2g3NGNwQ3JrQ2ZmOUlRVVRQSDZPczM4?=
 =?utf-8?B?UENtTkN6M29oKzhLNEoycjRpR1ZTYnJJYzJGTHBkd2t3LzB5MDlCQ0tyaFR2?=
 =?utf-8?B?Y2hacnNja2NPU2hWSlJFa1VFUHJ3bTluYTBhWHlMUExwdkxmdlo2YTAxamdk?=
 =?utf-8?B?RmJlRzlWU2RndUwwN2tNY2taTnpCcTVTVzZIUTdQbEpsVTFvSzJybmdPVmxX?=
 =?utf-8?B?eVl3TUtKZFZZOHFHd3ZoTTdGbkNaVzgxN3NmN3I0T2xaQzN5TldBNG82UER5?=
 =?utf-8?B?TjhnSVlrU2h1TlY0aHlNMy85TW9lWDlFOFBMcDRjTWpTYkFzalQrM2VOMm1p?=
 =?utf-8?B?d2poV1ZMYUJXWWFyMUVNbFdBZUlVVW9uNXhvV2VQT0MvVVE3L0FLS3FYRWJ4?=
 =?utf-8?B?bmh4UWFxakRlRElESFBlcGFLZ0xLandFWG1qR0xGbEpjNjk4ckFSb3Rtb3RT?=
 =?utf-8?B?Tk5uRTltUXMzVGhBVHMxdWh1UThNT0tCdXJub1RJMkZFb1AwQmZXT3dkdEJx?=
 =?utf-8?B?eGMvbDNLNTVzOTlyR1JMTnU5aWxSUTlwVTNzcUxJZXo2T0FnSG9ubXEraXI1?=
 =?utf-8?B?NUIxWGlVUGY2Mlp5OExJSlRsdjFpeFNjZFBDcEVYNFdhTUorN2p2WXJyTlpM?=
 =?utf-8?B?NzEyVHErSXZjWmJaekh0TFoxM2FiZ0d4THdXRWp2QzVuSjNNTnRVTXdmN1Jv?=
 =?utf-8?B?cEUyTGlsUm45N2ZIZVk5bnM0dlZqeWZ5cGdDSlBSS0FhWGhpRS9UMi9DTzQ4?=
 =?utf-8?B?cFkxYU00QXdpdTNsUHZoRjMwUUFEUkQrWmU1UEYxU3lrNVBTclpIWEs3U1Iw?=
 =?utf-8?B?U0dtQStKK081VDR6Ym9SQ3M4TG5XZzVZa0h3bldGWjZsZ2NUMGZkaExlTHVR?=
 =?utf-8?B?WStodTFzcHU4bEU0RC9QMlRaSkk4eDhUVHM0RDE2MjlRRFh0OGVpWnUxdUN1?=
 =?utf-8?B?b0t1UGVjY0d4MVRLbzVLODZKVVlWMVlHWGhkSk81VjNEalpLakllSW9XamVo?=
 =?utf-8?B?OWpxYzkzRjB2T0tkZVNkeDUyUmJsV0ZJVkhGeDVXR3orMDF5bTdhTGVzYytC?=
 =?utf-8?B?TGVBSHNCQ0R2WERVN2VIS0s5a3BaaXNzVlI4THRvUGhJcUZsQ3ptcmtxbTY1?=
 =?utf-8?B?Qm54TzZTSTlHQmZxelJNTDZIUXdVa0F1RDZ0NG5FZ2kzaldidFdIeW5LY2hQ?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SmZbLAw8VA+PnRGUDmIEk3k65TPsMN6k10+5tLggxLHkDnobv4JvKbxJWFq9umCTybX2MyRh/CwTHmqYlDJ1EzuVwyrayoP3MvM4bSxyCoqNITlavtzd6QIB6DHHvt8cjcaJNVVahbdqP/GpyS5X2/evbdwi4nxErTCkDJ3TFP+TqaUbapxY4/QWe/Mn7aKg1ovFSs7HeNVclk7db48iOGm7uLf8rMLz74MoYNxzOZjeHBP2nG8l5M0Kb03ZqLpFtYJgF+yVRKjOODRJYwSuLMuWym+o6jg8g2VhJ4xodKFPnTb3BagL6MX5gT2pYiL2xqLaPNdWXdwr74/53X8WBV7WU4ko5Z1iKaYCHHGQmMkbw3Cj8HmnZdRe4prPkZYWcIx+3RU6e7sqq4reBHfzgAZ9nswfQEGIrk3e9wiAEAF0kKKoRXyIB7q+0WGF0A8jVNymtEstzXPGWgE0bNeF6/lVfPqLl8K9pYON2NBk24+KddiaowWzl8r1DaZhG+O2fk4U3H/xDtRT5v5CltGz48aW4ElyV1TyQWljYotZb8mIRfACAhlPYEjjzZMuZ95FeqkhUCA7+CcgGnAg01jjp4+gNu5y7Gvo9OwCoCuHzpcQcN9nkvfWhB1h98Y1L8YAZ7iCGXd9RCII5aijQZcT6azT3LBtdqypUiSOk7AmAat9ShbT6ap2tG6tDP/fUVcU1CSGfymabbl+P5W5Jx8kOww9EfoPnJS3SkiZ6HOlYAEprWR8rgk/Je2JFRoTcP2IQEZlZMcfd32ra3SrcsYRUoHZWiH09jRKZyG6OqQglLttFg5iAxAxxC4joIP1raZe6nguoogCR85BLAlkHFkuTqOgsVvRaXYga4lgK+wCCaY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d88e3bc-d728-4cde-fec3-08db29b426ae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 02:29:52.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBmnt0q9pH8uFz7ygnxmMdcLPqxr0TOEV9ZZt+QpESh3zaXZYtB0xkpHoUHzdshMwYN0KyKLt9R8UbYjL9vGVpqtGoIs07HQEBSNDqpbLKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_18,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210018
X-Proofpoint-GUID: lPmd72l1q7B9cs-nmKSzLPGi0l2m0GBR
X-Proofpoint-ORIG-GUID: lPmd72l1q7B9cs-nmKSzLPGi0l2m0GBR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/20/23 9:06 PM, Mike Christie wrote:
> The following patches were made over Linus tree.

Hi Michael, I see you merged my first version of the patchset in your
vhost branch.

Do you want me to just send a followup patchset?

The major diff between the 2 versions:

1. I added the first 2 patches which fix some bugs in the existing code
I found while doing some code review and testing another LIO patchset
plus v1.

Note: The other day I posted that I thought the 3rd patch in v1 caused
the bugs but they were already in the code.

2. In v2 I made one of the patches not need the vhost device lock when
unmapping/mapping LUNs, so you can add new LUNs even if one LUN on the same
vhost_scsi device was hung.

Since it's not regressions with the existing patches, I can just send those
as a followup patchset if that's preferred.
