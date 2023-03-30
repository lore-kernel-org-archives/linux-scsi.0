Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBA2C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 07:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjC3H3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 03:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjC3H3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 03:29:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A28423A
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 00:29:13 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32U6So2Z026617;
        Thu, 30 Mar 2023 07:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vLjFJRJENk/rlmoywQNGvRyoFk79VmfeCTozrkv/I8E=;
 b=FpFGyOqI0oQ5latDB6UOHLxWgD7/KGInRztouhUocuEPClE/q3GKOfoCOsMX291sUdoK
 6aLlUZiHMSPXMV79VKDdcplzlNbgA7/RwBTvwSWO8MuAyfbuqj7VBm8OBWhSrNc8aFbm
 jLQlEH9VsN7I1Re9tDy21Je1NyRL1KI36hBo5Ek8N/Fj4c9gKa/p34/7IGvkTTGRn/E1
 0mhBsGqRT9rR290k2Ma3TGg9pgufPnpKL5VAkFn4GPSlKwG98q2viTqiaytJrAyrkfA4
 +GrEq/dgsgG/vgShFyDDiegwF2goX86SopM6+XrgHDswrGvecLggIkWugS/bqER3gEey Mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq799vpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 07:28:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32U7OtYH030067;
        Thu, 30 Mar 2023 07:28:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdfgq8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 07:28:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oqs8vG2x3GkDfbuyp1haHY2k00ABdQRYgESw6K6iECinHEFiLHCAaADKb4lsXvTHsjctOTqyISK4rS/n1WkXN/VFDTOA1wv/ArerQLkFkkT1zgTxBF6rxI21yHwRNLZAJMYseNq7bh4qebgTEt+pAJ4Sik3yPNVOAF3zuWUJgTbs7JmuLtOxEqO90BVgnZGiOTJENadu0R4Vu+ZpG6d//gtAmMsnGqbu6rR8V5jqQL8GqxgC6hiY2VmpCyUgZA7EiyD3a5xFtWTT9hW0hmrV6tvVn4zh8AkVnkEEE8apDnbftp/MAqhFFr2dQDhHPk6umYq4ODfVrYU6aIGMvyRskQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLjFJRJENk/rlmoywQNGvRyoFk79VmfeCTozrkv/I8E=;
 b=iiECa1ZqWuYTbEySJVmILia3olAPymOzWiB70yKL8Cl5E1ow7LVbTiO0ywJbEtg2Kx3C0Fx4NA8N+KoDNs1Za612kIEAk/Csxt2t7OeqY8m5bltjHkg4CwFFyf8SBi4jlUog3RJ2CNrMnk697wo4/UpCutIH/Zsfk+IE4/jV5bi5Uj/plusYALloJkOgVzg30Ur0mwotsmjJ8+90M7NRDZ6U1xrMf6VkVRlRVs/XAwG9pAH6ninvQOdkbRgw/az1nk2UJ5w7WJWytfyXwFc2F2x3LGTJxQp37CFqPavP7Wyx2HGZgMeK6pyoBmuZEr108zgbNEXDCEyfId2fs7UyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLjFJRJENk/rlmoywQNGvRyoFk79VmfeCTozrkv/I8E=;
 b=PoPr9KNFdgktAD8klwr0L8G2cpzSbvD/8ZeNxiUy+Hi0Sx1xkL65vO7QdQZwHfftp5o3p/u+SExUYsTxUO0DiPbt44HubNOzPBr9KZZUeeqXg/uBJw1PupBeR1JFpOiQMO5Qilm4Z0I+HKust3/Uu2kRYs1wMF5yvOwutibzSwg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB7426.namprd10.prod.outlook.com (2603:10b6:8:183::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 07:28:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%5]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 07:28:49 +0000
Message-ID: <038dd7fa-e933-ce00-aa90-af30508af0fa@oracle.com>
Date:   Thu, 30 Mar 2023 08:28:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2] scsi: libsas: abort all inflight requests when device
 is gone
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com,
        Xingui Yang <yangxingui@huawei.com>
References: <20230329124357.3746533-1-yanaijie@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230329124357.3746533-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0382.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f15acab-3367-4305-47a9-08db30f0676b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0v6iHDkP+PNgpMxUuIXAPZRglCLCUCl8v/ZveNWBON+NdcV7CQO8enql1Eq0X8bZ15W0rAv0Lz/gwoN/WANkQ9W+/5i0UeoWBlKSbFB1YA2df4xM76oEIUMaf1L0vGHOZiMTS9G3EpaSVunSH4s1HKz7ApapIvGfOQSPHlN/Pao+XdXFbFOmS79Ey9LePXlXgkMjgJU6Muj5SvVqFHv7O0vQFUeAqVghlb48cGwwoQdF8pL74v7otOA1LWFfddK7/4pW4Tma5fyQkKnrvyXxBEmUVUMNhTQTMzD9UWBCPv4HlKtCdMUMWMfbmw4gyeijJwLzHeKf5rui13JbFnS0wvxjo9S1EGa7uzL7PL1lKl10QeEANsI5/OB4LOX51SQuiHh7webW3ye2LhYNanI5peqdlsxUR/SWE0WmwTkq7Tz7Lc9We6SKI3X3sN2pSLQERuc1/axWPpiKLz6IYjBUMQ0wpM0Pv7YI0VoivnSSdea9STYKwXeiwF6OOXvLnW4yor16oYVn5iBDhahwDv5bze6exTvBo/IHW/ty+0mHAINRmdsEGTSTg2yzCecQbYHXz/H2CcW/ZYuXmudzgs5USk4YYWduCe8SNY8EM87kkVgh4v0U8xPYUtyXxVIsy4lltj6akiD0XoDS0b8FmmEHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199021)(36916002)(4326008)(41300700001)(316002)(8676002)(66556008)(478600001)(66476007)(38100700002)(66946007)(53546011)(83380400001)(186003)(2616005)(5660300002)(31696002)(36756003)(86362001)(31686004)(966005)(6486002)(2906002)(6666004)(26005)(6512007)(6506007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUhXSjNoMmRwUXdnMzIwRHJQcW9IdDUrODM3VE9VbnVmWXlOVVJMNlNKZVNh?=
 =?utf-8?B?QlJFbkJRQ2QzT1B5bU12dStRSDllakx3NWk3M1VQQ2ZEM3prTkgxUGZML2Fr?=
 =?utf-8?B?QXFxREg0NklRbXgrSUh6VVdkQTdIVU53ZzNiWm1sZ3RoWENkSlJKY1BndWtS?=
 =?utf-8?B?b0FMQ3F6bi8xMTJYeS83V2RpK1owZDdDbFNZVXJLZVdETEVja1BkM053bDg1?=
 =?utf-8?B?MmNWdTJRR05ETTd1aFNCTlFZeHNpTlMvQXpuR1JJVmpxcTZLaWRNQlJTL2dP?=
 =?utf-8?B?amFRTEgyNDN0MjNINWVIb3BPRXdQQjVqLy9ZZi9MWHJzRVMxWlYrME5INVNV?=
 =?utf-8?B?VnF0cXArbUc4dFhsTTFMWXBsUGNKYUZpOXk5QzBTVGg5akUydjFuT1ZHQ0Fm?=
 =?utf-8?B?UWdMWEVzOWMxREswRUFiN2kreFdOSWtMdE9LbGkyMDVnM2hXaVJvNUJuaFdK?=
 =?utf-8?B?SGs3MVc1WDZiTTFGTklzZ1ZvQ0lhSWgxMDBHVjh6MGxkTXdHbnRFL2FvS00r?=
 =?utf-8?B?Sm9GeElmMzdtN1VqVGV2SDMxOHZDSUFWUno3ZnNMVEgvTmpZdTJFTHd3Mmtw?=
 =?utf-8?B?Yk9YOU4rZUVRTWFCUWd6cXJEcWNTZ3NLaHNJbTVycjgxUTZSeWFFeUw0dlpU?=
 =?utf-8?B?Nkd1MGdLNkg5WlJvaVNIK0dWU0NNZEZIczRvV1UrSUxQeSthS2tVcHpiRFFM?=
 =?utf-8?B?d0IwSlU2NHplWjdsdlVwMGgreEV1NHhPaXhBS1VIZzNlcmJKTjNuVEF5TFNE?=
 =?utf-8?B?U2UrZUVOZXNPWTJuS29UM3JtY2VJcUZGUnBtcnZ4ODBkM1ZvV1l4T1gvcERo?=
 =?utf-8?B?NjBxeVlxNGpacjZkS1FPWjdKYmhiamt3RjVQbCtwVVJHajhTRmQwaVM1aURu?=
 =?utf-8?B?SVg1c1F3UEFFSFVTdWRsc1NtbUtCMUZSM1ovY0xpMmU4eEtsVkVOUlFocDZM?=
 =?utf-8?B?MkVVeTZFUDc3ZzBLdzdMYzl3b09IdDdmNEg3bEZyb1JIVzlBcHJRL3kyckVD?=
 =?utf-8?B?VVpSVlVKVUlJK2RyVWNmVDlwQ2pLWXhyS2greFFJL2NzQjFuM3dSSWM0Rlc2?=
 =?utf-8?B?andXekZ6a3QzRU5mQml4YVNBRUJLK2lyUUNsR3ZqZy9JTTFySDkxZUdFVWd2?=
 =?utf-8?B?R0JCYytzMWpIWGk2N0VWVlJNSkZLb29QV05HR2UvSWhJK25yUHhacUJoNi95?=
 =?utf-8?B?cFZZS010THZkOW52d3J0bmZ1NnlxKytBK3kyVkk2UDVEOVB6clVrVVlaVldq?=
 =?utf-8?B?WHZzNG5Gd2lSVVV2Tmx1V01EZVhJUzY1T0EvQ05nM0tpYmo0TTlsdFo0aG9C?=
 =?utf-8?B?bDU4T2tyZnhOTjJyY216b1M5TnRXb2swZHhia0p2cnhsRDFOZTZOYWpURWkr?=
 =?utf-8?B?THlIcmtrUGhINWVrTDd4NGpGd0JMYUttYjlsMXF5dU5Jem1OVFVrUHpDczN5?=
 =?utf-8?B?eEVXZ0E1ckZZa1ZFNGdFcnBXd2tzNFpjOTRMQ21rK3JZYU1oRU1lZ05OT0Fx?=
 =?utf-8?B?YUtXb0xEemxicW1aRmZhOVRSS09UbzZwOXBUamNjb05QazBYVk51aWZvNmNJ?=
 =?utf-8?B?YzBpZlJRRFI5Zm43SlNWZDA3d2g5UmVsbWVYd2M2c2RnQkcvRDVQZmUzOW5F?=
 =?utf-8?B?TDBJK2pUTU1TWWVwdThObXdvSE5mNXllQnhOU0Q3V0FvOVM3UkFJdWFyZytt?=
 =?utf-8?B?MkZVZ1p0M3dVQ3BwdTlXVGQzdmg1a0tvV1IwYWVjZEgwZk5FbWEreVI3QTkw?=
 =?utf-8?B?c2M2eGhlbFVUdWs5ems4VDc2aUpaWXdSSHNkR29kTldBZGhvVEVnTW5HMGw0?=
 =?utf-8?B?aDZFQ1I5d1RadC9xRDd4ZTBORW5heS94N1VZWldVSVBFb1lWQzBUWURXU29n?=
 =?utf-8?B?R3JwMHZwalBLV0h4b0h2RGxuKzR0WnhvRHZpTHF5VnE2Q1NsNUZhNUFXdGhm?=
 =?utf-8?B?akZRWjV5eGdpY2pURHpIMWl6V2x2WC9HaWlrajVGQzA1VEVjMlJCMEN6amFp?=
 =?utf-8?B?ZjZ1STlONUo3dUQyZjNCQzRMcnRUbFNCVnZyNmFyUWdYRExOVWxtN1RDRkJZ?=
 =?utf-8?B?aDZFYS8yTHB1R3RTeWQyS3hVT3kvZXNkWmcwcWREcFRlaVNzbUV2cHNINDFM?=
 =?utf-8?Q?1HNni1TXhfMPyd1ipJni/PRM0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MW1ZZTFNc0lHbW10bmRrOUY2Z0xLRGhuZVZBdjJLaVJnUUVHU29vZmcrZHR1?=
 =?utf-8?B?dGJ6SjQ1M0hjbGVBa3ZZREhnT0p6S2pjUmVNbW1wNWRROVpzZ004VysxUTVL?=
 =?utf-8?B?OUJtVjJpR3p1SUdxeW4zTUN3ZFdEL3BmeUJyMUliL3htL29ZK0JWcE92cTVK?=
 =?utf-8?B?QUJ4VlNnWVNHaDJ0MkRZSGd4OHo3dEZjK3VoemhhTitQaklQVXNRdzhLNmlx?=
 =?utf-8?B?L1NkRExvRU4wMTBPQXFENUV1NW9sVXZLZ1Z3N2ZtYjV2QWFsVHY2MnRPRE5o?=
 =?utf-8?B?cmMzMzBEQlU0WVdRL1Z5TTFIb1BCTjhuVXI3T1ZtWFdBTTJsYXBvNmRGMm9v?=
 =?utf-8?B?RVNyeHMyL2hnNXpkT25NQjk0UGVzbFBlU3FyNEVDN3J0MUNvbGFsWWxPQVJL?=
 =?utf-8?B?Qkl3QW0wSWNoKytkN25UVWMycTlDZGREeDhJalVuZUZqVjkvWGxoZmtIWmp6?=
 =?utf-8?B?dTVKMmFjSTJnT1hjK3oxT3BaTDh6TW9lM3Z2MUVNS3h1czcxbzV1bE9Yckhs?=
 =?utf-8?B?allnM01Ea0NNdjlTakNVak9kRlZySFIxNnY1enRBZXIyejlNblI0aW5oWGV0?=
 =?utf-8?B?S3NxYXk5UmNIRHFQZWNXUWdPMVhtbFpOVnZzSnlkQUlhS21ZQkluVVpDQjFB?=
 =?utf-8?B?QjR0V3dBUUZPRE02RW0xQS90MmhRbitYV3dRZ09pT2RQdFlCZ1RDTitvWWk3?=
 =?utf-8?B?TzJPVDlBMjVyd2dMU0hPaDZNM1N3RUtxWE1zZ1NKQit2K0NuNW1Kb1YxeFVq?=
 =?utf-8?B?VUhxUmNscE9lSERLbkx2SWFsRHZLdFczSzBmQ0dYUU1VT0NxL0lIS01Sbm9z?=
 =?utf-8?B?L1VoRTFkK010MVlMYzVnWExlVXordmx4N0NmcForUlRtZEZUZmhHMEllTERY?=
 =?utf-8?B?Y2Z6T1I4M3NmRHhuRFdGQUpuWkF3VDRBdWFnU2cvY3Fzb0xHSmpiTWJUdVFz?=
 =?utf-8?B?UWIzZlErUmFjR3FvYXdBOXBOSkV6UHZ2enI4ZDBuZ2RwSHhWcU8zZEZpUFYv?=
 =?utf-8?B?VWZFRGhnYk5ycmxQdCtKK3NmV2QwZ2x2Yzl6Rk5lSDAvUlJ3bXNBMkQxV2NX?=
 =?utf-8?B?ckVLZENKL3NQcTRKRUgxcHdUMlVsZnJHQWpwdWdyZW1sbXUrSkRtcmJYQ21y?=
 =?utf-8?B?ZmZsVFlBVWxmcXpVMzhtL0xFWnpudjZUNklkNERNUjdxNzRLWjRsdTRvU3NR?=
 =?utf-8?B?M0t4MHo2c1Q5QlBFdDRKRmprWkF6SWI4em5sZ1ZPRTRLUkIyc3RBak9kalhq?=
 =?utf-8?B?aTlvVm9hUDluV0lPKzVDUmRmZ1FxcXRSaUJla1lSYys4bCtnaTZCejVvalBG?=
 =?utf-8?Q?mYnh3MrNdiXDU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f15acab-3367-4305-47a9-08db30f0676b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 07:28:49.0696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OfR1Ad1IfWnXhX1404DvozMU6qK7MPcJ3w6dtfxfcbIj70nB0JQ2jyrPMdvI1JmjVCGKkQm7DQ9/XSF9hHNQqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7426
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_03,2023-03-30_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300059
X-Proofpoint-ORIG-GUID: BCpvKc-hflsZZdCdd9HZmODGXipvG4zn
X-Proofpoint-GUID: BCpvKc-hflsZZdCdd9HZmODGXipvG4zn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/03/2023 13:43, Jason Yan wrote:
> When a disk is removed with inflight IO, the userspace application need
> to wait for 30 senconds(depends on the timeout configuration) to getback

I think that you mean "get back", but this is not really clear in 
meaning. As below, everything the kernel does affects userspace in a 
way, so I don't think that we need to explicitly mention userspace.

> from the kernel. Xingui tried to fix this issue by aborting the ata link

/s/ata/ATA/

> for SATA devices[1]. However this approach left the SAS devices unresolved.
> 
> This patch try to fix this issue by aborting all inflight requests while
> the device is gone. This is implemented by itering the tagset.
> 
> [1] https://urldefense.com/v3/__https://lore.kernel.org/lkml/234e04db-7539-07e4-a6b8-c6b05f78193d@opensource.wdc.com/T/__;!!ACWV5N9M2RV99hQ!NCSE1y-PvbYiLiO35roetxUhmyG3r2_H86b8XasnaSrb0WuZvfhRDTHnwmn6tKYyV774bzF31KYhlZbzsWry$
> 
> Cc: Xingui Yang <yangxingui@huawei.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Apart from comments on documentation,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> 
>   v1->v2:
>     1. Rename sas_abort_domain_cmds() to sas_abort_device_scsi_cmds().
>     2. Don't do the aborting for expanders and for devices not completely initialinzed.
>     3. Add a comment to explain why we need to abort these commands.
> 
>   drivers/scsi/libsas/sas_discover.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 72fdb2e5d047..8c6afe724944 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -360,6 +360,33 @@ static void sas_destruct_ports(struct asd_sas_port *port)
>   	}
>   }
>   
> +static bool sas_abort_cmd(struct request *req, void *data)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +	struct domain_device *dev = data;
> +
> +	if (dev == cmd_to_domain_dev(cmd))
> +		blk_abort_request(req);
> +	return true;
> +}
> +
> +static void sas_abort_device_scsi_cmds(struct domain_device *dev)
> +{
> +	struct sas_ha_struct *sas_ha = dev->port->ha;
> +	struct Scsi_Host *shost = sas_ha->core.shost;
> +
> +	if (dev_is_expander(dev->dev_type))
> +		return;
> +
> +	/*
> +	 * For removed device with active IOs, the user space applications have
> +	 * to spend very long time waiting for the timeout.

I don't think that you need to mention userspace at all. Just mention 
that we want to accelerate the removal process by starting EH early.

* This is not
> +	 * necessary because a removed device will not return the IOs.
> +	 * Abort the inflight IOs here so that EH can be quickly kicked in.
> +	 */
> +	blk_mq_tagset_busy_iter(&shost->tag_set, sas_abort_cmd, dev);
> +}
> +
>   void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
>   {
>   	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
> @@ -372,6 +399,8 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
>   	}
>   
>   	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
> +		if (test_bit(SAS_DEV_GONE, &dev->state))
> +			sas_abort_device_scsi_cmds(dev);
>   		sas_rphy_unlink(dev->rphy);
>   		list_move_tail(&dev->disco_list_node, &port->destroy_list);
>   	}

