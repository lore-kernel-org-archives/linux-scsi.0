Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F43346EC69
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643028; cv=none; b=Y1asMJE3DdILIxiZ6BMn3DcMbQ1ca3GNsN8Pc7l7HAsTMjiSpZUDEkSTn1q++ajJ/7yIkH2yuKV1mlbmmwLF9+UMT6XRDaFEsmlXkBl/j3weWkzyikGpoRotrL2O8wfEnVzdacEmtsyrDW5WioMv4mtbcB75YmJBBJ4bA/63HIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643028; c=relaxed/simple;
	bh=hkVOl58yd+0xIc4PcYzqESS6hoMu+ewI0a6xW+GBSxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DpsK6V0VLqiG7P5ruMayK7WBOR3HOItIvD1DysWmq0HLryYWXkNP7cqbh4Mn8NLoBL6BN4ioUOe32OHHntp7GyA/82+0cKwRqV0VRiXw7k7hQXdhqhiGXkTK2A48xFRHhnejIG+R4PXiUoy/zDmVDpExtuKFUEl88Yw8CIJMqsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzSdDhN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzSdDhN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F270E1F00893;
	Thu, 17 Sep 2026 11:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789643020;
	bh=FBzIwS2bmSnQJ3wnma+F5T4ZoKx6859XdWq7gkQI93A=;
	h=From:To:Cc:Subject:Date;
	b=EzSdDhN2XlF+BgOYsFe2RtLJI/8e7BsT3mWVB7yu+ooxMHWjGxuwP+AqmkGCidRkD
	 xZON9EAB1gdoRz28iCZIXL3HkyBk/qM0/Thi+c8SMku0zImblgwnnyYugjeclas1Pr
	 gnjuBkiMlQeydechRZ/WUlzB0Iry837EIrdhs+ief3hp8x4OU225lh7GinpOsGunBy
	 bbn0UhUw/0hno97+FzsfA/sf9+SI4DhKbYfj1Oftzx8ahQtqRTb16cRLnM/vZcit1L
	 3EbrVAOn9O9HpJ/6yPDK3UMfPU+u3rnYxOWcLHHFSfnlw6qb9mQPD0Ti8AAkp+WtCv
	 Z9YocSLFKiGBg==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v2 0/4] scsi: scsi_debug: fix zoned write validation
Date: Thu, 17 Sep 2026 13:03:17 +0200
Message-ID: <20260917110316.1104863-6-cassel@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1548; i=cassel@kernel.org; h=from:subject; bh=hkVOl58yd+0xIc4PcYzqESS6hoMu+ewI0a6xW+GBSxY=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJWn/iSVpj39jTLxKZJ7dE6nJPZufPnOPxwD9J51/ZZ4 gbLWYXJHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZjI6zqGf+aeE2rfKRq8svt4 dP/D5MqWrgdtSioLFeZmpx4TUNzJdYGR4fgXH3NNv9gkKfaCeepTH/UKTzw5w2H9Y/6j0xfd+yR 2igUA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

This series fixes scsi_debug with regards to writes to a ZBC drive.

The series is based on 7.4/scsi-staging rather than 7.3/scsi-fixes (as
Damien suggested on v1) to avoid a build warning that would have happened
if this series was simply merged with linux-next (7.4/scsi-staging):

  error: too many arguments to function 'mk_sense_buffer'

Tested on a zoned scsi_debug device with 512 byte logical blocks and a
4096 byte physical block; the notes below each patch describe what was
observed before and after it.

Changes since v1:
- Based on 7.4/scsi-staging instead of 7.3/scsi-fixes, with patch 2
  using the combined sense code introduced there.
- Added patch 1, so that none of the write paths advance the write
  pointer when do_device_access() did not write all of the data.
- Patch 2 is unchanged, and has picked up Damien's Reviewed-by.
- Added patch 3, which marks the region that WRITE ATOMIC (16) wrote in
  the logical block provisioning map.
- Patch 4 advances the write pointer only when all of the data was
  written.

Niklas Cassel (4):
  scsi: scsi_debug: Do not advance the write pointer of a failed write
  scsi: scsi_debug: Enforce physical block alignment of zoned writes
  scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
  scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)

 drivers/scsi/scsi_debug.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)


base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
-- 
2.55.0

