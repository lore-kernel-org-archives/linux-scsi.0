Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kQyNNodt"
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1231A6
	for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2023 04:30:53 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40bd5eaa66eso24039075e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Dec 2023 04:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701693051; x=1702297851; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q3OtdRkBZRq7c4/uzUGtMz05bMeQtmqGYrkcfDBhpi0=;
        b=kQyNNodt8aSNcQDglGqpwTVuzAoH5liX8T9cwActy7fSp5tqbWrAh+8R0l+/NvM97x
         WjUsRlOolMvJAhvDFFcxoFiTsih2/pR3Cij7JY0/qK+qcUKSkaVucBNjE3uno+IDQMrt
         w+sGAhhODYhONjlOjWF/fQ0tAFj00aehPIgnORJ2AlTpA5L3gAZ6qTgh/4MQYtw1pWEc
         ul/lowtOe0ANjHWxs147a0RssZ0SfshbRzbtjnWezV47U/MZBmt3vK3VJOycvFtcptDD
         cdkH7Ajc4rWnH/0ssnz21TMNJIXve5H1nrE5PfHccgb0WFLsarAMPeTW0vv5aVTWmg1v
         CJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701693051; x=1702297851;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3OtdRkBZRq7c4/uzUGtMz05bMeQtmqGYrkcfDBhpi0=;
        b=HeBXTva8Ick4/+r6S36oFrf4xk+9sEcHNjQ5gYQ/VAjMDDRs1tcL+kpZYdh11owxHV
         mrb5645oozYN/l1ZP/rR+yxQrJE7SVwumoW2cGQOX/qGsy33vcFXf//n+pSi27ASiOa7
         ssMGVuLWVfQdLx+R/YJaP34qPilkkwytfMOM3b2YN69c45pFnoqzD1ra9AME60251BB9
         dMol68aicZ6OsCBIs+dVlhW6SF+VdA25NwvjAT+7fkg+3m591X5I6sPvfGAv3yEpllvL
         B/DcJaVjfPuJzNtKb1EHcwXhYHBZWYW7nl0/PeKDNqMZNTzdDIdjZdXZ0vv+ZyGfxphZ
         ppbw==
X-Gm-Message-State: AOJu0YzHAPDYujuPFWiKMmJmXoBkS+U8jCzlEerv2AMdZ3KuHi7tzZqO
	/fBXkkK0j0kwFXh4b/plQT5ClRreFBJgHxcZYYU=
X-Google-Smtp-Source: AGHT+IFHT7pWkz5jXoCY2Zxxuol2b8zZ2sF1dh++x+fuTT7zUz8AT/KGgEX1O6SSPNQ50dW7WQEomg==
X-Received: by 2002:a05:600c:b45:b0:40b:5e21:ec27 with SMTP id k5-20020a05600c0b4500b0040b5e21ec27mr2459790wmr.89.1701693051636;
        Mon, 04 Dec 2023 04:30:51 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a13-20020a05600c348d00b0040b5377cf03sm18649920wmq.1.2023.12.04.04.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 04:30:51 -0800 (PST)
Date: Mon, 4 Dec 2023 15:30:48 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Add support for the CM framework
Message-ID: <121b7df5-8277-497a-983a-eac00061fb58@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[ I'm not sure what triggered this warning 2 years after the commit.
  I checked on lore but I've never reported it previously. -dan ]

Hello James Smart,

The patch 02243836ad6f: "scsi: lpfc: Add support for the CM
framework" from Aug 16, 2021 (linux-next), leads to the following
Smatch static checker warning:

	drivers/scsi/lpfc/lpfc_sli.c:8343 lpfc_cmf_setup()
	error: we previously assumed 'phba->cgn_i' could be null (see line 8289)

drivers/scsi/lpfc/lpfc_sli.c
    8203 static int
    8204 lpfc_cmf_setup(struct lpfc_hba *phba)
    8205 {
    8206         LPFC_MBOXQ_t *mboxq;
    8207         struct lpfc_dmabuf *mp;
    8208         struct lpfc_pc_sli4_params *sli4_params;
    8209         int rc, cmf, mi_ver;
    8210 
    8211         rc = lpfc_sli4_refresh_params(phba);
    8212         if (unlikely(rc))
    8213                 return rc;
    8214 
    8215         mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
    8216         if (!mboxq)
    8217                 return -ENOMEM;
    8218 
    8219         sli4_params = &phba->sli4_hba.pc_sli4_params;
    8220 
    8221         /* Always try to enable MI feature if we can */
    8222         if (sli4_params->mi_ver) {
    8223                 lpfc_set_features(phba, mboxq, LPFC_SET_ENABLE_MI);
    8224                 rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
    8225                 mi_ver = bf_get(lpfc_mbx_set_feature_mi,
    8226                                  &mboxq->u.mqe.un.set_feature);
    8227 
    8228                 if (rc == MBX_SUCCESS) {
    8229                         if (mi_ver) {
    8230                                 lpfc_printf_log(phba,
    8231                                                 KERN_WARNING, LOG_CGN_MGMT,
    8232                                                 "6215 MI is enabled\n");
    8233                                 sli4_params->mi_ver = mi_ver;
    8234                         } else {
    8235                                 lpfc_printf_log(phba,
    8236                                                 KERN_WARNING, LOG_CGN_MGMT,
    8237                                                 "6338 MI is disabled\n");
    8238                                 sli4_params->mi_ver = 0;
    8239                         }
    8240                 } else {
    8241                         /* mi_ver is already set from GET_SLI4_PARAMETERS */
    8242                         lpfc_printf_log(phba, KERN_INFO,
    8243                                         LOG_CGN_MGMT | LOG_INIT,
    8244                                         "6245 Enable MI Mailbox x%x (x%x/x%x) "
    8245                                         "failed, rc:x%x mi:x%x\n",
    8246                                         bf_get(lpfc_mqe_command, &mboxq->u.mqe),
    8247                                         lpfc_sli_config_mbox_subsys_get
    8248                                                 (phba, mboxq),
    8249                                         lpfc_sli_config_mbox_opcode_get
    8250                                                 (phba, mboxq),
    8251                                         rc, sli4_params->mi_ver);
    8252                 }
    8253         } else {
    8254                 lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT,
    8255                                 "6217 MI is disabled\n");
    8256         }
    8257 
    8258         /* Ensure FDMI is enabled for MI if enable_mi is set */
    8259         if (sli4_params->mi_ver)
    8260                 phba->cfg_fdmi_on = LPFC_FDMI_SUPPORT;
    8261 
    8262         /* Always try to enable CMF feature if we can */
    8263         if (sli4_params->cmf) {
    8264                 lpfc_set_features(phba, mboxq, LPFC_SET_ENABLE_CMF);
    8265                 rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
    8266                 cmf = bf_get(lpfc_mbx_set_feature_cmf,
    8267                              &mboxq->u.mqe.un.set_feature);
    8268                 if (rc == MBX_SUCCESS && cmf) {
    8269                         lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT,
    8270                                         "6218 CMF is enabled: mode %d\n",
    8271                                         phba->cmf_active_mode);
    8272                 } else {
    8273                         lpfc_printf_log(phba, KERN_WARNING,
    8274                                         LOG_CGN_MGMT | LOG_INIT,
    8275                                         "6219 Enable CMF Mailbox x%x (x%x/x%x) "
    8276                                         "failed, rc:x%x dd:x%x\n",
    8277                                         bf_get(lpfc_mqe_command, &mboxq->u.mqe),
    8278                                         lpfc_sli_config_mbox_subsys_get
    8279                                                 (phba, mboxq),
    8280                                         lpfc_sli_config_mbox_opcode_get
    8281                                                 (phba, mboxq),
    8282                                         rc, cmf);
    8283                         sli4_params->cmf = 0;
    8284                         phba->cmf_active_mode = LPFC_CFG_OFF;
    8285                         goto no_cmf;
    8286                 }
    8287 
    8288                 /* Allocate Congestion Information Buffer */
    8289                 if (!phba->cgn_i) {
    8290                         mp = kmalloc(sizeof(*mp), GFP_KERNEL);
    8291                         if (mp)
    8292                                 mp->virt = dma_alloc_coherent
    8293                                                 (&phba->pcidev->dev,
    8294                                                 sizeof(struct lpfc_cgn_info),
    8295                                                 &mp->phys, GFP_KERNEL);
    8296                         if (!mp || !mp->virt) {
    8297                                 lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
    8298                                                 "2640 Failed to alloc memory "
    8299                                                 "for Congestion Info\n");
    8300                                 kfree(mp);
    8301                                 sli4_params->cmf = 0;
    8302                                 phba->cmf_active_mode = LPFC_CFG_OFF;
    8303                                 goto no_cmf;

phba->cgn_i is NULL here.

    8304                         }
    8305                         phba->cgn_i = mp;
    8306 
    8307                         /* initialize congestion buffer info */
    8308                         lpfc_init_congestion_buf(phba);
    8309                         lpfc_init_congestion_stat(phba);
    8310 
    8311                         /* Zero out Congestion Signal counters */
    8312                         atomic64_set(&phba->cgn_acqe_stat.alarm, 0);
    8313                         atomic64_set(&phba->cgn_acqe_stat.warn, 0);
    8314                 }
    8315 
    8316                 rc = lpfc_sli4_cgn_params_read(phba);
    8317                 if (rc < 0) {
    8318                         lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT | LOG_INIT,
    8319                                         "6242 Error reading Cgn Params (%d)\n",
    8320                                         rc);
    8321                         /* Ensure CGN Mode is off */
    8322                         sli4_params->cmf = 0;
    8323                 } else if (!rc) {
    8324                         lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT | LOG_INIT,
    8325                                         "6243 CGN Event empty object.\n");
    8326                         /* Ensure CGN Mode is off */
    8327                         sli4_params->cmf = 0;
    8328                 }
    8329         } else {
    8330 no_cmf:
    8331                 lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT,
    8332                                 "6220 CMF is disabled\n");
    8333         }
    8334 
    8335         /* Only register congestion buffer with firmware if BOTH
    8336          * CMF and E2E are enabled.
    8337          */
    8338         if (sli4_params->cmf && sli4_params->mi_ver) {
    8339                 rc = lpfc_reg_congestion_buf(phba);
    8340                 if (rc) {
    8341                         dma_free_coherent(&phba->pcidev->dev,
    8342                                           sizeof(struct lpfc_cgn_info),
--> 8343                                           phba->cgn_i->virt, phba->cgn_i->phys);
                                                   ^^^^^^^^^^^^^^^^^
Unchecked dereference.

    8344                         kfree(phba->cgn_i);
    8345                         phba->cgn_i = NULL;
    8346                         /* Ensure CGN Mode is off */
    8347                         phba->cmf_active_mode = LPFC_CFG_OFF;
    8348                         sli4_params->cmf = 0;
    8349                         return 0;
    8350                 }
    8351         }
    8352         lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
    8353                         "6470 Setup MI version %d CMF %d mode %d\n",
    8354                         sli4_params->mi_ver, sli4_params->cmf,
    8355                         phba->cmf_active_mode);
    8356 
    8357         mempool_free(mboxq, phba->mbox_mem_pool);
    8358 
    8359         /* Initialize atomic counters */
    8360         atomic_set(&phba->cgn_fabric_warn_cnt, 0);
    8361         atomic_set(&phba->cgn_fabric_alarm_cnt, 0);
    8362         atomic_set(&phba->cgn_sync_alarm_cnt, 0);
    8363         atomic_set(&phba->cgn_sync_warn_cnt, 0);
    8364         atomic_set(&phba->cgn_driver_evt_cnt, 0);
    8365         atomic_set(&phba->cgn_latency_evt_cnt, 0);
    8366         atomic64_set(&phba->cgn_latency_evt, 0);
    8367 
    8368         phba->cmf_interval_rate = LPFC_CMF_INTERVAL;
    8369 
    8370         /* Allocate RX Monitor Buffer */
    8371         if (!phba->rx_monitor) {
    8372                 phba->rx_monitor = kzalloc(sizeof(*phba->rx_monitor),
    8373                                            GFP_KERNEL);
    8374 
    8375                 if (!phba->rx_monitor) {
    8376                         lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
    8377                                         "2644 Failed to alloc memory "
    8378                                         "for RX Monitor Buffer\n");
    8379                         return -ENOMEM;
    8380                 }
    8381 
    8382                 /* Instruct the rx_monitor object to instantiate its ring */
    8383                 if (lpfc_rx_monitor_create_ring(phba->rx_monitor,
    8384                                                 LPFC_MAX_RXMONITOR_ENTRY)) {
    8385                         kfree(phba->rx_monitor);
    8386                         phba->rx_monitor = NULL;
    8387                         lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
    8388                                         "2645 Failed to alloc memory "
    8389                                         "for RX Monitor's Ring\n");
    8390                         return -ENOMEM;
    8391                 }
    8392         }
    8393 
    8394         return 0;
    8395 }

regards,
dan carpenter
