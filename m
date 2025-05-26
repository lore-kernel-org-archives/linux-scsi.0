Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D6319FA8D
	for <linux-scsi@vger.kernel.org>; Mon, 26 May 2025 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748258897; cv=none; b=Ldo7PZHTxcTL6OF917HmbDfe/5Ef0iApNOmCgHlDU0s6odcxDM9NpwqfH7WbpkqHTlKBWkxwN3nFwMWztMXA3Y3wS4kbtUtfRrj5X/pVY1pWBoGGHI6/nm1z4fQzCGcuvtSmV8v56oaCCM9yLwpljuoGFQr6IOvd2sQUir/Dgzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748258897; c=relaxed/simple;
	bh=fMGRF4QbYDU1RPpkGST8PpeVk5yZEUtNI4SAPFhJliQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iwkgAzqlTxt1p+hj7ffyuBMtcaIXUyz6syLxK+LLAYFLsBTu8EH3KHfhed8KiXBj4BlazCBW0sQkz5Hswm4gzX4diWlYKiEeqeRuc/UVANw8MebWfd9TBlxUw2PzXyho21IKtu9BrRM+btXCCZlEWVGm/vZr/v12O/CxIotsfPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=cQRqaaIu; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="cQRqaaIu"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3feaedb531dso290463b6e.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 May 2025 04:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1748258895; x=1748863695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1W+rRg+qB6E3PP3RlffazXHAJY+3BhmSu21vDM0uEA=;
        b=cQRqaaIuVnaLW2zXqqKC3HIFS/WWYNtK5+wQhNfnvS+OX8sF1g9KcK1NUEmPwG4Tq/
         d89xN1BvSVAGBHcbXuWcipAeZCISga1Jm0mnr+OlFmkjqFjJCOeuYaevfJzuw+vWuh0M
         DxAAv4Kxh0aQjGLJOKYmLmlTfFBpHoKhupOlUsve5Op8ghRwL3L4N7h9xn0FiFaHyPg1
         3ExoFKDg/7NWNF/AAp4tN8xGD5NKqueBR1uapajR3ZniakGvXhqqDYUPboGF4Gp9zBxu
         PkHSQxyeVmG/CcjOjIW/Vj3DCM186MW+yBC9VwknAlwJ9MqobZmXdObvr4XCQJk89qa5
         KiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748258895; x=1748863695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1W+rRg+qB6E3PP3RlffazXHAJY+3BhmSu21vDM0uEA=;
        b=GfDT/qR6imbX2FkgdeV+5sboqLVtULFZxq9U2WkYim87w/qudQHQSgWLuniQnjKnUn
         JT9K999ePI0sNI7tya5YQqaumWNHY8MfWQP05g3VxwkWw1uTv2W2SPW0vXmZxQuiXVLT
         xOaKm96bPJMdtFaG4ivGfwf+GIh0Ecs5EK3WqigCzMhNAkQEHHqTUGA5hu+a4zFugdJg
         hS/cfGMid7EMVQhgNZTDMf/Nd6K5oCLo/+F23jEc8YXjmDvrINvJ9QDn7g/DhHZI4epS
         LV0gvOroJfzE1P6kwf2rQO7Vceb0VGGM8m3TmojPVyHv5MQ1+KEbnA+iw3eNQ6cFkhwZ
         HFLg==
X-Forwarded-Encrypted: i=1; AJvYcCVi/oRz/p2tlgcGO3am2dlCgaECvExx4kg2C0fvVH4OyodF//9c2mnijJ6iyeD868qlGhyVRZ6S0J7R@vger.kernel.org
X-Gm-Message-State: AOJu0YxKJxNbApu0wygp4wj1LjcZ0VoR4qZujJtpJ1xYDWEzz1CPTNuf
	HJSd3mcK8IFKuj6pyJGgzvbOeAYDmAysildkug80FH4+MEZptQvvAGmeBV8eqo4OysbC9Rtjamw
	pYPWGdeR4bzjhwFPzsLSxu0NLXWbJ/eVp0yYI2G/JRQ==
X-Gm-Gg: ASbGnctbb//iEGhS36IN8QomLbJg5ZT8HlH5vh9PyMqOMeBJBs1/r1UbAOR2IQwE8EJ
	m8MNMN04STIUv+xOeOGsnOD+Qt6Y7j0wyqTzlyrfWwzq3Vv/XCzFhhKZ0On7O96V64E5SJlLVJU
	Qd8DIy2SUD+mhRE7gi57+dRXc+ObIgFMpsAW+RmIIgEUeJ
X-Google-Smtp-Source: AGHT+IF+XGb+RC9whoUMyRPJpJA3/K8NnIsOpwzmdZhF+QP/Z2mlIwOUMsIJaLuxnb800CCFZdKYSuCm1ofFRmWpVlo=
X-Received: by 2002:a05:6871:e70c:b0:29f:f1cc:12a5 with SMTP id
 586e51a60fabf-2e862057547mr5015366fac.31.1748258894516; Mon, 26 May 2025
 04:28:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250526112203.75874-1-changfengnan@bytedance.com>
In-Reply-To: <20250526112203.75874-1-changfengnan@bytedance.com>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Mon, 26 May 2025 19:28:03 +0800
X-Gm-Features: AX0GCFsVM1msxbokKO7UGkahRhxFlcELb6lFQ74O9WnfapfGrxVBt_2QG77KLOQ
Message-ID: <CAPFOzZtUqYWGc2VXtFERXNT33zAKviiLT6QXg7U2LNas7pe4qQ@mail.gmail.com>
Subject: Re: [RFC PATCH] scsi: mpi3mr: add remove host in mpi3mr_shutdown
To: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	Narayan Kittur <narayan.kittur@broadcom.com>, Jens Axboe <axboe@kernel.dk>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I discussed this with Narayan and we had some disagreements.
Narayan said he had not encountered this problem on other OS distributions.
I am not sure if this problem is related to the OS.
IMO, during reboot, io may still be sent to the driver unless the driver
calls the block layer interface to stop or destroy the request queue.
During the reboot process, the OS or other modules of the kernel cannot
prevent io from being sent to the driver, and the driver needs to handle
this situation.
So I sent a CC to block layer email list, wanting to confirm whether my
opinion was correct.

Fengnan Chang <changfengnan@bytedance.com> =E4=BA=8E2025=E5=B9=B45=E6=9C=88=
26=E6=97=A5=E5=91=A8=E4=B8=80 19:22=E5=86=99=E9=81=93=EF=BC=9A
>
> When we do reboot test, we found the following issue:
> [ 1524.234267] sd 0:0:2:0: [sdc] Synchronizing SCSI cache
> [ 1524.234491] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> [ 1524.234726] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 1524.235568] mpi3mr0: issuing message unit reset(MUR)
> [ 1524.545409] mpi3mr0: ioc_status/ioc_config after successful message un=
it reset is (0x10)/(0x470000)
> [ 1524.753407] mpi3mr0: ioc_status/ioc_config after successful shutdown i=
s (0x8)/(0x472000)
> [ 1526.002436] BUG: unable to handle page fault for address: 000000000000=
1090
> [ 1526.002454] #PF: supervisor write access in kernel mode
> [ 1526.002463] #PF: error_code(0x0002) - not-present page
> [ 1526.002470] PGD 0 P4D 0
> [ 1526.002476] Oops: 0002 [#1] SMP NOPTI
> [ 1526.002483] CPU: 17 PID: 2800 Comm: kworker/17:1H Kdump: loaded Tainte=
d: G S         OE     5.15.152-amd64 #5.15.152
> [ 1526.002497] Hardware name: ByteDance ByteDance System/ByteDance System
> [ 1526.002507] Workqueue: kblockd blk_mq_requeue_work
> [ 1526.002517] RIP: 0010:mpi3mr_op_request_post+0x1bf/0x290 [mpi3mr]
> [ 1526.002531] Code: ca f0 0f c1 42 2c 83 c0 01 83 f8 08 7f 3d f0 41 ff 8=
6 dc 1e 00 00 49 8b 86 80 00 00 00 48 8d 94 d8 08 10 00 00 41 0f b7 47 02 <=
89> 02 31 db 48 8b 34 24 4c 89 e7 e8 51 85 8e c5 48 83 c4 18 89 d8
> [ 1526.002551] RSP: 0018:ffff9a6244083bd8 EFLAGS: 00010003
> [ 1526.002558] RAX: 0000000000000168 RBX: 0000000000000011 RCX: 000000000=
0000440
> [ 1526.002567] RDX: 0000000000001090 RSI: 0000000000000000 RDI: ffff8af52=
8c4e400
> [ 1526.002576] RBP: 0000000000000080 R08: 000000000000001b R09: ffff8af52=
8c4e380
> [ 1526.002584] R10: 0000000000000000 R11: 0000000000000168 R12: ffff8af54=
31c6560
> [ 1526.002593] R13: 0000000000000167 R14: ffff8af51aed87f0 R15: ffff8af54=
31c6550
> [ 1526.002602] FS:  0000000000000000(0000) GS:ffff8b726fe40000(0000) knlG=
S:0000000000000000
> [ 1526.002611] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1526.002619] CR2: 0000000000001090 CR3: 0000000255a04006 CR4: 000000000=
0770ee0
> [ 1526.002628] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [ 1526.002637] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 000000000=
0000400
> [ 1526.002646] PKRU: 55555554
> [ 1526.002650] Call Trace:
> [ 1526.002655]  <TASK>
> [ 1526.002660]  ? __die_body+0x1a/0x60
> [ 1526.002668]  ? page_fault_oops+0x131/0x270
> [ 1526.002675]  ? update_group_capacity+0x25/0x1b0
> [ 1526.002684]  ? exc_page_fault+0x79/0x160
> [ 1526.002692]  ? asm_exc_page_fault+0x22/0x30
> [ 1526.002700]  ? mpi3mr_op_request_post+0x1bf/0x290 [mpi3mr]
> [ 1526.002711]  ? mpi3mr_op_request_post+0xe2/0x290 [mpi3mr]
> [ 1526.002721]  mpi3mr_qcmd+0x43b/0xc10 [mpi3mr]
> [ 1526.002730]  ? scsi_init_command+0x102/0x160 [scsi_mod]
> [ 1526.002746]  ? ktime_get+0x3b/0xa0
> [ 1526.002753]  scsi_queue_rq+0x375/0xa60 [scsi_mod]
> [ 1526.002765]  blk_mq_dispatch_rq_list+0x13f/0x810
> [ 1526.002774]  __blk_mq_sched_dispatch_requests+0xb4/0x140
> [ 1526.002782]  blk_mq_sched_dispatch_requests+0x30/0x60
> [ 1526.002790]  __blk_mq_run_hw_queue+0x2b/0x60
> [ 1526.002798]  __blk_mq_delay_run_hw_queue+0x13a/0x160
> [ 1526.002806]  blk_mq_run_hw_queues+0x45/0xc0
> [ 1526.002813]  blk_mq_requeue_work+0x159/0x180
> [ 1526.002819]  process_one_work+0x1ce/0x370
> [ 1526.003004]  ? process_one_work+0x370/0x370
> [ 1526.003183]  worker_thread+0x30/0x380
> [ 1526.003359]  ? process_one_work+0x370/0x370
> [ 1526.003573]  kthread+0xc0/0xe0
> [ 1526.003794]  ? __kthread_cancel_work+0x40/0x40
> [ 1526.004015]  ret_from_fork+0x1f/0x30
>
> After my analysis, I think it is like this:
> When the machine reboots, the shutdown function of all devices will
> be called.
> In mpi3mr_shutdown, the mpi3mr driver releases related resources when
> shutting down the device, but does not quiesce or destroy the request_que=
ue
> in block layer, which leads to the possibility that io may still be issue=
d
> to mpi3mr driver, and when the mpi3mr driver try to processes io, it's
> possible to access the released resources.
> So add remove scsi&sas host in mpi3mr_shutdown to destroy request_queue.
>
> BTW, the above call trace log is reproduced on Debian+ 5.15.152 kernel
> using the mpi3mr 8.12 driver version, but this issue still exist in the
> upstream version.
>
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index c186b892150f..443430d51603 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -5603,6 +5603,11 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
>         if (wq)
>                 destroy_workqueue(wq);
>
> +       if (mrioc->sas_transport_enabled)
> +               sas_remove_host(shost);
> +       else
> +               scsi_remove_host(shost);
> +
>         mpi3mr_stop_watchdog(mrioc);
>         mpi3mr_cleanup_ioc(mrioc);
>         mpi3mr_cleanup_resources(mrioc);
> --
> 2.39.2 (Apple Git-143)
>
