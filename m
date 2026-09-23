Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04594490BEC;
	Wed, 23 Sep 2026 20:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790193988; cv=fail; b=f/FDKAxmnSDZb74efVi9+idnQgcfVLfaJ/GEAkutIPL4tf3iXsCn6Isb/lCiVX9v4m1/ouOgPV9KTu6h221xvaAAkd0Hlsh00wecdF3K4y67t5VNejQYpIz+qxDNTyFbaaY6ktD8b82wDdUsF47jDHDYp3guMDKVfxTVbrgeT6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790193988; c=relaxed/simple;
	bh=q5qZrTckJ4qgPIlXFtTq8lBMlTrtPrITY8paV2s1BwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SzePv3J+AIShcatFn+tnvtSkMBHmo3vb3ARFjTs2i8pa5GuyBCEcxG2uI+pKQFPYqERal8iqTeGoOjuhfO74w71l3Rhio78bvCdLl0CrKsi2oY8vIXNuYftLEEM2OtgAW6kfMB7TAtK9v+44jJ3UK8QhJm/takzVCL64BhAX0h0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gr//TUr1; arc=fail smtp.client-ip=52.101.53.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gr//TUr1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqGbFeO9DU6UDkplCSRBwnlShfZfw/Oak5GXwSkwXFVTpDBHHPX6LoNHTW2JeSC9aeV8GpF8a8dZjYvTnTzVn3fIFf3/fOpKHDdOsZOM67VHUhZExgsi7pAZ1SZ7+8O8kgxUjtZPYvxsxLblfbazpVrQD7+u2WW+UaEZvixYDLHQ9xsKd7OM0W68N8dbXXcLE8axY7/mD8k51f/JTVnkMHYcG8w9AaReaFerizU16v4ifIbVSZuvmecZ9hcoA0IDPyP+H9H1OfVEN8WHxqBBBk3denEYSu6GQ8Y351uQ4c6qjhw+5aRIY0e+rqK2oD9qHwYkdrPe2ozPgIujzVQQyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOyNVeKRu/9wsHn8QCFYQsX3PWzgjdbOwqmDFBWtgG8=;
 b=nc0ORK+AwPAxjnpKvCN24EF8XNDZv5CX3sAqdP4JAcBak9fpdWBX1y0qzSVKc9FOXNtg36pOZmyMKZMNyYUXH3BfQPoXUG33DSi3pKHNV6ghRtx9V65JXNd/z3DYwYI6Y6L6id9jKjX0V4kbkrHZvsgWWF4A4IYXismO2E5mvSYnTvhBXHPjTgTUg4PX6oU6BLg1eUckzv53ECrJawLCRxuiz+vIIB8txA0T7lf2eQK8pkjsEdRo8wBYeLFHAH+au+U6ibp6I/8taakEwDtRrXf13yOJyd0c4/oQ2+0rt8PLp+qNlQ1fukvcQWUzcraXK3xvgDJoaJCErFguRDCggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOyNVeKRu/9wsHn8QCFYQsX3PWzgjdbOwqmDFBWtgG8=;
 b=Gr//TUr1kHrdmE/sv4thV+efXiTji/kJB+eXcAooL0UNQ8FunYILxMxB7JbTPIR3Qt2CzAOzh0i404obLxy2Zhndjq6mhBBN/JMZE3ajaUNu6gPaj4C//d71NGThuOs4XgVux7NCp2Vg77Iu5vNOSLrzMVuJVX8M9/he6OZQ0Ke9RGxFB8MtVvQ8Bid1K5vPWFby9VopCftjDxu/W4svHrd60URXR/sKYUl1Cp/F3u34p2woc0yn1Vh+WsCrDikkrJ7NP8mLrDfBvAWgi3x+sPbY12kg2a1tmuwcQZhrxT4CfIJkUzVPPBPkCCE+CSSkYdbThGG7DDtNpC2y8pX57g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV0PR12MB549960.namprd12.prod.outlook.com (2603:10b6:408:3b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 20:06:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 20:06:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Date: Wed, 23 Sep 2026 16:06:14 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <93672B94-BB0C-4713-8F8A-3619D81DB7BB@nvidia.com>
In-Reply-To:
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
References:
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0323.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV0PR12MB549960:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d67e920-10df-40a6-5309-08df19ae2126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|10067099003|56012099006|11063799006|4143699003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ruHTBwpA285QO7xfQ3JaJyhxtvOsbInycmqsGfj8SUC2vxcKwLdFe8UZQpVa53EokHzBENA8me1zwnYvYMzNNbrm9yXBbsHODj6OCukQAJi1fnnhgOIqkNw2LAeGQgdcoQRCesmbjAVNvSN+BTwEq9Ia6MICyNkH6CUDkwvzcSpoX2kZBo7hj9Om5S3B5ozNCDICRcf5NPdfjaHjUoycaZMEmr5alBBvvAewKIibYOjJys0PrYmU/KZh7rizCgnifRA5yJ1IssDsL72RZMwBzR/PjPOx8N5YkbnQ4ZjatuwYZXlKzd5cOM6xbckUZdnSinlUZjKl9DUtALCfp5htPHt6IGfkA9stQFi4QIh3TYEY7Eo+YZdNuYFfDzBNKcNZopwHYsbtuImX5R3g8t9pJABHQdLkr93UHHQJYOEQvy7aON2XtqmpkjArXmvWGr4OrxpSFCws8DUuus2Jo8uUEH4Z6ZG4z38Q8hphyZKEITbXmSHRF7O/r2G+5XGToWniTIntaBG7YpEbcRRjkTv6ki7Lf2yl1zfYLoISCEwk9EJAtZ5yFgrymUbqsKYl/WbhGXeJ8wyJa3Tm2/NhRIDZIUefnM8t7d6Bjw9ePbrBAdvHY2Vg/fI8xFXfYjxWcf6eOuwyp/IjM/Nz81gFV1gVYBQr/lV4gfUqm7bfesNk+og=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(10067099003)(56012099006)(11063799006)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ino+Wd+e2ukwsf8MskuuANxez24WHYwUiJHMMezH7BweN1ys/JiP5ndMwOe5?=
 =?us-ascii?Q?ZkRxIuH115P29KtErLdKHqL7uLDoydRvaikB0q3pVedXyrXrCKayLa0UHeOA?=
 =?us-ascii?Q?XDzUegrb2SVHG/jbLntrgx9gXygeSOBqRoE7pSd3q0wLgq1RwhR9hI3WNnHJ?=
 =?us-ascii?Q?aRzWrw2JOfyIaWl/zyMePvRqipdVYmLvoVuGm8AvgK/1LA12wa+pY2eugkBa?=
 =?us-ascii?Q?aDO79PXjBeh0iCpbhdB9PRX/Ypv7H+LQn8ZVKXfXFTaBQCDyG9upRTSLLiby?=
 =?us-ascii?Q?1FysjOcEh+cgFe5jwG9a6zyRvecV3v5y9ZuLHyBrSWeRk+bssna35Opvhhje?=
 =?us-ascii?Q?WyAdGpfGkFJanWb/oEIZeumdQsktnv7LtaZGRMNxeiFcaXce5gnvC8KdYeZR?=
 =?us-ascii?Q?t/clhKiJR8dJ3Wg7cElrGRmeOnwArnri6zj7Oa9mL2ib439ErDBasyeKeMwt?=
 =?us-ascii?Q?1whkoz+ow2fu5iLV7Xfqq0Gt8rCsGDTgX/6QHHCRoq8jOz2b4E2B7APAnCp4?=
 =?us-ascii?Q?fZuEtRUdCBiz8+/cxeDCLxW513WdL2mPa4a8RDZe0yCjg5OpEYpdH+r0RxPY?=
 =?us-ascii?Q?Ffi8jBr05xagfFLoOCuDJZtytZXVczNZCywyjhAIPN3WGMfs0DAxquLPA4G6?=
 =?us-ascii?Q?iLwMvIHOBzwjwSxxke/xQYkM9XPOpQXCYt07Cc0XhLwGvKPJEOe0+z3FE38C?=
 =?us-ascii?Q?wY4r2HWvfmCYF72h1J4jb1cAiGGAfSgTD0jBC726sY2X2PjO49D/sQNeXbwQ?=
 =?us-ascii?Q?yiCI6coM8FdtOZ1GsTM2loYd7C0qOfe+4pCcJQszruw6MQcPRrj9WWk2ZlJ+?=
 =?us-ascii?Q?WbcJc6hTll8EO1v+czlw7XBhRvYj34RJi4trc+zkgZhejBbheRVUeqnRYw2a?=
 =?us-ascii?Q?cFriYjHgQsCEw1l5fXlgzuV8pLZAK6qowhzEEukgBK5bvDN8WFqBGdpq4nOX?=
 =?us-ascii?Q?yWFsgplndMX/GH5qptGga0WhXDyA5FEW6/DgTqi+oMkg+MqIaERAS6QmaItN?=
 =?us-ascii?Q?g4vn0zBZsaZsFI0b05BiDlJ8gq2m/GfJVrrfHtDQI8+VapW+LrWhdu5QqblM?=
 =?us-ascii?Q?l8gSIQKsMlwXroSzJPLSSC5I177O+wQbpcYqfJYPwara9mQW3Co+YAOY/+L9?=
 =?us-ascii?Q?HTrKrlXR/9RBM2NBxaJPgZM+irr3eYPETFA1u/e2J0Yxw7sgcaNV5WJN4y1X?=
 =?us-ascii?Q?jExnedFEPP5KsXEgluPJeVOc8JrxjkVZnbHTaXeWcX6dOAAEQSv/T+VgP7ul?=
 =?us-ascii?Q?f4EyVmZ99G693hi0RLcoWcD+kE5Rj34G8NfQywsDLNYgbW+Zsgdn9mHgLqoZ?=
 =?us-ascii?Q?FuQmvu30qEehcLOaPOQEMKEyg/njWUdf551hnRtZwrPJiWRF3wNL8Xo6y2tS?=
 =?us-ascii?Q?cb7qeeI5gtMVJs0Gk6SMVVpyhLkZCJPNmPH24lD+tRiQYih01MnWK5pUUPWl?=
 =?us-ascii?Q?+OsY1NyRcfEoDwnd22W7eMwhe5AP0hvjwYcskKIU272v3XP1WCuwfBGbURPA?=
 =?us-ascii?Q?rHXhGMxio0BGKKYccbtiimHH3Pui4uy0lGUCdl27P/jVCAkx1QjyuH+TGenh?=
 =?us-ascii?Q?+WD8DsFyDHNZCBug+QoXB3Z3SXyWOetD8OaS/YfPogXXMfpzIdSeSJUeJOYx?=
 =?us-ascii?Q?zf7Ed6o1DKKneZeDSv7EainGlHp2Rnh15lz7F+Lfv3EsGyPwEB9h2uuRUQFT?=
 =?us-ascii?Q?gZUqIoQBzR3jTQ6+5QFCO5dIpSpnW0eiBnvmlRgfmKuw9szz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d67e920-10df-40a6-5309-08df19ae2126
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 20:06:18.3971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Kh8g4LDR6xd/9h9xKMi2qXz2uqlRiQfuNDhZaM84x829j8oxvbA4SO7ahiv961E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB549960

On 17 Sep 2026, at 12:22, Lorenzo Stoakes (ARM) wrote:

> When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_=
BIT
> solely to fix a race with migration which might otherwise double-count
> mlock VMAs.
>
> This is unnecessary - at the point of applying folio mlock state, wheth=
er
> setting or clearing PG_mlocked, we know whether or not we are locking.
>
> Solve this in two ways - thread a boolean through the page table walk
> indicating whether a lock or unlock is being performed, and run a locki=
ng
> walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.
>
> This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implie=
s
> VMA_LOCKED_BIT. These are also always cleared together.
>
> Then, update folio_add_lru_vma() and mlock_folio() to check only for
> VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_M=
ASK
> instead.
>
> Also remove the useless invocation of allow_mlock_munlock() which simpl=
y
> returns true if unlocking and instead rename it to allow_mlock() and on=
ly
> call it when locking.
>
> Finally, with the other mlock abuse of VMA_IO_BIT addressed, update
> mlock_vma_folio() and folio_add_lru_vma() to simply test for
> VMA_LOCKED_BIT. munlock_vma_folio() tests VMA_LOCKED_MASK instead, as a=
n
> unmap racing with the locking walk must still munlock folios the walk h=
as
> already counted.
>
> While here, also replace some deprecated VMA flag predicates.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/folio.c    |  2 +-
>  mm/internal.h | 10 +++++++---
>  mm/mlock.c    | 51 +++++++++++++++++++--------------------------------=

>  mm/rmap.c     |  4 +++-
>  4 files changed, 30 insertions(+), 37 deletions(-)
>
> diff --git a/mm/folio.c b/mm/folio.c
> index 47a437e0f7fd..35e242b48870 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct =
vm_area_struct *vma)
>  {
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) =3D=3D VM_LOC=
KED))
> +	if (vma_test(vma, VMA_LOCKED_BIT))

I think it is worth documenting VMA_LOCKONFAULT_BIT alone means mlock in
progress, like you did in munlock_vma_folio(). Just to keep the protocol
explicit for all the readers.

>  		mlock_new_folio(folio);
>  	else
>  		folio_add_lru(folio);
> diff --git a/mm/internal.h b/mm/internal.h
> index b2c6c9435021..84aa3e6c8bac 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -971,8 +971,7 @@ void mlock_folio(struct folio *folio);
>  static inline void mlock_vma_folio(struct folio *folio,
>  				struct vm_area_struct *vma)
>  {
> -	/* The VM_IO check prevents migration from double-counting during mlo=
ck. */
> -	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) =3D=3D VM_LOCKE=
D))
> +	if (vma_test(vma, VMA_LOCKED_BIT))

Ditto.

>  		mlock_folio(folio);
>  }
>
> @@ -989,7 +988,12 @@ static inline void munlock_vma_folio(struct folio =
*folio,
>  	 * always munlock the folio and page reclaim will correct it
>  	 * if it's wrong.
>  	 */
> -	if (unlikely(vma->vm_flags & VM_LOCKED))
> +	/*
> +	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
> +	 * mlock_vma_pages_range(). An unmap racing with the walk must still
> +	 * munlock folios the walk has already counted.
> +	 */
> +	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
>  		munlock_folio(folio);
>  }
>

Why I am commenting in the middle of the series? Because I am taking
a quiz given by LLM based on this series to get myself enough background
knowledge to review this series. This mlock part came up at part E
and I only have part F left before I can do the full review. :)

Best Regards,
Yan, Zi
