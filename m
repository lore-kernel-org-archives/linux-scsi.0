Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30F2479872
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 09:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328621; cv=none; b=SZoMgIidGZYV7b3jxpzQdNOR0YswVvoACJzFfwgbHl7k5BPHj2oMGg1MPJD3cx+IcR63qNsvWqcP9VaMtbLAn3rE3/XW/pqPawDpBq8FVdps/X9LK/vm6fCMWPbHMTy2AxGIlGFqIxiegNFGCpd3ufpYJAkqqHT5STCXWFh9a98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328621; c=relaxed/simple;
	bh=bhJI/o/XKAeek0NRgQ6rBedEJqDlrUAR+S36XKVbLRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EDapkDoTLjIANzf4N4hgCMYvGWy6AgB+RjQmJSL/1EKTAGSJyTemcpG/nKTxqMCNQ0SIi9pKYNAtp0vmGY0VnRi2tKJpOBKN5dlF/AQVQO5M7REsGJeJz220mn0upc4t+9uOFbxjtPYMlJ4KHBHNYqs//AxP23Xzm6dmM1KGPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=InZF1EJ2; arc=none smtp.client-ip=95.215.58.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="InZF1EJ2"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bhJI/o/XKAeek0NRgQ6rBedEJqDlrUAR+S36XKVbLRs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790328613; v=1; x=1790933413;
 b=InZF1EJ2vYV9zAQN4v029PA1P9o6/hR6XH5AXqIY+ZNLsljbi6amZUf7IHkEiLizeogYZjE1
 fLWFJFLJX9YhvODjFPzOauO8/Rr4QlBbfZBDagkUGY0IyEYuEWvHz11ZAjTy7OEPVDKVqEQVctZ
 gs21IiMnAMniWpdW5Xoi4y5Q=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id c62b8a93a3d2257a;
	Fri, 25 Sep 2026 09:30:12 +0000
X-Mizu-Trace-ID: c62b8a93a3d2257a
X-Migadu-Flow: FLOW_OUT
Message-ID: <3fc3aab6-9eca-4d3e-81ea-92ee56de2af5@linux.dev>
Date: Fri, 25 Sep 2026 10:30:11 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/11] scsi: scsi_debug: Refuse a short WRITE ATOMIC
 (16) before writing it
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
References: <20260925071726.140915-13-cassel@kernel.org>
 <20260925071726.140915-22-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260925071726.140915-22-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 08:17, Niklas Cassel wrote:
> A write whose data-out buffer is shorter than its transfer length is
> short. An ordinary write transfers what the buffer holds and reports the
> rest as a residual, but an atomic write cannot be short: SBC-6 r02
> (T10/BSR INCITS 587), 4.28.1, requires each atomic write operation to
> write either all of its data or none of it, and 4.28.2 requires one that
> cannot complete to leave the LBAs that it specifies unaltered.
> 
> resp_atomic_write() does fail a short WRITE ATOMIC (16) with DID_ERROR,
> but only after do_device_access() has returned, and do_device_access()
> copies one logical block at a time, so by then the blocks that the
> buffer did hold have been written. An eight block WRITE ATOMIC (16) with
> a buffer of four fails having overwritten the first four.
> 
> Check the length of the buffer before writing anything, and fail the
> command with the same DID_ERROR as before.
> 
> Assisted-by: LLM
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>    modprobe scsi_debug sector_size=512 physblk_exp=3 dev_size_mb=128 \
>        atomic_wr=1 lbpu=1
> 
> issuing a WRITE ATOMIC (16) of eight blocks through SG_IO with a buffer
> of four blocks of 0xaa. It fails with DID_ERROR before and after this
> patch, but before it the first four blocks read back as 0xaa afterwards,
> and after it all eight read back as they were. A WRITE ATOMIC (16) with
> a full buffer writes all eight blocks, as before.
> 

What is the command which you use?

I am just wondering if this check should go into sd_setup_atomic_cmnd() 
or somewhere else higher up. I mean, this check is not really specific 
to scsi_debug, right?

> Changes since v6: the comment is reworded, as Damien suggested.
> ---
>   drivers/scsi/scsi_debug.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index f59c4f11c851..c0bcf8155fc8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6247,6 +6247,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>   		}
>   	}
>   
> +	/* Short atomic writes are not allowed. */
> +	if (scsi_bufflen(scp) < len * sdebug_sector_size)
> +		return DID_ERROR << 16;
> +
>   	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
>   	if (unlikely(ret == -1))
>   		return DID_ERROR << 16;

