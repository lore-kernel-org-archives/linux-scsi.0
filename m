Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011041.outbound.protection.outlook.com [40.107.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F013451A6;
	Wed, 30 Sep 2026 02:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790733772; cv=fail; b=GbFGqjpr1EapcR5Pf1b2lazTmbMDIVqaZJooIsr6XdItDo0nOANSEzYYz9Up05DzDIfjuqJzwVKv4U9uwxZzBX2MXk44cfrsokbj/UNIIv5qR5adFIpiZfx6sotJF16mYyXwx/PZdjSBxoX2PJ81j59WtT1QIVZhAv4suQylcno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790733772; c=relaxed/simple;
	bh=rafpr1kM0hOmPH/TX07Mpoesxb9nKobb/l3MoSsyMZ8=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=Brt/oH/12l5gob2GbhmtAezUUFyjmc7/j/JU/LIt5S3xuG6xJoT6o7YokL2Nqa4wajvhv/VYAxESZrk111hK2NxcgCHiZn0/F2DBwwZwA2FkVIxd2vJE5TWKzvkhdgwKFcCITY7OhHohrduNyXwlO8Bz54mslUP0Z7cUzQt12UA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nK8O2w2e; arc=fail smtp.client-ip=40.107.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nK8O2w2e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ra6vhoQtMCDyJzolJQFbRWWvPfPl6vaSj/4fglohTOI7M2QG7mvN8hh90kSRRK+ygXNV8v88mlLpozyfwPGrFiTc+8NqI2btAYLD7OHq8w2yoPqLQk6XR0qjOPiZs3duGhbG/QcOmPXz7t9ST/2j9zyZ2+8Y6OXgjQHh8XvOPbub3xHTJpqYoxMSvdaIxtukKgrbADjqPOQ6oy56PYOjYZkqHKXfQ1ZnNZsb0kZoSl25W2TvvdjfS4PPAtAhLItAdJkYAykleZb0gqjDRZrPOSnBk7i5HmzKdILDNspJZtyo1qpqmiujpDHFLYEbPjJyMoo8i0rb6CHiPRqCcjf7Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNz4KX5x3JP5qBoqaaiqCUiqJ6fuLgUy1aCccPGn4p8=;
 b=Pqg12jwFdHI7M7HVRLWSQBJYj2RPhrzeAXGMAP8WKHebs50DTZ1i/GkunRbhcoXhrNZLLRR5RC6ysr5hb+MtRg0gvKNMF05U/H90qVKNpLuwSyC3hODBTWfzRMAWt6jsRpXLrr7fDh4zepMxgbohh2+KHCu0D4sLkHl+LU8i4TXp18QGis3ppUMwCyHzea1cWMy2ctXlyCnt3xSt76+I9Hf05LQNjOTQ1aMwvxIGdmolTkqmvw6mqxPYA2fUPmabz3AWSe9VIPvgxsKuekPk68KviW/OIG2BomYJJS8jd+caAKNlA0R+wMgLXbOYeAw04eVrzxyKtruTQrjmVeJ4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNz4KX5x3JP5qBoqaaiqCUiqJ6fuLgUy1aCccPGn4p8=;
 b=nK8O2w2eRE7lPwkNWj1GjtIuYllkJy3kfUfAtdRz8U1oykQC72QI8lK0d0SOV5FeKBIMpo357+s88I1ngDwqlVHzvdZA9E7hGNBsWuwef3TQcVAVnPlZH0BH/eX28ZCXq8Vxv2cebhd3UqWGiYNngloDgwwLE+nIIKXs5zPXvngEKR/SDbMoVDGaUhWt7yHeFUpNetXdOivFWF23OC3JqMnvoAWxFgzzq+MFSAwUm5Qg4xk++TcGjQcEaV31EbBiENhrawS2LJoYbuDErJ/KvsZpRhBYaj8OEKx3fYY+6lbLvmW4Z3ynePHuBu1xCXw65jGQii/lWv24fE2u9wvK7A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BY5PR12MB4307.namprd12.prod.outlook.com (2603:10b6:a03:20c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Wed, 30 Sep
 2026 02:02:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 02:02:44 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 22:02:37 -0400
Message-Id: <DLSA4ZBMVWWY.1GNXN8HFJLR9L@nvidia.com>
Subject: Re: [PATCH v3 32/40] mm/uffd: use predicates for userfaultfd checks
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0115.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BY5PR12MB4307:EE_
X-MS-Office365-Filtering-Correlation-Id: 9596d6c8-7b3a-4def-c039-08df1e96eaaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|921020|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CoRbAwFIpSNQsXZf5zrbpS6IBA54J4thOkVJNn4E1itVLW7ectwGZY+GrjpMIY4cMI8tZVHPC3Te58a6LBg+S3YHt81+OcKnbI++k0QnNyVdCbE/kf4oA75RWkUuzQntLd9bHGmLIx2Vifuzp2F3ewjngYvhNOJaswxbCLIsspr/FSG2tQFRhR5RVI4hhBi0En412o4i5MXcuYePIBBTdSP0jQIh4vqfO3EpXxpqwjwiJnDVFS76LQrXkkkQ5/jGwAhBPJZhH4haP1kDx1V0rRJUe+y74xo+CWPZ4U5rjdue9FAUyAauNsxck7M0GVqMJkabGSEXW+sCajmcufK4Bm5jtv8iG/xhKyReEl59SFgthd2rRhyenKvH1TWHjB6nESMoyzMC2kuJ4QyW7uMo0RyG4omkRY3PQuXjRIsrLsnny+aQ+VEt+S+gXNoI3r5wYczvddV4/oTnRoplq/Kzh1Rg6p+q7q/+gC3X+vG2z7x4aYkVVmAI+ds9U15faH95hKIbXEpKxRo+1Egq6YYqm3u1/qUB+J4e6WPyNdaMLB0eYrMtogYEpnZWgWEBTZU8OGpW1KuPXsNcuHy4QwDhwlBb8qUwRSnQnQlqVDp0Mf4OKY5pQQs2gZiOR4x5UFpppTVlsUBIdXkgOylqSoe9E8ywTFetqICpwzz2nOanEoKit51sskTANsJxjWtnhkyG3w1axGqhBx/D4BgM/JhGIA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(921020)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUlMUlFlWThpeU5oRWJlMUFqMGVKOVltMzB2NDRkMkVldUFURHk3VldkbitP?=
 =?utf-8?B?bzNCL0N5aHd4Q04xSXNoc25YMm9zNi9vcTQ3ajQ4RW9oRHRxb0R5WFVzSFN4?=
 =?utf-8?B?cVgwZUk5T3hCSjlETS8ybExoY2JWWERWOHNkbk9oOWxJeEFJcmxHS2Q3allP?=
 =?utf-8?B?OHNDWEZ1Vm9WWXlLT0hPdFNuU2RJakRtc2wwRXdDcHMyM1o3TTV2ZFpqSTBJ?=
 =?utf-8?B?WVFOWjlScVIybU55SFpYUkEybjl4V3duTktLeTJIU3FJUFNoVk1NSkdVQXl5?=
 =?utf-8?B?UmpOZnhhQnFIWE5VNllMRDhCQU5rNmFoYkt3K2hJbHNxOXpGKzhkaFA5cjE2?=
 =?utf-8?B?V1lkU0VmRXJnVW5vbEdKVmx0NFQ3NnRLb2VyMm9La21GTmJsNkY5NmN4cnV6?=
 =?utf-8?B?amV6RWxIZFZZK1VQY29FRnNqeTJqTUpwbHd6bGlTOEJyS0JVNG81UHY5WTJv?=
 =?utf-8?B?T1prYmlNbVpHbXhhZXlWaWRhVGh5WlVKQUQ0YmZ5dlFyWTRkTDZtV2FqVnhW?=
 =?utf-8?B?Q3VVK3gyb2dwVUdiTExTbXlpaUpyejR4TWFweVR0MWJlUjIvNzVyekpBa2dk?=
 =?utf-8?B?QzRWQVRyRDNUQ0NIa3hzTEJZb0taNXlhY2RkU3dTUWhwa0ttemhEeGV2ZTF1?=
 =?utf-8?B?clV6em9MV2FBVXJHbWdiTS80N1prUEFScStraTRhMXMxWWJJT1VOSmJWMHpU?=
 =?utf-8?B?OVg4Y2Z5R0dwYlIza1NGNnNxS1IxWitwNEM2Q2FrcnpyVEYxbjBtOVVwejNH?=
 =?utf-8?B?L2dFcXNpUHlYblQ1dnRCbTlnNnd3RXBjbXJyTmhnaElGb0xKWEVqeGJwVCtJ?=
 =?utf-8?B?ZUZsU1U1NUgwNHlSNmIzUFZGeVgwUS9rTjllNkR1TmpHWXRoZGhVOWN0UVV3?=
 =?utf-8?B?WUM0OWlqYURnUDhFZDU3M2d2bnBVK213ZUhreW5yTzFhTUZ6TkNhQU5IS293?=
 =?utf-8?B?eHRpcnpENlJQcEx3Tlc1ekV4NXhoZnk2ckFrODM2cklKMnd5OTFQbklYU1dP?=
 =?utf-8?B?QlJwblBSdlRtNGpHSEw0Qzh5Zk9zazI4d0xVVUNFdStpK1dvdkkzZTdjeTMw?=
 =?utf-8?B?dHpiY1o2bVFrRm9vUW9VTWhjcnQxY2hXOUFJWCt3Q3I3MnRzN0dZUVdGZTg2?=
 =?utf-8?B?bFRidXFJWE9VOW5LQ2Jod1NZUTJBVGFGNlJJM1oydHVJSVBUREhScmVrOTNn?=
 =?utf-8?B?bFBkQkxVb1R1UmltSDltVUh6ZjBXYURUQ0lLTVRBVzBPNjdMUitJWHdRcmh3?=
 =?utf-8?B?aDR2VHk1QzAvM3BvUnlJMmhNOXRXSjN4WTRsWFhjOWdBYkFrTThLVXFmMXY0?=
 =?utf-8?B?R0RMRnJpNlhLWkd5SDJ4aEZheCtPSlJSLzlleDZ2U3Zncm94T2diSVpoaFUz?=
 =?utf-8?B?bVFjRlFzczVFTndtSVpBNHZRNndTNlRMb29ubjExallYZEgwcktWZmNoSVNI?=
 =?utf-8?B?aWVoRDZxSFlaNk0vaDVWRXlIMFlreTNiUVVxd0p4SVpJQndnTEJRb0d5ME40?=
 =?utf-8?B?RTUyaUIwcXRSQ1p5RWVPK0RwTHh1bWY2T25objZTVGMxMkZuVXo0ODJZMnVm?=
 =?utf-8?B?TnJ6c2NjUWZnVTVLd2xOZlo3VVBmQlo2a2ZkTEdCcCtSTm9qNGZmSlVPSSts?=
 =?utf-8?B?R0U4NHQ1QlVta2I1Q0RmeVVaSDNQT0RNOEd5bWhnMnNjeGdmWlZWczZjTXRy?=
 =?utf-8?B?MnJyQjY5ZGNTNisxNk1LVnQwenZDYWlDQXQvSWZ2SjNVTmlmN1dTUGUwSHJR?=
 =?utf-8?B?WFBJRVVLOUplQW9IektXS2FCbFVsVzkxMkNadGt3RDFEa3hESGg1UnVSZ1J1?=
 =?utf-8?B?Y3M5LzdDVlVic0VmdXJteGNnYjNaNzRUYTFwNzNrZDVxcXU2NzlzMGs3cWJE?=
 =?utf-8?B?Qjg4WWFKUHFieDBpTS96MHpUS2hjaDBaSG5QYkVPcE5SYm1hM3ZiWFZHRENa?=
 =?utf-8?B?dm91M0NZUWNEQ2ppZU1Wd1JGbC81S05Pd2hQTXVLTVIxRGhRYTZGaFUzeWVo?=
 =?utf-8?B?aU9ubGpmU1hUb0NzRTN4WitkS0FOOUV1Szk4N3NNeitYdjNFcVZlQjZFSmh6?=
 =?utf-8?B?UisvTkNUMlk3Z0tEYjV2a1c1ZnhJakxvc2dRL3FiTGNVblc5ckxsQURlTG4y?=
 =?utf-8?B?T1NiYWtsNkhCYzdWeHZ0ZWRSVDVSakN6VTJrdnAzYXp1eXpLejd1S3A3S3pk?=
 =?utf-8?B?blRhbW9mY2w1eTVnOGpJZlF6T1dMSUhWcks3Zm9kVjdPMEJQOUtSdG55bTUv?=
 =?utf-8?B?WmIvcEEyYkFPL0J0NWdERHdzdDNoREpEdkFCNVNJUmFJQ3lPM2dPS3p3dUZk?=
 =?utf-8?Q?FMfbmHv+ZQ9f8Nh6K/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9596d6c8-7b3a-4def-c039-08df1e96eaaa
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 02:02:44.2949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIOR3RMj/s85xPp0+cgzSDI4TZlx0bntJ+e2ft0MDWOBFUCmQWYYL+RGKqzKsyO0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4307

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Rather than directly checking VMA flags, use the newly introduced
> vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
> assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
>
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
>
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
>
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that only kernel-owned mappings may set
> VMA_IO_BIT so the check is now redundant.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/userfaultfd.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

