Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9979317C220
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 02:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773628388; cv=pass; b=GIvqeHb7k8QM5fh7f7jciV5AeVpS5RQcF89vauiHJRFkSFCCJAX/jyyJB6HNGkOt74q4wMg4xK7qafL0Q36tAA/3xpWLsRfmAf6lGtUWupgeVi8iKGPykWQi6FEWAhCMmMKqdE2HJ5xXnPlwRu2PqWkMLiVlHbqSUPcEoPNniU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773628388; c=relaxed/simple;
	bh=P8upWlYrnSKRURZkcwVOV+h6+eQ68h1jm6EnGvbVBq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VWeBMN0bqY5AOvK2JaUy4FvL1WAM3qgJLXm3OHyZ6h524Mdi6jCDnqB7XbspD+GVsZnYGRvRKLzqPAs6HKAaSW1L4WFr4qij3IY2nBty2ZT5ANmBL6ZDjWS1mBuLU4YOOS4eFMWmVdPbcZXI3SAcKCzbnn22zNkilOAjx9g4bf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Os005hha; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Os005hha"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-509062d829dso709031cf.1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2026 19:33:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773628385; cv=none;
        d=google.com; s=arc-20240605;
        b=YDgdr8WCTpAIamjhHI0+pAcIdMyMw2u4lWFD9lPNVdSBzMVhSTI7pnc7oVNDS6xG5M
         Xn13yj+artWtEq/GYeaHaF3bBFWH0HXvup4vzYwQ3oJbAmFP6/31Vq3lZW7lYbwSzYas
         GUQCxBG3eNzKdg4Ig51NjTxFSCjbRaV/g5kJu0IfqxG24/rBLtyfOPE230KLNkTHwU8M
         qKKTTNrmZgSgfA287ntoJlAHZVsRh+nmT2yArJthizhkKzifJu1jYTA4BlQd785Tiroy
         zjwEZPrgPnJ8hhPny82IX9qxyNG6+1oR/xxCVWlzVK1feVPPL8D286fWDRBeDYP1vQw7
         7kHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        fh=pXUn2e8OaDZ17cdPvq6OKmVqvtePIPZw3F68qhqow0M=;
        b=M9YhIYXCGuMzoaDcVWLyh7FLXtEXbwVOGouGX15NIBAXf5lSZDupEafgy652AT31Hr
         RVumnrAUwQYIpwr419Aj2QueBtzfXPdbelTJgKrgfndiYhxdNMVMIFgtWFvoNBsuLcP0
         0584sTY99ZyVWH98BF4ijd4kpxjSyZYzOrM6zZPSENal6mFcZgHYak6bHOgrCFj1Qd6+
         0/m36NCi69AGEZh119rZwpabd7nFLPbgBsvOWfNByWqPT3ZAbN+qhJeAXQdX8RS8oKB7
         kxqARzrSTF9T/9aOiJjivD/6lRdYAzAMMgQjDH7Js9/xbNZeDhKecuTSY2Rl1GQm6+R+
         5l6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773628385; x=1774233185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        b=Os005hha9utJ0zhLJOYe43DqwRJu1UsmQb6s+HI6U/vIkdMMHKNfni2DnM3UjY2ppG
         Pgldse+NU/KSqsNIKnhLsbu3tV+y5WOf7u38Ae1jXCGJ+TALOgC7DlZBap+ebz4BPH5E
         nRNEReY023lXBY4rnzTVP/LQogEO2pekM5ob8tnZjzH8wkHt+SD0VxbFEmVw/IXm5ykT
         zenhaSk0a2HdP0Y9lApDdeu+NjIkaHvZvyqrN9+GDogwYjuU+8lnmWqykOgeBlgiP6JA
         /7T3vubRR+T2OKrdyYplaKBWP4WvlYGo8Iw+KD28NlBJmyFbtK2bzcP1n+j5ThCSE+rA
         UXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773628385; x=1774233185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        b=c4Kla5JnafgOtCiji/gC1eySueoQPUaHaNXv0zzXoRXrUvrnX+H9FbaPz7x43ltBhE
         6yOIsg0HDCJ+v6rToLAZXLQ3g8LDJ35jwmxfq1PUcZJUpf39xCUJ0+HtQqPx3XZfgq70
         XG1rTR1OijIBc1yvf8Y9pmuCG6JtJyiqDCZ+ZiKi+Ft4rlbby0nsMPAdNyIyPVdwdeG2
         3iwcWKOPRxR26hj2fkeaKAJaMLj5T7iIVFOO7XPDCgaPBu/OgRIWZ6UP5DZ+YGZlXWCS
         pT8d4vynolU5oEYBEs0EdwkhiFZgTtgjaMer3ia9svS8tSMEiq5cFKf1gF+aUXccILGd
         LIdA==
X-Forwarded-Encrypted: i=1; AJvYcCV8b2FELjoJTu52P35REXG0thiCCz5cCfRShIQyS8b0qa8ISl8MIeR23DTopeyS209orN/H7k94NfmQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwPKY8IDehEMR4whRdXKAB014iTgBkfT/YaZB5EBxXV7+eEF26R
	NL97DU3RscqU7OosC8nZpDEodxWRCAU6UyxePDORfxdpoEhF/MwBRjQ5yQiCsRv+NrYMEXzXcnd
	0yzsO9tt2BTQF0G+3kwTGY6ZOtFdv8MZb4rdUqV2W
X-Gm-Gg: ATEYQzy3PcL10WvJknmNWfxJ0PgQRg/bdaYmN/ASQD21qYGdMcJc5RQiFxlJAu/7mrG
	kw9b6VnJCOeoHJs9UymFb6e0IJADf2o3Yk0sQ93FcMcoJN4aZ0+nk/Lq5f8Gti7DL8uC0427g+r
	XiZZC/cW+vlHDQI3lqu/GQnlWAH7D3zzhtTGLqgnWt95Hq+Wa2p0MXAL+2g3nGVbBdPDmoegSBA
	CvbnIl9SFRPfEEUqGHhxhF0sPc0UvP+cG/Ll5tRMi145qZl6dLmE/cKOIkPJ+PNr/e2eW8QJ1d1
	U4EULQ==
X-Received: by 2002:a05:622a:60c:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-5096a92ebdbmr823271cf.1.1773628384887; Sun, 15 Mar 2026
 19:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
 <20260313110745.2573005-1-usama.arif@linux.dev> <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
In-Reply-To: <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 19:32:54 -0700
X-Gm-Features: AaiRm52_478_pqzpMaMH6nJQtQvcaF-xKuK5uDWZ-u00xGMYRYKMJPl6M-Q1q5E
Message-ID: <CAJuCfpFio6n-O-1NkPXrymV0o3UqvHYS8ZOyQtt=JXnZ5dTGhQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] fs: afs: correctly drop reference count on mapping failure
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 5:00=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 13, 2026 at 04:07:43AM -0700, Usama Arif wrote:
> > On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kern=
el.org> wrote:
> >
> > > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() use=
rs to
> > > .mmap_prepare()") updated AFS to use the mmap_prepare callback in fav=
our of
> > > the deprecated mmap callback.
> > >
> > > However, it did not account for the fact that mmap_prepare can fail t=
o map
> > > due to an out of memory error, and thus should not be incrementing a
> > > reference count on mmap_prepare.

This is a bit confusing. I see the current implementation does
afs_add_open_mmap() and then if generic_file_mmap_prepare() fails it
does afs_drop_open_mmap(), therefore refcounting seems to be balanced.
Is there really a problem?

> > >
> > > With the newly added vm_ops->mapped callback available, we can simply=
 defer
> > > this operation to that callback which is only invoked once the mappin=
g is
> > > successfully in place (but not yet visible to userspace as the mmap a=
nd VMA
> > > write locks are held).
> > >
> > > Therefore add afs_mapped() to implement this callback for AFS.
> > >
> > > In practice the mapping allocations are 'too small to fail' so this i=
s
> > > something that realistically should never happen in practice (or woul=
d do
> > > so in a case where the process is about to die anyway), but we should=
 still
> > > handle this.

nit: I would drop the above paragraph. If it's impossible why are you
handling it? If it's unlikely, then handling it is even more
important.

> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  fs/afs/file.c | 20 ++++++++++++++++----
> > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/afs/file.c b/fs/afs/file.c
> > > index f609366fd2ac..69ef86f5e274 100644
> > > --- a/fs/afs/file.c
> > > +++ b/fs/afs/file.c
> > > @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in=
, loff_t *ppos,
> > >  static void afs_vm_open(struct vm_area_struct *area);
> > >  static void afs_vm_close(struct vm_area_struct *area);
> > >  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t sta=
rt_pgoff, pgoff_t end_pgoff);
> > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_=
t pgoff,
> > > +                 const struct file *file, void **vm_private_data);
> > >
> > >  const struct file_operations afs_file_operations =3D {
> > >     .open           =3D afs_open,
> > > @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops=
 =3D {
> > >  };
> > >
> > >  static const struct vm_operations_struct afs_vm_ops =3D {
> > > +   .mapped         =3D afs_mapped,
> > >     .open           =3D afs_vm_open,
> > >     .close          =3D afs_vm_close,
> > >     .fault          =3D filemap_fault,
> > > @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area=
_desc *desc)
> > >     afs_add_open_mmap(vnode);
> >
> > Is the above afs_add_open_mmap an additional one, which could cause a r=
eference
> > leak? Does the above one need to be removed and only the one in afs_map=
ped()
> > needs to be kept?
>
> Ah yeah good spot, will fix thanks!
>
> >
> > >
> > >     ret =3D generic_file_mmap_prepare(desc);
> > > -   if (ret =3D=3D 0)
> > > -           desc->vm_ops =3D &afs_vm_ops;
> > > -   else
> > > -           afs_drop_open_mmap(vnode);
> > > +   if (ret)
> > > +           return ret;
> > > +
> > > +   desc->vm_ops =3D &afs_vm_ops;
> > >     return ret;
> > >  }
> > >
> > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_=
t pgoff,
> > > +                 const struct file *file, void **vm_private_data)
> > > +{
> > > +   struct afs_vnode *vnode =3D AFS_FS_I(file_inode(file));
> > > +
> > > +   afs_add_open_mmap(vnode);
> > > +   return 0;
> > > +}
> > > +
> > >  static void afs_vm_open(struct vm_area_struct *vma)
> > >  {
> > >     afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> > > --
> > > 2.53.0
> > >
> > >
>
> Cheers, Lorenzo
