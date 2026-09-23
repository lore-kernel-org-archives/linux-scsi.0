Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD6341DDEC;
	Wed, 23 Sep 2026 08:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153879; cv=none; b=cDegpxq1VMG1EfHufNBDiJuxGNewlckc/VlBFIy5e73L8aiz5DLKBD2yqxrJCC1zhFYQG5CrNIarT6L4vPsiVkLa0J/C/o0WuVcQxkPz5F1yZZsG+6xy+nfYon6pilTebONhyukPJcaWXtmBow80Brv6/TNgF9haQ+pP8RlZnRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153879; c=relaxed/simple;
	bh=NbxeVu7GQLPX31Zd04XaMUDdaWB7vEAx8Jmlhh/1e94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlCACv5r12DxK3VvBMUnekWHdevec1z+QQ9X3FQUweD3qnMRhq+qH/CaEidvaRjT2mQSK0ycXxRCTZhqg3tO2fksKqvuxjT5o59hx4ToDl27e7Xwyd61Z77KW1Y3NDMIEGxI6ptsTqXsrhPfdBSovG3m51DzzeWlduUhZlcuqKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXowWt4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXowWt4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D981F000FF;
	Wed, 23 Sep 2026 08:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153877;
	bh=zEbllmgiFfsLRk0pKgzNXwTCI+1F1P5ofJi8LFNISns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XXowWt4ziL/56y/Y94hdTEZbLLr97gz3vPYecgnU+2OLdzbRXNjVt79AFC23MY5tr
	 oTJY4tAIVUSxYNA273DbifXhFQN5PmgBpv0TsVokaKinyjXefw20slNXoVFuzwiHLS
	 F6ZYPX0Cqw7UBvBS+5fOLuIQVKaCqWPhvvdVx7EVb3HJaQ4wuHkk+WrSgfva1xzANX
	 bHdWs2TB7EVaJ4pr9L0v2ILwyY9eS00lIEN1Y7x7dNWVkC56JD9zi1iKd9QoWfdwqu
	 /X8/fzcyQTfJjStJTXhyCnJotJ5LbvBVoTP27bIDNCCQV90j0yhBvB6DJjUfHmgpLx
	 LQAT+4T8xfxRQ==
Date: Wed, 23 Sep 2026 09:57:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <arOMefPN1gxMpyx8@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>

I know everybody is very busy but I'd appreciate if people could take the time
to have a look at this if possible!

I asked an LLM to look at review replies per week in mm (see below), and
clearly 7.3 is an insane cycle, which I understand.

(And dropping the THP M, remarkably, has not resulted in a drop in review
workload for me).

However, I'd also ask people to perhaps 'give a little back' to those who
are doing a lot of review also :) review can be thankless at the best of
times, but having your own work sit there unreviewed for weeks while you
are working so hard to review others' work is a little much.

Thanks!

┌───────────────────┬──────┬──────┬──────┬──────┬──────┬──────┬───────┐
│      person       │ 6.17 │ 6.18 │ 6.19 │ 7.0  │ 7.1  │ 7.2  │  7.3  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ David Hildenbrand │ 84.8 │ 70.8 │ 44.5 │ 74.7 │ 80.3 │ 85.7 │ 107.0 │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Lorenzo Stoakes   │ 50.9 │ 25.1 │ 16.0 │ 45.4 │ 35.2 │ 40.1 │ 52.1  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Mike Rapoport     │ 11.8 │ 17.7 │ 12.8 │ 17.8 │ 30.1 │ 21.0 │ 24.1  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Zi Yan            │ 17.3 │ 12.8 │ 15.0 │ 14.4 │ 10.2 │ 24.0 │ 28.7  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Vlastimil Babka   │ 15.6 │ 19.3 │ 12.5 │ 23.8 │ 17.8 │ 25.2 │ 14.7  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ SeongJae Park     │ 16.2 │ 7.7  │ 13.3 │ 23.4 │ 22.8 │ 17.0 │ 19.2  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Shakeel Butt      │ 13.0 │ 5.3  │ 11.7 │ 9.6  │ 7.2  │ 8.2  │ 14.5  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Harry Yoo         │ 10.6 │ 15.0 │ 11.7 │ 15.0 │ 10.9 │ 11.3 │ 6.8   │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Baolin Wang       │ 6.0  │ 3.0  │ 4.1  │ 7.1  │ 6.7  │ 6.4  │ 17.4  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Kiryl Shutsemau   │ 5.6  │ 3.3  │ 2.2  │ 3.0  │ 0.9  │ 2.9  │ 16.2  │
└───────────────────┴──────┴──────┴──────┴──────┴──────┴──────┴───────┘
