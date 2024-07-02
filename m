Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56214A9D;
	Tue,  2 Jul 2024 03:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719891234; cv=none; b=AYdykZFGnrZqwqHkfeHrhJmhM/oyinRujhimDNRg47ZJomYFYzqnU4cejFpSQVDMM8BaCt/oPEtSHudBNYRhQk+tANbC8I4eZDKsHiAxxiAZobgx0umqBmg33mA91b2htQ8e9Bbsyu2FAG2/GFOHVE2rghAAIQxSFt3tK6LGKrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719891234; c=relaxed/simple;
	bh=hmeQcQEOKaJyYXLrDHih6u58p1v/aBI2HR0IGvqFP70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DaZ2HPtkkhrbcX0SpLaq6O8AmjpLNImwGLrl7xVTNspUhxnFSai8TekD6eTSC/ItA3ut8EGz+LZlKsoK6pCl9dyF+ff8HgbVPxlNvnEIPPL3f563kTlV1pAnRYVWHtlCDZSm3PJHRs12PsacBpZE6XS7VCTvJ+qd1+UQ62fEC+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W3Dn8c17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W3Dn8c17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E32DC116B1;
	Tue,  2 Jul 2024 03:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719891234;
	bh=hmeQcQEOKaJyYXLrDHih6u58p1v/aBI2HR0IGvqFP70=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W3Dn8c173+tf0Tf/TGLyQILi5+2l2rmH84S/v8lNxU5hAHErtT41hSIkeNxn6YR27
	 kEVN8uxCtqX389+yqMew3y28CX5l9a523K6zuY3SnwjENWvvrM6yoaxR6ZfE2sLIo8
	 RB2Qz0FmsQ3ZCfR9zDJ9Cdt2UQYJaV+PC+dTpwxtjvT4sdl1LcGRLqc64FtLJDEGyk
	 g98VLn2aJYMWjpw5Nuguf31/8ayubiRsMmQkUxys9yK3hSUQIMzLKF7jWgKJnxHK0p
	 SDQt3u9ktvoOBDWfVyggknOQctTRcMJ7Nv3GggfItkeEk5K7Jp/fzKVK7UoAZQsc4G
	 f2OXgfToEWAZg==
Message-ID: <cde0a2da-fae1-4f9f-b67f-f3906fc5cce6@kernel.org>
Date: Tue, 2 Jul 2024 12:33:52 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: sd: remove some redundant initialization code
To: Haoqian He <haoqian.he@smartx.com>, Christoph Hellwig
 <hch@infradead.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fengli@smartx.com
References: <20240702030118.2198570-1-haoqian.he@smartx.com>
 <20240702030118.2198570-4-haoqian.he@smartx.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240702030118.2198570-4-haoqian.he@smartx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/2/24 12:01, Haoqian He wrote:
> Since the memory allocated by kzalloc for sdkp has been
> initialized to 0, the code that initializes some sdkp
> fields to 0 is no longer needed.
> 
> Signed-off-by: Haoqian He <haoqian.he@smartx.com>
> Signed-off-by: Li Feng <fengli@smartx.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

