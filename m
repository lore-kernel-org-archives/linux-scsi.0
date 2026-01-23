Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6FC33985;
	Fri, 23 Jan 2026 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206790; cv=none; b=TJGBQSWboOqrc4UHsmmbmI/3LSQiOdE4uj6RWYOYqS9u1qhX0busm4VmpWQu3bUeuLPd9niLZEN8JC2BrPGta8d/AHVi2ZkG2BCUgPcZEmnLREkr22MWGDWRr7MoSoMNlr/uTxl0P1MVyeYsARIp4RlZ6V+M7GgNQi9LhYlyotE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206790; c=relaxed/simple;
	bh=XvKQbf5tSWHB1ZjAfppQ6iXqAUSdUK8UH6V7/QZHKeg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=P5ynh7B9lqe6Opy+khHruiFiZvqGlyc7Y0myJxNHw2OMfc6J5bCOLdDR4uQWscN4h+Tga+DFVGYUJWYlJr3XcNtNSCA0wj1bfbIrRGAYHSQmx3FqPd7FbzAedR8TS/yySzjkdUO8270I+Y1ghxTNONmoRaiEa2XpCSpaSuRHEew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4K3IM9LS; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4K3IM9LS"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dyXRS0SfZzlh1WS;
	Fri, 23 Jan 2026 22:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:subject
	:subject:from:from:content-language:user-agent:mime-version:date
	:date:message-id:received:received; s=mr01; t=1769206786; x=
	1771798787; bh=WXOJDmEHWqvdaloSjyUuCBbhoH9Ml5rvVPEVeVro3nU=; b=4
	K3IM9LSIBX1tnrMbP5ebQPGoVSceeOMeE4b3da+ebwTXJCbjlXoTIoiaiffKpbRy
	27HEt/dtJfhM6fcgU5nKMTdlY3AXCORX/F2mchAW5jF/FcVzTbnpkYBVBt26RCue
	F1CcgR0FaANDkC/O0Tzu8gcqzl7UW/T8XNos9nAbAqQdLiaBAxNPvkKYfiO+t0cu
	jY4RET2HhnsYLNU+17D5kYulc6abkBasvLwVOtO+mmhyi8QrKsnWQIcB32nZeSBz
	aeI+UJQBHUbO3DN5SCkF+kKHIqG7NmHaxjAmMU1HmZ4yblf9WZIOd5Y6r2yg5kEw
	/r4R8RXQJVA6VdK7WTmjw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id B-3JQDmGFdFE; Fri, 23 Jan 2026 22:19:46 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dyXRP5L49zlfl5q;
	Fri, 23 Jan 2026 22:19:45 +0000 (UTC)
Message-ID: <0cfe6fe2-3865-4dc2-92a7-74b1240f7b63@acm.org>
Date: Fri, 23 Jan 2026 14:19:44 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Language: en-US
Cc: lsf-pc@lists.linux-foundation.org, Jaegeuk Kim <jaegeuk@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [LSF/MM/BPF TOPIC] Block storage copy offloading
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Adoption of zoned storage is increasing in mobile devices. Log-
structured filesystems are better suited for zoned storage than
traditional filesystems. These filesystems perform garbage collection.
Garbage collection involves copying data on the storage medium.
Offloading the copying operation to the storage device reduces energy
consumption. Hence the proposal to discuss integration of copy
offloading in the Linux kernel block, SCSI and NVMe layers.

Other use-cases for copy offloading include reducing network traffic in
NVMeOF setups while copying data and also increasing throughput while
copying data.

Note: when using fscrypt, the contents of files can be copied without
decrypting the data since how data is encrypted depends on the file
offset and not on the LBA at which data is stored. See also
https://docs.kernel.org/filesystems/fscrypt.html.

My goal is to publish a patch series before the LSF/MM/BPF summit starts
that implements the following approach, an approach that hasn't been
proposed yet as far as I know:
* Filesystems call a block layer function that initiates a copy offload
   operation asynchronously. This function supports a source block
   device, a source offset, a destination block device, a destination
   offset and the number of bytes to be copied.
* That block layer function submits separate REQ_OP_COPY_SRC and
   REQ_OP_COPY_DST operations. In both bios bi_private is set such that
   it points at copy offloading metadata. The bi_private pointer is used
   to associate the REQ_OP_COPY_SRC and REQ_OP_COPY_DST operations that
   are involved in the same copying operation.
* There are two reasons why the choice has been made to have two copy
   operations instead of one:
   - Each bio supports a single offset and size (bi_iter). Copying data
     involves a source offset and a destination offset. Although it would
     be possible to store all the copying metadata in the bio data
     buffer, this approach is not compatible with the existing bio
     splitting code.
   - Device mapper drivers only support a single LBA range per bio.
* After a device mapper driver has finished mapping a bio, the result of
   the map operation is stored in the copy offloading metadata. This
   probably can be realized by intercepting dm_submit_bio_remap() calls.
* The device mapper mapping process is repeated until all input and
   output ranges have been mapped onto ranges not associated with a
   device mapper device. Repeating this process is necessary in case of
   stacked device mapper devices, e.g. dm-crypt on top of dm-linear.
* After the mapping process is finished, the block layer checks whether
   all LBA ranges are associated with the same non-stacking block driver
   (NVMe, SCSI, ...). If not, the copy offload operation fails and the
   block layer falls back to REQ_OP_READ and REQ_OP_WRITE operations.
* One or more copy operations are submitted to the block driver. The
   block driver is responsible for checking whether the copy operation
   can be offloaded. While the SCSI EXTENDED COPY command supports
   copying between logical units, whether the NVMe Copy command supports
   copying across namespaces depends on the version of the NVMe
   specification supported by the controller.
* It is verified whether the copy operation copied all data.
   If not, the block layer falls back to REQ_OP_READ and REQ_OP_WRITE.

Thanks,

Bart.
