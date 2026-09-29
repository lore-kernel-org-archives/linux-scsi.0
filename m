Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010061.outbound.protection.outlook.com [52.101.193.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDFB2931F0;
	Tue, 29 Sep 2026 02:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649421; cv=fail; b=TpmFZ52rEaHYsnFUEreexDbgK/nOoHiE4C/h8c2HBn2Na41vuYQ/EtnJA2whD9Ks5XAhceyx2IeFY06pr3zOnu2+hKKmi927rFSq+iuHbzFaheK7/mpZMFhb7aqWwT9ewNM75JD37avUib9WFLhwPeWKdNdANU9XkgZ06w/jZaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649421; c=relaxed/simple;
	bh=mu/T7xrcFN7Fh9vifJ551HF0rz7Q2d9T4k7HdvAVb7s=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=c1eE8vNoZ1n0t0ERmpOxzou4Ov7ihRSJuTizvC9QfQiERqysa0iorV9B9subv9xs3fIYIfLDX8jo4Kv3HJhobXK/FGgRXyvSo1ZCdCO06MqSYqdkPCdCVR1H9iYVqDaec+cyCpxMznvtDyZB0D6CFxrVJQoEXGnA6iM3rDDVES0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T+IY+X7k; arc=fail smtp.client-ip=52.101.193.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T+IY+X7k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sVWGOtXKl4T52XwcVhhOAnUYkp8HUOGcNa3wYlrbmOxLHgx8rzUi/4hs5YS9ION6sQ2cuN6ut4UoQLshyZVD0R1k0o5KkynEUzUTDlRQN1+Hbk+9xErj5hF3qlbWaiA2FCrlH9Rs/INpEjeGd7A7UhTWTjI2cTlet3yrux4Q7tl9UXZ4J9XYqBippRnDMAeeJK2HTqbpC5xQrQWdfK8dpnGgDZdWTgjetdsTN5tM58TcXvlOi5+G9l3T3+QodVUWQ7sSbpsJtOeDZtBMxkTuYN/kc3cA+esb/KIChf1VGtb/b9xmDvqFnfrfjpQgy+2rvuxiS0I5CtZEqsInQy3uFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCLTRohZgxrvH+esGkRGV3juLJpOde6+5uhyO00kSSE=;
 b=kwsCc67ZhbqMbUYowl8cXizD+MszX9P3u//eiz2KE88QhzkeLYfaWn68jCYmZFxOpvcGy7HOIRft3a0vhGztVtFB/eOoCT7k1NunSoHtc2ZSV87f7xzd0Dwwy2Lssxh2GvmPMoWP+1zHDXtrF1PysN1VESuICWfdoU4MW9YgMDGKEtsn80N/N3po5PCSIvrnbKfWYx3mHwQUJ/5jGYLHmhWMhokQYNfr9ViYGddRtRPGKDKqP5254aqL1crMkxO2tHDWLuIBGHVe7mK53Lm5zXdSJDuheBgu/2pkCyXruLeJk3htcSqQGcmVPX7Sevb97QoTDMWuQC3Im87RJvm5uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCLTRohZgxrvH+esGkRGV3juLJpOde6+5uhyO00kSSE=;
 b=T+IY+X7kRNHe1piTaz/G3orZVzTk0jaqTOj+lkVPngLXEOxfJ9d+lgNbI8NDWMiNn/QxueHVfQb8UBLOpJqZRAJ67RT0HfcEE6SkuZefl1UegYuHfZXB8LaWB5icnXe85Qd9lRCLkFcIAUUNoXzuNiudWUODNcjB4+oOkVc20T82pBHtLfy/Ts+fkZTwtW9dRzwIqm9j5UG6sFBCVPoMhoz70/OU7ol0S8fZ9ku2r06BOxldcTP76kQ7Lgf1ztYuDfzIpuBonFptPTwqFkO7j2IvK9CamiJZCTDuxLFqM2cORszQ/S+bqGm2QdQUvU1vbpbnlBY+2IVNtuhxnXgaMA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7660.namprd12.prod.outlook.com (2603:10b6:930:84::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:36:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:36:53 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:36:46 -0400
Message-Id: <DLRG8L762ZE1.3CCEQCRGI5DY@nvidia.com>
Subject: Re: [PATCH v3 29/40] mm: drop some redundant checks around hugetlb
 VMAs
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-29-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQZPR01CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7660:EE_
X-MS-Office365-Filtering-Correlation-Id: e5250cf3-9e87-49f3-4547-08df1dd285a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|921020|4143699003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R2CShBVTVO5kAP7NuRAknb3yqeDA+81WkQfNhB7rKCVlA0VLDx+nJ0Dt2jux/9OBjWSL8EQ7p0PcF8hceyPsG8jVbWaXgK9s/TbQ5/m92rudq9VqTKWNwodf19ppJVam7o7kWZ0ubWoaH5fazuMETLrjb8vSfofsSeH8cHq7TtnrNGytFONu3xZrhta+FuiCUbbbjIXoqgDtnLF6FXBtF+fDGcZKUTEXAMvl0vHWmwT0ZvuIQrHy0KcM6eKztvPQdJgXTy2umwy3/j+BxHSCQifr4jdZHlMBNEEvVXLMOhPJ7QDJbWeXlhwugmiM3wnj61Xxj7DTpluWGh5YPsWxwAylXXmryAh8FxJXKMVJuLW3LKPuZ8Cq8p2mi04eTKfYc1gsQp3qO9VRzi8T8XBiJdoxHxJsqsH74SRBdXegCEmTE088bDyNMmYOFCHijk4ytQc4HdQQFxW7J3c44ocfWLbj+bC77FgiOxfMviMMJ6Pv0EHl3BhMItleHfMRIKbwEBRdHDEwV4Lm6CYPH5XbCWepw/Z+Uh+Zf9WwYpGYxps/hVHX5NRo8GLbNI4HRzzxKdQ06tvwulUykZ42QnBDC1nz5Svfgv5s9vrgbfRfvuUx5ny6aheOFWfOJxUjGJscZAZB+iRWwlA/20WfxfoYSQLGrMCPk4Sdm29dmNe1BWvsN97EMyPZAwMn1B9m6u5UkluPCM+RzvE+y2TH03Xxng==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(921020)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkF5NFZGeFcyZDRjTldCeEpWSWUyc2hQK3BQVUg2NWNNZXhPejJsVk45WXFV?=
 =?utf-8?B?NHJBZlNpWWVFdE82SS80WklZcHE0UDNyTnJwc3lKNlM0SDBnVDNUdmhrd3pU?=
 =?utf-8?B?OUQwOG9Sa1NYSVFRSlpXQVQ1NDJIMHd4QzQreWlIOGtaMnlzc05ZL3BtREF3?=
 =?utf-8?B?eXo4Zk41dW5DNkZFSVR4dUxobnRFcG9TdzRuTVFZajFhZUp1YkR6SUNHbUph?=
 =?utf-8?B?ckE2OTNKdnZxZnl2amFTbitCKzNMYkJocEREQnlENHBjM3ZFQ1VyeE1JSDNO?=
 =?utf-8?B?OWpOYUtZY1AvL3VHMXErTXVld3BkekVkRGpXN1cxTHBaazRIMUZPTTNXYXFk?=
 =?utf-8?B?QmE2RDlnU2phSG9rSkpYTjV1bVVoOW1NMU13cWUvYU1HTVA0RGQ3TFk3cWtO?=
 =?utf-8?B?OXNRekRUbTI0d1hZaFJYTVNXRWV2V1hPdnhMazhUUFlPdlM2MktZaXNrOGor?=
 =?utf-8?B?VC8yTkFXOG5jTW1YakpDeG5Ib1hiS05XNUJDOVdVUEh5RDM3VjFpT3JUZWdZ?=
 =?utf-8?B?QlJ1c0w2TGxyMnVaUk9KaEMvY0R6YnlVQWd6ZFlMaG5rKzRXcG5NYitiS2dr?=
 =?utf-8?B?VFZ1dlRkUjZMWDE0c1ltZzFJWnA5Z3Q1YXpjZUY3K0QzVEx1UTRaQ0xxRS9G?=
 =?utf-8?B?TUdFOUNjcU1Fam54eHRhdkI2RHZKck1ES0NJbFM5SzhxaXNvdjg5VE5QNDZm?=
 =?utf-8?B?UkVjcG1Ob01vSSswbDhTWWtuMUVITFVtZkt6OGplM0ovSWMwTXI4VHNaaWJP?=
 =?utf-8?B?VFUxdmxIQTEzS3VHcEpIOGJhZjlKZDlYNGVLRjJTWXo1a1VVVS9QdGM2UHFm?=
 =?utf-8?B?eUNzd3Npd0tNNFZmRGp4RkdDVGQ4eFNhZmRKRU9UUzF6ODZrMVU4S0pyb1BZ?=
 =?utf-8?B?YUw4NFZSdkdXYlBQQWlXWTBjck5sWjRtb2xidUlVbjFselV2MklaZkpOdzNw?=
 =?utf-8?B?NWw1U3FrWW5RdDczN1pKN0pBZXlWTVlKWllLalFWRmJKTmE0RVozZWRJSysv?=
 =?utf-8?B?cG1xYnhNV2lrODRpYktFb09kUTBqUjJMZnV5RnRoOEkzZ0N5NStJS2xKTjZi?=
 =?utf-8?B?cTNWKzVpZkI2V2N3ZGcvSlJzaTI5bU1CRUdyS2xmcE5VdHpNSW5LcW1GOXND?=
 =?utf-8?B?b3c2YktPRmd4bDdCUnJMWmY4UkZaenZNQ2c1ZkU0MGJSSndUZVhLNFNNN29I?=
 =?utf-8?B?SlhIaGJMZ3hzU0RrSEp3RmNUTTBWL3dpYTNvSklBYzZKOTZFemhzQW9nU3hE?=
 =?utf-8?B?WkJrZkY5OERzQ2hzSVc1QVZMRCt1ZUFSL1lLb2pBaXFZSjlJZTM1RlRsbkFD?=
 =?utf-8?B?SDZlWlZFbEE5OGh2SSt4NWdvQzJkL2xLdTdhTUsrS1kvVWFHbXN3Vk54MWtJ?=
 =?utf-8?B?UE96VDFKbmFhVGtaNEczQlp4K1VaVy9RTmhTU1BacEx0OEZML2VSQ0dEdngy?=
 =?utf-8?B?dUd2ZTN3QTc0YzRFQXl3TnoyUmQ3ZzZIQzkvS0tTYmtSZmhVL290NGpQQno4?=
 =?utf-8?B?eFEwY21tczQxdnVnZHF4QUVmNmJ4dnM3cHVVSkhXbkVwdllNbkJCMDYwV09U?=
 =?utf-8?B?NTYvaURiQ1RoMnRKdmprZDRuT08zeE1xK2JoV0JCWXU4MVRDMEtCcWt0UE9k?=
 =?utf-8?B?aWVCTStUMjlRWEpqaHlWUlQ5azB4aC9aVWkrZ2xoRFFDa1NUTkg3KzU1SDNC?=
 =?utf-8?B?dnNZN0tkVytqTEovcnREU3R6a2VrdkxhTlVTY2YrSXJaR1lvcjV5Q1FUSEFw?=
 =?utf-8?B?aHpnWnFxVDJ0WlNWQURTZDMzcm8vZ0ZBbGZDZWRlazVON0kwaG81YndzeVVS?=
 =?utf-8?B?Rng0akdYaDNUZm95azJyK2tZaGViVzFaNmNheGRrWTNCM1prT2dwRENvL3Nh?=
 =?utf-8?B?eXV3OXJTS1h4VnYzMzNHa01QaXh6cll1UnpvdEZ5UEpoMzhkdCs5QklYeW9j?=
 =?utf-8?B?QVArQ1kyZjMzYnlmUWF5NmhLTzU3SVQ0UDZxdUFQN2VlQ2hkd0Rpd3dIRm44?=
 =?utf-8?B?YUIvb3p2VUtZYi9tSkYvbm9mTnRqWGlMdWpjNmlWRHZpTEdxV1JaU3JKb01N?=
 =?utf-8?B?ZHhOMXljVUpSSW5hNm5EVXh2Wm9FV2pVVk5jMFJjUklTWE5vWmVVRGVlTFdV?=
 =?utf-8?B?RHB4T25mOUFaQ2dHTHpkL0UxL2dUdHdNVENRajBqd290cDF6TlE3MXV2MWd1?=
 =?utf-8?B?azBPbElMNjNFYVNBMUJZajhSQkZsOGQzSHArU0hBZ2R5QmxIVGtwZzRTakRs?=
 =?utf-8?B?Y1hwWUtQSk9NOG9xVWJTODlsS1hhWDJMSTc3enJDdFZNK0lZK2NFR241Zmwz?=
 =?utf-8?Q?Pv9y+VtxliQRqcJxUZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5250cf3-9e87-49f3-4547-08df1dd285a0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:36:53.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 87GjufIGz/5BqgvvCCL9pO+7ud2Yfb4s8XtP6NeyAzoMFQtopv/8w3ZdrlpCZsQX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7660

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Adjust code which inadvertently perform redundant checks on hugetlb VMAs
> and clean them up:
>
> * hugetlb VMAs have VMA_DONTEXPAND_BIT set so a VMA_SPECIAL_FLAGS check
>   suffices. (migrate_vma_setup() regains an explicit hugetlb test later i=
n
>   the series, once VMA_SPECIAL_FLAGS is removed.)
>
> * hugetlb VMAs unconditionally set vma->vm_ops, so they are never
>   anonymous.
>
> * hugetlb VMAs do not set VMA_PFNMAP_BIT so checking for this is redundan=
t.
>
> While we're here also drop a VM_BUG_ON() which the simplified check above
> makes unreachable, and use the new VMA flag API.
>
> No functional change intended.
>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c         | 4 +---
>  drivers/gpu/drm/drm_gpusvm.c | 3 +--
>  mm/migrate_device.c          | 4 ++--
>  3 files changed, 4 insertions(+), 7 deletions(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

