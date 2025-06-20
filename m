Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2342530E85C
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 07:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750403790; cv=none; b=u2EIO3DIyRaTJ0+JC90QzKn7PGiWwoqZ0QZKdmiRrShmvw4DowYsg0x0BbgDuzzPdn+eXPgP3Xrw2LZCDzlA/Ynhf42In+d3SXVKtsLkYDMh6otF0TKvCBW5gwpx8WigEeLr56pkcevRs0iFIov7yw+pFvMo/jUsi8xI6Ow3/Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750403790; c=relaxed/simple;
	bh=UknbYEp+kDVI/VowfzuessqCmOiu2Fud3ojd63Jy4Ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rdfi8YB483ZLOaIWL3GRe/2WGxOaTe5AXITpRlSFiIKhwpcdRb/3DNHbxOK8b94JN58AQ3bRJSITAnajNrOnFTpLfLZo+Kn+URVmGTQA5yaJMwRm6zD5inbphd56PcZYo9vgFMVVjksAoAMnN11TUx9vQ8VdaZInEs12yCVDSeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwrIKz19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwrIKz19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B83FC4CEE3;
	Fri, 20 Jun 2025 07:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750403790;
	bh=UknbYEp+kDVI/VowfzuessqCmOiu2Fud3ojd63Jy4Ao=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RwrIKz19MU0rQZb633rAyUDdUHUI5QG6FGZbf1sZMY58EONMwcGuf25hU1LG2Ekr4
	 X/azNmkpfClKmDc0smQGGl+VPcI0A5kmTeBsEiRpoRu+TNoPHGuR8ZdF2/6qZ/4ECr
	 RMNByET+YIoKXKbnTRBQjD4PgH3u3fZt6RvCZr8M+Utq2z0xK55Hu3Qj/WQak5NfHH
	 3RsV9dtnm/mbEee5nK48V6nfnr1ZRFbBYLzTTT4uSW8eUKz73Lpk91hqj8Ox4OK30h
	 H9bupX/xeXAkP3kKTl6S09Zoi7E6ZtS/gSZDOLz6ShC3tg8NUXrz+f2GCMrF0hD4mi
	 2yYXHf7BblSQQ==
Message-ID: <f2b0e569-1335-430c-8147-9179caced2a4@kernel.org>
Date: Fri, 20 Jun 2025 16:16:27 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: fix kernel-doc issues in mpi3mr_app.c
To: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250620065628.3348589-1-rdunlap@infradead.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250620065628.3348589-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/20/25 15:56, Randy Dunlap wrote:
> Fix all kernel-doc problems in mpi3mr_app.c:
> 
> mpi3mr_app.c:809: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_hdb'
> mpi3mr_app.c:836: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_all_hdb'
> mpi3mr_app.c:3395: warning: No description found for return value of 'sas_ncq_prio_supported_show'
> mpi3mr_app.c:3413: warning: No description found for return value of 'sas_ncq_prio_enable_show'
> 
> Fixes: scsi: mpi3mr: HDB allocation and posting for hardware and firmware buffers ("X")

Missing the commit ID here and the patch title should be enclosed in ("").

> Fixes: d8d08d1638ce ("scsi: mpi3mr: Trigger support")
> Fixes: 90e6f08915ec ("scsi: mpi3mr: Fix ATA NCQ priority support")
> 

I do not think that you need the blank line here.

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
> Cc: mpi3mr-linuxdrv.pdl@broadcom.com
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

With these nits fixed, looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
