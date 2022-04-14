Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B37C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Apr 2022 18:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiDNSIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Apr 2022 14:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiDNSId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2022 14:08:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2134.outbound.protection.outlook.com [40.107.92.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11F5A147B;
        Thu, 14 Apr 2022 11:06:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2pj+mvnWsy/zoBzcH3Dj1QGyENB4husZ6Xjb9KbbU8M0KViR/GST1ve+IaZP/aJgOkULRgglx1yuK4A1cUdDtLB73yKEKc8v2doWBDKvYkHk4axmurAqoa44zOwmD+eMy0mV9i5/NAgidu9YAkIjP4I46ZeN17WszMyr0nQyODdxy+1wd82kj2hjXfRc+EPrLDuWgOb6VBxjQ2C8wZ/zCDpjqe2niTz+v2HlYSxuHkV1pcvpteMYmstY/2P4BmL3LoM5y/vv6nqteCd49f/YeJcVlxFQaSfqTlx+iGWlOzvqRq05y7hmczskVNExep9z+qjnOAwtkvBbtJlp3i39A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZjMHl5pmjwte/4Ci5bSQNV52Qh9MYXiYiEkzWW54xM=;
 b=f/Ehm2V0JB9HFAbTCkMe6fzgHQdmJNQKBjF+aW9FaRKNRyiowOevBBVsBHdX2rKZ5RSuxsKOjlxBJlTGBNsumAyO/N5c+jjjeWWLDQN6vdiM8Ip+BUeTKMoE7PVQ7YgGstX9yrTLAY9P/eUUSKB6o6iXQkAOY9xhU5SbbQcXDb0txYyTU6UNwYPgr90nySmWJACKFuUVSjyABEteIYvdBHjoF/RBer+EVGJvoIDosmrAuYckXAUG4rf6XjDw1ij0OXCUwzvJdhtwrvxcVAChD3k7zAvyOtnU7ZWzX03uXpywjxKQSYRYXolHe45dpeYENSckNZ7XcLoNyN6mR3soHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZjMHl5pmjwte/4Ci5bSQNV52Qh9MYXiYiEkzWW54xM=;
 b=jOVG+R8sXHicn4wx8wTvOYtpessdu3yVcIAaD6Ere8XoW1KnLbTKHAHq7Iawct0Rn9wfgVtVhrSSjQ2ZNJ+M8BZiN2JiIMgxn0ivgNSgsRbWaF6+B7Rh8Cp8odn5nalRxrmcoWj3ZiHF9HNfPrbD1nC2kUA0KRDBShb6IPGGVxyGFqXalkjGe/PoK7DsnqI8mZWANv8IBfw5bMFMti0kYlxT4VFTz5ZT1saZuNFJ5pCoT4hQtdg8OfmBPLF/Yfyv5Gf+oKABhWbtgaz0T7npJyI9QiIA1fRCWCzmmj32jH07PV/rdD58FPpv1gYqqOOUt6yijx0pmTq1JYzeiqLt1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 MW4PR01MB6434.prod.exchangelabs.com (2603:10b6:303:79::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.18; Thu, 14 Apr 2022 18:05:58 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com ([fe80::98bd:3eac:d0e:875])
 by PH0PR01MB6439.prod.exchangelabs.com ([fe80::98bd:3eac:d0e:875%6]) with
 mapi id 15.20.5144.029; Thu, 14 Apr 2022 18:05:58 +0000
Message-ID: <069b69ad-5aeb-5612-ae16-cb780ee067f9@cornelisnetworks.com>
Date:   Thu, 14 Apr 2022 14:05:54 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     mingzhe.zou@easystack.cn
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, michael.christie@oracle.com
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Subject: Problems removing ramdisk backed luns
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0025.namprd19.prod.outlook.com
 (2603:10b6:208:178::38) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7313928b-d412-4677-a1fb-08da1e416cf4
X-MS-TrafficTypeDiagnostic: MW4PR01MB6434:EE_
X-Microsoft-Antispam-PRVS: <MW4PR01MB64345BF0B8952CF4ADEBBDF7F4EF9@MW4PR01MB6434.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1k979XBTUG4KiNQyx7Eb+E7B31PJRG2mFCdPr2jRWUUTjgYeVKpjowVto/1BwUnr5mrdZILfi4z6RHTPi+0ndINSa8c7wVU7YPEuozjCP5wRAXSLPaVu3s/uH86T5xde6oA9A+7iu/bgYqM4Rgnz0drN0EAiI6BeUoE62NJyxYVHila2zZLnDsYNAvmxwXXgQCQu6DTG2VzD5H8lTghdXhPYp36KzhmRhEUfZoTQiP8jcXZ/niOmS85uwDWcjH3u9YcSyS3n5OLuDPTX+FDE1Puc+y5CMsa5bEOMKsE6Aat5gnUbPzWx1yRkAZAa3FOPT58gz1gqksainkoiBoT6HjAneE43pNT4fCEQkvDmktBj8Zhs+Bbnwp9kvSDA4m3pBOHwCtNjeiEYYxzXh4cn15R/vpoVdr1rrGFVpBE+5RJVsrrNLVrGkZUpF+2Znqn36Gl6pELiPAfiCyfi3e6eX+LWV7/iOLRy873wjNjFfj1oAHtI1pxcmMv0aOkqQSM2lUdte+upbB9RQwxV7nVM2zFgNBPzQj7NziMF4On/OwvbTjztMvl3Rfeq00Hciov4mUbUIs01pYA0+Sb8nfYt5n87/gdVePaGOcU2V5/M5PNXib6dUnvyHoNJyuROmOxacCpwAm7QIykWBK89uNTvZqLhBfGkb9625/8RyvIjDXXw+b32H3bfHIADtE8xGPAybVjt+hufhQVrdHve/kGMCJT8fdAdxVJ2de4BBlsvDzbyuKwV8m8uEpeb5gU1iwly
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(396003)(376002)(39840400004)(136003)(366004)(38350700002)(38100700002)(5660300002)(6916009)(316002)(508600001)(44832011)(6486002)(8676002)(66476007)(4326008)(66556008)(66946007)(8936002)(26005)(186003)(83380400001)(2616005)(6666004)(36756003)(52116002)(6506007)(2906002)(31696002)(31686004)(6512007)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azdwb1N0N0VVaXJsRDJIVXl6SCsvbG1TQWxMSTJDaVg2SXZsMFo1QkJuNFlH?=
 =?utf-8?B?UkVFZzZQbXBEQWNtQzI4YkdzQVZBM01PcE9QU0tiN3Nua3YvOFR0MlMwblQx?=
 =?utf-8?B?NitlNDQyeGhOU3BkT09HT2dxTEpPbnhtZnQwQ3NCdkxuMCtJWDVMNzZDSEw3?=
 =?utf-8?B?bExXUjlQYUJ5Wno5dWVpZS8wSEFSZ2VpMVdrSDdvaWE4VGR5Sk81amJKbEow?=
 =?utf-8?B?VkdpcGJ0MnJ5Z0RLajFzTzZ4VmZRNWxTaDJ0V1Y4TGhyRy9VLzdXdmNleDhS?=
 =?utf-8?B?eEFkampXYmhrZVU0UC9EbnZaU21tUzl1TC82TXg5WUV1a3duUjlraDE0Vkkx?=
 =?utf-8?B?ZWtTU25mQTl2RmhzYjc1Z1YrWGRKK2JWNzhETjlONllwazZkbE8xYVRrRm4r?=
 =?utf-8?B?eUZ5djZnK0doOUI1VjIwanAxT3FPbVRBSmxxR0dkUlJQeVRMNW5mcFRaVzVu?=
 =?utf-8?B?RFEvRyszODdERlE3NGk3eDBJZCtxeE4rTVlIMEdkUnkrUGhUOUcvM29YUkNo?=
 =?utf-8?B?WUoxdGVLQVZISXdkOUtNRjR2VGRTVlNqOW50R3h2ZmtQNzZ1Yk8xSCtIVzRz?=
 =?utf-8?B?K2swWlpZSGFzSWM5cjlVRWdmd2xQeUx3enc3c2pXWDVheVpWSjlNN0Q4d3dm?=
 =?utf-8?B?NWFIRXYyOHY2c2d3ZmlKQXlXNEF6N3MvZGFRMlYxdUp0Rm1OQkYvU2h2YUVV?=
 =?utf-8?B?aTVLU0dVWEEwNEhmMGNLK2tjdXV4K2tCN2Y0aU0wQ3dsMDh0Y1c0OFpEWktS?=
 =?utf-8?B?dnNrRnNBelFjeXlsOHRRN2RYQ3Nzc1FlTFNRVVdXZ2UxT1pBZWVPM2tpdkFa?=
 =?utf-8?B?ZVRiL3JtMWR1UUh4VEhwMU9QSWYwL2dvRG5MeElHQUtZQ01GU0s3YUxLdnVW?=
 =?utf-8?B?OS9paFNETFBWdVFTZnpMWEdpNGJuaUlPazZsSFZHRWtLL0F4NVFMTEZPZTUx?=
 =?utf-8?B?Rk1kd1pqN1FlNGh4bVMzcGkzVmtIU0lLd0V6OTBKbS9WeUFFWkdNcmplVUJj?=
 =?utf-8?B?ZytqdXVNek1oeEVxMFlEN3lZeTl1WnAyYUhsbnpSeVk3bkVacytQUkwzeFRz?=
 =?utf-8?B?di9tU2M1UWYrUTVPWDR2RGY4S2kvNFUzVndVSGRSUlFoaXBwWlA5ZXRvUm9S?=
 =?utf-8?B?enFDVnVlS29laE5SZGN6R0xMQ3BUV3Q0L0NnSzJBaURYaWN6NWs1dy9ZMGhz?=
 =?utf-8?B?QzRlaGRYVUFNSzZncFk5L3JOWE1kQlNPYUdWVlNqMTRFZ0tpV3BCQnZFTGti?=
 =?utf-8?B?VUU3YW5icUdpT014VTdnVklGMmdMZjM3RFVna1lhbTRiMVVSQmx2YmxmaG8r?=
 =?utf-8?B?RUI4cnBPMkk5SnRWKzZnbFM2eWFrN0VZVEwvNHY1UVBKcTZ5Y3hSSExHT2lI?=
 =?utf-8?B?RUJvQnFQb2FMOXhkZHhmcGtjM3FyTnZMQWhvVkI0Z2tnSE1xdjViVHhLbEN5?=
 =?utf-8?B?OXhxdEZSU1JnSDlPV25WMjhUK0grR2VtWklYZjB6aFhIZ3Z0ei9sU1hqeFd3?=
 =?utf-8?B?YW1SbDI0Z2NQSjRmVG1qZk8zajF0SDRWMmVMRkwwNzZKN0FWak9xRW00dzg5?=
 =?utf-8?B?VysrdzZ3M2VkRU0zeDVSNGZqR3Y1ZTFha1ozdzNrdnJ6VThoV2xWc2hTa21C?=
 =?utf-8?B?SWJSVFg0aG5rdkJ0NHNOWGVnQWI0QUZxVjVmNFVvWnp1VitsQkcyeHV6cjhZ?=
 =?utf-8?B?OUtWVlc1L3BENmhmTTdsL1VBYUE5VEJhdGpzbTQ0SzVmRGlUUEFlcHp4VFBG?=
 =?utf-8?B?ZE13SzdmSSs3RlBRaXZyZSthVlRsdEozbDhPN2MrNEFBTFBzWGF1ckJMUHlL?=
 =?utf-8?B?U0RheFN3UXIra28vU1VrajJBZ0lRaFBhRVhna0RDR2RGakhocWZzK1JWSHZB?=
 =?utf-8?B?RUc2VEtwNlBncWx5bGtsQ0VINlluM1pBNm9UV3ZNaHRmSVNnb0lreHl0NkZV?=
 =?utf-8?B?RzExckx6WmpnSFJEREdFUElqdnVvRkJ1SDV4V3Z0UGZzRGtFaW5ZUzY2TTVm?=
 =?utf-8?B?WDk3Y0tCRkE4UUxpUWFMSHR5VlFmeXJqaDJaUE84K2J6bDczSmo4dytqVTd1?=
 =?utf-8?B?MktNK2tENE5iZFFYTlpWUXhWQUFwS0ZOaDR2Nmh4d2hVRmZIRk9xRHQxbUVK?=
 =?utf-8?B?aXlPSVZJbS9PQXV4VW9rSlpaaHptWEl0QmV6RFFiQlpRaUxTczBIMkNLSmt0?=
 =?utf-8?B?UFFSQ2ZNMkhKZ0R3Wm9nb2s0Ny81ZFQrRHlPc2ZyUkxicjFXZ3FpMmQ5NmQ2?=
 =?utf-8?B?WXJyQmlqaGhBUVUyaDZJOTdYY2xwUWt4WHhMVG1zVW1KcEMwNFRMZ3NuZ1A5?=
 =?utf-8?B?a1lLZEh6VWpENHVDK1ZvcG5tMW1jYVc1OHpya2JkcEsxTEZkRGtoYnVvcCt2?=
 =?utf-8?Q?PhofcPUxONsZJQ8bK4xMfmGC/m4He/jdSYiKc?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7313928b-d412-4677-a1fb-08da1e416cf4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:05:57.7744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hh6eK3PwzV0yAzHOUlrlT1FvMaqnBfSotnuQEFdqx1AAjYMxKzp0nzFarHo+lUo5WqVzgkAvcwk23vjOaewXmPkA0iaxKMZRv5o0Ukzuypiuz+WpxCIGu0lKiwWpyjMj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6434
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Folks,

The commit:
d72d827f2f26 ("scsi: target: Add iscsi/cpus_allowed_list in configfs")

Seems to be causing problems when I try to delete ramdisk backed LUNSs. I
bisected the failure to this commit. Reverting restores functionality to 5.17
levels.

The error that I get is:
# targetcli /backstores/ramdisk delete iscsi_ib0_0
[Errno 20] Not a directory: '/sys/kernel/config/target/iscsi/cpus_allowed_list'

Looking through our automation looks like this is the gist of how things are setup:

targetcli /iscsi set global auto_add_default_portal=false
targetcli /iscsi create wwn=${wwn}
targetcli /iscsi/${wwn}/tpg1/portals create ${addr}

For each LUN:
targetcli /backstores/ramdisk create ${lun_prefix}_${x} ${lun_size}
targetcli /iscsi/${wwn}/tpg1/luns create /backstores/ramdisk/${lun_prefix}_${x}
targetcli /iscsi/${wwn}/tpg1 set attribute authentication=0 \
demo_mode_write_protect=0 generate_node_acls=1 cache_dynamic_acls=1

This all seems to work OK and it appears I can do I/O to the LUNs. Then when we
go to tear things down:

targetcli /iscsi delete ${wwn}
targetcli /backstores/ramdisk delete ${lun_prefix}_${lun} <-- ERROR

Any thoughts/ideas appreciated.

-Denny
