Received: from alln-iport-5.cisco.com (alln-iport-5.cisco.com [173.37.142.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD46142620;
	Mon, 10 Jun 2024 21:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718056351; cv=none; b=rptub9SeSDiOX4d9Ejstg6TlG2156LlUf3d7EBF9t+ZAzMqu95DriJC65oe2CL2QjvSRdxuy7A/GRVkOFC0w+ogq/ZbfpIEJpEcstDwTu9R0um0iq/HpZVA4Jmb61MLDdB6+wpx/feIGnIfjQMjjrGZTCeXQj5HqL+3q+PPBALY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718056351; c=relaxed/simple;
	bh=20dF36tyLYMvukAEs6/ZOMhFZal8fnBiTzHawZxFwC4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EUi7t3QO7S8xWKgzIWnk4L++jg97XIZ+kdqV3DlbINFVIzwun4XzXzoRbvExkpcBRjKLNZdjrrFSJGQnzOWI27WffRqsIDPxam+M1CZYkbs982Lbc89PJyp2t47zINl1DJq4I1BBj8hfrYICBZUUlZh2icakCF80BXDogSFLWd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=LJnmf/8Q; arc=none smtp.client-ip=173.37.142.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="LJnmf/8Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4768; q=dns/txt; s=iport;
  t=1718056349; x=1719265949;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+/+1WZ9Qli7ENIFuydnVAiZxGbcQ1OYsf5kSIXdQmPU=;
  b=LJnmf/8QaVoac5gl5OdLO+m7+yccDigrqF5XlUQT0udug3Tux5d3SWp/
   yKm7Q+sRV73Zo+1nWeYGbO7qSSha9DOZw/CQr/2GZVlx867nEvEcX+SVK
   PGFZp4gn1VaqZYraXnK0XvqEk9HAyS7YhDcbfoFGCH5mg/TiFiQkP6Sf1
   s=;
X-CSE-ConnectionGUID: bV5CvFE1SweijZFgi/Hwvg==
X-CSE-MsgGUID: 7brQSmZHTfmbJqkBrOt6rw==
X-IronPort-AV: E=Sophos;i="6.08,227,1712620800"; 
   d="scan'208";a="294807107"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by alln-iport-5.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 21:51:20 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPSA id 45ALpBCO012699
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 10 Jun 2024 21:51:19 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 00/14] Introduce support for feature Fabric Discovery and
Date: Mon, 10 Jun 2024 14:50:46 -0700
Message-Id: <20240610215100.673158-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-4.cisco.com

Hi Martin, reviewers,

This cover letter describes the feature: add support for Fabric Discovery
and Login Services (FDLS) to fnic driver.

This functionality is needed to support port channel RSCN (PC-RSCN)
handling and serves as a base to create FC-NVME initiators
(planned later), and eCPU handling (planned later).

It is used to discover the fabric and target ports associated with the
fabric.
It will then login to the target ports that are zoned to it.
The driver uses the tport structure presented by FDLS.

Port channel RSCN is a Cisco vendor specific RSCN
event. It is applicable only to Cisco UCS fabrics.

In cases where the eCPU in the UCS VIC (Unified Computing Services
Virtual Interface Card) hangs, a fabric log out is sent to the fabric.
Upon successful log out from the fabric, the IO path is failed over
to a new path.

Generally from a feature perspective, the code is divided into adding
support for this functionality initially. Then, code has been added to
modify the IO path and interfaces. Finally, support for port channel RSCN
handling has been added.

Here are the headers of some of the salient patches:

o add headers and definitions for FDLS
o add support for fabric based solicited requests and responses
o add support for target based solicited requests and responses
o add support for unsolicited requests and responses
o add support for FDMI
o add support for FIP
o add functionality in fnic to support FDLS
o modify IO path to use FDLS and tport
o modify fnic interfaces to use FDLS
o add support to handle port channel RSCN

Even though the patches have been made into a series, some patches are
heavier than others. But, every effort has been made to keep the purpose
of each patch as a single-purpose, and to compile cleanly.
All the individual patches compile cleanly. There are some unused function
warnings, but since the function calls happen in later patches, those
warnings go away.

This patchset has been tested as a whole. Therefore, the tested-by fields
have been added only to one patch in the set.
I've refrained from adding tested-by to most of the patches,
so as to not mislead the reviewer/reader.

A brief note on the unit tests:

o. Perform zone in zone out testing in a loop: remove a target
port from the zone, add it to the zone in a loop. 1000+ iterations
of this test have been successful.
o. Configure multipathing, and run link flaps on single link.
IOs drop briefly, but pick up as expected.
o. Configure multipathing, and run link flaps on two links, with a
30 second delay in between. IOs drop briefly, but pick up as expected.
o. Module load/unload test.
o. Repeat the above tests with 1 queue and 64 queues.
All tests were successful.

Please consider this patch series for the next merge window.

Thanks and regards,
Karan

Karan Tilak Kumar (14):
  scsi: fnic: Replace shost_printk with pr_info/pr_err
  scsi: fnic: Add headers and definitions for FDLS
  scsi: fnic: Add support for fabric based solicited requests and
    responses
  scsi: fnic: Add support for target based solicited requests and
    responses
  scsi: fnic: Add support for unsolicited requests and responses
  scsi: fnic: Add and integrate support for FDMI
  scsi: fnic: Add and integrate support for FIP
  scsi: fnic: Add functionality in fnic to support FDLS
  scsi: fnic: Modify IO path to use FDLS
  scsi: fnic: Modify fnic interfaces to use FDLS
  scsi: fnic: Add stats and related functionality
  scsi: fnic: Code cleanup
  scsi: fnic: Add support to handle port channel RSCN
  scsi: fnic: Increment driver version

 drivers/scsi/fnic/Makefile                |    5 +-
 drivers/scsi/fnic/fdls_disc.c             | 3942 +++++++++++++++++++++
 drivers/scsi/fnic/fdls_fc.h               |  548 +++
 drivers/scsi/fnic/fip.c                   |  900 +++++
 drivers/scsi/fnic/fip.h                   |  341 ++
 drivers/scsi/fnic/fnic.h                  |  216 +-
 drivers/scsi/fnic/fnic_attrs.c            |   12 +-
 drivers/scsi/fnic/fnic_debugfs.c          |   30 +-
 drivers/scsi/fnic/fnic_fcs.c              | 1775 ++++------
 drivers/scsi/fnic/fnic_fdls.h             |  371 ++
 drivers/scsi/fnic/fnic_io.h               |   14 +-
 drivers/scsi/fnic/fnic_isr.c              |   28 +-
 drivers/scsi/fnic/fnic_main.c             |  670 ++--
 drivers/scsi/fnic/fnic_pci_subsys_devid.c |  133 +
 drivers/scsi/fnic/fnic_res.c              |   76 +-
 drivers/scsi/fnic/fnic_scsi.c             | 1406 +++++---
 drivers/scsi/fnic/fnic_stats.h            |   48 +-
 drivers/scsi/fnic/fnic_trace.c            |   83 +-
 18 files changed, 8640 insertions(+), 1958 deletions(-)
 create mode 100644 drivers/scsi/fnic/fdls_disc.c
 create mode 100644 drivers/scsi/fnic/fdls_fc.h
 create mode 100644 drivers/scsi/fnic/fip.c
 create mode 100644 drivers/scsi/fnic/fip.h
 create mode 100644 drivers/scsi/fnic/fnic_fdls.h
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

-- 
2.31.1

