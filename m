Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D5FC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 08:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjHJIA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 04:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjHJIA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 04:00:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB48E6B;
        Thu, 10 Aug 2023 01:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691654457; x=1723190457;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=FlS0jQ44T0oeVD/hDIITeUqO9euAQSkoDLL1bMI5Al0=;
  b=AbppBs2l3gHfU/iWiKtEyENdKMTZthjkkdw8WuucO7v2/RzxBVW68s8X
   xyeqkW8IKfF2sZ9HH0xP/q+BUTSZjwwD32g0q7+I0FcIQz2pMhSftRNfZ
   yXsdSTNfaFcF8AwGdJ+lwwkExsP8RCLz6m3xXPc+Ccs0Mf4mIgsVbGof1
   r8DYtp3iTsVvW3eMUin7hgX1rCOskgf/XOr9/YLh9ptHJHNIWui9U6ibb
   UuxAJeUDGelgyDo4J3emRmwpWhxOIR0dXh05itn/ofuu/ub77uTq0sYd0
   nn59XudhclTgAJ8H5OChUfJkU3mncPCllaWhnUCEQjYXFHgC6fIMq/Z68
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="370230239"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="370230239"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 01:00:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="709036069"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="709036069"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 10 Aug 2023 01:00:52 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 01:00:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 01:00:52 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 01:00:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuzjSwKqZpl3GA928eDo1Ro5QQwSdbZ+ryElw0bpvXxnAbUMPHmFNaIPE4OcGZ2THly1Oj8giajQdtQtVKELQMtpFEEbbfeefHcUBP+0e/gc3og1jqVVE+WgMHGzsdfIaKyVrlTNhSp8PTpnUVm4oOKHG4BxrcCozZijhKHKUoIQYhEBdQnYPbKhD5VBNyiTSAcElgk+RGqVdqivxIqrogUQzsPffTNRqo3ZI0dikiRg7UeusR3le56zpl/jtGGXUirLitY9CeGkFuss7IeGP2N8rp+PVkce8Hk6bGeS7IUY4HtSVCEsNFnL/8UnWukCWzlDfvNNQuEXb0qCznJ//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1s97K/tjuo9eg26tZhUOUhgdIFnXEQbJHCBcbaKP4k=;
 b=PmzDRdmXkRa8IuujrqbCv73lwyCtnDk0AduohdJ4ZpuOzi00Etu4IivhyLcGEPJw570pYXOPOMQxvY/r9Dooq/ezzrGs2a19qCoZnrwk9GByYXsLLQMsRIDcKvIki+eUYncIhuzDMJhrJX+qMS+Zkir1wPMxexr+OEhcWsNPatjJWxc/uwHwo/GrbdkqngmquR4OGVGa8N3fbUGjFLGzJESJov0OXhfoLbQSKet7YZNh6F/yddr2m/A6q2NFcbvOuhVnu9kThsjx7bkMd22cZL4JtpAembC+2bH+/Oi9YLJdPDbyG4A93vpwHHSO3cr+9jjH6RWfKyUp0bZU7c7z9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by PH8PR11MB6831.namprd11.prod.outlook.com (2603:10b6:510:22d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 08:00:50 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::1778:c00c:d5ff:da66]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::1778:c00c:d5ff:da66%6]) with mapi id 15.20.6652.028; Thu, 10 Aug 2023
 08:00:50 +0000
Date:   Thu, 10 Aug 2023 16:00:39 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        Christoph Hellwig <hch@lst.de>, <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, <linux-nvme@lists.infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH V3 14/14] blk-mq: add helpers for treating kdump kernel
Message-ID: <202308101503.67a2d533-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230808104239.146085-15-ming.lei@redhat.com>
X-ClientProxiedBy: SG2PR03CA0117.apcprd03.prod.outlook.com
 (2603:1096:4:91::21) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|PH8PR11MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4bfd5c-421e-4478-2565-08db9977e9bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ctvtDt1WjkGF/1EHvZaYjXWx+3j51l7zGgnR2DFTEAtVmunN7Trd+tLrVxlstaJDrHbPzZj20VR2137WpwCtsA2ATM8U9AgoPjWkwfbbpmuf9m0GyqvW07jKS2gDl0L28PwLKx7rk86qrsznz1SZIqHgOf1doZkHHHGt+CN3A8En+o8B+yA1+tuJgeCYs43b63NzYg7uVNHi14q5fz4+QUKMc89BYzj6tqlDQGAHWtlPhEg1VOvcd6dywyV+cAmE5KN9bmngvMaksgnNOOPyyELpta0eMjosj0s7drBGwYyISYmO0ECJbyLbPnvMsZShXnzcJyBFJyimZh3RnJZvDlbsS+hEQkbKrI+hNbRJVy+vv5SRgqpQyVwYUm8W7JqacCaap2iTec7qPT4mwkffy6Mi8W7Ir5YRatpn1+GaNHD/iCIjtNU2lYUaLmvAm4H1ROac1l/smPwYTvCmpbTAfzSeskXsV4TIPejHbhv89JZwmwZsjEnsMyc8LDmIsrYKoc0Ce1XdiHbCqQjXNadqOSTTuPBe4obRouyqwjN20WHAaGdJzHjp4Cob+SjCq7bNGo4NLed5EPXu3rH7ymqebQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199021)(186006)(1800799006)(2906002)(83380400001)(2616005)(41300700001)(54906003)(6666004)(36756003)(316002)(6916009)(4326008)(66476007)(66556008)(66946007)(82960400001)(6486002)(966005)(6512007)(86362001)(38100700002)(26005)(8936002)(8676002)(6506007)(1076003)(5660300002)(7416002)(478600001)(45080400002)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xnNraFzswm/sDAFAJlR2PBhetHVviatWbhx8bBGepRGBAR/zKnjvQbsXrbUW?=
 =?us-ascii?Q?5GAhx8TBTQ1HAu9WFsDq7nHg/pMUwTP6C/iFdJB5ggVEwVwOPb/MJiEv+Kh+?=
 =?us-ascii?Q?yjmPvvYHkMi0V0GISzaUFRbhEAO83uLem8J5UYMN6y8V5iz47cpQOndppTHg?=
 =?us-ascii?Q?ENw596rdIr2SMXKxBTSwNTLY2ZHBUYUQSuy4yUUgALdl8AF0SoDZseRtReIC?=
 =?us-ascii?Q?+snHhYRq3u8QWNuDrgpaAhNFGZhhZfkS2HZnKiahkX2dvJLsVjfPjBhCwaUg?=
 =?us-ascii?Q?gEMlMCUxFaF5a35oOjChcaS63nV581I6Zy9mkiTVj1I+CZOQD+VJ5Meb3kdr?=
 =?us-ascii?Q?TyZ0iNZm1N4ftGs/Slaai+mG8SEYLEN4IH9odgPkOXe+LE2B2mMG9JA3po8y?=
 =?us-ascii?Q?OIUtpzEdIc6hyOBc3W5HLHYEEyOj/7ggSCFry/Zvj2TMidA2MygsDwGsEcZb?=
 =?us-ascii?Q?KPdS69nCEnwxU+0toVJ7O+sdXAOxOe4bc16kQ3R6fXcjDkT2NUxQFJ33OfKU?=
 =?us-ascii?Q?NFM+o7mCibbQuv+LDITq5IrbmrpvmHDhyzLQeqe2nV8wgmNazDqU+aqojAG6?=
 =?us-ascii?Q?/J/yQzZ5lvuoK6JA+YKrpaYx4dHB5zuXos37/OBRiwQNbHMJ0hwrYrcnD5F9?=
 =?us-ascii?Q?YDTc0b6urZ2T+Vl39YAqYLV8C0X1yR0ayGzCgp8OcIIfd3YkjwLImdLFCkVI?=
 =?us-ascii?Q?xyVv7QbUTtpwcqh0L4DQTGIaRCCupcLgoc73JoCxYwKX9serc5rpkZysvJAD?=
 =?us-ascii?Q?VHPL/vPt9hFu01c9DUZAxrs0rvznDX/yw7ISawXePeFzt1DAY/qQwG7WXOpc?=
 =?us-ascii?Q?1tfKR9ezdCJOA7zqnHHWp+A8uuOKRgPzlsze9YDFdneStknU27Fe0X7BNQHf?=
 =?us-ascii?Q?XB0RKXSdyUDFEjLgzZjRws0qXZvAXFrypOJTko1weH9zWsRfvmFqYALxAF56?=
 =?us-ascii?Q?cl/ahPnNqjqAxaxyrnZVjQyFBEcv9r8x2NtehzwBlHUleohXy71iKYORcqN9?=
 =?us-ascii?Q?/ahbl4kgiqtqGPJc4D5Te31H+6aMVXFg+Rny/VoCixhnfHLDAX65YSdMqDuR?=
 =?us-ascii?Q?S87MY4UH1V/ZMcIVIu3cAMCHN1GnalvLy+zKLKOylsAeMYRlLXOTiudMo+sN?=
 =?us-ascii?Q?u6HtBdWvpTk5s+8r75n4zNct0aiTzX+hZV3Q1xTRWJcLAx/pxqP3KUG42swJ?=
 =?us-ascii?Q?PLQdmBMuv+tOzB/uB5vo9wBoCJkKdRpelJ/7Kgf0WiO/fwgsKJjXTEBL3Lw8?=
 =?us-ascii?Q?ycUScTVjdoAuspE96upDvpV3fWOBz/Y1vpJkbLWAgGr0aX+WB1d5/J4vi1Dv?=
 =?us-ascii?Q?UPEg674UIM7fL6+kLxXKKInMYinA09hApntEaajgqRRq0Rs+dpaSXlI0vibG?=
 =?us-ascii?Q?3jKn2flgV38wbrR36MDTZsa+/r/htzULXV400hjzGy2ipJiXnw0gkRJxj7oi?=
 =?us-ascii?Q?gPFd0y8D9aNOPVxUkWZ/Vgxz/0mG/KoPsi+jzllaDUWMZ7VHAIoJcl9p090a?=
 =?us-ascii?Q?7FvwcN78gWyhvK8ryIOBaKxT/sm9EQvV9aYQ6AgVg+eu5yieJRNxSeCRlGMb?=
 =?us-ascii?Q?pSY19g2uSCHw2lV9fioCU4llMhgRMnp4FNS5SzMzdehcMBjORhzaK2Ti/sNm?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4bfd5c-421e-4478-2565-08db9977e9bb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 08:00:50.7538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7JP/X9YPyuu6PJPTZR8jvey4pPFMmo0RsbH0nk4k6u+u85+YcYnZTxMurVJvHGLdVXJQtv8cL3lcEBdqetZrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6831
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Hello,

kernel test robot noticed "WARNING:at_drivers/block/null_blk/main.c:#null_map_queues" on:

commit: 8ec7debf0b62ddf5f62e18b886925462215ab98b ("[PATCH V3 14/14] blk-mq: add helpers for treating kdump kernel")
url: https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/blk-mq-add-blk_mq_max_nr_hw_queues/20230809-003555
base: https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git for-next
patch link: https://lore.kernel.org/all/20230808104239.146085-15-ming.lei@redhat.com/
patch subject: [PATCH V3 14/14] blk-mq: add helpers for treating kdump kernel

in testcase: boot

compiler: gcc-12
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-----------------------------------------------------------+------------+------------+
|                                                           | 27da637b41 | 8ec7debf0b |
+-----------------------------------------------------------+------------+------------+
| boot_successes                                            | 12         | 0          |
| boot_failures                                             | 0          | 12         |
| WARNING:at_drivers/block/null_blk/main.c:#null_map_queues | 0          | 12         |
| EIP:null_map_queues                                       | 0          | 12         |
| BUG:kernel_NULL_pointer_dereference,address               | 0          | 12         |
| Oops:#[##]                                                | 0          | 12         |
| EIP:group_cpus_evenly                                     | 0          | 12         |
| Kernel_panic-not_syncing:Fatal_exception                  | 0          | 12         |
+-----------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202308101503.67a2d533-oliver.sang@intel.com



[    7.742766][    T1] null_blk: tag set has unexpected nr_hw_queues: 1
[    7.744704][    T1] ------------[ cut here ]------------
[    7.745825][    T1] WARNING: CPU: 0 PID: 1 at drivers/block/null_blk/main.c:1615 null_map_queues+0x56/0xdb
[    7.748029][    T1] Modules linked in:
[    7.748923][    T1] CPU: 0 PID: 1 Comm: swapper Tainted: G                T  6.5.0-rc1-00100-g8ec7debf0b62 #10 05d847e43b9b6f584ad59352c89de6920a7d94da
[    7.751662][    T1] EIP: null_map_queues+0x56/0xdb
[    7.753366][    T1] Code: b0 b4 01 00 00 8d 0c 37 39 ca 74 29 8b b8 b0 01 00 00 8b b0 b8 01 00 00 8d 04 37 39 c2 74 16 52 68 6d 34 9b 42 e8 f8 89 84 ff <0f> 0b 31
 f6 5a bf 01 00 00 00 59 8d 43 04 31 c9 31 d2 89 45 f0 3b
[    7.757272][    T1] EAX: 00000030 EBX: 46131e1c ECX: 00000000 EDX: 00000000
[    7.758794][    T1] ESI: 00000001 EDI: 00000001 EBP: 40343e88 ESP: 40343e68
[    7.760257][    T1] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010246
[    7.761810][    T1] CR0: 80050033 CR2: ffd99000 CR3: 0343e000 CR4: 000406d0
[    7.763254][    T1] Call Trace:
[    7.763953][    T1]  ? show_regs+0x60/0x70
[    7.764872][    T1]  ? null_map_queues+0x56/0xdb
[    7.765908][    T1]  ? __warn+0x8c/0x10a
[    7.766754][    T1]  ? report_bug+0xdd/0x13e
[    7.767719][    T1]  ? null_map_queues+0x56/0xdb
[    7.768721][    T1]  ? exc_overflow+0x41/0x41
[    7.769668][    T1]  ? handle_bug+0x2b/0x53
[    7.770532][    T1]  ? exc_invalid_op+0x24/0x6a
[    7.771501][    T1]  ? handle_exception+0x11d/0x11d
[    7.772572][    T1]  ? lockdep_next_lockchain+0x18/0x2b
[    7.773697][    T1]  ? exc_overflow+0x41/0x41
[    7.774604][    T1]  ? null_map_queues+0x56/0xdb
[    7.775593][    T1]  ? exc_overflow+0x41/0x41
[    7.776561][    T1]  ? null_map_queues+0x56/0xdb
[    7.777534][    T1]  ? kmalloc_array_node+0x19/0x28
[    7.778828][    T1]  ? blk_mq_update_queue_map+0x57/0x7e
[    7.779975][    T1]  ? blk_mq_alloc_tag_set+0x1eb/0x353
[    7.781115][    T1]  ? null_init_tag_set+0xd7/0xe6
[    7.782155][    T1]  ? null_add_dev+0x1d9/0x5ef
[    7.783128][    T1]  ? null_alloc_dev+0x7a/0x1c2
[    7.784144][    T1]  ? null_init+0x26d/0x36b
[    7.785126][    T1]  ? do_one_initcall+0x77/0x1b9
[    7.786097][    T1]  ? virtio_blk_init+0xbf/0xbf
[    7.787076][    T1]  ? do_initcalls+0x176/0x1ba
[    7.788080][    T1]  ? kernel_init_freeable+0xe9/0x13c
[    7.792635][    T1]  ? rest_init+0x11d/0x11d
[    7.793557][    T1]  ? kernel_init+0x12/0xf7
[    7.794469][    T1]  ? ret_from_fork+0x1c/0x30
[    7.795465][    T1] irq event stamp: 321017
[    7.796352][    T1] hardirqs last  enabled at (321027): [<41095389>] __up_console_sem+0x59/0x71
[    7.798190][    T1] hardirqs last disabled at (321036): [<41095370>] __up_console_sem+0x40/0x71
[    7.800028][    T1] softirqs last  enabled at (320984): [<41f25ca9>] __do_softirq+0x279/0x2b7
[    7.801854][    T1] softirqs last disabled at (320975): [<4101cf25>] call_on_stack+0x40/0x50
[    7.803562][    T1] ---[ end trace 0000000000000000 ]---
[    7.804950][    T1] BUG: kernel NULL pointer dereference, address: 00000010
[    7.805688][    T1] #PF: supervisor write access in kernel mode
[    7.805688][    T1] #PF: error_code(0x0002) - not-present page
[    7.805688][    T1] *pde = 00000000
[    7.805688][    T1] Oops: 0002 [#1] PREEMPT
[    7.805688][    T1] CPU: 0 PID: 1 Comm: swapper Tainted: G        W       T  6.5.0-rc1-00100-g8ec7debf0b62 #10 05d847e43b9b6f584ad59352c89de6920a7d94da
[    7.805688][    T1] EIP: group_cpus_evenly+0x24/0x2e
[    7.805688][    T1] Code: c9 e9 a1 91 8d 00 55 89 e5 ba 04 00 00 00 f7 e2 70 0e ba c0 0d 00 00 e8 2e 87 b4 ff 85 c0 75 04 31 c0 eb 08 8b 15 a8 1b 34 43 <89> 10 5d
 31 d2 e9 73 91 8d 00 55 89 e5 56 53 8b 1d 84 5f 32 43 85
[    7.805688][    T1] EAX: 00000010 EBX: 46131e38 ECX: 00000000 EDX: 00000001
[    7.805688][    T1] ESI: 00000000 EDI: 00000001 EBP: 40343e58 ESP: 40343e58
[    7.805688][    T1] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010202
[    7.805688][    T1] CR0: 80050033 CR2: 00000010 CR3: 0343e000 CR4: 000406d0
[    7.805688][    T1] Call Trace:
[    7.805688][    T1]  ? show_regs+0x60/0x70
[    7.805688][    T1]  ? __die_body+0x13/0x52
[    7.805688][    T1]  ? __die+0x22/0x2c
[    7.805688][    T1]  ? page_fault_oops+0x4c/0x7f
[    7.805688][    T1]  ? kernelmode_fixup_or_oops+0x8b/0x9d
[    7.805688][    T1]  ? __bad_area_nosemaphore+0x40/0x16c
[    7.805688][    T1]  ? bad_area_nosemaphore+0xa/0x17
[    7.805688][    T1]  ? do_user_addr_fault+0xdd/0x396
[    7.805688][    T1]  ? trace_irq_disable+0x3b/0x4e
[    7.805688][    T1]  ? exc_page_fault+0xf6/0x120
[    7.805688][    T1]  ? pvclock_clocksource_read_nowd+0x167/0x167
[    7.805688][    T1]  ? handle_exception+0x11d/0x11d
[    7.805688][    T1]  ? pvclock_clocksource_read_nowd+0x167/0x167
[    7.805688][    T1]  ? group_cpus_evenly+0x24/0x2e
[    7.805688][    T1]  ? pvclock_clocksource_read_nowd+0x167/0x167
[    7.805688][    T1]  ? group_cpus_evenly+0x24/0x2e
[    7.805688][    T1]  ? blk_mq_map_queues+0xf/0x46
[    7.805688][    T1]  ? null_map_queues+0xbc/0xdb
[    7.805688][    T1]  ? blk_mq_update_queue_map+0x57/0x7e
[    7.805688][    T1]  ? blk_mq_alloc_tag_set+0x1eb/0x353
[    7.805688][    T1]  ? null_init_tag_set+0xd7/0xe6
[    7.805688][    T1]  ? null_add_dev+0x1d9/0x5ef
[    7.805688][    T1]  ? null_alloc_dev+0x7a/0x1c2
[    7.805688][    T1]  ? null_init+0x26d/0x36b
[    7.805688][    T1]  ? do_one_initcall+0x77/0x1b9
[    7.805688][    T1]  ? virtio_blk_init+0xbf/0xbf
[    7.805688][    T1]  ? do_initcalls+0x176/0x1ba
[    7.805688][    T1]  ? kernel_init_freeable+0xe9/0x13c
[    7.805688][    T1]  ? rest_init+0x11d/0x11d
[    7.805688][    T1]  ? kernel_init+0x12/0xf7
[    7.805688][    T1]  ? ret_from_fork+0x1c/0x30
[    7.805688][    T1] Modules linked in:
[    7.805688][    T1] CR2: 0000000000000010
[    7.805688][    T1] ---[ end trace 0000000000000000 ]---
[    7.805688][    T1] EIP: group_cpus_evenly+0x24/0x2e
[    7.805688][    T1] Code: c9 e9 a1 91 8d 00 55 89 e5 ba 04 00 00 00 f7 e2 70 0e ba c0 0d 00 00 e8 2e 87 b4 ff 85 c0 75 04 31 c0 eb 08 8b 15 a8 1b 34 43 <89> 10 5d
 31 d2 e9 73 91 8d 00 55 89 e5 56 53 8b 1d 84 5f 32 43 85
[    7.805688][    T1] EAX: 00000010 EBX: 46131e38 ECX: 00000000 EDX: 00000001
[    7.805688][    T1] ESI: 00000000 EDI: 00000001 EBP: 40343e58 ESP: 40343e58
[    7.805688][    T1] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010202
[    7.805688][    T1] CR0: 80050033 CR2: 00000010 CR3: 0343e000 CR4: 000406d0
[    7.805688][    T1] Kernel panic - not syncing: Fatal exception
[    7.805688][    T1] Kernel Offset: disabled



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230810/202308101503.67a2d533-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

