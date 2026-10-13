Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988144F7CBF
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895931; cv=none; b=akmmBfpiY36r4z8/JwGuOlo5lidbuDrfxHYvrSsvGvONQc/WOr/EGBDyoL8MK8R0iUSHZWDGUZStdbBDVB36LMl9ra8wl+vJZgVpvMOQTBsVE8NhREODO6iubaGByVtCz5R+KF1pequVQFssx4uIdig4o5cmWboN0CqHLh2a3Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895931; c=relaxed/simple;
	bh=p2uRChVRxCXksfoc7niguKSWfjdr6ZGZTh0M+96+IwI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TGcwnPrtq1U5oAH2NBXx+czAyD/MlRI9CFBECob9YZc4kojuJST7OrvtQULJsOQXsDG//PqUi1YKf4zxGRtFrOxQlr4ji0kKM1dXV0SV3ahSF36/83IUPXElgRmqOTipf9kKkk5TVY35BojsDsUFnTIwVGcXlDedwxzGlejl2IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SjbfVdgi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HrqBnMsG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SjbfVdgi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrqBnMsG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791895927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXEHGOtHh3baENnAcbFZACuEi2aZnF37n/iOCZA6PHA=;
	b=SjbfVdgiDFEU8C+RdUnDRlVouThvj6ioL8WM9iwS1wiWuuOREkf8RPC+eW7uJvQuToA0Ug
	g5SkHc63+jFXq+T6M+y/beVKm1fd2huLBKfCyfYm07sgyFRXhCWUjTdPRW8ycfmwbeCjMz
	w3wMed2w8nxRKfsktNNcC8mC9C3Tgbk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-vvnkoDITMNC3tHWEKI7-sA-1; Tue, 13 Oct 2026 12:52:06 +0000
X-MC-Unique: vvnkoDITMNC3tHWEKI7-sA-1
X-Mimecast-MFC-AGG-ID: vvnkoDITMNC3tHWEKI7-sA_1791895926
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93e49a1d3b1so688134985a.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 05:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791895926; x=1792500726; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RXEHGOtHh3baENnAcbFZACuEi2aZnF37n/iOCZA6PHA=;
        b=HrqBnMsGC5h3rtgTSDbhbowQA6N8JDVETyiV169ybsIIxLp1huy43EJpDBFF/PxuSF
         LN+riEw/1jgYM5eQ23M+oXnqVSXM9e0P6dA4jaaX3PwPrV6LlSrcc0b0OkP2qJomGlDq
         Imm4AOIdM6LdYU9AHisAaoHHG7pWq1LzhcRCCe0jQV5zmMlqs4Fwx0sYC4tMGffRwNFo
         xEOYSL0oagG72dOuqmsx4S37kJUJohCdBQks541P42yTq4Sitp3co+nXjF1nv1d6Seua
         MSL/ZJoyAhTRMOVnM6t//M93WyMkM8FkVPeT+XKm48GhiM4JQ/6VnBvSnGek4cmkRtmD
         YvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791895926; x=1792500726;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXEHGOtHh3baENnAcbFZACuEi2aZnF37n/iOCZA6PHA=;
        b=s3KvxErwNkgLsNe0e1NuhDMS0tIJ1H4vk3ET5nwTSPVbrxS/WHrN+3H+u2+w5uCQ2d
         CkJl7Z4DYe0nfxCxg+Ezql9MMCWvgdF9SNicvpoX+pHopxVANzEKUOAmKYTFdl0ueq18
         vGCF2rXHmz0+o6Re4hzq5u5GfheSRL8ULeB0d98xV/GMeAvmMM2OZKjU2w3JHMby7XRe
         tJl+/tenS1wElwVCBimjGSUDQKw8FoHDcyzZe1iAu+xxnIepUzJSjfGjA7iPVHUCh4Jk
         6SNIF4gP1Q4c9P6m1MWSFNTCjyPYF9uMwv4Z83b0ay4mcB05mrlWEzvB9dbFuIEQ+pbR
         +Xmw==
X-Forwarded-Encrypted: i=1; AKwUvBxlZ7wD8qbXNYNXVFf9B4F8TqTiPkImfZ3KJHGgoucTCkQMCtH0b09BeYWxvTDaHOHGuNx47Evd92v/@vger.kernel.org
X-Gm-Message-State: AFq9FYKf93nRn/wRUUEMXdl6RWBNNKlabSCSvwVLEQUFO8MMvdg13xU0
	WYXbRHw2tXl7rrL6i+j9iGz1coU8skc1QN1Osko6wgTgsUMOpVp9xV/Uxn0WxdeoxO1Ev254udK
	bp02rAL8S6LF+dayECdJNMaPfmoHTNW3FUx736jDwc1j1c2bLKxkK2p4xtpQonJQ=
X-Gm-Gg: AYBFou06xhs4TT1G8iSjMlpbNMEE9h0NqLZPgs3zBcKeK8GGiq0QCCHy+5kB+wckDUK
	gwXb0nmY2JDmPDGAyILsEbOookY9HUFznyo+pWoDRg6l2da5CPDUapmEf1kndSOhkpOWI23QClu
	UgQwBOw2iI2h/1M///e1hP0I9HquplzT6lXw3u8jgr90YpkO4p0M1RiIijU7FzURTkpgUJ23VNW
	duMnZvmPmsvTbg8HHbyrdue5IT0OGP3GS1tMm72L9kpQUrWutaYF/50SZTkkci82DJxoQ3/s3ZK
	d7gbJSK/qXCGeSOiHIVcYyhK4RiDDlBV2urFVVK1wu+uEjpceuam2cLqCjb9zfZ1kGlxbncNpKk
	epLRODnq43A+Y8ApdofVNZPutts7pUo1mvlw=
X-Received: by 2002:a05:620a:1b97:b0:93e:66e6:fa4 with SMTP id af79cd13be357-93ebd20e4a4mr1960628785a.16.1791895925586;
        Tue, 13 Oct 2026 05:52:05 -0700 (PDT)
X-Received: by 2002:a05:620a:1b97:b0:93e:66e6:fa4 with SMTP id af79cd13be357-93ebd20e4a4mr1960624985a.16.1791895924986;
        Tue, 13 Oct 2026 05:52:04 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5086fe3sm229204385a.37.2026.10.13.05.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:52:04 -0700 (PDT)
Message-ID: <e5312492c3d90322f362b1b148f7dce4290c2ba1.camel@redhat.com>
Subject: Re: [BUG] scsi: st: use-after-free race between st_remove() and
 st_open()/scsi_tape_get()
From: Laurence Oberman <loberman@redhat.com>
To: Dingisoul <dingiso.kernel@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, mkp@kernel.org
Date: Tue, 13 Oct 2026 08:52:03 -0400
In-Reply-To: <20261012201730.1853897-1-dingiso.kernel@gmail.com>
References: <20261007211520.1428497-1-dingiso.kernel@gmail.com>
	 <20261012201730.1853897-1-dingiso.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-10-12 at 16:17 -0400, Dingisoul wrote:
> Hi Laurence,
>=20
> Adding you to Cc as requested. Quoting the original report below for
> reference; let me know if you'd like anything else re-tested.
>=20
> Best,
> Dingisoul
>=20
> > Hi Kernel Maintainers,
> >=20
> > I hit the following report while testing current upstream kernel:
> >=20
> > KASAN: slab-use-after-free in st_open
> >=20
> > on commit: a90ee4305c4a (2026-10-06)
> >=20
> > Root cause: st_remove() drops the device's last reference, and only
> > afterwards removes it from st_index_idr:
> >=20
> > =C2=A0=C2=A0=C2=A0 static void st_remove(struct scsi_device *SDp)
> > =C2=A0=C2=A0=C2=A0 {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct device *dev =3D &SDp-=
>sdev_gendev;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_tape *tpnt =3D d=
ev_get_drvdata(dev);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int index =3D tpnt->index;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&st_ref_mutex);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kref_put(&tpnt->kref, scsi_t=
ape_release);=C2=A0 /* may
> > kfree(tpnt) right here */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&st_ref_mutex);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&st_index_lock);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 idr_remove(&st_index_idr, in=
dex);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* too late:
> > tpnt may already be freed */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&st_index_lock);
> > =C2=A0=C2=A0=C2=A0 }
> >=20
> > Meanwhile scsi_tape_get() -- called from st_open() on every open of
> > a
> > tape device node -- looks the device up by the same index and takes
> > its
> > own reference:
> >=20
> > =C2=A0=C2=A0=C2=A0 static struct scsi_tape *scsi_tape_get(int dev)
> > =C2=A0=C2=A0=C2=A0 {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_tape *STp =3D NU=
LL;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&st_ref_mutex);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&st_index_lock);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 STp =3D idr_find(&st_index_i=
dr, dev);=C2=A0 /* can still find the
> > freed tpnt */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!STp) goto out;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kref_get(&STp->kref);=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 /* UAF write */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0=C2=A0 }
> >=20
> > =C2=A0=C2=A0=C2=A0 static int st_open(struct inode *inode, struct file =
*filp)
> > =C2=A0=C2=A0=C2=A0 {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(STp =3D scsi_tape_get(=
dev))) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> >=20
> > Between st_remove()'s mutex_unlock(&st_ref_mutex) and its own
> > spin_lock(&st_index_lock), tpnt is already freed but still
> > reachable
> > through st_index_idr. A concurrent st_open() racing in that window
> > takes
> > both locks in scsi_tape_get(), finds the stale idr entry, and calls
> > kref_get() on the freed tpnt.
> >=20
> > We used scsi_debug (ptype=3D1, emulating a tape LUN) to avoid needing
> > real
> > tape hardware.
> >=20
> > The reproducer and .config files are here.
> > https://gist.github.com/dingiso/b33f8c01a47bfcbb902d3f21a4877feb
> >=20
> > I'm happy to test debug patches or provide additional information.
> >=20
> > [=C2=A0=C2=A0 23.212502]
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [=C2=A0=C2=A0 23.212506] BUG: KASAN: slab-use-after-free in st_open
> > (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-
> > instrumented.h:252 ./include/linux/refcount.h:283
> > ./include/linux/refcount.h:366 ./include/linux/refcount.h:383
> > ./include/linux/kref.h:45 drivers/scsi/st.c:254
> > drivers/scsi/st.c:1291)
> > [=C2=A0=C2=A0 23.212537] Write of size 4 at addr ffff888009854a1c by ta=
sk
> > repro/315
> > [=C2=A0=C2=A0 23.212541]=20
> > [=C2=A0=C2=A0 23.212551] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX=
 +
> > PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [=C2=A0=C2=A0 23.212554] Call Trace:
> > [=C2=A0=C2=A0 23.212556]=C2=A0 <TASK>
> > [=C2=A0=C2=A0 23.212558]=C2=A0 dump_stack_lvl (lib/dump_stack.c:94
> > lib/dump_stack.c:120)
> > [=C2=A0=C2=A0 23.212566]=C2=A0 print_report (mm/kasan/report.c:378
> > mm/kasan/report.c:482)
> > [=C2=A0=C2=A0 23.212591]=C2=A0 kasan_report (mm/kasan/report.c:595)
> > [=C2=A0=C2=A0 23.212602]=C2=A0 kasan_check_range (mm/kasan/generic.c:18=
6
> > mm/kasan/generic.c:200)
> > [=C2=A0=C2=A0 23.212607]=C2=A0 st_open (./include/linux/instrumented.h:=
112
> > ./include/linux/atomic/atomic-instrumented.h:252
> > ./include/linux/refcount.h:283 ./include/linux/refcount.h:366
> > ./include/linux/refcount.h:383 ./include/linux/kref.h:45
> > drivers/scsi/st.c:254 drivers/scsi/st.c:1291)
> > [=C2=A0=C2=A0 23.212623]=C2=A0 chrdev_open (fs/char_dev.c:411)
> > [=C2=A0=C2=A0 23.212645]=C2=A0 do_dentry_open (fs/open.c:996)
> > [=C2=A0=C2=A0 23.212651]=C2=A0 vfs_open (fs/open.c:1101)
> > [=C2=A0=C2=A0 23.212656]=C2=A0 path_openat (fs/namei.c:4837 fs/namei.c:=
5000)
> > [=C2=A0=C2=A0 23.212669]=C2=A0 do_file_open (fs/namei.c:5029)
> > [=C2=A0=C2=A0 23.212693]=C2=A0 do_sys_openat2 (fs/open.c:1417 (discrimi=
nator 1))
> > [=C2=A0=C2=A0 23.212702]=C2=A0 __x64_sys_openat (fs/open.c:1423 fs/open=
.c:1439
> > fs/open.c:1434 fs/open.c:1434)
> > [=C2=A0=C2=A0 23.212712]=C2=A0 do_syscall_64 (arch/x86/entry/syscall_64=
.c:61
> > arch/x86/entry/syscall_64.c:84)
> > [=C2=A0=C2=A0 23.212719]=C2=A0 entry_SYSCALL_64_after_hwframe
> > (arch/x86/entry/entry_64.S:121)
> > [=C2=A0=C2=A0 23.212755]=20
> > [=C2=A0=C2=A0 23.212756] Allocated by task 325:
> > [=C2=A0=C2=A0 23.212758]=C2=A0 kasan_save_stack (mm/kasan/common.c:57)
> > [=C2=A0=C2=A0 23.212764]=C2=A0 kasan_save_track (mm/kasan/common.c:78)
> > [=C2=A0=C2=A0 23.212768]=C2=A0 __kasan_kmalloc (mm/kasan/common.c:409
> > mm/kasan/common.c:426)
> > [=C2=A0=C2=A0 23.212773]=C2=A0 __kmalloc_cache_noprof (./include/linux/=
kasan.h:263
> > mm/slub.c:5563)
> > [=C2=A0=C2=A0 23.212778]=C2=A0 st_probe (./include/linux/slab.h:991
> > ./include/linux/slab.h:1312 drivers/scsi/st.c:4376)
> > [=C2=A0=C2=A0 23.212783]=C2=A0 really_probe (drivers/base/dd.c:628
> > drivers/base/dd.c:706)
> > [=C2=A0=C2=A0 23.212788]=C2=A0 __driver_probe_device (drivers/base/dd.c=
:868)
> > [=C2=A0=C2=A0 23.212793]=C2=A0 driver_probe_device (drivers/base/dd.c:8=
98)
> > [=C2=A0=C2=A0 23.212798]=C2=A0 __device_attach_driver (drivers/base/dd.=
c:1026)
> > [=C2=A0=C2=A0 23.212803]=C2=A0 bus_for_each_drv (drivers/base/bus.c:500=
)
> > [=C2=A0=C2=A0 23.212807]=C2=A0 __device_attach (drivers/base/dd.c:1098)
> > [=C2=A0=C2=A0 23.212811]=C2=A0 device_initial_probe (drivers/base/dd.c:=
1153)
> > [=C2=A0=C2=A0 23.212816]=C2=A0 bus_probe_device (drivers/base/bus.c:620=
)
> > [=C2=A0=C2=A0 23.212821]=C2=A0 device_add (drivers/base/core.c:3776)
> > [=C2=A0=C2=A0 23.212826]=C2=A0 scsi_sysfs_add_sdev
> > (drivers/scsi/scsi_sysfs.c:1427)
> > [=C2=A0=C2=A0 23.212830]=C2=A0 scsi_add_lun (drivers/scsi/scsi_scan.c:1=
138
> > (discriminator 1))
> > [=C2=A0=C2=A0 23.212834]=C2=A0 scsi_probe_and_add_lun
> > (drivers/scsi/scsi_scan.c:1311)
> > [=C2=A0=C2=A0 23.212838]=C2=A0 __scsi_scan_target (drivers/scsi/scsi_sc=
an.c:1805)
> > [=C2=A0=C2=A0 23.212841]=C2=A0 scsi_scan_channel (drivers/scsi/scsi_sca=
n.c:1895
> > drivers/scsi/scsi_scan.c:1870)
> > [=C2=A0=C2=A0 23.212845]=C2=A0 scsi_scan_host_selected
> > (drivers/scsi/scsi_scan.c:1924)
> > [=C2=A0=C2=A0 23.212849]=C2=A0 scsi_scan_host (drivers/scsi/scsi_scan.c=
:2089
> > drivers/scsi/scsi_scan.c:2077)
> > [=C2=A0=C2=A0 23.212852] sdebug_driver_probe (drivers/scsi/scsi_debug.c=
:9618)
> > scsi_debug
> > [=C2=A0=C2=A0 23.212875]=C2=A0 really_probe (drivers/base/dd.c:628
> > drivers/base/dd.c:706)
> > [=C2=A0=C2=A0 23.212879]=C2=A0 __driver_probe_device (drivers/base/dd.c=
:868)
> > [=C2=A0=C2=A0 23.212883]=C2=A0 driver_probe_device (drivers/base/dd.c:8=
98)
> > [=C2=A0=C2=A0 23.212887]=C2=A0 __device_attach_driver (drivers/base/dd.=
c:1026)
> > [=C2=A0=C2=A0 23.212891]=C2=A0 bus_for_each_drv (drivers/base/bus.c:500=
)
> > [=C2=A0=C2=A0 23.212895]=C2=A0 __device_attach (drivers/base/dd.c:1098)
> > [=C2=A0=C2=A0 23.212900]=C2=A0 device_initial_probe (drivers/base/dd.c:=
1153)
> > [=C2=A0=C2=A0 23.212905]=C2=A0 bus_probe_device (drivers/base/bus.c:620=
)
> > [=C2=A0=C2=A0 23.212909]=C2=A0 device_add (drivers/base/core.c:3776)
> > [=C2=A0=C2=A0 23.212914] sdebug_add_host_helper
> > (drivers/scsi/scsi_debug.c:8843) scsi_debug
> > [=C2=A0=C2=A0 23.212937] add_host_store (drivers/scsi/scsi_debug.c:8878
> > drivers/scsi/scsi_debug.c:8105) scsi_debug
> > [=C2=A0=C2=A0 23.212954]=C2=A0 kernfs_fop_write_iter (fs/kernfs/file.c:=
345)
> > [=C2=A0=C2=A0 23.212960]=C2=A0 vfs_write (fs/read_write.c:595 fs/read_w=
rite.c:687)
> > [=C2=A0=C2=A0 23.212964]=C2=A0 ksys_write (fs/read_write.c:739)
> > [=C2=A0=C2=A0 23.212968]=C2=A0 do_syscall_64 (arch/x86/entry/syscall_64=
.c:61
> > arch/x86/entry/syscall_64.c:84)
> > [=C2=A0=C2=A0 23.212973]=C2=A0 entry_SYSCALL_64_after_hwframe
> > (arch/x86/entry/entry_64.S:121)
> > [=C2=A0=C2=A0 23.212977]=20
> > [=C2=A0=C2=A0 23.212978] Freed by task 325:
> > [=C2=A0=C2=A0 23.212980]=C2=A0 kasan_save_stack (mm/kasan/common.c:57)
> > [=C2=A0=C2=A0 23.212984]=C2=A0 kasan_save_track (mm/kasan/common.c:78)
> > [=C2=A0=C2=A0 23.212989]=C2=A0 kasan_save_free_info (mm/kasan/generic.c=
:584)
> > [=C2=A0=C2=A0 23.212993]=C2=A0 __kasan_slab_free (mm/kasan/common.c:264
> > mm/kasan/common.c:296)
> > [=C2=A0=C2=A0 23.212997]=C2=A0 kfree (./include/linux/kasan.h:235 mm/sl=
ub.c:2748
> > mm/slub.c:6509 mm/slub.c:6802)
> > [=C2=A0=C2=A0 23.213000]=C2=A0 st_remove (./include/linux/kref.h:65
> > drivers/scsi/st.c:4512)
> > [=C2=A0=C2=A0 23.213004]=C2=A0 device_release_driver_internal
> > (drivers/base/dd.c:1349 drivers/base/dd.c:1372)
> > [=C2=A0=C2=A0 23.213009]=C2=A0 bus_remove_device (drivers/base/bus.c:66=
4)
> > [=C2=A0=C2=A0 23.213014]=C2=A0 device_del (drivers/base/core.c:3965)
> > [=C2=A0=C2=A0 23.213018]=C2=A0 __scsi_remove_device
> > (drivers/scsi/scsi_sysfs.c:1499)
> > [=C2=A0=C2=A0 23.213021]=C2=A0 scsi_forget_host (drivers/scsi/scsi_scan=
.c:2115)
> > [=C2=A0=C2=A0 23.213025]=C2=A0 scsi_remove_host (drivers/scsi/hosts.c:1=
82)
> > [=C2=A0=C2=A0 23.213031] sdebug_driver_remove
> > (drivers/scsi/scsi_debug.c:9631) scsi_debug
> > [=C2=A0=C2=A0 23.213052]=C2=A0 device_release_driver_internal
> > (drivers/base/dd.c:1349 drivers/base/dd.c:1372)
> > [=C2=A0=C2=A0 23.213057]=C2=A0 bus_remove_device (drivers/base/bus.c:66=
4)
> > [=C2=A0=C2=A0 23.213061]=C2=A0 device_del (drivers/base/core.c:3965)
> > [=C2=A0=C2=A0 23.213065]=C2=A0 device_unregister (drivers/base/core.c:4=
006)
> > [=C2=A0=C2=A0 23.213070] sdebug_do_remove_host
> > (drivers/scsi/scsi_debug.c:8917) scsi_debug
> > [=C2=A0=C2=A0 23.213089] add_host_store (drivers/scsi/scsi_debug.c:8110=
)
> > scsi_debug
> > [=C2=A0=C2=A0 23.213109]=C2=A0 kernfs_fop_write_iter (fs/kernfs/file.c:=
345)
> > [=C2=A0=C2=A0 23.213113]=C2=A0 vfs_write (fs/read_write.c:595 fs/read_w=
rite.c:687)
> > [=C2=A0=C2=A0 23.213117]=C2=A0 ksys_write (fs/read_write.c:739)
> > [=C2=A0=C2=A0 23.213121]=C2=A0 do_syscall_64 (arch/x86/entry/syscall_64=
.c:61
> > arch/x86/entry/syscall_64.c:84)
> > [=C2=A0=C2=A0 23.213126]=C2=A0 entry_SYSCALL_64_after_hwframe
> > (arch/x86/entry/entry_64.S:121)
> > Best,
> > Dingisoul

Hello

Please try this patch, let me know if it fixes this and I will send a
follow up to finalize this fix.


diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c49466..d5b90bd1c6 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4509,11 +4509,11 @@ static void st_remove(struct scsi_device *SDp)
 	remove_cdevs(tpnt);
=20
 	mutex_lock(&st_ref_mutex);
-	kref_put(&tpnt->kref, scsi_tape_release);
-	mutex_unlock(&st_ref_mutex);
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, index);
 	spin_unlock(&st_index_lock);
+	kref_put(&tpnt->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
 }
=20


