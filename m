Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702FC1DD0C9
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 09:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887092; cv=none; b=PbplX7x7Jz9PUZoZ156kc4ecI/NH2qLDIwhWWztGBes0edGKTW4+3emB8P8tezxpR474bRP6mL/s8oNCKExUo5xr7V1IyglnmC3xbK4XPFBOP09Whz4eqL9CEUxvSMa1WOkM4LqvwT6b8wnAf8NRJTCD3w4AMSb+Qda8MR4+O90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887092; c=relaxed/simple;
	bh=x40R41wS28JHaszElwyf6IwMxjE2egr5A3XtFUi/S5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0ICXRdURdF/I5qy3cNg2RyL+H7nuUWKdvcXijUbuwHKvKNdmmRJzjBFqb/6BhnqzVEguojWJU4OREqCCKVd5DUxV+Frnb5hjyQ3DeYK9ISYUvZNv9VT2QWih81XiQZPdcY8DGslXc37iw+gKQkm0GgXHR8HDHleKZjNA7xej2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=oX8qFbln; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="oX8qFbln"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=QDqJYncT/PdMgfRzyz2Q49vpB2LdWEH5W9QQkI2VqQY=;
	b=oX8qFblnb3kMOL9EVpY8oZN2AZQ6tnVpTn7ohnhDF3RSb6TAzdZIf8w7V97NIYtzUTBbRYkLCwKQe
	 4m2VXOl1h/8yYgFsdNaS+mOknBt1t3u6p57pERmfH2SX+VgVcW5qCnrMS9Q7Bk7DuFkuP2G3YDmdj/
	 KAunCj35oDDbf+KBuF6VgP/xI+kMZDY3yNaAFfyR4BdkSrQISnAPjyyjpkwejz9coapjN6dFm4AF73
	 nsjRmvl/5VO8Vkwr7g9SCuYrdqtgvgRWbA91D0Bd20ZFrThTwB3/K9MrRTBuy3Cf/BfB8t6l4Jpktg
	 rm9YXwLwwVXgwmXc2YFqC7J1D/x7+1g==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 982c1968-9c25-11ef-9ac8-005056bd6ce9;
	Wed, 06 Nov 2024 11:57:55 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 3/3] scsi: st: New session only when Unit Attention for new tape
Date: Wed,  6 Nov 2024 11:57:23 +0200
Message-ID: <20241106095723.63254-4-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
References: <20241106095723.63254-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the code starts new tape session when any Unit Attention
(UA) is seen when opening the device. This leads to incorrectly
clearing pos_unknown when the UA is for reset. Set new session only
when the UA is for a new tape.
---
 drivers/scsi/st.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c9038284bc89..e8ef27d7ef61 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -991,7 +991,10 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 			scode = cmdstatp->sense_hdr.sense_key;
 
 			if (scode == UNIT_ATTENTION) { /* New media? */
-				new_session = 1;
+				if (cmdstatp->sense_hdr.asc == 0x28) { /* New media */
+					new_session = 1;
+					DEBC_printk(STp, "New tape session.");
+				}
 				if (attentions < MAX_ATTENTIONS) {
 					attentions++;
 					continue;
-- 
2.43.0

