Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3EC355057
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 09:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328749; cv=none; b=FMRk6cSE1j2wubglcNChYVeIC4jLl5TVlmyG8cpO4l7eCBL7XGCIRIQZ9pcLiGsMWAT5Z4KwQ/tBV0kBOlDzdpzeB8+eOIU9BY4iWe5kwX9SiNhvCGHOjS0dQ9lDfG9y+3VstXoDVrO0pls7qHJ2yf7eb56FntghttsaWj5n2Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328749; c=relaxed/simple;
	bh=SY9WECA+AiZ6IkpL77MOkT4pSdqOzr+1CGpRAtdNR14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J91C1PATCGe7FQhK6dLQp0Ov7+x1B0/bc+orbc95SwfXWAuG45oJ9KbDQog153WEJjTxHzx33CTCUE5eeYH4R+ydy0lIJ2CRj7Cud2BLGb5h1VjRmAZZYo5mwEc9LYdfsc/hPv9UtjzxHiggVxejA7b/uFiXAwlBfy6KhLnpjhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JQ/hPHP6; arc=none smtp.client-ip=91.218.175.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JQ/hPHP6"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SY9WECA+AiZ6IkpL77MOkT4pSdqOzr+1CGpRAtdNR14=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790328745; v=1; x=1790933545;
 b=JQ/hPHP6K9oZHQHdiQV7PgkZhQuiAoaQ8BvEbt500i6nQFpZnGcdzJAxltQRLi9ae7I5p8rz
 lfZipL8rmO9jV/atZax182G82+GUl7hdj50nz7EuDFZtL8HKxE4TuUXQhXCtEFJz7AkLJtF0TJA
 04CtMlLjwFa/v7uNXvOnAB2Q=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 7ff60f82c51c975e;
	Fri, 25 Sep 2026 09:32:25 +0000
X-Mizu-Trace-ID: 7ff60f82c51c975e
X-Migadu-Flow: FLOW_OUT
Message-ID: <76a43045-798d-4521-8a27-304b4d923236@linux.dev>
Date: Fri, 25 Sep 2026 10:32:24 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/10] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260921154015.2971990-12-cassel@kernel.org>
 <20260921154015.2971990-21-cassel@kernel.org>
 <3049af11-b93e-4849-8cf6-463a27792ae5@linux.dev> <arUFEnJj0BX_gFQW@ryzen>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <arUFEnJj0BX_gFQW@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 12:10, Niklas Cassel wrote:
> It does not have to be skipped: SBC-6 4.7.4.6.2 allows a device to map a
> deallocated LBA at any time, and resp_write_dt0() and resp_write_scat()
> also call map_region() without looking at the result, so I will keep it
> unconditional.

Maybe you comment on this in map_region()
