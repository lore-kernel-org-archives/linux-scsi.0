Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781198;
	b=XFpaF5P+RtL5I6z9RWxqOSY35UPtr7k4qZAiXl+lRua/zdakXqTTjtJL0aFsp8cR/AMH
	 Th4ZfUvWY3hZi1fFocbNtOs6Jt8bghnqyeAZT47sZ/XSBIm6JI+Plu1U66LAcdxBlh8lj
	 tuqYT0/MkyTAF//OIsGkh36esfdZdmwHsXr51UQ0FMaSB3Ph9wkX86MPzg3Ve5wrhRGYk
	 2VGjZvw/QIENRP20Y5ArKZtHfuIhnUE6hCpGnS7OjB2YOoOvX5Bl25oMosHtYoAJdh4y0
	 UHD3ox6E6VQz0IUWr7mp4Tz1DOF+v50Bb/tDGs4cLkUT+It7m+jQnytMF+G08eTTPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781198;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=56rUaLkKjtX6ZB9UH5r1QD7LWnj20Z4nDU5bdsBgB2w=;
	b=NZ6mQdyVqr9b3Rsgf1ORiQ95I6zKho10CxwWgOmjonCBbpfxdPrfSrbFeX7Q1vNjNKpi
	 VC5km7Be0nSDz1nWSxnLLpTpGVXQiMqBzLJ5saIn4dVt8GIFKA27gkMg4mFSsloQvp6Lc
	 e0Om91ccfSngOuydWQheDfSJ2f25UM46MU9aPiCCjzAzD4CLlJEzzYF2wd2BDutHxXU8E
	 9OHmMKHpgaf4CwawcZ+0MaebAOLDPZkkgIu499WfBiQhjDOEGc5c5uH8Yf9xi5KR8gJkg
	 luHXg/UadrT76BNOEtl1x7v0ZOxgrDMoZdP0x0FHexuIfpb9NuMrA/0c1WVvevPuKsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gH0DYllT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A882606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 08:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gH0DYllT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FA61F00919;
	Wed,  4 Nov 2026 08:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793781197;
	bh=56rUaLkKjtX6ZB9UH5r1QD7LWnj20Z4nDU5bdsBgB2w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gH0DYllTY13YXe8ev8pS7fwhX6Suer903pUxOogANaebtple6qBaNpe3lbTykTpT2
	 uqNDTToAnYE4e/hsrv6brqe4/GYmnCafNSaFmwtCayJQd+xdCc3Id5GhhzPCVLtZ+X
	 Cvrm6snzyhJ8MVYL2/L+mWTgJVf+0Cw2zXjdB2dKlRuOyO9HTBL48i9vaQCYbUC+nX
	 c2Eu/Ey9Lon87Iy+aQTw5TZpbfcykEKxPUIJFa59gPzkny5uYZPmDVuFpJX+Xz8G1w
	 ClKPgJpsg713kkcIOn/EE2Du3dEaNpVBxpZZHC94MAIpfZIdgQHLtk4lN54wRFNFJ0
	 qVrxIW4XEEH+w==
Message-ID: <536a5a8f-00e6-4ec4-9fd6-c317ef1b5ce4@kernel.org>
Date: Wed, 4 Nov 2026 09:33:13 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: myrb: unregister the SCSI host on remove
To: Hannes Reinecke <hare@suse.de>, Wentao Liang <vulab@iscas.ac.cn>,
 Hannes Reinecke <hare@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
References: <20261104021419.1468133-1-vulab@iscas.ac.cn>
 <cb17860c-5388-431a-8734-b66dd1efffc4@suse.de>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <cb17860c-5388-431a-8734-b66dd1efffc4@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/11/2026 08:54, Hannes Reinecke wrote:
> On 11/4/26 3:14 AM, Wentao Liang wrote:
>> scsi_add_host() takes a reference on the host device that is only
>> dropped by scsi_remove_host() when the host and its children are
>> unregistered.  myrb_remove() goes straight to myrb_cleanup(), which only
>> drops the reference taken by scsi_host_alloc(), so the host stays
>> registered after the PCI device is removed and the memory behind it is
>> leaked.
>>
>> Call scsi_remove_host() before tearing the controller down so that no
>> new commands are queued and the host is unregistered.
>>
>> Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
>> Cc: stable@vger.kernel.org
>> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
>> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
>> ---
>>   drivers/scsi/myrb.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
>> index 95df6e5345f7..e43d86f139c1 100644
>> --- a/drivers/scsi/myrb.c
>> +++ b/drivers/scsi/myrb.c
>> @@ -3496,6 +3496,7 @@ static void myrb_remove(struct pci_dev *pdev)
>>   {
>>   	struct myrb_hba *cb = pci_get_drvdata(pdev);
>>   
>> +	scsi_remove_host(cb->host);
>>   	shost_printk(KERN_NOTICE, cb->host, "Flushing Cache...");
>>   	myrb_exec_type3(cb, MYRB_CMD_FLUSH, 0);
>>   	myrb_cleanup(cb);
> 
> Reviewed-by: Hannes Reinecke <hare@kernel.org>

You sure? Sashiko reports introduced UAF. Mind that vulab@iscas.ac.cn is
a bot with spams with tons of patches which looks exactly like previous
hypocrite commit approach - some security vulnerability intentionally
added in between of thousands of valid patches.

Best regards,
Krzysztof
