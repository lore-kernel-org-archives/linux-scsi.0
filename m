Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191AB420E9D;
	Fri, 21 Aug 2026 08:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787299451; cv=none; b=lbIM4xb6yXpEEw9rt4n4fnAgkeWNOXdo3eA/IpiKo6S/ZwDMu8q16fF25FfbVyPDshYPkq6Xfb6vcSAFwqKF0uv9R1zV8lN5vsCvXZLJVTs1nuzYsBq+ZN/xJ1cj69PTHR1btV0wUNOWJWO++XYU4C0AIUm7C08ytaLybUGy03Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787299451; c=relaxed/simple;
	bh=LkFVS5bU2BZ6gMPuzh2p6qnIwcXnYdKqiJQq+ywPaAo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=mH+tWHCha6rLn30cRc9a7kxOHRq7mqrvWryYv4/KvRyAQjk9wLfquatn4GOJ0wWZLZn5FwgLYI5wkLxU+R9g7tK2V/qwYV1MbRj354kBSRYNWURb581+fy0BpO/AbKH5Jh4dPVZ4uCv6EYcAhJHE7TRf9U2R7tR6nlYC0ByDasU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=UNidCCvm; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="UNidCCvm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1787299438;
	bh=LkFVS5bU2BZ6gMPuzh2p6qnIwcXnYdKqiJQq+ywPaAo=;
	h=Message-ID:Subject:From:To:Date:From;
	b=UNidCCvmb65RlzdgJEBGzpZAKrFSNnzdYcVYF2mL9UzRfyvO29CRHxoLYG8QplID0
	 IT0rChK5bkPAakdk8D+z1x/tqaDW2ZldQnUGDEuJTBkNbwQ6lgmcg1iGPy28F6RtBQ
	 gqg/uSFiUDRPwy+5g0bfpDFYJqQhN7ewr4VLIQ/c=
Received: from [IPv6:2a00:23c8:103c:f701:6906:2df:959d:44bf] (unknown [IPv6:2a00:23c8:103c:f701:6906:2df:959d:44bf])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 9F59C1C044A;
	Fri, 21 Aug 2026 04:03:57 -0400 (EDT)
Message-ID: <1cec13635d688db8d8185fd4df8a8df621d60a75.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 7.2+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 21 Aug 2026 09:03:55 +0100
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482=
:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
misc

for you to fetch changes up to 376a3960e5efe85ff765abfb5b5b7e4655ad6aed:

  scsi: fnic: Fix built-in NVMe/FC build (2026-08-10 21:24:01 -0400)

----------------------------------------------------------------
One new driver: leapraid (similar to mpi3mr but OK'd by Broadcom).  The
usual suspects for driver updates (ufs, qla2xxx, smartpqi, zfcp, fnic,
ibmvfc) plus a few small core updates: a fix for an uninitialized sg
list pad bytes plus the removal of the dma mask check for max
sectors. The big update in the sd driver is mostly code refactoring for
obscure error leg handling.

----------------------------------------------------------------
Anil Gurumurthy (3):
      scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx
      scsi: qla2xxx: Add extended status continuation and marker IOCBs
      scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx

Ben Dooks (1):
      scsi: virtio_scsi: Fix up endian conversions for warning messages

Can Guo (6):
      scsi: ufs: dt-bindings: Document static TX Equalization settings prop=
erties
      scsi: ufs: core: Add support for static TX Equalization settings
      scsi: ufs: core: Avoid possible memory reclaim deadlock in TX EQTR co=
ntext
      scsi: ufs: ufs-qcom: Restore TX Equalization settings on FOM failure
      scsi: ufs: core: Tolerate RX_FOM read failures in TX EQTR
      scsi: ufs: core: Always run tx_eqtr POST_CHANGE notify

Chinmaya Kajagar (2):
      scsi: zfcp: Enhance fsf status read buffer tracing
      scsi: zfcp: Trace return values of sysfs unit add store

Colin Ian King (2):
      scsi: dc395x: Remove unused variable 'fact'
      scsi: ibmvfc: Fix spelling mistake "Deleteing" -> "Deleting"

David Strahan (4):
      scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dis=
patches.
      scsi: smartpqi: Add support for CCISS_BIG_PASSTHRU ioctl
      scsi: smartpqi: Add new PCI device-ids
      scsi: smartpqi: Update version to 2.1.42-011

Dongdong Hao (2):
      scsi: leapraid: Add new SCSI driver
      scsi: leapraid: Add driver documentation

Ed Tsai (3):
      scsi: ufs: core: Add get_hba_nortt callback for vendor-specific RTT c=
apability
      scsi: ufs: mediatek: Implement get_hba_nortt callback for RTT capabil=
ity
      scsi: ufs: core: Remove max_num_rtt field from ufs_hba_variant_ops

Heiko Carstens (2):
      scsi: zfcp: Add __must_hold() attribute to zfcp_qdio_sbal_get()
      scsi: zfcp: Enable CONTEXT_ANALYSIS

Himanshu Batra (1):
      scsi: ufs: sysfs: Add HS_GEAR6 string in power_info/gear sysfs output

Hyeoncheol Jeong (2):
      scsi: ufs: Use unsigned types for the BSG query
      scsi: ufs: Add support for the aggregated read query opcode

John Garry (3):
      scsi: dma-mapping: Make dma_max_mapping_size() return 0 for no DMA ca=
pability
      scsi: core: Drop dev->dma_mask check in evaluating max_sectors
      scsi: alua: Use access state macros

Kai M=C3=A4kisara (1):
      scsi: MAINTAINERS: Orphan the SCSI tape driver

Karan Tilak Kumar (14):
      scsi: fnic: Make debug logging protocol independent
      scsi: fnic: Use fnic_num for non-SCSI identifiers
      scsi: fnic: Decode firmware role configuration
      scsi: fnic: Advertise NVMe initiator service parameters
      scsi: fnic: Add FDLS role handling for NVMe initiators
      scsi: fnic: Add the NVMe/FC transport path
      scsi: fnic: Route completions and resets by initiator role
      scsi: fnic: Handle NVMe LS frames in FDLS
      scsi: fnic: Send NVMe LS requests through FDLS
      scsi: fnic: Abort timed-out NVMe LS requests
      scsi: fnic: Track NVMe transport statistics
      scsi: fnic: Expose NVMe transport state in debugfs
      scsi: fnic: Bump up version number
      scsi: fnic: Fix built-in NVMe/FC build

Laurence Oberman (1):
      scsi: storvsc: Support manual scans for all Hyper-V targets

Li Qiang (6):
      scsi: ufs: core: Validate string descriptors
      scsi: ufs: Avoid NULL CQE dereference when reporting invalid tags
      scsi: ufs: core: Validate connected lane counts
      scsi: ufs: rpmb: Validate request frame length before parsing
      scsi: ufs: rpmb: Use unaligned accessors for RPMB frames
      scsi: ufs: debugfs: Reserve space for a string terminator

Linkai Gong (1):
      scsi: fnic: Use GFP_ATOMIC for VLAN alloc under spinlock

Louis Sautier (2):
      scsi: mpt3sas: Add IO Unit Page 7 config accessor
      scsi: mpt3sas: Add hwmon support

Manish Rangankar (10):
      scsi: qla2xxx: Add 29xx series PCI device ID support
      scsi: qla2xxx: Add flash read/write interface for 29xx
      scsi: qla2xxx: Add NVRAM config support for 29xx adapters
      scsi: qla2xxx: Add 29xx support in queue initialisation path
      scsi: qla2xxx: Add FC operational firmware load for 29xx
      scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
      scsi: qla2xxx: Add flash block read/write BSG support for 29xx
      scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx
      scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series
      scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Martin K. Petersen (9):
      Merge patch series "scsi: ufs: Add support for static TX Equalization=
 settings"
      Merge patch series "scsi: ufs: Harden TX EQTR error handling paths"
      Merge patch series "ufs: Add callback for vendor-specific RTT capabil=
ity"
      Merge patch series "scsi: mpt3sas: add hwmon support"
      Merge patch series "ibmvfc: NVMe/FC support over IBM Virtual FC"
      Merge patch series "smartpqi: fixes and updates for 2.1.42-011"
      Merge patch series "Request to queue zfcp enhancements for upstream m=
erge window"
      Merge patch series "Introduce functionality for NVMe initiator"
      Merge zorro updates from Uwe Kleine-K=C3=B6nig.

Martin K. Petersen (Oracle) (7):
      Merge patch series "scsi: ufs: Fix descriptor parsing and invalid inp=
ut handling"
      Merge patch series "scsi: qla2xxx: Add QLA29xx series adapter support=
"
      Merge patch series "scsi: qla2xxx: Bug fixes and hardening"
      Merge patch series "scsi: ufs: Add support for the aggregated read qu=
ery opcode"
      Merge patch series "scsi: Add LeapRAID driver support"
      Merge patch series "scsi: sd: fix probe error cleanup, special_vec le=
ak and sd_done() sense gate"
      Merge patch series "scsi: zfcp: Enable CONTEXT_ANALYSIS"

Neil Armstrong (1):
      scsi: ufs: Switch WriteBooster missing free space message as warn_onc=
e

Nilesh Javali (75):
      scsi: qla2xxx: Skip image-set-valid attribute for 29xx
      scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
      scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
      scsi: qla2xxx: Extend execute_fw mailbox to include 29xx
      scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
      scsi: qla2xxx: Enable init_firmware mailbox for 29xx
      scsi: qla2xxx: Enable get_firmware_state for 29xx
      scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
      scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
      scsi: qla2xxx: Add support for QLA29XX in data rate functions
      scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
      scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
      scsi: qla2xxx: Add support for QLA29XX in memory allocation
      scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters
      scsi: qla2xxx: Update handling of status entries for 29xx series
      scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb handling for 29xx serie=
s
      scsi: qla2xxx: Enhance purex_entry handling for 29xx series
      scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series
      scsi: qla2xxx: Add size check for ELS status entry layout on 29xx
      scsi: qla2xxx: Add 29xx extended logio IOCB support
      scsi: qla2xxx: Enhance task management IOCB handling for 29xx series
      scsi: qla2xxx: Add abort command handling for 29xx series
      scsi: qla2xxx: Enhance ABTS processing for 29xx series
      scsi: qla2xxx: Update VP control IOCB handling for 29xx series
      scsi: qla2xxx: Add build-time size check for VP config IOCB layout
      scsi: qla2xxx: Add size check for extended VP report ID entry
      scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
      scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors
      scsi: qla2xxx: Fix endianness annotations in vp_rpt_id_entry structur=
es
      scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats
      scsi: qla2xxx: Add 64G/128G port speed setting support
      scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
      scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
      scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
      scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
      scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
      scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition(=
)
      scsi: qla2xxx: Initialize NVMe abort_work once at submission
      scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject
      scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
      scsi: qla2xxx: Fix BSG job leak on validate flash image error path
      scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
      scsi: qla2xxx: Update version to 12.00.00.2607b1
      scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation
      scsi: qla2xxx: Serialize flash version read in reset handler
      scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
      scsi: qla2xxx: Clarify MPI optrom address/length units
      scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
      scsi: qla2xxx: Don't query firmware state while chip is down
      scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
      scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
      scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump
      scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot
      scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error p=
ath
      scsi: qla2xxx: Fix response queue over-consumption in __qla_consume_i=
ocb()
      scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature
      scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
      scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
      scsi: qla2xxx: Quiesce response IRQ before freeing request queue
      scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path
      scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity
      scsi: qla2xxx: Avoid double completion in async IOCB timeout
      scsi: qla2xxx: Skip vport under deletion in report ID acquisition
      scsi: qla2xxx: Drop vport reference under lock in report ID acquisiti=
on
      scsi: qla2xxx: Hold vport_slock for host map update in report ID acqu=
isition
      scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
      scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started
      scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject erro=
r
      scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock
      scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics
      scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak
      scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]
      scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers
      scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
      scsi: qla2xxx: Update version to 12.00.00.2607b2

Nitin Rawat (1):
      scsi: ufs: dt-bindings: Document the Maili UFS Controller

Pan Chuang (1):
      scsi: ufs: host: Remove redundant dev_err()

Petr Vaganov (1):
      scsi: core: Fill in DMA padding bytes in scsi_alloc_sgtables()

Piotr Zarycki (1):
      scsi: isci: Remove unused macros from scu_task_context.h

Quinn Tran (1):
      scsi: qla2xxx: Improve firmware dump data capture

Randy Dunlap (1):
      scsi: ufs: ufshcd: Fix all kernel-doc warnings

Roman Demidov (1):
      scsi: fnic: Fix invalid comparison for error

Sang-Heon Jeon (1):
      scsi: mpt3sas: Remove conditional return with no effect

Shivaprasad G Bhat (1):
      scsi: qla2xxx: Handle INTx not connected while passing through

Steffen Maier (1):
      scsi: zfcp: Trace PLOGI and PRLI within open port response as payload

Tyrel Datwyler (33):
      scsi: ibmvfc: don't call locked done variant for MADs on send failure
      scsi: ibmvfc: flush rport_add_work_q during driver teardown
      scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete p=
ath
      scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
      scsi: ibmvfc: move target list from host to protocol specific channel=
 groups
      scsi: ibmvfc: add NVMe/FC protocol interface definitions
      scsi: ibmvfc: split NVMe support into separate source file and add tr=
ansport stubs
      scsi: ibmvfc: initialize NVMe channel configuration during driver pro=
be
      scsi: ibmvfc: alloc/dealloc sub-queues for nvme channels
      scsi: ibmvfc: add logic for protocol specific fabric logins
      scsi: ibmvfc: add wrapper to get vhost associated with a channel stru=
ct
      scsi: ibmvfc: add helper for creating protocol specific discovery eve=
nt
      scsi: ibmvfc: add helper to check NVMe/FC support with active channel=
s
      scsi: ibmvfc: allocate and free NVMe channel group discover buffer
      scsi: ibmvfc: send NVMe target discovery MAD
      scsi: ibmvfc: add NVMe/FC Implicit Logout and Move Login support
      scsi: ibmvfc: add NVMe/FC Port Login support
      scsi: ibmvfc: add NVMe/FC Process Login support
      scsi: ibmvfc: add NVMe/FC Query Target support
      scsi: ibmvfc: allocate targets based on protocol
      scsi: ibmvfc: delete NVMe/FC targets as well as SCSI
      scsi: ibmvfc: update state machine to process NVMe/FC targets
      scsi: ibmvfc: implement NVMe/FC stubs for local/remote port registrat=
ion
      scsi: ibmvfc: register local nvme fc port after fabric login
      scsi: ibmvfc: process NVMe/FC rports in work thread
      scsi: ibmvfc: extend ibmvfc_debug visibility to ibmvfc-nvme.h
      scsi: ibmvfc: declare global function definitions
      scsi: ibmvfc: implement LLDD callbacks for mapping nvme-fc queues
      scsi: ibmvfc: implement nvme-fc LS submission transport callback
      scsi: ibmvfc: implement nvme-fc IO command submission callback
      scsi: ibmvfc: implement nvme-fc LS abort handling callback
      scsi: ibmvfc: implement nvme-fc FCP abort callback
      scsi: ibmvfc: fail nvme-fc fcp-io and ls requests during transport re=
set

Uwe Kleine-K=C3=B6nig (The Capable Hub) (6):
      scsi: ata: pata_budda: Use named initializer for zorro_device_id
      scsi: aha1542: Improve style of pnp_device_id array terminator
      scsi: NCR5380: Improve style of pnp_device_id array terminator
      scsi: zorro: a2091: gvp11: Use named initializer for zorro_device_id
      scsi: zorro: Simplify storing pointers in device id struct
      scsi: zorro7xx: Make use of struct zorro_device_id::driver_data_ptr

Yang Xiuwei (3):
      scsi: sd: Fix error handling in sd_probe() after large pool creation =
failure
      scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fai=
ls
      scsi: sd: Fix sd_done() sense handling condition

Yihang Li (1):
      scsi: MAINTAINERS: Update HiSilicon hisi_sas driver maintainer to Xin=
gui Yang

 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |    3 +
 .../devicetree/bindings/ufs/ufs-common.yaml        |   58 +
 Documentation/scsi/index.rst                       |    1 +
 Documentation/scsi/leapraid.rst                    |  110 +
 MAINTAINERS                                        |   12 +-
 drivers/ata/pata_buddha.c                          |    8 +-
 drivers/s390/scsi/Makefile                         |    2 +
 drivers/s390/scsi/zfcp_dbf.c                       |   80 +-
 drivers/s390/scsi/zfcp_dbf.h                       |   34 +-
 drivers/s390/scsi/zfcp_ext.h                       |    7 +-
 drivers/s390/scsi/zfcp_fsf.h                       |    4 +-
 drivers/s390/scsi/zfcp_qdio.c                      |    1 +
 drivers/s390/scsi/zfcp_sysfs.c                     |   19 +-
 drivers/scsi/Kconfig                               |    1 +
 drivers/scsi/Makefile                              |    1 +
 drivers/scsi/a2091.c                               |    6 +-
 drivers/scsi/aha1542.c                             |    2 +-
 drivers/scsi/dc395x.c                              |    6 -
 drivers/scsi/device_handler/scsi_dh_alua.c         |    5 +-
 drivers/scsi/fnic/Makefile                         |    1 +
 drivers/scsi/fnic/fcpio.h                          |   35 +
 drivers/scsi/fnic/fdls_disc.c                      |  978 ++-
 drivers/scsi/fnic/fdls_fc.h                        |    7 +
 drivers/scsi/fnic/fip.c                            |  119 +-
 drivers/scsi/fnic/fip.h                            |    2 +-
 drivers/scsi/fnic/fnic.h                           |  104 +-
 drivers/scsi/fnic/fnic_debugfs.c                   |   99 +-
 drivers/scsi/fnic/fnic_fcs.c                       |  199 +-
 drivers/scsi/fnic/fnic_fdls.h                      |   48 +-
 drivers/scsi/fnic/fnic_io.h                        |   24 +-
 drivers/scsi/fnic/fnic_isr.c                       |   28 +-
 drivers/scsi/fnic/fnic_main.c                      |  214 +-
 drivers/scsi/fnic/fnic_nvme.c                      | 2268 +++++
 drivers/scsi/fnic/fnic_nvme.h                      |  214 +
 drivers/scsi/fnic/fnic_res.c                       |   31 +-
 drivers/scsi/fnic/fnic_res.h                       |   32 +-
 drivers/scsi/fnic/fnic_scsi.c                      |  251 +-
 drivers/scsi/fnic/fnic_stats.h                     |   28 +
 drivers/scsi/fnic/fnic_trace.c                     |    3 +-
 drivers/scsi/fnic/vnic_dev.c                       |    2 +-
 drivers/scsi/fnic/vnic_devcmd.h                    |    2 +-
 drivers/scsi/g_NCR5380.c                           |    2 +-
 drivers/scsi/gvp11.c                               |   17 +-
 drivers/scsi/hosts.c                               |    6 +-
 drivers/scsi/ibmvscsi/Makefile                     |    2 +
 drivers/scsi/ibmvscsi/{ibmvfc.c =3D> ibmvfc-core.c}  |  819 +-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c                |  573 ++
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h                |   49 +
 drivers/scsi/ibmvscsi/ibmvfc.h                     |  219 +-
 drivers/scsi/isci/scu_task_context.h               |   14 -
 drivers/scsi/leapraid/Kconfig                      |   14 +
 drivers/scsi/leapraid/Makefile                     |   10 +
 drivers/scsi/leapraid/leapraid.h                   | 2048 +++++
 drivers/scsi/leapraid/leapraid_app.c               |  803 ++
 drivers/scsi/leapraid/leapraid_func.c              | 8626 ++++++++++++++++=
++++
 drivers/scsi/leapraid/leapraid_func.h              | 1486 ++++
 drivers/scsi/leapraid/leapraid_os.c                | 2468 ++++++
 drivers/scsi/leapraid/leapraid_transport.c         | 1403 ++++
 drivers/scsi/mpt3sas/Makefile                      |    2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   20 +
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   36 +
 drivers/scsi/mpt3sas/mpt3sas_hwmon.c               |  191 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |    6 +
 drivers/scsi/qla2xxx/qla_attr.c                    |   63 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  622 +-
 drivers/scsi/qla2xxx/qla_bsg.h                     |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |   37 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  148 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |    8 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |  101 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |  144 +-
 drivers/scsi/qla2xxx/qla_fw29.h                    |  830 ++
 drivers/scsi/qla2xxx/qla_gbl.h                     |   40 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  176 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  930 ++-
 drivers/scsi/qla2xxx/qla_inline.h                  |  295 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    | 1421 +++-
 drivers/scsi/qla2xxx/qla_isr.c                     |  748 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  499 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   78 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  315 +-
 drivers/scsi/qla2xxx/qla_nvme.h                    |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  316 +-
 drivers/scsi/qla2xxx/qla_sup.c                     |  782 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   34 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   48 +-
 drivers/scsi/qla2xxx/qla_version.h                 |   10 +-
 drivers/scsi/scsi_lib.c                            |    2 +
 drivers/scsi/sd.c                                  |   55 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |  204 +-
 drivers/scsi/storvsc_drv.c                         |   32 +
 drivers/scsi/virtio_scsi.c                         |   18 +-
 drivers/scsi/zorro7xx.c                            |   16 +-
 drivers/scsi/zorro_esp.c                           |    2 +-
 drivers/ufs/core/ufs-debugfs.c                     |    2 +-
 drivers/ufs/core/ufs-mcq.c                         |   14 +-
 drivers/ufs/core/ufs-rpmb.c                        |    8 +-
 drivers/ufs/core/ufs-sysfs.c                       |    1 +
 drivers/ufs/core/ufs-txeq.c                        |   73 +-
 drivers/ufs/core/ufs_bsg.c                         |   41 +-
 drivers/ufs/core/ufshcd.c                          |  143 +-
 drivers/ufs/host/ufs-mediatek.c                    |   16 +-
 drivers/ufs/host/ufs-mediatek.h                    |    4 +-
 drivers/ufs/host/ufs-qcom.c                        |   11 +-
 drivers/ufs/host/ufshcd-pltfrm.c                   |  154 +
 include/linux/mod_devicetable.h                    |    6 +-
 include/uapi/linux/cciss_ioctl.h                   |    1 +
 include/ufs/ufs.h                                  |    6 +
 include/ufs/ufshcd.h                               |   45 +-
 include/ufs/ufshci.h                               |   12 +
 kernel/dma/mapping.c                               |    3 +
 113 files changed, 30058 insertions(+), 2365 deletions(-)
 create mode 100644 Documentation/scsi/leapraid.rst
 create mode 100644 drivers/scsi/fnic/fnic_nvme.c
 create mode 100644 drivers/scsi/fnic/fnic_nvme.h
 rename drivers/scsi/ibmvscsi/{ibmvfc.c =3D> ibmvfc-core.c} (87%)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc-nvme.c
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc-nvme.h
 create mode 100644 drivers/scsi/leapraid/Kconfig
 create mode 100644 drivers/scsi/leapraid/Makefile
 create mode 100644 drivers/scsi/leapraid/leapraid.h
 create mode 100644 drivers/scsi/leapraid/leapraid_app.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.c
 create mode 100644 drivers/scsi/leapraid/leapraid_func.h
 create mode 100644 drivers/scsi/leapraid/leapraid_os.c
 create mode 100644 drivers/scsi/leapraid/leapraid_transport.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_hwmon.c
 create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h
