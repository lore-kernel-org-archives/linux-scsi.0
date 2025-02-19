Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD288286280
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740003432; cv=none; b=t5AMnjBoTv3NrX4D0YYq+yBXX5xULaWVRPNFCTukd4RX5SAF/0qN9YNnO39jutfO2bbNy+ShWeflHzcvLPUoUHmDi7EJLb/6f1F50w56GLuyUrUdrQobi1556v3w7udXOtPrGIXw0t49ysKTzZ81f2kYFAEMiaLCzexAuWv9YVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740003432; c=relaxed/simple;
	bh=vyZ5FwH+Jilgeh9MqZ18xg41wyY+L//x6H/a4wmV0Yw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3QB4TkdqkGvkS07pTaCIgVw+/utt1On0ebt0mMDWmGuG/m9fNgtW+2PX6alzLy0HRwZgaQ1mvm6zUZeoKpVt1g2Z/tAjfuC57nEwRBYGn6Vm3Gh0jEZgbi6JFkIhAInWpOl67a5cD5Ps5SqakufrpHC2Envwru7aNo0vwO384E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJNQaLhm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJNQaLhm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740003428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TVkJfS7lS4RVjB3ko3E6TWvwdhEaHOg4C4hPboP9kM=;
	b=DJNQaLhmo17T6GkElwT0OwxTTUudQE5zsmHkgmCFfUcK8vmjjt97y2G8bxsYMMn1bhXyun
	oTOnskKzsvAcjgJa5iy+Vgz2JC/WYwjWaK9cDqERRvanTo4L4WT0Id3EqSCivY1VhFAIR6
	rZNBhynn2wNsyr1VbEwEsw4z9sHVw5A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-lA6e-73lMnSeM6XdwmCRIQ-1; Wed,
 19 Feb 2025 17:17:06 -0500
X-MC-Unique: lA6e-73lMnSeM6XdwmCRIQ-1
X-Mimecast-MFC-AGG-ID: lA6e-73lMnSeM6XdwmCRIQ_1740003423
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2403418EB2C9;
	Wed, 19 Feb 2025 22:17:03 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A73261944CC4;
	Wed, 19 Feb 2025 22:17:01 +0000 (UTC)
Message-ID: <a86e8b87-36e5-4848-a906-d77d88d190da@redhat.com>
Date: Wed, 19 Feb 2025 17:17:00 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] scsi: scsi_debug: Add support for partitioning the
 tape
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
 <20250213092636.2510-8-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250213092636.2510-8-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

Tested tape partitions with this patch and everything works!

[root@to-be-determined ~]#  mt -f /dev/nst1 stshowoptions
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:00:20 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
The options set: buffer-writes async-writes read-ahead debug can-bsr

[root@to-be-determined ~]#  mt -f /dev/nst1 stsetoptions can-partitions
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] Mode 0 options: buffer writes: 1, async writes: 1, read ahead: 1
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1]     can bsr: 1, two FMs: 0, fast mteom: 0, auto lock: 0,
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1]     defs for wr: 0, no block limits: 0, partitions: 1, s2 log: 0
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1]     sysv: 0 nowait: 0 sili: 0 nowait_filemark: 0
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1]     debugging: 1
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:03:51 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]#  mt -f /dev/nst1 stshowoptions
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] Updating partition number in status.
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] Got tape pos. blk 0 part 0.
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:13 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
The options set: buffer-writes async-writes read-ahead debug can-bsr can-partitions

[root@to-be-determined ~]#  mt -f /dev/nst1 mkpartition 200
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Loading tape.
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Error: 2, cmd: 0 0 0 0 0 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Sense Key : Unit Attention [current]
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Add. Sense: Not ready to ready change, medium may have changed
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 0 was_reset 0/0 ready 0, result 2
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] New tape session.
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] New tape session.
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] check_tape: 1126: CHKRES_NEW_SESS pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Partition page length is 14 bytes.
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] psd_cnt 2, max.parts 1, nbr_parts 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Formatting tape with two partitions (1 = 200 MB).
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] Sending FORMAT MEDIUM
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:04:44 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]# mt -f /dev/nst1 status
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (41010000):
  BOT ONLINE IM_REP_EN

[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:11 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]#  mt -f /dev/nst1 setpartition 1
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Setting block to 0 and partition to 1.
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Got tape pos. blk 0 part 0.
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Visited block 0 for partition 0 saved.
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] Trying to change partition from 0 to 1
[Wed Feb 19 17:05:41 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]# mt -f /dev/nst1 status
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
SCSI 2 tape drive:
File number=0, block number=0, partition=1.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (41010000):
  BOT ONLINE IM_REP_EN
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:05:47 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]# dd if=/dev/random count=1024 of=/dev/nst1
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
dd: writing to '/dev/nst1': No space left on device
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Error: 2, cmd: a 0 0 2 0 0
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Sense Key : No Sense [current]
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Add. Sense: End-of-partition/medium detected
^^^^
Oops.

[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] st_chk_result: 432: pos_unknown 0 was_reset 0/0 ready 0, result 2
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Error on write:
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] EOM with 512 bytes unwritten.
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Number of r/w requests 181, dio used in 181, pages 181.
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Async write waits 0, finished 0.
[Wed Feb 19 17:06:17 2025] st 8:0:0:0: [st1] Buffer flushed, 1 EOF(s) written
181+0 records in
180+0 records out
92160 bytes (92 kB, 90 KiB) copied, 0.200082 s, 461 kB/s


[root@to-be-determined ~]# mt -f /dev/nst1 eof 2
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] Writing 2 filemarks.

# Interesting, it lets me write a file mark after hitting EOM.

[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:44 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]# mt -f /dev/nst1 status
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
SCSI 2 tape drive:
File number=3, block number=0, partition=1.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (81010000):
  EOF ONLINE IM_REP_EN

[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:06:59 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]#  mt -f /dev/nst1 setpartition 0
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Setting block to 0 and partition to 0.
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Got tape pos. blk 184 part 1.
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Visited block 184 for partition 1 saved.
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] Trying to change partition from 1 to 0
[Wed Feb 19 17:07:13 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]# mt -f /dev/nst1 status
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (41010000):
  BOT ONLINE IM_REP_EN
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 17:07:30 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

On 2/13/25 4:26 AM, Kai Mäkisara wrote:
> This patch adds support for MEDIUM PARTITION PAGE in MODE SELECT and the
> FORMAT MEDIUM command for tapes. After these additions, the virtual tape
> can be partitioned containing either one or two partitions. The POFM
> flag in the mode page is set, meaning that the FORMAT MEDIUM command
> must be used to create the partitioning defined in the mode page.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 108 ++++++++++++++++++++++++++++++++++++--
>   1 file changed, 104 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 7da1758da3f5..74b136da55ce 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -188,6 +188,7 @@ static const char *sdebug_version_date = "20210520";
>   #define TAPE_EW 20
>   #define TAPE_MAX_PARTITIONS 2
>   #define TAPE_UNITS 10000
> +#define TAPE_PARTITION_1_UNITS 1000
>   
>   /* The tape block data definitions */
>   #define TAPE_BLOCK_FM_FLAG   ((u32)0x1 << 30)
> @@ -405,6 +406,9 @@ struct sdebug_dev_info {
>   	unsigned int tape_density;
>   	unsigned char tape_partition;
>   	unsigned char tape_nbr_partitions;
> +	unsigned char tape_pending_nbr_partitions;
> +	unsigned int tape_pending_part_0_size;
> +	unsigned int tape_pending_part_1_size;
>   	unsigned char tape_dce;
>   	unsigned int tape_location[TAPE_MAX_PARTITIONS];
>   	unsigned int tape_eop[TAPE_MAX_PARTITIONS];
> @@ -534,14 +538,15 @@ enum sdeb_opcode_index {
>   	SDEB_I_LOCATE = 34,
>   	SDEB_I_WRITE_FILEMARKS = 35,
>   	SDEB_I_SPACE = 36,
> -	SDEB_I_LAST_ELEM_P1 = 37,	/* keep this last (previous + 1) */
> +	SDEB_I_FORMAT_MEDIUM = 37,
> +	SDEB_I_LAST_ELEM_P1 = 38,	/* keep this last (previous + 1) */
>   };
>   
>   
>   static const unsigned char opcode_ind_arr[256] = {
>   /* 0x0; 0x0->0x1f: 6 byte cdbs */
>   	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
> -	    0, SDEB_I_READ_BLOCK_LIMITS, 0, 0,
> +	    SDEB_I_FORMAT_MEDIUM, SDEB_I_READ_BLOCK_LIMITS, 0, 0,
>   	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
>   	SDEB_I_WRITE_FILEMARKS, SDEB_I_SPACE, SDEB_I_INQUIRY, 0, 0,
>   	    SDEB_I_MODE_SELECT, SDEB_I_RESERVE, SDEB_I_RELEASE,
> @@ -629,6 +634,7 @@ static int resp_locate(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_write_filemarks(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_space(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_rewind(struct scsi_cmnd *, struct sdebug_dev_info *);
> +static int resp_format_medium(struct scsi_cmnd *, struct sdebug_dev_info *);
>   
>   static int sdebug_do_add_host(bool mk_new_store);
>   static int sdebug_add_host_helper(int per_host_idx);
> @@ -867,7 +873,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   	    resp_report_zones, zone_in_iarr, /* ZONE_IN(16), REPORT ZONES) */
>   		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>   		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
> -/* 31 */
> +/* 32 */
>   	{0, 0x0, 0x0, F_D_OUT | FF_MEDIA_IO,
>   	    resp_atomic_write, NULL, /* ATOMIC WRITE 16 */
>   		{16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> @@ -881,7 +887,9 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   	    {6,  0x01, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   	{0, 0x11, 0, F_D_IN, resp_space, NULL,    /* SPACE (6) */
>   	    {6,  0x07, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> -
> +	{0, 0x4, 0, 0, resp_format_medium, NULL,  /* FORMAT MEDIUM (6) */
> +	    {6,  0x3, 0x7, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> +/* 38 */
>   /* sentinel */
>   	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
>   	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> @@ -2844,6 +2852,51 @@ static int resp_partition_m_pg(unsigned char *p, int pcontrol, int target)
>   	return sizeof(partition_pg);
>   }
>   
> +static int process_medium_part_m_pg(struct sdebug_dev_info *devip,
> +				unsigned char *new, int pg_len)
> +{
> +	int new_nbr, p0_size, p1_size;
> +
> +	if ((new[4] & 0x80) != 0) { /* FDP */
> +		partition_pg[4] |= 0x80;
> +		devip->tape_pending_nbr_partitions = TAPE_MAX_PARTITIONS;
> +		devip->tape_pending_part_0_size = TAPE_UNITS - TAPE_PARTITION_1_UNITS;
> +		devip->tape_pending_part_1_size = TAPE_PARTITION_1_UNITS;
> +	} else {
> +		new_nbr = new[3] + 1;
> +		if (new_nbr > TAPE_MAX_PARTITIONS)
> +			return 3;
> +		if ((new[4] & 0x40) != 0) { /* SDP */
> +			p1_size = TAPE_PARTITION_1_UNITS;
> +			p0_size = TAPE_UNITS - p1_size;
> +			if (p0_size < 100)
> +				return 4;
> +		} else if ((new[4] & 0x20) != 0) {
> +			if (new_nbr > 1) {
> +				p0_size = get_unaligned_be16(new + 8);
> +				p1_size = get_unaligned_be16(new + 10);
> +				if (p1_size == 0xFFFF)
> +					p1_size = TAPE_UNITS - p0_size;
> +				else if (p0_size == 0xFFFF)
> +					p0_size = TAPE_UNITS - p1_size;
> +				if (p0_size < 100 || p1_size < 100)
> +					return 8;
> +			} else {
> +				p0_size = TAPE_UNITS;
> +				p1_size = 0;
> +			}
> +		} else
> +			return 6;
> +		devip->tape_pending_nbr_partitions = new_nbr;
> +		devip->tape_pending_part_0_size = p0_size;
> +		devip->tape_pending_part_1_size = p1_size;
> +		partition_pg[3] = new_nbr;
> +		devip->tape_pending_nbr_partitions = new_nbr;
> +	}
> +
> +	return 0;
> +}
> +
>   static int resp_compression_m_pg(unsigned char *p, int pcontrol, int target,
>   	unsigned char dce)
>   {	/* Compression page for mode_sense (tape) */
> @@ -3172,6 +3225,17 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   			return 0;
>   		}
>   		break;
> +	case 0x11:	/* Medium Partition Mode Page (tape) */
> +		if (sdebug_ptype == TYPE_TAPE) {
> +			int fld;
> +
> +			fld = process_medium_part_m_pg(devip, &arr[off], pg_len);
> +			if (fld == 0)
> +				return 0;
> +			mk_sense_invalid_fld(scp, SDEB_IN_DATA, fld, -1);
> +			return check_condition_result;
> +		}
> +		break;
>   	case 0x1c:      /* Informational Exceptions Mode page */
>   		if (iec_m_pg[1] == arr[off + 1]) {
>   			memcpy(iec_m_pg + 2, arr + off + 2,
> @@ -3556,6 +3620,39 @@ static int partition_tape(struct sdebug_dev_info *devip, int nbr_partitions,
>   	return nbr_partitions;
>   }
>   
> +static int resp_format_medium(struct scsi_cmnd *scp,
> +			struct sdebug_dev_info *devip)
> +{
> +	int res = 0;
> +	unsigned char *cmd = scp->cmnd;
> +
> +	if (sdebug_ptype != TYPE_TAPE) {
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 0, -1);
> +		return check_condition_result;
> +	}
> +	if (cmd[2] > 2) {
> +		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 2, -1);
> +		return check_condition_result;
> +	}
> +	if (cmd[2] != 0) {
> +		if (devip->tape_pending_nbr_partitions > 0) {
> +			res = partition_tape(devip,
> +					devip->tape_pending_nbr_partitions,
> +					devip->tape_pending_part_0_size,
> +					devip->tape_pending_part_1_size);
> +		} else
> +			res = partition_tape(devip, devip->tape_nbr_partitions,
> +					devip->tape_eop[0], devip->tape_eop[1]);
> +	} else
> +		res = partition_tape(devip, 1, TAPE_UNITS, 0);
> +	if (res < 0)
> +		return -EINVAL;
> +
> +	devip->tape_pending_nbr_partitions = -1;
> +
> +	return 0;
> +}
> +
>   static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
>   {
>   	return devip->nr_zones != 0;
> @@ -6522,6 +6619,7 @@ static int scsi_debug_sdev_configure(struct scsi_device *sdp,
>   			if (!devip->tape_blocks[0])
>   				return 1;
>   		}
> +		devip->tape_pending_nbr_partitions = -1;
>   		if (partition_tape(devip, 1, TAPE_UNITS, 0) < 0) {
>   			kfree(devip->tape_blocks[0]);
>   			devip->tape_blocks[0] = NULL;
> @@ -6783,6 +6881,8 @@ static void scsi_tape_reset_clear(struct sdebug_dev_info *devip)
>   		devip->tape_dce = 0;
>   		for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
>   			devip->tape_location[i] = 0;
> +		devip->tape_pending_nbr_partitions = -1;
> +		/* Don't reset partitioning? */
>   	}
>   }
>   

