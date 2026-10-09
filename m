Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B72247607C;
	Fri,  9 Oct 2026 10:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541451; cv=none; b=GqbucRdizygvEn+Xcpd7uCw2mmR9iIEWDeDPIMystH4ZWBUk5DCpQAu9n4K0X9K+W8HMx15MZ/dj/Jx0yudQNbGo5hFO4/C6vqWnWsscGX/qWYjFsT1PsO+csMaSwoePOP49F2iagVq/tbGepmu5xR7zFQ6Yv89gdTOnmgzcAN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541451; c=relaxed/simple;
	bh=YQhyyWfE7Q5RyxXQcP2KbdJbzPKfluIB/CXArj3LoDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMnAOqF4m8FvTzYse7cm1TXlqrTkkECX7WuYrL5JT+gGmim6+17PIy6iyOoaylhfNppTj0vmzRKKM2f41M2BNFHL0ONwKD0uY+QKSNcm3Gpsp1R+WmfwsbDkW8b+HYgcODzKS8VJkePaNjNXEbs1j2UfpYhQxzOacOxVTE5X/Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=M58Z1KrG; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="M58Z1KrG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=31
	fx0uSseVyNQSl00NLL5iN/tVXytomohfmqZXo8rdE=; b=M58Z1KrGHJuUIb7vim
	vc46lqH9cfxstzIsWHtEE9O9RenZIPZfqAvsAYG8iQOI8oOpTsL2dmJm5BkKgF6x
	UoxphM4esoiU2D9IKXjBKIn82t141rbUjNgvRprLQXzWbky56eocDkZM01+k8G/Z
	DpkKwNJg9yl6ozGqwMWBw7p30=
Received: from WIN-TOG0NDEIICD.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBnjvSRwMhqk4VBDQ--.5655S3;
	Fri, 09 Oct 2026 18:23:15 +0800 (CST)
From: Shirong Zhao <shxzhaosr@163.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Dongdong Hao <doubled@leap-io-kernel.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] scsi: mpt3sas: check set_identify result in update_links
Date: Fri,  9 Oct 2026 18:23:10 +0800
Message-ID: <20261009102313.18-2-shxzhaosr@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009102313.18-1-shxzhaosr@163.com>
References: <20261009102313.18-1-shxzhaosr@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnjvSRwMhqk4VBDQ--.5655S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr43ZFWrXw1rCw18Aw13Jwb_yoW8Ary3pa
	yDur98Cr95GF4I9Fn7Gr40qFyUG3WfWwnrtF4vgas5AF4Yqryftr4Ikwn0qayUJFs3Xa1v
	qw4Utrn0kFWUJwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07ja89tUUUUU=
X-CM-SenderInfo: hvk06xhdrv2qqrwthudrp/xtbCxRMhX2rIwJPSAQAA3K

mpt3sas_transport_update_links() ignores the return value of
_transport_set_identify(), which leaves the identify struct untouched
on FW query failure (host/PCI recovery, config page error, bad IOC
status).  The phy is then attached using a stale
remote_identify.sas_address from before the failed query.

Fold the call into the if condition so a failed query takes the
existing zeroing else path (same "no valid identify" state as an
invalid handle/rate) instead of attaching with stale data.  The next
successful link event re-fills the identify.

Verified against scsi.git fixes (469fa055664b), the current SCSI
fixes tree.

Signed-off-by: Shirong Zhao <shxzhaosr@163.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e74a526ef..ffd1d37d2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -1179,9 +1179,9 @@ mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 	mpt3sas_phy = &sas_node->phy[phy_number];
 	mpt3sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
-	if (handle && (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)) {
-		_transport_set_identify(ioc, handle,
-		    &mpt3sas_phy->remote_identify);
+	if (handle && link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5 &&
+	    !_transport_set_identify(ioc, handle,
+				    &mpt3sas_phy->remote_identify)) {
 		if ((sas_node->handle <= ioc->sas_hba.num_phys) &&
 		    (ioc->multipath_on_hba)) {
 			list_for_each_entry(hba_port,

