Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D5187570;
	Wed,  3 Jul 2024 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032297; cv=none; b=BEdeGf90WXDJ08rnpRzi/o23xFj7NlSKgusCO/FpjGpT/rOUcAMyamJicXLgVrSDkCxTdYxtZeZHkrURg5uLTCvQLl88TuBHvmBlQquwwfEmkqlsWH21RDWaRNo0fWa7Ca4ggz6uDNqS8BrYxlDdxV3WggUNQGGTfhro8ZpUHDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032297; c=relaxed/simple;
	bh=uL3qsxejMXbViNaxr/B+wibPmddp21cvRX8gRv8J9dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFQYVr7fr4qRPgvgEPU2d0Y4yyFi2P1Q6fsVKKvcLYGvwGQ+cUqsR1hM/loSNCRQLaUsC9niaIDDWUm443IJ/925YDvQWRgFKOF5vS1LDr1jlQCsmKkOiQmQcYiaxECiRw4CvnMlTnfWFmkktZxZSpNc5vS9J8EIVe6jidWPosw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9FBMKlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9FBMKlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE785C4AF07;
	Wed,  3 Jul 2024 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032296;
	bh=uL3qsxejMXbViNaxr/B+wibPmddp21cvRX8gRv8J9dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9FBMKlDwxpopaf/pQY/nQJfGGuCXEe/T0ktV4R3Kr9+VF1Blz503gQ7/eWnbNnx1
	 iz/dAcoWcjteAIzW3gzTGmy4WVXVTuiQxqbWDiHuw9Hiv9e0J+dro7sp8tsPQlXbjt
	 AyXTjw+y1w0EW685RGUzRSz2iz5rZIYXmCMBUXBsGaZfW20DoNMwIPHwX4kYtwnYJs
	 LHcoIRd7Kt2a175E/Pm4TeJ9QstFgXYvCe+9ctEejbmOoC1dqFFpyx2uzajMQTOL4R
	 uzvZ2ffbguZG7Ocw/Lx4wELyMLonK+werzqkMdSIGDKfk7dfziDenuZTh79MMzyjZh
	 wXSadPYXJtpww==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v4 3/9] ata: libata-core: Remove support for decreasing the number of ports
Date: Wed,  3 Jul 2024 20:44:20 +0200
Message-ID: <20240703184418.723066-14-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703184418.723066-11-cassel@kernel.org>
References: <20240703184418.723066-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4372; i=cassel@kernel.org; h=from:subject; bh=uL3qsxejMXbViNaxr/B+wibPmddp21cvRX8gRv8J9dU=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa53BvcDPZ4m/CsWDT1cOne7RmfL0+9ZBX19YnJbb3a 54r6TaWdZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAiBtoM/1OZrzBXpxXs9X0g 8XTvlvjnLx5H/Z1c1Payc8vSMy1tTiqMDF99LzyTfVa65sYm2ZDdB7dpzPDe66wa/oTfLtmwa9Z XJ2YA
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

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 22 +++++-----------------
 include/linux/libata.h    |  2 +-
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 74b59b78d278..f0cce3fec902 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5547,24 +5547,19 @@ EXPORT_SYMBOL_GPL(ata_host_put);
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
@@ -5572,7 +5567,7 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 	void *dr;
 
 	/* alloc a container for our list of ATA ports (buses) */
-	sz = sizeof(struct ata_host) + (max_ports + 1) * sizeof(void *);
+	sz = sizeof(struct ata_host) + n_ports * sizeof(void *);
 	host = kzalloc(sz, GFP_KERNEL);
 	if (!host)
 		return NULL;
@@ -5592,11 +5587,11 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
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
@@ -5905,13 +5900,6 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
 		return -EINVAL;
 	}
 
-	/* Blow away unused ports.  This happens when LLD can't
-	 * determine the exact number of ports to allocate at
-	 * allocation time.
-	 */
-	for (i = host->n_ports; host->ports[i]; i++)
-		ata_port_free(host->ports[i]);
-
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++) {
 		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
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

