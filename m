Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE333CFF6C;
	Wed, 27 May 2026 08:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779869524; cv=none; b=iJUgh8nRt7oFo0pNnajEKVmS3v7hEuPuT6WvkkzdDbQMOHG2WqF2Ey/0xUhlZFE+XAntj7dFgb/oeao863LlUuegfwSU2MZC7PtksE/QQCqtGRZxpZMijKLEAe7bslS20u4lZNfpQCi1NcUIZLyXiZhxK6uaTw357oZDM+YBiIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779869524; c=relaxed/simple;
	bh=CrjsZ89NLp/qgajRLSW9INu/xbfuVCAub2HUqhME3do=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJa2LUtQ7giQAwWOTbSNWMUfeQfZr6ayv7bpRJX97+V2+wujlDZrQiQLutQtp3QxZWuJ+YaMyD9JeDob/nP9sH7EMaCJOzruJPlTOwwY9LbVjQXFZscOyIClfvEYU83cGutbehkglhul/B/K5Xvg63aq020hChgrSkIBSvsMZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkslF6Ms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkslF6Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DB01F00A3A;
	Wed, 27 May 2026 08:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779869523;
	bh=XF738AUc4MqY++N0qZJs3qwXniGKZajtAh9K82WHq8I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XkslF6MshykwuFiw8ug1amzS7XgpyzSqn4x+Vu8x9ltaDoDzlM0hzH3lQaPMdyg12
	 YdEdJmyJBdaPk3x9qbMnBi6OsbOSCDq6O89Oh6iXsV+0oYwvyZz9Q2ln7+68I79yb+
	 fD3uSwG2aUlkVqgLqoOCcSRYE7lkf3diTFq2euL6lHMM3NS328px5/Nkzix/rUFsrv
	 nIUZQJEIvY54IlI1u7NkI2DC5RVy79BEVwADvs2qiLs6w0IwQZDSdfrW5IAfrGxfQ6
	 XTEiWuYfR9c9mN0IbvEeqw2KH6ZZEo2hCnU3/D6bq6qhqgp9ZToleHLaX5s71el7Aa
	 u6qMOj3trm1Gg==
Message-ID: <42a4627a-e4f6-4bbd-89eb-559d1f969053@kernel.org>
Date: Wed, 27 May 2026 17:11:59 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/8] ata: pata_budda: Use named initializer for
 zorro_device_id
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-kernel@vger.kernel.org,
 "Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
 "Christian A. Ehrhardt" <lk@c--e.de>, linux-scsi@vger.kernel.org
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
 <a20f52aeee9dfcacfaea43ff280fa1867878cbbe.1779803053.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a20f52aeee9dfcacfaea43ff280fa1867878cbbe.1779803053.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/26/26 11:17 PM, Uwe Kleine-König (The Capable Hub) wrote:
> Using named initializers is more explicit and thus easier to parse for a
> human.
> 
> It's also more robust to changes in the struct definition. This robustness
> is relevant for a planned change to struct zorro_device_id that replaces
> .driver_data by an anonymous union.
> 
> This change doesn't introduce changes to the compiled zorro_device_id
> array.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
