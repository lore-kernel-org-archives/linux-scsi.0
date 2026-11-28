Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795858002;
	b=WLyQAP3lKCButIXLO/lO7K9vavrInZuEfRJnp8NzXgIpgi/+v1PTeX8D2qbxWOwq8Eqg
	 WZES2v9OQoiL4UkivbTBRGHHMFGWxsBprWqfMXfqEErikm4CNlujJ7fOxnjgxXwiy+fIw
	 YnrA7u5IV6LIGNCuFdVOpoJfZ0ge55VGpW2knP/cjBq+V8qQvRBBuF7lVJFJVjSKIlQpF
	 FdhYrS69sGceOq4CNT5hYoRnNlcsr2ZCeZgPS8vpejU8nlN1PF4jCQbDE7wAY4FQROtPI
	 HPNupAvCn1NaOcGXBT5cRM6tmZL0yZ+tA7hjfO1awuLvmMf5ym4nKbl7+3HlVbusiBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795858002;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=1Sri8kxz2uoEL3sSeB5rKcJwSB9FUVM+rwbkcMwDLFM=;
	b=048RzEU862DGABKnkA3XEsEcZJzW0+DdqE2wDB0/ma+sYn8bFMMLMVjWwthAITPcbUMr
	 ydZdNGxB/a00HP7HtQE6LZHzS4U5J96meH13Ym2AHf0lWBf/DLQqRz1jUZ4y+bjZEf8en
	 BaOG4N4iyNBRs7bnxZJ1936LX7G+SzEhefsqinwDTQnmKhovjl8pWw2LDVi0uRijEjojZ
	 ZoeVx4bYnuDl6MFlKyMPIp/oIi+o/lTVKdLbmT4S+1Nzp/3ji2jTy0iWopwwj+fH3McNj
	 DJAt2Ez2Y/J2Km5n8YoAFRdSt65iqrLVREWWxPdiAHCECVPCQSRUKg8/wbZA8dm18aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=sxiVnH6D;
	arc=none smtp.remote-ip=74.125.224.53
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E1A606A33B
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51E1A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=sxiVnH6D
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-67dae7d3f7dso10290508d50.2
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 01:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795858001; x=1796462801; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1Sri8kxz2uoEL3sSeB5rKcJwSB9FUVM+rwbkcMwDLFM=;
        b=sxiVnH6DsPbF5W5f2ILVwXiPDYERvznuiRwvYAyFn1uNZHtNnzdvFjsl++AgMQHATF
         9ZSR5LWgUMW4B0nr04nNxrGIOzFQ0yYjqImgwJi2izBZWFI+8zBvFQ3oK7V/kaVaB7xk
         S7wXnFm6MvkgnUQEl4RJNstW8l5aIFjNiqwK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795858001; x=1796462801;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Sri8kxz2uoEL3sSeB5rKcJwSB9FUVM+rwbkcMwDLFM=;
        b=NsL8oWdJj+i8ustqMee/kn+nnpEM2lnhXSW5xlryTQkDtLCwbeT8el05NJjZBHsjiB
         StDgU48/cEQw49IJ44p3lAvlc+odknL1lZtEUls96VzkM1FD0DjYnFzllCYqNM1n2QSa
         4MYqG9KY5iqoxx+zCf/xplUsCynzKbfh82YtOEzXors3Lqyf8fY+2RtPO22axKVFM0qR
         PPg2MIL5wBoFsmbJz35YwNkIT9gKNYrUiGUwCI8aQlZRBChMRR/EgbwtexPzMLusk+cc
         uU6YFQuR0AC4SXlk2mSne5Vs3iQ5Zq0bp6a3BFf2D1utdXLYcm/7NFYbzX2DDcBl0AUc
         /8VA==
X-Forwarded-Encrypted: i=1; AL+hErEO/HRSZvBGR5bZFwdss0OJLGIjicHw+WwVgqTX5U12fkXNYO+4rTa/Gd5t+w00yAq6frtCvnLgl5Yx@vger.kernel.org
X-Gm-Message-State: APuU4Z9i8ltc45CpP2Sn+qZpKuROwJe1yDOnJxLbVGIER0BLFKN+1oG2
	cc5+W1cxgP65yaljwU2DjzVHNQWjJzBXXXfy0wLbMmlDNhJVv8ste0J4JDByuHK92OE=
X-Gm-Gg: AZFdTZfWFiQlVOkodxB/MwZ1LKT0Re4b0l35r2K68G6/cYCw0OwnAMPmwpB7P68svCo
	P3+i82gkqZFpLTqFRfGW29PkYFNNXQ5txak367z24UI5RSnEZRPM55HJreec8qHkp3zBEzL2gG7
	PtMhX/G3GOPY6CGO6iyGR5CstKz1ew3toHgPHTjSGWuQuPS7jPKE4YfThuUoOPg2GVjMk80/fue
	rxOPQY93Tj+BUPXCBjgo5sbsJaZUUZWqy21PE0pzcFJlSvN5jTrSWaICk6y1fFxzHWNX7BqNiE3
	tcU6NbgLYmPdUQlmhcencXlSsbMz195Jgz1yw5j+eOgsULKo6fJSdrgrC4w1sFFNsr8jwf94/1b
	BIL3plcFyE9scawgKx6kpTCJREvf6NdhY+7++rHGh0laCRqFPQFgEjpB7d503sWiaZnEU9XN/g3
	lZ/Dn3qEP+oF7gthv8n0NnQnKD/FkhChqpzhcRlgV8oX2qq4PuzAA5eb/ex7sR+iKGIDQtTR2L6
	8F1PsgkWpJP9IHaCX15mem3Pn34OaiFh5MCNaGvb8qOYnpKR789pOGEDJaE5jUV09zrfjHMrh5+
	rbIo2uaY9noi4Y/IhY/NbQpScki1rmVyEjVFs1fMRZLcbLGqHn5yVKSQj3u3d4VXgOtQgJtT2i7
	TnXK7oW/nmW6W+oht7lfughmJpNCCYDptpy5AwKeNTed1f0Lva+tjXPVo5X+ezJyZHXPso5FQHL
	oAzk0zSFnZpSxLd4HHYghHnZYCY5ptpLmP5IXhZFSpqJg/oHif66PThf0XhFvBhSYZXllQ/TkVw
	8hdE+uHCJLDqkCyEwlQAV24
X-Received: by 2002:a05:690e:1446:b0:67e:653b:319d with SMTP id 956f58d0204a3-67e653b3b4dmr3232301d50.133.1795858001577;
        Sat, 28 Nov 2026 01:26:41 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df33105fesm12336245d50.7.2026.11.28.01.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:26:40 -0800 (PST)
Date: Sat, 28 Nov 2026 01:26:39 -0800
Message-ID: <6e833f169d0c31a3a7da7581c68d4aee5d348ca1.1795842371.git.chris@chrisdown.name>
In-Reply-To: <cover.1795842371.git.chris@chrisdown.name>
References: <cover.1795842371.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 5/5] scsi: sd: Fix unsplit discards when the granularity
 exceeds the limit
To: "Martin K. Petersen" <mkp@kernel.org>,
    "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

The block layer doesn't split a discard when the discard granularity is
larger than max_discard_sectors. A disk in writesame_10 mode with an
unmap granularity of 0x10000 blocks then gets a 0x20000-block discard
as one request, and sends that as WRITE SAME(10) with a count of zero.
The other modes have room for the count, but the discard is still
larger than the limit we set.

mmc and drbd already make sure they don't report a granularity above
the discard limit. Let's do the same here and disable discard in that
case, as drbd_reconsider_queue_parameters() does.

A zero limit isn't enough on its own, because a discard that was
submitted before the limit changed still reaches us, and isn't split
either. So set provisioning_mode to disabled as well, which makes
sd_init_command() fail it.

Fixes: c98a0eb0e90d ("[SCSI] sd: Logical Block Provisioning update")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 drivers/scsi/sd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 792058f52f65..ef9c2d55c933 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -206,6 +206,17 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
 
 	lim->max_hw_discard_sectors = max_blocks *
 		(logical_block_size >> SECTOR_SHIFT);
+
+	/*
+	 * The block layer doesn't split a discard if the limit is below the
+	 * granularity, so we'd get discards of any size.
+	 */
+	if (lim->max_hw_discard_sectors &&
+	    lim->max_hw_discard_sectors <
+	    lim->discard_granularity >> SECTOR_SHIFT) {
+		sdkp->provisioning_mode = SD_LBP_DISABLE;
+		lim->max_hw_discard_sectors = 0;
+	}
 }
 
 static void sd_set_flush_flag(struct scsi_disk *sdkp,
-- 
2.56.1

