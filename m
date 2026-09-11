Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85273CF1F0;
	Fri, 11 Sep 2026 10:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789121807; cv=none; b=iB1NN+Xle04CzXtYZV7Yrz51R90PYU9RFFF5qUBsYrwHcwZWPnKStc3sHfnBk+oewk2JJAXoOSsj7tiwExazvUs0D0gdOkJL3C3HuCFB6c/Bf+j47tqMX8OpNavVIRYw1EtAzqNABeLVtIPTXm9ZJaJaGvs+5+coISO+tBa7WjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789121807; c=relaxed/simple;
	bh=vTsPXaHi8RAzBaWbL447Y7Wml4ZSeJ0BE4+oGF83XiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfULfKtT0eEwotwelT327Y+zHp8Xx8rUQ9pIKLl4J/4EQygHBBSYlbgOrVnN363ru4tOxiaB1w0T8fcxepr8zf/Fb738AONethY+9NM/OO4aWTW+C3iPQbXMdJ/kgEJ6/b3jJMMAcyKtnlYX8v3sIEarQHXPAHFKmZIVMBV0gQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAW41siy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAW41siy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B0E1F000FF;
	Fri, 11 Sep 2026 10:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789121805;
	bh=giLIDOVuGk3wU4sINvGbjDY5Co7tru0+JFiE0K9FPLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bAW41siy0jHTB1qfl3qn4gdNLwygOP92sxwRZ5j93bg2aVlvwhPZHWNQXCkbUnxC6
	 9zk3b5mbI7ab2hw7oNcaGXVKHnNx1qFzqMm5NsCPo7iMQTWRRa4ga4/FYZMgemnHMR
	 LUWR9RDzd1jBIAPZg7P5yYAnVdcGzlswz7uYblSZrI8mgcWzefXPuZrclq/aRa18mg
	 UXHtcfHYeWzL2TMktPNfUxYpL9byrk5pz2SSOJ+Hi6IFxR8hMDvGKPZB2iRfKGLL8X
	 ZmrHB9kpMAfbsIpyQlYJu0jR9aIkQQcmQfumaGM+wf3Q1dTyf8WnZzhQjhpzxy2VYs
	 gbIALJ3tDM5qQ==
Date: Fri, 11 Sep 2026 11:16:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Message-ID: <aqPUqU3eZeFrykj3@gremlin>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
 <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com>

On Thu, Sep 10, 2026 at 02:11:18PM -0400, Stephen Smalley wrote:
> On Tue, Sep 8, 2026 at 4:07 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > The policy file has no write method and is exposed read-only (S_IRUGO in
> > selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> > CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> > kernfs does.
> >
> > The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> > clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> > check in sel_mmap_policy() cannot be reached. Remove it.
> >
> > This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that is
> > neither a PFN map nor a mixed map, ahead of the core enforcing that only
> > such mappings may do so.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> We should likely do something similar for the other sel_open_*() and
> sel_mmap_*() functions too.
> In particular, truncation of the status file can bring down systemd
> since it is mapped by libselinux.

Yeah I think there's definitely more that can be done there.

Though I think obviously that kind of stuff is better as a follow up as this
patch is focused on eliminating a case where VMA_MAYWRITE_BIT is cleared
incorrectly.

>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

Thanks!
>
> > ---
> >  security/selinux/selinuxfs.c | 11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> >
> > diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> > index c7d91476971c..545a6f89f9e7 100644
> > --- a/security/selinux/selinuxfs.c
> > +++ b/security/selinux/selinuxfs.c
> > @@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
> >         struct policy_load_memory *plm = NULL;
> >         int rc;
> >
> > +       if (filp->f_mode & FMODE_WRITE)
> > +               return -EACCES;
> > +
> >         rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
> >                           SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
> >         if (rc)
> > @@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_policy_ops = {
> >
> >  static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
> >  {
> > -       if (vma->vm_flags & VM_SHARED) {
> > -               /* do not allow mprotect to make mapping writable */
> > -               vm_flags_clear(vma, VM_MAYWRITE);
> > -
> > -               if (vma->vm_flags & VM_WRITE)
> > -                       return -EACCES;
> > -       }
> > -
> >         vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> >         vma->vm_ops = &sel_mmap_policy_ops;
> >
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo
