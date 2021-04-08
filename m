Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95141C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 16:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675C4610D1
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 16:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhDHQfX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 12:35:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51480 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbhDHQfV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 12:35:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 138GU4we032678;
        Thu, 8 Apr 2021 16:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jyZTPAtyaU7LTn2BO6UIVOTYdNSWjyov6t1wDDV2mpA=;
 b=0A+hUOt04xGutua7h3PMnG1E9HsnY9+3ZjkP4YX94WCn32mg0UoY/i97tz817PHbM8T2
 1MJYn+LE8Gq38OlfqMhmhNWQ7LFFqEGfC3DP+wk3x4pDEIEejXinb0LNI4OFMO6dZvdh
 IoODvRJwS3FzUUikrg4EFRoyQWAGq6VqKgg0Kch1KaukkyKyM7RTdBKAL+SL7Min/9UE
 TbIXmWX33FQ12Kt9e29pf/0NL01HEbByIIIPQEfiSQRKMuDn+wpFE1IeiWGtGuASieoS
 K6Hn+PJgHBFaaNj3jM20JybLGFG3vGy8utLox39NpQL6dqJ+a/MZ2t/Mm6jlpcH2ILnP Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37rvaw6k34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Apr 2021 16:34:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 138GU3FB007237;
        Thu, 8 Apr 2021 16:34:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 37rvbfwg6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Apr 2021 16:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eU6ZYl5Yc41EFbe6HWyK6fxA4Z5hiVbJro0kUPn/gWM+DPuIruS/YYnJg7cTLLa53VBAkrDU+j9/jhBAjUUEbGojjS+N6EaWPcP0J0C5B59fH7gE5CMSsqEW93jFYJAsjUFGjBzXC8C08lyxuuiF09JJEQVPabCUqoyipa21q3Ij9TvFceFVeWn3NW+J59y5dsb6xC+jJfySiBWiKTxiFCuxUNiYvi5p3AwsIDEJ4dB9FUTRYrBsNXuu/W3upKiLVO7t3UQG6W3YX3OMV38gEYlwWpxSZaydcud584p/HCzfx8Pg9D1GAvPqme/NOVOfZO1n5O4qQFrCM+HYrdYf3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyZTPAtyaU7LTn2BO6UIVOTYdNSWjyov6t1wDDV2mpA=;
 b=kCxJ4ZFNiJsoU8xxK7ubH8ZWCPQPbt7SF1RnKMmK/Rbo3tdcAWDexdFK/8R1x8wUPgYC/U7JoNnpY0Ck3HqXgs41yUsHua78FlFkMKjI2HIS9Fn6/ZPPYs8lqiOkEaOzSWZBU88sHg8LGvsbtja5uqGXFQV9IyRuhzpXwK2K2i3d0NaqURlkcg0eZtlcodvFmtUG02XCwMzDAY81z6a0oVBIzha94X7trlhS4jsH6e8lnpMW/Jm7tak5TiMtbCmPbrrx9519yf7IrZRMxR4KbzJ0n98Rc7OX7i1T/hlBVi1yiTriWSPWCg/zmPaSI8HznYiMzQu6vvfE4TA+O+9jlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyZTPAtyaU7LTn2BO6UIVOTYdNSWjyov6t1wDDV2mpA=;
 b=yIaIlqD8y8462cDcRcNQ0PE2BFF1qVEW/ZQ6Odr1fjYn1DldZG/aANvJ4hbhGDY3ylz/tVdMvP8979Pv5RoL5HixXKG+cEp9DKYn1iTJL8v8e02sXEpmtIMxZhR9/pijQnMdedVr24oPgXqu/io+UyTF5uWoAj44qLtC5EKgJmM=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 8 Apr
 2021 16:34:48 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Thu, 8 Apr 2021
 16:34:48 +0000
Subject: Re: [PATCH 00/40] iscsi lock and refcount fix ups
From:   michael.christie@oracle.com
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210403232333.212927-1-michael.christie@oracle.com>
Message-ID: <6dfcc71e-aaf4-2831-5e47-d069fe1b2814@oracle.com>
Date:   Thu, 8 Apr 2021 11:34:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR14CA0133.namprd14.prod.outlook.com
 (2603:10b6:0:53::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM3PR14CA0133.namprd14.prod.outlook.com (2603:10b6:0:53::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 16:34:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db41de90-45c7-471a-801c-08d8faac396c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB331717D82A18C5B86317CFD7F1749@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16nRTtxnFLLYbxmLcA4YbUrxO4Y8Tm34owcfZlHxfeAInn9fMpoUgxOS0jsR681AUT2OLv+SFaJ/Hz7DDM9kOvop8H1Lujozad0gCbDqKKsfpTLT/roCWFsbWyT42dgtCsFjw2hQ93SWIGv8dFMI81AtegyqNoBy1Gm+0EuwkGlylyS0xUl3nADNnVWQF6J/DsJZwZuum8CKHFQi2zfD5vVebaeRk0msSjJEzTq49BoKjwvwz3f2Lca+8nz2PjtLESXgzz33fE5tqgbIr+MaUr0WZTJsOAZTEN95yCDuZ4FdCUx5aea970413w3jqnFezJeBIXU4YXrI6QLV6OuxO35GnI7z3l5jT+eAstTekT3KYQ/1oeILS3x6YHi8S8zBrUNY1QRq5imO8Wm2SC74+89ccb6gQjbUczNjmC2uEU1Syv+ePmyoqw/ORsiLms5gUT820bjg16wqrtL2YB6r3lOCxlTRDn6suNdV9RDSVcxCzFFXdgoDksJpHlGl569oHp5QrvzGXFVmzfCDe7GoiMJKMAq6R5sQmB2h1E3AIqZ5pHTru/BgPFVeJRA5PPSQK0ecP4M7WTUuf8l6zVuDsNtKZkbYRoykmhUGIfLZ6+kLg9nlP/u5VBIIzFOF1y9S2ChFJeSmDdwagrYPUS0HgaIEssJMLkhvTdMnuAhUuqBPW6LnUxKUo7C0BwM0Q/NstY1Iw9SdaJGEJqjmbQPAhLo1bONq01zCiC1gubjmoog=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(396003)(346002)(376002)(9686003)(86362001)(66946007)(31696002)(83380400001)(186003)(956004)(26005)(38100700001)(6706004)(5660300002)(8936002)(316002)(16576012)(36756003)(8676002)(6486002)(921005)(2616005)(7416002)(53546011)(478600001)(31686004)(66476007)(16526019)(2906002)(66556008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YkJpaTBhRTZ0WjZWdUtLdExYZVpjUHlRclpkOCsvUWxLV1pNM2xSU0FuUWVj?=
 =?utf-8?B?eVp3TTlqS2tVMkFDMjVkeTVadlRFanJjaUQ2MUNOTCsvY1ZWNFB1MU5HUDNt?=
 =?utf-8?B?WktHd01FcElWeUlITWJTdUJzWTNxck9JWEpKVi9UMmhRN1QwMWpDVUtMYVpu?=
 =?utf-8?B?NnZxa0x0cTc0bW5wdm5zNk0yRTZKZ3JPc0NZOVFPTUlCTWt0S0VEbzlEMHJL?=
 =?utf-8?B?bnVvVzQ4REtMVGFLSTNZZEZXSTlSODhMQWxoaXRrcE1BTEI3c3VpeVEzT2pt?=
 =?utf-8?B?Y1pNWjVoc0V2N2c2WndrUDN2VktWWDQ3TFBOK2F4dXRrdjBDQ2RqcFllYVh2?=
 =?utf-8?B?Vk1mYTkvaVo2TjN5SjRVUlo1SnBUSFBpY0xmdXd6TEp4YjhjK3JLV2w2YWJ4?=
 =?utf-8?B?RFB1VzZQSkJUSDA0VU10L1hHeFo1M0ZzNUdqWkRMZWExekJRbGpKUlpVSUpR?=
 =?utf-8?B?NitFZkxHdHpzMzJBV3hUcWJkQU9ZaHJUNGs3cGV5ZEJNRkRSa2poeHZqS0Zq?=
 =?utf-8?B?S2dtS2EyOFlGMktOQ0lQbGN3OGxiZ0ZxNU9jRnoyR1dtcTZ0QTlNTTZWbGhO?=
 =?utf-8?B?dGlkMVpRcS9zQXQrb3VRdGJ0d0xaaEhFeDhDRHQ5K0dRb0pZbmFRTDNHZmZM?=
 =?utf-8?B?Z3VoQWJUNzBtMFQ0bFdNbk9YMjdOZzlqVThKL1g3eG5WTmJqR0J3M1c3NDUv?=
 =?utf-8?B?eStMMTZ1RnEvbXcybVdiREJNN3lOY3hiU2xtUkkzOVM2OEcxSG0yZWFGZGQw?=
 =?utf-8?B?OEFSK2FtdFVOaG1lWUdaNysvbmxsQnYwamh1Y216QzF5cWt2ZER1TkwyZDF2?=
 =?utf-8?B?SFM0cHJOejgxOERKRU8rZTVtVkJINnlONEl1dGE0aEROZ2ZLejROYkl6SmNm?=
 =?utf-8?B?bkx0ZEIrVlNTelJwUnlGS3QxYlVnVTgwRGZ5UEhKMjFiTEtTdGNUY20yMHVQ?=
 =?utf-8?B?WG40dG8rM3VoTUpHcEJIakdTbG1YUFVoOTF2V2lSK3dMSW9QTWtaSmUvb1F6?=
 =?utf-8?B?L1RUQ0o3K1MrU2pKZDdOR2hGMkN6U043dmNEcTZ3eU5uZTJJbEFmSEdLN0g5?=
 =?utf-8?B?bkI3RWtvSEFaTEx2REJBOTZuOHRERU1YREZHU2VRaFgxNStWZ1JmbWRyL245?=
 =?utf-8?B?eWI3dTFORmtmNTRaWXY5SG9DU25ERzBPdm8zNUFleW4xcmJYOU9mQjJLNzdu?=
 =?utf-8?B?b3BxUnpNUUhVL1MzeHVNY0F1K0U5cXlhWWQ3NThqUnNHSUp3djNqWFFKeTEz?=
 =?utf-8?B?RWpOT292WE56dk9lQjR3dGl1blpua0RIRG8rUGdQYWFNV1cxMUt5S0JmR012?=
 =?utf-8?B?MUJGOFBNNDIxVWFkK2xmZ3hoZ2hHblFPeER4WExPa2toTnptMHIyWHV6K1NN?=
 =?utf-8?B?dEVFbWcvKzhsaFdMQU9Bay9oRmVpdlF5azduMHlaSVRsaTR0dHN3SVBodU1q?=
 =?utf-8?B?UytwZmZGQjlSYmYvanRldlBLMFBlTk5aNkJ2Vk8zMVI3d3VxQU80eWsyRnlu?=
 =?utf-8?B?TE83MTNBYnlWcFVRVmh1M0NVR3pOK1FwSTZSUk5MRkkrRmtpdVVjcThoNnBC?=
 =?utf-8?B?c0lDTW0xMGhzeSt1bEFuUEdUNFNLWG82cmJvZEVnVDJsd2E3di9NanpibUlV?=
 =?utf-8?B?NFc5ZFozMUx5V21uY3g2dk1oeXVLM0lhWUtVLzhHaFF6VGZTeGV3NTZGbWpS?=
 =?utf-8?B?NDBHWWVjZmE2VjZBcWc5N2pOcnp3dVJDSmo0U1pKdXN4cXdpUXl5SUFjbld1?=
 =?utf-8?Q?JMbArUhghjjKkMAxO/VBEUzDMPwGJSCrk89kB++?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db41de90-45c7-471a-801c-08d8faac396c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 16:34:47.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZvta1YsH9Ypg9a+8zV/wsT2PkyTu3aL4yN9X0V6iKltOfXBw+tvg/74wdy4iv3d6eGRNdBuHDbPuMXnDK53HSmivFEVYmRfEfmmUx+1QWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104080109
X-Proofpoint-ORIG-GUID: 7yTrOCNZlq868-vhfNFpgyIcusYaUVcK
X-Proofpoint-GUID: 7yTrOCNZlq868-vhfNFpgyIcusYaUVcK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104080109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Lee and Manish and others,

Don't review this patchset.

I'm hitting some issues with the code before my patchset. It will be easier
to test/review if I fix them first.

Lee, I'll send patches for the ep_disconnect/iscsi_conn_stop issue.

Manish, I found some bugs in qedi that we might be hitting:

- it shouldn't use iscsi_block_session in the tmf path
- libiscsi and qedi can get out of sync in the tmf paths and cleanup the
wrong cmds.


On 4/3/21 6:22 PM, Mike Christie wrote:
> The following patches apply over Linus's tree or Martin's staging branch.
> They fix up the locking and refcount handling in the iscsi code so for
> software iscsi we longer need a lock when going from queuecommand to the
> xmit thread and no longer need a common iscsi level lock between the xmit
> thread and completion paths.
> 
> For simple throughput workloads like
> 
> fio --filename=/dev/sdb --direct=1 --rw=randwrite --bs=256k \
> --ioengine=libaio --iodepth=128 --numjobs=1 --time_based \
> --group_reporting --name=throughput --runtime=120
> 
> I'm able to get throughput from 24 Gb/s to 28 where I then hit a
> bottleneck on the target side.
> 
> IOPs might increase by around 10% in some cases with:
> 
> fio --filename=/dev/sdb --direct=1 --rw=randwrite --bs=4k \
> --ioengine=libaio --iodepth=128 --numjobs=1 --time_based \
> --group_reporting --name=throughput --runtime=120
> 
> I'm still debugging some target side issues.
> 
> A bigger advantage I'm seeing with the patches is that for setups where
> you have software iscsi sharing CPUs with other subsystems like vhost
> IOPs can increase by up to 20%.
> 
> Notes:
> - I've tested iscsi_tcp, ib_iser, be2iscsi and qedi. I don't have cxgbi
> or bnx2i hardware, but cxbgi changes were API only.
> 
> - Lee, the first 2 patches are new bug fixes. The first half are then
> similar to what you saw before. I was not sure how far through them you
> were. The second half was the part that removed the back lock and frwd
> lock from iscsi_queuecommand are new.
> 
> 
> 
> 

