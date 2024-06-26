Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E937B6E613;
	Wed, 26 Jun 2024 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424896; cv=none; b=tCDCtCsTxTj29MTF6/Hlv+ts7aZ9ppL+quE2gsO6kBPhx2uebuP3xttdWhgAdj1+mN05Br3v7weBVOtRncS49hdeIR6dh2kPeDLoR5gA77W6tRKuf+3EJ4xb9rf6Sl4L146r5WZ0Px1qTSMxjNR25ttCFJyh0xFwUguiLtnenqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424896; c=relaxed/simple;
	bh=ppedzp1AaxL9/kS2JLoS2AUa1W0Jtte4QmafLe6BgYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL4eIL48c3Cqhh1z5j23Sjvh6WXPW2jjrLdKxF+vpCpx4RDpIEzW07HKTdjXiYW39EWEgCQYroZlUTdVPBeYJ1UJq9b/p/9ktienOKOgYbeLNU+Mo7DndZIx6eCZkh49ccSvt1RBHWv0oEBnEgJvsBMghs3EhN2/c6r/z7aF3sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjGcOOhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjGcOOhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EE0C32782;
	Wed, 26 Jun 2024 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424895;
	bh=ppedzp1AaxL9/kS2JLoS2AUa1W0Jtte4QmafLe6BgYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjGcOOhwU1KXY/WbnVm86F2MDJBCxSesDNiMryscKQ0JW0nyioJX3xbYZimMY+abO
	 1r82hpbZlvs5VUYWPVxXcivjT7GP+BjEgyFW4dg1DVo+Wr82ZVDTpYFnesxPiWbxQ1
	 id6LyUSPfcc1EqQ8A7Vel4gotSI17l5XnGwkLEibbvbteaniIOZSuvLpAtxOHe75z1
	 WuvLd7zVYKKONfhjHVv6g1K7oMBzxcpK07UQVoRgSid9J9vKOpDOLEue3u9JVdJ4R6
	 UF+oK7Xun8vfU6qNmmKlWrSOpj5R/F+dccWgUof0ZB6e104mEYsnwIbwg6GaCMa2V6
	 wVyd9RquAfTmQ==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 07/13] ata: libata-core: Remove support for decreasing the number of ports
Date: Wed, 26 Jun 2024 20:00:37 +0200
Message-ID: <20240626180031.4050226-22-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4496; i=cassel@kernel.org; h=from:subject; bh=ppedzp1AaxL9/kS2JLoS2AUa1W0Jtte4QmafLe6BgYU=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwp2OLlq7cR7jzdnsmmLrT9+KtTswQf+4x8Gt//tuR 7DK+rYpdZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAiexkYGfY05UVeZWP7eP3X 3BaJrbd8tjsc38bpePapaLqN5M9ECS2G/4Vx99dU3Tpy1mhx/dSDbXXaTUvWL38et+Sa9MJNK47 LRjADAA==
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Commit f31871951b38 ("libata: separate out ata_host_alloc() and
ata_host_register()") added ata_host_alloc(), where the API allowed
a LLD to overallocate the number of ports supplied to ata_host_alloc(),
as long as the LLD decreased host->n_ports before calling
ata_host_register().

However, this functionally has never ever been used by a single LLD.

Because of the current API design, the assignment of ap->print_id is
deferred until registration time, which is bad, because that means that
the ata_port_*() print functions cannot be used by a LLD until after
registration time, which means that a LLD is forced to use a print
function that is non-port specific, even for a port specific error.

Remove the support for decreasing the number of ports, such that it will
be possible to assign ap->print_id earlier.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 24 ++++++++++--------------
 include/linux/libata.h    |  2 +-
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 591020ea8989..a213a9c0d0a5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5550,24 +5550,19 @@ EXPORT_SYMBOL_GPL(ata_host_put);
 /**
  *	ata_host_alloc - allocate and init basic ATA host resources
  *	@dev: generic device this host is associated with
- *	@max_ports: maximum number of ATA ports associated with this host
+ *	@n_ports: the number of ATA ports associated with this host
  *
  *	Allocate and initialize basic ATA host resources.  LLD calls
  *	this function to allocate a host, initializes it fully and
  *	attaches it using ata_host_register().
  *
- *	@max_ports ports are allocated and host->n_ports is
- *	initialized to @max_ports.  The caller is allowed to decrease
- *	host->n_ports before calling ata_host_register().  The unused
- *	ports will be automatically freed on registration.
- *
  *	RETURNS:
  *	Allocate ATA host on success, NULL on failure.
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  */
-struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
+struct ata_host *ata_host_alloc(struct device *dev, int n_ports)
 {
 	struct ata_host *host;
 	size_t sz;
@@ -5575,7 +5570,7 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 	void *dr;
 
 	/* alloc a container for our list of ATA ports (buses) */
-	sz = sizeof(struct ata_host) + (max_ports + 1) * sizeof(void *);
+	sz = sizeof(struct ata_host) + (n_ports + 1) * sizeof(void *);
 	host = kzalloc(sz, GFP_KERNEL);
 	if (!host)
 		return NULL;
@@ -5595,11 +5590,11 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 	spin_lock_init(&host->lock);
 	mutex_init(&host->eh_mutex);
 	host->dev = dev;
-	host->n_ports = max_ports;
+	host->n_ports = n_ports;
 	kref_init(&host->kref);
 
 	/* allocate ports bound to this host */
-	for (i = 0; i < max_ports; i++) {
+	for (i = 0; i < n_ports; i++) {
 		struct ata_port *ap;
 
 		ap = ata_port_alloc(host);
@@ -5908,12 +5903,13 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 		return -EINVAL;
 	}
 
-	/* Blow away unused ports.  This happens when LLD can't
-	 * determine the exact number of ports to allocate at
-	 * allocation time.
+	/*
+	 * For a driver using ata_host_register(), the ports are allocated by
+	 * ata_host_alloc(), which also allocates the host->ports array.
+	 * The number of array elements must match host->n_ports.
 	 */
 	for (i = host->n_ports; host->ports[i]; i++)
-		kfree(host->ports[i]);
+		WARN_ON(host->ports[i]);
 
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++) {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 580971e11804..b7c5d3f33368 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1069,7 +1069,7 @@ extern int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline);
 extern void ata_std_postreset(struct ata_link *link, unsigned int *classes);
 
-extern struct ata_host *ata_host_alloc(struct device *dev, int max_ports);
+extern struct ata_host *ata_host_alloc(struct device *dev, int n_ports);
 extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 			const struct ata_port_info * const * ppi, int n_ports);
 extern void ata_host_get(struct ata_host *host);
-- 
2.45.2

