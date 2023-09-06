Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DE1CCF9FC
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Sep 2023 01:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjIFBiz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 21:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjIFBiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 21:38:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005A4BF
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 18:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693964330; x=1725500330;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uMv7Cdc7pawgpK+pLaWXGgJ7GRzY8vPnisgI1CjMXd4=;
  b=DOjRne+KCO0daatPmxoaaeRGK4Cah2btOH1i2K1bDeE3QnYEP/pjORKo
   RBJYLh82XCdfmgg8LVV0EqfAAYQPxTeMzqcviCM0VTyT8Tmv/gBkbuX8p
   kQZ+oMYE6SzBZZqMBbRjWbwARLZMIlikoiYXqmEjiLXsJy9RqUXMeTBGU
   lTEqpcy7IkNFyKiCqAMnJCSCTwOQZYVWQdQa6V07VWGbk9TTN9OOlmZ5t
   i8aaZJx2UO1+GXEd6dVJYzt4mirtk5gcQk+Izvkp9xl8rEqFm6BkrMm2R
   bcBZ4ExkxK7sSYxwSUyrDz5kRXkjrrCBSIUUhf7u6S5D0RbsASihKPymV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="380749523"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="380749523"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 18:38:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="831449153"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="831449153"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2023 18:38:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 18:38:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 18:38:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 5 Sep 2023 18:38:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 5 Sep 2023 18:38:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTEfsJVyuMR1NZE338rjhlRuF2jLdCiEfSsQd+KN1ugUMDPXoHzE4vR3EMo+cihz8QfH+AElDNPK8/P+kYCkHiIzlT0mobF1O4K9LxqTXHLp+LaDfu5QDgIdkrSJ9+IbZJsxCX0I5/S10EHJImQ7satSa9bRQIAHV7DtY7Amy8Wo4tJYhwHQow+lgJRidmE6RM5zeL7kULCwlUX8TuDyzMBrAt+bUF6d/hVqh3wEZDsxJrwITcbeFmlSeyB7c7dJhvC7x7u/1wrVJqkjf/T1Ew7fJ3/nT4EFTN2s4/uUmKzjGnqUrQStKQF5yp4k+2+Huhk2XSRwNBAchUHLyoK2FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzmbGRk4DauRHsEEHvaCZ7vkBCAL7q+Q7fFdwy/WRpg=;
 b=i8ueVNoOmwl//r6uJCQdTWlqNn3/xHJY23f86UPr12aznzaI3uwwgROLUtFETl8FScl5yo0ukSkrd4p5GLLmvdoiQVuBG7jjdKDic2EXp5m3ude1ZBfiK2UW3g3HvZKDV3u2xMMmPahUzD1ScmGSzAa/kJjkZ814idlwlv3UpgfvDObi5IH8zhzJh2GKhTZ/+dSMUBB105fihxA+lWUiaH7u6dELkQEtpAv2TDny7ENNR8xbw7Y0Vn/b5T67IfffKinXrtuUv2N+xmEsmtDtscRlclFonpdYyxkE+D8WO47qBtSzFuLKYJGY3dN1gmjgzd9vAXcl+2SFreW5nRMVZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by SA1PR11MB5921.namprd11.prod.outlook.com (2603:10b6:806:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Wed, 6 Sep
 2023 01:38:30 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6745.030; Wed, 6 Sep 2023
 01:38:30 +0000
Date:   Wed, 6 Sep 2023 09:38:21 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        <linux-scsi@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [bvanassche:block-for-next] [scsi]  6d1716982b:
 BUG:kernel_NULL_pointer_dereference,address
Message-ID: <202309060922.cefc15f7-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: PS1PR03CA0004.apcprd03.prod.outlook.com
 (2603:1096:803:3d::16) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|SA1PR11MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: fadc2059-d7eb-4c08-29a1-08dbae79f985
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8WKdXp0O5xsPLy0KcYIQ+I94zrIJVUUNO8g2zPd8Z1yajD3gL4oqjPF2Sf4cUO0qrZ5Zybd548Kh1U7PkwgliLIOwWZKReB3i0ketDTtOb/Rw1GZAgHLKSxw+pn3fwh5/nvVmTqjtYtqWGyaIjj4un+//Kxk7SUNJvrTkWtlkhaDYP5zMqIdxeLrriGaA0Lm+/WoeDQqP04aNw3svYVe4h2gQ3yVy2yzaA+zfo3NIvIXXiPFRrpwYZF++RagD7Rr7cfamxk5OJ8nV+lqV+gZ4wJWZm0Swnw3nb5AsDg16kbI7SAaWm+BI0xItTpG4ovv9DYiN4iT2XdjsYN7vQ6hom226iuIqLVNX/5RZ8cdXiIuWQwtRPc4q41p62tmWP3Ysi6VMktDXaB6LRKpIhs6794SDZyPaa8Ue5tFs1yHr8kMtebGayg9GfrhZjGyEoatBBr7kJ9a9RYTScaOK5ObGporynL0euyKSJdh3GLVhknV3HBjRsF476xEOBV1qS5v7tmdr9SqyAo8MxyROW3a2CI4iRqZfkrRYtO5yg5UUTMV2HUWs+wpXAiKikE08PFfseHdsZvmM6qAouQWB3FNxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199024)(186009)(1800799009)(6486002)(82960400001)(38100700002)(6506007)(36756003)(6666004)(86362001)(45080400002)(966005)(478600001)(6512007)(83380400001)(1076003)(26005)(107886003)(2616005)(66476007)(66556008)(4326008)(66946007)(6916009)(8676002)(8936002)(41300700001)(2906002)(316002)(54906003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jPZZ+7ATXH8HQFLoqyHbKK3uDJMBUYa1W+VNZQzIxJ8EL5pCz7P4Xh+VIXmK?=
 =?us-ascii?Q?g7IEd9uBtxv+7zqw7apyKvDNJcM/ASdxVY424H3VHAxBZt1Q5yVoal8GdKw7?=
 =?us-ascii?Q?7mVFnUQZsdryjPLtiWvuWJZCJ4NW8rcmfkMKLqu3kb/Hm148kxPRR5vdT0p7?=
 =?us-ascii?Q?+o+NgKuXKfps6FAJWhoZqrEhl/gHwSZg/kI0PLctUz43JY0Ncv0WnWIcWrgg?=
 =?us-ascii?Q?xRloUGkXbDIdp5Fu5Ce/c28FbTxL4yggY3EeEk6mD8yW3VEdQ9HblkrbPrRE?=
 =?us-ascii?Q?Enq17CUDuZhZsNUVrWbJLXffcJ7AKgKVs9KmQGldljuMuZDdnhGPGf91M+Mt?=
 =?us-ascii?Q?vcotjKdrbdwqxL4nKNls3hsScblmOv4mo3iuTbaliV0tnNyhheUJCapUBEEu?=
 =?us-ascii?Q?IdVvRq7+zrEal2cwq9ng3g2qVQnA6R8d21f+2IrVvNxrfO8OjVQILI2UATsO?=
 =?us-ascii?Q?M8n3rhm888Mg30RUUz+ojkAp+UpugysS1TL7OD3G9FqVbbLBHzjZVURfUxy8?=
 =?us-ascii?Q?stvdOUaMzeY8etiKzKWh2/E1buVYZkq4o7WIhXDbP8IGhw5rjfcwkZno9z6N?=
 =?us-ascii?Q?TLyzv6v55eaedQ1sNFfTDtj7Nj6/5edo6p2JygN7nq4o/I1L/5wgvLLIRBzF?=
 =?us-ascii?Q?EDwTLC9wFrjFND56qVzi3uLB8WlQl/jNiKLGrRE8QKjKWTX4uviqUB2KJi5W?=
 =?us-ascii?Q?Co8Ho18qUEB7UHeyi8jU5QKE+0dnD0jx+X5RlPeBXOP4y9q4cr+9clkrBOUt?=
 =?us-ascii?Q?vzOyowhoe1gByc1CsVabH9U94jfOeLv3eIgLGevmp0Ud9dnokmwTN/c1YcxS?=
 =?us-ascii?Q?ZG59alwZmzYEEb8hfctsrH8gEmxsKzy6SvwpYxK5LvvofvR92z9lvCQF/l3+?=
 =?us-ascii?Q?lJ3YkjnTIcSnpkbkxqY6g0f+dkOLqpTwYjv5mWvGAFlklPQPi+avrBv4zT3J?=
 =?us-ascii?Q?d9ry/kOKqC5tRMvWFkeToB4muMcfDpXkRrz53x217Qm6Um/CyzdpeEFoLlXG?=
 =?us-ascii?Q?8lymie3wVScX2++rD9yRjI0E9J+fPRaEZ9Km38Bmsvr2w2I14cyrC3gBEHSz?=
 =?us-ascii?Q?1pC+shKgSbPsKni5hqAeFoY9MLUQ/LaVVmi7w+Mqw26zmeteAswxnK6DaTZk?=
 =?us-ascii?Q?cUiSJaXtQ3sdH82q3N+Sj5XorZV4hKiZiFzlWovsCc9LskMZK90hUi1Ce813?=
 =?us-ascii?Q?843PZUPMlTP1tKkjvPkNFV1DVRBQQNtJVI5WGm/1UZSdDsRuXRUjiMCswJHW?=
 =?us-ascii?Q?4Rxi7GeZbVdY1vCR/4Vf/tVpUgSy6ZkLOsCgxjX5G2TibFyc4Pm/vj7s74ss?=
 =?us-ascii?Q?foInurST2BY4KnRRPOQ4rfEyW2Jk7MqaZ35YCYqBlK+75xO1IuvGUF8uhkQw?=
 =?us-ascii?Q?KpmgEpd3TnCcCZCemWBZjcwtXCkXxkE3CmpviwplJLvLQvm7ji6Z1qMfBZwv?=
 =?us-ascii?Q?sSamrd2h0zJCYgFmzb68M4sBok0iFqeRua//q3ZUws+IE7t9REhZJGot5eYK?=
 =?us-ascii?Q?LT38o4o5PMq2lRE4cM7641BeK6V4QS/rsXTSy6ezUoqZaPyEPcVjODi5sqdU?=
 =?us-ascii?Q?iXEJXZV7ezJjSdNJ+R25oirwJHO8h7L5Wjdd/2MIKWAerYxzFZ5ctOnHKo94?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fadc2059-d7eb-4c08-29a1-08dbae79f985
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2023 01:38:30.6096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJN7dg5edjhd9XOTiDjcpgD3OFxjQfUrmv5zqwycXX4n1VNJYuzHqXT4HoguMCJFRK5vbd4fOerWMvcRCBkLyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5921
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: 6d1716982bc67e5c6409456e4a6d37fb6909a779 ("scsi: core: Introduce a mechanism for reordering requests in the error handler")
https://github.com/bvanassche/linux block-for-next

in testcase: boot

compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+---------------------------------------------+------------+------------+
|                                             | 4618ba9202 | 6d1716982b |
+---------------------------------------------+------------+------------+
| boot_successes                              | 6          | 0          |
| boot_failures                               | 0          | 6          |
| BUG:kernel_NULL_pointer_dereference,address | 0          | 6          |
| Oops:#[##]                                  | 0          | 6          |
| EIP:scsi_call_prepare_resubmit              | 0          | 6          |
| Kernel_panic-not_syncing:Fatal_exception    | 0          | 6          |
+---------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202309060922.cefc15f7-oliver.sang@intel.com


[    7.088822][  T113] BUG: kernel NULL pointer dereference, address: 00000064
[    7.089409][  T113] #PF: supervisor read access in kernel mode
[    7.089981][  T113] #PF: error_code(0x0000) - not-present page
[    7.090463][  T113] *pdpt = 000000002de92001 *pde = 0000000000000000
[    7.090986][  T113] Oops: 0000 [#1] SMP PTI
[    7.091358][  T113] CPU: 0 PID: 113 Comm: scsi_eh_1 Tainted: G            E      6.5.0-rc7-00153-g6d1716982bc6 #1
[    7.092170][  T113] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 7.092974][ T113] EIP: scsi_call_prepare_resubmit (drivers/scsi/scsi_error.c:2202 drivers/scsi/scsi_error.c:2228) 
[ 7.093463][ T113] Code: 89 e5 57 89 c7 56 53 83 ec 1c 64 a1 1c 17 4d cd 89 45 f0 8b 07 39 c7 74 2d 8d 58 fc 8d b6 00 00 00 00 8b 03 8b 80 4c 01 00 00 <8b> 50 64 85 d2 74 0b 89 d8 e8 c2 17 45 00 84 c0 75 26 8b 43 04 8d
All code
========
   0:	89 e5                	mov    %esp,%ebp
   2:	57                   	push   %rdi
   3:	89 c7                	mov    %eax,%edi
   5:	56                   	push   %rsi
   6:	53                   	push   %rbx
   7:	83 ec 1c             	sub    $0x1c,%esp
   a:	64 a1 1c 17 4d cd 89 	movabs %fs:0x8bf04589cd4d171c,%eax
  11:	45 f0 8b 
  14:	07                   	(bad)
  15:	39 c7                	cmp    %eax,%edi
  17:	74 2d                	je     0x46
  19:	8d 58 fc             	lea    -0x4(%rax),%ebx
  1c:	8d b6 00 00 00 00    	lea    0x0(%rsi),%esi
  22:	8b 03                	mov    (%rbx),%eax
  24:	8b 80 4c 01 00 00    	mov    0x14c(%rax),%eax
  2a:*	8b 50 64             	mov    0x64(%rax),%edx		<-- trapping instruction
  2d:	85 d2                	test   %edx,%edx
  2f:	74 0b                	je     0x3c
  31:	89 d8                	mov    %ebx,%eax
  33:	e8 c2 17 45 00       	call   0x4517fa
  38:	84 c0                	test   %al,%al
  3a:	75 26                	jne    0x62
  3c:	8b 43 04             	mov    0x4(%rbx),%eax
  3f:	8d                   	.byte 0x8d

Code starting with the faulting instruction
===========================================
   0:	8b 50 64             	mov    0x64(%rax),%edx
   3:	85 d2                	test   %edx,%edx
   5:	74 0b                	je     0x12
   7:	89 d8                	mov    %ebx,%eax
   9:	e8 c2 17 45 00       	call   0x4517d0
   e:	84 c0                	test   %al,%al
  10:	75 26                	jne    0x38
  12:	8b 43 04             	mov    0x4(%rbx),%eax
  15:	8d                   	.byte 0x8d
[    7.094917][  T113] EAX: 00000000 EBX: ed40a0a0 ECX: 00000000 EDX: c21ded44
[    7.095473][  T113] ESI: edfb2ed4 EDI: edfb2ed4 EBP: c23fded8 ESP: c23fdeb0
[    7.096024][  T113] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010206
[    7.096644][  T113] CR0: 80050033 CR2: 00000064 CR3: 2de50000 CR4: 000406f0
[    7.097201][  T113] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    7.097756][  T113] DR6: fffe0ff0 DR7: 00000400
[    7.098160][  T113] Call Trace:
[ 7.098464][ T113] ? show_regs (arch/x86/kernel/dumpstack.c:479 arch/x86/kernel/dumpstack.c:465) 
[ 7.098831][ T113] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434) 
[ 7.099176][ T113] ? page_fault_oops (arch/x86/mm/fault.c:707) 
[ 7.099582][ T113] ? kernelmode_fixup_or_oops+0x73/0x100 
[ 7.100106][ T113] ? __bad_area_nosemaphore+0xdc/0x1c0 
[ 7.100621][ T113] ? ata_eh_speed_down (drivers/ata/libata-eh.c:1819) libata
[ 7.101108][ T113] ? bad_area_nosemaphore (arch/x86/mm/fault.c:867) 
[ 7.101535][ T113] ? do_user_addr_fault (arch/x86/mm/fault.c:1457) 
[ 7.101972][ T113] ? exc_page_fault (arch/x86/include/asm/irqflags.h:37 arch/x86/include/asm/irqflags.h:72 arch/x86/mm/fault.c:1494 arch/x86/mm/fault.c:1542) 
[ 7.102377][ T113] ? pvclock_clocksource_read_nowd (arch/x86/mm/fault.c:1499) 
[ 7.102868][ T113] ? handle_exception (arch/x86/entry/entry_32.S:1056) 
[ 7.103285][ T113] ? ata_eh_thaw_port (arch/x86/include/asm/bitops.h:228 arch/x86/include/asm/bitops.h:240 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/cpumask.h:504 include/linux/cpumask.h:1082 include/trace/events/libata.h:630 drivers/ata/libata-eh.c:1149 drivers/ata/libata-eh.c:1133) libata
[ 7.103755][ T113] ? pvclock_clocksource_read_nowd (arch/x86/mm/fault.c:1499) 
[ 7.104251][ T113] ? scsi_call_prepare_resubmit (drivers/scsi/scsi_error.c:2202 drivers/scsi/scsi_error.c:2228) 
[ 7.104723][ T113] ? ata_eh_thaw_port (arch/x86/include/asm/bitops.h:228 arch/x86/include/asm/bitops.h:240 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/cpumask.h:504 include/linux/cpumask.h:1082 include/trace/events/libata.h:630 drivers/ata/libata-eh.c:1149 drivers/ata/libata-eh.c:1133) libata
[ 7.105189][ T113] ? pvclock_clocksource_read_nowd (arch/x86/mm/fault.c:1499) 
[ 7.105681][ T113] ? scsi_call_prepare_resubmit (drivers/scsi/scsi_error.c:2202 drivers/scsi/scsi_error.c:2228) 
[ 7.106158][ T113] ? ata_sff_error_handler (drivers/ata/libata-sff.c:2096) libata
[ 7.106665][ T113] ? ata_sff_softreset (drivers/ata/libata-sff.c:2000) libata
[ 7.107153][ T113] ? ata_sff_dev_classify (drivers/ata/libata-sff.c:1920) libata
[ 7.107658][ T113] scsi_eh_flush_done_q (drivers/scsi/scsi_error.c:2266) 
[ 7.108084][ T113] ata_scsi_port_error_handler (drivers/ata/libata-eh.c:754) libata
[ 7.108616][ T113] ata_scsi_error (include/linux/list.h:292 drivers/ata/libata-eh.c:549) libata
[ 7.109060][ T113] scsi_error_handler (drivers/scsi/scsi_error.c:2406) 
[ 7.109472][ T113] kthread (kernel/kthread.c:389) 
[ 7.109847][ T113] ? scsi_eh_flush_done_q (drivers/scsi/scsi_error.c:2349) 
[ 7.110291][ T113] ? kthread_complete_and_exit (kernel/kthread.c:342) 
[ 7.110747][ T113] ret_from_fork (arch/x86/kernel/process.c:151) 
[ 7.111126][ T113] ? kthread_complete_and_exit (kernel/kthread.c:342) 
[ 7.111585][ T113] ret_from_fork_asm (arch/x86/entry/entry_32.S:741) 
[ 7.111989][ T113] entry_INT80_32 (arch/x86/entry/entry_32.S:947) 
[    7.112377][  T113] Modules linked in: rapl(E) ppdev(E) evdev(E) drm(E) ata_piix(E) psmouse(E) serio_raw(E) i2c_piix4(E) libata(E) floppy(E) parport_pc(E) parport(E) qemu_fw_cfg(E) button(E)
[    7.113658][  T113] CR2: 0000000000000064
[    7.114027][  T113] ---[ end trace 0000000000000000 ]---
[ 7.114475][ T113] EIP: scsi_call_prepare_resubmit (drivers/scsi/scsi_error.c:2202 drivers/scsi/scsi_error.c:2228) 
[ 7.114956][ T113] Code: 89 e5 57 89 c7 56 53 83 ec 1c 64 a1 1c 17 4d cd 89 45 f0 8b 07 39 c7 74 2d 8d 58 fc 8d b6 00 00 00 00 8b 03 8b 80 4c 01 00 00 <8b> 50 64 85 d2 74 0b 89 d8 e8 c2 17 45 00 84 c0 75 26 8b 43 04 8d
All code
========
   0:	89 e5                	mov    %esp,%ebp
   2:	57                   	push   %rdi
   3:	89 c7                	mov    %eax,%edi
   5:	56                   	push   %rsi
   6:	53                   	push   %rbx
   7:	83 ec 1c             	sub    $0x1c,%esp
   a:	64 a1 1c 17 4d cd 89 	movabs %fs:0x8bf04589cd4d171c,%eax
  11:	45 f0 8b 
  14:	07                   	(bad)
  15:	39 c7                	cmp    %eax,%edi
  17:	74 2d                	je     0x46
  19:	8d 58 fc             	lea    -0x4(%rax),%ebx
  1c:	8d b6 00 00 00 00    	lea    0x0(%rsi),%esi
  22:	8b 03                	mov    (%rbx),%eax
  24:	8b 80 4c 01 00 00    	mov    0x14c(%rax),%eax
  2a:*	8b 50 64             	mov    0x64(%rax),%edx		<-- trapping instruction
  2d:	85 d2                	test   %edx,%edx
  2f:	74 0b                	je     0x3c
  31:	89 d8                	mov    %ebx,%eax
  33:	e8 c2 17 45 00       	call   0x4517fa
  38:	84 c0                	test   %al,%al
  3a:	75 26                	jne    0x62
  3c:	8b 43 04             	mov    0x4(%rbx),%eax
  3f:	8d                   	.byte 0x8d

Code starting with the faulting instruction
===========================================
   0:	8b 50 64             	mov    0x64(%rax),%edx
   3:	85 d2                	test   %edx,%edx
   5:	74 0b                	je     0x12
   7:	89 d8                	mov    %ebx,%eax
   9:	e8 c2 17 45 00       	call   0x4517d0
   e:	84 c0                	test   %al,%al
  10:	75 26                	jne    0x38
  12:	8b 43 04             	mov    0x4(%rbx),%eax
  15:	8d                   	.byte 0x8d


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230906/202309060922.cefc15f7-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

