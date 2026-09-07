Received: from mta1.migadu.com (out-87.mta1.migadu.com [95.215.58.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4042619B5A3
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 07:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765186; cv=none; b=mqhgabhAplS9K4bQB6C5FVdmZFTynFi74Vk7BCVIx6p3GLmjKoLznnbTxTW5FCDBUobi8l9uSxrl5Jh85+iPj2cKzHfLZTWdHX/y8+YLckPLuwaTP47HYK79gyXmTMdCtWtfW/hAlpjgwVTFsBnFobcWiFtxy+s0ngw0n9ICNzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765186; c=relaxed/simple;
	bh=qe4Pb3BO2xwI8MHyMori99QTmbT0MeQ2RK5Red8Hhn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UV5JrvOsOe14fAtxE/zUZhN61xooz3G2hH9SO29/PgkqNROuw+J6yP2nKBT7cHQDQSHXeaOmAvuQ0fUQcUMctEVdzwrywRYNPoZSnWU2YGuRC/BxohSXPUJmmX+wWoqoaJpgfF+dSAZ50a+hM9967Hx8dOCOXJZTpBcsG5KY8Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q7eJ5i3d; arc=none smtp.client-ip=95.215.58.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q7eJ5i3d"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qe4Pb3BO2xwI8MHyMori99QTmbT0MeQ2RK5Red8Hhn4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788765183; v=1; x=1789369983;
 b=Q7eJ5i3d+ueK/UdYAEE2vLkE89xLa30JnSvRlKdWTx1o6D0cTgyquLt/UgBIq4f5keN0E8ma
 gMDBM5kaDPLCxcL1Gzk1z3rjY7X+fEycvM/+cxlM/RroHJ16nKX5uoeDTL3AIvNML6trN60oWtz
 OS/RuYpnffg7DAa9NlOC/iwM=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 1a82f737730640e3;
	Mon, 07 Sep 2026 07:13:03 +0000
X-Mizu-Trace-ID: 1a82f737730640e3
X-Migadu-Flow: FLOW_OUT
Message-ID: <09e0a759-8386-46c8-8379-1d3ae31598cd@linux.dev>
Date: Mon, 7 Sep 2026 08:12:58 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: mvsas: add suspend/resume support
To: FVMA <fvma@protonmail.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <zoyjysrYCqU3F2-p-3UZRqGS1J1LpdjECnhvTzszKX_E4ze5T6JfviETkHg7yj6vJy_X4RaIUe3GEBH23wKKbUOuKyPm7SUur08jDrWyVdE=@protonmail.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <zoyjysrYCqU3F2-p-3UZRqGS1J1LpdjECnhvTzszKX_E4ze5T6JfviETkHg7yj6vJy_X4RaIUe3GEBH23wKKbUOuKyPm7SUur08jDrWyVdE=@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/26 23:12, FVMA wrote:
> The driver has no PM callbacks. After a system suspend the controller 
> returns with its registers at reset values while the driver state 
> assumes a configured chip, so the first command after resume times out 
> and libsas error handling wedges the host.
> 
> Add dev_pm_ops. On suspend, quiesce libsas with sas_suspend_ha(), mask 
> controller interrupts, drain the IRQ and the tasklet, and cancel pending 
> deferred phy events. On resume, reset the ring indices and the STP 
> register set bookkeeping that chip_init() reinitialises in hardware, run 
> chip_init(), re-enable interrupts, report the attached phys through 
> mvs_scan_start() and hand the host back to libsas with sas_resume_ha().
> 
> Signed-off-by: Francois <fvma@protonmail.com <mailto:fvma@protonmail.com>>
> Assisted-by: Claude:claude-fable-5-1
> ---
> Compile-tested against v7.1.13 and current mainline; not yet exercised
> on hardware (88SE9485). 

What is your motivation in posting this change?

You don't even have access to the relevant HW.

