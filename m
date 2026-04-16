Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E139B49C;
	Thu, 16 Apr 2026 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367793; cv=fail; b=FALYheQ/ZW9sbVu6PZNU7mHA25rME2GgHpY7XvmKIthw9hz/xzOCPYdUDj7neg6cg1urBMXvuoRD+2I7ohQCjPb7eyqTKF9q4p3LtTqOAeor4gmsyRTMU4Kjjcb40Lqeh4O0jIKqonasTjMSF8C5IraTOq/k5h+h1osi1psIqAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367793; c=relaxed/simple;
	bh=o3/kBy/u9QGN6sRyLmzDbx/QfYUEPoUQBdXRlz67/J8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ZyCW5t854tX8+Myt3P138E2BiTdeMEYI7Kf7TjR360XZ3kmuFG8vJJP82JrrYN53unH5vQjik7DnJuYoWAB7UWkqZYbGBAUe7IqPcAsg2o9MNhkJZvTdr9QHFpJjMFjcgl0BIUh4SVX4QyvfQVfXpvQ1jFZup3oWgdvnjmxnxFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=whPTBJySndArXAKhdAhq0AMEfTlqMEvv0POJfqhUPr4LdwjdZcEMB/BMLp/PQRSBwKfwAp0khtL9YP5Fe9tAwxu5M/xR5KiO8ZnskWQ12UIn49m/gUC1iLZEzhGUwtsjJcxQmc7UCpj4JRE2BPDoj2jgKcr25xOsidTNbbvTNixtS3HS+Kriq7u5mYWVNgQEnhte22VXVzuetR9Q80sakuon0c3HtGiNV3UOhH/9p7jiIgnYum37ukzqoUmll4jhEnWCGmyZPdnYnIxOkhQ2bZau2JfnkGrasP/SqJJp1CSXYKt12xawxKzZi4Gc72i51ZmaAko0ImOVbOgAmsvuiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESo+oMx9LcJmyd1KXHbhrTUp6XFjjlsLTUknC2P9Hng=;
 b=jP+td9CjKy39BxPUacjXFVVaMVKe1a/9oG7R4xDvwXwHUADEx+5u04pKUoo+R+fH9KvwuqA0+p/b2v8CVqy653Utz8udSg2v7aA8lJd8Ba8nUr+aUcLAtxNdAGqBj8R84uTQuX94rHwgr8VJs7pbxmAi9FrK4ZGvlYRwoNNdAeWd3AhE36YalYMb96JnL00Rm65bg7fY/iwnSfYYcS+y3lAmyAWjCOnL/P/cCs9PdLqYG4iIU0ioAkDTD9lxCL6zj9Ta9dvz0yxpQQzinm9MuxFReDtOtlWZ9gvRZ7+/3Jn5pZrWDGl7OGmCuQnr362UxBmCei33Wm7R13B84SBY4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:29:46 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:29:46 +0000
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
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v11 00/13] blk: honor isolcpus configuration
Date: Thu, 16 Apr 2026 15:29:29 -0400
Message-ID: <20260416192942.1243421-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::8) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 55d8b175-25a1-4cc9-177e-08de9bee843a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|20046099003;
X-Microsoft-Antispam-Message-Info:
	eSRvUIGFt9dw4rG8qpmsbVORKjN0bPNhWNLsuR3g4KVh+MTskWlruSS96FJ8KKiHdKQG+uJj6k8CHowAVscKdkSMi7M8SVCiBBaJ+Z0Wmxpexqzj9iph23q/5gXa+/DvpYrk8WeGrGw/vVGbu7ySmCI35x4d+UB54dx/bVMqV7MIL7YwOuz7iE0OF74naxiJsp8e7n1PgDHJiEsbefUkBlv9tWsoIrLNv/xYR0eZiRKOCYkmEz1c8Ei3GD1UfGvNeo2L1ys1gKESdH0meTrIi1hUVxM/V9BRkRKp9gA7yWl/+SkNrc/8hmBndD066yUOl/mSKexz++KbfB01CsLWqhBLvkJB7qE87Fq+UOvymKJMogtPDVYB26mng1MneaMI2ep0XARpME+pxFCAzIVGqlx+EdCd4tnuYru2CZC6z/sJ6afiB6G6YOl9Tec+8L+Ihxgg++iTn5I2HFUTfGgap+4FYkEZzOmHeauqBAPP8aBU+qK9Q1udG+l3RFuEbk8fTgnCc74svh91lsBajsQvl45lWMZ+NHYR8Kg5DNqdxQTZe9FkF7+OkN5lM5zvZBeVUGKHg+97t2hgRHL+GAZLNzTXNbeMLBsWH0zY19xYsQGCd760v3fzGkHOZfLjIPWrNDtBNNMaFLju1a6D5hgV108/CMZRMWIysaHR7eBAgBrWRiR2z27U3PF+AHqJY5IuVoUjeMSN5hA9mOO/lWILGEIzoS3eKhGUvlU8NiQY0Ek=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(20046099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6J+PeGCOkNCWKp1Blf74dQxGG2gC+qKPuGasIukuLVGkbV1q73DalIiqo7Ps?=
 =?us-ascii?Q?PhwmRJxfq1hqOO/hEWXZ69mkea7J/GQTH7aD+qt5fmmBpaOZg1L+nChYox4U?=
 =?us-ascii?Q?N/xyfdEjHkGgACVpg7/cIQ6ucunmoGLQgAc4Zp/SQS/4hZY6Q7w5TSPXGmqA?=
 =?us-ascii?Q?t6VfDUy0HUG0GWVom0WZlQ3aLyPmgW3bysN8uLxyp28TX5IBHyF7jTrIUpsY?=
 =?us-ascii?Q?1rndb5d5K8a7XyeK8bSHSSINJZ7g1h7tS57pf44a0+qzylkp3fPBPMWK4iQ9?=
 =?us-ascii?Q?fQ6r8bSVi7OuwHi1IIutvW9OwIxxk+t79wrZiFjNW9fuM/IBIiIyFPPNTups?=
 =?us-ascii?Q?pl1QeS2BJlLUP5kx/9lzxHXj4IfquIP2rOFqfr4Dyx2D8EdItDsqfrubbG42?=
 =?us-ascii?Q?KedsI5X+O8l/BGsuyQrjvgZzHxqgQ7msNNB657xleQuUiuFzOC20qPiXZPRk?=
 =?us-ascii?Q?EPWAOpj29lks7BWkwz5ixKpkU+6X2tM3b8fy2FCXsO1iHmqfZ3IQQpJSb7cs?=
 =?us-ascii?Q?slVEhh8akDuMJ18wh4kr5jNE7WZvduRF6pWuJgju9b73rSFpdCx4ufuM45Fj?=
 =?us-ascii?Q?DLjpfkxFQSly6qUpPfE1lojd9FFc59K6STU2ZLSvfZKxxpXU5hfekjSUzXxo?=
 =?us-ascii?Q?Xta/12Lg+jbQ/c0xlBjeXsSmjdGZ2/utxhxb5T1BdF+xnSXgAf48pJe3Iddt?=
 =?us-ascii?Q?7UtGQUbUzH/oe7BojHoD72AOdfvWzbjRY6OLXQ+69c95fTHAZ0BAzBUHne6P?=
 =?us-ascii?Q?7Y1aq3PPx+7wFEU0EoTKCQOulDiUMsdJv+KgWu2iSdfxl0LEgJARQmZeQ8Or?=
 =?us-ascii?Q?yJ34PtGtHqM2t0Jdh9Dh3UveTl9l3XYyUZdUvMQLcWP67zbvhTMbN8rYIcx6?=
 =?us-ascii?Q?4uBHP80mCSJ2S5eXhoWVpnZdDgf8WJXPa1KysFT2aq36TeSpUi7r7I380eTN?=
 =?us-ascii?Q?u3vsdYVR2/SeIryHI5Kc4A9KBj1bNuUSy7HgLmKuKthz4sJB53A6cFPKr0wo?=
 =?us-ascii?Q?mESPM66XmQudVmvkwW0FZITmevBxGmeGhhwliHqoIKEPBWoVYOJssPfw/aK0?=
 =?us-ascii?Q?7XIoD7dzOSVMPz9eH/SRTGhziC/LiveDiv8qTrJ5NvkEhiSstM6IvrCrEy2P?=
 =?us-ascii?Q?20GeyL/Cae+UIlU5+nB5ch/cYF/I1FcYgV+wy+SUNcLfY3162Ozi0kzXs1UO?=
 =?us-ascii?Q?aW6JBmQEuVjTClLpd1ymoFqzc7kgy7kihu5RBgVjZXw7umQ2JIfHp68dVMHL?=
 =?us-ascii?Q?E7ox7WPgT+ptIGfFRXRRiuWJzdRigR0bOj52qbTkMTuydNqyI0MROOPklAgx?=
 =?us-ascii?Q?KXH21Q129Z+b4/s1EfNCAmEm3AD7Hm1LGTsoE04E7i1gGL7OvPlKLP3Lz6G/?=
 =?us-ascii?Q?Regqu+vD+C7p5zPpw2N2PhcJkzJ6R+V2LxQCAZNDyBYOZIoW3T1Vj32nbcrY?=
 =?us-ascii?Q?WpQPSz0AP2Ej8kDLAURIm1LHBL1HCoAPJO7SlDQcTy5/Hn2Fr1OJfihwhMV1?=
 =?us-ascii?Q?GxV9RjZmUIfu8ig8LmKV+fEcvFsQ/avMvcAe1NgSTqr0GlwqRLBsaIBh97V+?=
 =?us-ascii?Q?p+j8WXdrossfmyluAq0/eoJQhzYB7CucnU9VydEexy30aYakfkyh+her2v3L?=
 =?us-ascii?Q?6P4BXXvQ+rl+3MugPfBJI+p2KOkWgTo5Damw6GDJ50USfBWOCh9NrBpM9fN6?=
 =?us-ascii?Q?Qris/u68LqO+DxfurbjPtMFyUirnx7F/bQcF7JKQWIWPsp/B2pJz8MK+Bm8q?=
 =?us-ascii?Q?tr/puWZWmQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d8b175-25a1-4cc9-177e-08de9bee843a
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:29:46.3408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BN/dZFIkixie6FgU2FtvfALc1dWnoT6V8OtxgyPyi6sZgsXIwXpgyzs2++xS4Rl5dI9FYkHU2lgKHh4iOSjBkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

Hi,

I have decided to drive this series forward on behalf of Daniel Wagner, the
original author. This iteration addresses the outstanding architectural and
concurrency concerns raised during the previous review cycle, and the series
has been rebased on v7.0-rc5-509-g545475aebc2a.

Building upon prior iterations, this series introduces critical
architectural refinements to the mapping and affinity spreading algorithms
to guarantee thread safety and resilience against concurrent CPU-hotplug
operations. Previously, the block layer relied on a shared global static
mask (i.e., blk_hk_online_mask), which proved vulnerable to race conditions
during rapid hotplug events. This vulnerability was recently highlighted by
the kernel test robot, which encountered a NULL pointer dereference during
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
 lib/group_cpus.c                              |  65 ++++--
 19 files changed, 379 insertions(+), 48 deletions(-)


base-commit: 3cd8b194bf3428dfa53120fee47e827a7c495815
-- 
2.51.0

