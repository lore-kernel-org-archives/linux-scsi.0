Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170874;
	b=UM2OaSBFV4ZgLh32m3qzDbnidrnd8laEGJmCImMxRCBYwWRu/EkSxhVeeZcqajzZMbZC
	 zAf4/qlLXKsiWnYIGLBfFb/btHXKKTHAOrSLQIgVVIBrCumVaoDPDA/M2KKf6Awyy0yjE
	 +8irrzy2+sq34VEt0gPp3iNENw4XvMWHnJV7CPLQnWg0er0bdOb9DGzs3Wx6iv9TJY+Wf
	 JU5+9HpW0aHSsih/z+UUwcYaakKD5QY2gZfpZnWhcsKdOas4oRCnK5z831ChVqZHWXnTY
	 96oI/fDpCFg+wYB/lgT6otggAIKb6LkSl8d38qavffUfT30ZJZjsvn/IOxhD+doolcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170874;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aNzkqDCBVXwmi5oj0PGy5yPAAg5hMAVbnirK2n7hgX4=;
	b=Mu7akevKiJU4h/pWhGU1MFdNoMsM3uJnhA+tiXoT9pn2Kyzr8GU1h6A6YOgWGiGV7p28
	 uNO7D0j/srLRETOllZoy+SEUsb0QwlVmTjwJt+Cxox0sMHj9Vw7+Ec3HxzQoFXNvrofb4
	 NE0cOdAkuni6y562hwnFSUQ4z9BUofD9RdUOACF/2cm5KllkIkF/3Fj+hRv2Lr0g0WofQ
	 rNgHQFYJkGC/tLaoyTLZv9tvyLISIxkYaxnvxLwPAZmKWWfvy74oXbOzANDrbAi/uU3S3
	 ok1p50+gf/7vBQHNh0QxJKBBsnWrCp/4Sff89JacRaG2LEEeoEAnksDBXSmEjEaXr8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZxUl3w55;
	arc=none smtp.remote-ip=91.218.175.226
Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093FC606A322
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:47:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 093FC606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZxUl3w55
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Q+2pKZ+L2WOBU15nwp1Wi0VRAz2LduR8/HNqLcSY8YQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170871; v=1; x=1794775671;
 b=ZxUl3w55KgPzPTNm5iVSijHlrMf5EXOAc4m1hAD7uDigKoIkbGzkoR3F/w27tYnp0cUCgkDY
 jK32uHrQaZwhtAexWa3xHyxIzZ9KGtmb2oVirH4kziEd+Bu9Vgg4kRfNFBNR9zLv92S8QGS+hhb
 3A5SytfUjnbyNVvjGRaIe9LQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 3ae26450b5a369b2;
	Sun, 08 Nov 2026 20:47:51 +0000
X-Mizu-Trace-ID: 3ae26450b5a369b2
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 01/29] scsi: core: Clear cmd->flags for terminal queuing error
Date: Sun,  8 Nov 2026 20:47:05 +0000
Message-ID: <20261108204733.557995-2-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a request can't be queued in scsi_queue_rq(), then we error out with
a blk_status_t code. Such a scenario may be the scsi_device has its
transport offline.

For BLK_STS_RESOURCE or BLK_STS_AGAIN, the request will be requeued in the
block layer. For other errors, the block layer ends the request and so
we won't see it again (until recycled).

Normally when a request completes scmd->flags is cleared in
scsi_end_request().

However for the error scenario mentioned above, scsi_end_request() is
not called and so scmd->flags is not cleared. As such, when the request
is recycled we see the old value in scmd->flags.

Fix this issue by clearing scmd->flags in the error scenario mentioned by
calling scsi_cleanup_rq().

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b52b4c5daa42..36bc995e4e25 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1994,8 +1994,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		 * we hit an error, as we will never see this command
 		 * again.
 		 */
-		if (req->rq_flags & RQF_DONTPREP)
-			scsi_mq_uninit_cmd(cmd);
+		scsi_cleanup_rq(req);
+
 		scsi_run_queue_async(sdev);
 		break;
 	}
-- 
2.43.0

