Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69121DE4C1
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463175; cv=none; b=Rh8IWLL0Nwueh10MW/tq4ligUlV0zoLbzfwp4WegOp4cfiAtRyVfF7bzsPIOx7/vtyKkmjgeum9Zc6itco1+Dnp1JPXITwNLeOp/baBPH4IG+BZ9M1Ik3zGhN8hEbctos6FXXJDE4BuH/1zR5Ibm0i1qVwiuSS7I19BK1K02+3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463175; c=relaxed/simple;
	bh=aVjFYDK4arcsLHaVRv28g22zvBTRfmnEumNX7/L8BwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4wE1HOctou6s/2C1WBc1U5h/HFAVAQHuKNbF4YId6kg/nMTUrccPLwWBZgGp2hNKWSyWdFp0eWau2OSVLhMNQSjMavDovlBMJVsypveWLnL3UzvykHbVntXf9VQK94EudXjl2XKnj7EgOd/OPTuUwqjgA6OiJRitPsknpzQGPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e0Im8AEL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e0Im8AEL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739463172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+4HmqRP8CuCnmQg4TWCwNyMwRTD8aFo0iFQMI5fYg3w=;
	b=e0Im8AELwG3cyLkK9bSieONXnDRa27RvxvvbRIyqlQF3EujK8+I+5Y9kZvPzJQ/9DSkOMv
	x3ZCIvHE7BiPQ8capNDvef37WtxrL4yPvZ8CYGH59Yl3/WXTca2aG47Sr5h1RViHI2YXh6
	m3g1GrxuUfye9vZmIQgiR4OJ/8SLRi4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-256-0T3JqUuJNuS4KZmsKJtXeA-1; Thu,
 13 Feb 2025 11:12:49 -0500
X-MC-Unique: 0T3JqUuJNuS4KZmsKJtXeA-1
X-Mimecast-MFC-AGG-ID: 0T3JqUuJNuS4KZmsKJtXeA_1739463168
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC6A51975AFC;
	Thu, 13 Feb 2025 16:12:47 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB9371941298;
	Thu, 13 Feb 2025 16:12:45 +0000 (UTC)
Message-ID: <35ad5fb0-5a43-4755-bc9e-cc29de6ea7a6@redhat.com>
Date: Thu, 13 Feb 2025 11:12:44 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] scsi: scsi_debug: Add more tape support
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Thanks for all the patches Kai.

I will work on reviewing and testing these patches ASAP.

BTW, the st driver fixes you delivered in v6.13 and v6.14-rc1 are all working.

We have already resolved some customer reported tape issues and regressions with these
patches and I'm shipping them in RHEL-8.10z and RHEL-9.*.

John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

On 2/13/25 4:26 AM, Kai Mäkisara wrote:
> Currently, the scsi_debug driver can create tape devices and the st
> driver attaches to those. Nothing much can be done with the tape devices
> because scsi_debug does not have support for the tape-specific commands
> and features. These patches add some more tape support to the scsi_debug
> driver. The end result is simulated drives with a tape having one or two
> partitions (one partition is created initially).
> 
> The tape is implemented as fixed number (10 000) of 8-byte units.
> The first four bytes of a unit contain the type of the unit (data
> block, filemark or end-of-data mark). If the units is a data block,
> the first four bytes also contain the block length and the remaining
> four bytes the first bytes of written data. This allows the user
> to use tags to see that the read block is what it was supposed to be.
> 
> The following SCSI operations are added or modified:
> FORMAT MEDIUM
> - added
> LOCATE
> - added
> MODE SELECT
> - modified to allow use without page(s) (just header and block descriptor)
>    - store density and block size
> - partition page added
> MODE SENSE
> - modified to allow use without page(s) (just header and block descriptor)
>    - set density and block size
> - partition page added
> READ BLOCK LIMITS
> - added
> READ POSITION
> - added
> READ
> - added tape support for READ (6)
> REWIND
> - modified to set the tape position
> SPACE
> - added
> START STOP (LOAD)
> - modified to return New Medium Unit Attention if tape loaded (not
>    according to the standard, but enables testing this UA)
> WRITE
> - added tape support for WRITE (6)
> WRITE FILEMARKS
> - added
> 
> Changes RFC -> v1:
> - rebased to v6.14-rc1
> - virtual tape initialization is rewritten and the tape is made shorter
>    (10 000 units)
> - only one partition is created initially
> - tape block allocation is moved to sdev_configure()
> - tape blocks are freed in sdev_destroy()
> - block size must be multiple of four (SSC standard)
> - granularity set to four in READ BLOCK LIMITS
> - long LBA not allowed for tapes in MODE SELECT/SENSE
> - READ POSITION checks allocation length
> - new patch 7 adds support for re-partitioning the tape
> 
> Changes v1 -> v2:
> - Fixes for bugs reported by the Kernel Test Robot:
>    2/7: changed 'len +=' to 'len =' in resp_mode_sense()
>    3/7: changed 'for (;' to 'for (i = 0;' in partition_tape()
>    4/7: initialized i to zero in resp_space()
> 
> Kai Mäkisara (7):
>    scsi: scsi_debug: First fixes for tapes
>    scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
>    scsi: scsi_debug: Add write support with block lengths  and 4 bytes of
>      data
>    scsi: scsi_debug: Add read support and update locate for tapes
>    scsi: scsi_debug: Add compression mode page for tapes
>    scsi: scsi_debug: Reset tape setting at device reset
>    scsi: scsi_debug: Add support for partitioning the tape
> 
>   drivers/scsi/scsi_debug.c | 775 +++++++++++++++++++++++++++++++++++++-
>   1 file changed, 761 insertions(+), 14 deletions(-)
> 

