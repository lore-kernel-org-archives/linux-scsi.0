Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C531D040B;
	Tue,  5 Nov 2024 09:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730799236; cv=none; b=kkwY5GmijFABe9DDC7tab3NoVqLqo/T3+1xX3O/LZcXBt6qMUEdMdlsLn169uw4v9UmGWY86sdONWPdHH9qzUiNLcot382HlyHqVyd1oTa4tzGN3er4PT2tOZUqgh4mnq23LNcPIT12TNSZCX0wia8osuumWUEae5QDxR47sUKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730799236; c=relaxed/simple;
	bh=22W9nzMcL25HgQOsdfOmLga073kenQrCF15JNenZNe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tvt6omm+saKeKowgAmapcl3KbmbHRVo88p1OutES/uksNeK+zwY3pg+so92QN8FGYAawnhal36IGZunrwmSE3SR8+KgY/wOj9b+lbyz7EDryi9eZNYOpQw5gTJ17w5uDOEJ2B7+x7lqBQ1euSwXny9eHbkIKSFCEzOoOFtOcnjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fx/sZxCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fx/sZxCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1368CC4CECF;
	Tue,  5 Nov 2024 09:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730799235;
	bh=22W9nzMcL25HgQOsdfOmLga073kenQrCF15JNenZNe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fx/sZxCsKqej2maE4ErIgyI8Ra7siyvtDWtTPyRQf2Tb3WSt6pTS79eCb8YC4vtLx
	 NcvYTaHa9s+9zAguh0SVptoG5FwU0/BfItH2HVk92Ha5JA4BLjB42zjcsBjACy1JT8
	 jv1TcGbIVWrDnJC2Uv3m3X+8sRmbp5oiRV5JEp/Iq90jPJS+TngE9Iz0E7MP93bHe5
	 TPue25thADX9R6qZ8WYRCjgGC+yJ/481t4SVvpn6w/Ypjhule7tCwnOtTlAHuT/xrH
	 FM+eVh9OdXf9jr3CBkUpyg0r2Blf0XMCrzkjYizVw24q2xOu24Z9OFiaEZF0puKj9K
	 xblct6aryzlZQ==
Date: Tue, 5 Nov 2024 10:33:51 +0100
From: Niklas Cassel <cassel@kernel.org>
To: yangxingui <yangxingui@huawei.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Yu Kuai <yukuai1@huaweicloud.com>, linux-ide@vger.kernel.org,
	Wenchao Hao <haowenchao22@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] ata: libata: Issue non-NCQ command via EH when NCQ
 commands in-flight
Message-ID: <ZynmfyDA9R-lrW71@ryzen>
References: <20241031140731.224589-4-cassel@kernel.org>
 <20241031140731.224589-6-cassel@kernel.org>
 <baceec65-ad60-f8e5-f417-0316c19a0234@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baceec65-ad60-f8e5-f417-0316c19a0234@huawei.com>

On Mon, Nov 04, 2024 at 12:01:19PM +0800, yangxingui wrote:

(snip)

> After testing, the issues we encountered were resolved.

That is good news :)


> 
> But the kernel prints the following log:
> 
> [246993.392832] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [246993.392839] sas: ata5: end_device-4:0: cmd error handler
> [246993.392855] sas: ata5: end_device-4:0: dev error handler
> [246993.392860] sas: ata6: end_device-4:3: dev error handler
> [246993.392863] sas: ata7: end_device-4:4: dev error handler
> [246993.606491] sas: --- Exit sas_scsi_recover_host: busy: 0 failed:
> 1 tries: 1
> 
> And because the current EH will set the host to the recovery state,
> when we test and execute the smartctl command, it will affect the
> performance of all other disks under the same host.
> 
> Perhaps we can continue to improve the EH mechanism that Wenchao
> tried to do before, and implement EH for a single disk. After a
> single disk enters EH, it may not affect other disks under the same
> host.
> 
> https://lore.kernel.org/linux-scsi/20230901094127.2010873-1-haowenchao2@huawei.com/

That is bad news :(

Considering that this series will currently stall all other disks under
the same host, this series is currently not a viable solution to the
problem that you have reported (NCQ commands can starve out non-NCQ
commands).


Looking at:
https://lore.kernel.org/linux-scsi/20230901094127.2010873-1-haowenchao2@huawei.com/

It appears that a requirement for Wenchao's series to land,
is that Hannes's EH rework series:
https://lore.kernel.org/linux-scsi/20231023092837.33786-1-hare@suse.de/
lands first.


Unless these two SCSI series get merged first, it's illogical to carry this
increased complexity in libata.

If these two SCSI series ever get merged, then the series in $subject would
be a viable solution to the problem, and the extra complexity would be
justified.


Kind regards,
Niklas
