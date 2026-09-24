Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2685214B950;
	Thu, 24 Sep 2026 02:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790216876; cv=fail; b=WWHKziH4mG+Tip9KMBAA/vEJ1HDCKUsxwUILAqssSmCt46O7Q+67LE8GOMJh8cuIirCl8wnbQWj6R6WvhHLAYbtEL5XZiYjaDXnpWQsMJkqUOpTee4Cr2kCsNS22pXSUTAntRUEkNENJ3HyI5HsXri3zgD72pYkoTzs6OOIffHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790216876; c=relaxed/simple;
	bh=Tzcm3jByn55s9J/xPVANwIxUYc/EbwAFuUMse3oSuoY=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=FPjSnf8oXnTHH2dx3eAAqfrCJy/Dd5mLh4IAPqIn+WQApVY2xhp3BAQ0xG/DUKaiZKzyJPUT8QbfBKOetO3zTRplB/Ga7d0NI9oOkHHt6f/bi/MsCP68u7iSzQgbxbB4pKZMpaLtx+bo1xajP2Rgg5o7Q0AZUQ/ZLBW7rKCw1QM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ytxne8RR; arc=fail smtp.client-ip=52.101.53.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ytxne8RR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TpbelDJMtwQcZ0sMPoNtAlCd2xEE6eptuuMx/Xu0QgDwsgyDqWyXD/Xo0y/8lmoKEt/oBs6UJKndjxsrltBDXCV8S7G7mtu7j56+kfO0/ZSawOW9ldDcbMI8E2xXLDMqqM2SLbMZem0fjB0gOZCZ/O4jnpPttgrtOX/tfOlDA3v76/P6m2pwzQr6m+JRoyDZERuLiS0jLmwtfXXzbnAs3308eEiiW6iGpTgM40uPCAvic6XdoxAsWImtr2/fT9DwmNy55vJr/HFy8kS/sqRrZdXbcoxHXLKmc1GWql4C/KTT/dvoXktAjgJpGErup2inHRH9ndcTlLpoWeLXcDq9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1LtIhaUTUdeoozg5NLLRyrgipCYkM10mjzkOuPfjyc=;
 b=OGhOfJQnhZhQpqO8P385nzZBs2VRT4LDpZP7E2F4ynN+xhwxvS0kUjAiCuNoLhnQrNiBQwfB1MOFF/k6Dj/I34oJqIDa+BmCwRTp2LZVipHm54h9vjgdp+Hd76B7lKIvkyiZtgeZSOqT4Q1L3ew2uUIBMEIWjbKSv5lYs7InVsKaXZDORAEwnUVQqGWWPc/RtA7kBLnSGbuv23u0YwH/Mbae6Ddt57D7H7/JvzN88zjargxntuesCMhO5X2BkGAYNPAUXH480tnvjCv3lsTrO4WS037fExVyLSq/PPf+58KB2IB/d8tyJA1OcCksXfMeqT7vnHb/fV8JvBQWlstTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1LtIhaUTUdeoozg5NLLRyrgipCYkM10mjzkOuPfjyc=;
 b=Ytxne8RROiBMZ40exgcjankSpBMCRxQpQ4+hpoxrLcmrhRGq5061m66CC1RjxMnmFpa5FPLwPn/sWYwtdyeHN80b0EQKPZmXtuwyxIBKQt25zEzR/+PJWRgE2N2kojG2LJ6SUU/bn4XxfBYeBVjwpPJ9wXOWEIPvATw4IAkBMFwTQhw6s+/dr6x1mWATUB22YQSzlyNPPqA1Nh9wr3yuxg8f8dqAuKKPwczr9HMhHANP/jrQbiYoi18ryTm4tnZ3svHEs94+/uZE/wu6OyUWCWT6PdPm3hXIWSHZ8n6zMiHNDo8Y8fXK6R56uxpYPRyHkyhA+Ai0+kMQ1oFZbQs01A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6996.namprd12.prod.outlook.com (2603:10b6:806:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 02:27:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 02:27:44 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 23 Sep 2026 22:27:40 -0400
Message-Id: <DLN6WW7UF382.3DBDD29Q3TTCS@nvidia.com>
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
Subject: Re: [PATCH v3 03/40] mm/vma: introduce and use
 vma_[flags_]can_merge()
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BLAPR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:208:32d::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: 365a800d-55f0-4cce-1ccf-08df19e36a16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|921020|6133799003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bZPggaFTO3BTEuYsL+yCVCmkwM0n2gYY6dBHMcDTlCe+cFu7PU92q5ghe5p04YsKI1kuzw2N8IQz75DdketFE9Cxdvyl8ZlQNFiAR0HlWZg0lDbl+cqX6QtRNq/0Z5x5PSJcowr/NXxlWdfHV4dQgr3RCf1okgoS0u8nPW1cn4xFB7PHLKykqb9XtJcNkjpRR2tIxVm++qGz3/kVLHpi3PBmOSXaamnmnYAvl2Ia0i7i+vNbd1xpPk/smFj2dFe03q/U6/7Sj5bY5F4/d8qzDApC1XVqajBWj7tyTAabHhDTjGx+GnGLs4NyskfZ3a5gWSRIJGa67El0mQiv8Y5eKNEf/wyC+vi3mTtlaTxMWYzvAYIkzwox/VW2Q8QMZSmCRMzINiBvPEAwb/6F/b9AlcXMcLhVJwaZ2yq5X5H/QLg+IomZNMfQEwYFCqSok18M2L7iWGncrB6QVo8cygjKn0jEki2tl/O9irpbY1ks0tg4XPE87Z3k3MeIrzTgTWtJv5HYnrIePUT50Y+cBEvNVIc9rY2JtroeXwIjRCnYZL/rTbdFKc85wLUARjUHXIZZ8sL0dBZUGksxdQd/Ic98UeR3QVrKXSs2ciFoZk3fCTCmU72aj1FvPWMBL9JixJ8g1mLHLIqShaTibSs1oLmDrvSRcKhT1HTj9IEVk013AJ18YbyxvhpQDBJmUeG84mLPP0wUbM/nJU56GCAJXlwOMQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1dIVVkxMkNzSGU3VkxiaDZkbWZpNGVOdVYxSnpiS0NFZUhmZGdSMlQvb3NU?=
 =?utf-8?B?YncxS3hlQVh5aGVNVEY2eFR0djZEQWJKTUxZMmlXdzg3RXlWUVJwSUNIN0pJ?=
 =?utf-8?B?NjVsalgzRTFTSjlocCttZURjclY3Rk0yYjVmUzZuc1JEWVJrQnRYd213alRN?=
 =?utf-8?B?RkxlSytIZWhsLzlORnQzV0xUWDh4ZWJubHdqdXlaSVgvQ3lKRkVoMXQvbGFI?=
 =?utf-8?B?Q0ZnNm1NSWRUaFgzWnFOQmxwOFA0V0k5V2hqWHBDaDJvc3VmaWl0UjBCTHpH?=
 =?utf-8?B?TXFQdkY1NEt0VndXdU9iY2tXZjZyRmlYbW9WMFRZeE9XaDJRTyt0NkZSSm9k?=
 =?utf-8?B?TzdyMURtbU5ubkFVZElrR2pXaTcvQTZUZjJ5ZUgrcCtOS3ViMmdVNGZiemtV?=
 =?utf-8?B?VFdZNXVnUFJkamIrSnJRVEoxZUlOZHhvVnVkSWZLaUlOUnVETU42VDA2QkNP?=
 =?utf-8?B?a0Z5dGYwUnBzREQzeXJGdEtmd044S0trWDVPMkdJdFpCSFRKTy9DbWRiVkNr?=
 =?utf-8?B?WjlTNHFDZE5iS0w4SCs0SjllNThwNHBrRzZ5WkNzZXlvZ2Rxak1yb0MxTWhl?=
 =?utf-8?B?T1hjNnNCV0JDT08xMlhkalhaV2pkZXRITnk5RTJKcW9iWlFJcnBWOElQUkRG?=
 =?utf-8?B?VkFmM0tIQVFsUVRlTnl1T2s2QnRnSU5ENTZEZXNjaFlJNFRVOHAzNWhXSmNn?=
 =?utf-8?B?LzhObEZuRGErNk5GVkZZcERKMEhOT01OVjQzM3B4eUpVeTN2YkE3aTMvU2RP?=
 =?utf-8?B?OVhKVUM4ZjlXb0NRN2cweUJHNTk5ckR6cWtNK0VuUjcxUHNoS1FyRVk0Vmds?=
 =?utf-8?B?K2ZYbUIxbTZHZ3RYZm1BaXJUcXFwZkVldjhPYjJsTVMwT2dJcW5BUmJXNWNj?=
 =?utf-8?B?NGx6cVU4c094aFRmcjZqMXc4Mm95WHVQMUlmZnMvcE4zQTR6dlhvWjg2SWps?=
 =?utf-8?B?aVR0ZVJhZ094K0k0ZlBBbktTbVJxaUp4eEdsWS9nRGI2UVQxZ0ZVbjRTaENF?=
 =?utf-8?B?bW5JUzMwMmFlR0x6ZUhOZGppWnh5YUtRUm1DOXhLYTA2RThUWm9idjRnZFhJ?=
 =?utf-8?B?M2JnL2N1U1dSTkNVVUYxbW41ZTR3NlZyOXo3d0xGNk93TE0wM2l6akd1OHZq?=
 =?utf-8?B?NDhudk1uMUx6a3VYVHIwbVJnWW55S0ZVeWFZN2x6dzF6WnQ0NFo5aVA3alZH?=
 =?utf-8?B?UGlKVElnQnpYVVFBWHRKMjNHdGdWeUQra0htWkhVME43NFd5UTBuZDF3Kzg5?=
 =?utf-8?B?NGhjbis0elBpVlY3V3RVaDk4RHZ4UElETURHbHA5TW4rQnRkd0RoZmpNaWhC?=
 =?utf-8?B?Y1pDd041VWx5elUzTW1CcHdGUGNzZFlRWGgra3Q0QTR5UElveTlHSDVVYlJU?=
 =?utf-8?B?blp6aXQ3SituK2JPck5QS1c1cm1YVlBEdU52SUlUUTJvWVoxZ2l3ZjMybVZD?=
 =?utf-8?B?TVIvS3FGRjBGU2lsamkrZDN4ZmZERS95MFBNaWUxM2lhRFJVVFR0dk1hM0h5?=
 =?utf-8?B?bkxOb0hzQkFOS1FKNWFQVnZZaXlYcVNMT0pYZ1ZDS293YklHOTVwTGZObXY4?=
 =?utf-8?B?NC9mc28wdDQrSjJWRUFUSkcwanJpZkFsZTRLaG1SVmVXYXByQnJSZU9BN1RD?=
 =?utf-8?B?Nk1pSmRmV2g1endNNzJ5T2hDVE9oME54OTRWK3BHenJWZnl4dGo2RWdOTWp1?=
 =?utf-8?B?ekRQcGY3WTRJRVVIVHpHVUJLczl2Wm1XYWZPMEd2ZHRkQ3ZnMVZNZC9QUzVv?=
 =?utf-8?B?aEV5dWlpUER5UU9oTExOa2pNR3N5NlFMd29VYzFGOGdFSlFzTjVodzgzSFJa?=
 =?utf-8?B?WVZIR2cvYU1WcTZPL2VGZ2RjVStkNkZWR2lmbnZiT2FwMzBxekNITXZCemEw?=
 =?utf-8?B?Yy82UTBUSmphRmpiWHB2bm1lcGpmaUgxMUJJV255R3NJQW5nVzhWSTdNVGVR?=
 =?utf-8?B?ZzNkMGRzMmxPUU1TbmhtS3g3enczVjhSOXY2RldLKzJZbkc4cEdpQ0dBclJh?=
 =?utf-8?B?VWRTQWMzR2lrc1hlWlRjdlVPNmFTVzBwWmhJNllROW8rQjAxMkVId0JhY2Jm?=
 =?utf-8?B?bXExcWdYMlFZYnFURmMrQ2Q5MkQ1Rms3MWdrWVNBS2RGRytuTXVpSzRsd3E0?=
 =?utf-8?B?V3ZrYUtvNDVOMSsvRkdmRmFZNmtpT2JQWWlBQnZYR1YrTkhzLzJPSFcwVkQr?=
 =?utf-8?B?bmdkTHZJRzhLSlN0N1h5Nytlam5oenc0YzlwZzZnaTVxU3Myc3Z5V0FlOWVo?=
 =?utf-8?B?TEltdTc0dlRpSWd5Q2F6bUU0eStDdW9EQWhRSWRMZklYY056QjVXM01ycndt?=
 =?utf-8?Q?F6Xx/OVcdyqU0pyvyh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365a800d-55f0-4cce-1ccf-08df19e36a16
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 02:27:43.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Of7sVOL4RJ0pLv6ma+Ma3fbvS3uThVYAktGZXXhMnCRj8Ze14Tu4d0xAn+pYp6tF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6996

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic wit=
h
> two new functions vma_flags_can_merge() and vma_can_merge() and update th=
e
> merge logic to use the former.
>
> This abstracts the check and expresses it in terms of the desired behavio=
ur
> rather than an arbitrary and confusing VMA flag.
>
> This also lays the groundwork for making further improvements in VMA flag
> usage.
>
> Also update the userland VMA tests to reflect the change.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 21 +++++++++++++++++++++
>  mm/vma.c                        | 19 +++++++++++--------
>  tools/testing/vma/include/dup.h |  5 +++++
>  3 files changed, 37 insertions(+), 8 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

