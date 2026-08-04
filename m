Received: from mail-m3279.qiye.163.com (mail-m3279.qiye.163.com [220.197.32.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21292316190
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 07:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827272; cv=none; b=T4m0KpKXIgTe6j7g/3W3+pj2oSCOmMpNtXSLxYA9KZkw51KTSyXKzVNf8OAfynKuMFJdsW5pas9g/0MCGhmDSJKYZl34ChaHp7L4F8RJW9clqhDOwpBQIAnsocvW6JRTyPTyGXPlrezJZPCaaAudk1XorxBNV03TOe2et9z+HQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827272; c=relaxed/simple;
	bh=VyVBmF9IYDkjLYAkN8S+cw4S30pZ4xHdcIITfnZthY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cjoCCqT+qDbIqJZyTo2LHyrFlqyAnbKLStaZy7RV3wvWEXlED9mDmcmF2HhxCc4rWG0sPk+GpdPtEsLjYKRgS87ciRLzsjrHsmUC9ks1ruvYcTX0OrQ/hc40cZkGmc7K/6VLhl2iCSNukmmGxJYfbMwPx13R17cIABxzGqKEfII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=bKE5EtWX; arc=none smtp.client-ip=220.197.32.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="bKE5EtWX"
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 48b1dbe5e;
	Tue, 4 Aug 2026 15:02:27 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v5 0/2] scsi: Add LeapRAID driver support
Date: Tue,  4 Aug 2026 15:02:24 +0800
Message-Id: <cover.1785823793.git.doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fcb94afe903aekunme796edef9bcd8e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTE0fVk9CGU8ZTx1LHUlPHVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=bKE5EtWXSahvhJL0P8+tZk9CnDgteVN6IbV8LuopzWhT0p8M6ia5E3ybK7DJh3spcSL7DnQuHBpN3Nt2QCHxlH6tBxPxO0UmcgACnsOA6qzSOKjLhka93ut+qyzX47djSZKG5G11vDXVFhf21NpXLzR9U0jrMnWCv0GqYzkhogrbdi/ql4dpXTiGKW33c6zDNiwGVvBm2RqljDiLroOFbEYvNhDf842dB65j6WIgLMqgPyH8oOtB112DBUHumLAb12Ql1hl/jkuAa9kKxIr6pJgTBtkQ3DQddE0tKNFn/Q3oZBTONRLkBUm9MqLy7OwVuXNxIMqHmWuAmejwuQRhTg==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=f2hati80t4Kjx7IU4fpUkNkgLNy21y/CzXTFTBf+2aI=;
	h=date:mime-version:subject:message-id:from;

This series adds the LeapRAID driver and its documentation.

This version addresses issues reported by Sashiko and the kernel test
robot, as well as issues identified through internal testing. Because
[PATCH v4 1/2] exceeded the line-count limit of the public Sashiko
service, it was not analyzed. We therefore deployed Sashiko locally
with an increased line-count limit to complete the analysis and have
fixed all identified issues.

Changes in v5:

[PATCH v5 1/2] scsi: leapraid: Add new SCSI driver
- Fix /dev/leapraid_ctl adapter lifetime races during concurrent probe
  and removal.
- Fix firmware log mmap teardown by tracking active VMAs.
- Fix passthrough data_sge_offset validation to prevent overwrites.
- Validate asynchronous firmware event lengths to prevent out-of-bounds
  accesses.
- Fix SMP passthrough payload validation to prevent size_t underflow.
- Fix teardown races among event queuing, host removal, and IRQ handling.
- Fix MSI-X CPU mapping for sparse CPU IDs by using nr_cpu_ids.
- Make host-memory cleanup idempotent to prevent double cleanup.
- Initialize the internal SCSI command mutex earlier to ensure safe
  error-path cleanup.
- Fix Clang -Wunaligned-access warnings for packed SGE structures and
  related cases.
- Add the missing unwind path in leapraid_request_host_memory() and fix
  related error-path issues.
- Prevent nested hard resets during asynchronous recovery to avoid
  deadlocks.
- Remove periodic timestamp synchronization.

[PATCH v5 2/2] scsi: leapraid: Add documentation
- Document the actual enable_mp module parameter instead of enable_mpio.
- Drop SMART polling, which remains available only in the vendor driver.
- Remove the custom sas_address sysfs attribute, as it is provided by the
  SAS transport class.
- Drop the user-selectable interrupt_mode and msix_disable parameters.
- Rename the NCQ parameter to ncq_cmd_prio_enable for clarity.

Review tags collected
=====================

  1/2  Reviewed-by: Damien Le Moal dlemoal@kernel.org  (given on v2)
       Reviewed-by: Hannes Reinecke hare@kernel.org    (given on v5)      
  2/2  Reviewed-by: Damien Le Moal dlemoal@kernel.org  (given on v2)
       Reviewed-by: Hannes Reinecke hare@kernel.org    (given on v5)

Dongdong Hao (2):
  scsi: leapraid: Add new SCSI driver
  scsi: leapraid: Add driver documentation

 Documentation/scsi/index.rst               |    1 +
 Documentation/scsi/leapraid.rst            |  110 +
 MAINTAINERS                                |    7 +
 drivers/scsi/Kconfig                       |    1 +
 drivers/scsi/Makefile                      |    1 +
 drivers/scsi/leapraid/Kconfig              |   14 +
 drivers/scsi/leapraid/Makefile             |   10 +
 drivers/scsi/leapraid/leapraid.h           | 2048 +++++
 drivers/scsi/leapraid/leapraid_app.c       |  803 ++
 drivers/scsi/leapraid/leapraid_func.c      | 8626 ++++++++++++++++++++
 drivers/scsi/leapraid/leapraid_func.h      | 1486 ++++
 drivers/scsi/leapraid/leapraid_os.c        | 2468 ++++++
 drivers/scsi/leapraid/leapraid_transport.c | 1403 ++++
 13 files changed, 16978 insertions(+)
 create mode 100644 Documentation/scsi/leapraid.rst
 create mode 100644 drivers/scsi/leapraid/Kconfig
 create mode 100644 drivers/scsi/leapraid/Makefile
 create mode 100644 drivers/scsi/leapraid/leapraid.h
 create mode 100644 drivers/scsi/leapraid/leapraid_app.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.h
 create mode 100644 drivers/scsi/leapraid/leapraid_os.c
 create mode 100644 drivers/scsi/leapraid/leapraid_transport.c

-- 
2.25.1

