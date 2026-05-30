Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B717A2F6
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780149833; cv=none; b=BxEYWMwBz8dQwU49pM9YCnQdXxmPDpt6KMokOFZ3rQhLUY+tB3mTi7UuMXT+iYSp45FX+BDisSvAYM6zsjL+7rFtD7uxDk56abKQBVSBjjpbKSl3XlH+xoXV9EgxDXZviR3xYiTeMUmKlQ8MS3L8D6k8xJ2j8n1E6kfdMFuQPs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780149833; c=relaxed/simple;
	bh=ZdV21FAQ6FfUbG/FwtwVOCiY+WKE6K02yGhSDAPUDPc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hlZeT8xzLDaE0wCai83CwW9r80p0rsnjfzzpuAyE5zoBWdzpLbuNDW0LgMszLmDWCiRiR0RRzObXe+AxRcGyMHd9SCVxCTf/qqj7Rw+LQIDGHqFpIjkACA2wUMJq4rfIXSTp2XcdrrgPmGRUI+J6o+GJhuCn8W4avYwyvieqFE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lxji/7Ml; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lxji/7Ml"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4905e190c71so76879245e9.3
        for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 07:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780149831; x=1780754631; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N7AqBN4NC5EGll9YHhMJnBpsZ57jgRyRTy4tKAk75xk=;
        b=Lxji/7Ml0vRncEY5hTJ0n9mWDUVh733ayykX4D5srPWX5YdbJYz7kHKRlR5fIqZrhF
         i39QHycHg75r/V7RRa9HyT7y82dWS2lgLtQernxCX3EdXo1onh8iArxPjNAaRdN2D9a2
         61wO02sLTcKcV0gcwTHWPB+AJec96RAbLcfiDcJH5MBYDY5kuty4kQVc2+KorB84Rlcx
         duGYrI4aA796m/m/yndEkJ1g0D7l9zZw/gNy2Z0RNVSoUom+584rl8Sn7DnHWtm9O5vs
         5Ejt2WaUrKBfyn0XTczCDzohb9H3hBQ+hibXE2NvX3rIY2LxK8+p70imFmEYaW6awKU7
         Jqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780149831; x=1780754631;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N7AqBN4NC5EGll9YHhMJnBpsZ57jgRyRTy4tKAk75xk=;
        b=cv4JF7dtaZA726bXvK0dCWXGsyRxnd9nbSETNVu84fBNF08yaTe0fXCVU7q72LV3Mv
         TKAIU7wv4f4FOisBj2upvokjx+cfEsNyeI7WvyOUOMtB2nGS4wytuUWLaMAB/+HJEaIO
         61xD0NnqCGmTXrxGVnN4akkMc3p0jIoz5ljXCUxy+7zrOBE0x+SN10F93qM4xpvzZJmE
         dBU79dUWPbDWeGCUajc9QCnOEuvvjW3jHNk61w2rKvfZcP2DItwb7Py3qx9yKfgNkzXI
         jDKLjtuFo8DO0wljIEjTwZw5UkL5RfZupgvPu0pJSq45v7Sha9IvlQ7lpLmYj/XiOLNN
         IovA==
X-Forwarded-Encrypted: i=1; AFNElJ8XXcdG98vxoWxLR0WnHmJMlb7rEbuRTYo+6B6CVB3l3ha5n6nZegXv9UrdeDHbDFCeQKelVJilXNFs@vger.kernel.org
X-Gm-Message-State: AOJu0YwzG4ClSC+IKhSzCJCelClZLdOi6XelBNX1TIQ/ORif5dqciUFM
	on3chnQIGLI+BQU/Hc3S5X0e4891hz2Z7xSOjuCrLDOFy8kjPNpPnKbV
X-Gm-Gg: Acq92OFwymo7jVFKlCRg2s9YLoSf1Iy0UY9yS5BpbLJnv7OQbCgxh3WoZfgzTe7ZLYp
	yvO0WUvPG8UC8hgw+49+gowoquQrnhsx9p7akaHpBM4/gqS/1QQlEWQ4KPjEhIQMWMgPH+vD15l
	YhJlGYNlpvzn83Kb12qiPiBAt0q+pzXJXo5wbkMijagNQrdrxBvo6GGAQRzshj3FZLcjHKvJr0b
	KZWp1xP/FSZfDjiyNibm+uLpHy18ilAK1z+Qf09IKfq5mYWKQGyehvCxTV0BZ1VzckO6GbDxD7b
	FawCroJGxG3q+yGOCCsawgwybmep4vVULM195UdJymTViaiLPfMvz6DPmrCVwdvS0J1yy/dJyTe
	FrCcf0h5KhAmfjLIRUsO1w3Y2DcbiI858EmYEO2AWOpaWmI4wfK/JZA56EFinn4Des1ICbnqxCf
	Rr8cdKNS5hPaP/7LG7MO8Y1O/FQz4MGFX/NQ==
X-Received: by 2002:a05:600c:3552:b0:48a:8b02:ae91 with SMTP id 5b1f17b1804b1-490a29e43bemr61272475e9.11.1780149830642;
        Sat, 30 May 2026 07:03:50 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c12b2dbsm48875825e9.6.2026.05.30.07.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 07:03:49 -0700 (PDT)
Date: Sat, 30 May 2026 17:03:46 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: megaraid_mbox: Reduce stack usage in
 megaraid_cmm_register()
Message-ID: <ahruQrDsEDQO8RAP@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Arnd Bergmann,

Commit c1f7275b613b ("scsi: megaraid_mbox: Reduce stack usage in
megaraid_cmm_register()") from May 19, 2026 (linux-next), leads to
the following Smatch static checker warning:

	drivers/scsi/megaraid/megaraid_mbox.c:3474 megaraid_cmm_register()
	error: double free of 'adp' (line 3468)

drivers/scsi/megaraid/megaraid_mbox.c
    3395 static int
    3396 megaraid_cmm_register(adapter_t *adapter)
    3397 {
    3398         mraid_device_t        *raid_dev = ADAP2RAIDDEV(adapter);
    3399         mraid_mmadp_t        *adp;
    3400         scb_t                *scb;
    3401         mbox_ccb_t        *ccb;
    3402         int                rval;
    3403         int                i;
    3404 
    3405         // Allocate memory for the base list of scb for management module.
    3406         adapter->uscb_list = kzalloc_objs(scb_t, MBOX_MAX_USER_CMDS);
    3407         adp = kzalloc_obj(*adp);
    3408 
    3409         if (!adapter->uscb_list || !adp) {
    3410                 con_log(CL_ANN, (KERN_WARNING
    3411                         "megaraid: out of memory, %s %d\n", __func__,
    3412                         __LINE__));
    3413 
    3414                 kfree(adapter->uscb_list);
    3415                 kfree(adp);
    3416 
    3417                 return -1;
    3418         }
    3419 
    3420 
    3421         // Initialize the synchronization parameters for resources for
    3422         // commands for management module
    3423         INIT_LIST_HEAD(&adapter->uscb_pool);
    3424 
    3425         spin_lock_init(USER_FREE_LIST_LOCK(adapter));
    3426 
    3427 
    3428 
    3429         // link all the packets. Note, CCB for commands, coming from the
    3430         // commom management module, mailbox physical address are already
    3431         // setup by it. We just need placeholder for that in our local command
    3432         // control blocks
    3433         for (i = 0; i < MBOX_MAX_USER_CMDS; i++) {
    3434 
    3435                 scb                        = adapter->uscb_list + i;
    3436                 ccb                        = raid_dev->uccb_list + i;
    3437 
    3438                 scb->ccb                = (caddr_t)ccb;
    3439                 ccb->mbox64                = raid_dev->umbox64 + i;
    3440                 ccb->mbox                = &ccb->mbox64->mbox32;
    3441                 ccb->raw_mbox                = (uint8_t *)ccb->mbox;
    3442 
    3443                 scb->gp                        = 0;
    3444 
    3445                 // COMMAND ID 0 - (MBOX_MAX_SCSI_CMDS-1) ARE RESERVED FOR
    3446                 // COMMANDS COMING FROM IO SUBSYSTEM (MID-LAYER)
    3447                 scb->sno                = i + MBOX_MAX_SCSI_CMDS;
    3448 
    3449                 scb->scp                = NULL;
    3450                 scb->state                = SCB_FREE;
    3451                 scb->dma_direction        = DMA_NONE;
    3452                 scb->dma_type                = MRAID_DMA_NONE;
    3453                 scb->dev_channel        = -1;
    3454                 scb->dev_target                = -1;
    3455 
    3456                 // put scb in the free pool
    3457                 list_add_tail(&scb->list, &adapter->uscb_pool);
    3458         }
    3459 
    3460         adp->unique_id                = adapter->unique_id;
    3461         adp->drvr_type                = DRVRTYPE_MBOX;
    3462         adp->drvr_data                = (unsigned long)adapter;
    3463         adp->pdev                = adapter->pdev;
    3464         adp->issue_uioc                = megaraid_mbox_mm_handler;
    3465         adp->timeout                = MBOX_RESET_WAIT + MBOX_RESET_EXT_WAIT;
    3466         adp->max_kioc                = MBOX_MAX_USER_CMDS;
    3467 
    3468         if ((rval = mraid_mm_register_adp(adp)) != 0) {
    3469 
    3470                 con_log(CL_ANN, (KERN_WARNING
    3471                         "megaraid mbox: did not register with CMM\n"));
    3472 
    3473                 kfree(adapter->uscb_list);
--> 3474                 kfree(adp);

mraid_mm_register_adp() has a kfree() of the adapter on the the
error path.  I suppose, someone could make the argument that the
original code was already buggy since kfreeing a stack variable isn't
going to end well...

    3475         }
    3476 
    3477         return rval;
    3478 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
