Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6902839A80E;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783015179; cv=none; b=vGXGpeN0l41cQlFXxaolbwemUdgSzm3ThF/Yk80vdJ83HlN5xTdSKAeSFwgsa7/qK2MLGSpmxUQSWBYCNeDVUZjVviL2W3jUgy7UsfNGZNWbpuisqr1RmgIZij2E6RoJzNpy4rLDdGwimOk5/rkAmT3Ew/Q4qtt5bl9XHEq2gEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783015179; c=relaxed/simple;
	bh=65Flh2O6so42jIWnmqpRVhC63GZQocsX8X2bK0BNwos=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GssoTbi5yq/5yJI0k8yTQtZ48U7X6etZjcBsaQpZLp9JBU8EB0tF7AyFlx0l44WzsWN6XOqiGtwr92POTht3RhxCD3yLeWbQKJlRzZ6bqPdfak+gVy6OzBDOPF0lBkkqA6qeiKR1Cz+itpag4NHmAdoSq2P2ksU41nUi2nMqO80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADcchT/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADcchT/b"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0CA39C2BCC9;
	Thu,  2 Jul 2026 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783015179;
	bh=65Flh2O6so42jIWnmqpRVhC63GZQocsX8X2bK0BNwos=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=ADcchT/bGtMNDDA9MeQKQE/HT18J4B7MN4til+wcqROSc289VyTGH9PytHGBNRDbI
	 tmx7wu5Pz26gp7nH6jDz1eTgUDiTo3ImTgma21tIhMnZfZ/+gQy3OKh/xX4eVo5Riq
	 XDB9Ii85enep/2B0mOzZy/GnXo3UCpRgeBjnu+qf8JEDpAURZq6H2RVDkFjwHJhbOd
	 a9zHECNYB5iibR3rIH4COOh3U71MGqSKKS2BQzYt8fBfuoVk+/izrcawDt0gJjdXtR
	 anqxe8McqZ34R1v+Zc8M9MqWE/qB5h+tifWR26P/ysAjzVpNfHx+HosR0DrOS2nufb
	 ub49ut+KWMxfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB47FC43458;
	Thu,  2 Jul 2026 17:59:38 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Subject: [PATCH v3 0/8] ibmvfc: make ibmvfc support FPIN messages
Date: Thu, 02 Jul 2026 12:59:30 -0500
Message-Id: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WN0Q6CIBhGX8VxHQ4QsLrqPVoXgpB/S3SgzOZ89
 9DW2lpdftv5zplRMB5MQMdsRt5ECNC5NIpdhnRTuavBUKeNGGGScFJiUG20GtseHA5j33d+wOq
 gRCl0zeqKovTsvbEwbdbz5bXDqG5GD6tqJRoIQ+cfWzbSlXsX9j8LkWKCBVNEai65IcXpDm6c8
 sTmumvRWons45H/PCx5ak6t4MSqSuhvz7IsT2KudL0UAQAA
X-Change-ID: 20260407-ibmvfc-fpin-support-b9b575cd2da1
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>, 
 Greg Joyce <gjoyce@linux.ibm.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783015177; l=3277;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=65Flh2O6so42jIWnmqpRVhC63GZQocsX8X2bK0BNwos=;
 b=oVGKk/XsAbVkB+B0CwuXhDrwElf0sYJkinUmnKMUGzpu69DT0Bw4kYizoDp2LV91ZXtxNgO3i
 7Dv/OjZef85B1aZGbMej3Eq7TWBPV3S9Twz8Mz3sIuOc21wrjvQFEAQ
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

This patch series adds FPIN (fabric performance impact notification)
support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
in three flavors:

- basic, to recognize existing FPIN messages from the virtual I/O
  server (VIOS) (patch 1)
- full, supporting additional FPIN information and using its own
  asynchronous sub-queue and interrupt (patches 4-7)
- extended, supporting FC-LS-5 (patch 8)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support

- a new VFC_NOOP command, which the driver recognizes and
  ignores (patch 2)
- fabric login, to login separately to the fabric through messages
  exchanged with VIOS rather than doing fabric login through the
  existing NPIV login (patch 3)

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, in some cases using default values for
information not provided by the VIOS FPIN message but expected in the
FC ELS message. This FC ELS message is passed to fc_host_rcv_fpin for
updating statistics and sending the information upstream by netlink
multicast, where it may be read by listeners including the DM
multipath daemon "multipathd."

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
Highlights of changes in v2:
- Refactored mostly common FPIN conversion routines and async event
  processing into single routines with wrappers for differences.
- Moved FPIN processing to a work queue to avoid conflicts with
  fc_host_fpin_rcv and memory allocation
- Set descriptor sizes correctly
- Use target WWPN for basic FPIN descriptor
- Split patch 4 into 3 patches, for definition, allocation, and use of
  the asynchronous sub-queue for events
- Link to v1: https://patch.msgid.link/20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com

---
Changes in v3:
- Fixed latent bug, exposed by VFC_NOOP, related to dataless CRQs and events
- Fixed FPIN TLV descriptor length calculations
- Use safe list walker to walk targets in ibmvfc_process_async_work
- Added write memory barriers after clearing CRQ valid field
- Use per-vhost work queue for FPIN work
- Link to v2: https://patch.msgid.link/20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com

---
Dave Marquardt (8):
      ibmvfc: add basic FPIN support
      ibmvfc: Add NOOP command support
      ibmvfc: make ibmvfc login to fabric
      ibmvfc: define asynchronous sub-queue
      ibmvfc: allocate asynchronous sub-queue
      ibmvfc: extend async event handlers to handle async sub queue events
      ibmvfc: register and use asynchronous sub-queue for events
      ibmvfc: handle extended FPIN events

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc.c       | 704 ++++++++++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       | 115 +++++-
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 239 ++++++++++++
 5 files changed, 1000 insertions(+), 69 deletions(-)
---
base-commit: 0600eec09ad6cc5ba3ca78aceb6fa8dcbad010bb
change-id: 20260407-ibmvfc-fpin-support-b9b575cd2da1

Best regards,
--  
Dave Marquardt <davemarq@linux.ibm.com>


