Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021121.outbound.protection.outlook.com [52.101.95.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5241E29ACF6;
	Wed, 22 Apr 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883945; cv=fail; b=OmOhhSnf74eLEFFpXEQOpzTyHB0gwB0/+Ev3pFrH6T0iw/tkDH8R5+FKPr6v+KgAAw0DbUPVbgN/0D+xA2rjSQ3wXENuSjiVQdQ8RCgt0WMnP74O4DjjP04AYXLrZvwDX/DrByiSsDYKF4VgOqAFGXbd4gvqSc1yff5X0AMB6SU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883945; c=relaxed/simple;
	bh=iEeQ/pSr/Hl9aCAzpnOcb8l2hxB4ig75wdlL/va/Obw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nWZ7pePVxcelayktH44QlerCuFBebrv5DpUhhUnGvst6s4OuiQl8jkgXeUeF07JQxUcOLqfMXrniBuEXR6G9yXHSId2qBxGBzeRBeCkeOMXxKqwYBihODsB6eAuhgRn/hJHhoRWnzOmCnPK+Gc1faFWz9itQXgExG3/YZzSbbZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H38fQwIsDvLTsqhH7P2nE+jAAaJXcCpgj4f+gDTF0li5URBRB3yaZMuZQz74MZSmVvWC3u64I1h1xir0bn9/BlvX7//BIT17xGc1xP7F1xW9CCe7BE2J99lzoox6QXwCvVO6Wmflq5FFf2U4TQAJag8lX82D5EebHm4EjwhbvHToAvEAptPWaGd8EcS4FxiQFIPkxH8nTQzX8WuFo/C80FMegv05/CZYV3vKNadkl+NoevzSVHi3LCbIVe1OuZ1MiItdVZ2dfmFEAx6zB+5G/qoP3FCYbZwaxDA+C9d9wnjwb6gmZfD/OaI+D0BkD5efEWVDj9yqImi4AUXM6YOUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFv/pNeJVwC5daFPi1h2KP1UfRiWJwyTtw62Rq1uHak=;
 b=e4PJSeqSdi41iubQ0YPyHhuVrTSvvGhNkrjx/pfH5jwnmP5fOVhkGj4eHExddx9L7A+Yd2TX9ukKTP1K4QA07ip1BQhZDjlepq55e9MBS7eWlS2OTXHAk3gaYo8ru/jMkCsFgsayRwxvGFel3B+wmpsYlnGhabKvlEd0PZ0PQlUICH4yZPpiwqkc6IabasS5jO0RT7w2AyB1T9PBouSJLDUtjaFFygQC0Coq93IEqT9AuDoJhBTq7Zfq/b9ATlMZ5grkHxzK1cJ5OmE9z7RZGUqTpvLehFwdmZ1ynPDqXIMweAt6JLsOQj9M++iOYVFLduyZkbpam/JWmT1X5HV3yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:19 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:19 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	mst@redhat.com
Cc: atomlin@atomlin.com,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	liyihang9@h-partners.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	jinpu.wang@cloud.ionos.com,
	tglx@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	maz@kernel.org,
	ruanjinjie@huawei.com,
	bigeasy@linutronix.de,
	yphbchou0911@gmail.com,
	wagi@kernel.org,
	frederic@kernel.org,
	longman@redhat.com,
	chenridong@huawei.com,
	hare@suse.de,
	kch@nvidia.com,
	ming.lei@redhat.com,
	tom.leiming@gmail.com,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v12 00/13] blk: honor isolcpus configuration
Date: Wed, 22 Apr 2026 14:52:02 -0400
Message-ID: <20260422185215.100929-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0173.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::16) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d7cb23-ef68-4e46-bd88-08dea0a047b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|20046099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ra5ziZi6J3Yjw6j53dxLyvb66xLh67ObFOvVoCtJMfaDm0ih0WC5WuglTCdFGIg4zJWJQvSA0ERoBUH0ISaOnI5Lx992OPKiRDUuAO70HAW5eZsw8Kg3I5D7mXxpfSJRWwWEcbEFWzeVdqDiy8H6pApDx6o6Vkk+cJLa0MbyPD1biyl+Ij018rRnESm33jWcjVMmtpxjVVVZdsxW3f3W2aYlKKt7vrsChL6ELwgZ+SROqcvKWBuI0uO3qEBRu+jpryW+Q6x+GrKwUYzyM1MsOehYnUcWABwx90Mi9abna98+l2J1Brr6N+NCgUCx93w84uHzNcaGAjATLUaNjhqTaeTI3qSQLHf85ywRDm/r7bAslqJR9pAs29jwT+mKorlz6saVoCCwsZN+aA0Wrte21Wvx5HnjH+1kArN+YU/lQJrs1kPGPOEVl4cc6Xtv4PP18A8aD3cuLMFV89vNEE/otOflmw7Mc2jHM+kqC6FNKFD74TO5KgQx/KP4380NNjE/uysWLajN4SfcdA/2iCrTQYgRdjoM04CZ0/M5DWrBcFs+HpOVBPtuWgW5L9grFAeKHyw1cM/s02dwtwWW21L/R79vz8Xw1Ic4GmB+KHkzQIAdvrNJYzMckfgn/5ICYN8FCDwOHeJoCagTxCzwWMo1vQAQmMkd1UxgqmvcGA+4Vl8noDspIyeYFhnrpsAQfgcO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(20046099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tqD64izrA8NRFPfYrpjRCeT+nmd+t/0LwfFf3Rw7xhZrxlHbX6UNvLuc89jZ?=
 =?us-ascii?Q?SnZzKh5G/KnYxpbBJuSnmySzjwMHAH8t9vrW81MJdRVgeKxxKMn9OZDqjZhc?=
 =?us-ascii?Q?lzzMscaRi3OAU45vwQHrReXSW9c88bnm+SgDenVdMWVha6wEdqgCl++Uwwl7?=
 =?us-ascii?Q?Lgl2OFGo42LHpNbIoKuz2D68hAb27Dd65NxIME4sXwF/6DZxjAXuWeAxxDJY?=
 =?us-ascii?Q?4cEVPcy1GgzSOESIUZ7DO/RQehvFbWmX4EVSnBP8F38+TFjRjpZCZcMaIZ2A?=
 =?us-ascii?Q?37lHvuTm51XR8cS2qAWbcmNUBbbJ2Re/8pzyR/z+NIe6iTd5A0HAwkyTPEfV?=
 =?us-ascii?Q?mwiH7eRlQTWMMp/Lr2Iq3RVMKFOH4mYdb2Q5HFxH00NsugYGJL+woukkktZR?=
 =?us-ascii?Q?vv5baAmWsPWn9swXr1YAspEMSW6xgvmBlxSydoKOP4td29iaD5lysQb1xmbE?=
 =?us-ascii?Q?XUWPIAlpnyUKKlrVw4M9RtrrE86qIHCf0/gEdS1k7IIqwTi6crUZXaKdrgW4?=
 =?us-ascii?Q?jqZE5apKcJEMzJ97ujkUQRSz/puMF0SiF0uYgMODQmS4F/upEmsSzMPJcZ/R?=
 =?us-ascii?Q?ha8o/loruo/Ay60qn3khlETxVytZt884Q2EiDdRsAL7Jn1k6hnySQ9c8ZItB?=
 =?us-ascii?Q?ONwRvby8K6HssG35Rq/nhOb0iJXEOTm+QYhZDP87OBHWKqyCNsw+L/mtWOen?=
 =?us-ascii?Q?eyPlgpVVo89C+E2jbmUU8dlh4txogB/8ijhm9CS/MyqzoiZaMRMTNBgaR+XQ?=
 =?us-ascii?Q?59zu1qOVbrU2m+yKCmM/4N5IYTUcP4tAX0SiZUlyLavHZe+k/ztYyH8hQQk3?=
 =?us-ascii?Q?hai+NtQYVQ5yRuv08cZIBO3uTXUhVJYSAtb6Y1YGNawC0QG1eMGkRHIRrnk8?=
 =?us-ascii?Q?FnEHbe2oHpomzWofHSR3D/iarcRf2FNSCKb47wMW6vskYJpF4rEfs23xueg3?=
 =?us-ascii?Q?hb2Qiy0NQ0PTJ+eQw+IwgT1RDCqJkPSJI2S+osfk9nYgFt1qoF7RwjX36iyM?=
 =?us-ascii?Q?1ovHKLKFqiotwW+IgMNRYeyE9AtV7TQCnOmlpZpOl7FZWfuLKorBVKWSftnj?=
 =?us-ascii?Q?AXkSKRYiiUgwW3IBR834Wt4VzQVR5BJxyZTqKl17A5ibTQ10V5bLD+1rIMxx?=
 =?us-ascii?Q?JMursn6tFMEJfIps5rvP09N7+xP/vzqDgBngJYJNH68mS8qlYByCBQv08PFc?=
 =?us-ascii?Q?hOhpNLnnxLHTG3WqF5Ur44hneGl4AdeCkH934KVzmwOGZL4dNsdhGddPm01f?=
 =?us-ascii?Q?Ud3SD4tnJ8SRMMbgXSaAXZn2RpUDSQogwDXm6DWQHLos0NNi3TRF1hKEF/Vd?=
 =?us-ascii?Q?knkE9ocJ30Xf6GH8IGrHegQos2e4elmsx/msRUmwMcZBS9AImVJ3ikddGsGk?=
 =?us-ascii?Q?5FNTLWSEqet3XRgsx9v+Q4JPWUvNGqmUxPF2pM0xijWOte/fUCvvwJgOUwmj?=
 =?us-ascii?Q?MMVTw27Xhn43B/2GeRzoiJfzg8MQTFlI6eO+qNWJn9dkq1mZfexfXUh0MwXu?=
 =?us-ascii?Q?dcjHPw3Jz6mHzMvZxn098SmyhGJ16zderKrpzlmqGWzGNNniOIJPRFX/Q2oa?=
 =?us-ascii?Q?Xa5lAfpQ7vSlvWb2vXsSjkIgsPnGKZUYKxdCtgQQBQRWVeQccXgyWSBgaXL1?=
 =?us-ascii?Q?G6MQ7pbX+hDSqYPggvOHtQPpNA4Q/E/GZ/7e0bhuHBbWgQDfcAx4a1OwRh3y?=
 =?us-ascii?Q?nss7RCh5SH+TwN2ItaohYfP1ME1gmXdd7dhAgnXDD8qjCvcHHnyGeIb8myhI?=
 =?us-ascii?Q?n0HaoKCDSA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d7cb23-ef68-4e46-bd88-08dea0a047b9
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:19.4822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIrgaKlG0hHVYhjEhmKBViGtBl3qnpiA//QpHi40VvA3xJvx6PAl9FXq3cTTNhf1+vntSnXxFueWwvaV3heYWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

Hi,

I have decided to drive this series forward on behalf of Daniel Wagner, the
original author. The series has been rebased on v7.0-12635-g6596a02b2078.

Building upon prior iterations, this series introduces critical
architectural refinements to the mapping and affinity spreading algorithms
to guarantee thread safety and resilience against concurrent CPU-hotplug
operations. Previously, the block layer relied on a shared global static
mask (i.e., blk_hk_online_mask), which proved vulnerable to race conditions
during rapid hotplug events. This vulnerability was highlighted by the
kernel test robot, which encountered a NULL pointer dereference during
rcutorture (cpuhotplug) stress testing due to concurrent mask modification.

To resolve this, the architecture has been fundamentally hardened. The
global static state has been eradicated. Instead, the IRQ affinity core now
employs a newly introduced irq_spread_hk_filter(), which safely intersects
the natively calculated affinity mask with the HK_TYPE_IO_QUEUE mask.
Crucially, this is achieved using a local, hotplug-safe snapshot via
data_race(cpu_online_mask). This approach circumvents the hotplug lock
deadlocks previously identified by Thomas Gleixner, while explicitly
avoiding CONFIG_CPUMASK_OFFSTACK stack bloat hazards on high-core-count
systems. A robust fallback mechanism guarantees that should an interrupt
vector be assigned exclusively to isolated cores, it is safely re-routed to
the system's online housekeeping CPUs.

Following rigorous testing of multiple queue maps (such as NVMe poll
queues) alongside isolated CPUs, the tenth iteration resolved a critical
page fault regression. The multi-queue mapping logic has been corrected to
strictly maintain absolute hardware queue indices, ensuring faultless queue
initialisation and preventing out-of-bounds memory access.

Furthermore, following feedback from Ming Lei, the administrative
documentation for isolcpus=io_queue has undergone a comprehensive overhaul
to reflect this architectural reality. Previous iterations lacked the
required technical precision regarding subsystem impact. The expanded
kernel-parameters.txt now explicitly details that this parameter applies
strictly to managed IRQs. It thoroughly documents how the block layer
intercepts multiqueue allocation to match the housekeeping mask, actively
preventing MSI-X vector exhaustion on massive topologies and forcing queue
sharing. Most importantly, it cements the structural guarantee: while an
application on an isolated CPU may freely submit I/O, the hardware
completion interrupt is strictly and safely offloaded to a housekeeping
core.

Please let me know your thoughts.


Changes since v12:

 - Removed duplicate paragraph from the commit message in patch 11
   (Marco Crivellari)

 - Ensure ZERO_SIZE_PTR is not returned by group_mask_cpus_evenly()
   (Marco Crivellari)

 - Linked to v11: https://lore.kernel.org/lkml/20260416192942.1243421-1-atomlin@atomlin.com/

Changes since v11:

 - Completely rewrote the isolcpus=io_queue documentation in
   Documentation/admin-guide/kernel-parameters.txt to clarify its exclusive
   application to managed IRQs, queue allocation limits, vector exhaustion
   prevention, and hardware interrupt routing (Ming Lei)

 - Fixed a stack frame bloat issue by avoiding the on-stack declaration of
   struct cpumask (Waiman Long)

 - Linked to v10: https://lore.kernel.org/linux-nvme/20260401222312.772334-1-atomlin@atomlin.com/

Changes since v10:

 - Fixed a page fault regression encountered when initialising secondary
   queue maps (e.g., NVMe poll queues). Restored the qmap->queue_offset to
   the mq_map assignment to ensure CPUs are strictly mapped to absolute
   hardware indices (Keith Busch)

 - Corrected the active_hctx tracker to utilise relative queue indices,
   preventing out-of-bounds mask assignments

 - Fixed the blk_mq_validate() sanity check to properly evaluate absolute
   queue indices against the offset-adjusted loop index

 - Corrected typographical errors within block/blk-mq-cpumap.c
   (Keith Busch)

 - Clarified the commit message regarding the removal of the !SMP fallback
   code, explicitly noting that the core scheduler now mandates SMP
   unconditionally (Sebastian Andrzej Siewior)

 - Added missing "Signed-off-by:" tags to properly record the patch series
   chain of custody

 - Linked to v9: https://lore.kernel.org/lkml/20260330221047.630206-1-atomlin@atomlin.com/

Changes since v9:

 - Added "Reviewed-by:" tags

 - Introduced irq_spread_hk_filter() to safely restrict managed IRQ
   affinity to housekeeping CPUs (Thomas Gleixner)

 - Removed the unsafe global static variable blk_hk_online_mask from
   blk-mq-cpumap.c and blk-mq.c. blk_mq_online_queue_affinity() now returns
   a stable pointer, delegating safe intersection to the callers to prevent
   concurrent modification races (Thomas Gleixner, Hannes Reinecke)

 - Resolved BUG: kernel NULL pointer dereference in __blk_mq_all_tag_iter
   reported by the kernel test robot during cpuhotplug rcutorture stress
   testing

 - Linked to v8: https://lore.kernel.org/lkml/20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org/

Changes since v8:

 - Added commit 524f5eea4bbe ("lib/group_cpus: remove !SMP code")

 - Merged the new mapping logic directly into the existing function to
   avoid special casing

 - Refined the group_mask_cpus_evenly() implementation with the following
   updates:

   - Corrected the function name typo (changed group_masks_cpus_evenly to
     group_mask_cpus_evenly)

   - Updated the documentation comment to accurately reflect the function's
     behavior

   - Renamed the cpu_mask argument to mask for consistency

 - Added a new patch for aacraid to include the missing number of queues
   calculation

 - Restricted updates to only affect SCSI drivers that support
   PCI_IRQ_AFFINITY and do not utilize nvme-fabrics

 - Removed the __free cleanup attribute usage for cpumask_var_t allocations
   due to compatibility issues

 - Updated the documentation to explicitly highlight the limitations
   surrounding CPU offlining

 - Collected accumulated Reviewed-by and Acked-by tags

 - Linked to v7: https://patch.msgid.link/20250702-isolcpus-io-queues-v7-0-557aa7eacce4@kernel.org

Changes since v7:

 - Sent out the first part of the series independently:
   https://lore.kernel.org/all/20250617-isolcpus-queue-counters-v1-0-13923686b54b@kernel.org/

 - Added comprehensive kernel command-line documentation

 - Added validation logic to ensure the resulting CPU-to-queue mapping is
   fully operational

 - Rewrote the isolcpus mapping code to properly account for active
   hardware contexts (hctx)

 - Introduced blk_mq_map_hk_irq_queues, which utilizes the mask retrieved
   from irq_get_affinity()

 - Refactored blk_mq_map_hk_queues to require the caller to explicitly test
   for HK_TYPE_MANAGED_IRQ

 - Linked to v6: https://patch.msgid.link/20250424-isolcpus-io-queues-v6-0-9a53a870ca1f@kernel.org

Changes since v6:

 - Reintroduced the io_queue type for the isolcpus kernel parameter

 - Prevented the offlining of a housekeeping CPU if an isolated CPU is
   still present, upgrading this behavior from a simple warning to a hard
   restriction

 - Linked to v5: https://lore.kernel.org/r/20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org

Changes since v5:

 - Rebased the series onto the latest for-6.14/block branch.

 - Updated the documentation regarding the managed_irq parameters

 - Reworded the commit message for "blk-mq: issue warning when offlining
   hctx with online isolcpus" for better clarity

 - Split the input and output parameters in the patch "lib/group_cpus: let
   group_cpu_evenly return number of groups"

 - Dropped the patch "sched/isolation: document HK_TYPE housekeeping
   option"

 - Linked to v4: https://lore.kernel.org/r/20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org

Changes since v4:

 - Added the patch "blk-mq: issue warning when offlining hctx with online
   isolcpus"

 - Fixed the check in group_cpus_evenly(); the condition now properly uses
   housekeeping_enabled() instead of cpumask_weight(), as the latter always
   returns a valid mask

 - Dropped the Fixes: tag from "lib/group_cpus.c: honor housekeeping config
   when grouping CPUs"

 - Fixed an overlong line warning in the patch "scsi: use block layer
   helpers to calculate num of queues"

 - Dropped the patch "sched/isolation: Add io_queue housekeeping option" in
   favor of simply documenting the housekeeping hk_type enum

 - Added the patch "lib/group_cpus: let group_cpu_evenly return number of
   groups"

 - Collected accumulated Reviewed-by and Acked-by tags

 - Split the patchset by moving foundational changes into a separate
   preparation series:
   https://lore.kernel.org/linux-nvme/20241202-refactor-blk-affinity-helpers-v6-0-27211e9c2cd5@kernel.org/

 - Linked to v3: https://lore.kernel.org/r/20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de

Changes since v3:

 - Integrated patches from Ming Lei
   (https://lore.kernel.org/all/20210709081005.421340-1-ming.lei@redhat.com/):
   "virtio: add APIs for retrieving vq affinity" and "blk-mq: introduce
   blk_mq_dev_map_queues"

 - Replaced all instances of blk_mq_pci_map_queues and
   blk_mq_virtio_map_queues with the new unified blk_mq_dev_map_queues

 - Updated and expanded the helper functions used for calculating the
   number of queues

 - Added the CPU-to-hctx mapping function specifically to support the
   isolcpus=io_queue parameter

 - Documented the hk_type enum and the newly introduced isolcpus=io_queue
   parameter

 - Added the patch "scsi: pm8001: do not overwrite PCI queue mapping"

 - Linked to v2: https://lore.kernel.org/r/20240627-isolcpus-io-queues-v2-0-26a32e3c4f75@suse.de

Changes since v2:

 - Updated the feature documentation for clarity and completeness

 - Split the blk/nvme-pci patch into smaller, logical commits

 - Dropped the HK_TYPE_IO_QUEUE macro in favor of reusing
   HK_TYPE_MANAGED_IRQ

 - Linked to v1: https://lore.kernel.org/r/20240621-isolcpus-io-queues-v1-0-8b169bf41083@suse.de


Aaron Tomlin (1):
  genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs

Daniel Wagner (12):
  scsi: aacraid: use block layer helpers to calculate num of queues
  lib/group_cpus: remove dead !SMP code
  lib/group_cpus: Add group_mask_cpus_evenly()
  genirq/affinity: Add cpumask to struct irq_affinity
  blk-mq: add blk_mq_{online|possible}_queue_affinity
  nvme-pci: use block layer helpers to constrain queue affinity
  scsi: Use block layer helpers to constrain queue affinity
  virtio: blk/scsi: use block layer helpers to constrain queue affinity
  isolation: Introduce io_queue isolcpus type
  blk-mq: use hk cpus only when isolcpus=io_queue is enabled
  blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
  docs: add io_queue flag to isolcpus

 .../admin-guide/kernel-parameters.txt         |  30 ++-
 block/blk-mq-cpumap.c                         | 192 ++++++++++++++++--
 block/blk-mq.c                                |  42 ++++
 drivers/block/virtio_blk.c                    |   4 +-
 drivers/nvme/host/pci.c                       |   1 +
 drivers/scsi/aacraid/comminit.c               |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c        |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c     |   5 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c               |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c           |   5 +-
 drivers/scsi/pm8001/pm8001_init.c             |   1 +
 drivers/scsi/virtio_scsi.c                    |   5 +-
 include/linux/blk-mq.h                        |   2 +
 include/linux/group_cpus.h                    |   3 +
 include/linux/interrupt.h                     |  16 +-
 include/linux/sched/isolation.h               |   1 +
 kernel/irq/affinity.c                         |  38 +++-
 kernel/sched/isolation.c                      |   7 +
 lib/group_cpus.c                              |  66 ++++--
 19 files changed, 381 insertions(+), 47 deletions(-)


base-commit: 6596a02b207886e9e00bb0161c7fd59fea53c081
-- 
2.51.0

