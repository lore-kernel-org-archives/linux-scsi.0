Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB8316D9C2;
	Wed, 16 Apr 2025 08:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793006; cv=none; b=XdejxhpnW5YbALrZX7puTHcZFnamsJMO1a+JZ5oMVb752WOoG/5i5oFLyeuEftDdZQEEAFyATtNfB+KPv2Q7tDz3HVhRISmktAKfUnhUrK8On1/LSkLq+M6evU7D2TbUYORxesQHKlBwb6zjyZKrAlji1bJ6dWmQS1OmceiAJxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793006; c=relaxed/simple;
	bh=3uo6MB6VnKgDqvxnaj6h84rvVaHk1H/NFJSScIYSVio=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WR2qICMz8GJd+JU8lgWm7k03q4DFgflQRZ5Cx2G0ZTAjv1hkxYmB3N0tgKgdjK7SdVcVvSo40sh/klG64QUQuvQ8BepBs2L/he0GUHCsEpKNccIHZwQc101Ar8Y2ZdRCcHlFmy110+N4Ox/he9qGIW9TJ04nPqLK88V0XpIy8jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5scOhPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5scOhPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAC2C4CEE2;
	Wed, 16 Apr 2025 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793006;
	bh=3uo6MB6VnKgDqvxnaj6h84rvVaHk1H/NFJSScIYSVio=;
	h=From:To:Subject:Date:From;
	b=P5scOhPMJtC1M2CIPYbq3hsKS/0z1dAYsMKG+mhmjuVkOCJGpNSl45TBOWiXVoJzB
	 tNNsYMnEaFIYN+9f2t0JL//I/G9+IjnYkAr4nmN3hd1xcPxj9BeuEBO03SkSIgWw6D
	 NfSx5mnbigtEO9rpRQCmONfFo3Fl851eS/AHXFpG6127j68Oxt7E1snZAr8i9LITV/
	 xO2xwN5mPa3RLIJYfAFEpIeqMkohZ5K7lHcwGQYOH+yHAdXAnUAdcgYdYbubjZd96C
	 0aL/XvxZszWa24u5FJ1sDCJ3VjMoXTjrYRGFeRPjmrQDw7mHaBzfXa+TcDNXUIpMnL
	 zi+M/yqFUieOQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/3] CDL Feature control improvements
Date: Wed, 16 Apr 2025 17:42:35 +0900
Message-ID: <20250416084238.258169-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Control of the enable/disable state of an ATA device Command Duration
Limits (CDL) features has issues:
1) Incorrect feature state report translation in libata-scsi
2) The state reported when enabling the feature was being ignored, which
caused needless SET FEATURES commands to be issued to the device, thus
causing an unwanted reset of the CDL statistics log page (which is
implied by any CDL activation action).

These patches address these 2 issues.

Martin,

I can take the scsi patch if you are OK with it. Or the reverse, you can
take all patches through the scsi tree if you prefer. Please let me
know.

Damien Le Moal (3):
  ata: libata-scsi: Fix ata_msense_control_ata_feature()
  ata: libata-scsi: Improve CDL control
  scsi: Improve CDL control

 drivers/ata/libata-scsi.c | 19 +++++++++++++++----
 drivers/scsi/scsi.c       | 36 ++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.49.0

