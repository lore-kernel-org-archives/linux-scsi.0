Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58EA2C15BE
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772044112; cv=none; b=p1uVTk+U1SI1n1oUQspq60ydt3ny+J0rVJ3gSZLjs3A6oZurbVH0eke9zGWZPUeeEYJVTsTg1G2GcuQkgNpD8/3iwVR6PGrFE1YEYvGmuASkBMlU7xBj/KSmgk2uAhXxzKEiAaNv5VDXpCjw90PhMRb2Gz1iKVat5dNY3TZyMI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772044112; c=relaxed/simple;
	bh=xqvNEheZ6hTEx8wte6bxRRSvj/90Bk8ht9BgrZwTH2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVYDZJH8PwVaOoDPHQS8aiH6unsjEuAA/kgFAR6HpR9g+b+zEq0fjtQ8z1wpBEETI/C8VU6y+jDFq+XH3PKA2WQfdyjJDFYg8B3O1w+iJYQh//IQ1wwz/BFLEqoQVI4GkATp6jflh6XhOUGFu6+I7KNtsR7+/UnKhfO+mdIESR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V4I3LlkD; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4I3LlkD"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad4d639db3so33867495ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 10:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772044110; x=1772648910; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=++GgNEa7IDLFz2yQx18PzOQxKfqSeTS5Q2Mudl5/AVc=;
        b=V4I3LlkDzHjIKcpFk02vXJCB18bYHQSMNpqJ+OK2q9+zbleOYPezuJmlA5zYpmDMSy
         Tb/W410/nafoHKaaFjxCmAPSWGO/5hk90MKo9QZr7OZVMkaeLlERzCte9FbrPLRoBdw1
         JCeTBfk5J6mWFr0GjkGjOk58/OoUrB/8fBAwwQNwBkM4XKinieG1IZLwkdmwSj+5U77g
         TnWTj3bLlAwycNzHBhnRsdWwI0IwB7blbm7Y6pRcLlJ0P43VVzFm8reB8qTL1KKdZug6
         hWpRqMajo6aQ0b9UiQ8OZrkMyq+A5KjWMmyDsKAKoYRFRHWdHPWISmLuAxDymcq4DfOJ
         9/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772044110; x=1772648910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=++GgNEa7IDLFz2yQx18PzOQxKfqSeTS5Q2Mudl5/AVc=;
        b=O5W5q4uPJirG+7fthac3OJ6JPlKS7cdXXGnI8CnJz5mSLXP6tZabA0Uz0G6ZdQQdt8
         WMwf/t6XYQTfB62IOR1n5J9WtEpGTHl4Bdy2jRBjvceR7BImSD9tIuDWDd0OtKRdOXAa
         WgpJXND+XOFtEfw9kh+tyTKt7odkym156yHXa0wLw5rhBscUph2etSutoXTSNq8mJJvp
         CTKYhBd+NVgZ3aUualBgFS/+3pNKBpOZImQ/BuFutsEYzGLyP6M1RIIGOEmBzld6RNtg
         Omw43xvxeMxgz9d91Ezb0BLaY0M4U/QIjmfbqGAmtO5g5xr/dAaPin4zV5C/vp0ck+Xc
         IWpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn3a8hLFrUD6nMQeOlO2PvsH+mJlRHY5QtnxCvx9I86ex9OdfAP8wtBcQIO2WuycFP7Ul2+dsc92zO@vger.kernel.org
X-Gm-Message-State: AOJu0YwwnSxgzwVbxWyzgI6pxrv+ZxICeog+jec5ZFsXz5o5sm4AKc+4
	G0SzFbqeNPr57sBsPrrTbAxM91UjEjyd2eq/qmCxSsINkjH4MgTg/Zdi
X-Gm-Gg: ATEYQzw77rA5ESf/FXQtjstYP5amto/yKquUULUJrj3BkiCU0NxX3S/zgu1bh11HLU7
	uhifr5uwPwwuOWXtuunyzGpkchT4SQgJKnCu9+7g1Lkhf973qPJy3/2yHnduyHSv5Z9qpTvfYhL
	CfrmfYHUqe8TqqIR2+2qts2l+FQyx2f6l/qg2UpPl7GbIM8m0DPQS5ERt9+m6nZ49EGFMlJh0cP
	R+00vfnG5fI7QxLoQHstZiKTU5aP8UpfQFAwjEJ2s8lCKa3Q3gcqFqSWWTH1zSGVs6+mwuAPGQw
	RJDSLTaHeyijUzqhTEdUHqkmI4ev4smz6JSBX/QrwYsEPmIE7tuZpM78xa7xndH2PS8PjCToEly
	JGbi1nX0IZmSNP7Bv8pZx58nywtlNLV03XcrPLNxLc0nTBO5NPfbQz0FNCLb8LWS3ciA4RveGxu
	EZ+tfC1XnJBkJumuIfHa7EsCBgH8GW6WEGU9IY
X-Received: by 2002:a17:902:eccc:b0:2aa:f9d7:68a9 with SMTP id d9443c01a7336-2ade99c301fmr9542355ad.21.1772044110077;
        Wed, 25 Feb 2026 10:28:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adaa3b2b7bsm49005715ad.10.2026.02.25.10.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 10:28:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 25 Feb 2026 10:28:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Nilesh Javali <njavali@marvell.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
	sdeodhar@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
Subject: Re: [PATCH v3 08/12] qla2xxx: free sp in error path to fix system
 crash
Message-ID: <95de7112-d924-4ce5-ae96-8a0c6289732e@roeck-us.net>
References: <20251210101604.431868-1-njavali@marvell.com>
 <20251210101604.431868-9-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210101604.431868-9-njavali@marvell.com>

Hi,

On Wed, Dec 10, 2025 at 03:46:00PM +0530, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> System crash seen during load/unload test in a loop,
> 
> [61110.449331] qla2xxx [0000:27:00.0]-0042:0: Disabled MSI-X.
> [61110.467494] =============================================================================
> [61110.467498] BUG qla2xxx_srbs (Tainted: G           OE    --------  --- ): Objects remaining in qla2xxx_srbs on __kmem_cache_shutdown()
> [61110.467501] -----------------------------------------------------------------------------
> 
> [61110.467502] Slab 0x000000000ffc8162 objects=51 used=1 fp=0x00000000e25d3d85 flags=0x57ffffc0010200(slab|head|node=1|zone=2|lastcpupid=0x1fffff)
> [61110.467509] CPU: 53 PID: 455206 Comm: rmmod Kdump: loaded Tainted: G           OE    --------  ---  5.14.0-284.11.1.el9_2.x86_64 #1
> [61110.467513] Hardware name: HPE ProLiant DL385 Gen10 Plus v2/ProLiant DL385 Gen10 Plus v2, BIOS A42 08/17/2023
> [61110.467515] Call Trace:
> [61110.467516]  <TASK>
> [61110.467519]  dump_stack_lvl+0x34/0x48
> [61110.467526]  slab_err.cold+0x53/0x67
> [61110.467534]  __kmem_cache_shutdown+0x16e/0x320
> [61110.467540]  kmem_cache_destroy+0x51/0x160
> [61110.467544]  qla2x00_module_exit+0x93/0x99 [qla2xxx]
> [61110.467607]  ? __do_sys_delete_module.constprop.0+0x178/0x280
> [61110.467613]  ? syscall_trace_enter.constprop.0+0x145/0x1d0
> [61110.467616]  ? do_syscall_64+0x5c/0x90
> [61110.467619]  ? exc_page_fault+0x62/0x150
> [61110.467622]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [61110.467626]  </TASK>
> [61110.467627] Disabling lock debugging due to kernel taint
> [61110.467635] Object 0x0000000026f7e6e6 @offset=16000
> [61110.467639] ------------[ cut here ]------------
> [61110.467639] kmem_cache_destroy qla2xxx_srbs: Slab cache still has objects when called from qla2x00_module_exit+0x93/0x99 [qla2xxx]
> [61110.467659] WARNING: CPU: 53 PID: 455206 at mm/slab_common.c:520 kmem_cache_destroy+0x14d/0x160
> [61110.467718] CPU: 53 PID: 455206 Comm: rmmod Kdump: loaded Tainted: G    B      OE    --------  ---  5.14.0-284.11.1.el9_2.x86_64 #1
> [61110.467720] Hardware name: HPE ProLiant DL385 Gen10 Plus v2/ProLiant DL385 Gen10 Plus v2, BIOS A42 08/17/2023
> [61110.467721] RIP: 0010:kmem_cache_destroy+0x14d/0x160
> [61110.467724] Code: 99 7d 07 00 48 89 ef e8 e1 6a 07 00 eb b3 48 8b 55 60 48 8b 4c 24 20 48 c7 c6 70 fc 66 90 48 c7 c7 f8 ef a1 90 e8 e1 ed 7c 00 <0f> 0b eb 93 c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
> [61110.467725] RSP: 0018:ffffa304e489fe80 EFLAGS: 00010282
> [61110.467727] RAX: 0000000000000000 RBX: ffffffffc0d9a860 RCX: 0000000000000027
> [61110.467729] RDX: ffff8fd5ff9598a8 RSI: 0000000000000001 RDI: ffff8fd5ff9598a0
> [61110.467730] RBP: ffff8fb6aaf78700 R08: 0000000000000000 R09: 0000000100d863b7
> [61110.467731] R10: ffffa304e489fd20 R11: ffffffff913bef48 R12: 0000000040002000
> [61110.467731] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [61110.467733] FS:  00007f64c89fb740(0000) GS:ffff8fd5ff940000(0000) knlGS:0000000000000000
> [61110.467734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [61110.467735] CR2: 00007f0f02bfe000 CR3: 00000020ad6dc005 CR4: 0000000000770ee0
> [61110.467736] PKRU: 55555554
> [61110.467737] Call Trace:
> [61110.467738]  <TASK>
> [61110.467739]  qla2x00_module_exit+0x93/0x99 [qla2xxx]
> [61110.467755]  ? __do_sys_delete_module.constprop.0+0x178/0x280
> 
> Free sp in the error path to fix the crash.
> 
> Fixes: f352eeb75419 ("scsi: qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
> ---
>  drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index 02a52c215797..e5ebb9c5b650 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3532,8 +3532,8 @@ int qla_fab_async_scan(scsi_qla_host_t *vha, srb_t *sp)
>  	if (vha->scan.scan_flags & SF_SCANNING) {
>  		spin_unlock_irqrestore(&vha->work_lock, flags);
>  		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2012,
> -		    "%s: scan active\n", __func__);
> -		return rval;
> +		    "%s: scan active for sp:%p\n", __func__, sp);
> +		goto done_free_sp;

An experimental AI code review agent generated the following feedback:

If `vha->scan.scan_flags & SF_SCANNING` is true here, it means another thread
or context is already performing a scan. By jumping to `done_free_sp`, the code
now executes `vha->scan.scan_flags &= ~SF_SCANNING;`, which incorrectly clears
the flag while the other scan is still active.

Could this allow multiple concurrent scans to run, defeating the purpose of the
`SF_SCANNING` check? Should `sp` be freed directly here (for example, by calling
`qla24xx_sp_unmap(vha, sp);` or similar) before returning `rval`, to avoid
clearing the active scan flag?

Please take a look and let me know if the AI has a point or if it is missing
something.

Thanks,
Guenter
