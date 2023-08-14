Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F413C04A6A
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 14:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjHNO0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 10:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjHNO0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 10:26:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F334CB2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 07:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692023183; x=1723559183;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=BHJlxgjFngrsX4D/cQ9gbPz0CX4TISDy0HL8Qt2Dd90=;
  b=FsAkzDieCo7sHWd1YJmzA6pAeFskOlDbNGf78JfJtFGGoVD4313q9xbl
   1ZzSMD/BqykFNA7W8yPzwSHWPv6fX4TM4bqRutH1s8p5TpR9q8HNYNAOa
   TX8bXHIQz0AvTBqMzET7W9lXcmuSbUfhPfWqvb0cp7eXQGKz9FCPsmca1
   XeWlKAWW2Ab1c5t8QNLy5oOR4j8jbpyyaPDhW/KuepXtnmQzBDanyLZnT
   wE0I2+BaZqWK8FrlA1Cm/JPb+njsuxlHR5MgftXy5FKanxwOnFHVsNGS9
   gv8I8qeqr3Cv0ORbJO5LWWuH3cDYzPF2uHNK4oV7c0A81POyKg5E+WwXi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="372043256"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="372043256"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 07:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="876954122"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 14 Aug 2023 07:26:27 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 07:26:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 07:26:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 07:26:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0UAzkqjBzTnMaW0tfIUW8MjZpsXLboZG6okAZvmS5fQ5alJGvxd2Dm4vKzzEi4QhkmK/YX9kcZJNwAyfQuwu3rDzvXm5BOJRiwyJnvEsePruhjhBY336se5iYU+dPCEiX2ko19Ttke2gCyRw9OPiDwy07kWcGxjRd3nZl+DZRxESXwnAgVs4u0q+Rpl3sY+uCX58SE2WjK8v0tKcPB3IvvDMbTH6j7XZ2GYobV0JrdKJt2yoRaTntfOaTzsRWLoss+9x/d3ghwVR3p14L4Lbe60DzgjaRVGWqMPlu2+ltG8z/zv/gXkIKXF/TGbKDmS+FmgEuctsR31e9aFGg1hWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McNKDAxCY+sVg6ttc1VuIwwDiKHXKXCeqP0pLQ/6kDs=;
 b=Gq15Z4U4CIe767gpyNgvmHYVNR3YEJqX1M9yLuoEGTTKG265mHxzr2qmSx3RW/jJ5D3KQCydJ6vaPZMBGwbZa1rtmg08+p2SY8xEq30lAw+TPppBbmxQCNwbTvGKB/Yd0QYHJPw6IPCb46tguuWktEb6KbGT3UhcRAydkk9Qf8oBoj7Bqy8k9MRM4BAMIOljrDtnFVaNyFt2gAfMT2T8Yb/+f7I80HfJoMhyQNfyr3ZHuobxme6fd4UeQrFdara6R7uNT5AjiWHstci2dPodwq4vIMzoWo/mFjQfYJ7ePzqMUYw37pyxpflGDpcmydeQ1+i/43c67OAPnqQL/nRT/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by MN0PR11MB6182.namprd11.prod.outlook.com (2603:10b6:208:3c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 14:26:18 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 14:26:17 +0000
Date:   Mon, 14 Aug 2023 22:26:07 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        <linux-scsi@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [bvanassche:block-for-next] [scsi]  a034ed36f6:
 BUG:kernel_NULL_pointer_dereference,address
Message-ID: <202308142205.fe3e80ec-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|MN0PR11MB6182:EE_
X-MS-Office365-Filtering-Correlation-Id: 4375751d-f9ca-4d02-02f6-08db9cd26c51
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYyAiClxgyurVKWZ2qiWsQClbSCQ9zaBFgGeVx2fM9LWVQIw8EudoI+hly4G8vUU3EQPG2HYl2Y3IBHEvVD+IO4AWPJ+1L3inepTNXFRSF7VOOsINY2/lxU+ejHr/1wbzpFiWwptMCX+4iVgn/h2lZ5tJDN66H0TKcOWKtxU76EOnP/PwU2RhQ8jNg9/r+RgUpoLf1QmuVf8Ly2V8jfVdi8PmBn6TR8k98eZ5kRdIwnjUdKDAVpEKxCv6k/ncLz3zIbrc/qJPL2MaWgfacg/f8BilhjWvK1s8lj1z4qHEvYtTWQ+mLl4Fe/Gkq03chs7PU8S/iPRCziUznxmoLz5M5QIjBhDVYmHtp+UATp3gOZwFId8UzIIEPO1xCrmuRkvSg0Z/7YGK7LYtcX0oFaBjk176H0ZeotdsgNjfim5uvmV1G/Hiij1X7M7k+I0XKE4jxnjxjRseWjUcxOIASgEXxL+AbBerV+cp5uOvlRdjJaX2rxsOI4UUI+3nRF5rJNRdDcVW+avDFNKZ+VHZAkT9zbGTbY6t3N1Qka5d/WKVZaxot+QVurJw9KhpGTd+t48FFGZF+4DSLqgpGlnuY9n4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199021)(186006)(1800799006)(36756003)(5660300002)(2906002)(86362001)(83380400001)(66476007)(66556008)(6916009)(4326008)(66946007)(54906003)(38100700002)(316002)(41300700001)(107886003)(1076003)(26005)(2616005)(6512007)(6486002)(6506007)(45080400002)(8936002)(6666004)(478600001)(966005)(82960400001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sbPytT6L4SH4vhawOFCt/7FJ20S4BAVPAc1/kv8trF5o5O7plwYD/qFNOSv5?=
 =?us-ascii?Q?YxgwCOIeKMK0LZPo3jS8O8vGBw9bnyC/7hVjPb2EfD5xRa/2KrF20dym8Kxd?=
 =?us-ascii?Q?rO5tZaWsC2CW/WXcwHS4ZNPjYrvWv9zVVhVTy/F6h8+4i1L1xFtU3PgAezZy?=
 =?us-ascii?Q?jrgFR7Tiozc+To+rg6mUjElH/H7HKbB6MK9YL06OoEWXkcB8lRMRaDEKtOSk?=
 =?us-ascii?Q?EKH68QGp+J3jhg8scsnoUqFZqHCwsa7XdMa9JIklS2lcdd/SNRyes/xYCI4Q?=
 =?us-ascii?Q?ZDcljxvCt25P2OyoMSHZQ8UlhWSp8mH2HDwwC1hOZS006ESRjABN51/i/Je1?=
 =?us-ascii?Q?muB4dxoogKgWVkuM+6SFwlaJBXw6IXCcusKaZu/GMVhV14zxrfczkceCRbPT?=
 =?us-ascii?Q?V7tHl+jnmw1q8wjlS7YB9wr0BGNXDmCkjWoG1eaKaZt03DFnNrEhGhWsltcz?=
 =?us-ascii?Q?gSm6PUCzzc6AN250ej4MSzpI4TsrAc7nXBLJ7+4W3dy4239RGNrR+GgwsR8p?=
 =?us-ascii?Q?IBXoU6kqqAsRPIH9ivb28t34socuTP6NRf5jFV2iN6o9kgu8i1rAffa9DLG7?=
 =?us-ascii?Q?P5YTPVZeE9qUlTxRx1Xbx3jYfIuE+u2qVIGhtw/570LOlQLXeJf4d/SMD5NC?=
 =?us-ascii?Q?OG4aQJh15XPHe4WIOuFh4kko8Dx0VRzxpYVog57Qoz9qXInyOASfx2tH2V4w?=
 =?us-ascii?Q?SWRR1g7HwuLVHw0G7fx+tGyNWYYfvgyxoQkKxwtFTrUSvE+feHMcy1cR9Q3U?=
 =?us-ascii?Q?Ksk0amI/ehMxZYvHIs5KrrN+etbz/J0nu6GHGKWVOdO9jgTFJwnI9IXlKNHQ?=
 =?us-ascii?Q?45Du0wRzYyXGHCNFr3MOe2wYAbyPTZMuJyRSU1AVbHxcAbXz+VwM/2E9DfLv?=
 =?us-ascii?Q?wQSSJAhSSQT8v47Pih0ogJug6F2ELP3GKSOuHOEesDIgmrtpdR1WPwVGK0dZ?=
 =?us-ascii?Q?D1r35OTP7p8hkth4Oe6l66NJZ8EXRvrXTGK1lm+R+ikGixfTD+0AfCrjfB0w?=
 =?us-ascii?Q?EvMMHmXj/4GztSSeEKKrypHdz2wOIVPGbL/dXYeOqHANXUFHFr5Gp5MkZ3rj?=
 =?us-ascii?Q?bsVwSQgoyr7V/qtWs+peYBMDfR+z9xdcEmSNYBQGo7xeohYewDzcQFgz+pLA?=
 =?us-ascii?Q?K+9sEENiM1X5whJ551GFoLpmhv2jyD6ud9b6FzCRDm/Re4rPAQSBbiTh6okH?=
 =?us-ascii?Q?8mR3LmhB9lj/pvSSFue2aVf+yhMyoekEktFVqlR20rImB+w7Ye9uKjgjgHjb?=
 =?us-ascii?Q?GihaqhvNiVUlqV6hCn9utua3CV4+WhoMPm5HzmjthkCtvhPBECCOhHHkc3UV?=
 =?us-ascii?Q?Vl1iBNQEkMg209dkcyld9p3nDlhsYisTlhl3gQkEXqnCpy7wyr5LQCvvhBVX?=
 =?us-ascii?Q?ctQx2TmDAw7DKw1FumEArQ5CMLUEt3fSg5Z7lgCKM4ma6nSGMwZHx5WGLqn5?=
 =?us-ascii?Q?ta354JHGkfzR1GhUV3FhH4gqL6IoUXNS+9KS99ziozKy5Vo9b7rrRwBu8JkT?=
 =?us-ascii?Q?j0u+e25b9vldu5w9LoK/JgFk2cQQkwHgQsdFyxf5evQTmmrGByyu4gIXSOgk?=
 =?us-ascii?Q?c1Ajqg5RA3XmBIAEmPN5IXAsSr0BRElwTEGv9xNxvIEbsW7KPqjK7tNAs67h?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4375751d-f9ca-4d02-02f6-08db9cd26c51
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 14:26:17.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgqiqSzxrGCoqoL3IzkcIeV4fc89T26XnZaFAVQA+yjh+ae7yT/53vkPffAXgps6sDbjNu+neBQsLq3qqB4w3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6182
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: a034ed36f6462d88aeb8738931398a34a0ecf5f8 ("scsi: core: Call .eh_prepare_resubmit() before resubmitting")
https://github.com/bvanassche/linux block-for-next

in testcase: boot

compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------------+------------+------------+
|                                             | e4c5981e9c | a034ed36f6 |
+---------------------------------------------+------------+------------+
| boot_successes                              | 13         | 0          |
| boot_failures                               | 0          | 12         |
| BUG:kernel_NULL_pointer_dereference,address | 0          | 12         |
| Oops:#[##]                                  | 0          | 12         |
| RIP:scsi_call_prepare_resubmit              | 0          | 12         |
| Kernel_panic-not_syncing:Fatal_exception    | 0          | 12         |
+---------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202308142205.fe3e80ec-oliver.sang@intel.com



[    4.517792][  T681] ata2: found unknown device (class 0)
[    4.519992][  T681] ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[    4.525033][   T31] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.5+ PQ: 0 ANSI: 5
[    4.549819][  T681] BUG: kernel NULL pointer dereference, address: 00000000000000c0
[    4.551823][  T681] #PF: supervisor read access in kernel mode
[    4.553329][  T681] #PF: error_code(0x0000) - not-present page
[    4.553794][  T681] PGD 0 P4D 0
[    4.553794][  T681] Oops: 0000 [#1] PREEMPT SMP PTI
[    4.553794][  T681] CPU: 0 PID: 681 Comm: scsi_eh_1 Not tainted 6.5.0-rc5-00182-ga034ed36f646 #1
[    4.553794][  T681] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[    4.553794][  T681] RIP: 0010:scsi_call_prepare_resubmit+0x8f/0x152
[    4.553794][  T681] Code: 8b 80 20 02 00 00 31 c0 f3 ab 48 8d 45 08 49 39 c5 74 17 48 8b 45 00 4c 3b 80 20 02 00 00 75 0a 48 8b 6d 08 48 83 ed 08 eb e0 <49> 83 b8
 c0 00 00 00 00 75 0d 48 8b 45 08 48 89 ee 48 8d 50 f8 eb
[    4.553794][  T681] RSP: 0000:ffffc90001307e00 EFLAGS: 00010246
[    4.553794][  T681] RAX: ffff888129413d80 RBX: ffff888129410000 RCX: 0000000000000000
[    4.553794][  T681] RDX: ffff888129413d78 RSI: ffff888129a8d0f0 RDI: ffffc90001307e10
[    4.553794][  T681] RBP: ffff888129413d78 R08: 0000000000000000 R09: 0000000000000000
[    4.553794][  T681] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90001307e00
[    4.553794][  T681] R13: ffff888129413d80 R14: ffff888129413dd8 R15: 0000000000000001
[    4.553794][  T681] FS:  0000000000000000(0000) GS:ffff88842fc00000(0000) knlGS:0000000000000000
[    4.553794][  T681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.553794][  T681] CR2: 00000000000000c0 CR3: 0000000002432000 CR4: 00000000000406f0
[    4.553794][  T681] Call Trace:
[    4.553794][  T681]  <TASK>
[    4.553794][  T681]  ? __die_body+0x1e/0x5c
[    4.553794][  T681]  ? page_fault_oops+0xf3/0x13c
[    4.553794][  T681]  ? kernelmode_fixup_or_oops+0xa4/0xb0
[    4.553794][  T681]  ? __bad_area_nosemaphore+0x43/0x1bc
[    4.553794][  T681]  ? exc_page_fault+0xfd/0x116
[    4.553794][  T681]  ? asm_exc_page_fault+0x26/0x30
[    4.553794][  T681]  ? scsi_call_prepare_resubmit+0x8f/0x152
[    4.553794][  T681]  scsi_eh_flush_done_q+0x15/0x10d
[    4.553794][  T681]  ata_scsi_port_error_handler+0x486/0x4ff
[    4.553794][  T681]  ? scsi_unjam_host+0x1b0/0x1b0
[    4.553794][  T681]  ata_scsi_error+0x95/0xbe
[    4.553794][  T681]  scsi_error_handler+0x14c/0x1ca
[    4.553794][  T681]  kthread+0xf6/0xfe
[    4.553794][  T681]  ? kthread_complete_and_exit+0x1f/0x1f
[    4.553794][  T681]  ret_from_fork+0x25/0x37
[    4.553794][  T681]  ? kthread_complete_and_exit+0x1f/0x1f
[    4.553794][  T681]  ret_from_fork_asm+0x11/0x20
[    4.553794][  T681]  </TASK>
[    4.553794][  T681] Modules linked in:
[    4.553794][  T681] CR2: 00000000000000c0
[    4.553794][  T681] ---[ end trace 0000000000000000 ]---
[    4.553794][  T681] RIP: 0010:scsi_call_prepare_resubmit+0x8f/0x152
[    4.553794][  T681] Code: 8b 80 20 02 00 00 31 c0 f3 ab 48 8d 45 08 49 39 c5 74 17 48 8b 45 00 4c 3b 80 20 02 00 00 75 0a 48 8b 6d 08 48 83 ed 08 eb e0 <49> 83 b8
 c0 00 00 00 00 75 0d 48 8b 45 08 48 89 ee 48 8d 50 f8 eb
[    4.553794][  T681] RSP: 0000:ffffc90001307e00 EFLAGS: 00010246
[    4.553794][  T681] RAX: ffff888129413d80 RBX: ffff888129410000 RCX: 0000000000000000
[    4.553794][  T681] RDX: ffff888129413d78 RSI: ffff888129a8d0f0 RDI: ffffc90001307e10
[    4.553794][  T681] RBP: ffff888129413d78 R08: 0000000000000000 R09: 0000000000000000
[    4.553794][  T681] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90001307e00
[    4.553794][  T681] R13: ffff888129413d80 R14: ffff888129413dd8 R15: 0000000000000001
[    4.553794][  T681] FS:  0000000000000000(0000) GS:ffff88842fc00000(0000) knlGS:0000000000000000
[    4.553794][  T681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.553794][  T681] CR2: 00000000000000c0 CR3: 0000000002432000 CR4: 00000000000406f0
[    4.553794][  T681] Kernel panic - not syncing: Fatal exception
[    4.553794][  T681] Kernel Offset: disabled



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230814/202308142205.fe3e80ec-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

