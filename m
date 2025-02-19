Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FFA1CAA65
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740004343; cv=none; b=jjpxTEq/ZKfahmlVdNGZOQb2uZ5mvijbDc5xq4SPYLrrDAV41iMhV7pdyYPu+mmLVp/HN+c92eT2/0ffgzw7GQRH7wXW0K4CUr8X5jM/N853D0spjWBx4M9WzfaRpjIfkgEARSpOXwCpr3ldIYYa//ZevzioC5gnuIwBAhxE7oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740004343; c=relaxed/simple;
	bh=q6fI7RqKVNPqApnZz6DMmUOhEfzV/NuAeDudLDTaIn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s47qzLIrz4bwUuQ8ZhI/Q2HOUIVlmhb+E17W0h+bU7uGLM+ji//1PGyUGgwS/xof8V+K4rCxnebwGQoAbpkpJL8hNzcwf9ETUyFVYts1dTUQvs2wVty6o6iLitnw9LI+ZQD7ArBzElJ+jI12lOQxESpkrkpwDNW3LOE8/wjtr/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bLLb9xaF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bLLb9xaF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740004340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZht3o3JuLtn4pgpDy3ptoEr4irG3O1CKjKxFtylAN8=;
	b=bLLb9xaF4yJflqXns6C1FGIlDTKzmSfFbUG+dlKASAI4VD5Wtjhbdp1gbD/oe1ZnZhFWWX
	x4pfrgP8nTnTXMTLOT77ZKLsqWTllqpBK4QbJNIC3IDyt26O7Rdd6PArIElHyppMqRc/2b
	2oZvvlIZPgrJI1a8FXqhlpgpZUai/Fk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-mkB_za6jN3mfUXefEpi87A-1; Wed,
 19 Feb 2025 17:32:17 -0500
X-MC-Unique: mkB_za6jN3mfUXefEpi87A-1
X-Mimecast-MFC-AGG-ID: mkB_za6jN3mfUXefEpi87A_1740004336
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BF9E18EB2C3;
	Wed, 19 Feb 2025 22:32:16 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C5DA31956094;
	Wed, 19 Feb 2025 22:32:14 +0000 (UTC)
Message-ID: <30ec7c7a-3eca-461a-9deb-2856cd273d80@redhat.com>
Date: Wed, 19 Feb 2025 17:32:13 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] scsi: scsi_debug: Add more tape support
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 dgilbert@interlog.com
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Kai,

Thank you for these patches. This is a huge improvement to scsi_debug tape emulator and I am sure everyone will use this.

I must admit that I cheated a little bit with some of the test results I posted here as I did not test each patch,
but rather tested this whole series. I'll also admit I didn't really test the compression stuff.  I'll need
to develop some more tests to do that.

At this point the scsi_debug tape emulator is working as well as a real tape drive.  This will enable
me to greatly simplify and streamline my tape_tests.  I should now be able to consolidate everything
down into one or two test scripts that can be run against either a hardware tape device or the scsi_debug
tape device. There is certainly more room for improvements in my tests and these patches will enable that work.

The latest version of my tests are in the branch.

https://github.com/johnmeneghini/tape_tests/tree/version_5a

I'll work on improving theses tests as soon as this patches get merged upstream.

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

Martin, please merge these patches.

On 2/13/25 4:26 AM, Kai Mäkisara wrote:
> Currently, the scsi_debug driver can create tape devices and the st
> driver attaches to those. Nothing much can be done with the tape devicesTh
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
a> - partition page added
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

