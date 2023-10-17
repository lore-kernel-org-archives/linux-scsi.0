Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1511CCDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 13:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343532AbjJQNyX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 09:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbjJQNyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 09:54:22 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5744ED
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:54:20 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-31c5cac3ae2so5040615f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697550859; x=1698155659; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VPs3TMiBIj+1n5kEApn3cOzGYCZS6/Iuu4Hn/o59xsE=;
        b=NhQ0nQMurYF16tplJ3pBj41pYbX/WVKy+iJkGo9Y8otOA6Yta5ArYWZTG1HktmTmgX
         /7e7IAg4D5zk87ysq+s1WaSvmWRfzmMNSp77gDsbZqlA4Jh981OWVqnhM8/mq7aukBlt
         RS6DKoZjw6oRHiYVmP1IXEZUAOsQz45wZx0XsjhhXyvflEd9G76RCMuvOB80/5K92kU5
         ZhetcVbKNeJ6uWpjz90y7Ag6zNtCcxA3UjoH3PdJozSZkkIcnkcMd4vmvpf84FsTZ8Ps
         o1xdhRcJ0IqFFiDJc2v8YMUjblJ7NPulNTta0cmueTJmQiFW+tWTJfzTKzS0XsQFsFvl
         7FVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697550859; x=1698155659;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VPs3TMiBIj+1n5kEApn3cOzGYCZS6/Iuu4Hn/o59xsE=;
        b=GQCT+XBQs1j0dFhpeHnKi7tMtJbOOxjQlh/JkCmrKOzDCURD7bEbib7Lg0tEjMQLjy
         4JBW7mPNUsNHZL7NsjBsQKkZTbV8W5q8AWrBbytpKiu1YetXdVrh9OG17liPM5fJ9XJl
         rqv/vhu2KwLsGZ4LDFXULoP4Kq9GFIiIxJKIY2H0e0k+SYAdlYYVPcfkSCTed6uTYmub
         PELK7Hh3ROdwCCW0Pkq221WZto2HsUQVFYJEzGbeSeCB99+x+GYebECm4XlWOJ8hVxFH
         QgEJeL8LJV2mCUHjrwIwM27z58TA2rDrbStevxtTPl8YqjhJb6n+D0T6pxMLc/eLx5Iv
         TdeQ==
X-Gm-Message-State: AOJu0YyPTdF4okooXlXEsyUjuKSn/cfTlgBMWws5B3mUtGokvMT2HoPm
        2S3QbqpU/InnYc18mEKE0N7v+A==
X-Google-Smtp-Source: AGHT+IH/OPi9lBxbgvSmNlvO9CryvQGpTWbZpocEYao40P+HxyWBP/u/WLDy6CSY5QpsuXyJWgnYbQ==
X-Received: by 2002:a05:6000:4b:b0:32d:8eda:ba65 with SMTP id k11-20020a056000004b00b0032d8edaba65mr1987793wrx.66.1697550859105;
        Tue, 17 Oct 2023 06:54:19 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id dj7-20020a0560000b0700b003258934a4bcsm1746088wrb.42.2023.10.17.06.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 06:54:18 -0700 (PDT)
Date:   Tue, 17 Oct 2023 16:54:14 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     justin.tee@broadcom.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Validate ELS LS_ACC completion payload
Message-ID: <01b7568f-4ab4-4d56-bfa6-9ecc5fc261fe@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Justin Tee,

The patch a3c3c0a806f1: "scsi: lpfc: Validate ELS LS_ACC completion
payload" from Oct 9, 2023 (linux-next), leads to the following Smatch
static checker warning:

	drivers/scsi/lpfc/lpfc_els.c:2133 lpfc_cmpl_els_plogi()
	warn: list_entry() does not return NULL 'prsp'

drivers/scsi/lpfc/lpfc_els.c
    2126                 if (release_node)
    2127                         lpfc_disc_state_machine(vport, ndlp, cmdiocb,
    2128                                                 NLP_EVT_DEVICE_RM);
    2129         } else {
    2130                 /* Good status, call state machine */
    2131                 prsp = list_entry(cmdiocb->cmd_dmabuf->list.next,
    2132                                   struct lpfc_dmabuf, list);
--> 2133                 if (!prsp)

list_entry() never returns NULL.  If the list is empty it returns an
invalid pointer.  Did you want to use list_entry_or_null()?

    2134                         goto out;
    2135                 if (!lpfc_is_els_acc_rsp(prsp))
    2136                         goto out;
    2137                 ndlp = lpfc_plogi_confirm_nport(phba, prsp->virt, ndlp);

regards,
dan carpenter
