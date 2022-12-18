Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30173C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Dec 2022 21:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiLRVlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Dec 2022 16:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLRVlG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2022 16:41:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C8610FF
        for <linux-scsi@vger.kernel.org>; Sun, 18 Dec 2022 13:41:04 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BIJTPvl008958;
        Sun, 18 Dec 2022 21:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SL2WFitkbMP55x8sAnQ114W1BanKh2dv6Tnvorp/nN4=;
 b=YOhSbUhVqhd7aITba3482REzV6FdTf5UN0QZ05iKP9E42FaCYmBPwxwm/UcvBadt4qi/
 lxzYoLOO1iEP9fDYefni6QOsQ/K6uzCkELu+3ArBA6JsAA9Ir7AX1ISsm6VABJVOs238
 9aCczymeEf6C8hov/3CAVoZjacWVOxiitw75xqx7J4jeMnhTfwGHtoxOSC7qXQ84rUsJ
 fdk3emU8VFmeoXJV/2pY7DZ5hZccu0SLYQ2nhOotioro4L9sKUYoKGCNvQabm9HnDyw+
 QU+HbysCgNbpFSDaNl9QKsfsGcfjzvlvjG6zPmToGb8sVMQPX9mxGVx2NTlEIHqlrqAi 9w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tp1qdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Dec 2022 21:40:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BIK1JLo006497;
        Sun, 18 Dec 2022 21:40:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4730cr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Dec 2022 21:40:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpL+TsX25b6Zyq9eE+GpcEDE+AYgm1GWZTUa2nVC7xh9SB7G8DxQuDyeBXfo3C6YJ5l4vTTA28VY3e29Jc4E8eh+94PUFR7BFWBfxGyVJdiyVx5Md3NUE5THoG6vjKxFByQU9de/FscM9KxeUFNshK9IT8r8IG234u6ztV7y4fqrrwX63zK/EAjpYwmEqIqq52cufrw8Ps8ALhvHdO4JCyfzBDPHCPepVsON2p1zAjSMbV8u66Wabe++6dLCR6sQzAR0S9fbsQiSam/f+0VdNqLI7cmUOTUJq9lisvGqF6Ml99ZOhjd7dFvA1TRvE4x7WZwzkXNeLL9rM9oPQOn0/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SL2WFitkbMP55x8sAnQ114W1BanKh2dv6Tnvorp/nN4=;
 b=GX5Fv6KNcWZ8LARtT0FFKsWvXRGkTDx+csWym81XxJqNPHC5nEmZEJ14cCX15EDmh2smSqUJFjQVZPtac/d8qMafVModxcVjNhDBH9B4oYGfZuFp9z0suo4gw1RGsj3/OFhQ19Z9ZEm2zG7jmrICUIZT08MHB5yA9jKHBHQVX6nqXCPI8mjxWLCQkyTiboPDuDPvnxIhP/AUsrtUA4r8bggcA/68A/7On1bXk50o1biOL6sbAx47fBJtajENQ+ZOLWq1wJpPYgL6hzylGdsowU6lj5bpCUTvCEKB1tf5GXBu/7fRtrXKppebcuieQGY45cuJ9qFGn24WM4y0KjLqUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SL2WFitkbMP55x8sAnQ114W1BanKh2dv6Tnvorp/nN4=;
 b=pkraTr7CmPJsGpwouq3PYJ6ZHV4Tvu+IGJaRXudVXYDhJ4MnQl2nUasXKhfyxBz7IjKIOh8t9PN3ei082+aIihKq9fPgIpc/dH/0RtviEU/GYSLUjHnkMRoRy5n0BD5aujd62/lC9Tmh8NoMHSZ1hRQtEZSolZuw+jEsCD8Ykkk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4905.namprd10.prod.outlook.com (2603:10b6:610:ca::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Sun, 18 Dec 2022 21:40:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 21:40:50 +0000
Message-ID: <0771d185-107a-e3fa-aa61-9dbd1da36a61@oracle.com>
Date:   Sun, 18 Dec 2022 15:40:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v3 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
To:     Christoph Hellwig <hch@lst.de>
Cc:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221214235001.57267-1-michael.christie@oracle.com>
 <20221214235001.57267-13-michael.christie@oracle.com>
 <20221215081540.GG3308@lst.de>
Content-Language: en-US
In-Reply-To: <20221215081540.GG3308@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:610:b0::9) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f857772-f503-4ed0-f9f3-08dae14087d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UF+r7SRwvjTJaZOF9uwrTBAo+DXE1DgE91WvmPeB3PGVELVDz7AxnH0yYfb9y7ukQaUJ4z25C1K/8eMNNdT1UaltNG1QNuez8hpT5jpOwKqlkPCeYMWYLRpGcFtgb3QTsHIBsP4ZdvX7/ZoF1Y8DCqsBjl71kwcB5hnpBTQedcJoes7OGxZrOFQyFtqk3JGoJevaXjN/jHqzc1/ju2QFx8w8s3wn6M48AaDipoaa6e2AACuzNqCx6BG2bLq9tyvwjU9uzi6utXjEPRzBBSQaA/EWj/V8NnGrPYvzZERozOzBAYcOTGaWHBMMpPLAc0RkmIvOKzGhP1GeNnGPieNvzkMjAO0X7EcsfnvyGdcAHJgt7liG97titvppW3wWn0wDnFqkyIPsVyxdyQGfVXWR0H3BXbselTlQDqggJohKlaxYkKii1Pjx8wsSZNBx6SdY1kmDOaIr9N/rnQvCigrYRaSgv+Upzsb67VnzQD6HcYr5no9KM3VNqycpnBndqj4Msf0BO5Xnu2jcPquJXavCcKignucJPDV6KIvQ1vv1z9MnnWUop7zdiXdmQvgtJvk32vCWqh9qOOpPmgFXC9A2NKM1F4w3JMxD/CthSOrkzjxDrmW8USr6HW6U05Tm+vLN53oJhucfdsQe86Kfe3r5Dw7ztLH3gxgX6LIx3ohoGCSJyVhUOQp98ls9aJepa4EjzQBqFA+gkQtTLJAcr10z78z6citVgg7WuZ9mYxKNCuQhpGMTS1HJ+oWHShybNXKo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199015)(31686004)(478600001)(316002)(6916009)(31696002)(86362001)(36756003)(26005)(53546011)(6512007)(186003)(5660300002)(66556008)(6506007)(41300700001)(38100700002)(2616005)(66476007)(8676002)(4326008)(66946007)(966005)(2906002)(8936002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVluQWhxbEZMK1p0R2lmOVVFL255dGVkVkRMVjNXeXlLWkFqZzJVV2JXdzQv?=
 =?utf-8?B?OFEzSzVBYzdwYy9jeXQzS1dyL2w2UDB5ZFByTjFRNUFrREI2SjdKL2xEV1Av?=
 =?utf-8?B?OHpPOHZRQUxqSXV2bFAya2hSTVBnTnVBKzBDZElVYVArTFdPeGRaVUVnYVla?=
 =?utf-8?B?dUcrNFQxcmFaQjR6ZFozdEJiNnJXR1N0OFkvZEZVNnBTMkVBOUs5MlNmZTYx?=
 =?utf-8?B?dHBacktMbHVQdWtzbUJxdzBBbDdYaGdCaWpybG1qeWRzeGlXajhoaG0yN3RB?=
 =?utf-8?B?QmFhUkxxMlhvdjZuVTF2Uy9WUk54MUQ3cTVqNHVHakJidHdmRkQ2QkE3U0FD?=
 =?utf-8?B?cmpBTkxHTFVQaVFKTi9lWmJyTkxoZUtrd2cybUJaV3p6RlZabndiN3dPQ1hM?=
 =?utf-8?B?bzkyZnZHZHkxaE9XSGJwaEtVcThXT2pBb2VIZlYwbVNnNDZXN0JyRXR5ZXdU?=
 =?utf-8?B?Z1JhT3hwNDhxSC9SS3VzVWNqYS9CcUQ5dTZSanZ0aTZRNDlpUmVBbjlPNldD?=
 =?utf-8?B?NllrV2pwbGQvYkh1VlJkZnFwayswUUtMdDFOczN2NDRrQWFCcGw2d1RoZUVi?=
 =?utf-8?B?N2l4WkdTUUNJSEFMMzRXdTc3YkVlcEdXY1F4anZjRUw0RXdjVVgyd2lZL0Mv?=
 =?utf-8?B?eGx0VDRQTXhQcklXNUlMOXRZcENtYUw4M3l4MXprQkpjd0Z0aC9kelJ1cFl5?=
 =?utf-8?B?aENGRmFPV21LdGhrWUdvbkh0bWMwVytQZlg3dEpWSkRtRVlEOXRPNFJFUEZJ?=
 =?utf-8?B?aFhYU2Q5KzB0MmV4WWtHelBOY0FvWUsrVE0vaFByU0pKODIwVE43ODlsK0da?=
 =?utf-8?B?bExodnhmNHR1YzllNkZ0V3VhcUxQMWpPODFyS2k2NG0xYnVROEprclJOL1p3?=
 =?utf-8?B?RitLMWorbWhUZkJoaXZJdm4reWdScG5QaXZQR1ZHMU1zc0pnRHZHaTBnU2Jo?=
 =?utf-8?B?QzNxRFpJcGpjZWlybHRLZEc3TUNidU5nUTk2bnZ2TEtjUGxjQU1JR2NBU1E0?=
 =?utf-8?B?ZnpvMFdZenFXai9mMUlQcW0yTDZmSjhHRzRmYjlVOHpOYWJkbzh3elZDRFNU?=
 =?utf-8?B?MkNsOFpySERyd3h3NTBTSXpZOWNqQUw5UmVFOGpGNUQ3ZUNkVG8yaFplTGto?=
 =?utf-8?B?U041aW1rQ1FjSEVhYnhTWEtlMURqNU9QYlhGRUVScUhuS2ZKNTFjU0lYMU83?=
 =?utf-8?B?S1VnVU5WdjhJZjVsQXUvcXFyeGJuRDdJSWVKZ25ieGI2WlFWSEJ3bWtLQmww?=
 =?utf-8?B?TE5IektidVJLd25GNDBwV2d3TG1oL3Y0bXh4NzdIQXJpVjFNWE9jUWR3Vy9t?=
 =?utf-8?B?NCtaQTBmaU5wVjVET2xpektZaUZNdVRudjVlSWp4blhDSWlwMWdvNXQxRXVi?=
 =?utf-8?B?MGVTN29xUy94OGdJeU5qcDA3cmlybkNtZWtOQVpNbzVHSkZsVFRWSmYrNVl6?=
 =?utf-8?B?QVYzekllUWppNTAwQ2tUcFhoZVUrRE43dkhpTUpCbUhGMjNUdFdkYmRQQUVq?=
 =?utf-8?B?T3VZOGRvNldpWW9jWkN2ZGdDb3pPVFJyTkQvUlo5czF3UEtwUXdSTUU2bWFu?=
 =?utf-8?B?OGU5Zm1Kb0pJY2Z2NFhiRktFV3gxUDFIa1VMdU9CUTRGNy9rU0JZNWIyUjJ5?=
 =?utf-8?B?eEZEbGFQQkphTzdYdHNhZWgwSGNsMmNHUitXeTl1eDlBRzhkOHU5QjdpdjN1?=
 =?utf-8?B?WUNjYzYva0V6Q2JzZ2h4blpSQS9LWTlaelFUNDE1TTc4UVROWmRhSm50VUlv?=
 =?utf-8?B?Qk1ZUWQrTXV3WFhxSzV3M0xmVmlrZCt4NDB3WnVJbFRxbDJmRUxpYUhzVXJS?=
 =?utf-8?B?eXVXcktiOUttN1hJRTFmSk5Xdk1mQ2pnY212OHhmZ3JVN0hFSlFFbEM2VGRq?=
 =?utf-8?B?VVlzc3FKdWczMFp3WW1seERzdWFocS9VYnhFZEZGTHJBNThoeHozdmlIKzQ0?=
 =?utf-8?B?SXUrQkhkTVFXNkxadjBUS2syL3ZyZE5ySFZpT2lxS1l0SmNvSmxjKzZRZks3?=
 =?utf-8?B?UTJBcHlTbisxTGRhZEt6NVRuaVpSQW9QWDJQeFJhNGFSSklPbXRPdE10c1hn?=
 =?utf-8?B?WTRrMGhERUlwclVXL3F6ZVVJVTgybTg0UDgvdUllclk0c1JkbDdnWU55NzJz?=
 =?utf-8?B?NjJpV1luQUpESkZLMGV2eStqOXRVcmRIWnJ6VkRyaHFZWUt4SDZjM3ErZEdG?=
 =?utf-8?B?ZUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f857772-f503-4ed0-f9f3-08dae14087d5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 21:40:50.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfDzjtHW6nzwsKY4e1FgSFmwh5et3xkdejya/JcWtuKK7gfPJQKTGE1TF5WmHfhJNYllUPxOgPlK6FkPd7APR/+VfU1D6kajUy3y8sKyvk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4905
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180206
X-Proofpoint-GUID: 6u6i-MXkkERAMeUiqErubmoDZG-4XWLG
X-Proofpoint-ORIG-GUID: 6u6i-MXkkERAMeUiqErubmoDZG-4XWLG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/15/22 2:15 AM, Christoph Hellwig wrote:
> The conversion itself looks good, but how the f**k did we end up with
> a LLDD calling unquiry below the SCSI midlayer?

I don't know how it happened.

It looks like a hack around scsi_scan_host not removing devices.
Going forward, it looks like we can remove the inquiry code by having
scsi_scan_host be able to remove devices that are no longer returned.

However, there's an extra catch because they have that DID_BAD_TARGET
case where qemu returns VIRTIO_SCSI_S_BAD_TARGET if there are no devices
on the host, but other drivers uses that error code for a bunch of
different reasons.

I was thinking to handle the DID_BAD_TARGET use case above and this type
of issue:

https://lore.kernel.org/linux-scsi/CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com/

maybe we want to have a driver level BLIST like:

static struct {
        char *driver;
        blist_flags_t flags;
} scsi_static_driver_list[] __initdata = {
        {"virtio_scsi", BLIST_REMOVE_ON_BAD_TARGET},
	{"aacard", BLIST_SHOW_DEV_PQ1},


One other question, can I do this work after the patchset in this email, the
scsi_cmnd retry patches and the actual PR ones? I keep going off track on these
side adventures.
