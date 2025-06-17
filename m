Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA93E3C01;
	Tue, 17 Jun 2025 05:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136567; cv=none; b=UL0ycrvSwFMzDtTfO/lPMl579oBDKsdrSsC6oBQ5hhqiK72uHhecheQLbBbcducUS6zaM5XErW+89AkemsculgDIyak6sLNWdZWAslr3ozF195e/HfRQJNh8ckEZG3gITIIBYHYdOiG5iZkWVgRGmFEPvJx4eAFude3yZDLyBKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136567; c=relaxed/simple;
	bh=8NZa2ZGYava5v9rkDt/7q9+JjFUhw3MpxoIO0XTpWog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTsNxXvyDisEXaXnbK/lbDsAymYmReTr0WzQwbJ95Bn700b8Ky+StdGDdXIPIeU1M7DWHwuCqcyjPNk9FcZ30ZmW/YYUKOSioEHEBfL6r+arPopKjpK4y3QL5DUVmWXZt2H8jFMyyvauH0IW5umzJSF4lXVKbyJAsRHJT1rme9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E43468D05; Tue, 17 Jun 2025 07:02:41 +0200 (CEST)
Date: Tue, 17 Jun 2025 07:02:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
Message-ID: <20250617050240.GA2178@lst.de>
References: <20250616160509.52491-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616160509.52491-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Please try this proper fix instead:

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e021f1106bea..09f5fb5b2fb1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -473,7 +473,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	else
 		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
 
-	if (sht->max_segment_size)
+	if (sht->virt_boundary_mask)
+		shost->virt_boundary_mask = sht->virt_boundary_mask;
+	else if (sht->max_segment_size)
 		shost->max_segment_size = sht->max_segment_size;
 	else
 		shost->max_segment_size = BLK_MAX_SEGMENT_SIZE;
@@ -492,9 +494,6 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	if (sht->virt_boundary_mask)
-		shost->virt_boundary_mask = sht->virt_boundary_mask;
-
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
