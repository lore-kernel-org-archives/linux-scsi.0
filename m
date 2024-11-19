Received: from s113.resellerdesktop.de (s113.resellerdesktop.de [83.246.80.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088CB1D0954
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.246.80.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732038945; cv=none; b=u/sCAtB17K9x6FgtMc7D0bf6+3z3CtmG7VjXXOcnGNSbXhoZzYK5heQTLClW1i7/hf1+aMXpRwoVeI+tV0ZFB7wV27r/gfeLA9GXOXD/gm887QFW2nXd5g1VnegaA6xDDyBopevDMHE9MXoIrv2+E+s6ZT9fh+oOPG5eZSMzXqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732038945; c=relaxed/simple;
	bh=GUC0PxCHqTM6hlyMiw+iyO4RpInIzcHFMCiZUrW7hgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sYwfjOoeBc7yi139R0Wn+XK15LGs9cgvVAX5MFBhpA19twZi1yfK+2Dt/PHwFtjHQCF2VxsoR6F97tU8D+QJGOpsKtSr2lrTw5XAw9Pk0L6ZGHCnJ/4NuqR9JB/jmSasLl6JRsBGdp8He5LVohQTuyIRRR6wht+AP97tiSmDXBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloud-foo.de; spf=pass smtp.mailfrom=cloud-foo.de; dkim=pass (1024-bit key) header.d=cloud-foo.de header.i=@cloud-foo.de header.b=fuM0g2KZ; arc=none smtp.client-ip=83.246.80.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloud-foo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud-foo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud-foo.de header.i=@cloud-foo.de header.b="fuM0g2KZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cloud-foo.de; s=dkim; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
	From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bC2bf/dGhDo9RC2RyoQqlrEU9qaL4RyJqpX5bns2FD0=; b=fuM0g2KZSuaoreiWw/d+3BH5r0
	653F7UWfMhXMGbKSEJdlLPbQGDIVTqf2uNyg/ltYPGNkWM8sMX0AJiqvojrqwT7zplqNLPYZQjWIw
	QGyU+1vXFkQuPD1xUHA6khmOpo/CkD0Us64oKoZSOsXZtDW/1XI3iYHddYWjrJQxb7eU=;
Received: from i577b018a.versanet.de ([87.123.1.138] helo=[192.168.0.34])
	by s113.resellerdesktop.de with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <fedoradev@cloud-foo.de>)
	id 1tDSRo-0000000DQxN-37ai;
	Tue, 19 Nov 2024 18:55:32 +0100
Message-ID: <e6e5fc83-d2cc-4741-9924-a9634ed63f39@cloud-foo.de>
Date: Tue, 19 Nov 2024 18:55:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scsi bus disconnect on high load in qemu kvm anno 2024
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
References: <3a274d9a-8ff9-4cc8-8f4f-fd4cf98c3a14@cloud-foo.de>
 <yq1r077qiam.fsf@ca-mkp.ca.oracle.com>
Content-Language: de-DE
From: Marius Schwarz <fedoradev@cloud-foo.de>
In-Reply-To: <yq1r077qiam.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score:  ()
X-Spam-Report: 

Am 19.11.24 um 18:05 schrieb Martin K. Petersen:
>
> Hannes made some tweaks to the sym53c8xx_2 handling about a year ago
> which may explain the difference in behavior when I/Os time out due to
> load.
>
> But why rely on emulating 20-year old hardware in a
> performance-conscious environment? I thought Proxmox defaulted to
> virtio?
>

The vms have been setuped per default Proxmox settings. The help page 
also states, that scsi is the fastest..

The important part is, it worked until the F40 system was wake, than it 
started to fail apart with the same kernels that worked for months.

best regards,
Marius Schwarz


