Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2654627C162;
	Tue, 29 Sep 2026 02:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790648091; cv=fail; b=HzEJrMylktV61S+tGrTI5oIvhkKVGUw4tyRDNtAJEvckVznEa0vr5aXwG+CIN3GdrssUXfzqXPlye7LBhub8Yk9+ZpJGAqS98Buc+wI8SYBlP1AtbX7jA/h4lnAevaFI7SEksEN8g4OYiRz0eQzuceVSkJlftb/id/UyrPEzHbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790648091; c=relaxed/simple;
	bh=DmPPZWkGwy0FQ4AFgshtWA+AF1LRSnFHljxDDLbFAgw=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=QgST0C5Rec0TOgLzLVZ2oIDsEATipdq2e+uGqdiLJp+qi2eA7SiFQD1UuLQ05c3AwbuuFsv89QgV8AEA7r5uwJwHBec5hRWxd3SASVRnPhOXCVM8J3Ewc6rqLIP/71Hih/HYdq1MgmY+ex6yyKy51HLyOAFIfnFIxcJHFsGMSdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qahxTxx4; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qahxTxx4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0ghaqXaAJ3lJ3MwBVGNCpEQ2YJcGvJOt9PfalpFPjVlKmMbzoot8iTPWV/ft+X15ptiyCCqlvbqyMFnbGrROfA7YR79zZEXq5CqWNHzuEoWsOubnk3zuxFTIz7pPMaDSAY3gSRnlY8MLcShO7k+dmqr8NDp3QCfjsgKDwjxY/n56vxLaXBr9nAuMObF74I1YTCh7loyLO+PBoF5nyk3wrRacT32f0/9cmAsNK/KgzMjZhRuh7h6dLOnqcY3MVjdxs1K+DTT5kshkyiLr6I/XTVXGqCheE3Nb1GILIYa1cndWQZ8L2SB2eRZ128YqujCbz838lE2aSijxfsxgz+vTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7axsDLzgMX171I6HFpbp6eD+lUjpFcqXXeMKrn5ML2c=;
 b=QpLYc84M/TE6OXg4rv5i6jzFmWcIQ6/vesp/l9ERvMtYNZKgM0xCrYkvOtj3K9e9TSuGQEH1k2py5PhzIR4Uc/Hi9qfarFm+ZvYR0j7Z6cVELMg0wLf0Jy5VF/7yiUlSUCE4/KzkIImuuec5UHvdI2zQpuuJcuvsi5Sqjlx9xN20YbKBuY/qZYggQwqrOrFqtnQIKz4RrhefsMjCR//Kl3uX8vDkYVHHjcjHk3I07WaSAe0Ropy9da2vNVY29PKlxEOMUP9NaCMxzHdZ7u+WNlIb9JFxTE7FL/WNj0vs3cEJnoC3z/SA9v8F2RQ67UBIcC6FvGTHX41YEXLBslJsGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7axsDLzgMX171I6HFpbp6eD+lUjpFcqXXeMKrn5ML2c=;
 b=qahxTxx4Y9sVw12ZcxEhP6kgeXM9CkOzfLULAQWDhEK/1iHwZpUNBsQvIaCOSaLxG4b0XUqFZ4LDe4ndcN9xKgBaL2LHACmQg7eYKioaYRUqK0DFV1ogNOAAzihzWm6HBT3waRcfzA9XfAmSasz+6Ljy1/ctzE7uDRmjih51N4T0UTrZycSzF4B/+8dP6280TGnLm3UmU3pdl065O9tqucIttsvIai1d3Zm2gSM2IHMPYfMpOhcWJrXaZJfrOIkQ3zNlQxXvXeSZYtIdShDkHxN0ILrk4xI/5IKuyAFF4W+NYhTflZUEGOx9w146FH8bLxt6Ni/wVEHVdoGlHFLH1A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB7769.namprd12.prod.outlook.com (2603:10b6:8:138::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Tue, 29 Sep
 2026 02:14:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:14:29 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:14:26 -0400
Message-Id: <DLRFRHANY5WU.3PTO2OUJSFR1W@nvidia.com>
Subject: Re: [PATCH v3 28/40] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <selinux@vger.kernel.org>,
 <linux-sound@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <sparclinux@vger.kernel.org>, <fuse-devel@lists.linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>,
 "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Stephen Smalley"
 <stephen.smalley.work@gmail.com>, "Jaroslav Kysela" <perex@perex.cz>,
 "Takashi Iwai" <tiwai@suse.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Doug
 Gilbert" <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter"
 <simona@ffwll.ch>, "Helge Deller" <deller@gmx.de>, "Sebastian Reichel"
 <sre@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu"
 <peterx@redhat.com>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, "Arnaldo Carvalho de Melo"
 <acme@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>, "Harry Yoo"
 <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent Guittot"
 <vincent.guittot@linaro.org>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "David Airlie"
 <airlied@gmail.com>, "Will Deacon" <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Marc Zyngier"
 <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, "Andreas Larsson" <andreas@gaisler.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>, "Xu Xin"
 <xu.xin@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-28-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-28-4583d8a23bca@kernel.org>
X-ClientProxiedBy: MN2PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f1f10e1-8987-46cf-6300-08df1dcf6468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|921020|4143699003|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	5qNFZMHTc8a4tZ/nOPkKiKSYwkHhKrJ0hZ4GmPVqyeIG2rK169YhvI9LzK89tDbs74gUtz0RTwo8A3RArLAs45d7NA6X6EUavDhF6cjiC08cl4KOGvjQFgKCH4hylQ3c3ei8SZ1vmZPf7juG7TumY+/fOJzPs8cx2sshNf4txmhhxXd4/sld5kuFl5HppkqblSTfnjqymwz9PQEa0Tm+FUrb+CFL9VkWP5X+8/LbClDPVrk+WkciXYBYib4l+I+FGxdUBNR4H81cJXPBPuu5wKq9l1TjykymyGuUCFvzQYoM/hbWTAHO/rbVqvVce4aAKe5XaCkOljg1R8Zueh2Z1pKxtIJINE8VZTzrzooTQFK9WBnxQSmGvywa4AYyRn7qofxqcfdPdECPMONd5UZF6bLELKh8p1du7pwtCNgfZbzY4jgPQFB9sLlMbRprPevu9PJ6j1iJnWTixaj1RqJQK65HzmBH66DYApC5TAdRKSG8MPtXR0GuHB5qtTP8zoW3UnzmFcx7KEn+1HmpDdsc2Phpy1ouEVtNNQBwLKFjhlXNARQbO/wY6SJ2PJN7zwNja8rC3/TtIS7cGZC2yxMBgbgmKhw/lJrFqQTroPbyX/TC4Kfbkl75cFK0kxCD8lx1386zZX/vlr5BWPJ6hmJyYyUKi0AQTvpBBKp92bVaprZ1w/7uHDuIvKKR13jvOOPHdwGbhLcoPpkXMW4scrQO1A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(921020)(4143699003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzNma1picGxqK0RRN2hXb2RyVTBjUHBrc2MzWXhZS1NjVlo4YkIyWVhNVGZw?=
 =?utf-8?B?bHNMcUl0ellOQU1ydkJpM2tZQXVpYmRxMVFvc1hkREYyWU05aHJiczlnMXZD?=
 =?utf-8?B?MW96T1RCckZwVEd6T1FJRDlCLzg1SFcyckdZa1JYRzdxelBXMVIzdXgza05I?=
 =?utf-8?B?RVFGaFVVU3h2UFdnQzd6VkhUNDNCNXRacDRqUXN0azN3Ynd1bHhqNVhKMzhh?=
 =?utf-8?B?ZHNaUVlMS0pqOVB0aFdxTjRDT21jWDF5NFFwY1g0QzdPQkcvWStWK0VCOC9i?=
 =?utf-8?B?SG5Yb0xpbFJVcG4vbmF3cGpIOG1uTVRBTVNLcUZnRmx1bE9RbjJ1NCtZczJB?=
 =?utf-8?B?REZycU4vYnBDOTd1L3ErK3ZlYXl6RWVkL3V0TURuN1I3bjcvSXI1UlNqQjlX?=
 =?utf-8?B?SFZTRDY0enFWdndiNXdTc0Y5aEk1NFdMMGhIcitwa05nelhaQXU1ZHlteXUr?=
 =?utf-8?B?c3dIa1Izb3NMbHlqZ0JILzJHenlWaExveHZESTBuWnlsSUNFZ1REZUdEdWhJ?=
 =?utf-8?B?MVhBVVoxcndBR2Fjb1haeUJvVml4SjRlMkhSV0JnbFFFbjR6SHU1Ri9sOEx3?=
 =?utf-8?B?SmsyUkZoMkhRWXpQNEhaT1NkSnpMUXQrUWJ1cW5McUQyVmFPNmY4SEJpdFBH?=
 =?utf-8?B?NlhVQ0pQY2hRTFE0d0xMS2hOanI2WEllQzQwcmdSdU9pOERWajBBWCtDRzgy?=
 =?utf-8?B?R3hFWVhDMzdnZG84YmlCb0U1bi9qS1c1cTRCL3l4RUtiZis5YnQxOUJPaUJV?=
 =?utf-8?B?cnBsaThOQmM0TW1jQTI3NmFIOWVpbzZlZjFYYVovUkZRNkVhd0lQTklPekdF?=
 =?utf-8?B?c0o5dlE1bnZUbzRvOHlEaWY5UUllN1JReGNjcGk5VytiZFdrdWtqaDQ2NXhC?=
 =?utf-8?B?TGpzbE1kK2Q1UEtxZkNqTVZnV3ZpU2kweVhhUU12RlRpTHpPQXFwSEQ3NFJ3?=
 =?utf-8?B?ckJycGk5bWY0bHBVMkU3NTkzSXczZDRjWVhmaDNmQ3JlZjNVMXVadE1wWno5?=
 =?utf-8?B?dUxhTUV0bG56bDlUaW1CL0lDMTF5Y1kxNjQ5aEpnVDIyTXBBOU1rSjBURUpR?=
 =?utf-8?B?dVR5dHk4ZERLcW54bWJkM21nTmRra3VuYk9NbW9uVGJFSHZJcklyVWs4M0tu?=
 =?utf-8?B?a3orSTh0Qjc1aE1NakE4Q1NHU1graVZqb0V5ajVucEliL2NDREorcExUSmI0?=
 =?utf-8?B?aEFVL3lhNHN0dlVIRWFLSWJTSVM0MGFXb0p3RW1NUFpaUmUrNW85UEZuRmtF?=
 =?utf-8?B?b2tPTk95cU1KdklNZkE5U01Vd0h2ZDVjN2lXVHhUZndKVEc0bjdMRFNrYVpR?=
 =?utf-8?B?TkZRc2RKUEFCNGl6T1N0SjdlNGdxNjMzcEZvSy9VTkYyRmQwSmw5WlA1ZE5P?=
 =?utf-8?B?UlFDSEJ4WUpLYUVWVkx4TVczcnRqQVlwNExVM1VPeDhJV2FkRGUxWlB2bUlQ?=
 =?utf-8?B?ZnJPVSsyMTRRRkp1Njl0WE4xVElrcis3WGJna254MVU5N2p6QnpWM0RGR0Rh?=
 =?utf-8?B?ZVQzZVc3OVRiTU43K0lxVEZpZVVoRklaSXNFVDBMQzR6TVkvZnVFWE04L202?=
 =?utf-8?B?N0VudzArcmp6ckFKVlhPamtmVURyeEZIcFE1NkJEdVpKdnRRV0ZrcXVuZEM2?=
 =?utf-8?B?Y0c5OWovRnBQVjdGdkhLVm5ueWdrQi9VVE9SZ3hVZGowZkh4WTJMYk9uK0RC?=
 =?utf-8?B?OW1mcWtVQ1BiUXZ2SWFLQlJTNnQ0MGdIN1FESzZxYVRIcEJlT0I3ZXdGeXpY?=
 =?utf-8?B?azZRdWFDeUF6R3VMTkJESUpOY3V1VVpyMkUvN2dSdXF1Vm9jdzFHTFdxUXpz?=
 =?utf-8?B?S2t4MElIQ012MGhaZWY5dEZMbDg3aXRhb1VBU0gwOTNuTDZHU25UMnJScEFl?=
 =?utf-8?B?QTBaenBLejFDajN5ZTNiSWJ5eXViRnlHR3IxWTNKRXZEREFCY2JLdkdRWUc3?=
 =?utf-8?B?RkQwM3ZjT0hsWE9DOEt3cVNNc2JudGJ0dzVwYTZLR3hpd0hwV1RnVXBOUTlP?=
 =?utf-8?B?dnNBQldub0FXcEk4L2ZhSXVzOUZneGxIdFFHNkxtcVE5QnJNb0RZVE9ITWMr?=
 =?utf-8?B?NEgwSzBRNitaZDRieVArMDZNNGtFTGpLTWJ0clpxVTlQV2pvbVZ1VloyRVE3?=
 =?utf-8?B?SjQ1VFYvWDBHMzczeitYWTk0T1ZDeTdHN09YNzBWU1RmL21hRmFseGlCR3g2?=
 =?utf-8?B?RTFObGhuUHdYTXFWaTQzY3VaZDlvL05MeFBkVVlUYzlCNEZPczVtTUl0RVFZ?=
 =?utf-8?B?RzFaRHQ3R2lsZHJZSkh0dExEdTdacll1bkZGU2NkZmV6UENhelRsQy9ZVW5O?=
 =?utf-8?Q?EZtb+TmBnzDQSqadlO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1f10e1-8987-46cf-6300-08df1dcf6468
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:14:29.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqVJvlCUkQm1Y6qUscik0P4w1NSUabjgvguGmfya6HQzIK0rw82EYvzy/YEzTYZl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7769

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
>
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
>
> No functional change intended.
>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c                      |  4 ++--
>  arch/powerpc/mm/book3s64/radix_tlb.c      |  6 +++---
>  arch/powerpc/mm/nohash/e500_hugetlbpage.c |  2 +-
>  arch/powerpc/mm/nohash/tlb.c              |  2 +-
>  arch/riscv/kvm/mmu.c                      |  2 +-
>  arch/riscv/mm/tlbflush.c                  |  2 +-
>  arch/s390/mm/gmap_helpers.c               |  6 +++---
>  arch/sparc/mm/init_64.c                   |  2 +-
>  drivers/gpu/drm/drm_gpusvm.c              |  2 +-
>  fs/coredump.c                             |  2 +-
>  fs/hugetlbfs/inode.c                      |  2 +-
>  fs/proc/task_mmu.c                        |  8 ++++----
>  include/asm-generic/tlb.h                 |  2 +-
>  include/linux/hugetlb.h                   |  4 ++--
>  include/linux/mm.h                        | 19 ++++++++++++++++---
>  include/linux/rmap.h                      |  2 +-
>  kernel/events/core.c                      |  2 +-
>  kernel/sched/fair.c                       |  2 +-
>  mm/gup.c                                  |  4 ++--
>  mm/huge_memory.c                          |  2 +-
>  mm/hugetlb.c                              | 14 +++++++-------
>  mm/internal.h                             |  2 +-
>  mm/madvise.c                              |  4 ++--
>  mm/memory.c                               | 12 ++++++------
>  mm/mempolicy.c                            |  2 +-
>  mm/migrate_device.c                       |  2 +-
>  mm/mmap.c                                 |  2 +-
>  mm/mmu_gather.c                           |  2 +-
>  mm/mprotect.c                             |  2 +-
>  mm/mremap.c                               |  6 +++---
>  mm/page_vma_mapped.c                      |  4 ++--
>  mm/pagewalk.c                             |  2 +-
>  mm/swapfile.c                             |  2 +-
>  mm/userfaultfd.c                          | 26 +++++++++++++------------=
-
>  mm/vma.c                                  |  8 ++++----
>  mm/vmscan.c                               |  2 +-
>  tools/testing/vma/include/stubs.h         |  2 +-
>  37 files changed, 92 insertions(+), 79 deletions(-)
>
Makes sense

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

