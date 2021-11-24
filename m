Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661BAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhKXAzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:44 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33327 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhKXAzo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:44 -0500
Received: by mail-pg1-f180.google.com with SMTP id f65so610789pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qhobAcdyo1e28tDZZU6//79J1mh/4UC8Q7hU3IoeFhQ=;
        b=GzocJxqOZBmMd3cZ9m9To+CBc8d5IYGWC+IYQlCDDUiCzZ6d21FWcIyg3s85ixSFE4
         ujHrSmIgyjWPvpx9l0NSjLvo3Z/b57J5hyHp0Nxz1mwgNe+QEEAn2Ad5HiexVtRXVOSJ
         EBLfuU+XNyZZ9IHfOZXTuT3GzB3GFduFN+63nVB0nNzgRNd3k3JHY73mGX8MxY3LEebI
         1V7ZOiVwOsmRxOU3cSPuq3pDT8dwyLZJ/fyfng/GbDc4mwCFZma4i51M0F8BNh0qYzip
         6jfgD06Bg3mBBMGathglK5bdrE4SUtwKpVJY4sWIW4KBo2a6bFfhvbgGVkpFA13G7GpB
         qU2Q==
X-Gm-Message-State: AOAM533FWRwkf0RSFUfLchln1s2AtgsilkdB0EQfrmpt2qybAwRGSoD9
        +NbVjQm9x9Ua+DAKqmQYJYw=
X-Google-Smtp-Source: ABdhPJyVd9E3WKmA4hSU4c+r1pmVoWMdt9BYIiyh2CXlXwKDa4HGI2JIG4RujxnNo+XsiUFBpZxVlQ==
X-Received: by 2002:a63:920b:: with SMTP id o11mr6996786pgd.314.1637715155058;
        Tue, 23 Nov 2021 16:52:35 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <lkp@intel.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 07/13] scsi: bfa: Declare 'bfad_im_vport_attrs' static
Date:   Tue, 23 Nov 2021 16:52:11 -0800
Message-Id: <20211124005217.2300458-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

'bfad_im_vport_attrs' is only used in one source file. Hence declare this
array static.

Fixes: e73af234a1a2 ("scsi: bfa: Switch to attribute groups")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index c8b947c16069..f46989bd083c 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -981,7 +981,7 @@ const struct attribute_group *bfad_im_host_groups[] = {
 	NULL
 };
 
-struct attribute *bfad_im_vport_attrs[] = {
+static struct attribute *bfad_im_vport_attrs[] = {
 	&dev_attr_serial_number.attr,
 	&dev_attr_model.attr,
 	&dev_attr_model_description.attr,
