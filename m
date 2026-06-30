Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE640D56E;
	Tue, 30 Jun 2026 00:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778762; cv=none; b=AfMndcsMaihkIeeijLHLV5XtHztw5JpUdwQTxTrKnfedU2VE5dtBOycpKAVvEm3Rc3cs6fDeeg3kdu8S5Jk5SxB/1ePIGb3M9gdo3S2GifmwQVWAV+x40fB9sE9L88b6ccTqaEsKgGgeSoXVbi6boyaEQFG5UDBhlfjeSi9kJZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778762; c=relaxed/simple;
	bh=csi7AsxAN0DYEvzF9fOih+0A5ukF8JnJ07Hbt2F/qo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofrcaUtTm71Mv191LarXvhJZmzNjbUx4kAZH4wZSxC1bhzd7PkAZ0TLXyQ8ItdSpSPFeImp2tXwnEH2Jj86zUn2KxPufSex2chvuBfMQtovF6Xo4bKB0SOMSRA0ZQn304rAxi2TJDLzbxN0nL5pBPazNjKHU3PsOHkUX63lgH7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlI+iCBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlI+iCBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1701F000E9;
	Tue, 30 Jun 2026 00:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782778761;
	bh=LBEehFIWxZkQUhN9j6hIcOBBY4oYxR+BNVTiz0BEYbM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IlI+iCBlg81brz3/NAYgGHy+AfAss8TuGCESYrGd56d+3O/9DevoFqAo4J1qpAWR7
	 mRHkkwFOsPLf2S9FMfPKMvTTFYj4vKhVuuvqbK1O/igHoTGOMIKCBowDcSShhn2Y3T
	 WG+u0MolqtP+Pm1HLMRWkEZm2yns3oit968S+HfbQg6stws4gE6SIL7SDUVEA/k0Sg
	 s24Y79eCW85R4H9/09cQ2Wj8j/oXxnmJxjis528SfTtQyZTb6A4NbsYi3g2l1Vi5SD
	 w73Qt0sxCZLw0wle+SV0MGBsqoDFI9SEgRETMq9bVM8wl2dj9yARvml4j30hEYowtl
	 0BDSFzgQYYL+A==
Message-ID: <44fe243e-b5ee-484b-a760-9269bb8fe816@kernel.org>
Date: Tue, 30 Jun 2026 09:19:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
To: Louis Sautier <sautier.louis@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Guenter Roeck <linux@roeck-us.net>, MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-3-sautier.louis@gmail.com>
 <93542109-2101-4d62-aae4-bbf058029663@kernel.org>
 <airk3Os03wPV0rvW@localhost>
 <fdea1a8b-d631-43d8-bcf0-1c79e635782c@kernel.org>
 <ajkaf0aa0TWXdRZW@localhost>
 <841e8ff7-12db-4ca4-aaa5-fb8accfc9df0@kernel.org>
 <akMKIk8JN8REuYVB@localhost>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <akMKIk8JN8REuYVB@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/30/26 09:13, Louis Sautier wrote:
> On Mon, 22 Jun 2026 20:28:48 +0900, Damien Le Moal wrote:
>> I saw only patch 1/2... I was waiting for the new version of the full series.
> 
> Hi again Damien,
> 
> The whole series is there, including 2/2. I sent it all on June 13:
> https://lore.kernel.org/linux-hwmon/20260613023833.3163507-3-sautier.louis@gmail.com/

If you want me to review, address to me all patches. I only got 1/2 which I had
already reviewed.

-- 
Damien Le Moal
Western Digital Research
