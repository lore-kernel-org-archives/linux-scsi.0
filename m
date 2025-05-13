Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED1549620
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747162853; cv=none; b=M/erlzE4pfUKELq7KQxUxYgkkNO7wfoKE22rB13ZZ0hV9jnvLMQah70LLcfoqxkiOn3TVGsdY2XeczgeuAw5O0tXrN/L9qviFoPWvKgDqIQb8zPnPYFctot5HpJvqb+Cl/dwLQGy3EwzZn9a7kSBnJ2NfBQP+iho0jJXXOORHUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747162853; c=relaxed/simple;
	bh=M4+9RD18/zXOu/etGZGkDEvhcKUDpM2gBTMbL9UT9NQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HgiRh3dBy8jTX+0bS614SV9Lll+Q1GpWUApqRo/eVA5Y4Mzh4QsrReTCilit/Mn7ZLj75sJEoaJLBeqfUm4uEG7xXp6KXW5YFTzOuCEC1FBVqSI6WYL3u3YfvA1rV2NtQ307nYGyGIwIzZi9cPEv73pPfzpSbTlwIZVUMjOZbTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rlahlFo3; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rlahlFo3"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-47666573242so67961cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 12:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747162851; x=1747767651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4cUc9T2sHnhCYBHfb8AJ1s8PRRU4wPBZSZvKKfXSRps=;
        b=rlahlFo3wX/2UmqQ5dXgo3HosHbtBmxmdohIjQPSEd3P3uPcR8ka16ejnwG8sangm7
         kZDFtfAMan4ILmTMJIWlF38+/ddEKSJ9/WzsjRz+w89/RWAibP6tUIrxYQzx9B+Cqi4/
         NxthpJA/IVvIJZ7+9JRbsMbt1cAfaANJ5f97ZkN2Cb7VHUskpp4+Y/lSmNdj1BR8j6Jg
         Onvqfgj0DKzguc7VNdXEVGO3YsVFA9IGQSDWj89D9AAKXqFOwVONvyKb86cHtHDAE76i
         TsyN6yFnVwTS/WDEnV3nFlOG5Gi+e718he87SHY03cucyb0IGlQTCQ0wWZj6uYDkGVgh
         bWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747162851; x=1747767651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4cUc9T2sHnhCYBHfb8AJ1s8PRRU4wPBZSZvKKfXSRps=;
        b=f1x/Rq5Lcg9p2j4v6ISqHel1iC9oU1hiOnhfgxJBThjUUk4Qc4n3L8LbIhmOrK3b3T
         /FhdC9f/qhPLBhvltQqrsWZQHVPugJC2G69k/pOTQiwgxDazdPtMvhshxdPdVwPVlmVD
         2tntsXgEBITyKWlw8dbwnpeNx/4Xylxj7bP9e3+FFXWt1MRI3uFcrL0w6QKfE0p00BVV
         pvBEdaoDkWJlCCXE8+qy63vA6opaYtPHAQ1FYtRwHbOA/4vQmjUM3j4aVe+gjDl1GCsL
         XmP+FJpMGdf7YEITHuUF1MTSewbpI4l/UiYLJfiToD5igo0c4cY1d5k7LPVo29OWIVLv
         gwsA==
X-Gm-Message-State: AOJu0Yy0UDcVGQcQHbM0hM4KK+qrXoiiBWUKUo0Il/xciNqxUbWChEl2
	R76YFMUE5hK8xGPuDDHtTCpIhfmSNSUFFOo76UfjJGy0fmMdLJllHnL3rxLtZeRFNoUFaCuJjb+
	eE4eOy+OrcCohBzDPBw+ea2FNLIxrmPh4h7I+oFZM
X-Gm-Gg: ASbGncsU5COhVe9zA6wySqEptHNoMxC4atJVzEZMmzEx5WxzV7TD7XqpfqMj9faN3cF
	+ke1VB5QDSGe7ihOYbopAj0sQbASHPWu4q/KfkCNisit/geuWcVBDsDYKf78tH05O/9EkQHcx2C
	jJjT7W55jOU1O+otzJJfvkqYEXbMKF8wwbCeVT1dMHirF3cisK2VFOra2fX2k=
X-Google-Smtp-Source: AGHT+IHIKxFKnYmT7IGRz0JawhPrOlYLXAymk6k9Ex2k3r1NtbxvtVMqrroa2IFQgSnZ6itwt7r5Ft9gYT/iBifR14Q=
X-Received: by 2002:a05:622a:1985:b0:48a:42fa:78fa with SMTP id
 d75a77b69052e-494960f071emr529341cf.2.1747162850152; Tue, 13 May 2025
 12:00:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422181729.2792081-1-salomondush@google.com>
In-Reply-To: <20250422181729.2792081-1-salomondush@google.com>
From: Salomon Dushimirimana <salomondush@google.com>
Date: Tue, 13 May 2025 12:00:39 -0700
X-Gm-Features: AX0GCFt8Xij1w9xEGbNc7rpNW3CsAjKZFjw-fsARhcPUzW4tP9lQ7Ibj2FTl6sU
Message-ID: <CAPE3x14-Tsm-2ThihT3a=h9a0L9Vi8J4BbiZiTV6=6Ctc1xryg@mail.gmail.com>
Subject: Re: [PATCH] scsi: Add SCSI error events, sent as kobject uevents by mid-layer
To: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James and Martin

I wanted to follow up on this patch! It's a decently sized patch, so
it might take some time, but I'd love to hear your thoughts and
address any feedback!!

Thank you,
Salomon Dushimirimana

Salomon Dushimirimana


On Tue, Apr 22, 2025 at 11:17=E2=80=AFAM Salomon Dushimirimana
<salomondush@google.com> wrote:
>
> Adds a new function scsi_emit_error(), called when a command is placed
> back on the command queue for retry by the error handler, or when a
> command completes.
>
> The scsi_emit_error() function uses the kobject_uevent_env() mechanism
> to emit a KOBJ_CHANGE event with details about the SCSI error.
>
> The event has the following key/value pairs set in the environment:
> - SDEV_ERROR: Always set to 1, to distinguish disk errors
>   from media change events, which have SDEV_MEDIA_CHANGE=3D1
> - SDEV_ERROR_RETRY: 0 if this is an error in the completion
>   path in scsi_io_completion(), 1 if the command is going to be
>   placed back on the queue
> - SDEV_ERROR_RESULT: Host byte of result code
> - SDEV_ERROR_SK: Sense key
> - SDEV_ERROR_ASC: Additional sense code
> - SDEV_ERROR_ASCQ: Additional sense code qualifier
>
> Error events are filtered under specific conditions:
> - DID_BAD_TARGET: Avoids uevent storms if a removed device is repeatedly
>   accessed and is not responding.
> - DID_IMM_RETRY: Avoids reporting temporary transport errors where the
>   command is immediately retried. This is a temporary error that should
>   not be forwarded to userspace.
>
> scsi_emit_error() can be invoked from vairous atomic contexts, where
> sleeping is not permitted, so GFP_ATOMIC is used to ensure allocations
> can safely occur in these contexts.
>
> A per-device ratelimiting mechanism is added to prevent flooding
> userspace during persistent error conditions. The ratelimit is checked
> before scheduling the event work.
>
> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> ---
>  drivers/scsi/Kconfig       |  17 +++++++
>  drivers/scsi/scsi_error.c  |  66 ++++++++++++++++++++++++
>  drivers/scsi/scsi_lib.c    | 100 ++++++++++++++++++++++++++++++++-----
>  drivers/scsi/scsi_priv.h   |   1 +
>  drivers/scsi/scsi_scan.c   |   4 ++
>  drivers/scsi/scsi_sysfs.c  |   2 +
>  include/scsi/scsi_device.h |  22 +++++++-
>  7 files changed, 199 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 5a3c670aec27d..36a156ad6afd2 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -240,6 +240,23 @@ config SCSI_SCAN_ASYNC
>           Note that this setting also affects whether resuming from
>           system suspend will be performed asynchronously.
>
> +config SCSI_ERROR_UEVENT
> +       bool "Enable SCSI error uevent reporting"
> +       depends on SCSI
> +       default n
> +       help
> +         If enabled, the SCSI mid-layer will emit kobject uevents when
> +         SCSI commands fail or are retried by the error handler. These
> +         events provide details about the error, including the command
> +         result (host byte), sense key (SK), additional sense code (ASC)=
,
> +         additional sense code qualifier (ASCQ), and whether the command
> +         is being retried (SDEV_ERROR_RETRY=3D1) or finally failing beca=
use
> +         of error in completion path (SDEV_ERROR_RETRY=3D0).
> +
> +         Events are filtered for certain conditions (e.g., DID_BAD_TARGE=
T,
> +         DID_IMM_RETRY) and are also ratelimited per device to prevent
> +         excessive noise.
> +
>  config SCSI_PROTO_TEST
>         tristate "scsi_proto.h unit tests" if !KUNIT_ALL_TESTS
>         depends on SCSI && KUNIT
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 376b8897ab90a..327a012f328ff 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2227,6 +2227,9 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
>                                 scmd_printk(KERN_INFO, scmd,
>                                              "%s: flush retry cmd\n",
>                                              current->comm));
> +#ifdef CONFIG_SCSI_ERROR_UEVENT
> +                               scsi_emit_error(scmd);
> +#endif
>                                 scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_R=
ETRY);
>                                 blk_mq_kick_requeue_list(sdev->request_qu=
eue);
>                 } else {
> @@ -2595,3 +2598,66 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffe=
r, int sb_len,
>         }
>  }
>  EXPORT_SYMBOL(scsi_get_sense_info_fld);
> +
> +/**
> + * scsi_emit_error - Emit an error event.
> + *
> + * May be called from scsi_softirq_done(). Cannot sleep.
> + *
> + * @cmd: the scsi command
> + */
> +void scsi_emit_error(struct scsi_cmnd *cmd)
> +{
> +       struct scsi_sense_hdr sshdr;
> +       u8 result, sk, asc, ascq;
> +       int sense_valid;
> +       int retry;
> +
> +       if (unlikely(cmd->result)) {
> +               result =3D host_byte(cmd->result);
> +               if (result =3D=3D DID_BAD_TARGET ||
> +                   result =3D=3D DID_IMM_RETRY)
> +                       /*
> +                        * Do not report an error upstream, the situation=
 is
> +                        * not stable. Will report once the IO really fai=
ls.
> +                        */
> +                       return;
> +               sk =3D 0;
> +               asc =3D 0;
> +               ascq =3D 0;
> +
> +               if (result =3D=3D DID_OK) {
> +                       sense_valid =3D scsi_command_normalize_sense(cmd,=
 &sshdr);
> +                       if (!sense_valid) {
> +                               /*
> +                                * With libata, this happens when the err=
or
> +                                * handler is called but the error causes=
 are
> +                                * not identified yet.
> +                                */
> +                               return;
> +                       }
> +
> +                       sk =3D sshdr.sense_key;
> +                       asc =3D sshdr.asc;
> +                       ascq =3D sshdr.ascq;
> +
> +                       /*
> +                        * asc =3D=3D 0 && ascq =3D=3D 0x1D means "ATA pa=
ss through
> +                        * information available"; this is not an error, =
but
> +                        * rather the driver returning some data.
> +                        */
> +                       if (sk =3D=3D NO_SENSE ||
> +                           (sk =3D=3D RECOVERED_ERROR &&
> +                            asc =3D=3D 0x0 &&
> +                            ascq =3D=3D 0x1D)) {
> +                               return;
> +                       }
> +               }
> +
> +               retry =3D (!scsi_noretry_cmd(cmd) &&
> +                        cmd->retries > 0 &&
> +                        cmd->retries <=3D cmd->allowed);
> +               sdev_evt_send_error(cmd->device, GFP_ATOMIC,
> +                                   retry, result, sk, asc, ascq);
> +       }
> +}
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0d29470e86b0b..2a2fae00e9f1c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1029,6 +1029,9 @@ static int scsi_io_completion_nz_result(struct scsi=
_cmnd *cmd, int result,
>                 result =3D 0;
>                 *blk_statp =3D BLK_STS_OK;
>         }
> +#ifdef CONFIG_SCSI_ERROR_UEVENT
> +       scsi_emit_error(cmd);
> +#endif
>         return result;
>  }
>
> @@ -1544,6 +1547,9 @@ static void scsi_complete(struct request *rq)
>                 scsi_finish_command(cmd);
>                 break;
>         case NEEDS_RETRY:
> +#ifdef CONFIG_SCSI_ERROR_UEVENT
> +               scsi_emit_error(cmd);
> +#endif
>                 scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
>                 break;
>         case ADD_TO_MLQUEUE:
> @@ -2559,43 +2565,77 @@ EXPORT_SYMBOL(scsi_device_set_state);
>   */
>  static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *e=
vt)
>  {
> -       int idx =3D 0;
> -       char *envp[3];
> +       struct kobj_uevent_env *env;
> +
> +       env =3D kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
> +       if (!env)
> +               return;
>
>         switch (evt->evt_type) {
>         case SDEV_EVT_MEDIA_CHANGE:
> -               envp[idx++] =3D "SDEV_MEDIA_CHANGE=3D1";
> +               if (add_uevent_var(env, "SDEV_MEDIA_CHANGE=3D1"))
> +                       goto exit;
>                 break;
>         case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
>                 scsi_rescan_device(sdev);
> -               envp[idx++] =3D "SDEV_UA=3DINQUIRY_DATA_HAS_CHANGED";
> +               if (add_uevent_var(env, "SDEV_UA=3DINQUIRY_DATA_HAS_CHANG=
ED"))
> +                       goto exit;
>                 break;
>         case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
> -               envp[idx++] =3D "SDEV_UA=3DCAPACITY_DATA_HAS_CHANGED";
> +               if (add_uevent_var(env, "SDEV_UA=3DCAPACITY_DATA_HAS_CHAN=
GED"))
> +                       goto exit;
>                 break;
>         case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
> -              envp[idx++] =3D "SDEV_UA=3DTHIN_PROVISIONING_SOFT_THRESHOL=
D_REACHED";
> +               if (add_uevent_var(env,
> +                       "SDEV_UA=3DTHIN_PROVISIONING_SOFT_THRESHOLD_REACH=
ED"))
> +                       goto exit;
>                 break;
>         case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
> -               envp[idx++] =3D "SDEV_UA=3DMODE_PARAMETERS_CHANGED";
> +               if (add_uevent_var(env, "SDEV_UA=3DMODE_PARAMETERS_CHANGE=
D"))
> +                       goto exit;
>                 break;
>         case SDEV_EVT_LUN_CHANGE_REPORTED:
> -               envp[idx++] =3D "SDEV_UA=3DREPORTED_LUNS_DATA_HAS_CHANGED=
";
> +               if (add_uevent_var(env,
> +                       "SDEV_UA=3DREPORTED_LUNS_DATA_HAS_CHANGED"))
> +                       goto exit;
>                 break;
>         case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
> -               envp[idx++] =3D "SDEV_UA=3DASYMMETRIC_ACCESS_STATE_CHANGE=
D";
> +               if (add_uevent_var(env,
> +                       "SDEV_UA=3DASYMMETRIC_ACCESS_STATE_CHANGED"))
> +                       goto exit;
> +               break;
> +       case SDEV_EVT_ERROR:
> +               if (add_uevent_var(env, "SDEV_ERROR=3D1"))
> +                       goto exit;
> +               if (add_uevent_var(env, "SDEV_ERROR_RETRY=3D%u",
> +                                       evt->error_evt.retry))
> +                       goto exit;
> +               if (add_uevent_var(env, "SDEV_ERROR_RESULT=3D%u",
> +                                       evt->error_evt.result))
> +                       goto exit;
> +               if (add_uevent_var(env, "SDEV_ERROR_SK=3D%u",
> +                                       evt->error_evt.sk))
> +                       goto exit;
> +               if (add_uevent_var(env, "SDEV_ERROR_ASC=3D%u",
> +                                       evt->error_evt.asc))
> +                       goto exit;
> +               if (add_uevent_var(env, "SDEV_ERROR_ASCQ=3D%u",
> +                                       evt->error_evt.ascq))
> +                       goto exit;
>                 break;
>         case SDEV_EVT_POWER_ON_RESET_OCCURRED:
> -               envp[idx++] =3D "SDEV_UA=3DPOWER_ON_RESET_OCCURRED";
> +               if (add_uevent_var(env, "SDEV_UA=3DPOWER_ON_RESET_OCCURRE=
D"))
> +                       goto exit;
>                 break;
>         default:
>                 /* do nothing */
>                 break;
>         }
>
> -       envp[idx++] =3D NULL;
> +       kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, env->env=
p);
>
> -       kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
> +exit:
> +       kfree(env);
>  }
>
>  /**
> @@ -2693,6 +2733,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_=
event evt_type,
>         case SDEV_EVT_LUN_CHANGE_REPORTED:
>         case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
>         case SDEV_EVT_POWER_ON_RESET_OCCURRED:
> +       case SDEV_EVT_ERROR:
>         default:
>                 /* do nothing */
>                 break;
> @@ -2724,6 +2765,41 @@ void sdev_evt_send_simple(struct scsi_device *sdev=
,
>  }
>  EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
>
> +/**
> + *     sdev_evt_send_error - send error event to uevent thread
> + *     @sdev: scsi_device event occurred on
> + *     @gfpflags: GFP flags for allocation
> + *     @retry: if non-zero, command failed, will retry, otherwise final =
attempt
> + *     @result: host byte of result
> + *     @sk: sense key
> + *     @asc: additional sense code
> + *     @ascq: additional sense code qualifier
> + *
> + *     Assert scsi device error event asynchronously.
> + */
> +void sdev_evt_send_error(struct scsi_device *sdev, gfp_t gfpflags,
> +                        u8 retry, u8 result, u8 sk, u8 asc, u8 ascq)
> +{
> +       struct scsi_event *evt;
> +
> +       evt =3D sdev_evt_alloc(SDEV_EVT_ERROR, gfpflags);
> +       if (!evt) {
> +               sdev_printk(KERN_ERR, sdev, "error event eaten due to OOM=
: retry=3D%u result=3D%u sk=3D%u asc=3D%u ascq=3D%u\n",
> +                           retry, result, sk, asc, ascq);
> +               return;
> +       }
> +
> +       evt->error_evt.retry =3D retry;
> +       evt->error_evt.result =3D result;
> +       evt->error_evt.sk =3D sk;
> +       evt->error_evt.asc =3D asc;
> +       evt->error_evt.ascq =3D ascq;
> +
> +       if (___ratelimit(&sdev->error_ratelimit, "SCSI error"))
> +               sdev_evt_send(sdev, evt);
> +}
> +EXPORT_SYMBOL_GPL(sdev_evt_send_error);
> +
>  /**
>   *     scsi_device_quiesce - Block all commands except power management.
>   *     @sdev:  scsi device to quiesce.
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 9fc397a9ce7a4..8519b563e2feb 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -101,6 +101,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
>                       struct list_head *done_q);
>  bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
>  void scsi_eh_done(struct scsi_cmnd *scmd);
> +extern void scsi_emit_error(struct scsi_cmnd *scmd);
>
>  /* scsi_lib.c */
>  extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmn=
d *cmd);
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 4833b8fe251b8..5c311dfc501c3 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -310,6 +310,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
>         mutex_init(&sdev->inquiry_mutex);
>         INIT_WORK(&sdev->event_work, scsi_evt_thread);
>         INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
> +       ratelimit_state_init(&sdev->error_ratelimit, 5 * HZ, 10);
>
>         sdev->sdev_gendev.parent =3D get_device(&starget->dev);
>         sdev->sdev_target =3D starget;
> @@ -363,6 +364,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
>
>         scsi_change_queue_depth(sdev, depth);
>
> +       /* All devices support error events */
> +       set_bit(SDEV_EVT_ERROR, sdev->supported_events);
> +
>         scsi_sysfs_device_initialize(sdev);
>
>         if (shost->hostt->sdev_init) {
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d772258e29ad2..20a537490e9f2 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1025,6 +1025,7 @@ DECLARE_EVT(capacity_change_reported, CAPACITY_CHAN=
GE_REPORTED)
>  DECLARE_EVT(soft_threshold_reached, SOFT_THRESHOLD_REACHED_REPORTED)
>  DECLARE_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORT=
ED)
>  DECLARE_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
> +DECLARE_EVT(error, ERROR)
>
>  static ssize_t
>  sdev_store_queue_depth(struct device *dev, struct device_attribute *attr=
,
> @@ -1345,6 +1346,7 @@ static struct attribute *scsi_sdev_attrs[] =3D {
>         REF_EVT(soft_threshold_reached),
>         REF_EVT(mode_parameter_change_reported),
>         REF_EVT(lun_change_reported),
> +       REF_EVT(error),
>         NULL
>  };
>
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 68dd49947d041..5485d3b5853e2 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -64,7 +64,8 @@ enum scsi_scan_mode {
>  };
>
>  enum scsi_device_event {
> -       SDEV_EVT_MEDIA_CHANGE   =3D 1,    /* media has changed */
> +       SDEV_EVT_MEDIA_CHANGE   =3D 0,    /* media has changed */
> +       SDEV_EVT_ERROR          =3D 1,    /* command failed */
>         SDEV_EVT_INQUIRY_CHANGE_REPORTED,               /* 3F 03  UA repo=
rted */
>         SDEV_EVT_CAPACITY_CHANGE_REPORTED,              /* 2A 09  UA repo=
rted */
>         SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED,       /* 38 07  UA repo=
rted */
> @@ -79,6 +80,19 @@ enum scsi_device_event {
>         SDEV_EVT_MAXBITS        =3D SDEV_EVT_LAST + 1
>  };
>
> +struct scsi_error_event {
> +       /* A retry event */
> +       u8 retry;
> +       /* Host byte */
> +       u8 result;
> +       /* Sense key */
> +       u8 sk;
> +       /* Additional sense code */
> +       u8 asc;
> +       /* Additional sense code qualifier */
> +       u8 ascq;
> +};
> +
>  struct scsi_event {
>         enum scsi_device_event  evt_type;
>         struct list_head        node;
> @@ -86,6 +100,9 @@ struct scsi_event {
>         /* put union of data structures, for non-simple event types,
>          * here
>          */
> +       union {
> +               struct scsi_error_event error_evt;
> +       };
>  };
>
>  /**
> @@ -269,6 +286,7 @@ struct scsi_device {
>                                 sdev_dev;
>
>         struct work_struct      requeue_work;
> +       struct ratelimit_state  error_ratelimit;
>
>         struct scsi_device_handler *handler;
>         void                    *handler_data;
> @@ -474,6 +492,8 @@ extern struct scsi_event *sdev_evt_alloc(enum scsi_de=
vice_event evt_type,
>  extern void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *e=
vt);
>  extern void sdev_evt_send_simple(struct scsi_device *sdev,
>                           enum scsi_device_event evt_type, gfp_t gfpflags=
);
> +extern void sdev_evt_send_error(struct scsi_device *sdev, gfp_t gfpflags=
,
> +       u8 retry, u8 result, u8 sk, u8 asc, u8 ascq);
>  extern int scsi_device_quiesce(struct scsi_device *sdev);
>  extern void scsi_device_resume(struct scsi_device *sdev);
>  extern void scsi_target_quiesce(struct scsi_target *);
> --
> 2.49.0.805.g082f7c87e0-goog
>
