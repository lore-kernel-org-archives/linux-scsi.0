Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E4F288D6;
	Tue, 25 Nov 2025 04:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764045552; cv=none; b=YZnNPHwCp9y3ES05TidrZzQQVeBEw3Cg/5C04Y4KEU3+24KFckQnyC2t+hZPgbTU4mbyQ9Bx8IrU+JsB29RIoPRkYYMttkNP2UbHPe/CnThPaD+VnLa9V7kQEWn3H/ZPYat4M34/8Q8+aQTep7li8oCLs7UMiW4mY67loBxOPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764045552; c=relaxed/simple;
	bh=794hmnjlJcCDuDz4a2Vg2n8HtlfhwZ/VvXdGSdJguF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5T7fuKX09PTqRfZ4u3QV+b1c7WwtckGjZxpUvCbTN77DTuDaq0+jnJm6BIc6rZFxBadIClvYiDQ+DEpPu0FHxIHZ6jtdLfDY3iVnSjHNhpcdY/d1DpmaqJdT8ASOGUK/xx9EX/ccBwWUykmdDOmU/QiPmqJCaAHF2XOwi3Yeyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j73/yas2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j73/yas2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87ACC4CEF1;
	Tue, 25 Nov 2025 04:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764045552;
	bh=794hmnjlJcCDuDz4a2Vg2n8HtlfhwZ/VvXdGSdJguF0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j73/yas2jVAb2ELmWilPFvBqwHyuf5Hj/AJSVh6UdScC7yIadhEyV2WjvxG1ISNay
	 dJCTwn8frhv02yv75bWh0FnkyJrqf2V4fmP1sGT5duX3MqxdQnBJN69HSfDGOwAl67
	 Khm/ctR/RtEuLmaBzsM7QpqIyjNTIySE5ou9hlATkHUQ8y9/lKN1Io25gVOrgbzAFh
	 o64EC+Nft9ugqF82+H9hHBmsjXG5qvJj5sC6+R4M3gnpYFVKzVWijhD7BgMRY/fh5R
	 sbuWpzu/LsJmnIUPQpLQT3Y/xXu4rnU8TRJp00rdh7HuP7WwaqgrR4MTCp3bsEDVb6
	 uUTk+8L6Yx3Kg==
Message-ID: <597e6678-d62f-48d0-8a4d-225d4a6013d8@kernel.org>
Date: Tue, 25 Nov 2025 13:35:00 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] libata: Stop using cmd->budget_token
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 Niklas Cassel <cassel@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20251124182201.737160-1-bvanassche@acm.org>
 <20251124182201.737160-4-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251124182201.737160-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 3:21 AM, Bart Van Assche wrote:
> Since a single hardware queue is used by ATA drivers, the request tag
> uniquely identifies in-flight commands. Stop using the SCSI budget token
> to prepare for no longer allocating a budget token if possible. The
> modified code was introduced by commit 4f1a22ee7b57 ("libata: Improve ATA
> queued command allocation").
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Niklas Cassel <cassel@kernel.org>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

It is very hard to review this without the cover letter and the other patches
to give context.

So as-is, without trying to find where the other patches are, this is a big no
from me: this will break drivers for SAS HBAs that use libsas, and so libata as
their SAT implementation. In this case, the tag of a scsi command request is
the HBA tag, NOT the device tag. So this simply does not work at all.

Maybe you fixed that in other patches of this series. I don't know. If you want
a proper review with context, please send everything to the people from whom
you expect a review.

-- 
Damien Le Moal
Western Digital Research
