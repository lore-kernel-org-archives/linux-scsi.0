Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DDD2FFF90
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788747305; cv=none; b=FBTWbHv0SGF8kwEW6hOz4ODW7vSqvbhDAo3uqbdqy30TIbgR9orL8oMr+lvMX99neC6yrXHr2AVrA5kr/yVF8yk1Jg9Zvez/4a67S1Ghn1QnwJfbaL3mCBb+/WEr0QjPpcK1RtLlw+3nRY6JlARzd/Dt8h5ZDImVNBQww2qjBMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788747305; c=relaxed/simple;
	bh=Mg+UqZZlGv8SKX/zevbWsOCyzPa7w+DdEBZigYoyg+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bILsXYy4anJZkPMmSTf/U/rE//hwieC0frMAQThk1tnPMMMdMdBWar2codbk3AZAR5oKfMciNV/BlOqG+x4tw0UhKxFB0SBCs+sOdR/WCJvfQ3GrtozzOJac6SgwY9rfsfPCVskm/FKiyRRywt4FGhW5ZJPsWooyvbG1u3q+LJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSsonKGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSsonKGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD1D1F00A3A;
	Mon,  7 Sep 2026 02:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788747303;
	bh=O2uGW9ft/yycqdP52Osc5/y17yW/dea5VOZpoHRvNx4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fSsonKGzcLQuJ+P4xcHah9XtPjKcmdVNkPY6vWZcs3trEuYC9pNYWCkN2diJ4c8ZW
	 98aEJQFrst6Wd2NGrZBtEIycaV5ABf6kF4QuU2g1rjr/nJOQoUazvhzFILXnbi89Zf
	 V3ta9/VWITiEtHef+JtC+feUyo0eBZ+GWPpsYYVja8VQdE3ac2b5Ve06ml1DaKwRON
	 OvWIHKSVZf9pqu5b/GrytiNyuXdhQQHirER8t7YJurMiroT0Iu7joSLRD519jMMJlZ
	 nJCVKmoOJESCqB9jKk7gbs5FbuNLTBoCyqNdKc4jMjKyiwrKp5ALYjsm033pEkZ6w/
	 fpMnS9DZkkqmQ==
Message-ID: <b01217a5-fb1f-4d43-accb-53f7674976b5@kernel.org>
Date: Mon, 7 Sep 2026 11:15:01 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: pm80xx: Fix the use_msix, use_tasklet and read_wwn
 parameter descriptions
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
References: <20260906170925.2524-1-kmehltretter@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260906170925.2524-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/7/26 02:09, Karl Mehltretter wrote:
> The MODULE_PARM_DESC() lines of use_msix, use_tasklet and read_wwn all
> name a parameter zoned, which does not exist, and the use_tasklet one
> repeats the use_msix text. modinfo shows three "zoned" entries and no
> description for the real parameters.
> 
> Name the right parameters and describe use_tasklet.
> 
> Fixes: efa1fca45082 ("scsi: pm8001: Remove PM8001_USE_MSIX")
> Fixes: 205430290ad0 ("scsi: pm8001: Remove PM8001_USE_TASKLET")
> Fixes: 80975adc79dd ("scsi: pm8001: Remove PM8001_READ_VPD")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
