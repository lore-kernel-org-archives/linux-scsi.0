Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3F01D61B1
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 10:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736244180; cv=none; b=igQa4DjoKYVLf8Q/fsy5inTHTr/VnLkpywCrP9KT8H6GwrxMm4WupnLkndWscm8nJXKb2CeAH/Rl9Kj9EbfjQScg9FRoI0jGjgWQWMNdNpbW2ZuWgskH+SKPslvuHVpJdfbRFPwxe0uFasI/jhB4ZY6uV9+QHG2cmkExc/hkc9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736244180; c=relaxed/simple;
	bh=ZFR912bZybGYP6rglDpeVhLLO+uJWipukpMuSnm1y00=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iukvCzMqHFZhi6flVPwOlq69pJ0MDz+aIVk8g/HZEqCC/aEVceBpfXWprdAeUl0hwkWT4tjIzwb7Ke1r2ZtL8q2uB0sL8gBDY6ofQfD57mq+XkrQ4dpmCtaVeC6eD9GcFhDpJYrNfVAFHW+nSOBtk9EnQ+2/mhqtFVzXY/4ZOjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K1wQpoNW; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K1wQpoNW"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4362bae4d7dso109533105e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2025 02:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736244177; x=1736848977; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oy6GHniJ7nOjjdbBfgP2wpPjoH7wIP8qkxfOznT/nEM=;
        b=K1wQpoNWeBvoKoyBw4Ckln4vVlL1W19RqF80HoJqWuaLCqP5EG0X2CKU8sc/xUIAvb
         EJVAT1lf/oXokXrhYwzXSTgu0qhpDJwmeKxsNUKAcKvrL/70MPezF8aUWx6amEBdHt69
         4IoLUz6KEMsiEw9Z45LDcRj46XCBUt8L9KzHdyXOu/KmGiX8U/TRxjkSQNJYTFQri2fC
         aApZyprlpnADtfEDO9rdI73BWza4d/aFDR6mIG4oycq+XCbOsH0Im4gj0XV3mwDveaJQ
         insv3enGRq46wGO/70RHftEhbfuTBQMoi3IEN2UQDrIYF1zEwkoOsWRSdOGkoAiK8DDU
         UrKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736244177; x=1736848977;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oy6GHniJ7nOjjdbBfgP2wpPjoH7wIP8qkxfOznT/nEM=;
        b=KKpscAGUZD9w1IsYd5iUAfAShh6GEwP/indm/LCLDWFAhGHeMsrpe0YJUlAyKpER9/
         fWd0B8WM2eYrC1eH6L5vlMNobt1t9Irq/GReYy5g+zniYuJGhrJIKVwqOh3k7nluyUnj
         g+u+gJ6kmI7skKyazP08iGsDqPpjHD7Akb8DrnXCSs3ytvHg+ijSNqYKJf19QPgfWIGe
         97XrFI/o8hk3EkoWlKUuBfIIYAvopfSBdfYmo25YHb81p68p8/VMF9SxQhZpD+fvzaG4
         IjZ/8+nsrKLBtJEkA7u+BtAs+6+77RAJ7Jscc2h08XOFswa9cBBM5ocFSKF3WANsTJG6
         SJZA==
X-Gm-Message-State: AOJu0YyOvm4VfOEAjwDnm6I8J50kzKkwtOVDitGKJszP6d7/rjbMPQ7g
	MSz0e6znYIVDnjpn48PcEXc5WsZT35DsGhV11YK2WAxmgME58Ld1EM+hgqsV4As=
X-Gm-Gg: ASbGncuJGEmZzo7UXcXmf9aW8ar5ZYTdJONWS613yErGdBohPeM9zdNpKRnGbJO4qIq
	LaFw9vCWMpIcoKE54oyGv85Du7pvExOOwu/sHVSUB4dj/PSxjKNyaFnUntaSxReRE0KPwzt8FXM
	e8t+EaIAVImkk7zbCJ+oDOnAlxdhFmJTQ/xdEJ+FQz8Ogy4v3IXNVc5wTNBvbn9UYkEvbJnfXR4
	EnZKm434JcKPA6hKxNmwpQNTvgYCdY3emaS+DpzJGOMP0u2209WjB2XQgtiYw==
X-Google-Smtp-Source: AGHT+IGnAoCCwOSnfs5A2f2m17N8A4q5gyeJLV5kHWC+fpXkU9gn/OhGc/eMBI8YVBQMf5N6m4EuIA==
X-Received: by 2002:a05:600c:1994:b0:435:306:e5dd with SMTP id 5b1f17b1804b1-43668b5dfaamr491127615e9.22.1736244176995;
        Tue, 07 Jan 2025 02:02:56 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b119b6sm631128555e9.22.2025.01.07.02.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 02:02:56 -0800 (PST)
Date: Tue, 7 Jan 2025 13:02:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: fnic: Modify fnic interfaces to use FDLS
Message-ID: <382a9f41-dbb4-4039-abcd-cb0497c37d52@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Karan Tilak Kumar,

Commit 9243626c211e ("scsi: fnic: Modify fnic interfaces to use
FDLS") from Dec 11, 2024 (linux-next), leads to the following Smatch
static checker warning:

	drivers/scsi/fnic/fnic_main.c:1034 fnic_probe()
	warn: missing error code here? 'fnic_scsi_drv_init()' failed. 'err' = '0'

drivers/scsi/fnic/fnic_main.c
    1020 
    1021         vnic_dev_enable(fnic->vdev);
    1022 
    1023         err = fnic_request_intr(fnic);
    1024         if (err) {
    1025                 dev_err(&fnic->pdev->dev, "Unable to request irq.\n");
    1026                 goto err_out_fnic_request_intr;
    1027         }
    1028 
    1029         fnic_notify_timer_start(fnic);
    1030 
    1031         fnic_fdls_init(fnic, (fnic->config.flags & VFCF_FIP_CAPABLE));
    1032 
    1033         if (IS_FNIC_FCP_INITIATOR(fnic) && fnic_scsi_drv_init(fnic))
--> 1034                 goto err_out_scsi_drv_init;

Missing error code.

    1035 
    1036         err = fnic_stats_debugfs_init(fnic);
    1037         if (err) {
    1038                 dev_err(&fnic->pdev->dev, "Failed to initialize debugfs for stats\n");
    1039                 goto err_out_free_stats_debugfs;
    1040         }
    1041 
    1042         for (i = 0; i < fnic->intr_count; i++)
    1043                 vnic_intr_unmask(&fnic->intr[i]);
    1044 
    1045         spin_lock_irqsave(&fnic_list_lock, flags);
    1046         list_add_tail(&fnic->list, &fnic_list);
    1047         spin_unlock_irqrestore(&fnic_list_lock, flags);
    1048 
    1049         return 0;
    1050 
    1051 err_out_free_stats_debugfs:
    1052         fnic_stats_debugfs_remove(fnic);
    1053         scsi_remove_host(fnic->host);
    1054 err_out_scsi_drv_init:
    1055         fnic_free_intr(fnic);
    1056 err_out_fnic_request_intr:
    1057 err_out_alloc_rq_buf:
    1058         for (i = 0; i < fnic->rq_count; i++) {
    1059                 if (ioread32(&fnic->rq[i].ctrl->enable))
    1060                         vnic_rq_disable(&fnic->rq[i]);
    1061                 vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
    1062         }
    1063         vnic_dev_notify_unset(fnic->vdev);
    1064 err_out_fnic_notify_set:
    1065         mempool_destroy(fnic->frame_elem_pool);
    1066 err_out_fdls_frame_elem_pool:
    1067         mempool_destroy(fnic->frame_pool);
    1068 err_out_fdls_frame_pool:
    1069         mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX]);
    1070 err_out_free_dflt_pool:
    1071         mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT]);
    1072 err_out_free_resources:
    1073         fnic_free_vnic_resources(fnic);
    1074 err_out_fnic_alloc_vnic_res:
    1075         fnic_clear_intr_mode(fnic);
    1076 err_out_fnic_set_intr_mode:
    1077         if (IS_FNIC_FCP_INITIATOR(fnic))
    1078                 scsi_host_put(fnic->host);
    1079 err_out_fnic_role:
    1080 err_out_scsi_host_alloc:
    1081 err_out_fnic_get_config:
    1082 err_out_dev_mac_addr:
    1083 err_out_dev_init:
    1084         vnic_dev_close(fnic->vdev);
    1085 err_out_dev_open:
    1086 err_out_dev_cmd_init:
    1087         vnic_dev_unregister(fnic->vdev);
    1088 err_out_dev_register:
    1089         fnic_iounmap(fnic);
    1090 err_out_fnic_map_bar:
    1091 err_out_map_bar:
    1092 err_out_set_dma_mask:
    1093         pci_release_regions(pdev);
    1094 err_out_pci_request_regions:
    1095         pci_disable_device(pdev);
    1096 err_out_pci_enable_device:
    1097         ida_free(&fnic_ida, fnic->fnic_num);
    1098 err_out_ida_alloc:
    1099         kfree(fnic);
    1100 err_out_fnic_alloc:
    1101         return err;
    1102 }

regards,
dan carpenter
