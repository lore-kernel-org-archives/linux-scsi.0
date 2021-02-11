Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDE9C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 13:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5423A64E87
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 13:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhBKNU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 08:20:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231965AbhBKNSE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 08:18:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613049396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nwfCo96+ORexE4nd9lMvPQewHMvozTYtZvmFeVr87HA=;
        b=gQOkM525M4uarj+opYXtR+PO4i5/xp3RhLUj5eAYHT5JuqtNwjvi11hcstubF6OJXrjLbt
        dCb4uAyskNhWzzR6GYgHR6s6ZKqkEtCSliDSlQIGHYt4Ge4xU7lYC549hbGASecNt/3otB
        9NFmxHKdzMLZ+DR8fYVR3vGEzkuCcTM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-_XpFxryEPJGmVYLxrNhF2g-1; Thu, 11 Feb 2021 08:16:35 -0500
X-MC-Unique: _XpFxryEPJGmVYLxrNhF2g-1
Received: by mail-pf1-f200.google.com with SMTP id v23so4269972pfe.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 05:16:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=nwfCo96+ORexE4nd9lMvPQewHMvozTYtZvmFeVr87HA=;
        b=duQdHjWIf4UMGZREfjuotu7g+d4GbSckMgv1vLGwAmMYW8+cgsoPzk9VEXdA6USZrt
         gs558hTHEdxz93BqsOmyyymLgOA2sU3wws/w1B3eh7K2U+/AjNyr/6lNbt5VJhUXY/AH
         ZfuOql28Q93dh5ijjKXORL59H674ssxXyisla2DHUHsHRvQOKi/rlTji9NH1e2XeNoLG
         At4I5sRQ1OKrC1jmPMWgmzld3cyW2HL4yCuysl42voqe6tMY9cvVAEu+cUpOq6ucl+/n
         9HMmp1DHK6p2fxS5Mjr4AQvJ75zTte0URNvuOXcKvRHcM/mBM+OfWItKAAL5yB1a8e/q
         Stag==
X-Gm-Message-State: AOAM533+QZ4US5scAD/sWtwoBiTTQjFjwEW7PznSszf2wOr8+sX0+oij
        qe+6+S0wViWASQRklosAYOgYTmmgD+Jj5aaQaanJ8T4U6C58FMHdf8nHGHQCQyUjFUVCZjkKuCS
        6e4AL4wCCGaxo6CE82uWBKw==
X-Received: by 2002:a17:902:c40d:b029:e2:c0c3:75c9 with SMTP id k13-20020a170902c40db02900e2c0c375c9mr7474926plk.46.1613049394041;
        Thu, 11 Feb 2021 05:16:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVYC6+/htvGDWMyYQ1cg/ylcBsfp+7V0HdpzAXf+akRe5Ur0ljggfKQPKYsXUav1Nw8wDxKg==
X-Received: by 2002:a17:902:c40d:b029:e2:c0c3:75c9 with SMTP id k13-20020a170902c40db02900e2c0c375c9mr7474893plk.46.1613049393625;
        Thu, 11 Feb 2021 05:16:33 -0800 (PST)
Received: from machine1 ([171.50.216.159])
        by smtp.gmail.com with ESMTPSA id j185sm6207342pge.46.2021.02.11.05.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 05:16:33 -0800 (PST)
Date:   Thu, 11 Feb 2021 18:46:28 +0530
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
To:     kernel-janitors@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Subject: [PATCH v2] scsi: qla2xxx: Removed extra space in variable
 declaration.
Message-ID: <20210211131628.GA10754@machine1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Removed extra space in variable declaration in qla2x00_sysfs_write_nvram

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
changes v2:
 - Added a small note about change.
---
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ab45ac1e5a72..7f2db8badb6d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -226,7 +226,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
-	uint16_t	cnt;
+	uint16_t cnt;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size ||
 	    !ha->isp_ops->write_nvram)

