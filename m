Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540491F12F8
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 14:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736258887; cv=none; b=XxlgNbxc9izTnY+ix5GtmqAFlndpuY1XHdt8tGXxTFZSgrOaNTZjSoNSlIElK/KCPJh9Uk/83mOkOER6e/3rqV83VC1jNh082aOZOgh2YLWuoAJ4GP4X6ChBrtW0ZyXBm8qf4Q7AaudbpI+aKZ0k0/EWOZkqYHd8jmqbG4XrwP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736258887; c=relaxed/simple;
	bh=9h5jJAtJof99Jly7eSpiYE+fjffW1iQZpf3954k+0Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cKjXcMeAkx2ifOEiwKnoM7T1pPyhzhwRHEet4Uvd1TjRVqc24MZYxCrV+uMw6mWJ9va9lVgwp/gYLjyzZLKzXFsPsRZB5cTCa/dUiKjhbkPksttuB5y5YqZMdc4kbpnNxQ6a2cowQo30eXdKz2TC+hLWGwI1KRS2EDJGgGEwvok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ubQTfIIV; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ubQTfIIV"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4362bae4d7dso111642155e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2025 06:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736258883; x=1736863683; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V0eMBMBHn0hE1R+X0qsZ45MfTkd1D6d9P2VREjyMP6I=;
        b=ubQTfIIVZmN9gbKUN1KeCKJEkvuXYwuuEd/Hiz+b8biOEVBuJh7Z1MBHdJsPEyUhJL
         15903Teb/1DOd6TJR7AC6m+YB2eptLQ47mCqFEiAcKk85UtBkQsYENAieR3PkAEe36yc
         I8jFwV11YFyuIEO1cysiGfei1OPjUbu0oL2xMq/4qAG4sQ/b0Ea5kWN+lKfq48Xo6jTm
         4B7e+MoRrL0uGwYwYBtY5cxOXRgird4whdXuW2WaFsCUWgsfVV9qCsd92WgYH5vxR+5z
         juGDgUl7krx/6qsQ+0QJeUpAafn6ykh4G2Yk7Ef+dFRyoJxrF87OFbvgeOeAZLcBW+aN
         k5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736258883; x=1736863683;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0eMBMBHn0hE1R+X0qsZ45MfTkd1D6d9P2VREjyMP6I=;
        b=pqq7LvNFClHyq6cjf7p+x8dVXaH50SiuMhg6LtoBZqvw56jnqEmriEb/NeVeD+baQH
         pjmCBYzGJjX9yTs781ng0AYrVNhkOYfHW03fKtVvCYF+7OcyDKLFC1medS928yxqK96e
         diAvKr11ygzW+9frIUJBZ1GJE7lYVojYicGC5b7p6UbjawPp73D3LNpSUDw59b5zfndM
         e3IyyvczjTjNMOzrXAkhrhloiY8bvCe7dCSD9ns4Sk0BDv/meQ5jXoihC70955wckE4N
         tHDY5UKj25qA4+n04mIO6Yb11wEoy4hJJ3aw7MNVh+qLuVC94OINgIQRybPW6BRKdZg0
         6M8g==
X-Gm-Message-State: AOJu0Yx6xB9ACANLv3WLN6O7+sMS93cRJLTqUsSZwbpjFj3SVd6NTyz+
	A672gjK0/9vvx8u6aTVGLLPjr+9p8TJiwQdnbLMWqXLElZsSJiaZ9KtSQrJFZa4=
X-Gm-Gg: ASbGnctO/UmQ930zmCevjL++V4ROXROW7y1Kq6lSz0RYogTYMlnc4bXzeoJmA84U8x6
	xZTILgJRNhUUH/7UubJLtDAOAi5TztM9dECl4tKLlht+RwyZLFkDnhhrl9o37KPr2ekQdL58Lfx
	WupHkrvBVAI6PmAyJqHeeCyWkmGoHZvGDoCPSyaXHdQX4wBrbO9NuLxq7prIVoCRvuVWY2K5fKQ
	qnpqOCUAwikLMqpSVejlQYrRR3p7N1xIDz7q8UH4pcH+NotuQh1lF4gX5wkvA==
X-Google-Smtp-Source: AGHT+IGpOhD+J1ZZ5144ZbpcA/MVLZ2kdr/2oNRF+XT9QWpAGbrRi63YBBHGfx7MPN51Om1+cSitLw==
X-Received: by 2002:a05:600c:470b:b0:434:f609:1afa with SMTP id 5b1f17b1804b1-43668547314mr519865235e9.4.1736258883373;
        Tue, 07 Jan 2025 06:08:03 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b3b214sm639807115e9.28.2025.01.07.06.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 06:08:02 -0800 (PST)
Date: Tue, 7 Jan 2025 17:07:59 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: fnic: Add support for fabric based solicited
 requests and responses
Message-ID: <06645656-9445-4710-9646-7a2c147d1f51@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Karan Tilak Kumar,

Commit a63e78eb2b0f ("scsi: fnic: Add support for fabric based
solicited requests and responses") from Dec 11, 2024 (linux-next),
leads to the following Smatch static checker warning:

	drivers/scsi/fnic/fnic_main.c:907 fnic_probe()
	warn: missing error code 'err'

drivers/scsi/fnic/fnic_main.c
    866 
    867         err = fnic_alloc_vnic_resources(fnic);
    868         if (err) {
    869                 dev_err(&fnic->pdev->dev, "Failed to alloc vNIC resources, "
    870                              "aborting.\n");
    871                 goto err_out_fnic_alloc_vnic_res;
    872         }
    873         dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table size: %d\n",
    874                         fnic->wq_copy_count, fnic->sw_copy_wq[0].ioreq_table_size);
    875 
    876         /* initialize all fnic locks */
    877         spin_lock_init(&fnic->fnic_lock);
    878 
    879         for (i = 0; i < FNIC_WQ_MAX; i++)
    880                 spin_lock_init(&fnic->wq_lock[i]);
    881 
    882         for (i = 0; i < FNIC_WQ_COPY_MAX; i++) {
    883                 spin_lock_init(&fnic->wq_copy_lock[i]);
    884                 fnic->wq_copy_desc_low[i] = DESC_CLEAN_LOW_WATERMARK;
    885                 fnic->fw_ack_recd[i] = 0;
    886                 fnic->fw_ack_index[i] = -1;
    887         }
    888 
    889         pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
    890         if (!pool)
    891                 goto err_out_free_resources;

err = -ENOMEM;

    892         fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] = pool;
    893 
    894         pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
    895         if (!pool)
    896                 goto err_out_free_dflt_pool;

err = -ENOMEM;

    897         fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX] = pool;
    898 
    899         pool = mempool_create_slab_pool(FDLS_MIN_FRAMES, fdls_frame_cache);
    900         if (!pool)
    901                 goto err_out_fdls_frame_pool;

err = -ENOMEM;

    902         fnic->frame_pool = pool;
    903 
    904         pool = mempool_create_slab_pool(FDLS_MIN_FRAME_ELEM,
    905                                                 fdls_frame_elem_cache);
    906         if (!pool)
--> 907                 goto err_out_fdls_frame_elem_pool;

err = -ENOMEM;

regards,
dan carpenter

    908         fnic->frame_elem_pool = pool;
    909 
    910         /* setup vlan config, hw inserts vlan header */
    911         fnic->vlan_hw_insert = 1;
    912         fnic->vlan_id = 0;
    913 
    914         if (fnic->config.flags & VFCF_FIP_CAPABLE) {
    915                 dev_info(&fnic->pdev->dev, "firmware supports FIP\n");
    916                 /* enable directed and multicast */
    917                 vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
    918                 vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
    919                 vnic_dev_add_addr(fnic->vdev, iport->hwmac);
    920                 spin_lock_init(&fnic->vlans_lock);
    921                 INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
    922                 INIT_LIST_HEAD(&fnic->fip_frame_queue);
    923                 INIT_LIST_HEAD(&fnic->vlan_list);
    924                 timer_setup(&fnic->retry_fip_timer, fnic_handle_fip_timer, 0);
    925                 timer_setup(&fnic->fcs_ka_timer, fnic_handle_fcs_ka_timer, 0);
    926                 timer_setup(&fnic->enode_ka_timer, fnic_handle_enode_ka_timer, 0);
    927                 timer_setup(&fnic->vn_ka_timer, fnic_handle_vn_ka_timer, 0);
    928                 fnic->set_vlan = fnic_set_vlan;
    929         } else {
    930                 dev_info(&fnic->pdev->dev, "firmware uses non-FIP mode\n");
    931         }
    932         fnic->state = FNIC_IN_FC_MODE;
    933 
    934         atomic_set(&fnic->in_flight, 0);
    935         fnic->state_flags = FNIC_FLAGS_NONE;
    936 
    937         /* Enable hardware stripping of vlan header on ingress */
    938         fnic_set_nic_config(fnic, 0, 0, 0, 0, 0, 0, 1);
    939 
    940         /* Setup notification buffer area */
    941         err = fnic_notify_set(fnic);
    942         if (err) {
    943                 dev_err(&fnic->pdev->dev, "Failed to alloc notify buffer, aborting.\n");
    944                 goto err_out_fnic_notify_set;
    945         }
    946 

[ snip ]

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
