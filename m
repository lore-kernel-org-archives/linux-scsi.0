Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28EF18C341;
	Wed,  3 Jul 2024 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032303; cv=none; b=VwbK3CLaMg+u6GBXsvJNb30p7morN9Ik5jF4uVubPmbTWLOOVLbskJCJOGOmKLAIksgpG5Zrvp9p9BlFNZF6VRPojQevOpA2V47T1ZklWK+jNewLfvxbvbOXRAy5tfYvgpBGBpwLJ8/RdmBdPLd+kF1ThZXOv9WlDgUyX9AEAkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032303; c=relaxed/simple;
	bh=rGLhGA4U0nWfnf9gDicbn5UReSpLOrwyOSqv92NlJnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmr9rMQswKdQmS8azLrLLdy52QPHA2nwjGDyrE47glfmFGdcUJAiX7T1Su3qkOXlXqjoYll/Rq3xDp49y5qkxLcbqqdYi/bQGdbxA/E7rMpVSPNbk6B2w7VCZP+qWr6XQURBkrrDMijzFBC4egPpJSY6/V1st7sES3ClJitDYe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvyJTmWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvyJTmWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FBAC4AF07;
	Wed,  3 Jul 2024 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032302;
	bh=rGLhGA4U0nWfnf9gDicbn5UReSpLOrwyOSqv92NlJnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvyJTmWW/C/JFYTx0qdl9Ze1XXaHY1XgxkHAEAQbHsMaamUjhkTtu9V3qD8tH/hO2
	 Sh5EgCs+RvSzFrbSznjz7pjUf+mz7x8tisHsgmiOaHzDlAAOk4Y1xcaOLra2o8m58S
	 5/o31wIP7d70OSyu3xCOnVKxhoWKidceTXeYy3qQWrquHM0MB6dS6r+jKNh7JLy9h3
	 5wlX/6EZUimc8h4jpu9JdhU5CUISbXJuVfO3qQLkim1wcP0qXCYwbWzsBP0zSXlx6l
	 jibAXIwfvggXd0N/yaQ+D8iVONd7WNlBpI6tyrU1iHre+HVeFY51t9h5H/630wb/6w
	 Sn+3ojEdPmMwA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH v4 5/9] ata: libata-core: Remove local_port_no struct member
Date: Wed,  3 Jul 2024 20:44:22 +0200
Message-ID: <20240703184418.723066-16-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2682; i=cassel@kernel.org; h=from:subject; bh=rGLhGA4U0nWfnf9gDicbn5UReSpLOrwyOSqv92NlJnE=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa5/B4K4YIMp75ps23qeykqlxF8cR1zyJD+IxFWJXbJ qTWnM7oKGVhEONikBVTZPH94bK/uNt9ynHFOzYwc1iZQIYwcHEKwEQuOzD8d+wXvfP7TOe5Lxem Zz/y1svlSJ+k2v75yO7TWroF3d1O1xkZXmvoeRtL239Mv7zwweobC6VmZxw/7u6btuWMcOTsZw1 bOQE=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

ap->local_port_no is simply ap->port_no + 1.
Since ap->local_port_no can be derived from ap->port_no, there is no need
for the ap->local_port_no struct member, so remove ap->local_port_no.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c      | 5 +----
 drivers/ata/libata-transport.c | 3 ++-
 include/linux/libata.h         | 1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f0cce3fec902..aff54651da65 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5463,7 +5463,6 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
-	ap->local_port_no = -1;
 	ap->host = host;
 	ap->dev = host->dev;
 
@@ -5901,10 +5900,8 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 	}
 
 	/* give ports names and add SCSI hosts */
-	for (i = 0; i < host->n_ports; i++) {
+	for (i = 0; i < host->n_ports; i++)
 		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
-		host->ports[i]->local_port_no = i + 1;
-	}
 
 	/* Create associated sysfs transport objects  */
 	for (i = 0; i < host->n_ports; i++) {
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index d24f201c0ab2..9e24c33388f9 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -217,7 +217,8 @@ static DEVICE_ATTR(name, S_IRUGO, show_ata_port_##name, NULL)
 
 ata_port_simple_attr(nr_pmp_links, nr_pmp_links, "%d\n", int);
 ata_port_simple_attr(stats.idle_irq, idle_irq, "%ld\n", unsigned long);
-ata_port_simple_attr(local_port_no, port_no, "%u\n", unsigned int);
+/* We want the port_no sysfs attibute to start at 1 (ap->port_no starts at 0) */
+ata_port_simple_attr(port_no + 1, port_no, "%u\n", unsigned int);
 
 static DECLARE_TRANSPORT_CLASS(ata_port_class,
 			       "ata_port", NULL, NULL, NULL);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b7c5d3f33368..84a7bfbac9fa 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -814,7 +814,6 @@ struct ata_port {
 	/* Flags that change dynamically, protected by ap->lock */
 	unsigned int		pflags; /* ATA_PFLAG_xxx */
 	unsigned int		print_id; /* user visible unique port ID */
-	unsigned int            local_port_no; /* host local port num */
 	unsigned int		port_no; /* 0 based port no. inside the host */
 
 #ifdef CONFIG_ATA_SFF
-- 
2.45.2

