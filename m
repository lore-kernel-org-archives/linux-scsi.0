Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21ADC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 14:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347488AbiBCOpC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 09:45:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349279AbiBCOo7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 09:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643899499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q5J7ln4tjFQ52Wj4ZsKlhn/+YtsC2/vtNRNBmhcC5eU=;
        b=cKgHWCAMrZGh95JhjD00hpOqb2F3JVCiXy+6/fxUUcCaQKTo9YLyRmEezbYT4gB4QtRMej
        fPgLSIpXtAeThMb5NxRn3xRkF6ui64XUd51DY0IXEPi53vvC2/7xyF/c+LHzI67tI5YZYe
        lg++CH44p8mFmTgP9WKIk1N6VbX3Ntk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-dVb4gbMEPqmYocvvcAToOQ-1; Thu, 03 Feb 2022 09:44:57 -0500
X-MC-Unique: dVb4gbMEPqmYocvvcAToOQ-1
Received: by mail-lj1-f199.google.com with SMTP id f13-20020a2ea0cd000000b00243de4301e4so520740ljm.5
        for <linux-scsi@vger.kernel.org>; Thu, 03 Feb 2022 06:44:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q5J7ln4tjFQ52Wj4ZsKlhn/+YtsC2/vtNRNBmhcC5eU=;
        b=wZtc/oD2dfZ70b4YThidvYIBOT2aC3ZlfmsFz3SGsdKsmxYPmS/beprHazQzPAnNmY
         V6bo8X5KW0slKHYMW/hCx7UeaRmftLqB+H4fcsl2UGe4XHlduoU0Hrt22JPABCKpZcX8
         cHAX5GOP8jgupnFSpJ64VyHkUizQIRPBMhEwzMt/+lBprE1Z/IWE1wU1kCRYLzmJunBI
         h0LXfQnDBT1TDdOmtrsi0h27zRhbfuRUh//eSVM68/CPEXbYFcoY4Ym+J8WitRY7cdTB
         U39psRGoiKmGeA6OfO06OE2A4TBOcb0ZvvupTVXKjfWx8Gg3k5l0nfkIf02ZBAXFpdxe
         +0nQ==
X-Gm-Message-State: AOAM5313XcQmL2dNs2p0DcCKbJycZ7DbzLwNGm/WeGXI7t3yzIDSPUyZ
        YJ+by472wbuo8hnTbQgiPO9+JWgV8HDFzomXr8cE8GuO9wfc3U0Zx27+K+wm8AFZpRjKBOkmDkD
        B9OMzm4BpGwlICK+xih/ntn1HKYjtvLTQgiE5RQ==
X-Received: by 2002:a2e:7c10:: with SMTP id x16mr23196400ljc.482.1643899495244;
        Thu, 03 Feb 2022 06:44:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEoclEMYZ/L9ovxvoG7URe15awOCzHXVjDTvZBibty0RXW5ugY4bnvGuxBdSUSdRBg2ql+FY6UHQwfwBiUCio=
X-Received: by 2002:a2e:7c10:: with SMTP id x16mr23196375ljc.482.1643899494493;
 Thu, 03 Feb 2022 06:44:54 -0800 (PST)
MIME-Version: 1.0
References: <20220110050218.3958-1-njavali@marvell.com> <20220110050218.3958-3-njavali@marvell.com>
In-Reply-To: <20220110050218.3958-3-njavali@marvell.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Thu, 3 Feb 2022 09:44:43 -0500
Message-ID: <CAGtn9rkP7oUW8T8cjia6V-cq9tat=Pzifmcw+jPmi7juCpLL7g@mail.gmail.com>
Subject: Re: [PATCH v2 02/17] qla2xxx: Implement ref count for srb
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This commit causes at least 2 of our systems with Qlogic HBAs to panic on boot:
From the look of it, it is possible that a timer was left active on a
freed object or something.

[   44.232603] general protection fault, probably for non-canonical
address 0xdead00000000012a: 0000 [#1] PR
[   44.247211] CPU: 9 PID: 0 Comm: swapper/9 Tainted: G          I
  5.17.0-rc1 #4
[   44.254870] Hardware name: Dell Inc. PowerEdge R440/0WKGTH, BIOS
1.4.8 05/22/2018
[   44.262349] RIP: 0010:__run_timers.part.0+0x19c/0x260
[   44.267411] Code: 00 48 8b 03 49 c7 47 08 00 00 00 00 48 85 c0 74
61 48 8b 2b 49 89 6f 08 66 90 48 8b 45
[   44.286156] RSP: 0018:ffffb0a7803ecef0 EFLAGS: 00010086
[   44.291383] RAX: dead000000000122 RBX: ffffb0a7803ecf00 RCX: 0000000000000009
[   44.298515] RDX: ffffb0a7803ecf00 RSI: ffff91dad1060380 RDI: ffff91dad10603a8
[   44.305646] RBP: ffff91cfe34c8c10 R08: 0000000000000000 R09: 0000000000000000
[   44.312780] R10: 0000000000000002 R11: 00000000000000ca R12: 00000000fffc1200
[   44.319911] R13: dead000000000122 R14: 0000000000000001 R15: ffff91dad1060380
[   44.327045] FS:  0000000000000000(0000) GS:ffff91dad1040000(0000)
knlGS:0000000000000000
[   44.335131] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   44.340877] CR2: 00007ff966417870 CR3: 00000002db010004 CR4: 00000000007706e0
[   44.348010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   44.355143] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   44.362274] PKRU: 55555554
[   44.364987] Call Trace:
[   44.367442]  <IRQ>
[   44.369460]  ? tick_sched_timer+0x6d/0x80
[   44.373472]  ? _raw_spin_lock_irq+0x14/0x40
[   44.377658]  ? __hrtimer_run_queues+0x139/0x2c0
[   44.382190]  ? recalibrate_cpu_khz+0x10/0x10
[   44.386464]  run_timer_softirq+0x31/0x60
[   44.390391]  __do_softirq+0xf6/0x2fb
[   44.393968]  __irq_exit_rcu+0xe2/0x130
[   44.397720]  sysvec_apic_timer_interrupt+0xa2/0xd0
[   44.402514]  </IRQ>
[   44.404619]  <TASK>
[   44.406725]  asm_sysvec_apic_timer_interrupt+0x12/0x20


-Ewan

On Mon, Jan 10, 2022 at 12:03 AM Nilesh Javali <njavali@marvell.com> wrote:
>
> From: Saurav Kashyap <skashyap@marvell.com>
>
> The timeout handler and done function are racing. When
> qla2x00_async_iocb_timeout() starts to run it can be preempted by the
> normal response path (via the firmware?). qla24xx_async_gpsc_sp_done()
> releases the SRB unconditionally. When scheduling back to
> qla2x00_async_iocb_timeout() qla24xx_async_abort_cmd() will access an
> freed sp->qpair pointer:
>
>   qla2xxx [0000:83:00.0]-2871:0: Async-gpsc timeout - hdl=63d portid=234500 50:06:0e:80:08:77:b6:21.
>   qla2xxx [0000:83:00.0]-2853:0: Async done-gpsc res 0, WWPN 50:06:0e:80:08:77:b6:21
>   qla2xxx [0000:83:00.0]-2854:0: Async-gpsc OUT WWPN 20:45:00:27:f8:75:33:00 speeds=2c00 speed=0400.
>   qla2xxx [0000:83:00.0]-28d8:0: qla24xx_handle_gpsc_event 50:06:0e:80:08:77:b6:21 DS 7 LS 6 rc 0 login 1|1 rscn 1|0 lid 5
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>   IP: qla24xx_async_abort_cmd+0x1b/0x1c0 [qla2xxx]
>
> Obvious solution to this is to introduce a reference counter. One
> reference is taken for the normal code path (the 'good case') and one
> for the timeout path. As we always race between the normal good case
> and the timeout/abort handler we need to serialize it. Also we cannot
> assume any order between the handlers. Since this is slow path we can
> use proper synchronization via locks.
>
> When we are able to cancel a timer (del_timer returns 1) we know there
> can't be any error handling in progress because the timeout handler
> hasn't expired yet, thus we can safely decrement the refcounter by one.
>
> If we are not able to cancel the timer, we know an abort handler is
> running. We have to make sure we call sp->done() in the abort handlers
> before calling kref_put().
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
> v1->v2:
> - update detailed issue description and the solution
>
>  drivers/scsi/qla2xxx/qla_bsg.c    |  6 ++-
>  drivers/scsi/qla2xxx/qla_def.h    |  5 ++
>  drivers/scsi/qla2xxx/qla_edif.c   |  3 +-
>  drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
>  drivers/scsi/qla2xxx/qla_gs.c     | 85 +++++++++++++++++++++----------
>  drivers/scsi/qla2xxx/qla_init.c   | 70 +++++++++++++++++--------
>  drivers/scsi/qla2xxx/qla_inline.h |  2 +
>  drivers/scsi/qla2xxx/qla_iocb.c   | 41 +++++++++++----
>  drivers/scsi/qla2xxx/qla_mbx.c    |  4 +-
>  drivers/scsi/qla2xxx/qla_mid.c    |  4 +-
>  drivers/scsi/qla2xxx/qla_mr.c     |  4 +-
>  drivers/scsi/qla2xxx/qla_os.c     | 14 +++--
>  drivers/scsi/qla2xxx/qla_target.c |  4 +-
>  13 files changed, 173 insertions(+), 70 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 9da8034ccad4..c2f00f076f79 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -29,7 +29,8 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
>             "%s: sp hdl %x, result=%x bsg ptr %p\n",
>             __func__, sp->handle, res, bsg_job);
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>
>         bsg_reply->result = res;
>         bsg_job_done(bsg_job, bsg_reply->result,
> @@ -3013,7 +3014,8 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
>
>  done:
>         spin_unlock_irqrestore(&ha->hardware_lock, flags);
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         return 0;
>  }
>
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 9ebf4a234d9a..a5fc01b4fa96 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -726,6 +726,11 @@ typedef struct srb {
>          * code.
>          */
>         void (*put_fn)(struct kref *kref);
> +
> +       /*
> +        * Report completion for asynchronous commands.
> +        */
> +       void (*async_done)(struct srb *sp, int res);
>  } srb_t;
>
>  #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 53d2b8562027..c04957c363d8 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -2146,7 +2146,8 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
>
>  static void qla_noop_sp_done(srb_t *sp, int res)
>  {
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  /*
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 5056564f0d0c..3f8b8bbabe6d 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -333,6 +333,7 @@ extern int qla24xx_get_one_block_sg(uint32_t, struct qla2_sgx *, uint32_t *);
>  extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
>  extern int qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha,
>         struct qla_work_evt *e);
> +void qla2x00_sp_release(struct kref *kref);
>
>  /*
>   * Global Function Prototypes in qla_mbx.c source file.
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index 744eb3192056..a812f4a45232 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -529,7 +529,6 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int rc)
>                 if (!e)
>                         goto err2;
>
> -               del_timer(&sp->u.iocb_cmd.timer);
>                 e->u.iosb.sp = sp;
>                 qla2x00_post_work(vha, e);
>                 return;
> @@ -556,8 +555,8 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int rc)
>                         sp->u.iocb_cmd.u.ctarg.rsp = NULL;
>                 }
>
> -               sp->free(sp);
> -
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                 return;
>         }
>
> @@ -592,6 +591,7 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
>         if (!vha->flags.online)
>                 goto done;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -652,7 +652,8 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
>         }
>         return rval;
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> @@ -687,6 +688,7 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
>         srb_t *sp;
>         struct ct_sns_pkt *ct_sns;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -747,7 +749,8 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> @@ -777,6 +780,7 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
>         srb_t *sp;
>         struct ct_sns_pkt *ct_sns;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -836,7 +840,8 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> @@ -882,6 +887,7 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
>         srb_t *sp;
>         struct ct_sns_pkt *ct_sns;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -947,7 +953,8 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> @@ -2887,7 +2894,8 @@ static void qla24xx_async_gpsc_sp_done(srb_t *sp, int res)
>         qla24xx_handle_gpsc_event(vha, &ea);
>
>  done:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
> @@ -2899,6 +2907,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
>         if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
>                 return rval;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -2938,7 +2947,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> @@ -2987,7 +2997,8 @@ void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *sp)
>                 break;
>         }
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
> @@ -3126,13 +3137,15 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
>         if (res) {
>                 if (res == QLA_FUNCTION_TIMEOUT) {
>                         qla24xx_post_gpnid_work(sp->vha, &ea.id);
> -                       sp->free(sp);
> +                       /* ref: INIT */
> +                       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                         return;
>                 }
>         } else if (sp->gen1) {
>                 /* There was another RSCN for this Nport ID */
>                 qla24xx_post_gpnid_work(sp->vha, &ea.id);
> -               sp->free(sp);
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                 return;
>         }
>
> @@ -3153,7 +3166,8 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
>                                   sp->u.iocb_cmd.u.ctarg.rsp_dma);
>                 sp->u.iocb_cmd.u.ctarg.rsp = NULL;
>
> -               sp->free(sp);
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                 return;
>         }
>
> @@ -3173,6 +3187,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
>         if (!vha->flags.online)
>                 goto done;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -3189,7 +3204,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
>                 if (tsp->u.iocb_cmd.u.ctarg.id.b24 == id->b24) {
>                         tsp->gen1++;
>                         spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> -                       sp->free(sp);
> +                       /* ref: INIT */
> +                       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                         goto done;
>                 }
>         }
> @@ -3259,8 +3275,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
>                         sp->u.iocb_cmd.u.ctarg.rsp_dma);
>                 sp->u.iocb_cmd.u.ctarg.rsp = NULL;
>         }
> -
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> @@ -3315,7 +3331,8 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
>         ea.rc = res;
>
>         qla24xx_handle_gffid_event(vha, &ea);
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  /* Get FC4 Feature with Nport ID. */
> @@ -3328,6 +3345,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
>         if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
>                 return rval;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 return rval;
> @@ -3366,7 +3384,8 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
>
>         return rval;
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         fcport->flags &= ~FCF_ASYNC_SENT;
>         return rval;
>  }
> @@ -3753,7 +3772,6 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
>             "Async done-%s res %x FC4Type %x\n",
>             sp->name, res, sp->gen2);
>
> -       del_timer(&sp->u.iocb_cmd.timer);
>         sp->rc = res;
>         if (res) {
>                 unsigned long flags;
> @@ -3921,8 +3939,8 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
>                     sp->u.iocb_cmd.u.ctarg.rsp_dma);
>                 sp->u.iocb_cmd.u.ctarg.rsp = NULL;
>         }
> -
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>
>         spin_lock_irqsave(&vha->work_lock, flags);
>         vha->scan.scan_flags &= ~SF_SCANNING;
> @@ -3974,9 +3992,12 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>                 ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
>                     "%s: Performing FCP Scan\n", __func__);
>
> -               if (sp)
> -                       sp->free(sp); /* should not happen */
> +               if (sp) {
> +                       /* ref: INIT */
> +                       kref_put(&sp->cmd_kref, qla2x00_sp_release);
> +               }
>
> +               /* ref: INIT */
>                 sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>                 if (!sp) {
>                         spin_lock_irqsave(&vha->work_lock, flags);
> @@ -4021,6 +4042,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>                             sp->u.iocb_cmd.u.ctarg.req,
>                             sp->u.iocb_cmd.u.ctarg.req_dma);
>                         sp->u.iocb_cmd.u.ctarg.req = NULL;
> +                       /* ref: INIT */
>                         qla2x00_rel_sp(sp);
>                         return rval;
>                 }
> @@ -4083,7 +4105,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>                 sp->u.iocb_cmd.u.ctarg.rsp = NULL;
>         }
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>
>         spin_lock_irqsave(&vha->work_lock, flags);
>         vha->scan.scan_flags &= ~SF_SCANNING;
> @@ -4147,7 +4170,8 @@ static void qla2x00_async_gnnid_sp_done(srb_t *sp, int res)
>
>         qla24xx_handle_gnnid_event(vha, &ea);
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
> @@ -4160,6 +4184,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
>                 return rval;
>
>         qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
>         if (!sp)
>                 goto done;
> @@ -4200,7 +4225,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         fcport->flags &= ~FCF_ASYNC_SENT;
>  done:
>         return rval;
> @@ -4274,7 +4300,8 @@ static void qla2x00_async_gfpnid_sp_done(srb_t *sp, int res)
>
>         qla24xx_handle_gfpnid_event(vha, &ea);
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
> @@ -4286,6 +4313,7 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
>         if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
>                 return rval;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
>         if (!sp)
>                 goto done;
> @@ -4326,7 +4354,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index e6f13cb6fa28..38c11b75f644 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -51,6 +51,9 @@ qla2x00_sp_timeout(struct timer_list *t)
>         WARN_ON(irqs_disabled());
>         iocb = &sp->u.iocb_cmd;
>         iocb->timeout(sp);
> +
> +       /* ref: TMR */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  void qla2x00_sp_free(srb_t *sp)
> @@ -125,8 +128,13 @@ static void qla24xx_abort_iocb_timeout(void *data)
>         }
>         spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
>
> -       if (sp->cmd_sp)
> +       if (sp->cmd_sp) {
> +               /*
> +                * This done function should take care of
> +                * original command ref: INIT
> +                */
>                 sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
> +       }
>
>         abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
>         sp->done(sp, QLA_OS_TIMER_EXPIRED);
> @@ -140,11 +148,11 @@ static void qla24xx_abort_sp_done(srb_t *sp, int res)
>         if (orig_sp)
>                 qla_wait_nvme_release_cmd_kref(orig_sp);
>
> -       del_timer(&sp->u.iocb_cmd.timer);
>         if (sp->flags & SRB_WAKEUP_ON_COMP)
>                 complete(&abt->u.abt.comp);
>         else
> -               sp->free(sp);
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
> @@ -154,6 +162,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
>         srb_t *sp;
>         int rval = QLA_FUNCTION_FAILED;
>
> +       /* ref: INIT for ABTS command */
>         sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
>                                   GFP_ATOMIC);
>         if (!sp)
> @@ -181,7 +190,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
>
>         rval = qla2x00_start_sp(sp);
>         if (rval != QLA_SUCCESS) {
> -               sp->free(sp);
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                 return rval;
>         }
>
> @@ -189,7 +199,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
>                 wait_for_completion(&abt_iocb->u.abt.comp);
>                 rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
>                         QLA_SUCCESS : QLA_ERR_FROM_FW;
> -               sp->free(sp);
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         }
>
>         return rval;
> @@ -287,7 +298,8 @@ static void qla2x00_async_login_sp_done(srb_t *sp, int res)
>                 qla24xx_handle_plogi_done_event(vha, &ea);
>         }
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int
> @@ -306,6 +318,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
>                 return rval;
>         }
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -354,7 +367,8 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         fcport->flags &= ~FCF_ASYNC_SENT;
>  done:
>         fcport->flags &= ~FCF_ASYNC_ACTIVE;
> @@ -366,7 +380,8 @@ static void qla2x00_async_logout_sp_done(srb_t *sp, int res)
>         sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
>         sp->fcport->login_gen++;
>         qlt_logo_completion_handler(sp->fcport, sp->u.iocb_cmd.u.logio.data[0]);
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int
> @@ -376,6 +391,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
>         int rval = QLA_FUNCTION_FAILED;
>
>         fcport->flags |= FCF_ASYNC_SENT;
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -397,7 +413,8 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
>         return rval;
> @@ -423,7 +440,8 @@ static void qla2x00_async_prlo_sp_done(srb_t *sp, int res)
>         if (!test_bit(UNLOADING, &vha->dpc_flags))
>                 qla2x00_post_async_prlo_done_work(sp->fcport->vha, sp->fcport,
>                     lio->u.logio.data);
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int
> @@ -433,6 +451,7 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
>         int rval;
>
>         rval = QLA_FUNCTION_FAILED;
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -454,7 +473,8 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         fcport->flags &= ~FCF_ASYNC_ACTIVE;
>         return rval;
> @@ -539,8 +559,8 @@ static void qla2x00_async_adisc_sp_done(srb_t *sp, int res)
>         ea.sp = sp;
>
>         qla24xx_handle_adisc_event(vha, &ea);
> -
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int
> @@ -555,6 +575,7 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
>                 return rval;
>
>         fcport->flags |= FCF_ASYNC_SENT;
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -582,7 +603,8 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
>         qla2x00_post_async_adisc_work(vha, fcport, data);
> @@ -1063,7 +1085,8 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, int res)
>         }
>         spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
> @@ -1093,6 +1116,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
>         vha->gnl.sent = 1;
>         spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -1125,7 +1149,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         fcport->flags &= ~(FCF_ASYNC_ACTIVE | FCF_ASYNC_SENT);
>         return rval;
> @@ -1171,7 +1196,7 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, int res)
>         dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
>                 sp->u.iocb_cmd.u.mbx.in_dma);
>
> -       sp->free(sp);
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
> @@ -1216,7 +1241,7 @@ static void qla2x00_async_prli_sp_done(srb_t *sp, int res)
>                 qla24xx_handle_prli_done_event(vha, &ea);
>         }
>
> -       sp->free(sp);
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int
> @@ -1274,7 +1299,8 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         fcport->flags &= ~FCF_ASYNC_SENT;
>         return rval;
>  }
> @@ -1359,7 +1385,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
>         if (pd)
>                 dma_pool_free(ha->s_dma_pool, pd, pd_dma);
>
> -       sp->free(sp);
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         fcport->flags &= ~FCF_ASYNC_SENT;
>  done:
>         fcport->flags &= ~FCF_ASYNC_ACTIVE;
> @@ -1945,6 +1971,7 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
>         srb_t *sp;
>         int rval = QLA_FUNCTION_FAILED;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -1988,7 +2015,8 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
>         }
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         fcport->flags &= ~FCF_ASYNC_SENT;
>  done:
>         return rval;
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index 5f3b7995cc8f..db17f7f410cd 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -184,6 +184,8 @@ static void qla2xxx_init_sp(srb_t *sp, scsi_qla_host_t *vha,
>         sp->vha = vha;
>         sp->qpair = qpair;
>         sp->cmd_type = TYPE_SRB;
> +       /* ref : INIT - normal flow */
> +       kref_init(&sp->cmd_kref);
>         INIT_LIST_HEAD(&sp->elem);
>  }
>
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 95aae9a9631e..7dd82214d59f 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2560,6 +2560,14 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
>         }
>  }
>
> +void
> +qla2x00_sp_release(struct kref *kref)
> +{
> +       struct srb *sp = container_of(kref, struct srb, cmd_kref);
> +
> +       sp->free(sp);
> +}
> +
>  void
>  qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
>                      void (*done)(struct srb *sp, int res))
> @@ -2655,7 +2663,9 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
>                return -ENOMEM;
>         }
>
> -       /* Alloc SRB structure */
> +       /* Alloc SRB structure
> +        * ref: INIT
> +        */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp) {
>                 kfree(fcport);
> @@ -2687,7 +2697,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
>                             GFP_KERNEL);
>
>         if (!elsio->u.els_logo.els_logo_pyld) {
> -               sp->free(sp);
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                 return QLA_FUNCTION_FAILED;
>         }
>
> @@ -2710,7 +2721,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
>
>         rval = qla2x00_start_sp(sp);
>         if (rval != QLA_SUCCESS) {
> -               sp->free(sp);
> +               /* ref: INIT */
> +               kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                 return QLA_FUNCTION_FAILED;
>         }
>
> @@ -2721,7 +2733,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
>
>         wait_for_completion(&elsio->u.els_logo.comp);
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         return rval;
>  }
>
> @@ -2854,7 +2867,6 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
>             sp->name, res, sp->handle, fcport->d_id.b24, fcport->port_name);
>
>         fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
> -       del_timer(&sp->u.iocb_cmd.timer);
>
>         if (sp->flags & SRB_WAKEUP_ON_COMP)
>                 complete(&lio->u.els_plogi.comp);
> @@ -2964,7 +2976,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
>                         struct srb_iocb *elsio = &sp->u.iocb_cmd;
>
>                         qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
> -                       sp->free(sp);
> +                       /* ref: INIT */
> +                       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>                         return;
>                 }
>                 e->u.iosb.sp = sp;
> @@ -2982,7 +2995,9 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
>         int rval = QLA_SUCCESS;
>         void    *ptr, *resp_ptr;
>
> -       /* Alloc SRB structure */
> +       /* Alloc SRB structure
> +        * ref: INIT
> +        */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp) {
>                 ql_log(ql_log_info, vha, 0x70e6,
> @@ -3071,7 +3086,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
>  out:
>         fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
>         qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> @@ -3882,8 +3898,15 @@ qla2x00_start_sp(srb_t *sp)
>                 break;
>         }
>
> -       if (sp->start_timer)
> +       if (sp->start_timer) {
> +               /* ref: TMR timer ref
> +                * this code should be just before start_iocbs function
> +                * This will make sure that caller function don't to do
> +                * kref_put even on failure
> +                */
> +               kref_get(&sp->cmd_kref);
>                 add_timer(&sp->u.iocb_cmd.timer);
> +       }
>
>         wmb();
>         qla2x00_start_iocbs(vha, qp->req);
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 2aacd3653245..38e0f02c75e1 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6479,6 +6479,7 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
>         if (!vha->hw->flags.fw_started)
>                 goto done;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -6524,7 +6525,8 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
>         }
>
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index c4a967c96fd6..e6b5c4ccce97 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -965,6 +965,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>         if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
>                 return QLA_PARAMETER_ERROR;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
>         if (!sp)
>                 return rval;
> @@ -1007,6 +1008,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>                 break;
>         }
>  done:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         return rval;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
> index e3ae0894c7a8..f726eb8449c5 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -1787,6 +1787,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
>         struct register_host_info *preg_hsi;
>         struct new_utsname *p_sysid = NULL;
>
> +       /* ref: INIT */
>         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
>         if (!sp)
>                 goto done;
> @@ -1973,7 +1974,8 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
>                 dma_free_coherent(&ha->pdev->dev, fdisc->u.fxiocb.req_len,
>                     fdisc->u.fxiocb.req_addr, fdisc->u.fxiocb.req_dma_handle);
>  done_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         return rval;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index abcd30917263..0a7b00d165c7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -728,7 +728,8 @@ void qla2x00_sp_compl(srb_t *sp, int res)
>         struct scsi_cmnd *cmd = GET_CMD_SP(sp);
>         struct completion *comp = sp->comp;
>
> -       sp->free(sp);
> +       /* kref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         cmd->result = res;
>         CMD_SP(cmd) = NULL;
>         scsi_done(cmd);
> @@ -819,7 +820,8 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>         struct scsi_cmnd *cmd = GET_CMD_SP(sp);
>         struct completion *comp = sp->comp;
>
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>         cmd->result = res;
>         CMD_SP(cmd) = NULL;
>         scsi_done(cmd);
> @@ -919,6 +921,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>                 goto qc24_target_busy;
>
>         sp = scsi_cmd_priv(cmd);
> +       /* ref: INIT */
>         qla2xxx_init_sp(sp, vha, vha->hw->base_qpair, fcport);
>
>         sp->u.scmd.cmd = cmd;
> @@ -938,7 +941,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>         return 0;
>
>  qc24_host_busy_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>
>  qc24_target_busy:
>         return SCSI_MLQUEUE_TARGET_BUSY;
> @@ -1008,6 +1012,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
>                 goto qc24_target_busy;
>
>         sp = scsi_cmd_priv(cmd);
> +       /* ref: INIT */
>         qla2xxx_init_sp(sp, vha, qpair, fcport);
>
>         sp->u.scmd.cmd = cmd;
> @@ -1026,7 +1031,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
>         return 0;
>
>  qc24_host_busy_free_sp:
> -       sp->free(sp);
> +       /* ref: INIT */
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>
>  qc24_target_busy:
>         return SCSI_MLQUEUE_TARGET_BUSY;
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 83c8c55017d1..b0990f2ee91c 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -620,7 +620,7 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
>         }
>         spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
>
> -       sp->free(sp);
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  }
>
>  int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
> @@ -672,7 +672,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
>         return rval;
>
>  done_free_sp:
> -       sp->free(sp);
> +       kref_put(&sp->cmd_kref, qla2x00_sp_release);
>  done:
>         fcport->flags &= ~FCF_ASYNC_SENT;
>         return rval;
> --
> 2.23.1
>

