Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAB62472A8
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 10:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089772; cv=none; b=Sn3oDNVPm5JvixI5IpYLDV3UpD1T/fBWkVOpeb5wMH/exgiFef6MTjkeD+b5eVpkl2UjI+Jlhr7u3HNYUdJTPG9xZg74lt5TKdMommCOC56NrHMMzPVpv1xlxJnGxx1bHxi6ldWbaEVWmjxlNxHh8YduCipy+C4NIfPqRI4kSSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089772; c=relaxed/simple;
	bh=LXvIBwQKlwN2aW+nel9nihwfIG/BNCGtqaNljMXS3c4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WyMfnSRaOW/vhvBRyzi4ZVmYfd/Edgis3jO/xLvmRNX+5a1DDWAP3zI9x6/by8m6NUfODmctrN7PJN0FrxuLQGRfbhOlMObkd81T9ayAuSnBvs6VPIZZzwzeOjoj10Mr7lmImcfgHRlLWRpeL+JeEDeUDfLZr9Rdwgrt6EyV570=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y2eq0kbY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bt254Tfa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y2eq0kbY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bt254Tfa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CbbLRn5SB4hmqpKO67RyzNkOjJr20Ge6MiEXlRieQIA=;
	b=Y2eq0kbYZ/G4JtVsbXXmDX+h4pJ+R+EMoBukNUpp1I38mJ/7hUpz3W+MG1b0bTvRy1Xbz4
	XifEKYiXiYRSNV6RZASyfm1+32m8EQ2OqOXQVECwuDDsC/okwNevsf9DsJ8V6Oc+FpybZ4
	XtBt2DvLn7V9aGZfh2MUbrQBmbUjb6M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-mu4uXMAJNvm5sNC_Ue6VpA-1; Tue, 30 Dec 2025 05:16:05 -0500
X-MC-Unique: mu4uXMAJNvm5sNC_Ue6VpA-1
X-Mimecast-MFC-AGG-ID: mu4uXMAJNvm5sNC_Ue6VpA_1767089764
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430fd96b2f5so8253108f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089764; x=1767694564; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CbbLRn5SB4hmqpKO67RyzNkOjJr20Ge6MiEXlRieQIA=;
        b=Bt254TfaH40bxBLxxz/5PJL5tMkim9plomSHRIKOLweJ0ULeIwYjMOOodWhM3WK//P
         UymTDcx5T/76e6zQA5wl6k6H93lMN9mTTgBmA5esGeKjeD1Mhg8ocnWjdfxPB9BBFgQF
         j3fdS68fB7LUzhD9scOZuWhrXFMLFMJDw/Yu3dQNCsu5cZRj7sVy1+rzWBHeB7BpvBFc
         wLynWNnvzZtHrWQVI8zQxRsCRzHZIIcWpvNGF2l+95QVNBecdrjYemcNz1AR1GJqfHNj
         ZXTLKRq/pX6OrNPTEiM8u/fjDpJWmP9UZgXfRWZqPtLtcBKSBJf8RrGd6bNB289+Fq2l
         m7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089764; x=1767694564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbbLRn5SB4hmqpKO67RyzNkOjJr20Ge6MiEXlRieQIA=;
        b=jLv+as90JtSvZ+ZacR7rVUEQdw6uR6f6YkWD76djYa1v3tMELwFlg/zLqF/SpX7y8s
         Fi1JCrBwGV3+PM+BcXCSDKopUROzTuq45yW8/Ff/e31taRcLPMiFAzQPDvNT3QnJqQCT
         7amCi3+5/y0VkGsyOEBSxJVTYGKM10AWX1OIJadec1940KHSqxj5kMsJdDXSeQ7StDi+
         +byR8tzYGKomgukwfqKcjDqEFi8qRy8X0KbFfXg7aTuw4mri6frW5kgOe6CQHBZySXQX
         RZxWXlO3paMT06THKGpjbHB/7riczy7bErRxzSAoNfZjNtsLYRqou+XnzHtD99xVwgaU
         aFAw==
X-Forwarded-Encrypted: i=1; AJvYcCUvTQf6PEr+7UIG7vNC6rm1AMq6RGdT/bLYwQoiVl6lMn3zxbBUQVmRDAhYAcKZjmjAiS/2o2aCOEP4@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Wp2zPRyOsGFDFdgXLQDRMhPTRmrAAhhSVc8VpuDvlaXaLRkC
	+GSYK3ZhxFPySaaSexHeJ58+91JYNN8fIQzdImH5bBu+/mGhNJYiLUW9aUV5H5YkTKvMu6Le71X
	QGscC6NoDMRfgZQiWG8GzRPi6eASh4MdAJxnWWo6QIHjqzZQRDeQPI+GK5ZqHljk=
X-Gm-Gg: AY/fxX61PgI4B7EQKzcuayGzfwRogdi936bgajHUi+PmzTtMphKlJBcVBgx1jLkoo6g
	b264BTuuwbEJwx2+mIF3YqAMKZr/eESvOxkk9wogbbf6pDw0+5awrDP/UsI7IuSgbcp8WzpQTRG
	HMUI6vEnOPVIiUoQ/qMPaJikFMkcOh3z608Atq/+nLrXD3Eq/B0SxD2p1okwxgJVZJKe6yJw6VF
	3QgDFCai7YITxx85xYuiwjboJrDo/ERVmISQx1DGbFQzquP5wU3q5MO0JGdS7oX51wS7ZazAj2h
	InlmTX7O8T6DvISvbGvYlBLkwXdN3q6VvXNiKwjX2QUzWOaQTXN6tTOnZXWC0GRKVGVMOYJUH4R
	RjPVsDNFknX4MzerzXbMB4e0H3IUTXxo0Jg==
X-Received: by 2002:a05:6000:200e:b0:430:fcf5:4937 with SMTP id ffacd0b85a97d-4324e4c3e1emr38658309f8f.7.1767089763982;
        Tue, 30 Dec 2025 02:16:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHK1atjAKrkdoWQy4jxFj2rw+qTn5U0Lh0sTEHql45jv1yC6jgv8gOxch8xQ2S/3gi1ay54uA==
X-Received: by 2002:a05:6000:200e:b0:430:fcf5:4937 with SMTP id ffacd0b85a97d-4324e4c3e1emr38658276f8f.7.1767089763428;
        Tue, 30 Dec 2025 02:16:03 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1b1bdsm66936468f8f.8.2025.12.30.02.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:03 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:00 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 05/13] dma-debug: track cache clean flag in entries
Message-ID: <c0df5d43759202733ccff045f834bd214977945f.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

If a driver is bugy and has 2 overlapping mappings but only
sets cache clean flag on the 1st one of them, we warn.
But if it only does it for the 2nd one, we don't.

Fix by tracking cache clean flag in the entry.
Shrink map_err_type to u8 to avoid bloating up the struct.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 kernel/dma/debug.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 7e66d863d573..9bd14fd4c51b 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -63,6 +63,7 @@ enum map_err_types {
  * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
  * @paddr: physical start address of the mapping
  * @map_err_type: track whether dma_mapping_error() was checked
+ * @is_cache_clean: driver promises not to write to buffer while mapped
  * @stack_len: number of backtrace entries in @stack_entries
  * @stack_entries: stack of backtrace history
  */
@@ -76,7 +77,8 @@ struct dma_debug_entry {
 	int		 sg_call_ents;
 	int		 sg_mapped_ents;
 	phys_addr_t	 paddr;
-	enum map_err_types  map_err_type;
+	u8		 map_err_type;
+	bool		 is_cache_clean;
 #ifdef CONFIG_STACKTRACE
 	unsigned int	stack_len;
 	unsigned long	stack_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
@@ -472,12 +474,15 @@ static int active_cacheline_dec_overlap(phys_addr_t cln)
 	return active_cacheline_set_overlap(cln, --overlap);
 }
 
-static int active_cacheline_insert(struct dma_debug_entry *entry)
+static int active_cacheline_insert(struct dma_debug_entry *entry,
+				   bool *overlap_cache_clean)
 {
 	phys_addr_t cln = to_cacheline_number(entry);
 	unsigned long flags;
 	int rc;
 
+	*overlap_cache_clean = false;
+
 	/* If the device is not writing memory then we don't have any
 	 * concerns about the cpu consuming stale data.  This mitigates
 	 * legitimate usages of overlapping mappings.
@@ -487,8 +492,14 @@ static int active_cacheline_insert(struct dma_debug_entry *entry)
 
 	spin_lock_irqsave(&radix_lock, flags);
 	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
-	if (rc == -EEXIST)
+	if (rc == -EEXIST) {
+		struct dma_debug_entry *existing;
+
 		active_cacheline_inc_overlap(cln);
+		existing = radix_tree_lookup(&dma_active_cacheline, cln);
+		if (existing)
+			*overlap_cache_clean = existing->is_cache_clean;
+	}
 	spin_unlock_irqrestore(&radix_lock, flags);
 
 	return rc;
@@ -583,20 +594,24 @@ DEFINE_SHOW_ATTRIBUTE(dump);
  */
 static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
 {
+	bool overlap_cache_clean;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 	int rc;
 
+	entry->is_cache_clean = !!(attrs & DMA_ATTR_CPU_CACHE_CLEAN);
+
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);
 	put_hash_bucket(bucket, flags);
 
-	rc = active_cacheline_insert(entry);
+	rc = active_cacheline_insert(entry, &overlap_cache_clean);
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST &&
-		   !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_CPU_CACHE_CLEAN)) &&
+		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+		   !(entry->is_cache_clean && overlap_cache_clean) &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
 		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
-- 
MST

