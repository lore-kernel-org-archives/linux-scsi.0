Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8FC57983E
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 15:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176936; cv=pass; b=ZoWnCL3FjR3ll0kAReXSIoasNDO0+WEkq1HIadcIvXCgiHJQmfiuqcLYOnedNk1kza3/Ypk5XlNrN8zCJsGiCj/x1vhnGz5bIilySI7BrA5QScrzjYSIiGuPLglWy7TTUpV/H2j+aFicGkgWVfCDUt2oRBN+wzaaJE8+/xBwLHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176936; c=relaxed/simple;
	bh=Amk0xDDiuLrZOX0meRHdnJJ0c8aLaK2hhT8r+pRxJMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eOJ7WCfikPnxKn0P9x/hKp40hXm5+cmVmH+aHYqdAJrt+ou2uMOvZw8UFGybfhlgASBbZErkE/9Tux/h3zX08TT4c9Ul/i2hPdsy0u6Hp3BcEfLmUUbNnWANlYPdp+jFkyRW9X2TVA42OLdT4szhohNCi9FW3dsIGUp9qpAlVoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FVFPhjYX; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FVFPhjYX"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53113d72966so281831cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 08:22:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790176931; cv=none;
        d=google.com; s=arc-20260327;
        b=cbnhmrKcgmPuu5YztZN0Pd7HjV13rPtZ4LzwrCKVb0inbvH9HIQIY10BEC8w14Pr4T
         1Bg8umET9/zKVkdcDDANKRkmprOESrhwepQDPKUCW0YgoZGCheo1yRSmLUFg36oH+/ov
         NLWbogUTuuxNjrlsil45hTQ61q7ruZrvRDO0/ZA35Uae7Afs00gF4tXtV4EkVJ9evPoB
         48UwElNKf8ShB/zyxlfn5Bqx6V/Y46Ep1X/q+++5XZ3RFm85GAmjQ6Tc2igxPihDBIQW
         upSbrAhQuN0RG7RkdYbjiefWCdXNZF3OuM0vAEaGE++GUF2r3/XkorGNUusw2/WshWuR
         KB6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=215xHvrjA8k8F2o69zQ3x9mbVUyDBcCR5N4QBUkVljc=;
        fh=Hjj6IpGboB88atvJh3YOk47Zxom8nzBIZR7WgJt47uM=;
        b=Nwhj4qGf8ma+W3OROPlAoHe6xFybBUwKPyEbC2WkM16vMlqKP/s5RhPTHYn01rwhYc
         LScTT2U2HM9fgHy14D8AdmRAk93WUV+Tif0VaaZLZVkY0aIB5aJARAuqBagWrlyXRzav
         3DtqM/uFWZgyxtBFwrQ6IuA97rXdS6TFSytRxvLDM9J+TUTqW7Ls9GA+zklSSoM/VDmx
         x9YAEZhX9Xmuen+kdZ34cfO+5nuskjqgEPfKK3z5g05XlyniKO+/rzjHRNeohKyri9Qh
         JcVFGSeZo0a3HxdLsS5Bq2ETHFAAPQHN/wVV+0Yh1N90Njoe7tEOyF1kxvafsOm2EirF
         9H8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790176931; x=1790781731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=215xHvrjA8k8F2o69zQ3x9mbVUyDBcCR5N4QBUkVljc=;
        b=FVFPhjYX8LD6INsSglITHovKANCQHzky6BW5niWyjz8O89MDVMbgnTZkRwYDbSgRGD
         z5bwv48sa/+Yh8mLlOGTyhktgExNaP84Bc2Kzh533cBzXPIHQMXVVNxntjZAJdPYjylw
         p5An4gIJSo41/hv9U0M8dEZuzXbHqidzm57JNkHtyCDint0dLhDub8wI6OgX2sNJweMC
         0DUDwFwUnkjF3OBWzRQHA6XvwFE9AlugrhOG5UUgwgnjxwR0t2obcdmUJrLWDoEeRSLe
         SLbSo0qUJCEkBmQql558QkesN2UYLQnEs5yHdOwDUD+FZdP6BVaJ/h6aZDho8EbGFgEl
         IiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790176931; x=1790781731;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=215xHvrjA8k8F2o69zQ3x9mbVUyDBcCR5N4QBUkVljc=;
        b=ZCXFio4sq+MqqNJ6BIHkQSLb1tlHLfiORYNeXGMARA6WJ2srI1HP7A7nxwPVox0o0x
         58LpKLi4CyP1OT5FsFD8N+DnJw2gz7rWRZ4C1OO3bmw1Kjj8NKmwTlpx/s+VyFcPxxm0
         dB2YSKF2WFU5Nj440Uc8pTUl4uL4VFTWU+t10hDH/EPp6+pwINr+QcTkYM1WeXZo0jN3
         XDyR2K9wWTrKaUxqH3G8rZmRdPdAPJYl8q2/gjUgvMztB7FAjax1PspP2wbxiXPlZYgA
         6zltckyAKJR+p8a3Emq3pBnapPU27NSlCY/xDYnzYl99TR17V0QZjfG/ZsySEp5KDaB5
         vOxA==
X-Forwarded-Encrypted: i=1; AKwUvByhujnVevyAVtx4UEkd673ytti0bClnmDRLtGad7yeLLd6ObR9CIWB8XtiRWNTXnBt7coNFGoyzMasI@vger.kernel.org
X-Gm-Message-State: AFuF++kusBhbgXgUtawm1SHU13VVrt7yS2O9JMQlwL2z18zg6xbUXd5J
	TfXbYY3NV/TPqs9fkK3c/BSTBEQlM7strEHy03M4DKLe8z1LTBQYF1FLpzcupXMUIPtUgjaDKix
	ehYyFd1zNOpNR4TjoWswRiCOvUAICw72XpOjZlMCs
X-Gm-Gg: AYBFou0hp9ZXXMd4lm5765Ejd9hw4/3SWfP7XrN6/C6iA0Q60PQZs4K2f5FqfN/FE2Z
	AjzfRHzThiVc+AlyR6lpL3M0fszSaaNKR7T1Xaxjm5e7Vnn5eMuPfx3bg1z0II+FsWutZkhz65h
	vCtcACYGd27dP5ZN2uSEiyeVe0Z0Aq30ReH/Mr/A5S66b+rx6eRRcSemVOBR3MX0kuS/k4Qw6pV
	bikiW/SSVuE55FZIIFC3JdFfbRnHoHELGv8aiLnoZs7+QrHQhbTqDoprWd4/g84Mssg0B6azqfE
	cKyZ4JeWSPDNLEFSlDg92qk2ZK1jjVdOUcmjrOM0ZqNzafWjjAaZ01kDqMhD2biGt561sy0G7Ql
	0655f8KACkQ==
X-Received: by 2002:ac8:5f4b:0:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-532f8b3706amr797061cf.0.1790176930008; Wed, 23 Sep 2026
 08:22:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-1-4583d8a23bca@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Sep 2026 08:21:58 -0700
X-Gm-Features: AclHuK_Jr66nWhopiYzgP8yybrhj32Etg8U9Ma2NnEVU0JzktEFxq__eunHeX-k
Message-ID: <CAJuCfpFe+pLusPy-xWYHp2rTP1becBb2nhX16xXd+hKD5Q+Z3g@mail.gmail.com>
Subject: Re: [PATCH v3 01/40] mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
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
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 9:23=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
>
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
>
> The mmap() operation which ultimately invokes __mmap_region() is guarante=
ed
> to drop the refcount for the original file the mapping was made under, bu=
t
> this is not true for the replaced file.
>
> This has been addressed so far by tracking map->file_doesnt_need_get, whi=
ch
> is rather poorly named and unfortunately fails to correctly track whether
> or not an additional put were needed in a number of cases.
>
> Make life easier by removing this flag, and instead drop the reference fo=
r
> both mmap_prepare and the deprecated mmap callback in a new function
> put_map().
>
> Track whether this needs to be done by aligning mmap_state with
> vm_area_desc and store the original file in the map->file field, keeping
> the updated file in map->vm_file.
>
> In order to have the same behaviour for both types of hooks, only drop th=
e
> reference __mmap_new_file_vma() itself took in its error path, deferring
> the replaced file's reference to put_map().
>
> To make this work correctly, map->vm_file has to be updated before any
> error handling, so update __mmap_new_file_vma() and call_mmap_prepare() t=
o
> set this field first.
>
> Also when mmap_prepare() changes the file and is then merged, the referen=
ce
> count also must be decremented, so update the logic to call put_map() in
> this case too.
>
> Also update __compat_vma_mmap() to manually perform this step for stacked
> file systems using the compatibility layer, and update
> compat_set_vma_from_desc() to replace vma_set_file() with a correct
> refcount/file update.
>
> No in-tree driver is impacted by the incorrect implementation of this
> currently (no driver that does this is mergeable for one), so this does n=
ot
> need to be a fix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h |  1 +
>  mm/util.c     |  5 +++-
>  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------=
------
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
> @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
>
>         /* Perform any preparatory tasks for mmap action. */
>         err =3D mmap_action_prepare(desc);
> -       if (err)
> +       if (err) {
> +               if (desc->vm_file !=3D vma->vm_file)
> +                       fput(desc->vm_file);
>                 return err;
> +       }
>         /* Update the VMA from the descriptor. */
>         compat_set_vma_from_desc(vma, desc);
>         /* Complete any specified mmap actions. */
> diff --git a/mm/vma.c b/mm/vma.c
> index 55917d097933..fa784f069da4 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -24,7 +24,8 @@ struct mmap_state {
>                 vm_flags_t vm_flags;
>                 vma_flags_t vma_flags;
>         };
> -       struct file *file;
> +       struct file *file;      /* mmap()-specified file. */
> +       struct file *vm_file;   /* May be updated by mmap_prepare. */

Overall I like the change but I think you could avoid extra churn by
keeping the name of `file` as is and add `struct file *orig_file`
instead as:

+       struct file *orig_file;   /* mmap()-specified original file. */
-       struct file *file;
+       struct file *file;      /* May be updated by mmap_prepare. */

Then many uses of map->file would stay unchanged.

>         pgprot_t page_prot;
>
>         /* User-defined fields, perhaps updated by .mmap_prepare(). */
> @@ -43,8 +44,6 @@ struct mmap_state {
>
>         /* Determine if we can check KSM flags early in mmap() logic. */
>         bool check_ksm_early :1;
> -       /* If .mmap_prepare changed the file, we don't need to pin. */
> -       bool file_doesnt_need_get :1;
>  };
>
>  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vm=
a_flags_, file_) \
> @@ -58,6 +57,7 @@ struct mmap_state {
>                 .pglen =3D PHYS_PFN(len_),                               =
 \
>                 .vma_flags =3D vma_flags_,                               =
 \
>                 .file =3D file_,                                         =
 \
> +               .vm_file =3D file_,                                      =
 \
>                 .page_prot =3D vma_flags_to_page_prot(vma_flags_),       =
 \
>         }
>
> @@ -70,7 +70,7 @@ struct mmap_state {
>                 .vma_flags =3D (map_)->vma_flags,                        =
 \
>                 .pgoff =3D (map_)->pgoff,                                =
 \
>                 .anon_pgoff =3D (map_)->anon_pgoff,                      =
 \
> -               .file =3D (map_)->file,                                  =
 \
> +               .file =3D (map_)->vm_file,                               =
 \
>                 .prev =3D (map_)->prev,                                  =
 \
>                 .middle =3D vma_,                                        =
 \
>                 .next =3D (vma_) ? NULL : (map_)->next,                  =
 \
> @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
>   */
>  static bool accountable_mapping(struct mmap_state *map)
>  {
> -       const struct file *file =3D map->file;
> +       const struct file *file =3D map->vm_file;
>
>         /*
>          * hugetlb has its own accounting separate from the core VM
> @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap=
_struct *vms,
>
>  static void update_ksm_flags(struct mmap_state *map)
>  {
> -       map->vma_flags =3D ksm_vma_flags(map->mm, map->file, map->vma_fla=
gs);
> +       map->vma_flags =3D ksm_vma_flags(map->mm, map->vm_file, map->vma_=
flags);
>  }
>
>  static void set_desc_from_map(struct vm_area_desc *desc,
> @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *=
desc,
>         desc->end =3D map->end;
>
>         desc->pgoff =3D map->pgoff;
> -       desc->vm_file =3D map->file;
> +       desc->vm_file =3D map->vm_file;
>         desc->vma_flags =3D map->vma_flags;
>         desc->page_prot =3D map->page_prot;
>  }
> @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, st=
ruct vm_area_desc *desc,
>         return 0;
>  }
>
> +static bool map_same_file(struct mmap_state *map)
> +{
> +       return map->vm_file =3D=3D map->file;
> +}
>
>  static int __mmap_new_file_vma(struct mmap_state *map,
>                                struct vm_area_struct *vma)
> @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state =
*map,
>         struct vma_iterator *vmi =3D map->vmi;
>         int error;
>
> -       vma->vm_file =3D map->file;
> -       if (!map->file_doesnt_need_get)
> -               get_file(map->file);
> +       vma->vm_file =3D map->vm_file;
> +       if (map_same_file(map))
> +               get_file(map->vm_file);
>
> -       if (!map->file->f_op->mmap)
> +       if (!map->vm_file->f_op->mmap)
>                 return 0;
>
>         error =3D mmap_file(vma->vm_file, vma);
> +       map->vm_file =3D vma->vm_file;
> +
>         if (error) {
>                 UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>                             map->prev, map->next);
> -               fput(vma->vm_file);
> -               vma->vm_file =3D NULL;
> +               if (map_same_file(map))
> +                       fput(map->vm_file);
>
> +               vma->vm_file =3D NULL;
>                 vma_iter_set(vmi, vma->vm_end);
>                 /* Undo any partial mapping done by a device driver. */
>                 unmap_region(&unmap);
> @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>                         !vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT=
) &&
>                         vma_test(vma, VMA_MAYWRITE_BIT));
>
> -       map->file =3D vma->vm_file;
>         map->vma_flags =3D vma->flags;
>
>         return 0;
> @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>
>  static void map_set_anon(struct mmap_state *map)
>  {
> -       map->file =3D NULL;
> +       map->vm_file =3D NULL;
>         map->vm_ops =3D NULL;
>         map->pgoff =3D map->addr >> PAGE_SHIFT;
>  }
> @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state =
*map)
>
>  static bool map_is_anon(const struct mmap_state *map)
>  {
> -       return map_is_private(map) && !map->file;
> +       return map_is_private(map) && !map->vm_file;
>  }
>
>  /*
> @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, s=
truct vm_area_struct **vmap,
>         }
>
>         /* Invoke callbacks. */
> -       if (map->file)
> +       if (map->vm_file)
>                 error =3D __mmap_new_file_vma(map, vma);
>         else if (!is_anon)
>                 error =3D shmem_zero_setup(vma);
> @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *m=
ap,
>         int err;
>
>         /* Invoke the hook. */
> -       err =3D vfs_mmap_prepare(map->file, desc);
> +       err =3D vfs_mmap_prepare(map->vm_file, desc);
>         if (err)
>                 return err;
>
> -       /* It's invalid for mmap_preprare hooks to clear vm_ops. */
> +       /* Update first so file refcount tracked correctly. */
> +       if (desc->vm_file !=3D map->vm_file)
> +               map->vm_file =3D desc->vm_file;
> +
> +       /* It's invalid for mmap_prepare hooks to clear vm_ops. */
>         if (!desc->vm_ops)
>                 return -EINVAL;
>
> @@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *ma=
p,
>
>         /* Update fields permitted to be changed. */
>         map->pgoff =3D desc->pgoff;
> -       if (desc->vm_file !=3D map->file) {
> -               map->file_doesnt_need_get =3D true;
> -               map->file =3D desc->vm_file;
> -       }
>         map->vma_flags =3D desc->vma_flags;
>         map->page_prot =3D desc->page_prot;
>         /* User-defined fields. */
> @@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map=
,
>          * anonymous mappings. Rather than allowing these mappings to be =
odd
>          * outliers, simply make them truly anonymous.
>          */
> -       if (map_is_private(map) && file_is_dev_zero(map->file))
> +       if (map_is_private(map) && file_is_dev_zero(map->vm_file))
>                 map_set_anon(map);
>
>         return 0;
> @@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_a=
rea_struct *vma,
>   */
>  static bool can_set_ksm_flags_early(struct mmap_state *map)
>  {
> -       struct file *file =3D map->file;
> +       struct file *file =3D map->vm_file;
>
>         /* Anonymous mappings have no driver which can change them. */
>         if (!file)
> @@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_st=
ate *map)
>         return false;
>  }
>
> +static void put_map(struct mmap_state *map)

nit: maybe put_map_file() to be more specific?

> +{
> +       /*
> +        * An error occurred or the VMA was merged.

It's a bit weird that the function explains when it is being used.
Having an appropriate comment at the call site seems better to me.

> +        *
> +        * If the file was changed by the driver (which is required to in=
crement
> +        * the replacement file's reference count), drop its reference co=
unt.
> +        *
> +        * On error, the caller always drops the original file regardless=
.
> +        */
> +       if (map->vm_file && !map_same_file(map))
> +               fput(map->vm_file);
> +}
> +
>  static unsigned long __mmap_region(struct file *file, unsigned long addr=
,
>                 unsigned long len, vma_flags_t vma_flags,
>                 unsigned long pgoff, struct list_head *uf)
> @@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>
>         __mmap_complete(&map, vma);
>
> -       if (have_mmap_prepare && allocated_new) {
> +       if (!allocated_new) {
> +               /* Merged, so need to drop refcount. */
> +               put_map(&map);
> +       } else if (have_mmap_prepare) {
>                 error =3D mmap_action_complete(vma, &desc.action,
>                                              /*is_compat=3D*/false);
>                 if (error)
> @@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>         if (map.charged)
>                 vm_unacct_memory(map.charged);
>  abort_munmap:
> -       /*
> -        * This indicates that .mmap_prepare has set a new file, differin=
g from
> -        * desc->vm_file. But since we're aborting the operation, only th=
e
> -        * original file will be cleaned up. Ensure we clean up both.
> -        */
> -       if (map.file_doesnt_need_get)
> -               fput(map.file);
> +       put_map(&map);
>         vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
>         return error;
>  }
> diff --git a/mm/vma.h b/mm/vma.h
> index e97bd2dfa786..f15faa83f3d6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct v=
m_area_struct *vma,
>
>         /* Mutable fields. Populated with initial state. */
>         vma_set_pgoff(vma, desc->pgoff);
> -       if (desc->vm_file !=3D vma->vm_file)
> -               vma_set_file(vma, desc->vm_file);
> +       if (desc->vm_file !=3D vma->vm_file) {
> +               fput(vma->vm_file);
> +               vma->vm_file =3D desc->vm_file;
> +       }
>         vma->flags =3D desc->vma_flags;
>         vma->vm_page_prot =3D desc->page_prot;
>
>
> --
> 2.55.0
>
