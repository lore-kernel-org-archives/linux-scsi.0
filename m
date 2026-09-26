Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1996A31E85B;
	Sat, 26 Sep 2026 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442891; cv=none; b=ikGqtDyotU4vLW1m0H2ZSA90ZHJD4lX/4QPHjebIl7PvkbNsltWobnO0xDyiheF4kGEEYviUQZNc0Sy9be9HZUD62SgxEM2GyMIJSCjlwL1rkYtI0myf3PkDl4SQkYERH1b7c0SofCRPFC8Ydnxc760/9pLbl1CPRwt1Y8Bd5Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442891; c=relaxed/simple;
	bh=gojmdYDsD3StNnB/hDyqo1gXIHc8O8nZybk73It5oqU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=nAA/WlIzbixDsH7/i+ccnmt0/NrHTEngYwj2+yPDdK2pqxFX41f+CdQ6dgIGCk0WoW+DK/WA/1QXux5IV93FXwqfilQbgWIHjWqi9pLE7dj/5aZrgTYV6Oh/zy3xlxursqdHeGkiOUugMQzB3Ewlbvq+0m8sgX9n5ZM3o7Zws/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=ZVIK9Hxi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mwp84TFY; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="ZVIK9Hxi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mwp84TFY"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id E9CEB13800A4;
	Sat, 26 Sep 2026 13:14:44 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 26 Sep 2026 13:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790442884;
	 x=1790450084; bh=tGTq2YiYGuZgWk5ZY7JZMyWu45IuuL1ykMMcgPEJafg=; b=
	ZVIK9Hxi8OmBYJD8gSQZXTgvlZ4ULwofUd3eHILARMayF90oSThQLlm5pu0l5+wO
	EnQNPrQtmiNIZnGIwOhafr8jMDFrP3Dl7gTfjveAGlyclXfQN3BLKbYH82TnwGGE
	LDHz+61nEQdNJ7Mm5sWNWenepLPKzpbtqHutP61oa4S7+XoKGpYriUTGoU0AgYuQ
	9OTwRwbhibVgycEtR2pOCeqTs4FUfvkkls84aK/T+ibf6XDH5w7vKSNIGM7Ns4Te
	135M6wCurb5eGsyT4wJmj9eSmNADUwntt12lTP3+ewZFA5Y2rk4HTFGRVv8Gm5J4
	FYdUPsr/YYOVOuEmK403CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790442884; x=
	1790450084; bh=tGTq2YiYGuZgWk5ZY7JZMyWu45IuuL1ykMMcgPEJafg=; b=m
	wp84TFYHlBmHy48WpU0OJv+UejeKBnb6WEhb5BMBbjPw/UCY7uqA+43EKIRDaLxu
	G1ME4E65zZTTM83OGQxFYEaX8IjFcTplRfJNXnDCcf7M4LwptgYoomz5Pd8yjegu
	vxxY9CLa8ktV+zIhtoRoAiwaeH8imBZgq5qItAjTqRNlGb0cSk9vAwm0npDwQJxc
	ZBSOWP/LIH26Up0NfHDTJ2s5vjKd+KXmqqu3dQNyzUjNXLWwkQPUdw7wFwNq/2No
	YsWwT9G3+rtA9dRodWihaGIftDwTqZDbktrxc69FY4uf2b4Ufj3bOnrmH4U90eCu
	jkII0jgJplt+Ho3eCclLA==
X-ME-Sender: <xms:ev23aphDb-V-DzcUvq0g2j4uWxVUXz288eL2VWYqofNWUqazGf5cSw>
    <xme:ev23ao0ryaKlcNAnhIKgzAZfizI5zRmS9PD6pqUF6Jaoul6FnnmXFYB6KvX02iUGz
    BZmE3RTt53azeiOlRWmgUZqFjlCoYZMFa8ew0yOEJBlTMonzQebK2g>
X-ME-Proxy-Cause: dmFkZTFhx2cFFtNhkULYuqPvl8gGeJkM2fhMBUUfWVg74H8MxuoOHs6J8LEQB/SWwobSXF
    cN3Bm393pJVl8n+wel7ooQQNi4RqB/GFQKqP4KFWek4N9ELRDdYFOjuVinSGdMSTiVarKs
    4rOSnFGMqI3VdSxqJCmbjwz8JsjadS6g8WVg1FSsOASQL9qnvW06scsM7DdiXuQXSRvbp0
    oc1rMfdDSdXjZDuQ4Flc3WgW80v1q7p36oNIX1c572OX8QvM44FF244YDOCuvYk1zcB+Fz
    OcU5GlcEjMBRQT8ozzGGB17lMhu1hmoOmo2ETYbYqG7qYCuz/Gp8fIl3AA5CvGes553OYH
    zOP0t/bzfIhWaCPZjluKxSSoXuDxxjcXX/Q8DMMxmDbQWJ9Fr5WThqDq2FLaU+SqnaJuCL
    pkYbhniVBzMm7pvuYCl/qtichaoaEjJr59rIk6FGTSg9hy5MSJhlHhPKI2TiyHW60MEHdl
    JWno9EOAuEBSzEKX+LMbGzYracPdYAHxU3uanBYFvpgh22w5H+sisOsx1bppU4jaCs1GSb
    qD7s7IdOD1fMrVJxaXNIjxEhMdeQ0eT9oEzd23eeqQJ6pu7bYb2KG7Sxf3YtlsvQWzwwTb
    DVHLWbQk3RKB8mG01KIcI+VKbYDfnxSRmys1tgvRg1CtY/krP0JQij7af/2Q
X-ME-Proxy: <xmx:f_23asArcTC-7Q3MDdhePBo8lXV8z6QvAKpe9Ibzmll_nWXelxFyFw>
    <xmx:f_23aqWfoDFHKQGVk2R1--3tsFeyYyFnrcejyjSEGK5MWrduS9Wguw>
    <xmx:f_23am5ly-0659jMdrdtd-Lr7Biq-i6-UFjxRj9juHeAU_T69iDw6A>
    <xmx:f_23amDnrd_P6v0UUP--vOzaHh9I4PDmquAxe_V0QS1vx9j31Ee7Dg>
    <xmx:hP23akAE2wZVF6psZ3xKJ1lvcUYpihdEVBPR2JzpRxVK20H4-2HGjT2V>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7CCAA32A0087; Sat, 26 Sep 2026 13:14:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 19:14:14 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet" <corbet@lwn.net>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Paul Moore" <paul@paul-moore.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>,
 "Eduard Zingerman" <eddyz87@gmail.com>,
 "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Nico Pache" <nico.pache@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Doug Gilbert" <dgilbert@interlog.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter" <simona@ffwll.ch>,
 "Helge Deller" <deller@gmx.de>, "Sebastian Reichel" <sre@kernel.org>,
 "John Hubbard" <jhubbard@nvidia.com>, peterx <peterx@redhat.com>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Oleg Nesterov" <oleg@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>,
 "Harry Yoo" <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Dave Airlie" <airlied@gmail.com>, "Will Deacon" <will@kernel.org>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Janosch Frank" <frankja@linux.ibm.com>,
 "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Chris Li" <chrisl@kernel.org>,
 "Kairui Song" <kasong@tencent.com>,
 "Kemeng Shi" <shikemeng@huaweicloud.com>,
 "Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>,
 "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>,
 "Michal Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>,
 "Xu Xin" <xu.xin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, linux-sound@vger.kernel.org,
 bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, "Takashi Iwai" <tiwai@suse.de>,
 "Emil Tsalapatis" <emil@etsalapatis.com>
Message-Id: <4a3a089c-3ade-494d-8f83-f9cb710e9ad1@app.fastmail.com>
In-Reply-To: <arfGmNiEngnO3JKm@gremlin>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
 <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
 <arfGmNiEngnO3JKm@gremlin>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 26, 2026, at 15:22, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 26, 2026 at 03:06:33PM +0200, Arnd Bergmann wrote:
>>
>> It's a Kconfig setting upstream, but the way I'm doing it is to have
>> patch that calculates a sensible default based on other options that
>> is a little smaller than the default (currently 2048 bytes) on x86-64
>> to catch more cases where something sticks out.
>
> So this is an early warning more or less :)

Yes, a surprising number of these just point to stupid mistakes
where the developer had no they were adding a large object to
the stack. This instance here is unfortunately not an obvious
case.

>> There are many ways the call chain can go of course, but the actual
>> stack overflows do tend to follow this pattern where you are at a
>> function with high stack usage and call kmalloc() during low memory
>> condition and that ends up waiting for a block I/O down the line.
>> (you normally don't go through swap and nfs, I was just looking
>> for the worst case I could easily see in the code)
>
> You certainly found quite the example haha.

I have previously toyed around with using VMALLOC_STACK on a reduced
stack size and syzcaller, so I knew roughly where the worst offenders
lie, but the list was from looking through the code just today.

>> > If I can do it as a follow-up that'd be ideal!
>>
>> What I was hoping for is that as you are already deep into the
>> exact code that caused the warning and you can already see something
>> in there that may help.
>>
>> I don't think it's urgent, I just don't want it to be forgotten.
>
> It won't be, it's now on my TODO and I see it as a relatively high priority
> thing to follow up with.
>
> Will likely send a patch for it next cycle (this is about the worst cycle I've
> seen workload-size for mm so I don't really want to send anything more this time
> around).

Sounds good, I'll keep the local hack to mark functions as noinline for the
moment then. Thanks,

      Arnd
