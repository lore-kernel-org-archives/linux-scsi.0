Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E49EC7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 10 May 2023 06:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbjEJGVV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 02:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjEJGVT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 02:21:19 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E6BE60
        for <linux-scsi@vger.kernel.org>; Tue,  9 May 2023 23:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683699673; x=1715235673;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=AVOw/V6u/905u5QQTVwxtKNJIgA1NAa8gSTs9Sak2Gw=;
  b=fVlxdURv0xGYjdMDwJlymemilK+jnJ+gEtylC3vTxleXpP0KISA/JDa6
   gFnMNNAqAKQMzFrwZNZFvpnKolC3QARr5ak5CQrbicamCibQSVgbsmO7N
   ReG0js0/V3wTSDJGKxvt8rLF8bE6/hNy8QTrRcimeRDvKB+jlF8cKyEjH
   /5qdVhsh4ytVJRWWbqPITmE6N/GpJ+wRz6f5NmFDPaNS0r4UEuCLGGdfo
   DKLSdgd+7FyJgINS4MIvXFVF02dJEjoXUaose7ow+zKkXAmJ2gva4ksRn
   crcavxXzpvC5Cn4PT81xraHPhcknGhWptxlCi/JmSmRs7vh7Cfv91cDal
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="353207032"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="xz'341?scan'341,208,341";a="353207032"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="788811264"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="xz'341?scan'341,208,341";a="788811264"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 09 May 2023 23:21:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 23:21:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 23:21:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 23:21:08 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 23:21:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GV1iaqTYKRKjcOottPWR1lLRxxdyz3dme/rmhMcHb3YRtr585pUiwkQjUS2ZmCzpKvgKkaOnD+Nie/Fmxclr5ThxMEOpdzFfXx4xjoQFGS8WoSkzO6sa2f7ivan6Fom6aOAlMOn8qZPyulWzZvd9o/rwMdSQux2VYNGY83JVwqnBubkrUEi9FOeiFFB9YGLB+V2ykcRFEHa8KnrY9qb/cvVix+Ci9mXOLat3TTEz/AhDrluBb/gNDYhw27nbRmN29KU0RocZ9ldFJ6ZH8IHq+r1W77+BAvUt5LYA33CkG4xqwRQS56OQ9ZHzIIMnO/xzfrcKlOMBlVSLISJRQm22wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giZJH1t0ByrWvaVYoaveuMGZWvvKib5u2nwNEOIqNPU=;
 b=Nb0TIknwth36WMqwEVPe7Sw1tUmm8u5kb029hgbK6gnbw0ZGxWjzMH7j2bZnAtSz9vhTyR0viIxlxNsQYF1DFVb7aPrGeC+Dbd+ayvWqQW7+uW9jCR39sMfBbB/aHy+N3tkreMzZrQWgdAZLlfnY0Bv8BXM+7gPabYg3V373/ojf/rzs3OwZzbdY/PoZ1+D2ur8WftBQskDiTxW9axM5+r0iHciTQPujGAlcLPONqDmafq+7zGolqFjmYDFquLFVkRevPxWoJkv81da42cQnnWsyHrT4wKDML7oNbV5nxmsWTJQV8j2k3AuttpEIbG+BcwmT1umGwRUM+HMEZ8vqBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by SA2PR11MB5004.namprd11.prod.outlook.com (2603:10b6:806:112::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 06:21:03 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf%6]) with mapi id 15.20.6363.031; Wed, 10 May 2023
 06:21:03 +0000
Date:   Wed, 10 May 2023 14:20:51 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Tejun Heo <tj@kernel.org>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>,
        <oliver.sang@intel.com>
Subject: [linux-next:master] [scsi]  59709bb84c:
 WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register
Message-ID: <202305101032.eb213724-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="mpXzSbgjLJBKxB4+"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SG2PR02CA0120.apcprd02.prod.outlook.com
 (2603:1096:4:92::36) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|SA2PR11MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e4ba77e-3d47-4244-9896-08db511ebaa8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J+2lfEm+6EnOKwgQXn0TplMnvAyR3+EJC0HagW0o73ru9odvGko+fBIQ0SnMemboMT6keS9DoT04db2ibFfJ+pCumLJ+3hZJDEtHrwK4QoJacyQAK9LIrEMeioH8L5ytqovqqbx98OvkJ98UWWlxcTfIzgGBrsYfCy8KnHjnWBvJV4SS2s64KMyxcH8k0lhyuRq/P1hD4KbZr205yNdH1zrCDswtuzOc6k8NER6qSQN5KUuuV0qZ35d7KG2lRlg38acL3ZprN6AgvP7I8LSPk1HQpeTTt3F0OWJfwnB0MgO4BFsyq7avDKtgnxWoac39O6wdmNFqPxmAvslEJNZ+SHU1DyxzK2qFMHk9hBkcxkgkv8z8sN9rO+EfEkwxytwQfH77f8bFB9qsrh+Evy/RquC/ez8/wlZ9aoV5beKoPUGh4PT8o+3Roxt55pSWU8QIH2EYExSGjPbQEdoknfrJzB27RNArFEL32OVvHg13EctCptkYYVK43d1Ec4OCNTsg02GCqSo5sBqr9KZMhpbra+pnzdAoDXgfy0ShFtRjNM8j+nvjzmajx5nUe1x1I7h3jBUiA8376LHKPY6/BhdbZZhKZUqg2sMF66hWMlNj3hxECEQjzmD/D7BLjWZqLqHnv+vv7JpzCbdwayawY5L2yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199021)(2906002)(86362001)(2616005)(83380400001)(186003)(6916009)(4326008)(41300700001)(66946007)(36756003)(66556008)(45080400002)(66476007)(6506007)(6512007)(1076003)(107886003)(26005)(235185007)(38100700002)(5660300002)(966005)(6486002)(44144004)(6666004)(54906003)(316002)(82960400001)(8936002)(8676002)(478600001)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CdGj1BhnRPaAXHaT5MsR+Kroz1QubC0euSlRHVXJgo9g/+MA7PbraBF67AEV?=
 =?us-ascii?Q?2hchGEWIgR2kx8Kh9mNDaX4zr0LxuyzukW6GT9SpbMmUcOxbQTyPRKnR02oU?=
 =?us-ascii?Q?mwUhCClKeT7fwpvYVrIIPf8/w20z7Ka69/u/bd5Rx3dMtTmmRnXXXEqfJGPN?=
 =?us-ascii?Q?F4e8LzKWCeFvlLHOAZ3CgsB6w9L89YvZlYKw0YmXC3CifxeM/XjQRK40pkaL?=
 =?us-ascii?Q?ymR/wBQBz3Q4pgpMTwJ3+rbCuNEOtQKe4BlEslHoc9YkqRwWald5Ptw2IZGV?=
 =?us-ascii?Q?6DMGws2Txl5t82nEyNpiO+07UvceOncMmfBOWyPpGPL55yw2kwMf6EHf/eNX?=
 =?us-ascii?Q?dJRKtrPHRYYKiWEt9f1cVREhQz5o6KhJg3q+sm7Vn94Gi89JGtCtNMwu7k6J?=
 =?us-ascii?Q?8i4VmUFdUdPLib99Y0CNi8LS+m8FKhry0lnpXhvPusDnqIisUE7JkQVNvGc0?=
 =?us-ascii?Q?kcVjvN0YJv5CmeUWkjJuQ3v1kkotw36CfkSqXKdrrHXapwspXfz8cqmOjcWY?=
 =?us-ascii?Q?tA2/K7KmlG2RgctdQf/Z9lvVNlSRSxIyCKIXnfgZ6PMciMocauZGRAmh2eHk?=
 =?us-ascii?Q?MvCoHZfcSh4LWrm8pLTlGPAabdJNJs9kD9KO++WJfj5Q3rNrUhUM/1vyDnew?=
 =?us-ascii?Q?v/t/uw+nDqBVYAKLYu4oc2OPAB+5VFopGKXL0YlN6g+J5kocjYO/6QtvjXz/?=
 =?us-ascii?Q?U0RnLanvV/VzJIEFuPezMsxaPkEAzcsWu0wShKOObvyXsKNs/HhgLU+bkHQc?=
 =?us-ascii?Q?hbyaE/UIKm+ssfmIHMEHtnGSXwam7aNOVx4PxafkGt5i3s7iQqpqhTc3cPBL?=
 =?us-ascii?Q?ZqJuvNb+HXnmqyMnXCUU43CV95h2gufP07UhpX0nOXJirCBOM+x+Z2WunCBb?=
 =?us-ascii?Q?hn7eFBaBW74HnMVvvyyZQKMSd+UAVP4ZG0FxC4ZKLbNtavZAyRmK8zx2oT/e?=
 =?us-ascii?Q?XAOr/Qw8pwMLE4kD4QckUdoy7stNwCBLucDmB7lt8gbEfCVV0/P3cNl7zCJc?=
 =?us-ascii?Q?mSZD3v9h9MmTBbwr5ntfmUNuFG1xhqpOBNrZHR31cdRr2328pMTsJTQpae4P?=
 =?us-ascii?Q?ZKn43NYdiBd53JoByLG68DhqP3du4lyF8oWXdzkg01Idn6Wq6NHyAbBTtGsr?=
 =?us-ascii?Q?R8vxf+uOnpPH6TCSp1+GDAQKMbD9P2/8yX28J3aEI4JDPPh4Xea60mD3JRfJ?=
 =?us-ascii?Q?LEOs+tC11BW1WConjFXC9bcDJ4viQF94Dmpehfm6R8A+oWUTWtGeacl1Gqcf?=
 =?us-ascii?Q?FmhLIUZ9i86a2UMADks6lQ7ZKE5HClCFgSpn0ZhTXo+1tU6iReb+VmWcaGDA?=
 =?us-ascii?Q?7V+YfV6aIsr8af15TseMlkMt+VoNii3nyvG1w/prFSRVxj1zQ2+ZLn2WDXUW?=
 =?us-ascii?Q?vp/lt+ggCXeqDZu7sKutKT97Un1Y4emp7uKBEZJyvj7Ll/IC95CB4MCE/RaM?=
 =?us-ascii?Q?QkFh8/Z+wWJ5+5ER3FZz87y4829E4yroZORtmVmiMIFSpfnxYuR5omOacYot?=
 =?us-ascii?Q?yq5U6G6nUCMmfUG8DOwUD9mbmrQJEmhvrQe9q5FxI53CgMNeGmPg6Z42EGBj?=
 =?us-ascii?Q?VARpt1t/5TLBAJ6/ZiPC6BfI7LcGrUVbkRfYKcPNSdBM1A61cTnAxq19OcNh?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4ba77e-3d47-4244-9896-08db511ebaa8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 06:21:03.4757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OK1ZjF8JFX20nDDE04UYLmI/30Ad3tCo5NVBGW05Vv9rpTSyKkQREIWJu9UF6p7YFP9EFKm13Eoh1Ir95AeWKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5004
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--mpXzSbgjLJBKxB4+
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


Hello,

we reported "[tj-wq:ordered-cleanup] [scsi]  25aa2ad5c3: WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register"
on https://lore.kernel.org/all/202304251456.d77841dd-oliver.sang@intel.com/
when this commit is on
commit: 25aa2ad5c302824d6ff271e4b0030ac92cb99a69 ("scsi: Use alloc_ordered_workqueue() to create ordered workqueues")
https://git.kernel.org/cgit/linux/kernel/git/tj/wq.git ordered-cleanup

now we noticed this commit is already in linux-next/master.
since we still observed same issue in our tests, we reported this again FYI.

below is the detailed report.


kernel test robot noticed "WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register" on:

commit: 59709bb84c22905421dd05fa2a80ece411bec76f ("scsi: Use alloc_ordered_workqueue() to create ordered workqueues")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 47cba14ce6fc4f314bd814d07269d0c8de1e4ae6]

in testcase: boot

compiler: gcc-11
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Link: https://lore.kernel.org/oe-lkp/202305101032.eb213724-oliver.sang@intel.com


[    9.776932][    T1] ------------[ cut here ]------------
[ 9.778320][ T1] WARNING: CPU: 0 PID: 1 at kernel/workqueue.c:5923 workqueue_sysfs_register (??:?) 
[    9.780600][    T1] Modules linked in:
[    9.798598][    T1] CPU: 0 PID: 1 Comm: swapper Tainted: G                T  6.4.0-rc1-00007-g59709bb84c22 #1 5e42178dc8b4a43844b39beb4e06c668c3c6e8e3
[    9.801539][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
[ 9.803786][ T1] EIP: workqueue_sysfs_register (??:?) 
[ 9.805123][ T1] Code: c0 75 0f 8d 45 fc e8 be fe ff ff 85 c0 75 03 8b 45 08 c9 31 d2 31 c9 c3 55 89 e5 57 56 53 83 ec 08 f6 80 e2 00 00 00 08 74 0c <0f> 0b bf ea ff ff ff e9 cc 00 00 00 89 c6 ba c0 0c 00 00 b8 78 01
All code
========
   0:	c0 75 0f 8d          	shlb   $0x8d,0xf(%rbp)
   4:	45 fc                	rex.RB cld 
   6:	e8 be fe ff ff       	callq  0xfffffffffffffec9
   b:	85 c0                	test   %eax,%eax
   d:	75 03                	jne    0x12
   f:	8b 45 08             	mov    0x8(%rbp),%eax
  12:	c9                   	leaveq 
  13:	31 d2                	xor    %edx,%edx
  15:	31 c9                	xor    %ecx,%ecx
  17:	c3                   	retq   
  18:	55                   	push   %rbp
  19:	89 e5                	mov    %esp,%ebp
  1b:	57                   	push   %rdi
  1c:	56                   	push   %rsi
  1d:	53                   	push   %rbx
  1e:	83 ec 08             	sub    $0x8,%esp
  21:	f6 80 e2 00 00 00 08 	testb  $0x8,0xe2(%rax)
  28:	74 0c                	je     0x36
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	bf ea ff ff ff       	mov    $0xffffffea,%edi
  31:	e9 cc 00 00 00       	jmpq   0x102
  36:	89 c6                	mov    %eax,%esi
  38:	ba c0 0c 00 00       	mov    $0xcc0,%edx
  3d:	b8                   	.byte 0xb8
  3e:	78 01                	js     0x41

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	bf ea ff ff ff       	mov    $0xffffffea,%edi
   7:	e9 cc 00 00 00       	jmpq   0xd8
   c:	89 c6                	mov    %eax,%esi
   e:	ba c0 0c 00 00       	mov    $0xcc0,%edx
  13:	b8                   	.byte 0xb8
  14:	78 01                	js     0x17
[    9.809253][    T1] EAX: c56ba800 EBX: c56ba800 ECX: 00000000 EDX: 00000000
[    9.810916][    T1] ESI: 000a004a EDI: c56ba8b8 EBP: c3e49d78 ESP: c3e49d64
[    9.812595][    T1] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010202
[    9.814419][    T1] CR0: 80050033 CR2: ffdaa000 CR3: 03163000 CR4: 00040690
[    9.816114][    T1] Call Trace:
[ 9.817007][ T1] ? init_rescuer (workqueue.c:?) 
[ 9.818075][ T1] alloc_workqueue (??:?) 
[ 9.819214][ T1] scsi_host_alloc (??:?) 
[ 9.820399][ T1] sdebug_driver_probe (scsi_debug.c:?) 
[ 9.821615][ T1] ? sysfs_create_link (??:?) 
[ 9.822772][ T1] really_probe (dd.c:?) 
[ 9.823946][ T1] __driver_probe_device (dd.c:?) 
[ 9.825218][ T1] driver_probe_device (dd.c:?) 
[ 9.826405][ T1] __device_attach_driver (dd.c:?) 
[ 9.827666][ T1] bus_for_each_drv (??:?) 
[ 9.828813][ T1] __device_attach (dd.c:?) 
[ 9.829976][ T1] ? driver_probe_device (dd.c:?) 
[ 9.831180][ T1] device_initial_probe (??:?) 
[ 9.832389][ T1] bus_probe_device (??:?) 
[ 9.833579][ T1] device_add (??:?) 
[ 9.834658][ T1] device_register (??:?) 
[ 9.835791][ T1] sdebug_add_host_helper (scsi_debug.c:?) 
[ 9.837129][ T1] scsi_debug_init (scsi_debug.c:?) 
[ 9.838279][ T1] ? ses_init (scsi_debug.c:?) 
[ 9.839322][ T1] do_one_initcall (??:?) 
[ 9.840507][ T1] ? rdinit_setup (main.c:?) 
[ 9.841626][ T1] do_initcalls (main.c:?) 
[ 9.842719][ T1] kernel_init_freeable (main.c:?) 
[ 9.843956][ T1] ? rest_init (main.c:?) 
[ 9.845022][ T1] kernel_init (main.c:?) 
[ 9.846099][ T1] ret_from_fork (??:?) 
[    9.847231][    T1] irq event stamp: 112397
[ 9.848320][ T1] hardirqs last enabled at (112409): __up_console_sem (printk.c:?) 
[ 9.850447][ T1] hardirqs last disabled at (112422): __up_console_sem (printk.c:?) 
[ 9.852509][ T1] softirqs last enabled at (111600): __do_softirq (??:?) 
[ 9.854571][ T1] softirqs last disabled at (111591): call_on_stack (irq_32.c:?) 
[    9.856598][    T1] ---[ end trace 0000000000000000 ]---
[    9.859173][    T1] scsi host0: failed to create tmf workq
[    9.861023][    T1] scsi_debug:sdebug_driver_probe: scsi_host_alloc failed
[    9.862682][    T1] probe of adapter0 returned 19 after 86023 usecs


To reproduce:

        # build kernel
	cd linux
	cp config-6.4.0-rc1-00007-g59709bb84c22 .config
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 olddefconfig prepare modules_prepare bzImage modules
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 INSTALL_MOD_PATH=<mod-install-dir> modules_install
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



--mpXzSbgjLJBKxB4+
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.4.0-rc1-00007-g59709bb84c22"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 6.4.0-rc1 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-12) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=24000
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=24000
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT=y
CONFIG_TOOLS_SUPPORT_RELR=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=125
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_UAPI_HEADER_TEST=y
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
CONFIG_KERNEL_LZ4=y
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
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
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
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

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=125
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y

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

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_TINY_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_FORCE_TASKS_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_FORCE_TASKS_RUDE_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_FORCE_TASKS_TRACE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_TASKS_TRACE_RCU_READ_MB=y
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=y
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC11_NO_ARRAY_BOUNDS=y
CONFIG_CC_NO_ARRAY_BOUNDS=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
# CONFIG_MEMCG is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_RD_ZSTD is not set
# CONFIG_BOOT_CONFIG is not set
# CONFIG_INITRAMFS_PRESERVE_MTIME is not set
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_BITS_MAX=16
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=2
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
CONFIG_GOLDFISH=y
# CONFIG_X86_CPU_RESCTRL is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_M486SX is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
CONFIG_MWINCHIP3D=y
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_CPU_SUP_VORTEX_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_NR_CPUS_RANGE_BEGIN=1
CONFIG_NR_CPUS_RANGE_END=1
CONFIG_NR_CPUS_DEFAULT=1
CONFIG_NR_CPUS=1
CONFIG_UP_LATE_INIT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set

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

# CONFIG_X86_LEGACY_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_TOSHIBA=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_X86_INTEL_TSX_MODE_OFF is not set
CONFIG_X86_INTEL_TSX_MODE_ON=y
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_EFI_FAKE_MEMMAP=y
CONFIG_EFI_MAX_FAKE_MEM=8
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
# end of Processor type and features

CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=11
CONFIG_FUNCTION_PADDING_BYTES=16
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_RETPOLINE=y
# CONFIG_RETHUNK is not set
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
# CONFIG_ACPI_SPCR_TABLE is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
CONFIG_ACPI_DPTF=y
# CONFIG_DPTF_POWER is not set
CONFIG_DPTF_PCH_FIVR=y
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_FFH is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
CONFIG_CPU_IDLE_GOV_HALTPOLL=y
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_COMPAT_32=y
# end of Binary Emulations

CONFIG_HAVE_ATOMIC_IOMAP=y
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
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
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
CONFIG_ARCH_32BIT_OFF_T=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
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
CONFIG_MMU_LAZY_TLB_REFCOUNT=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
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
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_ISA_BUS_API=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
CONFIG_LOCK_EVENT_COUNTS=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SPLIT_ARG64=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT=16
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_DEBUG is not set
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
CONFIG_MODVERSIONS=y
CONFIG_ASM_MODVERSIONS=y
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
CONFIG_BLK_CGROUP_PUNT_BIO=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_WBT_MQ is not set
# CONFIG_BLK_DEBUG_FS is not set
CONFIG_BLK_SED_OPAL=y
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
# end of IO Schedulers

CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
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
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SLUB_STATS is not set
# end of SLAB allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_BOUNCE=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_DEBUGFS=y
CONFIG_CMA_SYSFS=y
CONFIG_CMA_AREAS=7
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ZONE_DMA=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PERCPU_STATS=y
# CONFIG_GUP_TEST is not set
# CONFIG_DMAPOOL_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_KMAP_LOCAL=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
CONFIG_USERFAULTFD=y
CONFIG_LRU_GEN=y
# CONFIG_LRU_GEN_ENABLED is not set
# CONFIG_LRU_GEN_STATS is not set

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
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
CONFIG_NET_HANDSHAKE=y
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
CONFIG_MAX_SKB_FRAGS=17
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

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
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#
# CONFIG_PCI_FTPCI100 is not set
# CONFIG_PCI_HOST_GENERIC is not set

#
# Cadence-based PCIe controllers
#
# CONFIG_PCIE_CADENCE_PLAT_HOST is not set
# CONFIG_PCI_J721E_HOST is not set
# end of Cadence-based PCIe controllers

#
# DesignWare-based PCIe controllers
#
# end of DesignWare-based PCIe controllers

#
# Mobiveil-based PCIe controllers
#
# end of Mobiveil-based PCIe controllers
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_DEVTMPFS_SAFE is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_DEBUG=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_FW_LOADER_COMPRESS is not set
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
CONFIG_REGMAP_SLIMBUS=y
CONFIG_REGMAP_SPMI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SCCB=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y
# CONFIG_FW_DEVLINK_SYNC_STATE_TIMEOUT is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=y
# CONFIG_MHI_BUS_DEBUG is not set
# CONFIG_MHI_BUS_PCI_GENERIC is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

# CONFIG_CONNECTOR is not set

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_FW_CFG_SYSFS is not set
CONFIG_SYSFB=y
CONFIG_SYSFB_SIMPLEFB=y
CONFIG_FW_CS_DSP=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_ESRT=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_BOOTLOADER_CONTROL=y
CONFIG_EFI_CAPSULE_LOADER=y
# CONFIG_EFI_CAPSULE_QUIRK_QUARK_CSH is not set
# CONFIG_EFI_TEST is not set
CONFIG_EFI_RCI2_TABLE=y
CONFIG_EFI_DISABLE_PCI_DMA=y
CONFIG_EFI_EARLYCON=y
# CONFIG_EFI_CUSTOM_SSDT_OVERLAYS is not set
CONFIG_EFI_DISABLE_RUNTIME=y
CONFIG_EFI_COCO_SECRET=y
# end of EFI (Extensible Firmware Interface) Support

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_GNSS=y
# CONFIG_MTD is not set
CONFIG_OF=y
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_KOBJ=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_UBLK is not set

#
# NVME Support
#
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
# CONFIG_NVME_TARGET is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_SMPRO_ERRMON=y
CONFIG_SMPRO_MISC=y
# CONFIG_HI6421V600_IRQ is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_VCPU_STALL_DETECTOR=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_IDT_89HPESX=y
CONFIG_EEPROM_EE1004=y
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_ECHO=y
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
CONFIG_UACCE=y
CONFIG_PVPANIC=y
CONFIG_PVPANIC_MMIO=y
# CONFIG_PVPANIC_PCI is not set
# CONFIG_GP_PCI1XXXX is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=y
# CONFIG_SCSI_AHA1542 is not set
CONFIG_SCSI_AHA1740=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_FDOMAIN=y
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_FDOMAIN_ISA=y
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_GENERIC_NCR5380=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_SIM710 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=y
CONFIG_SATA_HOST=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_AHCI_DWC is not set
# CONFIG_AHCI_CEVA is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
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
# CONFIG_TUN is not set
# CONFIG_TUN_VNET_CROSS_LE is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
# CONFIG_MHI_NET is not set
# CONFIG_ARCNET is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
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
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CIRRUS=y
# CONFIG_CS89x0_ISA is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_GEMINI_ETHERNET is not set
CONFIG_NET_VENDOR_DAVICOM=y
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
# CONFIG_EZCHIP_NPS_MANAGEMENT_ENET is not set
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
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_IGC is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_LITEX=y
# CONFIG_LITEX_LITEETH is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
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
# CONFIG_NE2000 is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_ULTRA is not set
# CONFIG_WD80x3 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
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
# CONFIG_SMC9194 is not set
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
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
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
# CONFIG_PSE_CONTROLLER is not set
# CONFIG_MDIO_DEVICE is not set

#
# PCS device drivers
#
# end of PCS device drivers

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
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_IQS62X is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
# CONFIG_KEYBOARD_MTK_PMIC is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_ELAN_I2C=y
# CONFIG_MOUSE_ELAN_I2C_I2C is not set
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADC is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_PXRC is not set
CONFIG_JOYSTICK_QWIIC=y
# CONFIG_JOYSTICK_FSIA6B is not set
CONFIG_JOYSTICK_SENSEHAT=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_AR1021_I2C is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT_T37 is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_BU21029=y
CONFIG_TOUCHSCREEN_CHIPONE_ICN8318=y
CONFIG_TOUCHSCREEN_CHIPONE_ICN8505=y
CONFIG_TOUCHSCREEN_CY8CTMA140=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP5=y
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_EGALAX is not set
CONFIG_TOUCHSCREEN_EGALAX_SERIAL=y
CONFIG_TOUCHSCREEN_EXC3000=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
CONFIG_TOUCHSCREEN_HIDEEP=y
# CONFIG_TOUCHSCREEN_HYCON_HY46XX is not set
CONFIG_TOUCHSCREEN_HYNITRON_CSTXXX=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_ILITEK=y
CONFIG_TOUCHSCREEN_S6SY761=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
CONFIG_TOUCHSCREEN_ELAN=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MELFAS_MIP4=y
# CONFIG_TOUCHSCREEN_MSG2638 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_NOVATEK_NVT_TS is not set
CONFIG_TOUCHSCREEN_IMAGIS=y
CONFIG_TOUCHSCREEN_IMX6UL_TSC=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_HTCPEN is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WDT87XX_I2C=y
CONFIG_TOUCHSCREEN_WM97XX=y
CONFIG_TOUCHSCREEN_WM9705=y
# CONFIG_TOUCHSCREEN_WM9712 is not set
# CONFIG_TOUCHSCREEN_WM9713 is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC200X_CORE=y
CONFIG_TOUCHSCREEN_TSC2004=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
CONFIG_TOUCHSCREEN_SILEAD=y
CONFIG_TOUCHSCREEN_SIS_I2C=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMFTS=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_SX8654=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZET6223=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_TOUCHSCREEN_COLIBRI_VF50=y
CONFIG_TOUCHSCREEN_ROHM_BU21023=y
CONFIG_TOUCHSCREEN_IQS5XX=y
# CONFIG_TOUCHSCREEN_ZINITIX is not set
CONFIG_TOUCHSCREEN_HIMAX_HX83112B=y
# CONFIG_INPUT_MISC is not set
# CONFIG_RMI4_CORE is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
# CONFIG_SERIO_GPIO_PS2 is not set
CONFIG_USERIO=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
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
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCILIB=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_PCI1XXXX is not set
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
CONFIG_SERIAL_8250_RT288X=y
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y
CONFIG_SERIAL_OF_PLATFORM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SIFIVE=y
# CONFIG_SERIAL_SIFIVE_CONSOLE is not set
CONFIG_SERIAL_LANTIQ=y
# CONFIG_SERIAL_LANTIQ_CONSOLE is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_SC16IS7XX=y
# CONFIG_SERIAL_SC16IS7XX_I2C is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_FSL_LINFLEXUART=y
CONFIG_SERIAL_FSL_LINFLEXUART_CONSOLE=y
CONFIG_SERIAL_CONEXANT_DIGICOLOR=y
# CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=y
CONFIG_GOLDFISH_TTY=y
CONFIG_GOLDFISH_TTY_EARLY_CONSOLE=y
# CONFIG_IPWIRELESS is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set
CONFIG_NULL_TTY=y
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SSIF=y
# CONFIG_IPMI_IPMB is not set
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
# CONFIG_SSIF_IPMI_BMC is not set
# CONFIG_IPMB_DEVICE_INTERFACE is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_BA431=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_CCTRNG is not set
CONFIG_HW_RANDOM_XIPHERA=y
# CONFIG_DTLK is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_CRB=y
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_XILLYBUS_CLASS=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_OF=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_GPMUX=y
CONFIG_I2C_MUX_LTC4306=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_PINCTRL is not set
CONFIG_I2C_MUX_REG=y
CONFIG_I2C_DEMUX_PINCTRL=y
CONFIG_I2C_MUX_MLXCPLD=y
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_CHT_WC=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_SLAVE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_EMEV2 is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_GPIO_FAULT_INJECTOR is not set
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
CONFIG_I2C_RK3X=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PCI1XXXX is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_FSI=y
CONFIG_I2C_VIRTIO=y
# end of I2C Hardware Bus support

# CONFIG_I2C_STUB is not set
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
CONFIG_I2C_SLAVE_TESTUNIT=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_SPMI_HISI3670=y
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_GPIO=y

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PTP_1588_CLOCK_KVM=y
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_GENERIC_PINCTRL_GROUPS=y
CONFIG_PINMUX=y
CONFIG_GENERIC_PINMUX_FUNCTIONS=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
CONFIG_PINCTRL_AS3722=y
CONFIG_PINCTRL_AXP209=y
CONFIG_PINCTRL_CY8C95X0=y
CONFIG_PINCTRL_DA9062=y
CONFIG_PINCTRL_EQUILIBRIUM=y
CONFIG_PINCTRL_MAX77620=y
# CONFIG_PINCTRL_MCP23S08 is not set
CONFIG_PINCTRL_MICROCHIP_SGPIO=y
CONFIG_PINCTRL_OCELOT=y
CONFIG_PINCTRL_SINGLE=y
CONFIG_PINCTRL_STMFX=y
CONFIG_PINCTRL_SX150X=y

#
# Intel pinctrl drivers
#
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
CONFIG_PINCTRL_LYNXPOINT=y
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_ALDERLAKE is not set
CONFIG_PINCTRL_BROXTON=y
CONFIG_PINCTRL_CANNONLAKE=y
# CONFIG_PINCTRL_CEDARFORK is not set
CONFIG_PINCTRL_DENVERTON=y
# CONFIG_PINCTRL_ELKHARTLAKE is not set
CONFIG_PINCTRL_EMMITSBURG=y
CONFIG_PINCTRL_GEMINILAKE=y
CONFIG_PINCTRL_ICELAKE=y
CONFIG_PINCTRL_JASPERLAKE=y
# CONFIG_PINCTRL_LAKEFIELD is not set
CONFIG_PINCTRL_LEWISBURG=y
CONFIG_PINCTRL_METEORLAKE=y
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_PINCTRL_TIGERLAKE=y
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
# CONFIG_GPIO_ALTERA is not set
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_CADENCE=y
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_FTGPIO010=y
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_GRGPIO is not set
CONFIG_GPIO_HLWD=y
# CONFIG_GPIO_LOGICVC is not set
# CONFIG_GPIO_MB86S7X is not set
CONFIG_GPIO_SIFIVE=y
CONFIG_GPIO_SYSCON=y
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_WCD934X=y
CONFIG_GPIO_XILINX=y
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_IT87=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_WINBOND=y
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADNP=y
# CONFIG_GPIO_FXL6408 is not set
# CONFIG_GPIO_GW_PLD is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCA9570=y
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_BD71815 is not set
CONFIG_GPIO_BD71828=y
CONFIG_GPIO_DA9055=y
# CONFIG_GPIO_ELKHARTLAKE is not set
CONFIG_GPIO_KEMPLD=y
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_LP873X=y
CONFIG_GPIO_LP87565=y
CONFIG_GPIO_MAX77620=y
CONFIG_GPIO_MAX77650=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS65218=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# CONFIG_GPIO_SODAVILLE is not set
# end of PCI GPIO expanders

#
# Virtual GPIO drivers
#
CONFIG_GPIO_AGGREGATOR=y
CONFIG_GPIO_LATCH=y
CONFIG_GPIO_MOCKUP=y
CONFIG_GPIO_VIRTIO=y
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_GPIO=y
# CONFIG_W1_MASTER_SGI is not set
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2405=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2406 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2805=y
CONFIG_W1_SLAVE_DS2430=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2438=y
# CONFIG_W1_SLAVE_DS250X is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_DS28E17=y
# end of 1-wire Slaves

CONFIG_POWER_RESET=y
CONFIG_POWER_RESET_AS3722=y
# CONFIG_POWER_RESET_ATC260X is not set
CONFIG_POWER_RESET_GPIO=y
CONFIG_POWER_RESET_GPIO_RESTART=y
# CONFIG_POWER_RESET_LTC2952 is not set
CONFIG_POWER_RESET_MT6323=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_RESET_TPS65086=y
# CONFIG_POWER_RESET_SYSCON is not set
CONFIG_POWER_RESET_SYSCON_POWEROFF=y
CONFIG_REBOOT_MODE=y
CONFIG_SYSCON_REBOOT_MODE=y
# CONFIG_NVMEM_REBOOT_MODE is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_IP5XXX_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_CHARGER_ADP5061=y
# CONFIG_BATTERY_ACT8945A is not set
CONFIG_BATTERY_CW2015=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SAMSUNG_SDI=y
CONFIG_BATTERY_WM97XX=y
CONFIG_BATTERY_SBS=y
CONFIG_CHARGER_SBS=y
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
CONFIG_BATTERY_DA9030=y
CONFIG_CHARGER_DA9150=y
# CONFIG_BATTERY_DA9150 is not set
# CONFIG_CHARGER_AXP20X is not set
# CONFIG_BATTERY_AXP20X is not set
# CONFIG_AXP20X_POWER is not set
# CONFIG_AXP288_FUEL_GAUGE is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_MAX1721X is not set
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_LT3651 is not set
CONFIG_CHARGER_LTC4162L=y
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_DETECTOR_MAX14656=y
CONFIG_CHARGER_MAX77650=y
CONFIG_CHARGER_MAX77693=y
CONFIG_CHARGER_MAX77976=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24257=y
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_BQ2515X is not set
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_BQ25980=y
CONFIG_CHARGER_BQ256XX=y
CONFIG_CHARGER_TPS65217=y
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_BATTERY_RT5033=y
CONFIG_CHARGER_RT9455=y
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_SMPRO=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_AHT10=y
CONFIG_SENSORS_AS370=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_AXI_FAN_CONTROL=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DRIVETEMP=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DELL_SMM=y
CONFIG_I8K=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_I5500 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC2947=y
CONFIG_SENSORS_LTC2947_I2C=y
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC2992=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX127=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX31730=y
CONFIG_SENSORS_MAX31760=y
CONFIG_SENSORS_MAX6620=y
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MC34VR500=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_MLXREG_FAN is not set
CONFIG_SENSORS_TC654=y
CONFIG_SENSORS_TPS23861=y
# CONFIG_SENSORS_MENF21BMC_HWMON is not set
# CONFIG_SENSORS_MR75203 is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775_CORE=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NCT6775_I2C=y
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_OCC_P8_I2C is not set
CONFIG_SENSORS_OXP=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_PECI_CPUTEMP=y
CONFIG_SENSORS_PECI_DIMMTEMP=y
CONFIG_SENSORS_PECI=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_PWM_FAN=y
CONFIG_SENSORS_SBTSI=y
CONFIG_SENSORS_SBRMI=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHT3x=y
# CONFIG_SENSORS_SHT4x is not set
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC2305=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_STTS751 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA238 is not set
CONFIG_SENSORS_INA3221=y
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP108=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TMP464=y
CONFIG_SENSORS_TMP513=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83773G=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_SENSORS_ASUS_EC=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
CONFIG_THERMAL_STATISTICS=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
# CONFIG_THERMAL_HWMON is not set
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_WRITABLE_TRIPS is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
CONFIG_DEVFREQ_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_THERMAL_MMIO is not set
CONFIG_MAX77620_THERMAL=y
# CONFIG_DA9062_THERMAL is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
# CONFIG_WATCHDOG is not set
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
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_ACT8945A=y
# CONFIG_MFD_AS3711 is not set
CONFIG_MFD_SMPRO=y
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_ATMEL_FLEXCOM is not set
# CONFIG_MFD_ATMEL_HLCDC is not set
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_BD9571MWV is not set
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
# CONFIG_MFD_MADERA is not set
# CONFIG_MFD_MAX597X is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_DA9150=y
# CONFIG_MFD_GATEWORKS_GSC is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_MFD_MP2629=y
CONFIG_MFD_HI6421_PMIC=y
CONFIG_MFD_HI6421_SPMI=y
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_INTEL_SOC_PMIC_CHTWC=y
CONFIG_INTEL_SOC_PMIC_CHTDC_TI=y
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_IQS62X=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77620=y
CONFIG_MFD_MAX77650=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX77714=y
# CONFIG_MFD_MAX77843 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_MT6360=y
CONFIG_MFD_MT6370=y
CONFIG_MFD_MT6397=y
CONFIG_MFD_MENF21BMC=y
# CONFIG_MFD_NTXEC is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RT4831=y
CONFIG_MFD_RT5033=y
CONFIG_MFD_RT5120=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_RK808 is not set
CONFIG_MFD_RN5T618=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SIMPLE_MFD_I2C=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SKY81452=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# end of STMicroelectronics STMPE Interface Drivers

CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_TI_LMU=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TI_LP87565=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS65219 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TQMX86 is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_LOCHNAGAR is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_CS47L24=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8998 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
# CONFIG_MFD_ROHM_BD718XX is not set
CONFIG_MFD_ROHM_BD71828=y
CONFIG_MFD_ROHM_BD957XMUF=y
CONFIG_MFD_STPMIC1=y
CONFIG_MFD_STMFX=y
CONFIG_MFD_WCD934X=y
CONFIG_MFD_ATC260X=y
CONFIG_MFD_ATC260X_I2C=y
CONFIG_MFD_QCOM_PM8008=y
CONFIG_MFD_RSMU_I2C=y
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=y
# CONFIG_LIRC is not set
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_IR_IMON_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
# CONFIG_IR_SHARP_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
CONFIG_IR_XMP_DECODER=y
CONFIG_RC_DEVICES=y
CONFIG_IR_ENE=y
CONFIG_IR_FINTEK=y
CONFIG_IR_GPIO_CIR=y
CONFIG_IR_HIX5HD2=y
# CONFIG_IR_ITE_CIR is not set
CONFIG_IR_NUVOTON=y
# CONFIG_IR_SERIAL is not set
CONFIG_IR_WINBOND_CIR=y
# CONFIG_RC_LOOPBACK is not set
CONFIG_CEC_CORE=y
CONFIG_CEC_NOTIFIER=y

#
# CEC support
#
# CONFIG_MEDIA_CEC_RC is not set
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_CEC_CH7322=y
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=y
# CONFIG_MEDIA_SUPPORT_FILTER is not set
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=y
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_V4L2_FLASH_LED_CLASS is not set
CONFIG_V4L2_FWNODE=y
CONFIG_V4L2_ASYNC=y
# end of Video4Linux options

#
# Media controller options
#
# CONFIG_MEDIA_CONTROLLER_DVB is not set
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=y
CONFIG_DVB_ULE_DEBUG=y
# end of Digital TV options

#
# Media drivers
#

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_SI4713=y
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=y
# CONFIG_PLATFORM_SI4713 is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_V4L_RADIO_ISA_DRIVERS is not set
CONFIG_MEDIA_PLATFORM_DRIVERS=y
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_SDR_PLATFORM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_DEINTERLACE is not set
CONFIG_VIDEO_MUX=y

#
# Allegro DVT media platform drivers
#

#
# Amlogic media platform drivers
#

#
# Amphion drivers
#

#
# Aspeed media platform drivers
#

#
# Atmel media platform drivers
#

#
# Cadence media platform drivers
#
CONFIG_VIDEO_CADENCE_CSI2RX=y
CONFIG_VIDEO_CADENCE_CSI2TX=y

#
# Chips&Media media platform drivers
#

#
# Intel media platform drivers
#

#
# Marvell media platform drivers
#
# CONFIG_VIDEO_CAFE_CCIC is not set

#
# Mediatek media platform drivers
#

#
# Microchip Technology, Inc. media platform drivers
#

#
# NVidia media platform drivers
#

#
# NXP media platform drivers
#

#
# Qualcomm media platform drivers
#

#
# Renesas media platform drivers
#

#
# Rockchip media platform drivers
#

#
# Samsung media platform drivers
#

#
# STMicroelectronics media platform drivers
#

#
# Sunxi media platform drivers
#

#
# Texas Instruments drivers
#

#
# Verisilicon media platform drivers
#

#
# VIA media platform drivers
#

#
# Xilinx media platform drivers
#
# CONFIG_VIDEO_XILINX is not set

#
# MMC/SDIO DVB adapters
#
CONFIG_SMS_SDIO_DRV=y
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=y
# CONFIG_SMS_SIANO_RC is not set
# end of Media drivers

CONFIG_MEDIA_HIDE_ANCILLARY_SUBDRV=y

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y

#
# IR I2C driver auto-selected by 'Autoselect ancillary drivers'
#
CONFIG_VIDEO_IR_I2C=y

#
# Camera sensor devices
#
CONFIG_VIDEO_APTINA_PLL=y
CONFIG_VIDEO_CCS_PLL=y
# CONFIG_VIDEO_AR0521 is not set
CONFIG_VIDEO_HI556=y
CONFIG_VIDEO_HI846=y
# CONFIG_VIDEO_HI847 is not set
# CONFIG_VIDEO_IMX208 is not set
# CONFIG_VIDEO_IMX214 is not set
CONFIG_VIDEO_IMX219=y
# CONFIG_VIDEO_IMX258 is not set
CONFIG_VIDEO_IMX274=y
# CONFIG_VIDEO_IMX290 is not set
CONFIG_VIDEO_IMX296=y
# CONFIG_VIDEO_IMX319 is not set
CONFIG_VIDEO_IMX334=y
# CONFIG_VIDEO_IMX335 is not set
CONFIG_VIDEO_IMX355=y
# CONFIG_VIDEO_IMX412 is not set
# CONFIG_VIDEO_IMX415 is not set
CONFIG_VIDEO_MAX9271_LIB=y
CONFIG_VIDEO_MT9M001=y
CONFIG_VIDEO_MT9M111=y
CONFIG_VIDEO_MT9P031=y
CONFIG_VIDEO_MT9T112=y
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_MT9V032=y
# CONFIG_VIDEO_MT9V111 is not set
CONFIG_VIDEO_OG01A1B=y
# CONFIG_VIDEO_OV02A10 is not set
CONFIG_VIDEO_OV08D10=y
# CONFIG_VIDEO_OV08X40 is not set
CONFIG_VIDEO_OV13858=y
CONFIG_VIDEO_OV13B10=y
# CONFIG_VIDEO_OV2640 is not set
CONFIG_VIDEO_OV2659=y
CONFIG_VIDEO_OV2680=y
CONFIG_VIDEO_OV2685=y
CONFIG_VIDEO_OV2740=y
CONFIG_VIDEO_OV4689=y
CONFIG_VIDEO_OV5640=y
# CONFIG_VIDEO_OV5645 is not set
# CONFIG_VIDEO_OV5647 is not set
CONFIG_VIDEO_OV5670=y
CONFIG_VIDEO_OV5675=y
CONFIG_VIDEO_OV5693=y
# CONFIG_VIDEO_OV5695 is not set
CONFIG_VIDEO_OV6650=y
CONFIG_VIDEO_OV7251=y
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_OV772X=y
# CONFIG_VIDEO_OV7740 is not set
CONFIG_VIDEO_OV8856=y
CONFIG_VIDEO_OV9282=y
CONFIG_VIDEO_OV9640=y
CONFIG_VIDEO_OV9650=y
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_RDACM20 is not set
CONFIG_VIDEO_RDACM21=y
CONFIG_VIDEO_RJ54N1=y
# CONFIG_VIDEO_S5K5BAF is not set
CONFIG_VIDEO_S5K6A3=y
# CONFIG_VIDEO_ST_VGXY61 is not set
CONFIG_VIDEO_CCS=y
# CONFIG_VIDEO_ET8EK8 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
CONFIG_VIDEO_AK7375=y
CONFIG_VIDEO_DW9714=y
# CONFIG_VIDEO_DW9768 is not set
CONFIG_VIDEO_DW9807_VCM=y
# end of Lens drivers

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=y
# CONFIG_VIDEO_LM3560 is not set
CONFIG_VIDEO_LM3646=y
# end of Flash devices

#
# audio, video and radio I2C drivers auto-selected by 'Autoselect ancillary drivers'
#

#
# Video and audio decoders
#
CONFIG_MEDIA_TUNER=y

#
# Tuner drivers auto-selected by 'Autoselect ancillary drivers'
#
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_XC5000=y

#
# DVB Frontend drivers auto-selected by 'Autoselect ancillary drivers'
#

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Common Interface (EN50221) controller drivers
#

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_VIDEO_CMDLINE=y
CONFIG_VIDEO_NOMODESET=y
# CONFIG_AGP is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_FBDEV_EMULATION is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_DP_AUX_BUS=y
CONFIG_DRM_DISPLAY_HELPER=y
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_GEM_DMA_HELPER=y
CONFIG_DRM_GEM_SHMEM_HELPER=y
CONFIG_DRM_SCHED=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_I2C_NXP_TDA9950=y
# end of I2C encoder or helper chips

#
# ARM devices
#
# CONFIG_DRM_KOMEDA is not set
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_ARM_VERSATILE is not set
CONFIG_DRM_PANEL_ASUS_Z00T_TM5P5_NT35596=y
CONFIG_DRM_PANEL_BOE_BF060Y8M_AJ0=y
CONFIG_DRM_PANEL_BOE_HIMAX8279D=y
CONFIG_DRM_PANEL_BOE_TV101WUM_NL6=y
# CONFIG_DRM_PANEL_DSI_CM is not set
CONFIG_DRM_PANEL_LVDS=y
CONFIG_DRM_PANEL_EBBG_FT8719=y
CONFIG_DRM_PANEL_ELIDA_KD35T133=y
CONFIG_DRM_PANEL_FEIXIN_K101_IM2BA02=y
# CONFIG_DRM_PANEL_FEIYANG_FY07024DI26A30D is not set
CONFIG_DRM_PANEL_HIMAX_HX8394=y
# CONFIG_DRM_PANEL_ILITEK_ILI9881C is not set
# CONFIG_DRM_PANEL_INNOLUX_P079ZCA is not set
CONFIG_DRM_PANEL_JADARD_JD9365DA_H3=y
CONFIG_DRM_PANEL_JDI_LT070ME05000=y
CONFIG_DRM_PANEL_JDI_R63452=y
CONFIG_DRM_PANEL_KHADAS_TS050=y
# CONFIG_DRM_PANEL_KINGDISPLAY_KD097D04 is not set
CONFIG_DRM_PANEL_LEADTEK_LTK050H3146W=y
# CONFIG_DRM_PANEL_LEADTEK_LTK500HD1829 is not set
CONFIG_DRM_PANEL_NEWVISION_NV3051D=y
# CONFIG_DRM_PANEL_NOVATEK_NT35510 is not set
CONFIG_DRM_PANEL_NOVATEK_NT35560=y
CONFIG_DRM_PANEL_NOVATEK_NT35950=y
# CONFIG_DRM_PANEL_NOVATEK_NT36523 is not set
CONFIG_DRM_PANEL_NOVATEK_NT36672A=y
CONFIG_DRM_PANEL_MANTIX_MLAF057WE51=y
CONFIG_DRM_PANEL_OLIMEX_LCD_OLINUXINO=y
CONFIG_DRM_PANEL_ORISETECH_OTM8009A=y
CONFIG_DRM_PANEL_OSD_OSD101T2587_53TS=y
# CONFIG_DRM_PANEL_PANASONIC_VVX10F034N00 is not set
CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN=y
CONFIG_DRM_PANEL_RAYDIUM_RM67191=y
CONFIG_DRM_PANEL_RAYDIUM_RM68200=y
CONFIG_DRM_PANEL_RONBO_RB070D30=y
CONFIG_DRM_PANEL_SAMSUNG_S6D16D0=y
CONFIG_DRM_PANEL_SAMSUNG_S6E3HA2=y
# CONFIG_DRM_PANEL_SAMSUNG_S6E63J0X03 is not set
CONFIG_DRM_PANEL_SAMSUNG_S6E63M0=y
# CONFIG_DRM_PANEL_SAMSUNG_S6E63M0_DSI is not set
CONFIG_DRM_PANEL_SAMSUNG_S6E88A0_AMS452EF01=y
CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=y
CONFIG_DRM_PANEL_SAMSUNG_SOFEF00=y
CONFIG_DRM_PANEL_SEIKO_43WVF1G=y
# CONFIG_DRM_PANEL_SHARP_LQ101R1SX01 is not set
# CONFIG_DRM_PANEL_SHARP_LS043T1LE01 is not set
# CONFIG_DRM_PANEL_SHARP_LS060T1SX01 is not set
# CONFIG_DRM_PANEL_SITRONIX_ST7701 is not set
CONFIG_DRM_PANEL_SITRONIX_ST7703=y
# CONFIG_DRM_PANEL_SONY_TD4353_JDI is not set
CONFIG_DRM_PANEL_SONY_TULIP_TRULY_NT35521=y
# CONFIG_DRM_PANEL_TDO_TL070WSH30 is not set
CONFIG_DRM_PANEL_TRULY_NT35597_WQXGA=y
CONFIG_DRM_PANEL_VISIONOX_RM69299=y
# CONFIG_DRM_PANEL_VISIONOX_VTDR6130 is not set
# CONFIG_DRM_PANEL_XINPENG_XPP055C272 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_CHIPONE_ICN6211=y
CONFIG_DRM_CHRONTEL_CH7033=y
CONFIG_DRM_DISPLAY_CONNECTOR=y
CONFIG_DRM_ITE_IT6505=y
CONFIG_DRM_LONTIUM_LT8912B=y
# CONFIG_DRM_LONTIUM_LT9211 is not set
CONFIG_DRM_LONTIUM_LT9611=y
CONFIG_DRM_LONTIUM_LT9611UXC=y
# CONFIG_DRM_ITE_IT66121 is not set
CONFIG_DRM_LVDS_CODEC=y
CONFIG_DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW=y
# CONFIG_DRM_NWL_MIPI_DSI is not set
CONFIG_DRM_NXP_PTN3460=y
CONFIG_DRM_PARADE_PS8622=y
CONFIG_DRM_PARADE_PS8640=y
# CONFIG_DRM_SAMSUNG_DSIM is not set
# CONFIG_DRM_SIL_SII8620 is not set
CONFIG_DRM_SII902X=y
CONFIG_DRM_SII9234=y
CONFIG_DRM_SIMPLE_BRIDGE=y
# CONFIG_DRM_THINE_THC63LVD1024 is not set
CONFIG_DRM_TOSHIBA_TC358762=y
# CONFIG_DRM_TOSHIBA_TC358764 is not set
# CONFIG_DRM_TOSHIBA_TC358767 is not set
CONFIG_DRM_TOSHIBA_TC358768=y
CONFIG_DRM_TOSHIBA_TC358775=y
CONFIG_DRM_TI_DLPC3433=y
CONFIG_DRM_TI_TFP410=y
CONFIG_DRM_TI_SN65DSI83=y
# CONFIG_DRM_TI_SN65DSI86 is not set
CONFIG_DRM_TI_TPD12S015=y
# CONFIG_DRM_ANALOGIX_ANX6345 is not set
CONFIG_DRM_ANALOGIX_ANX78XX=y
CONFIG_DRM_ANALOGIX_DP=y
CONFIG_DRM_ANALOGIX_ANX7625=y
CONFIG_DRM_I2C_ADV7511=y
CONFIG_DRM_I2C_ADV7511_AUDIO=y
# CONFIG_DRM_I2C_ADV7511_CEC is not set
CONFIG_DRM_CDNS_DSI=y
# CONFIG_DRM_CDNS_DSI_J721E is not set
CONFIG_DRM_CDNS_MHDP8546=y
# end of Display Interface Bridges

CONFIG_DRM_ETNAVIV=y
CONFIG_DRM_ETNAVIV_THERMAL=y
# CONFIG_DRM_LOGICVC is not set
CONFIG_DRM_ARCPGU=y
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_SIMPLEDRM=y
# CONFIG_DRM_VBOXVIDEO is not set
CONFIG_DRM_SSD130X=y
# CONFIG_DRM_SSD130X_I2C is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_PRIVACY_SCREEN=y

#
# Frame buffer Devices
#
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_BACKLIGHT=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_SSD1307=y
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_KTD253=y
# CONFIG_BACKLIGHT_KTZ8866 is not set
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_MT6370=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_QCOM_WLED=y
# CONFIG_BACKLIGHT_RT4831 is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_SKY81452=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_BACKLIGHT_LED=y
# end of Backlight & LCD device support

CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER=y
# end of Console display driver support

CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

CONFIG_DRM_ACCEL=y
# CONFIG_DRM_ACCEL_QAIC is not set
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_PCM_ELD=y
CONFIG_SND_PCM_IEC958=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQ_DEVICE=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
# CONFIG_SND_OSSEMUL is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_PROC_FS=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_CTL_FAST_LOOKUP=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
# CONFIG_SND_CTL_INPUT_VALIDATION is not set
CONFIG_SND_CTL_DEBUG=y
CONFIG_SND_JACK_INJECTION_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_SEQ_MIDI_EVENT=y
CONFIG_SND_SEQ_MIDI=y
CONFIG_SND_SEQ_VIRMIDI=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=y
# CONFIG_SND_MTPAV is not set
CONFIG_SND_SERIAL_U16550=y
# CONFIG_SND_MPU401 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SE6X is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
# end of HD-Audio

CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=y
CONFIG_SND_INTEL_SOUNDWIRE_ACPI=y
# CONFIG_SND_INTEL_BYT_PREFER_SOF is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=y
CONFIG_SND_PDAUDIOCF=y
CONFIG_SND_SOC=y
CONFIG_SND_SOC_AC97_BUS=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
CONFIG_SND_SOC_ACPI=y
# CONFIG_SND_SOC_ADI is not set
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_SOC_AMD_RENOIR is not set
# CONFIG_SND_SOC_AMD_ACP5x is not set
# CONFIG_SND_SOC_AMD_ACP6x is not set
# CONFIG_SND_AMD_ACP_CONFIG is not set
# CONFIG_SND_SOC_AMD_ACP_COMMON is not set
# CONFIG_SND_SOC_AMD_RPL_ACP6x is not set
# CONFIG_SND_SOC_AMD_PS is not set
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_SOC_MIKROE_PROTO=y
CONFIG_SND_BCM63XX_I2S_WHISTLER=y
CONFIG_SND_DESIGNWARE_I2S=y
CONFIG_SND_DESIGNWARE_PCM=y

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_ASRC=y
CONFIG_SND_SOC_FSL_SAI=y
# CONFIG_SND_SOC_FSL_MQS is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
CONFIG_SND_SOC_FSL_SSI=y
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
CONFIG_SND_SOC_FSL_MICFIL=y
# CONFIG_SND_SOC_FSL_EASRC is not set
CONFIG_SND_SOC_FSL_XCVR=y
CONFIG_SND_SOC_FSL_UTILS=y
CONFIG_SND_SOC_IMX_AUDMUX=y
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_I2S_HI6210_I2S is not set
# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SOC_INTEL_CATPT=y
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=y
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=y
# CONFIG_SND_SOC_INTEL_SKYLAKE is not set
# CONFIG_SND_SOC_INTEL_SKL is not set
# CONFIG_SND_SOC_INTEL_APL is not set
# CONFIG_SND_SOC_INTEL_KBL is not set
# CONFIG_SND_SOC_INTEL_GLK is not set
# CONFIG_SND_SOC_INTEL_CNL is not set
# CONFIG_SND_SOC_INTEL_CFL is not set
# CONFIG_SND_SOC_INTEL_CML_H is not set
# CONFIG_SND_SOC_INTEL_CML_LP is not set
CONFIG_SND_SOC_ACPI_INTEL_MATCH=y
# CONFIG_SND_SOC_INTEL_AVS is not set
CONFIG_SND_SOC_INTEL_MACH=y
CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES=y
CONFIG_SND_SOC_MTK_BTCVSD=y
CONFIG_SND_SOC_SOF_TOPLEVEL=y
# CONFIG_SND_SOC_SOF_PCI is not set
CONFIG_SND_SOC_SOF_ACPI=y
CONFIG_SND_SOC_SOF_ACPI_DEV=y
# CONFIG_SND_SOC_SOF_OF is not set
CONFIG_SND_SOC_SOF=y
CONFIG_SND_SOC_SOF_IPC3=y
# CONFIG_SND_SOC_SOF_AMD_TOPLEVEL is not set
CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL=y
CONFIG_SND_SOC_SOF_INTEL_HIFI_EP_IPC=y
CONFIG_SND_SOC_SOF_INTEL_ATOM_HIFI_EP=y
CONFIG_SND_SOC_SOF_INTEL_COMMON=y
CONFIG_SND_SOC_SOF_BAYTRAIL=y
CONFIG_SND_SOC_SOF_BROADWELL=y
CONFIG_SND_SOC_SOF_XTENSA=y

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

CONFIG_SND_SOC_XILINX_I2S=y
CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER=y
CONFIG_SND_SOC_XILINX_SPDIF=y
# CONFIG_SND_SOC_XTFPGA_I2S is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_WM_ADSP=y
CONFIG_SND_SOC_AC97_CODEC=y
CONFIG_SND_SOC_ADAU_UTILS=y
CONFIG_SND_SOC_ADAU1372=y
CONFIG_SND_SOC_ADAU1372_I2C=y
CONFIG_SND_SOC_ADAU1701=y
# CONFIG_SND_SOC_ADAU1761_I2C is not set
CONFIG_SND_SOC_ADAU7002=y
CONFIG_SND_SOC_ADAU7118=y
# CONFIG_SND_SOC_ADAU7118_HW is not set
CONFIG_SND_SOC_ADAU7118_I2C=y
CONFIG_SND_SOC_AK4118=y
CONFIG_SND_SOC_AK4375=y
CONFIG_SND_SOC_AK4458=y
CONFIG_SND_SOC_AK4554=y
CONFIG_SND_SOC_AK4613=y
CONFIG_SND_SOC_AK4642=y
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
CONFIG_SND_SOC_ALC5623=y
# CONFIG_SND_SOC_AW8738 is not set
# CONFIG_SND_SOC_AW88395 is not set
CONFIG_SND_SOC_BD28623=y
# CONFIG_SND_SOC_BT_SCO is not set
CONFIG_SND_SOC_CS35L32=y
CONFIG_SND_SOC_CS35L33=y
CONFIG_SND_SOC_CS35L34=y
CONFIG_SND_SOC_CS35L35=y
CONFIG_SND_SOC_CS35L36=y
CONFIG_SND_SOC_CS35L41_LIB=y
CONFIG_SND_SOC_CS35L41=y
CONFIG_SND_SOC_CS35L41_I2C=y
CONFIG_SND_SOC_CS35L45=y
CONFIG_SND_SOC_CS35L45_I2C=y
# CONFIG_SND_SOC_CS35L56_I2C is not set
CONFIG_SND_SOC_CS42L42_CORE=y
CONFIG_SND_SOC_CS42L42=y
# CONFIG_SND_SOC_CS42L51_I2C is not set
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L56=y
# CONFIG_SND_SOC_CS42L73 is not set
CONFIG_SND_SOC_CS42L83=y
# CONFIG_SND_SOC_CS4234 is not set
CONFIG_SND_SOC_CS4265=y
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
CONFIG_SND_SOC_CS43130=y
CONFIG_SND_SOC_CS4341=y
CONFIG_SND_SOC_CS4349=y
CONFIG_SND_SOC_CS53L30=y
CONFIG_SND_SOC_CX2072X=y
CONFIG_SND_SOC_DA7213=y
CONFIG_SND_SOC_DMIC=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_ES7134=y
# CONFIG_SND_SOC_ES7241 is not set
# CONFIG_SND_SOC_ES8316 is not set
# CONFIG_SND_SOC_ES8326 is not set
# CONFIG_SND_SOC_ES8328_I2C is not set
CONFIG_SND_SOC_GTM601=y
# CONFIG_SND_SOC_HDA is not set
CONFIG_SND_SOC_ICS43432=y
CONFIG_SND_SOC_INNO_RK3036=y
CONFIG_SND_SOC_MAX98088=y
# CONFIG_SND_SOC_MAX98090 is not set
# CONFIG_SND_SOC_MAX98357A is not set
CONFIG_SND_SOC_MAX98504=y
CONFIG_SND_SOC_MAX9867=y
# CONFIG_SND_SOC_MAX98927 is not set
CONFIG_SND_SOC_MAX98520=y
# CONFIG_SND_SOC_MAX98373_I2C is not set
# CONFIG_SND_SOC_MAX98390 is not set
CONFIG_SND_SOC_MAX98396=y
# CONFIG_SND_SOC_MAX9860 is not set
CONFIG_SND_SOC_MSM8916_WCD_ANALOG=y
CONFIG_SND_SOC_MSM8916_WCD_DIGITAL=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1789=y
CONFIG_SND_SOC_PCM1789_I2C=y
CONFIG_SND_SOC_PCM179X=y
CONFIG_SND_SOC_PCM179X_I2C=y
# CONFIG_SND_SOC_PCM186X_I2C is not set
CONFIG_SND_SOC_PCM3060=y
CONFIG_SND_SOC_PCM3060_I2C=y
CONFIG_SND_SOC_PCM3168A=y
CONFIG_SND_SOC_PCM3168A_I2C=y
# CONFIG_SND_SOC_PCM5102A is not set
# CONFIG_SND_SOC_PCM512x_I2C is not set
CONFIG_SND_SOC_RK3328=y
CONFIG_SND_SOC_RL6231=y
CONFIG_SND_SOC_RT5616=y
CONFIG_SND_SOC_RT5631=y
# CONFIG_SND_SOC_RT5640 is not set
CONFIG_SND_SOC_RT5659=y
CONFIG_SND_SOC_RT9120=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
CONFIG_SND_SOC_SIMPLE_AMPLIFIER=y
# CONFIG_SND_SOC_SIMPLE_MUX is not set
# CONFIG_SND_SOC_SMA1303 is not set
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SRC4XXX_I2C=y
CONFIG_SND_SOC_SRC4XXX=y
CONFIG_SND_SOC_SSM2305=y
CONFIG_SND_SOC_SSM2518=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_SSM2602_I2C=y
CONFIG_SND_SOC_SSM4567=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA350=y
CONFIG_SND_SOC_STI_SAS=y
CONFIG_SND_SOC_TAS2552=y
# CONFIG_SND_SOC_TAS2562 is not set
CONFIG_SND_SOC_TAS2764=y
CONFIG_SND_SOC_TAS2770=y
CONFIG_SND_SOC_TAS2780=y
CONFIG_SND_SOC_TAS5086=y
# CONFIG_SND_SOC_TAS571X is not set
CONFIG_SND_SOC_TAS5720=y
# CONFIG_SND_SOC_TAS5805M is not set
# CONFIG_SND_SOC_TAS6424 is not set
CONFIG_SND_SOC_TDA7419=y
# CONFIG_SND_SOC_TFA9879 is not set
CONFIG_SND_SOC_TFA989X=y
# CONFIG_SND_SOC_TLV320ADC3XXX is not set
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_TLV320AIC23_I2C=y
CONFIG_SND_SOC_TLV320AIC31XX=y
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC3X_I2C is not set
CONFIG_SND_SOC_TLV320ADCX140=y
CONFIG_SND_SOC_TS3A227E=y
CONFIG_SND_SOC_TSCS42XX=y
# CONFIG_SND_SOC_TSCS454 is not set
CONFIG_SND_SOC_UDA1334=y
CONFIG_SND_SOC_WCD9335=y
# CONFIG_SND_SOC_WCD934X is not set
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8524=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
# CONFIG_SND_SOC_WM8731_I2C is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8804_I2C=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8904=y
CONFIG_SND_SOC_WM8940=y
CONFIG_SND_SOC_WM8960=y
CONFIG_SND_SOC_WM8961=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_WM8974=y
# CONFIG_SND_SOC_WM8978 is not set
CONFIG_SND_SOC_WM8985=y
# CONFIG_SND_SOC_MAX9759 is not set
CONFIG_SND_SOC_MT6351=y
# CONFIG_SND_SOC_MT6358 is not set
CONFIG_SND_SOC_MT6660=y
CONFIG_SND_SOC_NAU8315=y
CONFIG_SND_SOC_NAU8540=y
CONFIG_SND_SOC_NAU8810=y
CONFIG_SND_SOC_NAU8821=y
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SOC_LPASS_WSA_MACRO=y
# CONFIG_SND_SOC_LPASS_VA_MACRO is not set
# CONFIG_SND_SOC_LPASS_RX_MACRO is not set
# CONFIG_SND_SOC_LPASS_TX_MACRO is not set
# end of CODEC drivers

CONFIG_SND_SIMPLE_CARD_UTILS=y
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_AUDIO_GRAPH_CARD=y
CONFIG_SND_AUDIO_GRAPH_CARD2=y
CONFIG_SND_AUDIO_GRAPH_CARD2_CUSTOM_SAMPLE=y
# CONFIG_SND_TEST_COMPONENT is not set
CONFIG_SND_X86=y
# CONFIG_SND_VIRTIO is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
# CONFIG_HID is not set
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
CONFIG_PWRSEQ_EMMC=y
# CONFIG_PWRSEQ_SIMPLE is not set
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_USDHI6ROL0=y
# CONFIG_MMC_CQHCI is not set
CONFIG_MMC_HSQ=y
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFS_BSG is not set
CONFIG_SCSI_UFS_HPB=y
# CONFIG_SCSI_UFS_HWMON is not set
# CONFIG_SCSI_UFSHCD_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
CONFIG_LEDS_CLASS_MULTICOLOR=y
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_AN30259A is not set
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_AW2013=y
CONFIG_LEDS_BCM6328=y
CONFIG_LEDS_BCM6358=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_LM3692X=y
# CONFIG_LEDS_MT6323 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP3952=y
CONFIG_LEDS_LP50XX=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8860 is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA955X_GPIO is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_BD2606MVV is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_MAX77650=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_MENF21BMC=y
CONFIG_LEDS_IS31FL319X=y
CONFIG_LEDS_IS31FL32XX=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_SYSCON is not set
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
CONFIG_LEDS_NIC78BX=y
CONFIG_LEDS_TI_LMU_COMMON=y
# CONFIG_LEDS_LM3697 is not set
# CONFIG_LEDS_LM36274 is not set
CONFIG_LEDS_LGM=y

#
# Flash and Torch LED drivers
#
CONFIG_LEDS_AAT1290=y
CONFIG_LEDS_AS3645A=y
CONFIG_LEDS_KTD2692=y
# CONFIG_LEDS_LM3601X is not set
CONFIG_LEDS_MAX77693=y
# CONFIG_LEDS_MT6360 is not set
# CONFIG_LEDS_MT6370_FLASH is not set
CONFIG_LEDS_RT4505=y
# CONFIG_LEDS_RT8515 is not set
# CONFIG_LEDS_SGM3140 is not set

#
# RGB LED drivers
#
# CONFIG_LEDS_PWM_MULTICOLOR is not set
CONFIG_LEDS_QCOM_LPG=y
# CONFIG_LEDS_MT6370_RGB is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_DISK=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_ACTIVITY=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
CONFIG_LEDS_TRIGGER_PATTERN=y
CONFIG_LEDS_TRIGGER_AUDIO=y
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_DW_AXI_DMAC is not set
CONFIG_FSL_EDMA=y
CONFIG_INTEL_IDMA64=y
# CONFIG_PCH_DMA is not set
# CONFIG_PLX_DMA is not set
CONFIG_XILINX_XDMA=y
CONFIG_XILINX_ZYNQMP_DPDMA=y
CONFIG_QCOM_HIDMA_MGMT=y
CONFIG_QCOM_HIDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_HSU_DMA=y
CONFIG_SF_PDMA=y
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_UDMABUF=y
# CONFIG_DMABUF_MOVE_NOTIFY is not set
CONFIG_DMABUF_DEBUG=y
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
CONFIG_DMABUF_HEAPS_CMA=y
# end of DMABUF options

CONFIG_AUXDISPLAY=y
CONFIG_CHARLCD=y
CONFIG_LINEDISP=y
# CONFIG_HD44780 is not set
# CONFIG_IMG_ASCII_LCD is not set
CONFIG_HT16K33=y
CONFIG_LCD2S=y
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_UIO_PRUSS=y
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO=y
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
# CONFIG_VDPA is not set
CONFIG_VHOST_MENU=y
# CONFIG_VHOST_NET is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
CONFIG_COMEDI=y
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_BOND is not set
# CONFIG_COMEDI_TEST is not set
CONFIG_COMEDI_PARPORT=y
CONFIG_COMEDI_SSV_DNP=y
CONFIG_COMEDI_ISA_DRIVERS=y
# CONFIG_COMEDI_PCL711 is not set
CONFIG_COMEDI_PCL724=y
CONFIG_COMEDI_PCL726=y
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=y
CONFIG_COMEDI_PCL816=y
CONFIG_COMEDI_PCL818=y
# CONFIG_COMEDI_PCM3724 is not set
# CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
CONFIG_COMEDI_AMPLC_PC236_ISA=y
CONFIG_COMEDI_AMPLC_PC263_ISA=y
CONFIG_COMEDI_RTI800=y
CONFIG_COMEDI_RTI802=y
CONFIG_COMEDI_DAC02=y
CONFIG_COMEDI_DAS16M1=y
CONFIG_COMEDI_DAS08_ISA=y
CONFIG_COMEDI_DAS16=y
CONFIG_COMEDI_DAS800=y
CONFIG_COMEDI_DAS1800=y
CONFIG_COMEDI_DAS6402=y
CONFIG_COMEDI_DT2801=y
# CONFIG_COMEDI_DT2811 is not set
CONFIG_COMEDI_DT2814=y
CONFIG_COMEDI_DT2815=y
# CONFIG_COMEDI_DT2817 is not set
# CONFIG_COMEDI_DT282X is not set
# CONFIG_COMEDI_DMM32AT is not set
CONFIG_COMEDI_FL512=y
# CONFIG_COMEDI_AIO_AIO12_8 is not set
# CONFIG_COMEDI_AIO_IIRO_16 is not set
CONFIG_COMEDI_II_PCI20KC=y
CONFIG_COMEDI_C6XDIGIO=y
CONFIG_COMEDI_MPC624=y
CONFIG_COMEDI_ADQ12B=y
CONFIG_COMEDI_NI_AT_A2150=y
CONFIG_COMEDI_NI_AT_AO=y
# CONFIG_COMEDI_NI_ATMIO is not set
CONFIG_COMEDI_NI_ATMIO16D=y
# CONFIG_COMEDI_NI_LABPC_ISA is not set
CONFIG_COMEDI_PCMAD=y
CONFIG_COMEDI_PCMDA12=y
CONFIG_COMEDI_PCMMIO=y
CONFIG_COMEDI_PCMUIO=y
# CONFIG_COMEDI_MULTIQ3 is not set
CONFIG_COMEDI_S526=y
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_8254=y
CONFIG_COMEDI_8255=y
# CONFIG_COMEDI_8255_SA is not set
CONFIG_COMEDI_KCOMEDILIB=y
CONFIG_COMEDI_AMPLC_PC236=y
CONFIG_COMEDI_DAS08=y
CONFIG_COMEDI_ISADMA=y
# CONFIG_COMEDI_TESTS is not set
CONFIG_STAGING=y
# CONFIG_RTLLIB is not set
# CONFIG_RTS5208 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# end of Accelerometers

#
# Analog to digital converters
#
# end of Analog to digital converters

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
# CONFIG_ADT7316_I2C is not set
# end of Analog digital bi-direction converters

#
# Direct Digital Synthesis
#
# end of Direct Digital Synthesis

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y
# end of Network Analyzer, Impedance Converters

#
# Resolver to digital converters
#
# end of Resolver to digital converters
# end of IIO staging drivers

# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set
CONFIG_STAGING_BOARD=y
# CONFIG_MOST_COMPONENTS is not set
# CONFIG_KS7010 is not set
CONFIG_XIL_AXIS_FIFO=y
CONFIG_FIELDBUS_DEV=y
CONFIG_HMS_ANYBUSS_BUS=y
CONFIG_HMS_PROFINET=y
# CONFIG_QLGE is not set
# CONFIG_VME_BUS is not set
CONFIG_GOLDFISH_PIPE=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_ACPI=y
CONFIG_CHROMEOS_LAPTOP=y
CONFIG_CHROMEOS_PSTORE=y
CONFIG_CHROMEOS_TBMC=y
# CONFIG_CROS_EC is not set
CONFIG_CROS_KBD_LED_BACKLIGHT=y
CONFIG_CHROMEOS_PRIVACY_SCREEN=y
CONFIG_MELLANOX_PLATFORM=y
# CONFIG_MLXREG_HOTPLUG is not set
CONFIG_MLXREG_IO=y
# CONFIG_MLXREG_LC is not set
# CONFIG_NVSW_SN2201 is not set
CONFIG_SURFACE_PLATFORMS=y
CONFIG_SURFACE_3_POWER_OPREGION=y
CONFIG_SURFACE_GPE=y
CONFIG_SURFACE_HOTPLUG=y
CONFIG_SURFACE_PRO3_BUTTON=y
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_P2SB is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_MAX9485=y
CONFIG_COMMON_CLK_SI5341=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI514=y
CONFIG_COMMON_CLK_SI544=y
CONFIG_COMMON_CLK_SI570=y
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CDCE925 is not set
CONFIG_COMMON_CLK_CS2000_CP=y
CONFIG_COMMON_CLK_S2MPS11=y
# CONFIG_CLK_TWL6040 is not set
CONFIG_COMMON_CLK_AXI_CLKGEN=y
CONFIG_COMMON_CLK_PWM=y
CONFIG_COMMON_CLK_RS9_PCIE=y
# CONFIG_COMMON_CLK_SI521XX is not set
# CONFIG_COMMON_CLK_VC5 is not set
# CONFIG_COMMON_CLK_VC7 is not set
# CONFIG_COMMON_CLK_BD718XX is not set
# CONFIG_COMMON_CLK_FIXED_MMIO is not set
# CONFIG_CLK_LGM_CGU is not set
CONFIG_XILINX_VCU=y
CONFIG_COMMON_CLK_XLNX_CLKWZRD=y
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

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
# CONFIG_LITEX_SOC_CONTROLLER is not set
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
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_AXP288 is not set
# CONFIG_EXTCON_FSA9480 is not set
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_INTEL_INT3496 is not set
# CONFIG_EXTCON_INTEL_CHT_WC is not set
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX3355=y
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PTN5150=y
CONFIG_EXTCON_RT8973A=y
CONFIG_EXTCON_SM5502=y
CONFIG_EXTCON_USB_GPIO=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_BUFFER_DMA=y
CONFIG_IIO_BUFFER_DMAENGINE=y
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_CONFIGFS=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=y
# CONFIG_IIO_SW_TRIGGER is not set
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
CONFIG_ADXL313=y
CONFIG_ADXL313_I2C=y
# CONFIG_ADXL345_I2C is not set
CONFIG_ADXL355=y
CONFIG_ADXL355_I2C=y
# CONFIG_ADXL367_I2C is not set
CONFIG_ADXL372=y
CONFIG_ADXL372_I2C=y
# CONFIG_BMA180 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
CONFIG_DA280=y
CONFIG_DA311=y
CONFIG_DMARD06=y
CONFIG_DMARD09=y
CONFIG_DMARD10=y
CONFIG_FXLS8962AF=y
CONFIG_FXLS8962AF_I2C=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_KX022A=y
CONFIG_IIO_KX022A_I2C=y
CONFIG_KXSD9=y
CONFIG_KXSD9_I2C=y
# CONFIG_KXCJK1013 is not set
CONFIG_MC3230=y
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7660 is not set
CONFIG_MMA8452=y
CONFIG_MMA9551_CORE=y
# CONFIG_MMA9551 is not set
CONFIG_MMA9553=y
CONFIG_MSA311=y
CONFIG_MXC4005=y
# CONFIG_MXC6255 is not set
CONFIG_STK8312=y
CONFIG_STK8BA50=y
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7091R5 is not set
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD799X=y
# CONFIG_ADI_AXI_ADC is not set
CONFIG_AXP20X_ADC=y
CONFIG_AXP288_ADC=y
CONFIG_DA9150_GPADC=y
CONFIG_ENVELOPE_DETECTOR=y
CONFIG_HX711=y
CONFIG_LTC2471=y
CONFIG_LTC2485=y
# CONFIG_LTC2497 is not set
# CONFIG_MAX1363 is not set
CONFIG_MAX9611=y
# CONFIG_MCP3422 is not set
CONFIG_MEDIATEK_MT6360_ADC=y
CONFIG_MEDIATEK_MT6370_ADC=y
# CONFIG_MP2629_ADC is not set
CONFIG_NAU7802=y
CONFIG_QCOM_VADC_COMMON=y
# CONFIG_QCOM_SPMI_IADC is not set
CONFIG_QCOM_SPMI_VADC=y
# CONFIG_QCOM_SPMI_ADC5 is not set
# CONFIG_RN5T618_ADC is not set
# CONFIG_RICHTEK_RTQ6056 is not set
CONFIG_SD_ADC_MODULATOR=y
CONFIG_STMPE_ADC=y
CONFIG_TI_ADC081C=y
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS7924 is not set
# CONFIG_TI_ADS1100 is not set
# CONFIG_TI_AM335X_ADC is not set
# CONFIG_TWL4030_MADC is not set
# CONFIG_TWL6030_GPADC is not set
CONFIG_VF610_ADC=y
CONFIG_XILINX_XADC=y
# end of Analog to digital converters

#
# Analog to digital and digital to analog converters
#
# end of Analog to digital and digital to analog converters

#
# Analog Front Ends
#
# CONFIG_IIO_RESCALE is not set
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7746=y
# end of Capacitance to digital converters

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=y
# CONFIG_ATLAS_EZO_SENSOR is not set
# CONFIG_BME680 is not set
CONFIG_CCS811=y
# CONFIG_IAQCORE is not set
# CONFIG_SCD30_CORE is not set
CONFIG_SCD4X=y
CONFIG_SENSIRION_SGP30=y
CONFIG_SENSIRION_SGP40=y
CONFIG_SPS30=y
CONFIG_SPS30_I2C=y
CONFIG_SENSEAIR_SUNRISE_CO2=y
CONFIG_VZ89X=y
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
# end of Hid Sensor IIO Common

CONFIG_IIO_MS_SENSORS_I2C=y

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# end of SSP Sensor Common

CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
# CONFIG_AD5446 is not set
# CONFIG_AD5593R is not set
CONFIG_AD5686=y
CONFIG_AD5696_I2C=y
# CONFIG_DPOT_DAC is not set
CONFIG_DS4424=y
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MAX5821 is not set
# CONFIG_MCP4725 is not set
CONFIG_TI_DAC5571=y
CONFIG_VF610_DAC=y
# end of Digital to analog converters

#
# IIO dummy driver
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# end of IIO dummy driver

#
# Filters
#
# end of Filters

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
CONFIG_BMG160=y
CONFIG_BMG160_I2C=y
# CONFIG_FXAS21002C is not set
# CONFIG_MPU3050_I2C is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
CONFIG_MAX30102=y
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
CONFIG_AM2315=y
CONFIG_DHT11=y
# CONFIG_HDC100X is not set
CONFIG_HDC2010=y
CONFIG_HTS221=y
CONFIG_HTS221_I2C=y
CONFIG_HTU21=y
CONFIG_SI7005=y
CONFIG_SI7020=y
# end of Humidity sensors

#
# Inertial measurement units
#
CONFIG_BMI160=y
CONFIG_BMI160_I2C=y
# CONFIG_BOSCH_BNO055_I2C is not set
CONFIG_FXOS8700=y
CONFIG_FXOS8700_I2C=y
# CONFIG_KMX61 is not set
CONFIG_INV_ICM42600=y
CONFIG_INV_ICM42600_I2C=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_INV_MPU6050_I2C=y
CONFIG_IIO_ST_LSM6DSX=y
CONFIG_IIO_ST_LSM6DSX_I2C=y
# CONFIG_IIO_ST_LSM9DS0 is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
CONFIG_ADJD_S311=y
CONFIG_ADUX1020=y
CONFIG_AL3010=y
CONFIG_AL3320A=y
CONFIG_APDS9300=y
# CONFIG_APDS9960 is not set
# CONFIG_AS73211 is not set
# CONFIG_BH1750 is not set
CONFIG_BH1780=y
# CONFIG_CM32181 is not set
CONFIG_CM3232=y
CONFIG_CM3323=y
CONFIG_CM3605=y
CONFIG_CM36651=y
# CONFIG_GP2AP002 is not set
# CONFIG_GP2AP020A00F is not set
CONFIG_IQS621_ALS=y
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_ISL29125=y
CONFIG_JSA1212=y
# CONFIG_ROHM_BU27034 is not set
CONFIG_RPR0521=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=y
CONFIG_LTRF216A=y
# CONFIG_LV0104CS is not set
CONFIG_MAX44000=y
CONFIG_MAX44009=y
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
CONFIG_PA12203001=y
CONFIG_SI1133=y
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
CONFIG_TCS3414=y
CONFIG_TCS3472=y
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2591 is not set
CONFIG_TSL2772=y
CONFIG_TSL4531=y
CONFIG_US5182D=y
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
CONFIG_VEML6030=y
CONFIG_VEML6070=y
CONFIG_VL6180=y
CONFIG_ZOPT2201=y
# end of Light sensors

#
# Magnetometer sensors
#
CONFIG_AK8974=y
CONFIG_AK8975=y
CONFIG_AK09911=y
CONFIG_BMC150_MAGN=y
CONFIG_BMC150_MAGN_I2C=y
# CONFIG_MAG3110 is not set
CONFIG_MMC35240=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y
CONFIG_SENSORS_RM3100=y
CONFIG_SENSORS_RM3100_I2C=y
# CONFIG_TI_TMAG5273 is not set
CONFIG_YAMAHA_YAS530=y
# end of Magnetometer sensors

#
# Multiplexers
#
CONFIG_IIO_MUX=y
# end of Multiplexers

#
# Inclinometer sensors
#
# end of Inclinometer sensors

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
CONFIG_IQS624_POS=y
# end of Linear and angular position sensors

#
# Digital potentiometers
#
# CONFIG_AD5110 is not set
CONFIG_AD5272=y
# CONFIG_DS1803 is not set
CONFIG_MAX5432=y
# CONFIG_MCP4018 is not set
CONFIG_MCP4531=y
# CONFIG_TPL0102 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
CONFIG_BMP280=y
CONFIG_BMP280_I2C=y
CONFIG_DLHL60D=y
# CONFIG_DPS310 is not set
CONFIG_HP03=y
CONFIG_ICP10100=y
CONFIG_MPL115=y
CONFIG_MPL115_I2C=y
CONFIG_MPL3115=y
# CONFIG_MS5611 is not set
CONFIG_MS5637=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_T5403=y
# CONFIG_HP206C is not set
CONFIG_ZPA2326=y
CONFIG_ZPA2326_I2C=y
# end of Pressure sensors

#
# Lightning sensors
#
# end of Lightning sensors

#
# Proximity and distance sensors
#
CONFIG_ISL29501=y
CONFIG_LIDAR_LITE_V2=y
CONFIG_MB1232=y
CONFIG_PING=y
# CONFIG_RFD77402 is not set
CONFIG_SRF04=y
CONFIG_SX_COMMON=y
CONFIG_SX9310=y
CONFIG_SX9324=y
# CONFIG_SX9360 is not set
CONFIG_SX9500=y
# CONFIG_SRF08 is not set
# CONFIG_VCNL3020 is not set
CONFIG_VL53L0X_I2C=y
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_IQS620AT_TEMP is not set
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TMP117 is not set
# CONFIG_TSYS01 is not set
CONFIG_TSYS02D=y
CONFIG_MAX30208=y
# end of Temperature sensors

# CONFIG_NTB is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
CONFIG_PWM_ATMEL_TCB=y
CONFIG_PWM_CLK=y
# CONFIG_PWM_DWC is not set
# CONFIG_PWM_FSL_FTM is not set
CONFIG_PWM_INTEL_LGM=y
CONFIG_PWM_IQS620A=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_LPSS=y
# CONFIG_PWM_LPSS_PCI is not set
CONFIG_PWM_LPSS_PLATFORM=y
CONFIG_PWM_PCA9685=y
# CONFIG_PWM_STMPE is not set
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_PWM_XILINX=y

#
# IRQ chip support
#
CONFIG_IRQCHIP=y
# CONFIG_AL_FIC is not set
# CONFIG_XILINX_INTC is not set
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_GENERIC_PHY_MIPI_DPHY=y
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
CONFIG_BCM_KONA_USB2_PHY=y
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_CADENCE_TORRENT is not set
CONFIG_PHY_CADENCE_DPHY=y
CONFIG_PHY_CADENCE_DPHY_RX=y
# CONFIG_PHY_CADENCE_SALVO is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
CONFIG_PHY_PXA_28NM_USB2=y
CONFIG_PHY_LAN966X_SERDES=y
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_MAPPHONE_MDM6600 is not set
# CONFIG_PHY_OCELOT_SERDES is not set
# CONFIG_PHY_INTEL_LGM_COMBO is not set
CONFIG_PHY_INTEL_LGM_EMMC=y
# end of PHY Subsystem

CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_IDLE_INJECT=y
CONFIG_DTPM=y
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

# CONFIG_RAS is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ANDROID_BINDERFS is not set
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder"
# CONFIG_ANDROID_BINDER_IPC_SELFTEST is not set
# end of Android

CONFIG_DAX=y
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y

#
# Layout Types
#
# CONFIG_NVMEM_LAYOUT_SL28_VPD is not set
# CONFIG_NVMEM_LAYOUT_ONIE_TLV is not set
# end of Layout Types

CONFIG_NVMEM_RMEM=y
# CONFIG_NVMEM_SPMI_SDAM is not set

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
CONFIG_FSI=y
# CONFIG_FSI_NEW_DEV_NODE is not set
CONFIG_FSI_MASTER_GPIO=y
CONFIG_FSI_MASTER_HUB=y
# CONFIG_FSI_MASTER_ASPEED is not set
CONFIG_FSI_SCOM=y
# CONFIG_FSI_SBEFIFO is not set
# CONFIG_TEE is not set
CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
CONFIG_MUX_ADG792A=y
CONFIG_MUX_GPIO=y
CONFIG_MUX_MMIO=y
# end of Multiplexer drivers

CONFIG_PM_OPP=y
# CONFIG_SIOX is not set
CONFIG_SLIMBUS=y
CONFIG_SLIM_QCOM_CTRL=y
CONFIG_INTERCONNECT=y
# CONFIG_COUNTER is not set
CONFIG_MOST=y
CONFIG_MOST_CDEV=y
CONFIG_MOST_SND=y
CONFIG_PECI=y
CONFIG_PECI_CPU=y
CONFIG_HTE=y
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_VALIDATE_FS_PARSER=y
CONFIG_FS_IOMAP=y
CONFIG_LEGACY_DIRECT_IO=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_SUPPORT_ASCII_CI=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DRAIN_INTENTS=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
# CONFIG_XFS_ASSERT_FATAL is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
CONFIG_FS_VERITY=y
CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_VIRTIO_FS=y
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
CONFIG_OVERLAY_FS_INDEX=y
CONFIG_OVERLAY_FS_NFS_EXPORT=y
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
# CONFIG_NETFS_STATS is not set
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_CACHEFILES is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_FAT_DEFAULT_UTF8=y
CONFIG_EXFAT_FS=y
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y
CONFIG_NTFS3_FS=y
CONFIG_NTFS3_LZX_XPRESS=y
# CONFIG_NTFS3_FS_POSIX_ACL is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
CONFIG_MEMFD_CREATE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_FSCACHE is not set
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
# CONFIG_CIFS_FSCACHE is not set
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
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
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
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_KEY_NOTIFICATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_FORTIFY_SOURCE=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_LOADPIN=y
# CONFIG_SECURITY_LOADPIN_ENFORCE is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
# CONFIG_INTEGRITY is not set
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
CONFIG_GCC_PLUGIN_STACKLEAK=y
CONFIG_STACKLEAK_TRACK_MIN_SIZE=100
# CONFIG_STACKLEAK_METRICS is not set
CONFIG_STACKLEAK_RUNTIME_DISABLE=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
CONFIG_INIT_ON_FREE_DEFAULT_ON=y
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
CONFIG_ZERO_CALL_USED_REGS=y
# end of Memory initialization

# CONFIG_RANDSTRUCT_NONE is not set
CONFIG_RANDSTRUCT_FULL=y
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
CONFIG_RANDSTRUCT=y
CONFIG_GCC_PLUGIN_RANDSTRUCT=y
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
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y
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
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SM4_GENERIC is not set
CONFIG_CRYPTO_TWOFISH=y
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
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_OFB=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XCTR=y
# CONFIG_CRYPTO_XTS is not set
CONFIG_CRYPTO_NHPOLY1305=y
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
CONFIG_CRYPTO_AEGIS128=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y
CONFIG_CRYPTO_ESSIV=y
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=y
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_POLYVAL=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_SHA3 is not set
CONFIG_CRYPTO_SM3=y
# CONFIG_CRYPTO_SM3_GENERIC is not set
CONFIG_CRYPTO_STREEBOG=y
CONFIG_CRYPTO_VMAC=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_XXHASH=y
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRCT10DIF=y
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
CONFIG_CRYPTO_ZSTD=y
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
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TWOFISH_586=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
# end of Accelerated Cryptographic Algorithms for CPU (x86)

# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
# CONFIG_FIPS_SIGNATURE_SELFTEST is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
CONFIG_SYSTEM_REVOCATION_LIST=y
CONFIG_SYSTEM_REVOCATION_KEYS=""
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_RAID6_PQ_BENCHMARK=y
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=y
CONFIG_PRIME_NUMBERS=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=1
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC64_ROCKSOFT is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
CONFIG_CRC4=y
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
CONFIG_DECOMPRESS_XZ=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_DMA_CMA=y
CONFIG_DMA_PERNUMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_PERCENTAGE=0
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
CONFIG_DMA_MAP_BENCHMARK=y
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_32=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
# CONFIG_FONT_8x16 is not set
# CONFIG_FONT_6x11 is not set
CONFIG_FONT_7x14=y
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_6x10 is not set
CONFIG_FONT_10x18=y
CONFIG_FONT_SUN8x16=y
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_TER16x32 is not set
# CONFIG_FONT_6x8 is not set
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
CONFIG_STACKTRACE_BUILD_ID=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
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
# CONFIG_DEBUG_INFO_COMPRESSED_ZLIB is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_HEADERS_INSTALL=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_FRAME_POINTER=y
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
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
CONFIG_UBSAN_UNREACHABLE=y
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
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
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
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
# CONFIG_DEBUG_KMAP_LOCAL is not set
CONFIG_ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP=y
# CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
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

CONFIG_DEBUG_TIMEKEEPING=y

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
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_NMI_CHECK_CPU is not set
# CONFIG_DEBUG_IRQFLAGS is not set
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
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_CGROUP_REF is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
CONFIG_OSNOISE_TRACER=y
CONFIG_TIMERLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
CONFIG_UPROBE_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_SYNTH_EVENTS=y
# CONFIG_USER_EVENTS is not set
# CONFIG_HIST_TRIGGERS is not set
# CONFIG_TRACE_EVENT_INJECT is not set
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_TRACE_EVAL_MAP_FILE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_RV is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
# CONFIG_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_FRAME_POINTER=y
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_TEST_DHRY is not set
# CONFIG_LKDTM is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_SCANF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_MAPLE_TREE is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_DYNAMIC_DEBUG is not set
# CONFIG_TEST_KMOD is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
CONFIG_MEMTEST=y
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--mpXzSbgjLJBKxB4+
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
commit
kbuild_queue_analysis'
	export queue='validate'
	export testbox='vm-snb'
	export tbox_group='vm-snb'
	export branch='linux-next/master'
	export commit='59709bb84c22905421dd05fa2a80ece411bec76f'
	export kconfig='i386-randconfig-a014-20230508'
	export repeat_to=6
	export nr_vm=300
	export submit_id='6459de46c7f5213be66efd04'
	export job_file='/lkp/jobs/scheduled/vm-meta-73/boot-1-yocto-i386-minimal-20190520.cgz-59709bb84c22905421dd05fa2a80ece411bec76f-20230509-80870-zjim0s-4.yaml'
	export id='fd2d73f900b21cccc346748be3d54237aa0488e1'
	export queuer_version='/zday/lkp'
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='16G'
	export need_kconfig=\{\"KVM_GUEST\"\=\>\"y\"\}
	export ssh_base_port=23032
	export kernel_cmdline_hw='vmalloc=256M initramfs_async=0 page_owner=on'
	export rootfs='yocto-i386-minimal-20190520.cgz'
	export compiler='gcc-11'
	export enqueue_time='2023-05-09 13:46:46 +0800'
	export _id='6459de5cc7f5213be66efd05'
	export _rt='/result/boot/1/vm-snb/yocto-i386-minimal-20190520.cgz/i386-randconfig-a014-20230508/gcc-11/59709bb84c22905421dd05fa2a80ece411bec76f'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/boot/1/vm-snb/yocto-i386-minimal-20190520.cgz/i386-randconfig-a014-20230508/gcc-11/59709bb84c22905421dd05fa2a80ece411bec76f/3'
	export scheduler_version='/lkp/lkp/.src-20230508-150254'
	export arch='i386'
	export max_uptime=600
	export initrd='/osimage/yocto/yocto-i386-minimal-20190520.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/boot/1/vm-snb/yocto-i386-minimal-20190520.cgz/i386-randconfig-a014-20230508/gcc-11/59709bb84c22905421dd05fa2a80ece411bec76f/3
BOOT_IMAGE=/pkg/linux/i386-randconfig-a014-20230508/gcc-11/59709bb84c22905421dd05fa2a80ece411bec76f/vmlinuz-6.4.0-rc1-00007-g59709bb84c22
branch=linux-next/master
job=/lkp/jobs/scheduled/vm-meta-73/boot-1-yocto-i386-minimal-20190520.cgz-59709bb84c22905421dd05fa2a80ece411bec76f-20230509-80870-zjim0s-4.yaml
user=lkp
ARCH=i386
kconfig=i386-randconfig-a014-20230508
commit=59709bb84c22905421dd05fa2a80ece411bec76f
initcall_debug
mem=4G
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
	export modules_initrd='/pkg/linux/i386-randconfig-a014-20230508/gcc-11/59709bb84c22905421dd05fa2a80ece411bec76f/modules.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-i386.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export stop_repeat_if_found='dmesg.WARNING:at_kernel/workqueue.c:#workqueue_sysfs_register'
	export kbuild_queue_analysis=1
	export meta_host='vm-meta-73'
	export kernel='/pkg/linux/i386-randconfig-a014-20230508/gcc-11/59709bb84c22905421dd05fa2a80ece411bec76f/vmlinuz-6.4.0-rc1-00007-g59709bb84c22'
	export dequeue_time='2023-05-09 13:47:10 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-meta-73/boot-1-yocto-i386-minimal-20190520.cgz-59709bb84c22905421dd05fa2a80ece411bec76f-20230509-80870-zjim0s-4.cgz'

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

--mpXzSbgjLJBKxB4+
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--mpXzSbgjLJBKxB4+--
