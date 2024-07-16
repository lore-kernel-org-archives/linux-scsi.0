Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF4C25779
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jul 2024 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721159750; cv=none; b=AZcPyB/cJoeqxIViPlbH8LPreZMcibKHyYjkGrd6/lbmF9Z9jGAMDpz0Wer+mSMSoTtU492QrP02w4h/WTNJv5Q5dMf9//Tn3lUmFvxdkH2GoC33XdNWvL1VQNWPmDNV04q7IKpHaMkVgOKxpOTJ8Uz+9qDLfDBfD+J2BEn8v+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721159750; c=relaxed/simple;
	bh=+dukO4vRhP7V8+O73+Tq9iNX+T8h5LATyVDgubUjWIk=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=KQfBjR45GvumlZLO30BCuOlHG3oFgJtBi0OYKcOnmCRjmSGOLWF++uFP/Lt3OwbzADqdgaiYfQTH3bowNLqOsQCFU/NBUwWJHBeIygWw7zluCmseK0KGhSY68izQLA4r6EJ5QOmd3WXG9qOV1/B8gNFWHmLF4m+kSF4zZBQ50F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K5+viH+O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5+viH+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721159747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OzLC0yzCu7tQh9KqVhFprkcDVVw3RS5/BHX2qPZCoqQ=;
	b=K5+viH+Op/lm34bq9w7SvMyrktUWll7CKFRGDPKPrtL2wTpLdCTdLAwxynSra0rSTeJxbI
	zJByPmdxeo+/62fNw42TgyEnIvp7Kuug0Jj3vF+xgIzDPUmnIYb0mmngNbnV4w55QGSvtY
	B4idf30NXuXhh3mT7CYqAJ/2ZmCS0lE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-ouPr8ZYhMDmoy9991xW9Uw-1; Tue,
 16 Jul 2024 15:55:44 -0400
X-MC-Unique: ouPr8ZYhMDmoy9991xW9Uw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7637B1955BFC;
	Tue, 16 Jul 2024 19:55:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3FD6A1955D42;
	Tue, 16 Jul 2024 19:55:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
cc: dhowells@redhat.com, linux-scsi@vger.kernel.org,
    linux-block@vger.kernel.org
Subject: SCSI error indicating misalignment on part of Linux scsi or block layer?
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <483246.1721159741.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jul 2024 20:55:41 +0100
Message-ID: <483247.1721159741@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi James,

I'm wondering if I'm seeing a problem with DIO writes through Ext4 or XFS
manifesting as SCSI misalignment errors.  This has occurred with two diffe=
rent
drives.  I saw it first with v6.10-rc6, I think, but I haven't tried
cachefiles for a while.  It does happen with v6.10.

ata1.00: exception Emask 0x60 SAct 0x1 SErr 0x800 action 0x6 frozen
ata1.00: irq_stat 0x20000000, host bus error
ata1: SError: { HostInt }
ata1.00: failed command: WRITE FPDMA QUEUED
ata1.00: cmd 61/68:00:b0:93:34/00:00:02:00:00/40 tag 0 ncq dma 53248 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x60 (host bus erro=
r)
ata1.00: status: { DRDY }
ata1: hard resetting link
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_OK cmd_age=3D3s
sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current] =

sd 0:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 02 34 93 b0 00 00 68 00
I/O error, dev sda, sector 37000112 op 0x1:(WRITE) flags 0x8800 phys_seg 1=
 prio class 0
ata1: EH complete

For reference, I made it dump the result of the READ CAPACITY 16 command:

sd 0:0:0:0: [sda] RC16 000000003a38602f00000200000000000000000000000000000=
0000000000000

The drive says it has 512-byte logical and physical block sizes.

The DIO writes are being generated by cachefiles and are all
PAGE_SIZED-aligned in terms of file offset and request length.

I also saw this:

	CacheFiles: I/O Error: Trunc-to-dio-size failed -95 [o=3D000001cb]

which indicates that ext4/xfs returned EOPNOTSUPP to vfs_truncate() and th=
ence
to cachefiles.  I'm not sure why it would do that.

Any idea what might cause this or how to investigate it further?  Is it
possible it's some sort of hardware error in the I/O bridge or IOMMU?

Thanks,
David

