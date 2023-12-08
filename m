Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="EhdL9Gsc";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="EhdL9Gsc"
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9E211F;
	Fri,  8 Dec 2023 10:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1702061065;
	bh=qaCnYPlBMIzaa8Uz/9BoJw942PlrsJdBc0gloYteYG0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=EhdL9GscnNzI6KeaYHVCqN7Y6GSEnGsVY6peYKiwYi2LS9GwEAIhXNtmGKzHF8KPd
	 g5M9t0tfpLB+Zpz0zW2jASrBuhelKs3PjWLBPW+/+4ddg+o7ICQtHE4Bc2S6ImvEc0
	 3emygQYEuiZbcYRWpw1KiS8a8ZlYgP247C85u30g=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7FCBA1281EF3;
	Fri,  8 Dec 2023 13:44:25 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id W3mO3yodjRzM; Fri,  8 Dec 2023 13:44:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1702061065;
	bh=qaCnYPlBMIzaa8Uz/9BoJw942PlrsJdBc0gloYteYG0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=EhdL9GscnNzI6KeaYHVCqN7Y6GSEnGsVY6peYKiwYi2LS9GwEAIhXNtmGKzHF8KPd
	 g5M9t0tfpLB+Zpz0zW2jASrBuhelKs3PjWLBPW+/+4ddg+o7ICQtHE4Bc2S6ImvEc0
	 3emygQYEuiZbcYRWpw1KiS8a8ZlYgP247C85u30g=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C6FA312817A4;
	Fri,  8 Dec 2023 13:44:24 -0500 (EST)
Message-ID: <04e6cd5c53b77f7cf01df448525709f1eb7b7712.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.7-rc4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 08 Dec 2023 13:44:22 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

One tiny fix to the be2iscsi driver fixing a memory leak in an error
leg.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dinghao Liu (1):
      scsi: be2iscsi: Fix a memleak in beiscsi_init_wrb_handle()

And the diffstat:

 drivers/scsi/be2iscsi/be_main.c | 1 +
 1 file changed, 1 insertion(+)

With full diff below.

James

---

diff --git a/drivers/scsi/be2iscsi/be_main.c
b/drivers/scsi/be2iscsi/be_main.c
index e48f14ad6dfd..06acb5ff609e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2710,6 +2710,7 @@ static int beiscsi_init_wrb_handle(struct
beiscsi_hba *phba)
 		kfree(pwrb_context->pwrb_handle_base);
 		kfree(pwrb_context->pwrb_handle_basestd);
 	}
+	kfree(phwi_ctxt->be_wrbq);
 	return -ENOMEM;
 }
 

