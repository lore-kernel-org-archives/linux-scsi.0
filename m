Received: from s113.resellerdesktop.de (s113.resellerdesktop.de [83.246.80.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306051D26EE
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.246.80.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732039151; cv=none; b=exz4bMXVIqTVf3+sG6yLLCC19RhzOavpUcHtI+2jr69v05g2+TQVBQPk2th1GkN46ZNKF3MYnubzRr3NI7pMtbw/z9s0EQiFRTKwlGii86vGHiJwf0AyK7EkklB3FiYgDPx0nQPTXiODFA7U2Xx1CbgpsIZirV898eCSC7JO1io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732039151; c=relaxed/simple;
	bh=7i14AFu4GzaZvPxnbhzeV39b+TaXV80No3B+3Zd5J1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NMFMuZFIzE7EzzmqOuFI1BPvg7rmLImw7mEUbxpYnkKLq93Vs9uOyYw8umIycHYpDlbive7dOJ9AvRnUGUeIR4UVk8Tf4kfZEKQEP5szgSKkq7QoyrOhDZTdMqboT/S1HNfH7McdAESieBIPKrszWZKYRjZWVT3EUPDLzdm1SWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloud-foo.de; spf=pass smtp.mailfrom=cloud-foo.de; dkim=pass (1024-bit key) header.d=cloud-foo.de header.i=@cloud-foo.de header.b=Rly6jwFJ; arc=none smtp.client-ip=83.246.80.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloud-foo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud-foo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud-foo.de header.i=@cloud-foo.de header.b="Rly6jwFJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cloud-foo.de; s=dkim; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
	From:References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fV96s4IfXyXhmMdktZfyXJ290nXGBDblJ4oYWY6CNrI=; b=Rly6jwFJkdn7L0JpzkCtTm+8GQ
	pFrAeYp1vo/k3VZmbez/5cTMqV6I/Cr6PtXFkexf0XMoUzYk2bSz3A/klefJGOGWnT/ztWiGyJ8c2
	+h/UtioBzlMSPqy28H5UefNRThgepnBLRgwMiki+ZKinxpab8DrwXXu6513QN0pKNEHs=;
Received: from i577b018a.versanet.de ([87.123.1.138] helo=[192.168.0.34])
	by s113.resellerdesktop.de with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <fedoradev@cloud-foo.de>)
	id 1tDSVF-0000000DRAQ-3Zjv;
	Tue, 19 Nov 2024 18:59:05 +0100
Message-ID: <7f84bf30-2b7d-4e94-a4b1-9e3b67ed45f4@cloud-foo.de>
Date: Tue, 19 Nov 2024 18:59:05 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi bus disconnect on high load in qemu kvm anno 2024
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
References: <3a274d9a-8ff9-4cc8-8f4f-fd4cf98c3a14@cloud-foo.de>
 <5c15f52b-bbb5-4d04-8e48-11a92d407201@acm.org>
Content-Language: de-DE
From: Marius Schwarz <fedoradev@cloud-foo.de>
In-Reply-To: <5c15f52b-bbb5-4d04-8e48-11a92d407201@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score:  ()
X-Spam-Report: 

Am 19.11.24 um 18:42 schrieb Bart Van Assche:
> On 11/19/24 4:52 AM, Marius Schwarz wrote:
>> a bug in the scsi subsystem has been discovered
>
> Why would the observed behavior indicate a bug in the SCSI subsystem?
> If the queue depth is high enough and the I/O timeout is short enough,
> any storage controller will get overloaded and will start aborting I/O
> requests, isn't it?
>
> Bart.

Because it was working rock solid under any pressure before os upgrade,
and now, with something changed on the os side, not the kernel side, it 
was producing these resets.

After switching to SATA in proxmox, the same tasks have run flawless again.

Conclusion: there is an unkown trigger in the os for a unseen bug in the 
scsi subsystem.

best regards,
Marius Schwarz
