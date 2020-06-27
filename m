Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC0DC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 13:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E90120B1F
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 13:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R/iHhHeN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgF0Nd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 09:33:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24772 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725850AbgF0Nd2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 09:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Qer1iXTJUcRgtSy6CWeiNt2qqL/Nc340WbBo6sqo8Hw=;
        b=R/iHhHeNOo4oAUxabGXpW7u3Kt1S/YKgoQsFb/8S4HDHz9JFqd76Lya+vsUDe3EAFmKqrz
        1idG++QoHJW+JegEZfCi3XCwYdizxJi65hAcGQTZbcOv2/0N6Xx1L0voBpQjtm2Gjh/8em
        8LbTEaLkmiNJ7AW3O9PGP+copUsDwME=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-2Hx_SW-KOIipwUmNYHBQ3g-1; Sat, 27 Jun 2020 09:33:25 -0400
X-MC-Unique: 2Hx_SW-KOIipwUmNYHBQ3g-1
Received: by mail-qt1-f200.google.com with SMTP id e4so8622545qtd.13
        for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2020 06:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Qer1iXTJUcRgtSy6CWeiNt2qqL/Nc340WbBo6sqo8Hw=;
        b=qapeMk0kG5cRLxGOusfDYHvase5/68Hv932Xmp8QfNuSL+9x3b+k2FYGU/C/Ptf25z
         UMs7V+w0dUZvudbfyas4r4gLrFSefsU51spD90Ks0kfj5zEdFahHPbighMPzeLV8++sx
         jXUPf55bOSwTytghXAta0tBud4eu5b0PaJtK01Jy5RyXkmJUT+YgbYhp5jYH0xVznKTE
         qb4+K3bbuBDJEOtui6PqL4BG/bnPe9BJfIVENvEt01UjwQ5cbvWKfcKU9Xu2XWhyKWpu
         VsLkCCVgYGBfAj8+em/ue7M+GmQFdlR94eC0e+8lKl6Q3gQz7Z+52zs4XUX7yGKwWa8H
         zq3w==
X-Gm-Message-State: AOAM530SRpbOemh+K3/tf6gn3GmsPbkQ1xLjmMKZCizDmI/HCivyr0wZ
        8CWGGIwX8erTQ6Ntco3t3sjZMtfupK6bRjgLBXZ0SfrjnskXFGUaRcK0flX91cXsDlDmpG+zqIB
        H7eHOUk4SBfdamYYbZ4MWoQ==
X-Received: by 2002:ac8:40cd:: with SMTP id f13mr7446122qtm.373.1593264777905;
        Sat, 27 Jun 2020 06:32:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTywsDCYj1R1MS3BxIDCt8awqyb1UCPMVd5HfK6pZlMhU6x4aB7OaqYuih/FjYDa/EJvOPwQ==
X-Received: by 2002:ac8:40cd:: with SMTP id f13mr7446108qtm.373.1593264777712;
        Sat, 27 Jun 2020 06:32:57 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id b22sm9767979qka.43.2020.06.27.06.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 06:32:57 -0700 (PDT)
From:   trix@redhat.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: scsi_transport_spi: fix function pointer check.
Date:   Sat, 27 Jun 2020 06:32:42 -0700
Message-Id: <20200627133242.21618-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags several null function pointer problems.

drivers/scsi/scsi_transport_spi.c:374:1: warning: Called function pointer is null (null dereference) [core.CallAndMessage]
spi_transport_max_attr(offset, "%d\n");
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reviewing the store_spi_store_max macro

	if (i->f->set_##field)
		return -EINVAL;

should be

	if (!i->f->set_##field)
		return -EINVAL;

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/scsi_transport_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f8661062ef95..f3d5b1bbd5aa 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -339,7 +339,7 @@ store_spi_transport_##field(struct device *dev, 			\
 	struct spi_transport_attrs *tp					\
 		= (struct spi_transport_attrs *)&starget->starget_data;	\
 									\
-	if (i->f->set_##field)						\
+	if (!i->f->set_##field)						\
 		return -EINVAL;						\
 	val = simple_strtoul(buf, NULL, 0);				\
 	if (val > tp->max_##field)					\
-- 
2.18.1

