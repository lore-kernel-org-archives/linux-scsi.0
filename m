Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500C3148825;
	Tue,  2 Jul 2024 16:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936528; cv=none; b=XaRLqJ7yDAuXBQ7qgAn4L7dPpJSVpyQe0apZvNpu9FOBCHL8Oh1dRfXnyElZvZUv8uctoNa3PGD25TMVuRrolDsjp3H6JwKTUNYbJAGOMmhtN41gJEE6sdwe7xFSRKe+1jfeTr2sA0kCElQo/NGiXdeCTJPDWVCK9NiGLlyymPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936528; c=relaxed/simple;
	bh=uL3qsxejMXbViNaxr/B+wibPmddp21cvRX8gRv8J9dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGfS+CleRyZ82kaP7Nfdf3e/ZziOKrzhwwuKr5G63cb797Yulo9paU72XOuIkFWN9F1TeANTBy7n4ftrlwKlB0kQ3/dqZgkRlw0OJcRYgQVeHIEminGqNZ7Dj6JuiSEoFOq70gm8zUTiFibtKXGfdx7DByRC8BKa4hS7CZdY2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Upws76iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Upws76iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3B1C116B1;
	Tue,  2 Jul 2024 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936527;
	bh=uL3qsxejMXbViNaxr/B+wibPmddp21cvRX8gRv8J9dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Upws76iwIz6bSe9js1vMrRSCuWumId25KqBVzStcA1Z+67ZfgOMrjINTFR1ruMIhD
	 4eZq1rCCtxsH6Cvkr1rdzjo6uubUQ/dTQ3A1vUCRSVRz/ZlNINV9zsv9YmiuNKUv+j
	 n6e81PpmEezv5MgHnRXuhirWxU4+Ey1gBFiXqcHDwmUeCQx7K376znyHHCjqEuwl+o
	 LNdDXi/1L5tZ71E/hvpcEutCWu5yCrFkQcjbFyNCdqSfzVcgmaGVLs62rALCEbkqwi
	 9sip69deH4GTT69SMyc2K1NVvh7CpFSd4Hp3R6bbShLz9LDHBdoIU9K4d1X2+EoIHp
	 xZLrmcyjkuqkA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org
Subject: [PATCH v3 3/9] ata: libata-core: Remove support for decreasing the number of ports
Date: Tue,  2 Jul 2024 18:07:59 +0200
Message-ID: <20240702160756.596955-14-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4372; i=cassel@kernel.org; h=from:subject; bh=uL3qsxejMXbViNaxr/B+wibPmddp21cvRX8gRv8J9dU=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVJ9scDPZ4m/CsWDT1cOne7RmfL0+9ZBX19YnJbb3a 54r6TaWdZSyMIhxMciKKbL4/nDZX9ztPuW44h0bmDmsTCBDGLg4BWAi2Y8ZGW5tqQm8px12/ICj Xt65ytSbq2c0fbQ9mhfd8JbjOXu7RADDH+4fE/eYOnCIClYs/Vepena+6un7LGF/1CQmi/Xraz7 5zAQA
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

