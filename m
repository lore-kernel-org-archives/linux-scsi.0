Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C76C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 08:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbjDYI3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 04:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbjDYI3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 04:29:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C277949FA
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 01:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682411341; x=1713947341;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=l30n2Seg61NAz7t2cnfx2VFIhcR2Qm7Oe2Y3rxqK6mQ=;
  b=hAEIuofirhwep7+RHLDnIztLslHBe1iqWY93e4ZaSR0UW+I2JgcElb8d
   /sO40fRGLiV4era2OHnnvNgFg6S/aXasHm6V6eduiHAktSShD5UR3Jedd
   e7CvI6WJV+CYWOY4cMKOMXWALdEbQ44J2qJ8RHX7AhEU1bI7wYrI3TcFh
   hsJUO23t+X+isyCkbQKwEZJKgOVqof8BkpE6aghWBSVKN2DeZWDhpEMf/
   cT770TvDsTph7L/mqzCGKM/JWYVYlLwk4r/xdpih4/Q+2J57Bz0K6j81q
   i1JZsk81E/MX1dF3bMNYtlqbdPd2zEkE8/U71Jgh95eYb3Vf5lGgcUA8g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="327007292"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="xz'341?scan'341,208,341";a="327007292"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 01:28:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="723930744"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="xz'341?scan'341,208,341";a="723930744"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2023 01:28:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 01:28:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 01:28:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 01:28:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 01:28:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2eD5nqXbSGMVv2aTLf/f75ef50ie4pmOYe4D1sRE8MYnW6zjwTmxv3st3sA9stTQiRjRhN12yD3JcI+Um9wld/cpd2lswNLb1lsiOAPM43LZgyhR4wlXxydTZhPYJ4RqgyhAj7EvO8tINaW3HWPlfY+j85j0VVYScyo/fe4ZJY7LzYkpOh+l9dgBh14c6YbtUyK01ssi+4pwAUFjNX6sQwxyogXs3v94wEzjTAOcg0h7DRKymmv0q1p7g1m7VIv6l2n0iNiaFETxS3VT+q8/mbtQL3iZimhmGqktq8pTzA6igNTZlD+0m04TQ/Fy/Fx8U6T4UpJOvK+1USd4UfB8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ER8h1JdFwM+K6r2nYOWyUHy5oeKw1jcqS+RN1ciXqRE=;
 b=O73kfxskHuac4yArMenLuNSiDXKLgWWEso7AKnnksdxxbBJUyFvQYJsnHzfMG7RFOw3Ir/CvVV50IHkMaJ/jlM3XYzUNsM3Sz4C1wKLvEeAF20EJRLHKR49Taw8wpjYTyx4E27/Q4oFvMFppZCMbtnY/ELo8nBgyMMqGhZ9/1Kq7ViHwVpOcwNdX8ov5/6cM8TMLCkv6ltLFcVSpWAYS5xAFZSHzr4SKH/tR00lNFd/pVH+olhqp/uYsRy9Ozy/r9A3ikweuCdArtEtkKZNZl4P/ouFp5ujtC3IZu3O//xHaEkrDccNkXDw9KAz17U90flumRJvydyv52CjT3YArIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by PH0PR11MB7470.namprd11.prod.outlook.com (2603:10b6:510:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 08:28:50 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf%6]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 08:28:49 +0000
Date:   Tue, 25 Apr 2023 16:28:39 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Tejun Heo <tj@kernel.org>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>,
        <oliver.sang@intel.com>
Subject: [tj-wq:ordered-cleanup] [scsi]  25aa2ad5c3:
 WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register
Message-ID: <202304251456.d77841dd-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="xJgqUhhEbMFOTMjC"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SG2PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:3:18::19) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|PH0PR11MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: d85d2e92-8165-4ba4-215d-08db4567179f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QY/t7/5Upvvp2A/Uvv+xekJHSKLsu61ssIXpBbq5nhfciBcsMm7wPzurzxAcg0AchTo7p/PZcX4vaMlDLJOSc2+FVisC+8qyych9htD8ylU7Mml0bg5+/QqWTEnMPRq8QQK2HBw0JG6uoZQ6S5lUyssdDOq5BAq6r2T4S5s4FB6fT9m4QRqiYRDPo+nRO2vpteOwGxZLZ3RCPvGOc0SbczuEKP1cDfQUMEt6oGEClVhcOKaBIEVaIAMZQtP8sQ4jpap6GwzciU+5C5qBKXzFnXqRb/oCJADOxYQRTOminKck5GryjsNcWlpsJeHsO9AB6p9SJwBX285DHaO60cBJeOfxuGJKaOpXS0atr4AOa216rxurDzaeVm/1KfGDCPOzR2HuEyzKcO2N/IwN183mzbevdNQYoPcP84s+l9iY4sOTdTwzOZ94T8LfGK+O+ST1MIVqyaLZhmiUnPeaNseDIY5LyZOuoU6JQoJwRY2iq28mNddLiCFZHy9+ejiKbRxju+Cagy0K4HcSwZO917UWHRl0Wa74m41wEIRgAYLxTGLuslM9oHXYufInX/PzRufEbAlO16N1DdMgNtJwJIStFlE4kWTGTVliqNtcxaszkV1I7rmY4Kuly1MNPKitbpAgdtL8jBrZ/uIHfUVlnrfnbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199021)(36756003)(8676002)(8936002)(54906003)(45080400002)(478600001)(66476007)(66556008)(6916009)(66946007)(4326008)(82960400001)(316002)(41300700001)(30864003)(2906002)(38100700002)(235185007)(5660300002)(2616005)(86362001)(186003)(966005)(26005)(6506007)(6512007)(1076003)(107886003)(44144004)(6486002)(6666004)(83380400001)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g48lFzrsK32tcn9gk5Avssi26oyIKtr7Tiple+An5dZXvYvS2HcULjwq5FmW?=
 =?us-ascii?Q?ZLw2/TfZs3O9l10WsK2oFRFOI7YURr0hJ4lbfjFtGYKu+wpI+33Zh42+64Gy?=
 =?us-ascii?Q?yzofx5FoEZR39g/wY9/Ta8/Ac6eIo1VPK3KHKVKdgNlE78IjVpsBssVLZH4I?=
 =?us-ascii?Q?yR8R4d3xIuq2Ghxs1ZewpzhAFNmDA7V93uu1tL1lh3G7kRKbNJI0UpesTwON?=
 =?us-ascii?Q?A0gNjs2lZDMvMpzV/uAqa0jDFgR3LsVrEa3UWu6WkKrB2feR5Pz/dk1UAFbp?=
 =?us-ascii?Q?UFbIsZOiwD1CU8r+QNF2rFuALPhQQmH7fuLhNRUXsCsZb36wKbDJ1+X72fDs?=
 =?us-ascii?Q?PkU5koaO5d6wK69AkALSTfY6uffYSgG3YiiY3P0nZ7grYgaP44C4klkRuWtf?=
 =?us-ascii?Q?B4lSpKCqH+4ggitoIHCu+ULjPF2q2oFPPC6B+KXMNIKKA5JXoZlVhWDfe31c?=
 =?us-ascii?Q?SVWLPV3DzkEMYsqUcF5Xz4JVJo0DugsncLmxGMRlTg+8bdYfaHkk6u5Kg/B+?=
 =?us-ascii?Q?qzur9xCPgS+p2gyxMvRVaZRcCM3P/C2KJt4pR4W3KyOdgVSYxq/cCWMpVg4/?=
 =?us-ascii?Q?IXXPmXTXWSmfg9yq89UDwx3Z7XMiehg2F5y2BNfY+WJ5BSvAP65wUvrz1nN9?=
 =?us-ascii?Q?rFVwq9sJS7jTufuTYe7iKwOS6AoQUtwXTNWlE1re0dsWuG59n/wAi4wYY/+a?=
 =?us-ascii?Q?PFRvGHxQ2Rny9zuo769cre8Dkb5Gq6a3amM/LAm3W2WcINcF0Hi1fUls6cUn?=
 =?us-ascii?Q?DsFI6uIrzdq6Pl57MnsB+7m+EDSmtOSUSuMe1f6laNoai2figIM742C9rJbi?=
 =?us-ascii?Q?GZHoRPqWYpaVxfUuyHxveCm35MQ0T8kXB/l/lOsFoozejhJz6f9tdFNA+5yG?=
 =?us-ascii?Q?a3sos0ooMSpYjbHyEbTECP2XhZ8W7cawXqmU1I2UwnAcVDkqNtwwBWtJrhcz?=
 =?us-ascii?Q?ZHJENPuRp6JR1DdOTZRovthSQXPSKq/fAc5BQ9VJm3aXS1Drk8STeFsMu46L?=
 =?us-ascii?Q?7tkK5/8bZvFo2F40sH0Zd6rhLfHva8UV6jfXz849rIoTsk7NDmJKJ2UaG9qu?=
 =?us-ascii?Q?Hip/o3yAWXZLyAKoAiRb8TCeLz3WeyL1G08A0wW7zSA7g5iGpnLkS/lxzU8u?=
 =?us-ascii?Q?dcs5TLoeMn/2zBARBKmf3r4lN1xroxuEWgQ7TPHUbE2u/kQY2WQvwlzuVR0M?=
 =?us-ascii?Q?uvTLxoFNNJG7wQZKNYt4SeqWnzCHbXYsQEIh3BHmub56tIgaH9lLIPG+Dvwr?=
 =?us-ascii?Q?OcJ5iZzyFwTcdJ6VTIFDbeiUhRPwqyY+nSwUATIkeU/jC896LHYdZqlVioGO?=
 =?us-ascii?Q?nEsicoVESsaLrjuo/bAGGX6DBJ9lcfdMWwFWqievzVl0phRpaT/mI+HKBaBW?=
 =?us-ascii?Q?YMaNyjElhCo64xhtF+NP5jHkPRp9otnyAACCVo4Rl+FzZSsKjEdOjAARc0C7?=
 =?us-ascii?Q?hPSplDHpvRQ2UPbefi3yi5vvMWX9nZ4Z46uv4BYDtk8sCiHCqJkQgD+t+MlO?=
 =?us-ascii?Q?2oXh2IFtXO6MudMkvw81kUY2QLmnox7HRZTnIDl4v2MG7JxlTuWdLJIbqPZX?=
 =?us-ascii?Q?lC3gPjeAIiEwC1JE44dN4MvjaHOEJtETONodh+luNmMevw84DCDrN6p319gD?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d85d2e92-8165-4ba4-215d-08db4567179f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 08:28:49.0949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10RwT7sqYRHOIPJZ9g13AIdpqogdIf4/ttXYFVmpcmCXxbW5+iMw9z77fk6KGiWUIIaFhQ2t2jb4T5C9sQ7vWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7470
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--xJgqUhhEbMFOTMjC
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline



Hello,

kernel test robot noticed "WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register" on:

commit: 25aa2ad5c302824d6ff271e4b0030ac92cb99a69 ("scsi: Use alloc_ordered_workqueue() to create ordered workqueues")
https://git.kernel.org/cgit/linux/kernel/git/tj/wq.git ordered-cleanup

in testcase: boot

compiler: clang-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Link: https://lore.kernel.org/oe-lkp/202304251456.d77841dd-oliver.sang@intel.com


[   53.193336][   T14] ------------[ cut here ]------------
[ 53.194297][ T14] WARNING: CPU: 0 PID: 14 at kernel/workqueue.c:5871 workqueue_sysfs_register (??:?) 
[   53.195680][   T14] Modules linked in:
[   53.196286][   T14] CPU: 0 PID: 14 Comm: kworker/0:1 Not tainted 6.3.0-rc7-00151-g25aa2ad5c302 #1
[   53.197580][   T14] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[   53.199096][   T14] Workqueue: events work_for_cpu_fn
[ 53.199844][ T14] RIP: 0010:workqueue_sysfs_register (??:?) 
[ 53.200811][ T14] Code: e8 a6 02 48 b8 00 00 00 00 00 fc ff df 41 80 3c 06 00 48 8b 5c 24 10 0f 84 ff fe ff ff 48 89 df e8 4b e8 4e 00 e9 f2 fe ff ff <0f> 0b 41 bd ea ff ff ff eb b0 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c
All code
========
   0:	e8 a6 02 48 b8       	callq  0xffffffffb84802ab
   5:	00 00                	add    %al,(%rax)
   7:	00 00                	add    %al,(%rax)
   9:	00 fc                	add    %bh,%ah
   b:	ff                   	(bad)  
   c:	df 41 80             	filds  -0x80(%rcx)
   f:	3c 06                	cmp    $0x6,%al
  11:	00 48 8b             	add    %cl,-0x75(%rax)
  14:	5c                   	pop    %rsp
  15:	24 10                	and    $0x10,%al
  17:	0f 84 ff fe ff ff    	je     0xffffffffffffff1c
  1d:	48 89 df             	mov    %rbx,%rdi
  20:	e8 4b e8 4e 00       	callq  0x4ee870
  25:	e9 f2 fe ff ff       	jmpq   0xffffffffffffff1c
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	41 bd ea ff ff ff    	mov    $0xffffffea,%r13d
  32:	eb b0                	jmp    0xffffffffffffffe4
  34:	89 e9                	mov    %ebp,%ecx
  36:	80 e1 07             	and    $0x7,%cl
  39:	80 c1 03             	add    $0x3,%cl
  3c:	38 c1                	cmp    %al,%cl
  3e:	0f                   	.byte 0xf
  3f:	8c                   	.byte 0x8c

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	41 bd ea ff ff ff    	mov    $0xffffffea,%r13d
   8:	eb b0                	jmp    0xffffffffffffffba
   a:	89 e9                	mov    %ebp,%ecx
   c:	80 e1 07             	and    $0x7,%cl
   f:	80 c1 03             	add    $0x3,%cl
  12:	38 c1                	cmp    %al,%cl
  14:	0f                   	.byte 0xf
  15:	8c                   	.byte 0x8c
[   53.203574][   T14] RSP: 0000:ffff88810032f548 EFLAGS: 00010202
[   53.204517][   T14] RAX: ffff888100175900 RBX: dffffc0000000000 RCX: ffffffff813ee8ba
[   53.205678][   T14] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff888100175800
[   53.206814][   T14] RBP: ffff8881001759c0 R08: dffffc0000000000 R09: fffffbfff1276c09
[   53.207950][   T14] R10: dffff7fff1276c0a R11: 1ffffffff1276c08 R12: 1ffff1102002eb38
[   53.209111][   T14] R13: ffff888100175800 R14: 1ffff11020065ed4 R15: dffffc0000000000
[   53.210304][   T14] FS:  0000000000000000(0000) GS:ffff8883aea00000(0000) knlGS:0000000000000000
[   53.211568][   T14] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.212492][   T14] CR2: ffff88843ffff000 CR3: 00000000072c0000 CR4: 00000000000406f0
[   53.213598][   T14] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   53.214793][   T14] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   53.215927][   T14] Call Trace:
[   53.218382][   T14]  <TASK>
[ 53.218803][ T14] ? init_rescuer (workqueue.c:?) 
[ 53.219468][ T14] alloc_workqueue (??:?) 
[ 53.220201][ T14] ? try_to_wake_up (core.c:?) 
[ 53.220940][ T14] ? kthread_create_on_node (??:?) 
[ 53.221749][ T14] ? apply_workqueue_attrs (??:?) 
[ 53.222605][ T14] ? __init_waitqueue_head (??:?) 
[ 53.223408][ T14] ? device_initialize (??:?) 
[ 53.224134][ T14] scsi_host_alloc (??:?) 
[ 53.224941][ T14] ata_scsi_add_hosts (??:?) 
[ 53.225672][ T14] ? ata_tport_add (??:?) 
[ 53.226409][ T14] ata_host_register (??:?) 
[ 53.227124][ T14] ata_pci_sff_activate_host (??:?) 
[ 53.227909][ T14] ? ata_bmdma_port_intr (??:?) 
[ 53.228711][ T14] ? ata_pci_sff_prepare_host (??:?) 
[ 53.229513][ T14] ? dmi_matches (dmi_scan.c:?) 
[ 53.230265][ T14] piix_init_one (ata_piix.c:?) 
[ 53.230978][ T14] ? pdc20621_put_to_dimm (ata_piix.c:?) 
[ 53.232052][ T14] ? lockdep_hardirqs_on_prepare (??:?) 
[ 53.232929][ T14] ? print_irqtrace_events (??:?) 
[ 53.233725][ T14] ? do_raw_spin_unlock (??:?) 
[ 53.234539][ T14] ? read_lock_is_recursive (??:?) 
[ 53.235320][ T14] ? __lock_acquire (??:?) 
[ 53.236050][ T14] ? pdc20621_put_to_dimm (ata_piix.c:?) 
[ 53.236852][ T14] local_pci_probe (pci-driver.c:?) 
[ 53.237539][ T14] ? remove_id_store (pci-driver.c:?) 
[ 53.238302][ T14] work_for_cpu_fn (workqueue.c:?) 
[ 53.238945][ T14] process_one_work (workqueue.c:?) 
[ 53.239647][ T14] ? rescuer_thread (workqueue.c:?) 
[ 53.240372][ T14] ? _raw_spin_lock_irqsave (??:?) 
[ 53.241191][ T14] ? wq_worker_sleeping (??:?) 
[ 53.241948][ T14] worker_thread (workqueue.c:?) 
[ 53.242788][ T14] kthread (kthread.c:?) 
[ 53.243365][ T14] ? pr_cont_work (workqueue.c:?) 
[ 53.244019][ T14] ? kthread_blkcg (kthread.c:?) 
[ 53.244719][ T14] ret_from_fork (??:?) 
[   53.245387][   T14]  </TASK>
[   53.245831][   T14] irq event stamp: 79941
[ 53.246510][ T14] hardirqs last enabled at (79953): __up_console_sem (printk.c:?) 
[ 53.247872][ T14] hardirqs last disabled at (79962): __up_console_sem (printk.c:?) 
[ 53.249228][ T14] softirqs last enabled at (79886): __irq_exit_rcu (softirq.c:?) 
[ 53.250603][ T14] softirqs last disabled at (79881): __irq_exit_rcu (softirq.c:?) 
[   53.251924][   T14] ---[ end trace 0000000000000000 ]---
[   53.256400][   T14] scsi host0: failed to create tmf workq
[   53.270705][    T1] ata_piix: probe of 0000:00:01.1 failed with error -12
[ 53.272881][ T1] initcall piix_init+0x0/0x30 returned 0 after 94012 usecs 
[ 53.274079][ T1] calling mv_init+0x0/0x50 @ 1 
[ 53.275182][ T1] initcall mv_init+0x0/0x50 returned 0 after 336 usecs 
[ 53.276240][ T1] calling pdc_ata_pci_driver_init+0x0/0x20 @ 1 
[ 53.277295][ T1] initcall pdc_ata_pci_driver_init+0x0/0x20 returned 0 after 150 usecs 
[ 53.278593][ T1] calling sil_pci_driver_init+0x0/0x20 @ 1 
[ 53.279741][ T1] initcall sil_pci_driver_init+0x0/0x20 returned 0 after 245 usecs 
[ 53.280956][ T1] calling k2_sata_pci_driver_init+0x0/0x20 @ 1 
[ 53.282196][ T1] initcall k2_sata_pci_driver_init+0x0/0x20 returned 0 after 279 usecs 
[ 53.283409][ T1] calling uli_pci_driver_init+0x0/0x20 @ 1 
[ 53.284489][ T1] initcall uli_pci_driver_init+0x0/0x20 returned 0 after 206 usecs 
[ 53.285662][ T1] calling vsc_sata_pci_driver_init+0x0/0x20 @ 1 
[ 53.286920][ T1] initcall vsc_sata_pci_driver_init+0x0/0x20 returned 0 after 211 usecs 
[ 53.288134][ T1] calling ali_init+0x0/0x50 @ 1 
[ 53.289048][ T1] initcall ali_init+0x0/0x50 returned 0 after 170 usecs 
[ 53.290171][ T1] calling atp867x_driver_init+0x0/0x20 @ 1 
[ 53.291276][ T1] initcall atp867x_driver_init+0x0/0x20 returned 0 after 209 usecs 
[ 53.292434][ T1] calling cmd64x_pci_driver_init+0x0/0x20 @ 1 
[ 53.293558][ T1] initcall cmd64x_pci_driver_init+0x0/0x20 returned 0 after 177 usecs 
[ 53.294868][ T1] calling cy82c693_pci_driver_init+0x0/0x20 @ 1 
[ 53.296010][ T1] initcall cy82c693_pci_driver_init+0x0/0x20 returned 0 after 197 usecs 
[ 53.305202][ T1] calling efar_pci_driver_init+0x0/0x20 @ 1 
[ 53.306390][ T1] initcall efar_pci_driver_init+0x0/0x20 returned 0 after 252 usecs 
[ 53.307629][ T1] calling hpt36x_pci_driver_init+0x0/0x20 @ 1 
[ 53.308738][ T1] initcall hpt36x_pci_driver_init+0x0/0x20 returned 0 after 177 usecs 
[ 53.309968][ T1] calling hpt37x_pci_driver_init+0x0/0x20 @ 1 
[ 53.311156][ T1] initcall hpt37x_pci_driver_init+0x0/0x20 returned 0 after 240 usecs 
[ 53.312355][ T1] calling hpt3x3_pci_driver_init+0x0/0x20 @ 1 
[ 53.313493][ T1] initcall hpt3x3_pci_driver_init+0x0/0x20 returned 0 after 206 usecs 
[ 53.314785][ T1] calling it8213_pci_driver_init+0x0/0x20 @ 1 
[ 53.315836][ T1] initcall it8213_pci_driver_init+0x0/0x20 returned 0 after 160 usecs 
[ 53.317010][ T1] calling it821x_pci_driver_init+0x0/0x20 @ 1 
[ 53.318156][ T1] initcall it821x_pci_driver_init+0x0/0x20 returned 0 after 240 usecs 
[ 53.319413][ T1] calling jmicron_pci_driver_init+0x0/0x20 @ 1 
[ 53.320650][ T1] initcall jmicron_pci_driver_init+0x0/0x20 returned 0 after 279 usecs 
[ 53.321933][ T1] calling pdc2027x_pci_driver_init+0x0/0x20 @ 1 
[ 53.323071][ T1] initcall pdc2027x_pci_driver_init+0x0/0x20 returned 0 after 163 usecs 
[ 53.324437][ T1] calling pdc202xx_pci_driver_init+0x0/0x20 @ 1 
[ 53.325573][ T1] initcall pdc202xx_pci_driver_init+0x0/0x20 returned 0 after 166 usecs 
[ 53.326881][ T1] calling rdc_pci_driver_init+0x0/0x20 @ 1 
[ 53.328040][ T1] initcall rdc_pci_driver_init+0x0/0x20 returned 0 after 226 usecs 
[ 53.329273][ T1] calling serverworks_pci_driver_init+0x0/0x20 @ 1 
[ 53.330555][ T1] initcall serverworks_pci_driver_init+0x0/0x20 returned 0 after 243 usecs 
[ 53.331846][ T1] calling sil680_pci_driver_init+0x0/0x20 @ 1 
[ 53.333009][ T1] initcall sil680_pci_driver_init+0x0/0x20 returned 0 after 193 usecs 
[ 53.334321][ T1] calling sis_pci_driver_init+0x0/0x20 @ 1 
[ 53.335359][ T1] initcall sis_pci_driver_init+0x0/0x20 returned 0 after 153 usecs 
[ 53.336528][ T1] calling ata_tosh_pci_driver_init+0x0/0x20 @ 1 
[ 53.337591][ T1] initcall ata_tosh_pci_driver_init+0x0/0x20 returned 0 after 156 usecs 
[ 53.338925][ T1] calling triflex_pci_driver_init+0x0/0x20 @ 1 
[ 53.340113][ T1] initcall triflex_pci_driver_init+0x0/0x20 returned 0 after 246 usecs 


To reproduce:

        # build kernel
	cd linux
	cp config-6.3.0-rc7-00151-g25aa2ad5c302 .config
	make HOSTCC=clang-14 CC=clang-14 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage modules
	make HOSTCC=clang-14 CC=clang-14 ARCH=x86_64 INSTALL_MOD_PATH=<mod-install-dir> modules_install
	cd <mod-install-dir>
	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz


        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



--xJgqUhhEbMFOTMjC
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.3.0-rc7-00151-g25aa2ad5c302"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.3.0-rc7 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="clang version 14.0.6 (git://gitmirror/llvm_project f28c006a5895fc0e329fe15fead81e37457cb1d1)"
CONFIG_GCC_VERSION=0
CONFIG_CC_IS_CLANG=y
CONFIG_CLANG_VERSION=140006
CONFIG_AS_IS_LLVM=y
CONFIG_AS_VERSION=140006
CONFIG_LD_VERSION=0
CONFIG_LD_IS_LLD=y
CONFIG_LLD_VERSION=140006
CONFIG_RUST_IS_AVAILABLE=y
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT=y
CONFIG_TOOLS_SUPPORT_RELR=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=125
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_KERNEL_ZSTD=y
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_CONTEXT_TRACKING_USER=y
# CONFIG_CONTEXT_TRACKING_USER_FORCE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=125
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
# CONFIG_BPF_SYSCALL is not set
# CONFIG_BPF_JIT is not set
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_PREEMPT_DYNAMIC is not set
CONFIG_SCHED_CORE=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_PSI=y
# CONFIG_PSI_DEFAULT_DISABLED is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_FORCE_TASKS_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_FORCE_TASKS_RUDE_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_FORCE_TASKS_TRACE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_NOCB_CPU is not set
# CONFIG_TASKS_TRACE_RCU_READ_MB is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_PRINTK_INDEX=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough"
CONFIG_GCC11_NO_ARRAY_BOUNDS=y
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_CGROUP_FAVOR_DYNMODS=y
# CONFIG_MEMCG is not set
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_SCHED_MM_CID=y
# CONFIG_CGROUP_PIDS is not set
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_MISC=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_TIME_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
CONFIG_BOOT_CONFIG=y
# CONFIG_BOOT_CONFIG_FORCE is not set
CONFIG_BOOT_CONFIG_EMBED=y
CONFIG_BOOT_CONFIG_EMBED_FILE=""
# CONFIG_INITRAMFS_PRESERVE_MTIME is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_LD_ORPHAN_WARN_LEVEL="warn"
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_PROFILING=y
# CONFIG_RUST is not set
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_CSUM=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_GOLDFISH is not set
CONFIG_X86_CPU_RESCTRL=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS_RANGE_BEGIN=2
CONFIG_NR_CPUS_RANGE_END=512
CONFIG_NR_CPUS_DEFAULT=64
CONFIG_NR_CPUS=64
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_PERF_EVENTS_AMD_UNCORE is not set
# CONFIG_PERF_EVENTS_AMD_BRS is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
# CONFIG_X86_IOPL_IOPERM is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
# CONFIG_MICROCODE_LATE_LOADING is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_5LEVEL is not set
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
# CONFIG_X86_64_ACPI_NUMA is not set
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
# CONFIG_X86_PMEM_LEGACY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
CONFIG_X86_KERNEL_IBT=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
# CONFIG_X86_INTEL_TSX_MODE_OFF is not set
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
CONFIG_X86_INTEL_TSX_MODE_AUTO=y
# CONFIG_EFI is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
CONFIG_KEXEC_SIG=y
# CONFIG_KEXEC_SIG_FORCE is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
# end of Processor type and features

CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=11
CONFIG_FUNCTION_PADDING_BYTES=16
# CONFIG_SPECULATION_MITIGATIONS is not set
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_USERSPACE_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ENERGY_MODEL=y
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_TABLE_LIB=y
CONFIG_ACPI_DEBUGGER=y
CONFIG_ACPI_DEBUGGER_USER=y
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_FPDT=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_REV_OVERRIDE_POSSIBLE is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_NFIT is not set
# CONFIG_ACPI_NUMA is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_ACPI_DPTF=y
CONFIG_DPTF_POWER=y
CONFIG_DPTF_PCH_FIVR=y
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_CONFIGFS=y
# CONFIG_ACPI_PFRUT is not set
CONFIG_ACPI_PCC=y
CONFIG_ACPI_FFH=y
CONFIG_PMIC_OPREGION=y
# CONFIG_TPS68470_PMIC_OPREGION is not set
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
# CONFIG_X86_AMD_PSTATE is not set
# CONFIG_X86_AMD_PSTATE_UT is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ_CPB is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_CPU_IDLE_GOV_TEO=y
CONFIG_CPU_IDLE_GOV_HALTPOLL=y
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

# CONFIG_INTEL_IDLE is not set
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y
CONFIG_AS_GFNI=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_RUST=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
# CONFIG_SECCOMP is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
# CONFIG_STACKPROTECTOR_STRONG is not set
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_ARCH_SUPPORTS_CFI_CLANG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING_USER=y
CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_ISA_BUS_API=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
# CONFIG_VMAP_STACK is not set
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT=16
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
# CONFIG_BLOCK_LEGACY_AUTOLOAD is not set
CONFIG_BLK_RQ_ALLOC_TIME=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_ZONED=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_WBT_MQ is not set
CONFIG_BLK_CGROUP_IOLATENCY=y
CONFIG_BLK_CGROUP_FC_APPID=y
CONFIG_BLK_CGROUP_IOCOST=y
# CONFIG_BLK_CGROUP_IOPRIO is not set
# CONFIG_BLK_DEBUG_FS is not set
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
# CONFIG_MQ_IOSCHED_KYBER is not set
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
CONFIG_BFQ_CGROUP_DEBUG=y
# end of IO Schedulers

CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
# CONFIG_SWAP is not set

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLAB_MERGE_DEFAULT is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLUB_STATS=y
CONFIG_SLUB_CPU_PARTIAL=y
# end of SLAB allocator options

# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
CONFIG_COMPAT_BRK=y
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_DEBUGFS=y
# CONFIG_CMA_SYSFS is not set
CONFIG_CMA_AREAS=19
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
# CONFIG_ZONE_DEVICE is not set
CONFIG_GET_FREE_REGION=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PERCPU_STATS=y
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
CONFIG_SECRETMEM=y
CONFIG_ANON_VMA_NAME=y
# CONFIG_USERFAULTFD is not set
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y
CONFIG_LRU_GEN_STATS=y

#
# Data Access Monitoring
#
CONFIG_DAMON=y
# CONFIG_DAMON_VADDR is not set
CONFIG_DAMON_PADDR=y
# CONFIG_DAMON_SYSFS is not set
CONFIG_DAMON_RECLAIM=y
CONFIG_DAMON_LRU_SORT=y
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
# CONFIG_XFRM_USER is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
CONFIG_INET_TABLE_PERTURB_ORDER=16
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
# CONFIG_NETLABEL is not set
# CONFIG_MPTCP is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_NET_NSH is not set
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
# CONFIG_MCTP is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_PCI_PF_STUB=y
CONFIG_PCI_ATS=y
CONFIG_PCI_DOE=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#

#
# DesignWare PCI Core Support
#
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
CONFIG_PCI_ENDPOINT=y
CONFIG_PCI_ENDPOINT_CONFIGFS=y
# CONFIG_PCI_EPF_TEST is not set
CONFIG_PCI_EPF_NTB=y
# CONFIG_PCI_EPF_VNTB is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
CONFIG_PCI_SW_SWITCHTEC=y
# end of PCI switch controller drivers

CONFIG_CXL_BUS=y
CONFIG_CXL_PCI=y
CONFIG_CXL_MEM_RAW_COMMANDS=y
CONFIG_CXL_ACPI=y
CONFIG_CXL_PMEM=y
# CONFIG_CXL_MEM is not set
CONFIG_CXL_PORT=y
CONFIG_CXL_REGION=y
# CONFIG_CXL_REGION_INVALIDATION_TEST is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y
# CONFIG_RAPIDIO_CHMAN is not set
CONFIG_RAPIDIO_MPORT_CDEV=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_RXS_GEN3=y
# end of RapidIO Switch drivers

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
CONFIG_FW_UPLOAD=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_SOC_BUS=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=y
CONFIG_MHI_BUS_DEBUG=y
CONFIG_MHI_BUS_PCI_GENERIC=y
CONFIG_MHI_BUS_EP=y
# end of Bus devices

# CONFIG_CONNECTOR is not set

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set
CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_GNSS is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_AR7_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_PSTORE=y
CONFIG_MTD_PARTITIONED_MASTER=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_PHYSMAP_GPIO_ADDR is not set
CONFIG_MTD_SBC_GXX=y
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_MCHP48L640 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

#
# NAND
#
CONFIG_MTD_NAND_CORE=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set
CONFIG_MTD_RAW_NAND=y

#
# Raw/parallel NAND flash controllers
#
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_MXIC is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_NAND_ARASAN=y

#
# Misc
#
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_RICOH=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_SPI_NAND is not set

#
# ECC engine support
#
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
CONFIG_MTD_NAND_ECC_SW_BCH=y
CONFIG_MTD_NAND_ECC_MXIC=y
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# end of LPDDR & LPDDR2 PCM memory drivers

CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
# CONFIG_MTD_SPI_NOR_SWP_DISABLE is not set
CONFIG_MTD_SPI_NOR_SWP_DISABLE_ON_VOLATILE=y
# CONFIG_MTD_SPI_NOR_SWP_KEEP is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_MTD_HYPERBUS=y
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_UBLK=y

#
# NVME Support
#
CONFIG_NVME_COMMON=y
CONFIG_NVME_CORE=y
CONFIG_BLK_DEV_NVME=y
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_VERBOSE_ERRORS=y
CONFIG_NVME_HWMON=y
CONFIG_NVME_FABRICS=y
CONFIG_NVME_FC=y
# CONFIG_NVME_TCP is not set
CONFIG_NVME_AUTH=y
CONFIG_NVME_TARGET=y
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=y
# CONFIG_NVME_TARGET_FC is not set
# CONFIG_NVME_TARGET_TCP is not set
# CONFIG_NVME_TARGET_AUTH is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_SMPRO_ERRMON=y
# CONFIG_SMPRO_MISC is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
CONFIG_DW_XDATA_PCIE=y
# CONFIG_PCI_ENDPOINT_TEST is not set
CONFIG_XILINX_SDFEC=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_EEPROM_EE1004=y
# end of EEPROM support

CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=y
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_INTEL_MEI_GSC=y
CONFIG_INTEL_MEI_HDCP=y
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_VMWARE_VMCI=y
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
CONFIG_MISC_ALCOR_PCI=y
# CONFIG_MISC_RTSX_PCI is not set
CONFIG_UACCE=y
# CONFIG_PVPANIC is not set
CONFIG_GP_PCI1XXXX=y
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# end of SCSI Transports

# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=y
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_MOBILE_LPM_POLICY=0
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_AHCI_DWC=y
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
CONFIG_SATA_SVW=y
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_ATP867X=y
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=y
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=y
CONFIG_PATA_IT821X=y
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
# CONFIG_PATA_SCH is not set
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=y
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_PCMCIA=y
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_PARPORT=y

#
# Parallel IDE protocol modules
#
CONFIG_PATA_PARPORT_ATEN=y
CONFIG_PATA_PARPORT_BPCK=y
CONFIG_PATA_PARPORT_COMM=y
CONFIG_PATA_PARPORT_DSTR=y
CONFIG_PATA_PARPORT_FIT2=y
CONFIG_PATA_PARPORT_FIT3=y
CONFIG_PATA_PARPORT_EPAT=y
CONFIG_PATA_PARPORT_EPATC8=y
CONFIG_PATA_PARPORT_EPIA=y
# CONFIG_PATA_PARPORT_FRIQ is not set
CONFIG_PATA_PARPORT_FRPW=y
# CONFIG_PATA_PARPORT_KBIC is not set
CONFIG_PATA_PARPORT_KTTI=y
# CONFIG_PATA_PARPORT_ON20 is not set
CONFIG_PATA_PARPORT_ON26=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NET is not set
CONFIG_FIREWIRE_NOSY=y
# end of IEEE 1394 (FireWire) support

# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NTB_NETDEV is not set
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_MHI_NET is not set
# CONFIG_ARCNET is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
# CONFIG_CAVIUM_PTP is not set
# CONFIG_LIQUIDIO is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_FUNGIBLE=y
CONFIG_NET_VENDOR_GOOGLE=y
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_IGC is not set
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_ADI=y
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_OCTEON_EP is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
# CONFIG_VCAP is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
# CONFIG_SFC_SIENA is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PSE_CONTROLLER is not set
# CONFIG_MDIO_DEVICE is not set

#
# PCS device drivers
#
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_WLAN_VENDOR_ATMEL=y
CONFIG_WLAN_VENDOR_BROADCOM=y
CONFIG_WLAN_VENDOR_CISCO=y
CONFIG_WLAN_VENDOR_INTEL=y
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
CONFIG_WLAN_VENDOR_MARVELL=y
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_WLAN_VENDOR_MICROCHIP=y
CONFIG_WLAN_VENDOR_PURELIFI=y
CONFIG_WLAN_VENDOR_RALINK=y
CONFIG_WLAN_VENDOR_REALTEK=y
CONFIG_WLAN_VENDOR_RSI=y
CONFIG_WLAN_VENDOR_SILABS=y
CONFIG_WLAN_VENDOR_ST=y
CONFIG_WLAN_VENDOR_TI=y
CONFIG_WLAN_VENDOR_ZYDAS=y
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_WAN is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1050=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_DLINK_DIR685=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_PINEPHONE=y
CONFIG_KEYBOARD_SAMSUNG=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_IQS62X=y
CONFIG_KEYBOARD_TM2_TOUCHKEY=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CYPRESS_SF=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_JOYSTICK_PSXPAD_SPI=y
# CONFIG_JOYSTICK_PSXPAD_SPI_FF is not set
# CONFIG_JOYSTICK_PXRC is not set
CONFIG_JOYSTICK_QWIIC=y
CONFIG_JOYSTICK_FSIA6B=y
# CONFIG_JOYSTICK_SENSEHAT is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=y
# CONFIG_RMI4_SPI is not set
CONFIG_RMI4_SMB=y
# CONFIG_RMI4_F03 is not set
CONFIG_RMI4_2D_SENSOR=y
# CONFIG_RMI4_F11 is not set
CONFIG_RMI4_F12=y
# CONFIG_RMI4_F30 is not set
# CONFIG_RMI4_F34 is not set
CONFIG_RMI4_F3A=y
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_GPIO_PS2=y
# CONFIG_USERIO is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_LEGACY_TIOCSTI=y
# CONFIG_LDISC_AUTOLOAD is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_16550A_VARIANTS=y
CONFIG_SERIAL_8250_FINTEK=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCILIB=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_EXAR is not set
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_PCI1XXXX=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DWLIB=y
# CONFIG_SERIAL_8250_DFL is not set
# CONFIG_SERIAL_8250_DW is not set
CONFIG_SERIAL_8250_RT288X=y
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_UARTLITE_NR_UARTS=1
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_LANTIQ=y
CONFIG_SERIAL_LANTIQ_CONSOLE=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_SC16IS7XX_CORE=y
CONFIG_SERIAL_SC16IS7XX=y
CONFIG_SERIAL_SC16IS7XX_I2C=y
CONFIG_SERIAL_SC16IS7XX_SPI=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_FSL_LINFLEXUART=y
# CONFIG_SERIAL_FSL_LINFLEXUART_CONSOLE is not set
CONFIG_SERIAL_SPRD=y
CONFIG_SERIAL_SPRD_CONSOLE=y
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=y
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set
CONFIG_NULL_TTY=y
CONFIG_HVC_DRIVER=y
CONFIG_RPMSG_TTY=y
CONFIG_SERIAL_DEV_BUS=y
CONFIG_SERIAL_DEV_CTRL_TTYPORT=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_BA431=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_SCR24X is not set
# CONFIG_IPWIRELESS is not set
# end of PCMCIA character devices

CONFIG_MWAVE=y
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
# CONFIG_DEVPORT is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_SPI=y
CONFIG_TCG_TIS_SPI_CR50=y
CONFIG_TCG_TIS_I2C=y
# CONFIG_TCG_TIS_I2C_CR50 is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
CONFIG_TCG_TIS_ST33ZP24_SPI=y
# CONFIG_TELCLOCK is not set
CONFIG_XILLYBUS_CLASS=y
CONFIG_XILLYBUS=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_LTC4306=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_REG=y
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y
# end of I2C Algorithms

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_NVIDIA_GPU is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PCI1XXXX=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=y
CONFIG_I2C_VIRTIO=y
# end of I2C Hardware Bus support

# CONFIG_I2C_STUB is not set
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

CONFIG_I3C=y
CONFIG_CDNS_I3C_MASTER=y
# CONFIG_DW_I3C_MASTER is not set
CONFIG_SVC_I3C_MASTER=y
CONFIG_MIPI_I3C_HCI=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
CONFIG_SPI_MEM=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ALTERA_CORE=y
# CONFIG_SPI_ALTERA_DFL is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_DMA is not set
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MMIO=y
# CONFIG_SPI_NXP_FLEXSPI is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_INTEL=y
CONFIG_SPI_INTEL_PCI=y
CONFIG_SPI_INTEL_PLATFORM=y
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_MICROCHIP_CORE=y
CONFIG_SPI_MICROCHIP_CORE_QSPI=y
CONFIG_SPI_LANTIQ_SSC=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PCI1XXXX=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_ROCKCHIP=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SIFIVE=y
CONFIG_SPI_MXIC=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_ZYNQMP_GQSPI=y
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_LOOPBACK_TEST is not set
CONFIG_SPI_TLE62X0=y
CONFIG_SPI_SLAVE=y
CONFIG_SPI_SLAVE_TIME=y
# CONFIG_SPI_SLAVE_SYSTEM_CONTROL is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_KVM=y
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_CY8C95X0 is not set
CONFIG_PINCTRL_DA9062=y
CONFIG_PINCTRL_MCP23S08_I2C=y
CONFIG_PINCTRL_MCP23S08_SPI=y
CONFIG_PINCTRL_MCP23S08=y
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_MADERA=y
CONFIG_PINCTRL_CS47L15=y

#
# Intel pinctrl drivers
#
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
CONFIG_PINCTRL_LYNXPOINT=y
CONFIG_PINCTRL_INTEL=y
CONFIG_PINCTRL_ALDERLAKE=y
CONFIG_PINCTRL_BROXTON=y
# CONFIG_PINCTRL_CANNONLAKE is not set
CONFIG_PINCTRL_CEDARFORK=y
CONFIG_PINCTRL_DENVERTON=y
# CONFIG_PINCTRL_ELKHARTLAKE is not set
CONFIG_PINCTRL_EMMITSBURG=y
CONFIG_PINCTRL_GEMINILAKE=y
CONFIG_PINCTRL_ICELAKE=y
# CONFIG_PINCTRL_JASPERLAKE is not set
CONFIG_PINCTRL_LAKEFIELD=y
CONFIG_PINCTRL_LEWISBURG=y
CONFIG_PINCTRL_METEORLAKE=y
CONFIG_PINCTRL_SUNRISEPOINT=y
# CONFIG_PINCTRL_TIGERLAKE is not set
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y
CONFIG_GPIO_IDIO_16=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_DWAPB=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_MB86S7X=y
CONFIG_GPIO_SIOX=y
CONFIG_GPIO_VX855=y
CONFIG_GPIO_AMD_FCH=y
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_IT87=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_WINBOND=y
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
# CONFIG_GPIO_PCA9570 is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_BD9571MWV=y
CONFIG_GPIO_DA9052=y
# CONFIG_GPIO_LP873X is not set
CONFIG_GPIO_MADERA=y
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS65910=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TPS68470=y
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_PCI_IDIO_16=y
CONFIG_GPIO_PCIE_IDIO_24=y
CONFIG_GPIO_RDC321X=y
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_PISOSR=y
CONFIG_GPIO_XRA1403=y
# end of SPI GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_LATCH=y
# CONFIG_GPIO_MOCKUP is not set
CONFIG_GPIO_VIRTIO=y
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_GPIO=y
CONFIG_W1_MASTER_SGI=y
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2405 is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2805=y
# CONFIG_W1_SLAVE_DS2430 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2438=y
CONFIG_W1_SLAVE_DS250X=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_DS28E17=y
# end of 1-wire Slaves

CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_ATC260X is not set
CONFIG_POWER_RESET_RESTART=y
# CONFIG_POWER_RESET_TPS65086 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_POWER_SUPPLY_HWMON is not set
CONFIG_IP5XXX_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_CHARGER_ADP5061=y
# CONFIG_BATTERY_CW2015 is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_CHARGER_SBS=y
# CONFIG_MANAGER_SBS is not set
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=y
# CONFIG_BATTERY_BQ27XXX_HDQ is not set
# CONFIG_BATTERY_BQ27XXX_DT_UPDATES_NVM is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_DA9150=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_MAX1721X is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_LT3651 is not set
CONFIG_CHARGER_LTC4162L=y
CONFIG_CHARGER_MAX77693=y
CONFIG_CHARGER_MAX77976=y
CONFIG_CHARGER_MT6360=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24257=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_BQ2515X=y
CONFIG_CHARGER_BQ25890=y
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_BATTERY_RT5033=y
# CONFIG_CHARGER_RT9455 is not set
CONFIG_CHARGER_RT9467=y
# CONFIG_CHARGER_RT9471 is not set
CONFIG_CHARGER_BD99954=y
CONFIG_BATTERY_UG3105=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_SMPRO=y
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM1177=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_AHT10=y
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DELL_SMM=y
# CONFIG_I8K is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_FTSTEUTATES=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_I5500=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC2947=y
CONFIG_SENSORS_LTC2947_I2C=y
CONFIG_SENSORS_LTC2947_SPI=y
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC2992=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX31722=y
CONFIG_SENSORS_MAX31730=y
CONFIG_SENSORS_MAX31760=y
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MC34VR500=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_MLXREG_FAN=y
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_TPS23861=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
CONFIG_SENSORS_MR75203=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NCT6775_I2C=y
CONFIG_SENSORS_NCT7802=y
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_OCC_P8_I2C=y
CONFIG_SENSORS_OCC=y
CONFIG_SENSORS_OXP=y
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_PECI_CPUTEMP=y
CONFIG_SENSORS_PECI_DIMMTEMP=y
CONFIG_SENSORS_PECI=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1266=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_BEL_PFE=y
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
CONFIG_SENSORS_FSP_3Y=y
# CONFIG_SENSORS_IBM_CFFPS is not set
CONFIG_SENSORS_DPS920AB=y
CONFIG_SENSORS_INSPUR_IPSPS=y
CONFIG_SENSORS_IR35221=y
CONFIG_SENSORS_IR36021=y
CONFIG_SENSORS_IR38064=y
# CONFIG_SENSORS_IR38064_REGULATOR is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LM25066_REGULATOR is not set
CONFIG_SENSORS_LT7182S=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_LTC2978_REGULATOR=y
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX16601=y
CONFIG_SENSORS_MAX20730=y
CONFIG_SENSORS_MAX20751=y
CONFIG_SENSORS_MAX31785=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_MP2888=y
CONFIG_SENSORS_MP2975=y
CONFIG_SENSORS_MP5023=y
# CONFIG_SENSORS_MPQ7932_REGULATOR is not set
CONFIG_SENSORS_MPQ7932=y
# CONFIG_SENSORS_PIM4328 is not set
CONFIG_SENSORS_PLI1209BC=y
CONFIG_SENSORS_PLI1209BC_REGULATOR=y
CONFIG_SENSORS_PM6764TR=y
# CONFIG_SENSORS_PXE1610 is not set
CONFIG_SENSORS_Q54SJ108A2=y
CONFIG_SENSORS_STPDDC60=y
CONFIG_SENSORS_TDA38640=y
# CONFIG_SENSORS_TDA38640_REGULATOR is not set
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_TPS53679=y
# CONFIG_SENSORS_TPS546D24 is not set
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_XDPE152=y
CONFIG_SENSORS_XDPE122=y
# CONFIG_SENSORS_XDPE122_REGULATOR is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SBTSI=y
CONFIG_SENSORS_SBRMI=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHT3x=y
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SY7636A=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC2305 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_STTS751=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_INA238=y
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP108=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TMP464=y
# CONFIG_SENSORS_TMP513 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83773G=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_XGENE=y
# CONFIG_SENSORS_INTEL_M10_BMC_HWMON is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_SENSORS_ASUS_WMI=y
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
CONFIG_THERMAL_STATISTICS=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
# CONFIG_THERMAL_HWMON is not set
CONFIG_THERMAL_ACPI=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_DEVFREQ_THERMAL is not set
CONFIG_THERMAL_EMULATION=y

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_INTEL_TCC=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=y
CONFIG_ACPI_THERMAL_REL=y
CONFIG_INT3406_THERMAL=y
CONFIG_PROC_THERMAL_MMIO_RAPL=y
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=y
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
# CONFIG_WATCHDOG_SYSFS is not set
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
CONFIG_WATCHDOG_PRETIMEOUT_GOV=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_SEL=m
CONFIG_WATCHDOG_PRETIMEOUT_GOV_NOOP=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_PANIC=y
# CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP is not set
CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_SOFT_WATCHDOG_PRETIMEOUT=y
CONFIG_DA9052_WATCHDOG=y
# CONFIG_DA9063_WATCHDOG is not set
CONFIG_DA9062_WATCHDOG=y
CONFIG_MENF21BMC_WATCHDOG=y
CONFIG_WDAT_WDT=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
CONFIG_ZIIRAVE_WATCHDOG=y
CONFIG_RAVE_SP_WATCHDOG=y
CONFIG_MLX_WDT=y
# CONFIG_CADENCE_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
CONFIG_MAX63XX_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ADVANTECH_EC_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_EBC_C384_WDT=y
CONFIG_EXAR_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_INTEL_MEI_WDT is not set
CONFIG_NI903X_WDT=y
CONFIG_NIC7018_WDT=y
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_PCI=y
# CONFIG_BCMA_SFLASH is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
CONFIG_MFD_SMPRO=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_BD9571MWV=y
# CONFIG_MFD_AXP20X_I2C is not set
CONFIG_MFD_MADERA=y
# CONFIG_MFD_MADERA_I2C is not set
CONFIG_MFD_MADERA_SPI=y
CONFIG_MFD_CS47L15=y
# CONFIG_MFD_CS47L35 is not set
# CONFIG_MFD_CS47L85 is not set
# CONFIG_MFD_CS47L90 is not set
# CONFIG_MFD_CS47L92 is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9062=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_DA9150=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC_BXTWC is not set
CONFIG_INTEL_SOC_PMIC_MRFLD=y
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_INTEL_PMC_BXT=y
CONFIG_MFD_IQS62X=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX77843=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6360=y
CONFIG_MFD_MT6370=y
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=y
CONFIG_MFD_OCELOT=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_SY7636A=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RT4831=y
CONFIG_MFD_RT5033=y
CONFIG_MFD_RT5120=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SIMPLE_MFD_I2C=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SKY81452=y
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_TI_LMU=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TI_LP873X=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_CS47L24=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8998=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_ATC260X=y
CONFIG_MFD_ATC260X_I2C=y
CONFIG_RAVE_SP_CORE=y
CONFIG_MFD_INTEL_M10_BMC_CORE=y
# CONFIG_MFD_INTEL_M10_BMC_SPI is not set
CONFIG_MFD_INTEL_M10_BMC_PMCI=y
# end of Multifunction device drivers

CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PG86X=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ATC260X is not set
# CONFIG_REGULATOR_BD9571MWV is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9062=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=y
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LM363X is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_LTC3676=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8893 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX20086=y
CONFIG_REGULATOR_MAX20411=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MAX77826=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_MP8859=y
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_MT6360=y
CONFIG_REGULATOR_MT6370=y
CONFIG_REGULATOR_PCA9450=y
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_PV88060 is not set
# CONFIG_REGULATOR_PV88080 is not set
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_RT4801=y
# CONFIG_REGULATOR_RT4831 is not set
CONFIG_REGULATOR_RT5033=y
CONFIG_REGULATOR_RT5120=y
CONFIG_REGULATOR_RT5190A=y
CONFIG_REGULATOR_RT5759=y
# CONFIG_REGULATOR_RT6160 is not set
CONFIG_REGULATOR_RT6190=y
CONFIG_REGULATOR_RT6245=y
CONFIG_REGULATOR_RTQ2134=y
# CONFIG_REGULATOR_RTMV20 is not set
# CONFIG_REGULATOR_RTQ6752 is not set
CONFIG_REGULATOR_SKY81452=y
CONFIG_REGULATOR_SLG51000=y
CONFIG_REGULATOR_SY7636A=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65086 is not set
CONFIG_REGULATOR_TPS65132=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS68470=y
CONFIG_REGULATOR_WM831X=y
CONFIG_RC_CORE=y
# CONFIG_LIRC is not set
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_IR_ENE is not set
CONFIG_IR_FINTEK=y
CONFIG_IR_ITE_CIR=y
# CONFIG_IR_NUVOTON is not set
CONFIG_IR_SERIAL=y
# CONFIG_IR_SERIAL_TRANSMITTER is not set
CONFIG_IR_WINBOND_CIR=y
# CONFIG_RC_LOOPBACK is not set
CONFIG_CEC_CORE=y
CONFIG_CEC_NOTIFIER=y

#
# CEC support
#
CONFIG_MEDIA_CEC_RC=y
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_VIDEO_NOMODESET=y
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DBI=y
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=y
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=y
CONFIG_DRM_BUDDY=y
CONFIG_DRM_VRAM_HELPER=y
CONFIG_DRM_TTM_HELPER=y
CONFIG_DRM_GEM_DMA_HELPER=y
CONFIG_DRM_GEM_SHMEM_HELPER=y
CONFIG_DRM_SCHED=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_I2C_NXP_TDA9950=y
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_FORCE_PROBE=""
# CONFIG_DRM_I915_CAPTURE_ERROR is not set
# CONFIG_DRM_I915_USERPTR is not set
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_PREEMPT_TIMEOUT_COMPUTE=7500
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
CONFIG_DRM_VGEM=y
CONFIG_DRM_VKMS=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_MKSSTATS=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_QXL=y
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_PANEL_AUO_A030JTN01=y
CONFIG_DRM_PANEL_ORISETECH_OTA5601A=y
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
CONFIG_DRM_PANEL_WIDECHIPS_WS2401=y
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_ANALOGIX_ANX78XX=y
CONFIG_DRM_ANALOGIX_DP=y
# end of Display Interface Bridges

CONFIG_DRM_ETNAVIV=y
CONFIG_DRM_ETNAVIV_THERMAL=y
CONFIG_DRM_BOCHS=y
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_PANEL_MIPI_DBI=y
# CONFIG_DRM_SIMPLEDRM is not set
CONFIG_TINYDRM_HX8357D=y
CONFIG_TINYDRM_ILI9163=y
CONFIG_TINYDRM_ILI9225=y
CONFIG_TINYDRM_ILI9341=y
CONFIG_TINYDRM_ILI9486=y
CONFIG_TINYDRM_MI0283QT=y
# CONFIG_TINYDRM_REPAPER is not set
CONFIG_TINYDRM_ST7586=y
CONFIG_TINYDRM_ST7735R=y
CONFIG_DRM_VBOXVIDEO=y
# CONFIG_DRM_SSD130X is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_PRIVACY_SCREEN=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
# CONFIG_FB is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_LCD_OTM3225A=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
CONFIG_BACKLIGHT_KTZ8866=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MT6370 is not set
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_QCOM_WLED=y
# CONFIG_BACKLIGHT_RT4831 is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_SKY81452=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_BACKLIGHT_ARCXCNN=y
CONFIG_BACKLIGHT_RAVE_SP=y
# end of Backlight & LCD device support

CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
# end of Console display driver support
# end of Graphics support

# CONFIG_DRM_ACCEL is not set
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_PCI=y

#
# USB dual-mode controller drivers
#

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=y
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_DEBUG=y
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_F_SDH30 is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_ALCOR=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_USDHI6ROL0=y
CONFIG_MMC_CQHCI=y
CONFIG_MMC_HSQ=y
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
CONFIG_MMC_SDHCI_XENON=y
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFS_BSG=y
# CONFIG_SCSI_UFS_HPB is not set
CONFIG_SCSI_UFS_HWMON=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFS_DWC_TC_PCI=y
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
CONFIG_LEDS_CLASS_MULTICOLOR=y
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP50XX=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_MENF21BMC=y
CONFIG_LEDS_IS31FL319X=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_MLXCPLD=y
CONFIG_LEDS_MLXREG=y
CONFIG_LEDS_USER=y
CONFIG_LEDS_NIC78BX=y
# CONFIG_LEDS_TI_LMU_COMMON is not set
CONFIG_LEDS_TPS6105X=y

#
# Flash and Torch LED drivers
#
CONFIG_LEDS_AS3645A=y
# CONFIG_LEDS_LM3601X is not set
# CONFIG_LEDS_RT8515 is not set
CONFIG_LEDS_SGM3140=y

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_DISK=y
CONFIG_LEDS_TRIGGER_MTD=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=y
CONFIG_LEDS_TRIGGER_TTY=y

#
# Simple LED drivers
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# end of Speakup console speech

# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
CONFIG_DMABUF_MOVE_NOTIFY=y
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
# CONFIG_DMABUF_HEAPS_SYSTEM is not set
CONFIG_DMABUF_HEAPS_CMA=y
# end of DMABUF options

# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_PMEM=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MEM=y
CONFIG_VIRTIO_INPUT=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=y
# CONFIG_VDPA is not set
# CONFIG_VHOST_MENU is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_RTLLIB is not set
# CONFIG_RTS5208 is not set
# CONFIG_STAGING_MEDIA is not set
# CONFIG_MOST_COMPONENTS is not set
# CONFIG_KS7010 is not set
CONFIG_PI433=y
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_QLGE is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_TSI148=y
CONFIG_VME_FAKE=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
# CONFIG_MLXREG_HOTPLUG is not set
CONFIG_MLXREG_IO=y
# CONFIG_MLXREG_LC is not set
CONFIG_NVSW_SN2201=y
# CONFIG_SURFACE_PLATFORMS is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=y
CONFIG_WMI_BMOF=y
CONFIG_HUAWEI_WMI=y
CONFIG_MXM_WMI=y
CONFIG_PEAQ_WMI=y
# CONFIG_NVIDIA_WMI_EC_BACKLIGHT is not set
CONFIG_XIAOMI_WMI=y
CONFIG_GIGABYTE_WMI=y
CONFIG_YOGABOOK_WMI=y
# CONFIG_ACERHDF is not set
CONFIG_ACER_WIRELESS=y
CONFIG_ACER_WMI=y
# CONFIG_AMD_PMF is not set
# CONFIG_AMD_HSMP is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=y
# CONFIG_ASUS_LAPTOP is not set
CONFIG_ASUS_WIRELESS=y
CONFIG_MERAKI_MX100=y
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_TABLET=y
CONFIG_GPD_POCKET_FAN=y
# CONFIG_X86_PLATFORM_DRIVERS_HP is not set
# CONFIG_WIRELESS_HOTKEY is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_THINKPAD_LMI=y
CONFIG_INTEL_ATOMISP2_PDX86=y
CONFIG_INTEL_ATOMISP2_LED=y
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_IFS=y
CONFIG_INTEL_SAR_INT1092=y
CONFIG_INTEL_SKL_INT3472=y
# CONFIG_INTEL_PMC_CORE is not set
CONFIG_INTEL_PMT_CLASS=y
# CONFIG_INTEL_PMT_TELEMETRY is not set
CONFIG_INTEL_PMT_CRASHLOG=y

#
# Intel Speed Select Technology interface support
#
CONFIG_INTEL_SPEED_SELECT_INTERFACE=y
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_TELEMETRY=y
CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=y

#
# Intel Uncore Frequency Control
#
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=y
# CONFIG_INTEL_VBTN is not set
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_MRFLD_PWRBTN=y
CONFIG_INTEL_PUNIT_IPC=y
CONFIG_INTEL_RST=y
CONFIG_INTEL_SDSI=y
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_INTEL_TPMI=y
CONFIG_INTEL_VSEC=y
CONFIG_MSI_WMI=y
CONFIG_PCENGINES_APU2=y
# CONFIG_BARCO_P50_GPIO is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_TOSHIBA_HAPS=y
CONFIG_TOSHIBA_WMI=y
CONFIG_ACPI_CMPC=y
CONFIG_LG_LAPTOP=y
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_SYSTEM76_ACPI=y
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_SERIAL_MULTI_INSTANTIATE is not set
# CONFIG_MLX_PLATFORM is not set
CONFIG_FW_ATTR_CLASS=y
# CONFIG_INTEL_IPS is not set
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU=y
CONFIG_INTEL_SCU_PCI=y
CONFIG_INTEL_SCU_PLATFORM=y
CONFIG_INTEL_SCU_IPC_UTIL=y
# CONFIG_SIEMENS_SIMATIC_IPC is not set
CONFIG_WINMATE_FM07_KEYS=y
CONFIG_P2SB=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_WM831X is not set
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI544=y
CONFIG_COMMON_CLK_CDCE706=y
# CONFIG_COMMON_CLK_TPS68470 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
CONFIG_CLK_TWL6040=y
CONFIG_XILINX_VCU=y
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
CONFIG_ALTERA_MBOX=y
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

CONFIG_IOMMU_DEBUGFS=y
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
# CONFIG_IOMMU_DEFAULT_DMA_LAZY is not set
CONFIG_IOMMU_DEFAULT_PASSTHROUGH=y
CONFIG_IOMMU_DMA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_IOMMUFD=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_REMOTEPROC_CDEV=y
# end of Remoteproc drivers

#
# Rpmsg drivers
#
CONFIG_RPMSG=y
# CONFIG_RPMSG_CHAR is not set
# CONFIG_RPMSG_CTRL is not set
CONFIG_RPMSG_NS=y
CONFIG_RPMSG_QCOM_GLINK=y
CONFIG_RPMSG_QCOM_GLINK_RPM=y
CONFIG_RPMSG_VIRTIO=y
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=y

#
# SoundWire Devices
#

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

CONFIG_WPCM450_SOC=y

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y
CONFIG_DEVFREQ_GOV_PASSIVE=y

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_FSA9480 is not set
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_INTEL_INT3496=y
CONFIG_EXTCON_INTEL_MRFLD=y
# CONFIG_EXTCON_MAX3355 is not set
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX77843=y
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_PTN5150=y
CONFIG_EXTCON_RT8973A=y
# CONFIG_EXTCON_SM5502 is not set
CONFIG_EXTCON_USB_GPIO=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_NTB_AMD is not set
CONFIG_NTB_IDT=y
CONFIG_NTB_INTEL=y
# CONFIG_NTB_EPF is not set
CONFIG_NTB_SWITCHTEC=y
CONFIG_NTB_PINGPONG=y
CONFIG_NTB_TOOL=y
CONFIG_NTB_PERF=y
CONFIG_NTB_TRANSPORT=y
# CONFIG_PWM is not set

#
# IRQ chip support
#
CONFIG_MADERA_IRQ=y
# end of IRQ chip support

CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_USB_LGM_PHY is not set
CONFIG_PHY_CAN_TRANSCEIVER=y

#
# PHY drivers for Broadcom platforms
#
CONFIG_BCM_KONA_USB2_PHY=y
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
CONFIG_PHY_PXA_28NM_USB2=y
CONFIG_PHY_INTEL_LGM_EMMC=y
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=y
# CONFIG_INTEL_RAPL is not set
CONFIG_IDLE_INJECT=y
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ANDROID_BINDERFS is not set
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder"
# CONFIG_ANDROID_BINDER_IPC_SELFTEST is not set
# end of Android

CONFIG_LIBNVDIMM=y
CONFIG_BLK_DEV_PMEM=y
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=y
CONFIG_BTT=y
CONFIG_NVDIMM_KEYS=y
# CONFIG_NVDIMM_SECURITY_TEST is not set
CONFIG_DAX=y
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
CONFIG_NVMEM_RAVE_SP_EEPROM=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=y
# CONFIG_STM_PROTO_BASIC is not set
CONFIG_STM_PROTO_SYS_T=y
# CONFIG_STM_DUMMY is not set
CONFIG_STM_SOURCE_CONSOLE=y
CONFIG_STM_SOURCE_HEARTBEAT=y
# CONFIG_STM_SOURCE_FTRACE is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

CONFIG_FPGA=y
# CONFIG_ALTERA_PR_IP_CORE is not set
CONFIG_FPGA_MGR_ALTERA_PS_SPI=y
CONFIG_FPGA_MGR_ALTERA_CVP=y
CONFIG_FPGA_MGR_XILINX_SPI=y
# CONFIG_FPGA_MGR_MACHXO2_SPI is not set
CONFIG_FPGA_BRIDGE=y
CONFIG_ALTERA_FREEZE_BRIDGE=y
CONFIG_XILINX_PR_DECOUPLER=y
CONFIG_FPGA_REGION=y
CONFIG_FPGA_DFL=y
CONFIG_FPGA_DFL_FME=y
CONFIG_FPGA_DFL_FME_MGR=y
# CONFIG_FPGA_DFL_FME_BRIDGE is not set
# CONFIG_FPGA_DFL_FME_REGION is not set
CONFIG_FPGA_DFL_AFU=y
# CONFIG_FPGA_DFL_NIOS_INTEL_PAC_N3000 is not set
# CONFIG_FPGA_DFL_PCI is not set
CONFIG_FPGA_M10_BMC_SEC_UPDATE=y
# CONFIG_FPGA_MGR_MICROCHIP_SPI is not set
# CONFIG_FPGA_MGR_LATTICE_SYSCONFIG_SPI is not set
# CONFIG_TEE is not set
CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
CONFIG_MUX_ADG792A=y
CONFIG_MUX_ADGS1408=y
# CONFIG_MUX_GPIO is not set
# end of Multiplexer drivers

CONFIG_PM_OPP=y
CONFIG_SIOX=y
CONFIG_SIOX_BUS_GPIO=y
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
CONFIG_MOST=y
# CONFIG_MOST_CDEV is not set
CONFIG_PECI=y
CONFIG_PECI_CPU=y
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_LEGACY_DIRECT_IO=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT2 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_SUPPORT_V4=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_ONLINE_SCRUB=y
# CONFIG_XFS_ONLINE_REPAIR is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_BTRFS_FS_REF_VERIFY=y
CONFIG_NILFS2_FS=y
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
CONFIG_F2FS_CHECK_FS=y
# CONFIG_F2FS_FAULT_INJECTION is not set
CONFIG_F2FS_FS_COMPRESSION=y
CONFIG_F2FS_FS_LZO=y
CONFIG_F2FS_FS_LZORLE=y
CONFIG_F2FS_FS_LZ4=y
CONFIG_F2FS_FS_LZ4HC=y
# CONFIG_F2FS_FS_ZSTD is not set
# CONFIG_F2FS_IOSTAT is not set
CONFIG_F2FS_UNFAIR_RWSEM=y
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
# CONFIG_OVERLAY_FS_INDEX is not set
CONFIG_OVERLAY_FS_XINO_AUTO=y
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=m
# CONFIG_NETFS_STATS is not set
# CONFIG_FSCACHE is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_EXFAT_FS=y
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"
# CONFIG_NTFS_FS is not set
CONFIG_NTFS3_FS=y
CONFIG_NTFS3_64BIT_CLUSTER=y
# CONFIG_NTFS3_LZX_XPRESS is not set
# CONFIG_NTFS3_FS_POSIX_ACL is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_TMPFS_INODE64=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_RTIME=y
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=y
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
CONFIG_SQUASHFS_DECOMP_MULTI=y
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_CHOICE_DECOMP_BY_MOUNT=y
CONFIG_SQUASHFS_MOUNT_DECOMP_THREADS=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZSTD=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
CONFIG_PSTORE_LZO_COMPRESS=y
CONFIG_PSTORE_LZ4_COMPRESS=y
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
CONFIG_PSTORE_842_COMPRESS=y
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
# CONFIG_PSTORE_LZO_COMPRESS_DEFAULT is not set
# CONFIG_PSTORE_LZ4_COMPRESS_DEFAULT is not set
# CONFIG_PSTORE_842_COMPRESS_DEFAULT is not set
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_RAM is not set
CONFIG_PSTORE_ZONE=y
CONFIG_PSTORE_BLK=y
CONFIG_PSTORE_BLK_BLKDEV=""
CONFIG_PSTORE_BLK_KMSG_SIZE=64
CONFIG_PSTORE_BLK_MAX_REASON=2
CONFIG_PSTORE_BLK_PMSG_SIZE=64
CONFIG_PSTORE_BLK_CONSOLE_SIZE=64
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_EROFS_FS=y
CONFIG_EROFS_FS_DEBUG=y
CONFIG_EROFS_FS_XATTR=y
CONFIG_EROFS_FS_POSIX_ACL=y
CONFIG_EROFS_FS_SECURITY=y
# CONFIG_EROFS_FS_ZIP is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_TRUSTED_KEYS_TPM is not set

#
# No trust source selected!
#
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_KEY_NOTIFICATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_FORTIFY_SOURCE=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
# CONFIG_INIT_STACK_NONE is not set
CONFIG_INIT_STACK_ALL_PATTERN=y
# CONFIG_INIT_STACK_ALL_ZERO is not set
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
CONFIG_INIT_ON_FREE_DEFAULT_ON=y
# end of Memory initialization

CONFIG_RANDSTRUCT_NONE=y
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_ENGINE=y
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECDSA=y
CONFIG_CRYPTO_ECRDSA=y
CONFIG_CRYPTO_SM2=y
CONFIG_CRYPTO_CURVE25519=y
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_ARIA=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SM4=y
CONFIG_CRYPTO_SM4_GENERIC=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
CONFIG_CRYPTO_ADIANTUM=y
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_HCTR2=y
CONFIG_CRYPTO_KEYWRAP=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_OFB=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XCTR=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_NHPOLY1305=y
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
CONFIG_CRYPTO_AEGIS128=y
CONFIG_CRYPTO_CHACHA20POLY1305=y
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_SEQIV is not set
CONFIG_CRYPTO_ECHAINIV=y
CONFIG_CRYPTO_ESSIV=y
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=y
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_POLYVAL=y
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_SM3=y
CONFIG_CRYPTO_SM3_GENERIC=y
CONFIG_CRYPTO_STREEBOG=y
CONFIG_CRYPTO_VMAC=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_XXHASH=y
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRYPTO_CRC64_ROCKSOFT=y
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y
# CONFIG_CRYPTO_ZSTD is not set
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_KDF800108_CTR=y
# end of Random number generation

#
# Userspace interface
#
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
CONFIG_CRYPTO_CURVE25519_X86=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64=y
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_AEGIS128_AESNI_SSE2=y
CONFIG_CRYPTO_NHPOLY1305_SSE2=y
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
CONFIG_CRYPTO_BLAKE2S_X86=y
CONFIG_CRYPTO_POLYVAL_CLMUL_NI=y
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SM3_AVX_X86_64=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# end of Accelerated Cryptographic Algorithms for CPU (x86)

CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_ATMEL_I2C=y
CONFIG_CRYPTO_DEV_ATMEL_ECC=y
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_CRYPTO_DEV_QAT=y
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
CONFIG_CRYPTO_DEV_QAT_C3XXX=y
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
CONFIG_CRYPTO_DEV_QAT_4XXX=y
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=y
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
CONFIG_CRYPTO_DEV_VIRTIO=y
CONFIG_CRYPTO_DEV_SAFEXCEL=y
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set

#
# Certificates for signature checking
#
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
# CONFIG_RAID6_PQ_BENCHMARK is not set
CONFIG_LINEAR_RANGES=y
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
# CONFIG_CORDIC is not set
CONFIG_PRIME_NUMBERS=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
CONFIG_CRYPTO_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_DES=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC64_ROCKSOFT=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
# CONFIG_CRC4 is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_MICROLZMA=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_INTERVAL_TREE=y
CONFIG_INTERVAL_TREE_SPAN_ITER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y
CONFIG_DMA_PERNUMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_PERCENTAGE=0
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
CONFIG_CMA_SIZE_SEL_MIN=y
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_SBITMAP=y
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DYNAMIC_DEBUG_CORE=y
# CONFIG_SYMBOLIC_ERRNAME is not set
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_AS_HAS_NON_CONST_LEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_PAHOLE_HAS_BTF_TAG=y
CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_OBJTOOL=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
# CONFIG_DEBUG_FS_ALLOW_ALL is not set
CONFIG_DEBUG_FS_DISALLOW_MOUNT=y
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_CC_HAS_UBSAN_ARRAY_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ARRAY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_TABLE_CHECK is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
CONFIG_DEBUG_WX=y
CONFIG_GENERIC_PTDUMP=y
CONFIG_PTDUMP_CORE=y
# CONFIG_PTDUMP_DEBUGFS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SHRINKER_DEBUG=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP=y
# CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_KASAN_SW_TAGS=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
CONFIG_HAVE_ARCH_KMSAN=y
CONFIG_HAVE_KMSAN_COMPILER=y
# end of Memory Debugging

# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_NMI_CHECK_CPU is not set
CONFIG_DEBUG_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_DEBUG_MAPLE_TREE is not set
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_LIST is not set
CONFIG_TORTURE_TEST=m
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_CPU_STALL_CPUTIME is not set
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_CGROUP_REF is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_OBJTOOL_NOP_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_HWLAT_TRACER is not set
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_ENABLE_DEFAULT_TRACERS is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
CONFIG_UPROBE_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_SYNTH_EVENTS is not set
# CONFIG_HIST_TRIGGERS is not set
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_RV is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_SAMPLES=y
CONFIG_SAMPLE_AUXDISPLAY=y
# CONFIG_SAMPLE_TRACE_EVENTS is not set
# CONFIG_SAMPLE_TRACE_CUSTOM_EVENTS is not set
# CONFIG_SAMPLE_TRACE_PRINTK is not set
# CONFIG_SAMPLE_TRACE_ARRAY is not set
CONFIG_SAMPLE_KOBJECT=y
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_RPMSG_CLIENT is not set
# CONFIG_SAMPLE_CONFIGFS is not set
CONFIG_SAMPLE_WATCHDOG=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--xJgqUhhEbMFOTMjC
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='boot'
	export testcase='boot'
	export category='functional'
	export timeout='10m'
	export job_origin='boot.yaml'
	export queue_cmdline_keys='branch
commit'
	export queue='bisect'
	export testbox='vm-snb'
	export tbox_group='vm-snb'
	export branch='tj-wq/ordered-cleanup'
	export commit='25aa2ad5c302824d6ff271e4b0030ac92cb99a69'
	export kconfig='x86_64-randconfig-a015-20230417'
	export nr_vm=300
	export submit_id='644721a1991d64e49f2a36d4'
	export job_file='/lkp/jobs/scheduled/vm-meta-44/boot-1-debian-11.1-x86_64-20220510.cgz-25aa2ad5c302824d6ff271e4b0030ac92cb99a69-20230425-58527-12zgbb6-1.yaml'
	export id='5134e022731621d53e4ba198ca55a6c0cb82897e'
	export queuer_version='/zday/lkp'
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='16G'
	export need_kconfig=\{\"KVM_GUEST\"\=\>\"y\"\}
	export ssh_base_port=23032
	export kernel_cmdline_hw='vmalloc=256M initramfs_async=0 page_owner=on'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export compiler='clang-14'
	export enqueue_time='2023-04-25 08:41:05 +0800'
	export _id='644728e7991d64e49f2a36d5'
	export _rt='/result/boot/1/vm-snb/debian-11.1-x86_64-20220510.cgz/x86_64-randconfig-a015-20230417/clang-14/25aa2ad5c302824d6ff271e4b0030ac92cb99a69'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/boot/1/vm-snb/debian-11.1-x86_64-20220510.cgz/x86_64-randconfig-a015-20230417/clang-14/25aa2ad5c302824d6ff271e4b0030ac92cb99a69/3'
	export scheduler_version='/lkp/lkp/.src-20230424-083632'
	export arch='x86_64'
	export max_uptime=600
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/boot/1/vm-snb/debian-11.1-x86_64-20220510.cgz/x86_64-randconfig-a015-20230417/clang-14/25aa2ad5c302824d6ff271e4b0030ac92cb99a69/3
BOOT_IMAGE=/pkg/linux/x86_64-randconfig-a015-20230417/clang-14/25aa2ad5c302824d6ff271e4b0030ac92cb99a69/vmlinuz-6.3.0-rc7-00151-g25aa2ad5c302
branch=tj-wq/ordered-cleanup
job=/lkp/jobs/scheduled/vm-meta-44/boot-1-debian-11.1-x86_64-20220510.cgz-25aa2ad5c302824d6ff271e4b0030ac92cb99a69-20230425-58527-12zgbb6-1.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-randconfig-a015-20230417
commit=25aa2ad5c302824d6ff271e4b0030ac92cb99a69
initcall_debug
nmi_watchdog=0
vmalloc=256M initramfs_async=0 page_owner=on
max_uptime=600
LKP_SERVER=internal-lkp-server
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-randconfig-a015-20230417/clang-14/25aa2ad5c302824d6ff271e4b0030ac92cb99a69/modules.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export schedule_notify_address=
	export meta_host='vm-meta-44'
	export kernel='/pkg/linux/x86_64-randconfig-a015-20230417/clang-14/25aa2ad5c302824d6ff271e4b0030ac92cb99a69/vmlinuz-6.3.0-rc7-00151-g25aa2ad5c302'
	export dequeue_time='2023-04-25 09:12:09 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-meta-44/boot-1-debian-11.1-x86_64-20220510.cgz-25aa2ad5c302824d6ff271e4b0030ac92cb99a69-20230425-58527-12zgbb6-1.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/one-shot/wrapper boot-slabinfo
	run_monitor $LKP_SRC/monitors/one-shot/wrapper boot-meminfo
	run_monitor $LKP_SRC/monitors/one-shot/wrapper memmap
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test $LKP_SRC/tests/wrapper sleep 1
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper boot-slabinfo
	$LKP_SRC/stats/wrapper boot-meminfo
	$LKP_SRC/stats/wrapper memmap
	$LKP_SRC/stats/wrapper boot-memory
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper kernel-size
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper sleep
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time sleep.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--xJgqUhhEbMFOTMjC
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
etDi6LHEZ/sCAAAAAARZWg==

--xJgqUhhEbMFOTMjC--
