Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9964BD79C
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885741; cv=none; b=JSlQA68e6JmH3hP5Xz939cpByST4gPH+Z5cfBZpCh94RXnbGT3pJCDwJo3iPvQiS1Dnee4jD0+sLOipd0dvDQDbU+/nU3l9yDJi42v5Zw/9C1RdqNQJ+cbYc+WXfKnkrxeTy7dsp07c1prCHt3pk1B/JIpg4Qv992UR9LJdzTQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885741; c=relaxed/simple;
	bh=+bsGtM9Nb3bD/LMo9a7RrIT0Sv8TXeglP9/638efe4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SLl/uTT9+5DEwlkWlqy4E2fm99oDEMYx7nF7E+sharvZ8lxw6+gv618QIV251HjoqamzGtYkphR5MzGBa2kEJwqKPa3WbTZpP/HVuitWUhAWzW8I8JfPwSiE45ZzIZgKTcfwG0qs3CpQ33rOn7erZjrqk7XGDlIG/Gh7RPlOhVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJ4vU14S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJ4vU14S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6351F000FF;
	Tue, 13 Oct 2026 10:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885740;
	bh=wieUGn8dR31i/fHkMsJ7Yszsooqx2K2xQCuasWu31og=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CJ4vU14S5gwtaUhGpNcYmO28zODG8fGYHkIu9PCdc7CXP5Mz+dwETt+q2rtf3JRk+
	 3lbTBxTrOb0+wzsqTZ9BWFLfY8gMWO6yIMz5ndWtOOItX5g4JzuDfMNuu9IcDSnqDN
	 HZIaSaJsagbZh/p+ICN+LQ7Ti3ji500roARZi0BN8fAZNjK2/S/AZX+kM+T4Y3FCPT
	 QvpE8aWmVCVIdP+Vk6muuX6QsvbOZEs9bAIgWHDHtHiR2VO6/8/AUehPgsyKwwdiaX
	 /gZPI6GtgD99fCtKX+p13YIuV6TVNsuYP9L/LnR9B1Q9JJVlMvxqGkmy+kGNv94UgY
	 RLTXIwYsr6eHQ==
Message-ID: <50facde8-ea4e-41bd-8167-2cb7e185ca46@kernel.org>
Date: Tue, 13 Oct 2026 12:02:17 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/5] scsi: core: Add scsi_update_inquiry_data() for
 updating INQUIRY data
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James.Bottomley@HansenPartnership.com, Hannes Reinecke <hare@suse.de>,
 Bart Van Assche <bvanassche@acm.org>, krishna.kant@purestorage.com,
 Hannes Reinecke <hare@kernel.org>
References: <20261012210511.16061-1-brian@purestorage.com>
 <20261012210511.16061-3-brian@purestorage.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261012210511.16061-3-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/12 23:05, Brian Bunker wrote:
> +	/*
> +	 * Check if this is an ATA device (SATA emulation layer).
> +	 * ATA devices need allow_restart set to work around SATL power
> +	 * management specifications.
> +	 */
> +	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
> +		sdev->is_ata = 1;
> +		sdev->allow_restart = 1;
> +	} else
> +		sdev->is_ata = 0;

Missing the curly brackets around the else.


-- 
Damien Le Moal
Western Digital Research
