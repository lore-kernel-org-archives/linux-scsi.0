Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C61246778
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 03:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788753122; cv=none; b=GzOe+iMhstRWDZWK3GDHBl/K08cF23K3mvDX015L6b5G5Me67jUVeim8OpgVq2cK33+HBLUZDG6JjIQh36eP7YnWqWyppGsWwsXMIscvs8jMsF2Q9XuAv6AwSi4bocSpML5AwTypKI1Nv7CdSzfFqLslzA74jpDeiYDGITmCeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788753122; c=relaxed/simple;
	bh=yp4FHX9/rvm5dTuVbDnt1LOM/Qbqbx+JJ9Za4QyHiZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=s+Z6pd6L6vV8aNjijwWzUMYcikaMyftcpF3BCTJIQ61Yoz3Xs2rnHpDzc/4GfwB9uUiUylAgYepklsSkLIHX5hymGeRfVwpIDLouhVprJaTdc7LZNsuc8Hfm18xDdjxvHMDM26+HN2Lei+nZ8BRsiQ2B+1g2OSej09Tx0NxwtH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndoy/NEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndoy/NEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21EC1F00A3A;
	Mon,  7 Sep 2026 03:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788753121;
	bh=8JYF0OjDd7Nxj6OZBCxfz9MtDUbyF2JTT0xcuCJ4MW4=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=ndoy/NEWkHbS/Ik7W/43Ov7IF+HsPnH4En78DB2NHAmsxVWmDojVaK82U2Cz6N1MI
	 sVq/9fpMYmLk/OJVht0v4C9H7oViwP8Ric4HpI9HSjLzi0PyOS5GTsfcS2tWRwmsUn
	 5agaRjz0UYYT4cI+xJV547A5TifsQuj1IeIpIIpYzptvi/iuzqVNtQs6y9JgAB8gOc
	 qadsJXKFmDBcW/iTHgNm2pPtKhPfGbPjK9J9FBaBL3Pg0xmsaDwOEBdWDh0SF3Qp4w
	 rycanK2N7nFWUZaneXzds58WAQBYh5+Ly5KqwR4RVX7PJAxA53DY0/rbpsc8LhtdO4
	 RrHlo1qxAKm1g==
Message-ID: <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
Date: Mon, 7 Sep 2026 12:51:59 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/40] scsi: define all additional sense codes and
 their qualifiers
To: linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-2-dlemoal@kernel.org>
 <20260907031437.87FC41F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260907031437.87FC41F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/7/26 12:14, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] The newly introduced `scsi_sense_code` enum injects hundreds of generic, un-prefixed identifiers into the global namespace.
> --
> 
> commit 483fa6eeda05c51714847f3283212cc3d768cf57
> Author: Damien Le Moal <dlemoal@kernel.org>
> 
> scsi: define all additional sense codes and their qualifiers
> 
> Introduce include/scsi/scsi_sense.h to define all existing additional
> sense codes and their combinations with additional sense code qualifiers.
> The sense key macro definitions in include/scsi/scsi_proto.h are also
> moved into this new file, and scsi_sense.h is included in scsi_proto.h.
> 
>> diff --git a/include/scsi/scsi_sense.h b/include/scsi/scsi_sense.h
>> new file mode 100644
>> index 0000000000000..e668ac1c2302c
>> --- /dev/null
>> +++ b/include/scsi/scsi_sense.h
> [ ... ]
>> +enum scsi_sense_code {
>> +	ASC(NO_ADDITIONAL_SENSE_INFORMATION,			0x00),
>> +	FILEMARK_DETECTED					= 0x0001,
> [ ... ]
>> +	ASC(WARNING,						0x0B),
> 
> [Severity: Low]
> Does defining scsi_sense_code this way inject generic, un-prefixed
> identifiers like WARNING and WRITE_ERROR into the global namespace?
> 
> Could this cause symbol collisions since scsi_sense.h is widely included
> through scsi_proto.h?

Martin, James,

This is a valid concern which I had when writing scsi_sense.h. But so far,
building with allyesconfig/allmodconfig did not great any issue. But I can
change these names if you think it is better to avoid issues going forward.

-- 
Damien Le Moal
Western Digital Research
