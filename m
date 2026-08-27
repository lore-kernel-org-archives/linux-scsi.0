Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF78486E4C
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846906; cv=none; b=aOeWQf5edJAXMSGYIujqH4g688A0gXYRuqzHqAmrSleljkzXBu0zKq/3KyzeB3A+yvWwkdvXAvollw9FFvsm+mFwUDwaTxZwkVUyDZeikzJvv2A9NWXcba2EHlrwJGvWwRy43P6Y7h075D1JNxLnG4HFzJUn3O6UAEf6oaHTD5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846906; c=relaxed/simple;
	bh=InJBi1ft2hBbaFKieY6YZqUXPU/gfk8w7Fh7r9+bQPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IgZACVxIfwpzXGQXgvBKGR57uMprFQvrZixfPu2wox822ZjmK/9wpGk1T+IfQrjg471IAz160HId1o394LSh9dXlgOwHRc+k7KeE6E6Sst6FG2cfrFTosVzGtBu8sUUDzE+iApmn9iyJ7aY4zJ0q30MHJI5v3eqWfaB0ePSTVnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y4uq6JlM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F1Gzg4Vm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y4uq6JlM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F1Gzg4Vm"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFcHNh1312674
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=atRu9g3ecGR/Ax5Jg8bJIB
	651HizDXONPJoQtisnwWc=; b=Y4uq6JlMpmj0npdFeC57HIRdcXHvB1w2M6L9O9
	PwLZ2U/E0etX95l5S3QazbFxtQ84dSCpFhs45XMhhNr3ykMBlc1XAe08rxWKIf93
	ISwIavbNkpr3MlFveW/yD//12y0VEiu3W4O4nTwolGa++uMHbVVNsr38aOU7Ccob
	nAAhMKFTAbbbRqXqxz0wW2chDr7MQ4aF8D7HsMFFWPhL78MCVYcgmQe7N9Jv2Aks
	dANs4IPALWTMepSN4Eu5YdlOwWxdhvCJ5Fo/H19ieoRURWH+ZGvNlorRanqW5mN7
	JP7f9tVZZ3N/9OpCUX+Y6KR5kKq6jRemzqPyb59O9qxQdGMQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ga8m5kny1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:23 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so191939a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 09:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846903; x=1788451703; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=atRu9g3ecGR/Ax5Jg8bJIB651HizDXONPJoQtisnwWc=;
        b=F1Gzg4VmkuOEsACdblWuKAtOcr6W6YKWMVFwu+Kh+gqkimFgSCc2waBhtWpILUSOrv
         DO7w/AJuTdBuIde3AdytuBdGizsu4+v2Unpni5n5oR+DC+NTUZjJw+prd7nmEqVoTfxB
         kvFax5lZ85MmKppQTTDpSvFHWVMOwR01gshwQqiGAnwGWLww9oy1QI5TyQQlvOi5rOkE
         3s015XgPsOf/meLzGNptBOBC1/zVuUvZrahT6/T6XTFzfzbEoj5zWbMx1/nIVYgsNZkY
         2h/p5WWerLNSk+N9aRCq2MQaW920TkEXf28Pwpa1ZUN24kTIJedpyYaukAC7SH+ztFgt
         y/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846903; x=1788451703;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=atRu9g3ecGR/Ax5Jg8bJIB651HizDXONPJoQtisnwWc=;
        b=grWdP8D5oaz3W18bFZfoYipuBvAEtxwx+DXFYxq0zDoyBpEMUjG8B0Uyr5dp5FMO8V
         pbcIlIJU0JXhwv94YWbPyObxztMZsWMeG2NEzjR8a3up5IBHiLbapo3XYy7O9tlSEPsj
         c3/AfPblXRIkx+mDLLNVgaLuKPLdN7gqDmWDgrmGgcdz4868HasB9craGp/zBKaFZhsf
         PTo/R1tzdHbAGhdGbwraQYqB/uds3n06eTXQ6SJRhaCgcBvB7j582D536V5PqIII9jpv
         zrAT0c/Ubfaa/CVheMtdLhHHMPDB7Sd6ITsMAo31i7UMZZNTbpE7ezCq9+BV0LrK16OT
         hs4A==
X-Forwarded-Encrypted: i=1; AHgh+RpcjxmhbRrJ648AWLlDAs+wzy+SPqZ2u5LeiIxhR9By7zj8133r+wfdesprpeMAk/CWv+IfhwOlwQb4@vger.kernel.org
X-Gm-Message-State: AFuF++mwDVBvIvVWi7wQM+y7Xpg2aUk4KjgyAJAHHXuVkPHiNHnFtorg
	O7jePfkEPZ5xoqaErxOIa+BAbuzMeQTTNy4NBInFOuPm52IaBAfyK0mnsoBESq0Fhy89IcK5ie5
	bwtpbNb0F3XcKgFCoXtmuHwtWOiW62ipDGcZvr6OVA/cnCmnNS0t6GvP7cTA/JeBj
X-Gm-Gg: AR+sD10FROPJRuUUxC1aaHX5JyxhOcBbm6IFuR4UmgEhAECCl5OToUK9WwE6bqOPf4q
	XuAdqGBGGW9shqsqeJfdX9d8Wn6fsuDmNmCf3FJKmTZ5dY3cZOQvZ1Q75I8ZRzUWINMfAIdzDJF
	Ynr0tIPM1tNpUJRrapvq0PV78GrkgFucsY6QLyYsP/w9/9umcpXdr7/qNa3Pg9z2ESLqMCMpVKB
	k60+FC0Slr9YVKWcxLlSknR4/cRKwN7h4Ufn8BrHgRWcfzCoW3Egln2Q91gU/J2TahN3x6roINE
	LsqJ69dZuIEuGmewJBuGxy6/VRvKerOhbEYPoalOIygtJgav2hGx873l3gdJvHa89y5+Uvt9NzN
	2weUWsy/ENCtNK7H2WTA1xOBpmfrD5/5fXneqSJuOqVPkhkEjnJjzatFqvTc=
X-Received: by 2002:a17:90b:3c8a:b0:38e:524:8797 with SMTP id 98e67ed59e1d1-396d10076e9mr459869a91.13.1787846901366;
        Thu, 27 Aug 2026 09:08:21 -0700 (PDT)
X-Received: by 2002:a17:90b:3c8a:b0:38e:524:8797 with SMTP id 98e67ed59e1d1-396d10076e9mr459325a91.13.1787846899408;
        Thu, 27 Aug 2026 09:08:19 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:18 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: [PATCH v1 00/11] FBE virtualization: inline encryption for virtio-blk guests
Date: Thu, 27 Aug 2026 09:07:09 -0700
Message-ID: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: jfyVzBTFpg9auIU7M-O1iFM_XwEGPjYG
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX7+1k6oP04qxT
 B3HXccdzQIQtoh0Kgpu73ymDuFq0gBD0nPDEQtDcH/pWTudxsYOdWoY3ia6BfNcPilYn+SyeZgV
 iqaZgfUbIzDgjG78Gb25HQKyqMA3Zyc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfXzPrfcyKE0zqB
 EyTwIRWX/AJKWg2/SCH1NnTpGmn97hSEKtNPvkzrv8CapOi1KzwhY7ADiV/rQu/JFrUdJ9Ctv65
 89qz3gNrMQ2fJuD0pJL+RK0mX5SaygBOcAov3xxSh0Zl0E62E+tBHOndiRQR5eQJyiq6reBFG0W
 OwXttzquQuK4IRQBJs5CwULMmn5OZCVFdyKpmynQqpgEF122+CGKekDXHOm5d07n1qRDvb8UrIm
 69VnNXGEHQcKP9A3VXY/rG2dlEVyJHzFIAIsSWkzLB80Mp/gS1yipORKhr4ys+OGPnWZWmiV/4J
 BWUbQVePg0uf0e0cOrAoNBqOFcyFo4BkGQF1hxdo3wOWoddeLzoIUlAERLpffo0PnuJ85p5W/A5
 7hqkDv4Tkk7mRvtYIit2yPxmF7uGcZo4ooD5jb4azsanPHshfuIurxDxrLsJ8MBcoY4OnSRqxNN
 64V1tclE67og185wyOA==
X-Proofpoint-GUID: jfyVzBTFpg9auIU7M-O1iFM_XwEGPjYG
X-Authority-Analysis: v=2.4 cv=SomgLvO0 c=1 sm=1 tr=0 ts=6a9060f7 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bZYwddHGPv9KEr_TRj0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1011 phishscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

Current virtio-blk does not provide a mechanism for a guest to
program hardware keys or submit encrypted I/O using pre-programmed
keyslots.  It drops the crypto context when issuing a bio request
to the virtio-blk queue, preventing inline-encryption-based FBE
on virtio block devices.

This series enables File-Based Encryption in guest VMs on Qualcomm
GVM platforms where the ICE inline encryption hardware is shared
between the host and guests.  In this environment the guest kernel
has no access to the ICE hardware directly; it supplies a virtual
keyslot index and data unit number with each encrypted I/O request
via VIRTIO_BLK_F_INLINE_ENCRYPTION, and the host must translate the
virtual slot to a physical ICE keyslot and submit the bio — without
transferring raw key material across the VM boundary.

             +----------------------------------------------------------------+   
             |                                                                |   
             |               LA GVM                                           |   
             |                                                                |   
             |                                                       |        |   
             |                                                       |        |   
             |                                                       |        |   
             |                                                +------v------+ |   
             |                               +----y-----------+   blk-mq    | |   
             |                               |                +-------+-----+ |   
             |                               |                        |       |   
             |                               |                        |       |   
             |                    +----------v-----------+            |       |   
             |                    |blk-crypto-profile    +------------v       |   
             |                    +----------------------+            |       |   
             |                                                        |       |   
             |                                                        |       |   
             |            Control path:                               |       |   
             |            generate/import/prepare key                 |       |   
             |            program/evict/derive_sw_secret key          |       |   
+----------+ |                                                        |       |   
|          | |+-------------+     +-----------------------+     +-----v-----+ |   
|Trust Zone| || crypto-virt <-----+ virtio-blk-crypto-ext <-----+virtio-blk | |   
|          | |+------+------+     +-----------------------+     +-----+-----+ |   
|          | |       |                                         Data path: I/O |   
+-------^--+ +-------+------------------------------------------------+-------+   
        |         SMC|call                                (virt_slot, DUN, DUSize)
        |            |                                    appended in virtblk_req 
    +---+------------v------------------------------------------------v----------+
    |  +--------------+                             +--------------------------+ |
    |  | SMC trap     |                  Hypervisor | MMIO trap/VIRQ injection | |
    +--+--------------+-----------------------------+--------------------------+ +

    +--------------------------------------------------------------------------------------------+
    |                                                                    PVM                     |
    |                                                                                            |
    | Crypto IO    +--------------+                                                              |
  +-+-------------->  QEMU/Crosvm +-------+                                                      |
  | |              +--------------+  IO data                                                     |
  | |                             virt_slot, DUN, DUSize                                         |
  | |                                     |                                                      |
  | |+----------------+       +--------- -v-----+                                                |
  | ||  blk-crypto    <-------+ blk-crypto-proxy+-------------+----------------------+           |
  | |+----------------+       +-----------+-----+             |                      |           |
  | |                             slot path based             |                      |           |
  | |                               bio_crypt_ctx             |                      |           |
  | |+-----------------------+       +--- v----+              |                      |           |
  | || blk-crypto-profile    <---x---+  blk-mq |      bcp_hypervisor_ops             |           |
  | |+-----------------------+       +----+----+              |                      |           |
  | |                                     |                   |             bcp_slot_virt_ops    |
  | |                         +-----------v-----+             |                      |           |
  | |                         |         SCSI    |             |                      |           |
  | |                         +-----------+-----+             |                      |           |
  | |                                     |                   |                      |           |
  | |                 crypto msg in UTRD  |                   |                      |           |
  | |+----------------------+        +----v-----+  +----------v-- ---------+ +-------v--- ------+|
  | ||    ufs crypto        <--------+ ufs-core |  |blk-crypto-hyp-backend | | keyslot-partition||
  | |+----------------------+        +-----+----+  +-----------------------+ +------------------+|
  | +--------------------------------------+-----------------------------------------------------+
  |                                        |                                                      
  |                                        |                                                      
+-----------------------------------+   +--v---+-----------+                                      
| +------------------------+        |   |  ICE |    UFS    |                                      
||MMIO trap/VIRQ injection |  HYP   |   +------+-----------+                                      
+ +------------------------+--------+                                                             

Patches 1-3 land in the guest kernel.  Patch 1 negotiates
VIRTIO_BLK_F_INLINE_ENCRYPTION and wires it into blk-crypto.
Patches 2-3 add the Qualcomm GVM-side crypto backend, which routes
key programming and software-secret derivation through SCM calls to
TrustZone.  These patches are sent for review; the virtio-blk inline
encryption protocol is also under review (see
https://lore.kernel.org/all/20260814142306.3934029-1-linlin.zhang@oss.qualcomm.com/).
These patches and the virtio-spec depend on each other.  They must be
kept consistent for upstream merging.

Patch 4 adds the dt-binding for the Qualcomm crypto-virt node used by
the guest-side backend.

Patch 5 introduces a "slot path" in blk-crypto that lets a bio carry
a pre-programmed physical ICE keyslot index in bc_slot rather than a
blk_crypto_key pointer (bc_key == NULL).  This is needed on the host
side where the hypervisor has already programmed the keyslot; the host
kernel has no access to the raw key.  Patch 6 extends
ufshcd_prepare_lrbp_crypto() to handle this path.  Patch 7 moves
bio_crypt_dun_increment() to the public header so it can be called
from drivers/block/.

Patch 8 adds /dev/blk-crypto-proxy, a misc character device for
userspace virtio-blk backends.  The interface is three ioctls:
BCP_BIND_CONTEXT binds a host block device fd and a hypervisor VM fd;
BCP_GET_CRYPTO_CAPS queries the device's inline-crypto capabilities
and the VM's ICE keyslot allocation; BCP_SUBMIT_IO_BY_VSLOT resolves
a guest virtual slot to a physical ICE keyslot and submits the
inline-encrypted bio synchronously.  The driver is
hypervisor-agnostic and storage-vendor-agnostic, using two pluggable
op-sets registered by platform drivers at runtime.

Patch 9 implements bcp_slot_virt_ops for Qualcomm platforms: it parses
a qcom,ice-keyslot-map device-tree node that maps each guest_id to a
contiguous physical keyslot range.  Patch 10 adds slot_offset to struct
blk_crypto_profile so that blk_crypto_keyslot_index() returns the
correct physical slot number when the host's ICE range does not start
at slot 0.  Patch 11 extends ufs-qcom to read the host's own slot
reservation from the same DT node and initialize the
blk_crypto_profile accordingly.

Patches 1-4 are technically ready for review.  However, since they
depend on the proposed virtio-blk inline encryption protocol, progress
on these patches is expected to follow consensus on the protocol design.
Feedback on the overall architecture is therefore particularly valuable,
as it will also help advance the associated virtio-spec work.

Patches 5-8 implement the core host-side infrastructure and are
believed ready for review.

Patches 9-11 do not depend on any hypervisor-specific code.  Of them,
patches 9 and 11 provide the Qualcomm platform implementation based
on a static device-tree keyslot mapping; this may be revised in a future
version to use a TZ SCM query interface.

The kernel-internal header declares bcp_hypervisor_ops, which
translates a hypervisor VM fd to an opaque guest_id.  No upstream
implementation is included in this series because the series was
validated on a downstream Qualcomm GVM platform using the Gunyah
hypervisor, which provides a stable per-VM identifier but is not
yet upstream.  KVM does not currently expose an externally-visible
per-VM identifier that a kernel module could use for this purpose.
Input from KVM maintainers on whether and how such an interface
could be added, or whether an alternative identity mechanism is
preferred, would be welcome.

Known limitations
-------
  - Only AES-256-XTS has been tested.
  - virtio_blk_crypto_msg.dun is a fixed __virtio64; the driver refuses
    to enable inline crypto if the device advertises max_dun_bytes > 8 to
    prevent silent IV truncation and reuse.
  - Inline encryption is mutually exclusive with VIRTIO_BLK_F_ZONED.
  - The qcom_ice_slots driver uses a
    global singleton and ignores the blk_crypto_profile argument to its
    callbacks, so multiple storage controllers sharing a single slot table
    are not yet supported.
  - BCP_SUBMIT_IO_BY_VSLOT submits each bio synchronously with
    submit_bio_wait(); concurrent in-flight bios from multiple threads
    sharing one fd are not supported.

Testing
-------
Compilation pass on Linux-next.
End-to-end FBE virtualization with wrapped key enabled was validated
on top of gunyah hypervisor.  wrapped_key_test is a local utility to
get wrapped key and ephemeral wrapped key via storage ioctl interfaces.
  - /data/wrapped_key_test /dev/block/userdata generate
  - /data/wrapped_key_test /dev/block/userdata prepare /data/lt_key.bin
  - /data/fscryptctl insert_wrapped_key < /data/eph_key.bin
  - /data/fscryptctl set_policy --identifier=20f553802e64e36b43469211266a5f1c /data/testing
  - echo "data" > /data/testing/file.txt
  - sync and reboot
  - /data/wrapped_key_test /dev/block/userdata prepare /data/lt_key.bin
  - /data/fscryptctl insert_wrapped_key < /data/eph_key_2.bin
  - /data/fscryptctl set_policy --identifier=d8ca51d6d2094b73b2dae5ee7e3a10b6 /data/testing
  - cat /data/testing/file.txt


linlzhan (11):
  virtio_blk: add inline encryption support
  soc: qcom: add crypto_virt backend for virtio-blk inline crypto
  soc: qcom: crypto_virt: add support for create, prepare and import
    keys
  dt-bindings: soc: qcom: add binding for qcom,crypto-virt
  blk-crypto: add slot-based inline encryption path
  scsi: ufs: core: add slot path to ufshcd_prepare_lrbp_crypto
  blk-crypto: move bio_crypt_dun_increment() to the public header
  block: add /dev/blk-crypto-proxy for host-side virtio-blk inline
    encryption
  soc: qcom: add ICE keyslot partitioning driver for guest VMs
  blk-crypto: add slot_offset to blk_crypto_profile
  scsi: ufs: ufs-qcom: support ICE keyslot partitioning for guest VMs

 .../bindings/soc/qcom/qcom,crypto-virt.yaml   |  39 +
 block/blk-crypto-internal.h                   |   5 +-
 block/blk-crypto-profile.c                    |   7 +-
 block/blk-crypto.c                            |  57 +-
 drivers/block/Kconfig                         |  28 +
 drivers/block/Makefile                        |   3 +
 drivers/block/blk-crypto-proxy.c              | 667 ++++++++++++++++++
 drivers/block/virtio_blk.c                    | 199 +++++-
 drivers/block/virtio_blk_crypto_ext.c         | 283 ++++++++
 drivers/soc/qcom/Kconfig                      |  30 +
 drivers/soc/qcom/Makefile                     |   2 +
 drivers/soc/qcom/crypto_virt.c                | 197 ++++++
 drivers/soc/qcom/qcom_ice_slots.c             | 232 ++++++
 drivers/ufs/core/ufshcd-crypto.h              |  14 +-
 drivers/ufs/host/ufs-qcom.c                   |  91 ++-
 include/linux/blk-crypto-profile.h            |   9 +
 include/linux/blk-crypto-proxy.h              | 100 +++
 include/linux/blk-crypto.h                    |  28 +
 include/linux/virtio_blk_crypto_ext.h         |  78 ++
 include/uapi/linux/blk-crypto-proxy.h         | 122 ++++
 include/uapi/linux/virtio_blk.h               |  62 ++
 21 files changed, 2224 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.yaml
 create mode 100644 drivers/block/blk-crypto-proxy.c
 create mode 100644 drivers/block/virtio_blk_crypto_ext.c
 create mode 100644 drivers/soc/qcom/crypto_virt.c
 create mode 100644 drivers/soc/qcom/qcom_ice_slots.c
 create mode 100644 include/linux/blk-crypto-proxy.h
 create mode 100644 include/linux/virtio_blk_crypto_ext.h
 create mode 100644 include/uapi/linux/blk-crypto-proxy.h

-- 
2.34.1

