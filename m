Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754230;
	b=pIMbtqlsWuWqnbVPBBU9l8cMO64NO1lQG62ojdhuF0mDBez3G21jPhbs1C9r3aaryjtN
	 1KrPLQibtNiqDbS6SvgYMuNwvxBG0STjWiCo+o7jQohYvRn5Mmfe6GLUZLG8mDI+n35/0
	 2kXCFh7Jrr3afdQUdEQTtdnE+TvhJrDCMK+hiSeArFM8wlirVD1VxNRO4DCQSGR0VytsE
	 EDmmD+DC32aeu8pJLHKKXDUSm5G8leJoVad/tHKMxs6jxZl5Ubr13s2YBa422Vz6uvO/z
	 H05OwXHBWMOOOnHJ9k1lfXWN6KwI6am4UCDnWilbXBA41kqCdknBh5C2dwQvclb7e6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754230;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=aG7SLsBMCKK3KHh8tJEKySbfqFCHL1//lVE0aKE2nhk=;
	b=tzqSlgZyKY98QdonPtcNaodEOMTKmpmkqOKV+352PpOMEUSMh6+MdhpSaHLh+b+/eDSs
	 VPoAO2QbZCa/9z/oKvXE5w4EfR9DYMO39ewr5URnWufi6cC2yYfB8oEk9kDMRqrQQIk77
	 e6KeOpY7mcbq1NuNp+wj8oyMK4f/JtKNbQajxl7f6tOZm/NAEspkaWn4Ws6o5WAlmPMJb
	 GqD3xQYwxeFfsQza5y25r+pajUlJlDstQE14dhNJsSwSic24x0nsdtfThA/Q7GNP17SpA
	 vhnSsJm7HUCZPTpUAS7tkxDYb6uCc++vuNw7AOh/A1SaST9J599Wh/vukRr7LamueQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSaBeUGv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9CA606A327;
	Sun, 15 Nov 2026 14:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSaBeUGv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691B81F000C4;
	Sun, 15 Nov 2026 14:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754230;
	bh=aG7SLsBMCKK3KHh8tJEKySbfqFCHL1//lVE0aKE2nhk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=CSaBeUGv0QmGCX+1MBoaF5iHePmPYnQ4/pilCq8qWzRvyMa+jHCRjfY+2ReJNrT19
	 59+9n988iXqBzx5BJ12oEORhZr0DzocPPld5MMY3E0P8Rwr9TM7sZRrYZDynvNkRK4
	 k+LCPpMmtWUSiGK/XuiIsEucNyLOCzUXKc87dFWa7MZMniahxEL/7j/F/ye0NNCOZg
	 xGi+mysEdgaKSltblskV2IWWhXb0iCAxKeW+Mo8mjjZpSkRGyjklsegbnPSP9ydKMn
	 BPFPkWKRdpGZjZuOBn+bz30fdU3GG6/BElWaq7/B1cKoFpOPtbXVoh+kdPd7c81lVu
	 QAJfNSFfcny+g==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 10/13] scsi: scsi_proto: refine the definition of storage element health
Date: Sun, 15 Nov 2026 23:50:12 +0900
Message-ID: <20261115145015.938426-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
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

A disk may report the health of a storage element as being within or
outside of the manufacturer's specification limits using a range of values
for the health field. However, in scsi_proto.h, we only define the
start of each range using the SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS and
SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS enum value.

Define the full range by renaming SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS
to SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MIN and by defining the
healthy range end with SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MAX. The
same treatment is done for the outside range with the renaming of
SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS to
SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MIN, and the definition of the
range upper value with SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MAX.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/scsi_proto.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 9c7d31aa6bae..f290a214e3e0 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -408,9 +408,11 @@ enum scsi_phys_element_type {
 /* SCSI physical element health. */
 enum scsi_phys_element_health {
 	SCSI_PHYS_ELEM_HEALTH_NOT_REPORTED		= 0x00,
-	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS	= 0x01,
+	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MIN	= 0x01,
+	SCSI_PHYS_ELEM_HEALTH_WITHIN_SPEC_LIMITS_MAX	= 0x63,
 	SCSI_PHYS_ELEM_HEALTH_AT_SPEC_LIMITS		= 0x64,
-	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS	= 0x65,
+	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MIN	= 0x65,
+	SCSI_PHYS_ELEM_HEALTH_OUTSIDE_SPEC_LIMITS_MAX	= 0xCF,
 	SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_ERR		= 0xFB,
 	SCSI_PHYS_ELEM_HEALTH_DEPOP_REVOKE_IN_PROGRESS	= 0xFC,
 	SCSI_PHYS_ELEM_HEALTH_DEPOP_ERR			= 0xFD,
-- 
2.56.0

