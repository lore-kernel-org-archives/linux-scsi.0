Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EB4136663;
	Fri, 27 Sep 2024 18:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462804; cv=none; b=Oa19Pb2V73r+4rrRIp2XCz+jXdTFE/zcqIT6voIIufrEUdjOFT0a9QST/NCjMMrK46ZfNKAaWBKmVFH23iLAnx3XcYv+wrB1g9Xk87hPKpAwqeZj+BxSRkZNn65Q66fTCJcXeU3BHvy+KcVOre+GcmxdRJeK4/UvOPSVa1Jz2DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462804; c=relaxed/simple;
	bh=rz6FAUEtZHL86XGxXe9+RQ8x5ab0L03dUPa5Z7KIE88=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DJwgHDVdm1ZLDeIiu5/Elk8bY5qxPPWx0bc6bgataORimA4GvrMx9m4JgztajXbeln5SYWDspwmo20iZr9VoDZTTzihHs3epzzR6X9unKAkZoZXjBiZ7cVZlCinrlYD8Eja8O67sAmHZ1OGjWd2QgSH8KphhKzLmqse++LTZHmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=ITKtpR1m; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="ITKtpR1m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7562; q=dns/txt; s=iport;
  t=1727462802; x=1728672402;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MT1eMq7WTR2fOTL/U3ohJBHxOyefzFzd4YQSgH+wxDQ=;
  b=ITKtpR1m5kKdKpgRoGzUP7k0sHsrme3Yb0dYOBLwa4EkMLZe+Lm25iJO
   t6Fe1iLFDOQUogIHZQXHglLyxst2RT3f2PuLV3moC31/2RhgrjwDdu1eA
   Dxmexs7o6/kTfToe5BJJsgeGsruoUnyYzphyvqTKayRCJ1ozaI3d468gp
   I=;
X-CSE-ConnectionGUID: kULWHogNSBGQE7DVWfX3mw==
X-CSE-MsgGUID: 9FWlmnLQTSOj+QFN9SCNwg==
X-IronPort-AV: E=Sophos;i="6.11,159,1725321600"; 
   d="scan'208";a="267254632"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 18:46:35 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 48RIkQah022754
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 27 Sep 2024 18:46:34 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v3 00/14] Introduce support for Fabric Discovery and 
Date: Fri, 27 Sep 2024 11:45:59 -0700
Message-Id: <20240927184613.52172-1-kartilak@cisco.com>
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
X-Outbound-Node: rcdn-core-5.cisco.com

Hi Martin, reviewers,

This cover letter describes the feature: add support for Fabric
Discovery and Login Services (FDLS) to fnic driver.

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
modify the IO path and interfaces. Finally, support for port channel
RSCN handling has been added.

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
heavier than others. But, every effort has been made to keep the
purpose of each patch as a single-purpose, and to compile cleanly.
All the individual patches compile cleanly. There are some unused
function warnings, but since the function calls happen in later
patches, those warnings go away.

This patchset has been tested as a whole. Therefore, the tested-by
fields have been added only to one patch in the set.
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

Changes between v1 and v2:
	Replace pr_err with printk.
	Replace simultaneous use of fc_tport_abts_s and tport_abts with
    just tport_abts.
	Incorporate review comments by Hannes:
		Replace pr_info with dev_info.
		Replace pr_err with dev_err.
		Restore usage of tagset iterators.
		Replace fnic_del_tport_timer_sync macro calls with function
		calls.
		Use the correct kernel-doc format.
		Replace definitions with standard definitions from
		fc_els.h.
		Replace htonll() with get_unaligned_be64().
		Use standard definitions from scsi_transport_fc.h for
		port speeds.
		Refactor definitions in struct fnic to avoid cache holes.
		Replace memcmp with not equal to operator.
		Fix indentation.
		Replace fnic_del_fabric_timer_sync macro calls to function
		calls.
		Rename fc_abts_s to fc_tport_abts_s.
		Modify fc_tport_abts_s to be a global frame.
		Rename variable pfc_abts to tport_abts.
		Modify functions with returns in the middle to if else
		clauses.
		Remove double newline.
		Fix indentation in fnic_send_frame.
		Add fnic_del_fabric_timer_sync as an inline function.
		Add fnic_del_tport_timer_sync as an inline function.
		Modify fc_abts_s variable name to fc_fabric_abts_s.
		Modify fc_fabric_abts_s to be a global frame.
		Rename pfc_abts to fabric_abts.
		Remove redundant patch description.
		Replace htonll() with get_unaligned_be64().
		Replace raw values with macro names.
		Remove fnic_del_fabric_timer_sync macro.
		Remove fnic_del_tport_timer_sync macro.
		Add fnic_del_fabric_timer_sync function declaration.
		Add fnic_del_tport_timer_sync function declaration.
		Move FDMI function declaration.
		Modify patch heading and description appropriately.
	Incorporate review comments from John:
		Remove unreferenced variable.
		Use standard definitions of true and false.
		Replace if else clauses with switch statement.
		Use kzalloc instead of kmalloc.
		Modify fnic_send_fcoe_frame to not send a return value.
		Replace int return value with void.
	Fix warning from kernel test robot:
		Remove version.h

Changes between v2 and v3:
    Incorporate review comments from Hannes:
        Replace redundant structure definitions with standard
        definitions.
		Replace static OXIDs with pool-based OXIDs for fabric.
		Replace static OXIDs with pool-based OXIDs for targets.
		Remove multiple endian macro copies.
		Modify locking as applicable.
	Incorporate review comments from John:
		Replace GFP_ATOMIC with GFP_KERNEL where applicable.
	Replace fnic->host with fnic->lport->host in some patches to
	prevent compilation errors.
	Fix issues found by kernel test robot.
	Refactor fnic_std_ba_acc definition to fix compilation warning.
	Refactor fnic_fdls_remove_tport to fix null pointer exception.
	Modify scsi_unload to fix null pointer exception during fnic_remove.

Thanks and regards,
Karan

Karan Tilak Kumar (14):
  scsi: fnic: Replace shost_printk with dev_info/dev_err
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
 drivers/scsi/fnic/fdls_disc.c             | 4506 +++++++++++++++++++++
 drivers/scsi/fnic/fdls_fc.h               |  381 ++
 drivers/scsi/fnic/fip.c                   |  876 ++++
 drivers/scsi/fnic/fip.h                   |  345 ++
 drivers/scsi/fnic/fnic.h                  |  217 +-
 drivers/scsi/fnic/fnic_attrs.c            |   12 +-
 drivers/scsi/fnic/fnic_debugfs.c          |   30 +-
 drivers/scsi/fnic/fnic_fcs.c              | 1769 ++++----
 drivers/scsi/fnic/fnic_fdls.h             |  431 ++
 drivers/scsi/fnic/fnic_io.h               |   14 +-
 drivers/scsi/fnic/fnic_isr.c              |   28 +-
 drivers/scsi/fnic/fnic_main.c             |  675 +--
 drivers/scsi/fnic/fnic_pci_subsys_devid.c |  131 +
 drivers/scsi/fnic/fnic_res.c              |   77 +-
 drivers/scsi/fnic/fnic_scsi.c             | 1168 ++++--
 drivers/scsi/fnic/fnic_stats.h            |   48 +-
 drivers/scsi/fnic/fnic_trace.c            |   83 +-
 18 files changed, 8920 insertions(+), 1876 deletions(-)
 create mode 100644 drivers/scsi/fnic/fdls_disc.c
 create mode 100644 drivers/scsi/fnic/fdls_fc.h
 create mode 100644 drivers/scsi/fnic/fip.c
 create mode 100644 drivers/scsi/fnic/fip.h
 create mode 100644 drivers/scsi/fnic/fnic_fdls.h
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

-- 
2.31.1

