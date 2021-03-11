Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3888CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 23:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1576E64F7C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 23:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhCKXxq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 18:53:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhCKXxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 18:53:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BNoSHA007013;
        Thu, 11 Mar 2021 23:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9OPocUNO8PRy6sYTDiOxcZ64YsKLDg8zaNp6/Mgjlm0=;
 b=HCy+eZQX0jFiCw+1V2927/ErSieR7bVV9i4ZBTBSg4yvPC12HBMpj5pWTEjgvB1KD9ff
 2XjAn+IwElYYQ2DEVYDG594ol0nEWDpyCx4kM2P0E/YT7oErO6cQrQGCXe1ALuRjWlI2
 b/SJc6AK9boyHrxtXJ8bN/p525UcHoWbYybY7k+NGBGqM9S60hnoVYxfU4PvAL/yLAgT
 GWmIDIoijh8dRKRyK2SPM1k6988L+fHP4wMsgi20w+NDu54O+UehbIbuq2hkoH9bt1r7
 c+00Kd1FBI3IezurV5efgxfPr4jNMU+Uaoe9eRS/2qwWWLV1Ktz07iX6fUweYPsMdiBd vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3742cngcvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 23:53:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BNnY8X156639;
        Thu, 11 Mar 2021 23:53:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 374kp1qjv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 23:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeqOiJNbZEnW4xBLhWZrySdLy7peI5AVzvKnuRfalY+Y6dXv6T4WaV1WBX4cG7Gn2znbyVdaCzYAPPZHd2EeURspZfmfoLcypwZ/A/+cxg/MlDNBhEVMgemzf9lNNOaz0R9JVKvigJsVnp+9WLYSR76BNBlzipZTGGkLAkvvYpyKFdRIaisCyZBgL6OyaVdQiB/u88IzalLN5ged24PFKx0jMSKzgod64+BHo3Lx5Gsj22cTNqBxQgsMpa2Olu2qjywlVs0ALIDY8Z6Cl8rNfMnLLRScD38KHwBNobLv80Xka7vySt/jpN3mnnUbL4M5b89pSAmOAxUqplVyR+kQzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OPocUNO8PRy6sYTDiOxcZ64YsKLDg8zaNp6/Mgjlm0=;
 b=CRv2jNnDIiMVAFjaoKsfywDjVFXwPHLrStivKjePHhk9VXI6L5h3mFIVcQLy7Bu0jPECEsiryDy8Wdj5SZX0H7rdataqk5L7KzLqrK6Pv+ocB53vgnmKPyVqNSH1o7o1y6DI12qz6Qw8KxNPo2Ny1wFHFHckqOHTy01ydjSooUE6AZL4Q4neqQ3TJ1eher7TsWFbKuGe2JImS7veKv1tLI1kF1CFTnpZmxghg87Vk5bGy4uGZiu4ni0i8PZA89JJJedm0e6hEL04qxhk3f8cMlSfBS3kCq2G43Pt6FQijkmq6bqvmf/BOm0rKlt1bYFSMQZoEmuXfGOwe4RxYDlCzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OPocUNO8PRy6sYTDiOxcZ64YsKLDg8zaNp6/Mgjlm0=;
 b=AXOjtN9WY/63PEx0Fj4Sdbkzni2TlimBF12z1x+dGwh8ubrq0lzAKcSyjl4WjpBBugv9EDl0ES3E/iCwIaHdI8kHkEBc5S3jt3oM+CldFd4mzW/NVE6D6C+k/rHhJjFtbn93bXMfSFMToouMqUYyau71ri4hQgn3Su7VtLwCDuw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 23:53:30 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 23:53:30 +0000
Subject: Re: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210222132405.91369-1-hare@suse.de>
From:   michael.christie@oracle.com
Message-ID: <ef8fe68b-dcf0-6092-b51f-1ef79af61cc2@oracle.com>
Date:   Thu, 11 Mar 2021 17:53:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR2001CA0020.namprd20.prod.outlook.com
 (2603:10b6:4:16::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM5PR2001CA0020.namprd20.prod.outlook.com (2603:10b6:4:16::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 23:53:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59b95273-80e0-457f-5b02-08d8e4e8deb0
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52549AF1C3B11473A21E242AF1909@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h193kdy3IVynjBXE00rxqChr358dVpSoFzC4tyZL0+LGIi2uSOvujsnNlAdnBihyLGd2qAttz3M5HasL3aGDXWox22Ew83VTdKF5my6gsHAwroa+1L6WaXxyoWLcI3kEm/QgBMu4wIgkdBgOT26kTmoMYI57KbWtG1lYCLNoxPqZPSJkwyvsb6x65I/o2oFWW9sRgTQNzzx50YPZpVggrwYiLi93uGgSSsBUtUD4bXMAsLMF6b3X17jActg80uFBdOT0sKB9+AgK0thBx5Z8iiAO33Wxr4iMG86F0pSz0UN/C37g2PVANbYnF4ru261AoTCEizKgVlSyDG0gI0gT4eHpfNN9zgKRUfNhrztwkAkPFkHe+cluuOVE4lup9fkaUEtx6m1UXIN7J/6s85lUmu1PYEAZthaaJKVcTLPX+VQycYd0Bow+4XZs3dSS1Fjd8jJN7Tcv6mfr/RTxC937SgDj+oXastYcVwfxGSHjnTeCnTgex4b1HvB7ibobqkKJxAxjhuFVtfemJZOTW9C967ZQWaAgNbBTg2D24YpE5izQXtB5CEnibIzdOkYmYxg/ottZ6rwx+L6VlFxf567RgRM8aAINUTfZeAkAJqIUKWw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(396003)(376002)(31686004)(2616005)(4326008)(6486002)(66556008)(2906002)(9686003)(956004)(83380400001)(478600001)(54906003)(36756003)(8936002)(31696002)(6706004)(66946007)(5660300002)(316002)(8676002)(16526019)(110136005)(16576012)(53546011)(86362001)(66476007)(186003)(26005)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TE1XRWMyc0JNazBHY2dxSzNsV3F3SWFPdWFtV2xqZVN6VklFZlNjOXNURlU3?=
 =?utf-8?B?WG45dmZ0Q1BjYVNGYlhtQzRydk8rNzJ4UUkrdU5oVmxNWktPZkRNL0tac2pQ?=
 =?utf-8?B?UjkwcVI3VndYc29kWUplUjhHRFZXWWcvSXh6MGk0L1QrNks5aUxKZ1Btd3A2?=
 =?utf-8?B?aFJHeEs3ajFCSHNncm5vUG5hYU10N0lGWnY3U2pnNlRpcnJxNmx5TzhGbTlw?=
 =?utf-8?B?TVEwYytobGZ0VGIvQWxjWEdHUTZJYks0Wmpmdzl3T1QyRXdlME5uUS91OWtV?=
 =?utf-8?B?NCtMNy9tZ3dUMWVjRStRVHNaQjFHTnp5d3JZUFZSYmZwQ3lVVDhWeU5UZlBh?=
 =?utf-8?B?UmM2ZXB1QmkrSDRLbzJLMmlaOVBkRVJZS3RGeXV0NC9XdUM1eUlNRjVZZy9L?=
 =?utf-8?B?MTJxb2ZZY0piWTBMMzV5SU5KdlBnNCtKbEhneFRzcFBoZ2JRbFRVUWdjMXB3?=
 =?utf-8?B?NjRzSnVrVkc1czh0Q0dvczF5dFZIOVc3UmR5MldIWjFydGk3cFRqdGhLMXVV?=
 =?utf-8?B?VmFGZGRlK0hwQkdnaGRnMy9SdFd3Z0EyK1lmSFZzQTMwTXZ2SEgyRmhxanJs?=
 =?utf-8?B?aDBHVzJrTktLandtMnRJVWR2KzlwaW5sUUZUNi9lZ2VZcHpCamoxQjB6SFR2?=
 =?utf-8?B?RFAyUzVwbmhJY2V1SVYzUzBCanQrTEV5N2hkd2lRYmF2QUxWYmpWdUdmWWxo?=
 =?utf-8?B?cHNXVXN4em5Sa3p6Z2JrU285M2tzSTJWYnZKMTlGYUpYSjMrRFlKK3B1RVV6?=
 =?utf-8?B?b1JrZzVoVlh6a1BuRjRabld4cFJhaVlhVW94VURtQlFwWm4vT0tMTFJJa2lu?=
 =?utf-8?B?cTE2Zk0xaDFWNDJVRThnNmU5TnZlQkhaOVB0UE93MW0zdGlHUVJTOHp1Um8r?=
 =?utf-8?B?MmI5M2x2ZEVWUkE0S1lxVyt1Umx0VlNVY003MVgxWWxVcVRSSzRCUnV1MWlY?=
 =?utf-8?B?akgreW5tSHJKaW9lVm1ueEhWZUMxQlhXZmJBNnF1NkZYOTZ3dE5oUEFRaVdo?=
 =?utf-8?B?SkF5djREQy9VREREbHV2d09tdWh6L2NPemJMVTh2ZGUzdk5VVE95T2lnTEM0?=
 =?utf-8?B?enF6K1VYREt2dFBycTA2aXY0bUJJQlFjWVBmYVlyZWRGcCtwMGdpUlBldFZy?=
 =?utf-8?B?d2ZvY0JFcFBYQU82VUVRWU1XVnAyRjhKemtjVUg5dm5FL3lsME9rd0NkYU9p?=
 =?utf-8?B?cEhIQ3RjY281U3ZYaUJHL0JreWptRjIxRlA0aXduTGNDcFBrelRKZnZ0VjFp?=
 =?utf-8?B?TFVFQ1JLekZQbzBsT0x6VFZqOTIyQU5RRXU5Yndlbk1ZcVdVbTAyS05FSTMw?=
 =?utf-8?B?c1hmTXJhTVNURStnS3FuTkg0OHV0R1NveURpWldYM2JzL2RRY1hxTSt5VVN6?=
 =?utf-8?B?NHpxSS9JNHEvUlQxWWFSNkRtSllnZVJDL1RHanBaV2tCUHlzcXRoSDFlT2RI?=
 =?utf-8?B?Z05BMnF2TXNoMnRxSzZ4WGx3dFdtS29tcnNiV1B4R3JWZW5jWXMvTVM0bTB4?=
 =?utf-8?B?dWxSTk9OTEVvaFZDZzJaK2c3ZFVXaXoxYy9xY3BOSEtpdlNqODBtQlJGbmhG?=
 =?utf-8?B?Yk9Qd0dhNjNXdlVVOWFqK2htRm5yMFpkM1B4MXZmTmVYSE90TjBianRuaFhT?=
 =?utf-8?B?Z2hsR3Q1YlJTNzBBbFpOYnhPa0trZHpnT09PVFpGdUdoNTZtWlVtSXhud2Ew?=
 =?utf-8?B?a3M0Ukd2QVgzSytXVkRXS2lBemowM2hId1FqMTBYa1FwV2Q0blMxZ3hzd2lo?=
 =?utf-8?Q?GegYsFhl1QxUTl+WJWK4y9DlUztoQDqV9SJXOuT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b95273-80e0-457f-5b02-08d8e4e8deb0
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 23:53:29.9736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8uNl96jP7bBZRZMqG5AMydsJ3QHIvVVCiqMuO9c/x3jMG3qa3hs2xAcWJ/mM8+Em/OejNKCEwK4zu+qbNUVFJLgJOZTEM0UF5gjqsGf7llA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110130
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/21 7:23 AM, Hannes Reinecke wrote:
> Hi all,
> 
> quite some drivers use internal commands for various purposes, most
> commonly sending TMFs or querying the HBA status.
> While these commands use the same submission mechanism than normal
> I/O commands, they will not be counted as outstanding commands,
> requiring those drivers to implement their own mechanism to figure
> out outstanding commands.
> The block layer already has the concept of 'reserved' tags for
> precisely this purpose, namely non-I/O tags which live off a separate
> tag pool. That guarantees that these commands can always be sent,
> and won't be influenced by tag starvation from the I/O tag pool.
> This patchset enables the use of reserved tags for the SCSI midlayer
> by allocating a virtual LUN for the HBA itself which just serves
> as a resource to allocate valid tags from.
> This removes quite some hacks which were required for some
> drivers (eg. fnic or snic), and allows the use of tagset
> iterators within the drivers.
> 

Hey Hannes,

I was trying to port some iscsi patches to this set. One question I had
is how to handle if my driver implements init_cmd_priv, and wants to use
the reserved cmds for a non scsi IO. My case I want to use them for cmds
like a iscsi nop/ping, device/target reset or login request.

There is no bit to way to tell if at init_cmd_priv time the cmd will be
for a reserved or non reserved cmd right? If not, I was wondering should
I do:

1. in libiscsi, allocate an array of size $reserved_cmds with non_scsi_cmds
structs. When I need to do a non scsi cmd do blk_mq_get_tag on the host's
tags to get a reserved tag then use that to lookup a struct in my array?

2. in libiscsi when I need to do a non scsi cmd do a scsi_get_internal_cmd.
At this time allocate the non_scsi_cmd struct parts.
