Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5F57268E
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063896; cv=pass; b=O6ez3X565TvrmlAsprOmX5uh24yjN+5WjZXeejOMFufHIkY7VQZWXPurb1EWbT7nyRqvo4SAd7yqVPiWjb6fzb11sBYgFvihpDSBnkLHxCFMFEHMQGwspuyOZxeiWWdLbVQgUsA8dewFi6kAiLATDwS4Xk0SF1G4yrXkJPgTrEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063896; c=relaxed/simple;
	bh=NT0Z/LF1SMhtkavx81DR2GGYYK6aB7iX5ZVgmCMPgvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fPYHXyoGzvbP6oHkLxi8WyW6ZVeh9xcnTX76LfGHrV0z6nuVDxZG2oYgFxPDajRa+oaSacCQ28H32DFvXkldmH2Tke51FV9iihfxfcCgpbQ5GIszE5y18wKsPDMF9t8SF6v1SmJd86FLmAfA2iIj039LBjAX+BN9PULXdi1yyY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKybIG7v; arc=pass smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKybIG7v"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-466ccde2b71so24182fac.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 11:11:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789063890; cv=none;
        d=google.com; s=arc-20260327;
        b=IzqEW+F7GtZiOjiRXkVrAIy3fTMVXNip9O6ScUIakUEDP+xPzXb4ccHl+h2DQSP0GU
         cUzHK28SoNxt0ejlb+ejnxKx8ohe0tcMAR02nOKvbv1y28nfFstpHRDX6y3t9cbFBb6m
         UlmhhbdVTi/9UvDsfms1RNMfqxhzdqLwNzpq1nm3YwBGQNEwKR52xemrJzJ4ice3XPxf
         AcNhAC5erxguyflMMBtL++jHGrXwjP+F4nI9TZbiINTfjCtYTSCSL4XFT9yf0/8zZpD9
         Cgy5EKUafcquE6/T1CYTcEoITJ3UbPC8dcxBNHofHPpZx0j9sWiOmoT+gNhWbJyn72bI
         NJsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        fh=S6aHh8VNovZ1JJKsyh6VJC4k8XSAfq9LCOagspY6I2I=;
        b=gHmHRPqJgSt8tOzrddVcfwn0kHotKCODRuNdEY2+h1XToapzdHjbWQXySv56qFNtMe
         DLC8dfXjDJunDJAufxgDgdqHYS2VIUax1v/4uwqPE88c2tFwjYKHT0RTkx3chs6ioiy2
         828uk6tX3Ur1MzTdlyWOOMls7WZekkbR6i294fcUMiAHX+jlG+I/rPKe9ETaTsULZQy7
         l+oYEqi0tWlSZgWzOKeb7TPc+lLibrk+CYZF8VqpOkhHKcg7ez5kohxtC2L9FJVxzZUO
         Lz5yntO9oCbuOmUNDamewgDCZsHDtVPzv3Du93PozWtGKneDgudGeCE+1AVQlpg4nrdZ
         LU2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789063890; x=1789668690; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        b=FKybIG7vbPrID6z1nHaj6kVvqnRQk9kvLUdCSO2+2ma9Rrzv9SNsMhpf6H6ntsMUds
         JkyN3NfvnmjEM6fiuIEbDJ9ubreYKGMr4WB5YW+WP8daIgGmV93h2QhGZncGxUruNTVl
         xb2WebfNbk637VrINs16GyzSfy6Udi4tcRoeH/5/HvD6JJC39vardYEfjksmVtn+eq90
         6nNKA546KE5FFVTONnyAW7NH0ZI0JriDM3YVglc1gMZq/J8BylnjF7IuIBmBXSUxR5sk
         pKWbcKzTldmYVXmq15a181+DQWmWqY+Hy9X3XmqX1apU7j5PpWG+JMXCx6tSMMlVkN1h
         l9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789063890; x=1789668690;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gxuS67QpsgmiVo7SJODgVn7jNGL8PaTVeXELBYXj9Vc=;
        b=Fte2Gmeo8trzsIn8mLmw+cgBvdVJeHjkzjd1R+02/BU1dENEAHrQNOsajwRtm5Aqpc
         5kuL4FZEJTsg2aAWXpcXq4eB2knF1Uce06w+uJuEng/XlUVW1GvRnhBxZGW6nVBWgy2m
         hXzgQy/6ZxAw/OAAQMK/SbUZo95mps/FM7B+jKXt0lnJ4F0jWjF08UFTUKVEUxbVdd4k
         Ci8o6PhpBnaaScz84AMqJdl1CW87TAVt5DwNqPyRqnh/DWmpCWCFJSaCFob/XNV7KU6M
         rosRwupA9oTXIm3HyiT37x5BmjoFbMaztFQm/rDYQ+vNBJtLUf2zFbcLh/tr53WiD3nG
         f3qA==
X-Forwarded-Encrypted: i=1; AKwUvByTnzsqCTJl3iZjDbNihR7KbxfVr8oTWE9o+d1NKBHyWRE2aToanzytSyoOJ3Nu9jM/31hl+aYnsxhh@vger.kernel.org
X-Gm-Message-State: AFuF++kLonvKKf5FXQ0gPT0ntqkqDb16dKqxN8ys0/9+wHlK0sHAgEZH
	sh47DCLz6vUdSjf+7kRygpSEp3apfQkp4QsEnrNDpB1ubyetwoeeNAFqJCq0g1mwFlhDD/QKkKE
	8K9h7gLO4K9sn+Zr780KHDZ/kLO0Xniw=
X-Gm-Gg: AYBFou1ZqJBskr57KPetKdW/K545lYixz2BXifvDiBTnPA6yPGwIExWkywJeFUudbbh
	WoknChvcr5dyCNUP+DkARKXoJE5i0YjltGfqajG4ZLAcZajjJLlveSNuQV87c1x/JWS6M/a3S2V
	YTOmSR0qb26GyUVgLeEknk/THhSfvWiURy8PT4chtkfpPopLIDXuCMThrHpTFWtYgpc5c5F5JyJ
	2niuZozaY2mg4upwp5PoxAgBQPylKbGUFnS/LakVhiiC/kqmjIeiR2o/ramFtH3hZ8ouWfmCEua
	l2JKEZFeGHmBSEy+a/dUla25kLTF2k05CIgRtQNiRFszZLxS9DvIfhE=
X-Received: by 2002:a05:6820:55d3:20b0:6b1:ac4f:f708 with SMTP id
 006d021491bc7-6c0bc1d3ad3mr241038eaf.17.1789063890425; Thu, 10 Sep 2026
 11:11:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 10 Sep 2026 14:11:18 -0400
X-Gm-Features: AcwNN1XLr_yN2lEzELD3PcXDse2cuW9BBHCwsQpnROCV_SxzPvFmiqhSaiK704I
Message-ID: <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com>
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 4:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, a=
s
> kernfs does.
>
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARE=
D
> check in sel_mmap_policy() cannot be reached. Remove it.
>
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

We should likely do something similar for the other sel_open_*() and
sel_mmap_*() functions too.
In particular, truncation of the status file can bring down systemd
since it is mapped by libselinux.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

> ---
>  security/selinux/selinuxfs.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index c7d91476971c..545a6f89f9e7 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -340,6 +340,9 @@ static int sel_open_policy(struct inode *inode, struc=
t file *filp)
>         struct policy_load_memory *plm =3D NULL;
>         int rc;
>
> +       if (filp->f_mode & FMODE_WRITE)
> +               return -EACCES;
> +
>         rc =3D avc_has_perm(current_sid(), SECINITSID_SECURITY,
>                           SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL)=
;
>         if (rc)
> @@ -424,14 +427,6 @@ static const struct vm_operations_struct sel_mmap_po=
licy_ops =3D {
>
>  static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma=
)
>  {
> -       if (vma->vm_flags & VM_SHARED) {
> -               /* do not allow mprotect to make mapping writable */
> -               vm_flags_clear(vma, VM_MAYWRITE);
> -
> -               if (vma->vm_flags & VM_WRITE)
> -                       return -EACCES;
> -       }
> -
>         vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
>         vma->vm_ops =3D &sel_mmap_policy_ops;
>
>
> --
> 2.55.0
>
