Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52EEDC;
	Wed, 17 Jul 2024 00:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721176272; cv=none; b=VRo+pxmCeIuZt4QNT7FA3P/w0ZkBqhr80CzNdoLwvF1VyVM0N3+sGbdB+jCIJCfkmqas1lJfCU6khuDx9CxKXE4KnzyY4DUYyUVETUbMy8+wwudcMUbMptQDzSYsW8pDg3NAYs0/Y6phqq+TxBB/SK+OJ5aaHYtwlesu6voV/Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721176272; c=relaxed/simple;
	bh=4bgBD0d980yh+wjXx4HFIFLjQ+W5MLxchORRA3RIGac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ca3hjFS8DPQk8IbNxeE48vSNW2Zd3ZU9bbLz1DCdnWf9no6UYtKNK3bEKIK7HW3GTeBme3O/1f+vN3MOzxh4NN0CpwvShP42ygZTD1P3mY+5N+1aJlwVuTN3jjq5IWjkPi1CJSPO89ZpQ9ifuE5k/mV4MsTyL4Xy4l+gDdaV224=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVKrlQp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVKrlQp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BD4C4AF09;
	Wed, 17 Jul 2024 00:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721176271;
	bh=4bgBD0d980yh+wjXx4HFIFLjQ+W5MLxchORRA3RIGac=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dVKrlQp7mfhT37j+E5JCSWVXvUpxKQqa0qRG3f92ZtCdi1Oo+1P7xKvWArwVj6Wyz
	 flLUcOUbAsP13GmLo1Y5e/FhQ19m4PTAOeoKHBTpN17tq1HLJdRhw5u8+WVuaOC6Nt
	 SAIBXU7U5y7NG4sObpxnJog1X+gJNBPwU6xfxjWpuWINsQHehmT2QaP1no51QE7Va6
	 j9qeV7YSZ3/0hTFjQykL1p+85SCjs/D2NnBSCEFEO2aecLfpOdoZe9nbIcqQOpg+JX
	 uOf5AgZ+/4SsYcrX3lMc5Cf7RA5O0mLU8IHFgdJNBbwgpYin2jC88YQNevb4xjgfvf
	 WKK8bime/iIfw==
Message-ID: <020b3def-37c4-435f-99f3-fff67b49caba@kernel.org>
Date: Wed, 17 Jul 2024 09:31:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SCSI error indicating misalignment on part of Linux scsi or block
 layer?
To: David Howells <dhowells@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <b69d54af-2ac2-406a-ab32-9bad9d8a3000@kernel.org>
 <483247.1721159741@warthog.procyon.org.uk>
 <981264.1721174468@warthog.procyon.org.uk>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <981264.1721174468@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/17/24 09:01, David Howells wrote:
> Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> That is very low... Old hardware ?
> 
> I got the cpu and motherboard in 2016, I think:
> 
> 	model name      : Intel(R) Core(TM) i3-4170 CPU @ 3.70GHz
> 
> 	Base Board Information
> 		Manufacturer: ASUSTeK COMPUTER INC.
> 		Product Name: H97-PLUS

The CPU does not really matter much. I was talking about the disk connected to
your AHCI adapter. It links up at SATA-1 speed, which is uncommon for recent
drives. So I suspect your drive is old-ish, and old drives have the tendency to
be buggy and needing quirks...

What does "hdparm -I" say for this drive ?

> 
>> What is the adapter model you are using ?
> 
> This:
> 
> 00:1f.2 SATA controller: Intel Corporation 9 Series Chipset Family SATA Controller [AHCI Mode] (prog-if 01 [AHCI 1.0])
>         Subsystem: ASUSTeK Computer Inc. Device 8534
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 30
>         I/O ports at f0b0 [size=8]
>         I/O ports at f0a0 [size=4]
>         I/O ports at f090 [size=8]
>         I/O ports at f080 [size=4]
>         I/O ports at f060 [size=32]
>         Memory at f7d19000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [70] Power Management version 3
>         Capabilities: [a8] SATA HBA v1.0
>         Kernel driver in use: ahci
> 
> It's whatever is on the motherboard.
> 
> David
> 
> 

-- 
Damien Le Moal
Western Digital Research

