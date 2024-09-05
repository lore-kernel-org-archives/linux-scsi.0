Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C4E4C6E
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 00:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725496545; cv=none; b=XQK6IJM6w33Cis134RA+2cwx2MtulR1XAZ27A9o2/46eDn4bP+D4j8NMyKS6OH9Dx8oRrzWzw47V1tNSRdd2LqGczy5ykV3FrzCuT1hOrwnj0XAYWo/3rJRpOcZohPrqNvk/89kuxs4Uyc2ZYEjUMXegwNTzE4hh3Ei/egYToHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725496545; c=relaxed/simple;
	bh=Wbi9rBQe1lt+aE5QkMt/uusLTP1uewEBk/8cPKWHy64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bc604TTIIRlwIwseqzd+XBTHY8jwCU5ZsHVHtFlrx5AO92Ibk2/uRwOl9EmJWCOecHRAhmF3MrQpdWYx3q4ctJZ8UA3ygU2ooUMgvlhMwBw+YE3TK6GkZSkYa6dz/UdFBOoQ7jFC40AdQjiRY3uF/DmVLKCoHL7OA4f8Xg7xfdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYwS7vXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYwS7vXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BF0C4CEC2;
	Thu,  5 Sep 2024 00:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725496545;
	bh=Wbi9rBQe1lt+aE5QkMt/uusLTP1uewEBk/8cPKWHy64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aYwS7vXstzUZKO4i17CkoNfc+z3AuaoiJjvNw4tdukwMGBgGfYAeZPLj7PU/TJQ3R
	 gauc0f1q/Qwe1aBmVhE4UutJS0ZOSJxnE6qLiElUXOeMeOr73Y0kFPTAp9aLRazSPS
	 KKvlWp2OdlyS6aSz8NJOdNkQ6O54dtu9irjIpPFDDT9MynOmTVJe4jomRfVAXdD1S+
	 Rh/xI4jZgfTLarqLzlTNyy+4snAO30z7z5E6oslH6JMraBCxkhksuqprUQvkqt6RYJ
	 maalq6NKJKIyhWoUfQp0W7xBP6oXDgBjK7UfC/hKCMTzu1tMKShoiJFqY0auAbIuIr
	 lVBU8oMPd5fxQ==
Message-ID: <da8723a0-a98b-46c1-bca1-988be93f986b@kernel.org>
Date: Thu, 5 Sep 2024 09:35:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] sd: Retry START STOP UNIT commands
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240904210304.2947789-1-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240904210304.2947789-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/09/05 6:03, Bart Van Assche wrote:
> During system resume, sd_start_stop_device() submits a START STOP UNIT
> command to the SCSI device that is being resumed. That command is not
> retried in case of a unit attention and hence may fail. An example:
> 
> [16575.983359] sd 0:0:0:3: [sdd] Starting disk
> [16575.983693] sd 0:0:0:3: [sdd] Start/Stop Unit failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
> [16575.983712] sd 0:0:0:3: [sdd] Sense Key : 0x6
> [16575.983730] sd 0:0:0:3: [sdd] ASC=0x29 ASCQ=0x0
> [16575.983738] sd 0:0:0:3: PM: dpm_run_callback(): scsi_bus_resume+0x0/0xa0 returns -5
> [16575.983783] sd 0:0:0:3: PM: failed to resume async: error -5
> 
> Make the SCSI core retry the START STOP UNIT command if the device
> reports that it has been powered on or that it has been reset.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

