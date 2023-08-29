Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA39C83F14
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 07:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbjH2HjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 03:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbjH2HjF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 03:39:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC1719F
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 00:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693294742; x=1724830742;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=cffIh1r7J4yK9VeI5WUmX+Og8oZ5H7acamD7kt+8WdY=;
  b=gYfJmjTu6UHyni9tKc0MIXf5qPjYWCkgkbpj0nfDGmKrn/6D0fatmEQ8
   6eDOYTK8Xo27gS99IQ4WeXL4T3Ec8dQnQcBz6ATbEBafWU0KES/suzl7d
   B8pUszaLhfRfUnWJ0zUbK6PVShHr/rtmjnN2Kpbc3I4UVAjyBqroPl0oE
   UfFFjpmEepi7YQ+XAYYZcQp37gEY4Lh3nHlYu4d2OYnPPl9UyUr7BGFWc
   lLlXLiRSGAyl2BGqjZfNsKmYxiaXQNDgCJ/251xbge5XX7IGAICW1oHf4
   FWdWKrPHf+afvYgV0/8atgQHr7roy7GeTQ28XgBlsPGymhU119sKBdg24
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="439253793"
X-IronPort-AV: E=Sophos;i="6.02,210,1688454000"; 
   d="scan'208";a="439253793"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 00:39:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="808582192"
X-IronPort-AV: E=Sophos;i="6.02,210,1688454000"; 
   d="scan'208";a="808582192"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2023 00:39:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 29 Aug 2023 00:39:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 29 Aug 2023 00:38:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 29 Aug 2023 00:38:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 29 Aug 2023 00:38:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvNLmwEd81qgn2tek5eMJQFf8h+JykKunT0wzgSXJJDvm1WScF/OfY/Jrg4YDfSLzbsFmGVH6o0A5ncquNHe3QOQS7G2JiWampfS+w2eHZ2PSeu8tMjfahMjnGRZ6MPWutmoigEsFySyV2VAJhctFlnumUfaEWXtQANF3+IsA9eWWjHMIqLS6uNHy34+mh3JiKC11OTVcQ9BD+Q5pO6lZDVFREHxzIrJ9UEjZAL+WOyZUPrvtDk/5vGtz7bCKfYTCCQ5ImJ+k0OHVXWd0gyV5bxJ0WEcHV5/D25eB16kr6mYEYyUaeZnq/f8AZgSz0BGAmSbhkIX3FyIwt9YPRaXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q80qn+hQ41eVYNHm0zhrPRSO3mnKCUSQ15MQ9BORv7M=;
 b=KmHPYlw+zn3AHe1+HTqyC+ITm/WlKv4vCMjImLcjaG31s2hEv4oIJEbREKR0/vKwFKvgxHe7sRW5px8AYRND2/dM6vIEy2TsO4uBjl6oVVf80LFXQiLouh1B65o+hDathhzaYwjY9sdNP9FmOMeRAnu+WvIItoeHf/eo1TU3G70e1yXkeL4vsJKHZvC6GwPdcqbS2RhIoIHK/ZwgJ9oGARqtoB3G/KXVSYN7ox0YhjdGqioOi5PlM56UaMeOmVD30MS6AN034wUdi/Y0sa9V0PPpXRPnPkVQKx48229GHsJwSOS6u3Gw3UjVD5eY7D+4G/eZN84hpfZLi8UKg4vjuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by PH7PR11MB5960.namprd11.prod.outlook.com (2603:10b6:510:1e3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34; Tue, 29 Aug
 2023 07:38:57 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6699.034; Tue, 29 Aug 2023
 07:38:57 +0000
Date:   Tue, 29 Aug 2023 15:38:48 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        <linux-scsi@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [bvanassche:block-for-next] [scsi]  b4cd894093:
 BUG:kernel_NULL_pointer_dereference,address
Message-ID: <202308291549.d323e980-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR06CA0011.apcprd06.prod.outlook.com
 (2603:1096:4:186::16) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|PH7PR11MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: e50a0af7-0730-4901-3bee-08dba86300ac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75D1T0o64OWk7uBHjXi3HoQ9Ucibc1QBJEXL6wydAfWMq9/7C4FU+RblXKLGTKdM+9bmbwtrSnKi/gsS2mGBon3jOnBYoa0JALcBIODvNjuwipFZDWKYTrm0XosCfIt91qPE2I8IGzmsXiweoQHmOTGltTo43NRYL4tgOjftikwbt/UilAJqOT1vVpXJCL22FEbLxmvYqLhjNTcfTLzBdaMyfgm78aDRms7NKI8klV2hE8+QijA/bPOmcKO6JcMNgAtLt4HPKkXeyGbdvBIsfE9vJhppx0wo1+GZc0FVEuclZkTkyYLHPB62GKdMI1VpWfr9gLOkHTciho7+HWPboQfcec36Zb6GlAH2uLpu1vQiSp/16Ii6ycRWCusR3rFtKS7SwsjZQ+f9A6io/KJsXoYA4N90WgJ7GkJR45oNXUdJjtk7YF1SbxXGQ4iMQxlmK0mUT66jwOMZ3DJZv4oS8LcHZpVi/KVG5O39DQU3LnunCKFlUUg2OT9435UPBZgi2zfF6OZIj//iah9DJbLD6rqRV1lbABW1NLjhqltBmgmEqFEs1nxsdPBaGX3hU7pyDpRDL4avk+UNjV76kmKbjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199024)(1800799009)(186009)(8676002)(8936002)(4326008)(6916009)(2906002)(54906003)(66946007)(66556008)(66476007)(316002)(36756003)(5660300002)(26005)(41300700001)(6486002)(6506007)(1076003)(2616005)(6512007)(107886003)(45080400002)(38100700002)(966005)(478600001)(82960400001)(6666004)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dD1MQ8k4HprmvNulXI01JWgpNanCiTlDjO5GCENmyPa5yPFkvHKTlOHN81Sv?=
 =?us-ascii?Q?ahntEJrxyn1DBIAWPBXQMPxVvXUWJdWlOF1rcML+7atk5eh485qW/GfcmYWD?=
 =?us-ascii?Q?ho8PovOPRFoiPrvVk/XR7wBn6R1hwQJAeC1ztTb87jFnkkKv0SRQXI/gLWin?=
 =?us-ascii?Q?30isy+ol2uXXSpQunerId3mAT3WM+5x7Y2DGKuAD6ohU6UVCwU/FYUmVyR8M?=
 =?us-ascii?Q?hQQMqFrwHguF64Isp19nLlR0nSzuIISLrIk0LnSr3OeBPBJZC74YkfQ7dkWf?=
 =?us-ascii?Q?a69+87e42DzdhjeTtSSrQ2RgJVRaMyTA9CIDXiwM8y07RFLYXaYQWz+ooOJO?=
 =?us-ascii?Q?zj9OZSbj/zDXUOnQ3k1KUptxaHeB9xvxcIilbQTchX2CgbB+4UsW4x7rBsob?=
 =?us-ascii?Q?Aj4Kt/cIvjwmbt1sFqLt61WDF1ikoOnvyu5AD1sVUclIVtg+Di52TaZqnb4D?=
 =?us-ascii?Q?Wdwg/FXlPKURoFOciQcRU9fVNjcfLQ13au2/vd/NL5UshXcjxQnUTrbLAOv7?=
 =?us-ascii?Q?6VWzox6Cd6Ij82lJR10ANq1QpMgOVm+tGmgymNOEbKYEIbS2ql3BGnOlou8u?=
 =?us-ascii?Q?GHmaD+MuKHtoWP3/flYyrDjf/00D/hwyiNWGQEStuffPC41Esm9zg0gTWfbC?=
 =?us-ascii?Q?631byIwOMI5j+t/IQXInPy8CJBrxdB1pXi0E6D1yqgUhiTtrt5fA6ZOlrlbX?=
 =?us-ascii?Q?NXKwvcUy68fr/oBVH9wJ9Z5OEUdNDA7AjrzGGVg5TNPCfToMZgSJoELUXCV2?=
 =?us-ascii?Q?JMIxObN2GYA1G/z/D8NrZ99lY1ZyJclkyudT/HjAnsVTFR6qCw+UEC6uSqEu?=
 =?us-ascii?Q?m9LmQlVVZuEoOORou923UdC5tfjnN2D5RBASzyooJpDjnkf0gMolSGMu7B6f?=
 =?us-ascii?Q?3jQAbHaroc4hThKHGCddMq7oqMoJQ4SFchqHlALlUGkFZCDdQE/SLYgP+OZF?=
 =?us-ascii?Q?EQdVRAJPbVuoXyA1yCz77J6VFLvrLKoa4tUzZS0B4ergPriTbCkxOrPrPrrO?=
 =?us-ascii?Q?IMF0V5wMYeYHjIZ8pi6lprvI/XYEK6yW1P28y5IMJ7GUIMK1Gm5sQPmZXCWw?=
 =?us-ascii?Q?YgJprKBSlAMVeiyCtfX5bOtLTX+DPnH7rs4mnKeJ1fHe8ZFyT7tP6m/G+ajC?=
 =?us-ascii?Q?Fdf5N9AK4GfroDaCsVXwQy/Y5A4craGKm5HajeFn8S75Q53coPB3qpf8C9AF?=
 =?us-ascii?Q?ZeZO9jvKxKiGTdviwGOGMAfFHLKGN8C7nLogFpHtNilI3HP0hl6H7Uv+oKSR?=
 =?us-ascii?Q?NeRZrycn4j4kkb/QnP2yqtTZMesSKU+I5KDfBwju38kFNZt+9TgosN2ocg4z?=
 =?us-ascii?Q?kvfQC/YBV4A0ofgM4CyYPrwJTMPwu3aPI/mtKiWNYTdfUpcXVKCKUqmmR4Nr?=
 =?us-ascii?Q?VRbUlu+1aFzUFLdGmZL/CmB8wUmzzPUGIMj1wJku1EGynxMBDFd72pC0vWDz?=
 =?us-ascii?Q?KfBcOHcexuIKyO5OpoECwH53cCnMOGcb40XI4t3BMM3Rv+vNpEfNKBJBegsM?=
 =?us-ascii?Q?nyYAWtaj2EDgNf5KS/vck/F5dhHOafGrBivB5NSN9t5l6z/Y6jz1S4pDKQ4M?=
 =?us-ascii?Q?jna8V3Y42rSvXYMOYITYLAzmI0tAigyL6zgFlr55OysUJUghE7U8tQiYvdUC?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e50a0af7-0730-4901-3bee-08dba86300ac
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2023 07:38:57.4631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zyKhOF/0Ae6mcf8twautfQb9nQqHZsfMAZx1+BsYmkqYt7kIPPooNDYomfS2Cb3gD6BKgid3mIRdiAKUjYJchQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5960
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: b4cd894093d32204e911d4bac07fbbe7cd9e60ce ("scsi: core: Introduce a mechanism for reordering requests in the error handler")
https://github.com/bvanassche/linux block-for-next

in testcase: boot

compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------------+------------+------------+
|                                             | 15dcd22cb3 | b4cd894093 |
+---------------------------------------------+------------+------------+
| boot_successes                              | 19         | 0          |
| boot_failures                               | 0          | 20         |
| BUG:kernel_NULL_pointer_dereference,address | 0          | 20         |
| Oops:#[##]                                  | 0          | 20         |
| RIP:scsi_call_prepare_resubmit              | 0          | 20         |
| Kernel_panic-not_syncing:Fatal_exception    | 0          | 20         |
+---------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202308291549.d323e980-oliver.sang@intel.com


[    6.360846][  T118] BUG: kernel NULL pointer dereference, address: 00000000000000c0
[    6.361947][  T118] #PF: supervisor read access in kernel mode
[    6.362752][  T118] #PF: error_code(0x0000) - not-present page
[    6.363560][  T118] PGD 800000035271b067 P4D 800000035271b067 PUD 0
[    6.364435][  T118] Oops: 0000 [#1] SMP PTI
[    6.365052][  T118] CPU: 0 PID: 118 Comm: scsi_eh_1 Not tainted 6.5.0-rc7-00153-gb4cd894093d3 #1
[    6.366200][  T118] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 6.367514][ T118] RIP: 0010:scsi_call_prepare_resubmit (drivers/scsi/scsi_error.c:2200 drivers/scsi/scsi_error.c:2226) 
[ 6.368392][ T118] Code: 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 18 48 8b 07 48 39 c7 74 36 48 89 fd 48 8d 58 f8 48 8b 03 48 8b 80 20 02 00 00 <48> 8b 80 c0 00 00 00 48 85 c0 74 0c 48 89 df e8 c2 f6 59 00 84 c0
All code
========
   0:	83 ec 20             	sub    $0x20,%esp
   3:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
   a:	00 00 
   c:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  11:	48 8b 07             	mov    (%rdi),%rax
  14:	48 39 c7             	cmp    %rax,%rdi
  17:	74 36                	je     0x4f
  19:	48 89 fd             	mov    %rdi,%rbp
  1c:	48 8d 58 f8          	lea    -0x8(%rax),%rbx
  20:	48 8b 03             	mov    (%rbx),%rax
  23:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  2a:*	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax		<-- trapping instruction
  31:	48 85 c0             	test   %rax,%rax
  34:	74 0c                	je     0x42
  36:	48 89 df             	mov    %rbx,%rdi
  39:	e8 c2 f6 59 00       	callq  0x59f700
  3e:	84 c0                	test   %al,%al

Code starting with the faulting instruction
===========================================
   0:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
   7:	48 85 c0             	test   %rax,%rax
   a:	74 0c                	je     0x18
   c:	48 89 df             	mov    %rbx,%rdi
   f:	e8 c2 f6 59 00       	callq  0x59f6d6
  14:	84 c0                	test   %al,%al
[    6.370771][  T118] RSP: 0000:ffffb19a40493df0 EFLAGS: 00010202
[    6.371593][  T118] RAX: 0000000000000000 RBX: ffff9aa0177120f8 RCX: 0000000000000000
[    6.372648][  T118] RDX: 0000000000000000 RSI: 0000000000000206 RDI: ffff9aa01829bd80
[    6.373707][  T118] RBP: ffff9aa01829bd80 R08: 0000000000000000 R09: 0000000000000000
[    6.374741][  T118] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    6.375790][  T118] R13: ffff9aa01829bd80 R14: 0000000000000206 R15: 0000000000000000
[    6.376909][  T118] FS:  0000000000000000(0000) GS:ffff9aa32fc00000(0000) knlGS:0000000000000000
[    6.378126][  T118] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.378965][  T118] CR2: 00000000000000c0 CR3: 0000000116d94000 CR4: 00000000000406f0
[    6.380007][  T118] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.385149][  T118] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    6.386254][  T118] Call Trace:
[    6.386808][  T118]  <TASK>
[ 6.387282][ T118] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434) 
[ 6.387845][ T118] ? page_fault_oops (arch/x86/mm/fault.c:707) 
[ 6.388500][ T118] ? exc_page_fault (arch/x86/include/asm/irqflags.h:37 arch/x86/include/asm/irqflags.h:72 arch/x86/mm/fault.c:1494 arch/x86/mm/fault.c:1542) 
[ 6.389166][ T118] ? asm_exc_page_fault (arch/x86/include/asm/idtentry.h:570) 
[ 6.389872][ T118] ? scsi_call_prepare_resubmit (drivers/scsi/scsi_error.c:2200 drivers/scsi/scsi_error.c:2226) 
[ 6.390643][ T118] scsi_eh_flush_done_q (drivers/scsi/scsi_error.c:2262) 
[ 6.391338][ T118] ata_scsi_port_error_handler (drivers/ata/libata-eh.c:754) libata
[ 6.397364][ T118] ? __pfx_scsi_error_handler (drivers/scsi/scsi_error.c:2345) 
[ 6.398111][ T118] ata_scsi_error (include/linux/list.h:292 drivers/ata/libata-eh.c:549) libata
[ 6.398877][ T118] scsi_error_handler (drivers/scsi/scsi_error.c:2402) 
[ 6.399561][ T118] kthread (kernel/kthread.c:389) 
[ 6.400139][ T118] ? __pfx_kthread (kernel/kthread.c:342) 
[ 6.400778][ T118] ret_from_fork (arch/x86/kernel/process.c:151) 
[ 6.401411][ T118] ? __pfx_kthread (kernel/kthread.c:342) 
[ 6.402051][ T118] ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 
[    6.402716][  T118]  </TASK>
[    6.403190][  T118] Modules linked in: ppdev rapl drm_kms_helper drm_ttm_helper ata_piix ttm parport_pc parport joydev drm libata serio_raw i2c_piix4
[    6.404866][  T118] CR2: 00000000000000c0
[    6.405461][  T118] ---[ end trace 0000000000000000 ]---
[ 6.406196][ T118] RIP: 0010:scsi_call_prepare_resubmit (drivers/scsi/scsi_error.c:2200 drivers/scsi/scsi_error.c:2226) 
[ 6.407046][ T118] Code: 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 18 48 8b 07 48 39 c7 74 36 48 89 fd 48 8d 58 f8 48 8b 03 48 8b 80 20 02 00 00 <48> 8b 80 c0 00 00 00 48 85 c0 74 0c 48 89 df e8 c2 f6 59 00 84 c0
All code
========
   0:	83 ec 20             	sub    $0x20,%esp
   3:	65 48 8b 04 25 28 00 	mov    %gs:0x28,%rax
   a:	00 00 
   c:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  11:	48 8b 07             	mov    (%rdi),%rax
  14:	48 39 c7             	cmp    %rax,%rdi
  17:	74 36                	je     0x4f
  19:	48 89 fd             	mov    %rdi,%rbp
  1c:	48 8d 58 f8          	lea    -0x8(%rax),%rbx
  20:	48 8b 03             	mov    (%rbx),%rax
  23:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  2a:*	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax		<-- trapping instruction
  31:	48 85 c0             	test   %rax,%rax
  34:	74 0c                	je     0x42
  36:	48 89 df             	mov    %rbx,%rdi
  39:	e8 c2 f6 59 00       	callq  0x59f700
  3e:	84 c0                	test   %al,%al

Code starting with the faulting instruction
===========================================
   0:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
   7:	48 85 c0             	test   %rax,%rax
   a:	74 0c                	je     0x18
   c:	48 89 df             	mov    %rbx,%rdi
   f:	e8 c2 f6 59 00       	callq  0x59f6d6
  14:	84 c0                	test   %al,%al


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230829/202308291549.d323e980-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

