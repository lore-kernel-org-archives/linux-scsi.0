Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60624C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjGaOhU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjGaOhT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:37:19 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81A718C;
        Mon, 31 Jul 2023 07:37:17 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b974031aeaso68327361fa.0;
        Mon, 31 Jul 2023 07:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814236; x=1691419036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ClupZYKS8JeUk1us3Kwcw+jicJe7n/nJrCJP2EkCW4E=;
        b=WdB0XvdDtIcmLtxh3v98UEMexneqfrm+gu8IS+DtySID/lXwiHfmCpsw5xiNWJ0hi4
         gFU7D0FWQ9SeswsnmDUlVHtyCHEH6gAPJG5m0eZYqwy8L06+6ed6jwD/cJxhN2emLpZX
         jegotFAQQlmXFw8EKY9ANEw35BwWl25WkDpnTQM4dyPuhymTXp6d7oo2Ue1yTLkAhk7D
         ebBlNkeXJWgJyvs9//nn95IaG82FtpGlkdxDmF6ZkKx54S8PyQKnpzDzFrYYxtz1VXln
         aIKyypC/qvsIHJUKaago1q+yOa87XpdGwO/Fq4jKndbKY7qtftxsVKEKmIZPowrKE4oi
         l8OQ==
X-Gm-Message-State: ABy/qLbTf3krP3WzPd/pk4mmeWsoEfONTBATAobxcNMw5kcDauIhvB98
        HipnJ4EXMfg1Xn3EwlnTP7qWA7N8oOIPoA==
X-Google-Smtp-Source: APBJJlGA60tBkMqqqg24CY8U0/c7KwD9QpPms2R9yki9ULaCMhJtHD7LDeWJ+7mL8gKVjnsAe8dQ6Q==
X-Received: by 2002:a2e:8eca:0:b0:2b9:d0dc:53a9 with SMTP id e10-20020a2e8eca000000b002b9d0dc53a9mr100411ljl.27.1690814235907;
        Mon, 31 Jul 2023 07:37:15 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id c3-20020a2e9483000000b002b6ea79c613sm2591761ljh.94.2023.07.31.07.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:37:15 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 8CE9E3F6E; Mon, 31 Jul 2023 16:37:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814234; bh=j0ZTQkAUQkYnLxb8vQUkk8v3PeseaLM00aHRAEfW8EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHr75Q6W+V3It+CL7/6FnYJOZu2z3ycOIUsED15bvKdRRtSVZt9yES7XUbz3wmuUy
         U35i5UwrXc6PwNDfptCzujuAYgOLel9mQMBwGu24YiCPumRhBdpFDrD8L6Kz1dzgzQ
         6+KwCunXe65YmPHA6puqEHmlGZO41IO5jv7QvRjg=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id B5D8E4018;
        Mon, 31 Jul 2023 16:34:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814087; bh=j0ZTQkAUQkYnLxb8vQUkk8v3PeseaLM00aHRAEfW8EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzxRKOA9tJbeeBZx9gjmnW8EEUI74W+gPTYvBgh2dlk09DLqMs9xKWdLjLyY5Rc3g
         OrKNO19PuZAHVj9zYB5AmbK0t4LeYkG0+udsyXybxVwX1Up/uSpfUiQToOgaFq8QYT
         wj8cM5HpL5CW3lWvj6lAJN1WUF+wzIwl/kvqnYqg=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 02/10] ata,scsi: remove ata_sas_port_{start,stop} callbacks
Date:   Mon, 31 Jul 2023 16:34:13 +0200
Message-ID: <20230731143432.58886-3-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Callbacks are empty now, so remove them.

Also, remove the call to ap->ops->port_start() in ata_sas_port_init(),
as this would otherwise cause a NULL pointer dereference, now when the
callback is gone.

Signed-off-by: Hannes Reinecke <hare@suse.de>
[niklas: remove the call to ap->ops->port_start() in ata_sas_port_init()]
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/ata/libata-sata.c     | 38 -----------------------------------
 drivers/scsi/libsas/sas_ata.c |  2 --
 include/linux/libata.h        |  2 --
 3 files changed, 42 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 99d4ab04bcce..a8256cb08763 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1144,40 +1144,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
 
-/**
- *	ata_sas_port_start - Set port up for dma.
- *	@ap: Port to initialize
- *
- *	Called just after data structures for each port are
- *	initialized.
- *
- *	May be used as the port_start() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-int ata_sas_port_start(struct ata_port *ap)
-{
-	/* the port is marked as frozen at allocation time */
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_start);
-
-/**
- *	ata_sas_port_stop - Undo ata_sas_port_start()
- *	@ap: Port to shut down
- *
- *	May be used as the port_stop() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-
-void ata_sas_port_stop(struct ata_port *ap)
-{
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_stop);
-
 /**
  * ata_sas_async_probe - simply schedule probing and return
  * @ap: Port to probe
@@ -1211,10 +1177,6 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
 
 int ata_sas_port_init(struct ata_port *ap)
 {
-	int rc = ap->ops->port_start(ap);
-
-	if (rc)
-		return rc;
 	ap->print_id = atomic_inc_return(&ata_print_id);
 	return 0;
 }
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 77714a495cbb..7ead1f1be97f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -565,8 +565,6 @@ static struct ata_port_operations sas_sata_ops = {
 	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
-	.port_start		= ata_sas_port_start,
-	.port_stop		= ata_sas_port_stop,
 	.set_dmamode		= sas_ata_set_dmamode,
 	.sched_eh		= sas_ata_sched_eh,
 	.end_eh			= sas_ata_end_eh,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3eeea76c30de..5faf2d5d3da5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1244,10 +1244,8 @@ extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 extern void ata_sas_async_probe(struct ata_port *ap);
 extern int ata_sas_sync_probe(struct ata_port *ap);
 extern int ata_sas_port_init(struct ata_port *);
-extern int ata_sas_port_start(struct ata_port *ap);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
-extern void ata_sas_port_stop(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
-- 
2.41.0

