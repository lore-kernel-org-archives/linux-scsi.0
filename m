Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19043D396
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516014; cv=none; b=KOs+xXGCzfOAXrwggHJh4Ar7r9f1jp+etsEaS91U775on3id6ZVSx+QS59e7Tw0Yo7PPDfHX1M0k4eNQ63hJDyznfOdVf9F4R2z28qoiUm9GgzjO6d1IMsDBEzwrr/pOEQkAibt7P2444uBam8d+Ec22URrpdshq8ZI+tTnHmfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516014; c=relaxed/simple;
	bh=tBQyMgtyMXtg5KeuvsC1XMDbJ3YGTEDOFvB6JeNcAhE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aVBLetxF4mLLN4b6NOB1YZ48wanqsX8p3C651TTrDaD/rmeWo/vFKgTjLbSWM+9/as4Myge30QI0nN6skEKj7KsTuaXEtNc+tIlfmX8rEUcWgE2icP+0R335yt8Z+dC0rv6hM8hpT8L5XVqXDpdsTvK/7aWyxr0xH7be/cBsl5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HGex4jWi; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HGex4jWi"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-512e4f4e463so2543519e87.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1710516011; x=1711120811; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CQoZ399Ft2OCqR6PrRZ8AKdQ51GM57H/4iFSM9vAuGU=;
        b=HGex4jWigtWZgj47DTf1KwLAGyI3OiN8JpGkHKcwnQJYfpd7ZyyEQJo2AFfypF7yeQ
         Cjm8TpqVLG7h3hVXUlSvjioxtbGZQTmkNCVa1au1CHx96wqs328yXhTxBjC46TK12rQy
         +MUBfi98Z5hiQl4xymgSPDcP8BUHz2mZFpvT/o5+/q9ScT/emtwwK0nDOVeBPxo00pi9
         zA0Frg7CU70Uoq0VBUDNZVZo+6me/6M2cgAhpshbkMG8jpMMSe2yIQ9oQljTOYoYPCeJ
         rTqM1EcrF9BEn8zVfR75tLRPVHBY9WdeYZWvmYjpoBCQItN94PoOyqz75UiCoNIow5qo
         fOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516011; x=1711120811;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CQoZ399Ft2OCqR6PrRZ8AKdQ51GM57H/4iFSM9vAuGU=;
        b=EQ/r+n/eQhUQCdl/wm9ojYW1DChSq+MN9IFd5/DHf0fuP3WrPP78j7DJq7m6Pcue2R
         7V7I9ckzDrTwcctoOobPEusJ6fqEk7N/l5PzaSkR8nS4JnQC9qPPPW9iLBo7exhfBCwi
         JH7ijY43FB5MvhK+HFK44CSkOwnIVbeDhMgfs0XQKWgT5Oo0c87SFa8L0v2TWcVBZ9sZ
         9nViVfLQXvwZbQpQlXsxtP6nLHbLy9weQx/4G7XQqoeas4G0wSJL+0pzhIBakJR67KTo
         xZFxLeqjk+mGWKKMxTIeaR/dHeMfL3Is2zctAjU/ezM4ZfC/VUTIoBnnMVmVW7ov/hEC
         wPKw==
X-Gm-Message-State: AOJu0YyZ2kdG7d7QbhKZ9Q9BxF7rtOlIA4+sVXUpR5vcGSaDHM/D/62w
	it9oXi3Z0Wze72vqm8yNUNvUYZ8Hb7X1wMqySgU+myGe15GuztZBy9oTI+e+A/8=
X-Google-Smtp-Source: AGHT+IElsYX3uf9nTp5WxF8Y4cdJua66BxMa0WqmJ636ce1yzWXhYSkyTrzBnyPmvL33ldNGnhiuSg==
X-Received: by 2002:ac2:4e03:0:b0:513:cebb:cf19 with SMTP id e3-20020ac24e03000000b00513cebbcf19mr4092392lfr.53.1710516010793;
        Fri, 15 Mar 2024 08:20:10 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id co17-20020a0560000a1100b0033e1be7f3d8sm3584064wrb.70.2024.03.15.08.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:20:10 -0700 (PDT)
Date: Fri, 15 Mar 2024 18:20:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: qutran@marvell.com
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: qla2xxx: Fix N2N stuck connection
Message-ID: <15c413c2-f99c-4b7f-861f-2841306e3b8a@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Quinn Tran,

Commit 881eb861ca38 ("scsi: qla2xxx: Fix N2N stuck connection") from
Feb 27, 2024 (linux-next), leads to the following Smatch static
checker warning:

	drivers/scsi/qla2xxx/qla_iocb.c:3060 qla24xx_els_dcmd2_iocb()
	warn: missing error code here? 'qla2x00_get_sp()' failed

drivers/scsi/qla2xxx/qla_iocb.c
    3043 int
    3044 qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
    3045                         fc_port_t *fcport)
    3046 {
    3047         srb_t *sp;
    3048         struct srb_iocb *elsio = NULL;
    3049         struct qla_hw_data *ha = vha->hw;
    3050         int rval = QLA_SUCCESS;
                 ^^^^^^^^^^^^^^^^^^^^^^^

    3051         void        *ptr, *resp_ptr;
    3052 
    3053         /* Alloc SRB structure
    3054          * ref: INIT
    3055          */
    3056         sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
    3057         if (!sp) {
    3058                 ql_log(ql_log_info, vha, 0x70e6,
    3059                  "SRB allocation failed\n");
--> 3060                 goto done;

This used to return -ENOMEM;  Should it return QLA_FUNCTION_FAILED?

    3061         }
    3062 
    3063         fcport->flags |= FCF_ASYNC_SENT;
    3064         qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND);
    3065         elsio = &sp->u.iocb_cmd;
    3066         ql_dbg(ql_dbg_io, vha, 0x3073,
    3067                "%s Enter: PLOGI portid=%06x\n", __func__, fcport->d_id.b24);
    3068 
    3069         sp->type = SRB_ELS_DCMD;
    3070         sp->name = "ELS_DCMD";
    3071         sp->fcport = fcport;
    3072         qla2x00_init_async_sp(sp, ELS_DCMD_TIMEOUT + 2,
    3073                              qla2x00_els_dcmd2_sp_done);
    3074         sp->u.iocb_cmd.timeout = qla2x00_els_dcmd2_iocb_timeout;
    3075 
    3076         elsio->u.els_plogi.tx_size = elsio->u.els_plogi.rx_size = DMA_POOL_SIZE;
    3077 
    3078         ptr = elsio->u.els_plogi.els_plogi_pyld =
    3079             dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.tx_size,
    3080                 &elsio->u.els_plogi.els_plogi_pyld_dma, GFP_KERNEL);
    3081 
    3082         if (!elsio->u.els_plogi.els_plogi_pyld) {
    3083                 rval = QLA_FUNCTION_FAILED;
    3084                 goto done_free_sp;
    3085         }
    3086 
    3087         resp_ptr = elsio->u.els_plogi.els_resp_pyld =
    3088             dma_alloc_coherent(&ha->pdev->dev, elsio->u.els_plogi.rx_size,
    3089                 &elsio->u.els_plogi.els_resp_pyld_dma, GFP_KERNEL);
    3090 
    3091         if (!elsio->u.els_plogi.els_resp_pyld) {
    3092                 rval = QLA_FUNCTION_FAILED;
    3093                 goto done_free_sp;
    3094         }
    3095 
    3096         ql_dbg(ql_dbg_io, vha, 0x3073, "PLOGI %p %p\n", ptr, resp_ptr);
    3097 
    3098         memset(ptr, 0, sizeof(struct els_plogi_payload));
    3099         memset(resp_ptr, 0, sizeof(struct els_plogi_payload));
    3100         memcpy(elsio->u.els_plogi.els_plogi_pyld->data,
    3101                (void *)&ha->plogi_els_payld + offsetof(struct fc_els_flogi, fl_csp),
    3102                sizeof(ha->plogi_els_payld) - offsetof(struct fc_els_flogi, fl_csp));
    3103 
    3104         elsio->u.els_plogi.els_cmd = els_opcode;
    3105         elsio->u.els_plogi.els_plogi_pyld->opcode = els_opcode;
    3106 
    3107         if (els_opcode == ELS_DCMD_PLOGI && DBELL_ACTIVE(vha)) {
    3108                 struct fc_els_flogi *p = ptr;
    3109                 p->fl_csp.sp_features |= cpu_to_be16(FC_SP_FT_SEC);
    3110         }
    3111 
    3112         ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3073, "PLOGI buffer:\n");
    3113         ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x0109,
    3114             (uint8_t *)elsio->u.els_plogi.els_plogi_pyld,
    3115             sizeof(*elsio->u.els_plogi.els_plogi_pyld));
    3116 
    3117         rval = qla2x00_start_sp(sp);
    3118         if (rval != QLA_SUCCESS) {
    3119                 fcport->flags |= FCF_LOGIN_NEEDED;
    3120                 set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
    3121                 goto done_free_sp;
    3122         } else {
    3123                 ql_dbg(ql_dbg_disc, vha, 0x3074,
    3124                     "%s PLOGI sent, hdl=%x, loopid=%x, to port_id %06x from port_id %06x\n",
    3125                     sp->name, sp->handle, fcport->loop_id,
    3126                     fcport->d_id.b24, vha->d_id.b24);
    3127         }
    3128 
    3129         return rval;
    3130 
    3131 done_free_sp:
    3132         qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
    3133         /* ref: INIT */
    3134         kref_put(&sp->cmd_kref, qla2x00_sp_release);
    3135 done:
    3136         fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
    3137         qla2x00_set_fcport_disc_state(fcport, DSC_DELETED);
    3138         return rval;
    3139 }

regards,
dan carpenter
