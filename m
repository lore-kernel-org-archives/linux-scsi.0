Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9AB23AB9C;
	Tue, 21 Oct 2025 05:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761025010; cv=none; b=Rg70yt1LK63iSvOY746y8caHWP1svPSSNltUKOlQPHHpri2PcLM1h1YZXwN0THHmGwMw94Nx1gBOrq50gxdfVSNhhDSnoyctVKLmaeDCOArMPoObtiuC4ltpsXOr76Om4zJs1rtCSck/1Pri5DyYOlIoaXyk6+QQRwNzJrygOoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761025010; c=relaxed/simple;
	bh=T09YKLc/aWWjmxxkF2jQHHlcSWx+HpI6aR2Lq2mNO58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGQfK6jalBZxjzTZKxa3yX8z7PVrqKO6Y/NWc77+o7nza3nt3DqyInDeuLcMH3xcOC5FWHTFkpetVKGywSPGnYMi7AV9FWN5LXG2HScroSxfIVecr3ey8uoW5Tuh8CagoFKymUeaWHiKGMp/7uaSpqyTlXjJfo0TkxWBgV7tGP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O5ys5hDF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O5ys5hDF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YlFYbdykABayPvN+IU9EDT7b7dDniXXWQfbMhJjQoRY=; b=O5ys5hDF/JUqv4GTDZ9CfnNB97
	bkSwcNvT9u+cK36isCaQ/FW3WPY2Uy7KpnNsxMtEoO3wLNSe4ClSQeBdbAOj6J9P4HdkTeeO8MWe5
	l1VdwCZko+QrkD0/VPNnd2ywkMPz6gJImVpJsMoRo5DWBmiju5M0TzkvIeffT2bnDpBe1riVxxgHH
	5kOY8ZlN2+Kixvf8nhquo//E8n+Lkt7JCuVegYYdCZvSIqQOfuZKKnlZ2EE+8stbGcBSrh4rBXGOV
	1d5cFqNeoy3/CASLSqSX6sAdfXfF82xArzYDOY57XDQ+QJHy7LpT5pDBT2w2IdkuxtwZ8CI58IIsh
	ypncjiDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vB53A-0000000FsC2-1kdS;
	Tue, 21 Oct 2025 05:36:48 +0000
Date: Mon, 20 Oct 2025 22:36:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yuhao Jiang <danisjiang@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: wd33c93: fix buffer overflow in SCSI message-in
 handling
Message-ID: <aPcb8MMIJ2ve64yD@infradead.org>
References: <20251021020804.3248930-1-danisjiang@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021020804.3248930-1-danisjiang@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This exploit really needs a catchy name.  Just think of how much
valuable data you could extract by selling malicious fake 8-bit
SCSI disks to retro computing enthusiasts and then exploiting their
SCSI HBA driver.

On Mon, Oct 20, 2025 at 09:08:04PM -0500, Yuhao Jiang wrote:
> A buffer overflow vulnerability exists in the wd33c93 SCSI driver's
> message handling where missing bounds checking allows a malicious
> SCSI device to overflow the incoming_msg[] buffer and corrupt kernel
> memory.
> 
> The issue occurs because:
> - incoming_msg[] is a fixed 8-byte buffer (line 235 in wd33c93.h)
> - wd33c93_intr() writes to incoming_msg[incoming_ptr] without
>   validating incoming_ptr is within bounds (line 935)
> - For EXTENDED_MESSAGE, incoming_ptr increments based on the device-
>   supplied length field (line 1085) with no maximum check
> - The validation at line 1001 only checks if the message is complete,
>   not if it exceeds buffer size
> 
> This allows an attacker controlling a SCSI device to craft an extended
> message with length field 0xFF, causing the driver to write 256 bytes
> into an 8-byte buffer. This can corrupt adjacent fields in the
> WD33C93_hostdata structure including function pointers, potentially
> leading to arbitrary code execution.
> 
> Add bounds checking in the MESSAGE_IN handler to ensure incoming_ptr
> does not exceed buffer capacity before writing. Reject oversized
> messages per SCSI protocol by sending MESSAGE_REJECT.
> 
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yuhao Jiang <danisjiang@gmail.com>
> ---
>  drivers/scsi/wd33c93.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index dd1fef9226f2..2d50a0a01726 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -932,6 +932,19 @@ wd33c93_intr(struct Scsi_Host *instance)
>  		sr = read_wd33c93(regs, WD_SCSI_STATUS);	/* clear interrupt */
>  		udelay(7);
>  
> +		/* Prevent buffer overflow from malicious extended messages */
> +		if (hostdata->incoming_ptr >= sizeof(hostdata->incoming_msg)) {
> +			printk("wd33c93: Incoming message too long, rejecting\n");
> +			hostdata->incoming_ptr = 0;
> +			write_wd33c93_cmd(regs, WD_CMD_ASSERT_ATN);
> +			hostdata->outgoing_msg[0] = MESSAGE_REJECT;
> +			hostdata->outgoing_len = 1;
> +			write_wd33c93_cmd(regs, WD_CMD_NEGATE_ACK);
> +			hostdata->state = S_CONNECTED;
> +			spin_unlock_irqrestore(&hostdata->lock, flags);
> +			break;
> +		}
> +
>  		hostdata->incoming_msg[hostdata->incoming_ptr] = msg;
>  		if (hostdata->incoming_msg[0] == EXTENDED_MESSAGE)
>  			msg = EXTENDED_MESSAGE;
> -- 
> 2.34.1
> 
> 
---end quoted text---
