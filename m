Received: from kurisu.lahfa.xyz (kurisu.lahfa.xyz [163.172.69.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A755A18DB35
	for <linux-scsi@vger.kernel.org>; Sun,  9 Mar 2025 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=163.172.69.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741529265; cv=none; b=JmOi4bRBrE14tHaxgJP46yq0an7rGsME4ldLvHYu7vIcSNnAUn9iqi50X4fJwnT7pDVwtqVsfOeYUcgq95GS0YYpwaD5CE02Qg1GCA95rsInUAs6+5Wyaih744xVgi6hUR8VK/4G4WYq9IbeLcUneIM7EgfuaM5sI6bXP7l6/kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741529265; c=relaxed/simple;
	bh=c82KHWNRf1iUmfQhiMk9Cqn+oWsqAgxHyn+njvcfGBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL90D++N5iTAeEj/LZFby7qKEsvKWmE5Jr3cMDCZiqoaPj59nimnIlZnPAtm/2Kux6jJbCkCiRsobq28EbFLRA64vn5Tt+1S3rZOX2zh6V0lEX1MY+JN0Cko5U1x8LaXAMlJzGA4IJ/s7piMox8Bcsr595YNKe9Oa1rUjANL5I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lahfa.xyz; spf=pass smtp.mailfrom=lahfa.xyz; dkim=pass (1024-bit key) header.d=lahfa.xyz header.i=@lahfa.xyz header.b=OrIsAFI8; arc=none smtp.client-ip=163.172.69.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lahfa.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lahfa.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lahfa.xyz header.i=@lahfa.xyz header.b="OrIsAFI8"
From: Samy Lahfa <samy+kernel@lahfa.xyz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lahfa.xyz; s=kurisu;
	t=1741528703; bh=dKxaUQbi4jA6Kay/yyTdaP5y13gre17UREL9EtTFPQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrIsAFI8R8DHtQdsOoSU2+X7kC7bD8F/4hmSy7UcLTN1YXTcsFwafMYUtDP5NZ/eL
	 vyspsK8mMj0AdHlBqJolN1/EciZAP+KUpbRgzHnulJS1mD7ZemcEtufCHDiyK1Mzmd
	 mi75jy95aFkk2y92+nSQ17HzrtXJs88NMmjDac7w=
To: vt@altlinux.org
Cc: chandrakanth.patil@broadcom.com,
	kashyap.desai@broadcom.com,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	megaraidlinux.pdl@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	sumit.saxena@broadcom.com,
	Samy Lahfa <samy+kernel@lahfa.xyz>
Subject: Re: megaraid_sas: multiple FALLOC_FL_ZERO_RANGE causes timeouts and resets on MegaRAID 9560-8i 4GB since 5.19
Date: Sun,  9 Mar 2025 14:55:31 +0100
Message-ID: <20250309135728.3140904-1-samy+kernel@lahfa.xyz>
In-Reply-To: <20240216100844.aabjlexbwq6ggzs2@altlinux.org>
References: <20240216100844.aabjlexbwq6ggzs2@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello all,

I have just ran into this issue, controller resets and timeouts (running mkfs.ext4 or mkfs.xfs to reproduce) and bisected it to the same commit : 

commit c92a6b5d63359dd6d2ce6ea88ecd8e31dd769f6b
Author:     Martin K. Petersen <martin.petersen@oracle.com>
AuthorDate: Wed Mar 2 00:35:47 2022 -0500

  scsi: core: Query VPD size before getting full page

Reverting this commit and building 6.6.80 kernel with the revert patch solved the issue.

Is it possible to receive the patch that was referenced by Bart (I wasn't able to find it) so I can give it a try please ?

Also sharing the output that was asked, not sure if this may help.

sg_readcap -l /dev/sdb : 
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=1, lbprz=1
   Last LBA=390721967 (0x1749f1af), Number of logical blocks=390721968
   Logical block length=512 bytes
   Logical blocks per physical block exponent=3 [so physical block length=4096 bytes]
   Lowest aligned LBA=0
Hence:
   Device size: 200049647616 bytes, 190782.2 MiB, 200.05 GB

sg_vpd -l /dev/sdb :
Supported VPD pages VPD page:
   [PQual=0  Peripheral device type: disk]
  0x00  Supported VPD pages [sv]
  0x80  Unit serial number [sn]
  0x83  Device identification [di]
  0x87  Mode page policy [mpp]
  0x89  ATA information (SAT) [ai]
  0xb0  Block limits (SBC) [bl]
  0xb1  Block device characteristics (SBC) [bdc]
  0xb2  Logical block provisioning (SBC) [lbpv]

sg_vpd -p 0xb0 /dev/sdb : 
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks [Command not implemented]
  Optimal transfer length granularity: 0 blocks [not reported]
  Maximum transfer length: 0 blocks [not reported]
  Optimal transfer length: 0 blocks [not reported]
  Maximum prefetch transfer length: 0 blocks [ignored]
  Maximum unmap LBA count: 262143
  Maximum unmap block descriptor count: 32
  Optimal unmap granularity: 1 blocks
  Unmap granularity alignment valid: false
  Unmap granularity alignment: 0 [invalid]
  Maximum write same length: 0 blocks [not reported]
  Maximum atomic transfer length: 0 blocks [not reported]
  Atomic alignment: 0 [unaligned atomic writes permitted]
  Atomic transfer length granularity: 0 [no granularity requirement
  Maximum atomic transfer length with atomic boundary: 0 blocks [not reported]
  Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]

sg_vpd -p 0xb1 /dev/sdb :
Block device characteristics VPD page (SBC):
  Non-rotating medium (e.g. solid state)
  Product type: Not specified
  WABEREQ=0
  WACEREQ=0
  Nominal form factor: 2.5 inch
  MACT=0
  ZONED=0
  RBWZ=0
  BOCS=0
  FUAB=0
  VBULS=0
  DEPOPULATION_TIME=0 (seconds)

sg_vpd -p 0xb2 /dev/sdb : 
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBPWS): 1
  Write same (10) with unmap bit supported (LBPWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 1
  Threshold exponent: 0 [threshold sets not supported]
  Descriptor present (DP): 0
  Minimum percentage: 0 [not reported]
  Provisioning type: 0 (not known or fully provisioned)
  Threshold percentage: 0 [percentages not supported]

Thanks for any help!

Kind regards,
Lahfa Samy
