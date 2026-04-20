Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5692F5A13
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 16:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776703890; cv=none; b=PcAROcaaVDvuV5HpH5PeTey38dlhqtDtFNarnvQgM9fdgyhOSTdgof07f5WB+tWoh5iZWktMOtJYVmiJMXOwL0ufSdDKkPsgb35+ICGJThexjWJhHXphkGczwDNKpGi6R0I3e7GvJ0J4R2PI1uR0smmWO/nGA6DhVl+AcWzowds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776703890; c=relaxed/simple;
	bh=fMTkVtETBxofMf2sQEI2W7I2qQXdJ08SNERN9JJM+Kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=c/Q3TxEGWpioJj7fz0aCm5y+FY/a6sGDbgWeYGFDmLB/cHsG7Y79PUKqL8kolq49ZMEQddYV60tLmel96j5rHTKlR/54qg9ZemAbksis3QOHcBRQZeazB/yNTHWryiR5vbihhaDUog9E25ehtt2Duvi1X61obvsOsLshtsfBd7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=URHfcdeW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="URHfcdeW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fzs2S2nsvz1XM6Jf;
	Mon, 20 Apr 2026 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776703883; x=1779295884; bh=Bnex+1RTo3Eptes/lVVmUsIe
	qfbCHfN2vHOGnI7nV14=; b=URHfcdeWJ6q+k9QY7tcSc40nlOGl3hsabjVTbsPv
	hwWjsH6+cL28jkicaMx3QsppHjHWhw3mrp1DAZOz1HIZ1mLsSql8w0VBkIk5Wgwm
	GwOylKcSEVE+VfZlhzIQ6nURny2mciOT3W8uYkcaOjr1w4sFCZitWN5NpqqazSTj
	ufb8KnzYmynVr08I6Nwtt0Uihb/1jj0MTW42ApMvIzKHir+2Pu7j6ifyxKmipFoQ
	S5ZAdECyd4G6mPpMvY0mKkUKBiP0hP7zasoZ3CIabYBbnOKAEZrLKhGawRgnIXbv
	L6Aev3a66WToRQmNfGiu7DFZ85U5PM26JSJqGdN4DVP2dQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yfp_JgZi8mnk; Mon, 20 Apr 2026 16:51:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fzs2K3bdZz1XM6JR;
	Mon, 20 Apr 2026 16:51:21 +0000 (UTC)
Message-ID: <0ad1fbe4-2452-4c03-af24-47255021b751@acm.org>
Date: Mon, 20 Apr 2026 09:51:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: Support scsi_devices without a device wide
 limit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
 stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-4-michael.christie@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260417230751.117836-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/17/26 3:57 PM, Mike Christie wrote:
> +#define SCSI_UNLIMITED_CMD_PER_LUN	-1
>   	/*
>   	 * True if this host adapter can make good use of linked commands.
>   	 * This will allow more than one command to be queued to a given
> @@ -451,6 +452,9 @@ struct scsi_host_template {
>   	 * command block per lun, 2 for two, etc.  Do not set this to 0.
>   	 * You should make sure that the host adapter will do the right thing
>   	 * before you try setting this above 1.
> +	 *
> +	 * Adapters that do not have a device limit can set this to
> +	 * SCSI_UNLIMITED_CMD_PER_LUN.
>   	 */
>   	short cmd_per_lun;

Please make sure that SCSI_UNLIMITED_CMD_PER_LUN has type "short" 
instead of "int". Otherwise comparisons like "shost->cmd_per_lun !=
SCSI_UNLIMITED_CMD_PER_LUN" will trigger a conversion from "short" to
"int" for "shost->cmd_per_lun" before the actual conversion happens. I
don't think that's what we want ...

Thanks,

Bart.
