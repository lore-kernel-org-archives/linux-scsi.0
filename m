Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A78179CF
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 01:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730336447; cv=none; b=nl7f4eEdXy4Nb+UKOZVnbtn74jhDScVO3yM1EafeidV/FTMbjAjHdMQVAuzqZQtNQ5coN34aPai/wTGeG2UXkqI7yMgRNSRT7fbKKpX8fZgB3BrD9N72zFZw+/FBjaI0A2pgdW0TqEw0rXS3Rv79FDfDGQ4YPAJ84R3JtL4v7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730336447; c=relaxed/simple;
	bh=hKWQCLREMvLTx1SZGzy8pC4vfowsROrFJSzHcICoC5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=UMF+dlTxpMZkQlb4ey/ZJdxZjxwf0axCVnsSF9BnRmCw9TKnfeBmBCQkcE0tecy/5asEYnFxuSJzm53sPkCf2kLMsOkLMATagenq8cuaor322Tb44jnUmlMkN3c13TQrTvMlx65RwVCIC9DaRY6da2fQi5G1woyerZNiuAPI0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J4oa58M6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J4oa58M6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730336443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4kp1sUdq/3GLRew0DS3qXKa6cyGjV3a4UMrvEyrzrak=;
	b=J4oa58M6Nghv/mkU05cmbvjugkkdUVgoRTPCmlr1E2eqE2Li6KLC+VRl/E7BPY4mDyBfBK
	sYhANQzLQlPTVtenxoDqnyN5hDBJ+SmU41Q/kj28p0RP54FCZaOZUafhfGlsP5aArh8CcQ
	GQzk0FMX7wXR+q6gf05d7obNp1TV9v0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-zIHXQ7mxNX6s1Tk3VY382Q-1; Wed,
 30 Oct 2024 21:00:40 -0400
X-MC-Unique: zIHXQ7mxNX6s1Tk3VY382Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A02B19560B0;
	Thu, 31 Oct 2024 01:00:39 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen3.rmtusnh.csb (unknown [10.22.88.108])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 403531956054;
	Thu, 31 Oct 2024 01:00:38 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: linux-scsi@vger.kernel.org,
	Kai.Makisara@kolumbus.fi,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	loberman@redhat.com
Subject: [PATCH 0/3] scsi: st: improve pos_unknown handling after reset 
Date: Wed, 30 Oct 2024 21:00:29 -0400
Message-ID: <20241031010032.117296-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

These patches address some issues with positoin lost handling which
where introduced by commit 9604eea5bd3a ("scsi: st: Add third party
poweron reset handling"). That commit added code which detected any
unexpected power on/reset unit attention to st_chk_results() and
correclty set pos_unknown in the driver.

However, the aforementioned changes is catching POR UAs that are
expected as well as those that are unexpected as st_chk_results() sets
pos_unknown every time a POR UA is seen.  This results in a change of
behavior that is confusing as some tape drives can set a POR UA when the
system reboots, the driver reloads, or a tape is reloaded. This results
in regressions as MTIOGET now fails following and kind of reset.

These issues are documented in the kernel bugzilla:

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219419

A reproducer test script can be found at: 

Link: https://github.com/johnmeneghini/tape_tests

John Meneghini (3):
  scsi: st: instrument the pos_unknown code
  scsi: st: clear was_reset when CHKRES_NEW_SESSION
  scsi: st: clear pos_unknown when the por ua is expected

 drivers/scsi/st.c | 63 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 9 deletions(-)

-- 
2.47.0

