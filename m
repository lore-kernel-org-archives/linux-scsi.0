Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427912253EB;
	Thu, 24 Sep 2026 02:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790216458; cv=fail; b=MOHLsgHybzjmlYvH3hh1mrhuYZP51FRLlySBFX051XKAKhRe0FvFEMsCgRZIZmKbD1D19KojZDy1c2K9HAiwob7DXPV58V2Yi/yM/n0QnUaaPnwiOLmecv6eNEzuOWHvfef6aXWj88Slb5s9pwwChQ/wvyjGyFuo7mcJofO8JAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790216458; c=relaxed/simple;
	bh=P250yCszL/82JvQ1GMiCjb5W3ozIsIiGbVtA86XQaho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IkFuRjNbupDa9pLu0RhyORv0MuF+eHl4ua5a7Rsya71F3Td9tjNJZBMuo/Yu/Z9U72R8Ur9u+J0dBx/9b5sJXRrHsF9XJXrAZ2nRmDkawwVwcL2F+6rtg6sbWuFNvUQw2PbpCioL/8MG8GQQ+BcdqK1DkSsuPXe0j3sQWlYjRHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Os7y4AZy; arc=fail smtp.client-ip=40.107.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Os7y4AZy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FEW8NXvNN7Ip1AMDoH/NDr10ZP/j0MD++ZTreI9Y8fvmDEmCahI/USddG4Bd+0uLHze+Vfqw2VsyOBrqBOhsaOoBo+4Jm+cIpNjbPZd4XpCv979BXO0F45I5QqZbYsUP4CupmPrEWvAhxxvz+80HtYgOH7/pUrwsaxhEjRdAvxaRqz43b9iNuu2rUOLu2eudZuhmRh9qos8eI9djOT4U7wDA2wgvV8fEGctFMdbvY4fMYvauhrLoR+ut0m+h9T+DtILpdiBBMoJkj2nhvCinAvATNNKt2T1+KN2C3xyvI5mUxdLBqKYvBHQsnqSkN37R67+1AsWth/1tXeLB9WZWiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3+f00+7OE+5/QGLyNup2ZjMtqagdnIsAWYHKTCo4rM=;
 b=EPldav/v6eXctrUXtVxtv/+1RM7EIoIOyzNB/W/Ju29wIqjgdZ+8kjWW7WVF8jlP6PSV6eEV07FO/D9n44bLKuawxX3UGHHWbbtRYyS+vYayWXMLIWLtoRCnc9p90cZOY6g8koVGVm7CCWuEwtPFpcJOfO7r2WnB5H+Szi1I6U/L4RY0611ftlxlPCKkxFijucw50d/wP1vCbwl96wlLQnlAc+f2BILenGjIf1H3CldzzeYMQGMszzr0gyjZTFnS92oF0eQCi7wTQn6XYOM2do+1rHvCyrO/rtht+QWHarcXmdNl0r5btvn7ZjuZYbUh55hxY59rwZjsm6angf/dLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3+f00+7OE+5/QGLyNup2ZjMtqagdnIsAWYHKTCo4rM=;
 b=Os7y4AZygLP9mAZXIrqyEXUU3/QQMgwFCOFFLhP71NnUy8Ft7xIZS3EKcwS1i6L/FK1Lrf/7PdWBai7Gz6ZJwqhRB9czYqVq2FJKVc0nWlJXNVcYJMCwVGb2m8ZaXZNNEhFsuVElQkcBHPCI1+rsnRKmKlpsHdooIuntR61pXDA5a9lhH28tB5kwGlyV+BMWsy9LZz6uFuubudiB+/K+0F/J+PAis/TUe3ItrWbCgrK+atteghn6vF5/GYTs80YCEZbgce355DS2MUygx+/9yq1OtZbVBH0WBL5W/yLQdIYawmnyI8KLy0d08mJkQGdwNBgZl+oW4NiFBVtVLx0hyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB9150.namprd12.prod.outlook.com (2603:10b6:510:2eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 02:20:49 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 02:20:48 +0000
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
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Date: Wed, 23 Sep 2026 22:20:43 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <26EB9785-2909-4D49-A755-09A72BA94BD0@nvidia.com>
In-Reply-To:
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
References:
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0946.namprd03.prod.outlook.com
 (2603:10b6:408:108::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB9150:EE_
X-MS-Office365-Filtering-Correlation-Id: d756cd66-f5e7-4f68-4938-08df19e27286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|4143699003|56012099006|5023799004|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	vAF891Uu3yvreEx2UHQuX6W8IEX/mlPqs3+Smof8FvsPNmQScSoDs2+FB3x3k2uo19SVOuCIXnoy9MTEEbZIu1gRy/CtimvSKSN9rskBe221z5ehDUtRP6nVu9iIGODbzbMefZ4TWyNY5el+DkXzcJr0R1IRygulCqZyWT5QiHT2Ct4rc9B1yNkzMva3/s1blmVxF7XABRHByA+Pt8HHYfp4kObzMhotCFZgidIrmL9icQcXAZq4dndy2+igaco2x0rG+2bk+beqGHM407OOa/Ra5MlI19WI2U1Ij0DM/G2D/llIDRjvbNTbYsbXcmvL5HvN6KKqrP7BceSPmSqJ4mg1WFnp+E+xpNLTT33/KUh0xFAJBVTdsDyjWL9OsbU70hgnUGVBwPY+k3cCuVoWM/eL/zR8R/7jXTCyCYTzUHbzG8ehTuDT4/bPFnXC5mVNQngIeUvY0Bmw1kT2B777w/jkQdz3YhaBEMMNSMQaAa+PWyrrq8SmZRDXEgiFDfobCOchSvLQdY5pcCKbf+QckqMLlSgHKipl2+GAJtbIHgpnydo6rBQpwbEeBzt1XJGPY+l+ALxei0ObL+uKYu+6KpIzfWEKIilf39mTynQRlQCMvf3pfLhT3FvMy9o4xDa/hyZdt2kh20vdftLnEjSLlHH/cbNrOT+9Smse0z4QCkw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(4143699003)(56012099006)(5023799004)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xh9+5RAafXZuRSQI4trYeDWrakKa8YzB2EWrmma0gz9ppwIRDb06jzYHyZqp?=
 =?us-ascii?Q?u8/RHkZZwTL5ZBLXTTm9H9lOnW1K9p56dt+2CThYqPSAX6ya4BI/vDAnt5NZ?=
 =?us-ascii?Q?RFVAZK54FbBskogNUtvlOTl2QyjJcVhLT++eFs8+1fh2K6bqtgzdvId5Kdo6?=
 =?us-ascii?Q?xUP4HmCLvXcz8MQnAIOQCc99ySTvYMQZ+oRBMWj9Ky6irHLJyGPMxhMnu3ke?=
 =?us-ascii?Q?Iry/L167hUUgO6Ctf5XLaaQWRKwUTybgURTgWSoomwogACAc8pDEuOd8bG6k?=
 =?us-ascii?Q?mlXzbsq7mYhJWFKj3uUOgf/P5LXbbQbNj00xu/kX9gGegRwPEk6euEMvJd+g?=
 =?us-ascii?Q?A5SpAYqSXLvVaiW66c73h1fjSi+oCH9bZ+cF9+HwVOfwKACr2y6RDHxaJOsi?=
 =?us-ascii?Q?Gcb3G9KI/b/o/VaAGOV7c6AGIhFssDV4uzrVubsGurTWaZOMsxK7M/d6WST7?=
 =?us-ascii?Q?ITvOCYYQ5+A94DNE1PtR6MhBM3KBONyVh9xrBbywBwS7fkeA2P0HZYgViKSp?=
 =?us-ascii?Q?jlcZdE/msUaQS6oemeaBS5UZxJYudGWqKtstdnt/Ez+YisvpScg4eDXHyf96?=
 =?us-ascii?Q?eU0i6nfR464z8JVs9qEMkK+kNpVy8HMx4pPHbcNgfwfyEhGegNSc8EUFt/wV?=
 =?us-ascii?Q?y5tFdqOtmoI1nr2NMTGMDqrDeT/G+oMqXebVARSlqPEQ86MmSbFzI8E64+3C?=
 =?us-ascii?Q?25b4Gs9i2s5yILNWsXKEIidNaewLODMlJWawHRkdgUkt+OhHY3s3O9kf0Hsi?=
 =?us-ascii?Q?+EmgriPx9z6Cwg1mT/pr8884lJnS2iY5JiL7kAlgXWR0oLc49xFCUD4PIvRc?=
 =?us-ascii?Q?+cVStPKeojSdIxUmOLeBN0L2nqJGKAeZSgRlLDdYsgQ7U11nP9+CMK0N+v2G?=
 =?us-ascii?Q?YshkYrCoF49A0g3B4QWhzU/syMA4wa5QaZ/rMn8FBsq1BWVr2qgMcySnY7c/?=
 =?us-ascii?Q?4byNwN3j9Admm4UpXmr4qbKpxRYb+cjOVfe0IyJMnZMzwtq25HH3mO4DPKQl?=
 =?us-ascii?Q?KjPcLqay6p1HXC5i21PqdfATgGW9e4HHHLVlDDLpysdqMh/jQEEmOTiiMckM?=
 =?us-ascii?Q?nfA2OB7resXhmLRoIlJLl2LWnJ6CqVq818PvlwxiVylzBDFUDlZxfdreTGRW?=
 =?us-ascii?Q?hhLj+R1aO4pXK2cCXLi7RUNjiwKWUo5/as0aXPHJMQHeLa9GtNyyIEb7qRop?=
 =?us-ascii?Q?JqomsCxbuc+6T95HoH0XXtozR20hqbvkN5q7qvJ44JE1fCgLIrkI3c0ZZ/I2?=
 =?us-ascii?Q?5kBNupIwy+T9vP1AkSBs/fhhuZxvCLbd1a28H7ErdfR88AoZCVzLPFet9POB?=
 =?us-ascii?Q?ZhXQux02XLAitI+S3gRaSY0C6mOK7fb6c7dD15dG2B1/5pPytOj79s+ExALB?=
 =?us-ascii?Q?fq2DQr63c7yI5Z1RWyRkbIJm+HKgdL8ieevnZ9M4E0IjDfgAzZ3CTWDu8H8G?=
 =?us-ascii?Q?gvgEjfdS9y3eVY25A0RMep6sDjPhNQsDLFaHH3T98410rIhHNreRbHDF5Imo?=
 =?us-ascii?Q?gZg8ljPQUmAAyW8gUwlSCo3SDG4RL/4Q+8Mlb8DpjBb/ssp5rAfcCp+jXM2z?=
 =?us-ascii?Q?Hvw4Bg/Miyby5KHxG9D9JQHlsjE37CbMAzwvfov1Aa9F1NaoL6jSJtSxxqTY?=
 =?us-ascii?Q?V1VOYwDdQsY6tOcktVdAIDJz3EF3hiN8DGryokehm6qSH1TSqu/Rc0S2TOqI?=
 =?us-ascii?Q?tQaa6WgxvbLi4yFfwaUug0GRPQ4yeyQNIrAcsEVMSJbAb9bM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d756cd66-f5e7-4f68-4938-08df19e27286
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 02:20:48.6665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZI+lxUdi2FGrBf75OaraOZjkam5K29+pXlxtyhA+lzIAkyF+iRrKsxWnomUYCtj7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9150

On 17 Sep 2026, at 12:22, Lorenzo Stoakes (ARM) wrote:

> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
>
> Drivers are permitted to change the owning file of a mapping. If they d=
o
> so, they are required to take a reference on that file.
>
> The mmap() operation which ultimately invokes __mmap_region() is guaran=
teed
> to drop the refcount for the original file the mapping was made under, =
but
> this is not true for the replaced file.
>
> This has been addressed so far by tracking map->file_doesnt_need_get, w=
hich
> is rather poorly named and unfortunately fails to correctly track wheth=
er
> or not an additional put were needed in a number of cases.
>
> Make life easier by removing this flag, and instead drop the reference =
for
> both mmap_prepare and the deprecated mmap callback in a new function
> put_map().
>
> Track whether this needs to be done by aligning mmap_state with
> vm_area_desc and store the original file in the map->file field, keepin=
g
> the updated file in map->vm_file.
>
> In order to have the same behaviour for both types of hooks, only drop =
the
> reference __mmap_new_file_vma() itself took in its error path, deferrin=
g
> the replaced file's reference to put_map().
>
> To make this work correctly, map->vm_file has to be updated before any
> error handling, so update __mmap_new_file_vma() and call_mmap_prepare()=
 to
> set this field first.
>
> Also when mmap_prepare() changes the file and is then merged, the refer=
ence
> count also must be decremented, so update the logic to call put_map() i=
n
> this case too.
>
> Also update __compat_vma_mmap() to manually perform this step for stack=
ed
> file systems using the compatibility layer, and update
> compat_set_vma_from_desc() to replace vma_set_file() with a correct
> refcount/file update.
>
> No in-tree driver is impacted by the incorrect implementation of this
> currently (no driver that does this is mergeable for one), so this does=
 not
> need to be a fix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h |  1 +
>  mm/util.c     |  5 +++-
>  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++----------------=
--------
>  mm/vma.h      |  6 +++--
>  4 files changed, 59 insertions(+), 36 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 0dca33db068f..fe576d468af4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -7,6 +7,7 @@
>  #ifndef __MM_INTERNAL_H
>  #define __MM_INTERNAL_H
>
> +#include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/khugepaged.h>
>  #include <linux/mm.h>
> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d0..016932780925 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,=

>
>  	/* Perform any preparatory tasks for mmap action. */
>  	err =3D mmap_action_prepare(desc);
> -	if (err)
> +	if (err) {
> +		if (desc->vm_file !=3D vma->vm_file)
> +			fput(desc->vm_file);
>  		return err;
> +	}
>  	/* Update the VMA from the descriptor. */
>  	compat_set_vma_from_desc(vma, desc);
>  	/* Complete any specified mmap actions. */
> diff --git a/mm/vma.c b/mm/vma.c
> index 55917d097933..fa784f069da4 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -24,7 +24,8 @@ struct mmap_state {
>  		vm_flags_t vm_flags;
>  		vma_flags_t vma_flags;
>  	};
> -	struct file *file;
> +	struct file *file;	/* mmap()-specified file. */

IIUC, file is never assigned other than MMAP_STATE() and should not
change after mmap(). Could it be made const to prevent any change?
I assume mmap_state will not need to handle the nesting issue like
vm_area_desc, so file can be const.

> +	struct file *vm_file;	/* May be updated by mmap_prepare. */
>  	pgprot_t page_prot;
>
>  	/* User-defined fields, perhaps updated by .mmap_prepare(). */
> @@ -43,8 +44,6 @@ struct mmap_state {
>
>  	/* Determine if we can check KSM flags early in mmap() logic. */
>  	bool check_ksm_early :1;
> -	/* If .mmap_prepare changed the file, we don't need to pin. */
> -	bool file_doesnt_need_get :1;
>  };
>
>  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, =
vma_flags_, file_) \
> @@ -58,6 +57,7 @@ struct mmap_state {
>  		.pglen =3D PHYS_PFN(len_),				\
>  		.vma_flags =3D vma_flags_,				\
>  		.file =3D file_,						\
> +		.vm_file =3D file_,					\
>  		.page_prot =3D vma_flags_to_page_prot(vma_flags_),	\
>  	}
>


Best Regards,
Yan, Zi
