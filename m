Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 74810B661
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 16:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707842000; cv=none; b=ZtyiXP61h0/5nPRM7Imjk9E/tj1I7IUicpi7UrTmtVG41VAvE1KBAVYSGQalkET3JtmOJsJuVjbMo4XT5uWm/4tYc4W7fZM5wAp75GHzCepoGlFZJtrAkSz68pwG1MqHlFXVP6bJpPHkt3w8Fc16HxgauA6Xiq1AJP8iwwQxBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707842000; c=relaxed/simple;
	bh=d14lREhWx+tOon4ph0Ab8gMi95kr46zyK0xqNgMhZ0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iwJN/i6FYEN10IJmkUkUhPGeZEOMSZPoWYzkCFhLnCRMnAFDqT4qY4ty3bkLHmctXzUReB07G3YojFBUpPuIm//Hz7eKUshvBRia3UHg4WFzuNSOopz8h26swKotTu+gZCrqAqEtKV7+HAvkOk/hn3V/8Nn3jp4iu1LInK3m4Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 374583 invoked by uid 1000); 13 Feb 2024 11:33:14 -0500
Date: Tue, 13 Feb 2024 11:33:14 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, belegdol@gmail.com,
  stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>
Subject: Re: [PATCH] scsi: sd: usb_storage: uas: Access media prior to
 querying device properties
Message-ID: <d8f04b97-f13b-4dbc-af18-2953eebfa4e8@rowland.harvard.edu>
References: <20240213143306.2194237-1-martin.petersen@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213143306.2194237-1-martin.petersen@oracle.com>

On Tue, Feb 13, 2024 at 09:33:06AM -0500, Martin K. Petersen wrote:
> It has been observed that some USB/UAS devices return generic
> properties hardcoded in firmware for mode pages and vital product data
> for a period of time after a device has been discovered. The reported
> properties are either garbage or they do not accurately reflect the
> properties of the physical storage device attached in the case of a
> bridge.

...

> +static void sd_read_block_zero(struct scsi_disk *sdkp)
> +{
> +	unsigned int buf_len = sdkp->device->sector_size;
> +	char *buffer, cmd[10] = { };
> +
> +	buffer = kmalloc(buf_len, GFP_KERNEL);
> +	if (!buffer)
> +		return;
> +
> +	cmd[0] = READ_10;
> +	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
> +	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
> +
> +	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
> +			 SD_TIMEOUT, sdkp->max_retries, NULL);
> +	kfree(buffer);
> +}

Do we still claim to support devices that implement only the 6-byte
commands, not the 10-byte forms?  Or is that now a non-issue?

Alan Stern
