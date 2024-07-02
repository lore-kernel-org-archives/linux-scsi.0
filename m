Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CDB148825;
	Tue,  2 Jul 2024 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936525; cv=none; b=Q2tQCyeP8mm7qlrT5Be6gWXlA1PhI5fNwqO0neZ8tg7fdpFkig8xASP/st/lXbltdyP5WqsQNH+7qEDydB0BX1C+u4v6tgEWFJg4dYRFMmJ0TBxPpRHg0j3W8HFqVPOmRbfRzgebdw5l+34BMbUPTfTSStsd6uahj7yXQSTYypY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936525; c=relaxed/simple;
	bh=gPbInyMbE7OFPzXDVK+ChS+iQcVWiyhWogsVEQ4IImk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9Ee55xGZQlPMwv8pH3IFpZSoTHCmf1HUCOdyJpn8QhJNiZlklIpX0QtzpNJPRAcJ/IlOUspuqyOA2/PBhdm+1RKGNJdFTTnlLm/n7J97R06H7rhI3I+srl3r9fP6fRvGcvF08K/pq6TOxzewxP4HTRoi1AiWvxmkRd3/AnT1OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORPfyhB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORPfyhB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8DFC116B1;
	Tue,  2 Jul 2024 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936525;
	bh=gPbInyMbE7OFPzXDVK+ChS+iQcVWiyhWogsVEQ4IImk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORPfyhB3WyIhCzajiMrCba8esOh9WskGQIfwpo5MqVeddHJIfFbxIm6QV+AF6PpDu
	 GDeNzSnTJIPS4gu54sevx8vwRtrPml5Z1ht0QUPCYMOcFt3CdbS9bdNb2w+wEeFdNg
	 Crke/rY9ltNODx2Qhf1LZWMa4crRLVvOCXpIjGzHmdyZdzKWELkfjr3JN/4ixoxcOf
	 8AcDh09Zl73RFtHJ3+cYBukp4nlf0QNOBqHAQoc4Jwnr2JC5+twbG8dQkSbs1E2qI5
	 kogpVQxkA6sdZBcPNNrL0Y7n/5NQJGwZjRQJw9qNaqOkOocLzBrs3E4gDhLW4q+jka
	 RWE0uIIvsm4+g==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH v3 2/9] ata: libata: Remove unused function declaration for ata_scsi_detect()
Date: Tue,  2 Jul 2024 18:07:58 +0200
Message-ID: <20240702160756.596955-13-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702160756.596955-11-cassel@kernel.org>
References: <20240702160756.596955-11-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=916; i=cassel@kernel.org; h=from:subject; bh=gPbInyMbE7OFPzXDVK+ChS+iQcVWiyhWogsVEQ4IImk=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVB/vr5T1kNRUMLewzM0Tm3iFY87yN/d19N9d2irx9 gl/yXL7jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExE1YGR4fgywVcqa7WXxGby MVfknRF9M1Eoubc2QOmlTODb5XoFQgz/bN+n/WM3npH/7N4Nyf4NjBf9GLo7rKfv9ipWdwn98nU KIwA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Remove unused function declaration for ata_scsi_detect().

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 include/linux/libata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 586f0116d1d7..580971e11804 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1082,7 +1082,6 @@ extern int ata_host_activate(struct ata_host *host, int irq,
 			     const struct scsi_host_template *sht);
 extern void ata_host_detach(struct ata_host *host);
 extern void ata_host_init(struct ata_host *, struct device *, struct ata_port_operations *);
-extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 			  void __user *arg);
 #ifdef CONFIG_COMPAT
-- 
2.45.2

