Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422478;
	b=TYQ4NfCQPkKOxj+UAecZ5NUBXFviHd3xjs7m6EiQKDhMqVxfQWZO+r7jeinXZzAZODi9
	 P7jT9P/ltMWNJexP6dQZPsgbnZj1FbmcfSw97YiSbcn2uApRzAH9K3wOu70tkyGoWG7tt
	 xpfU8uBXpviTjTBfkCZfgdQkuujh9QuOkLaq+gaswqSFeVHanaJwYxH0jaNHaVghggf8Q
	 o2TCNYTIpDbArn3YjeV79ZZBT8oG4iUyPQK9+TdIecsyGQCprI34ElOTIBlB+ewAhlyRP
	 EEXjqEzNhNafsyx5fU2W6aNw+g6aGcs4TMchYG2NAKHsOxh2/HmdxDbTkS47jiTTTjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=eAf/LYtQdzETgJNaoLTxIh/MMYqJFTgROGsz2hEz7zI=;
	b=Wd1Pz2rA2AlJyevpAqib5OYUszCZk4YvANBA5sHqf0uSICR1loaNmxp9ln1Egt8SgNxd
	 yV7x1tma9Fpn1zGWwMYbBRg6txeYkAUtkCrkT6hH+9aTkg3oEl8VzgzdD3YooO7NofGw8
	 4BB6D7jDZ9ST7KIRymgH3Ay8pA1nhA888dnSmkHZvd4ngxpB506WaCl3uDOgR83GVe0rv
	 l9gX/D/ZYluP62u/K3oMWi51AJ33IcNXNWQEJMOYsvbsJCp/OvKi3u3VzWNLTSn5RbIRd
	 U905GwM1aZ0g4XKuVQnVdDriHPvd3jonFdwTiZ9gIQjEJyp4WxUmWWveGNs1BaMdu0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MUcg5Qs8;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861D6606A31E
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 08:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 861D6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=MUcg5Qs8
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4a357b1c649so1728336f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 00:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795422477; x=1796027277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eAf/LYtQdzETgJNaoLTxIh/MMYqJFTgROGsz2hEz7zI=;
        b=MUcg5Qs8HOGbVD3a9+8+XyUDTDo2XHgDr4iDZMV/QDQh2BbTJc27yR47TH7E0ckJv3
         zRZn92fj2+uJBhQbW2odayK079NQuK+L4CJuRSd/VyxbvDXBFnmmnUQtcyNz8CASVjfA
         xUsreHPFwe8b+qlE70brFZI0TOxf6FAY8u26l2ImsYu60ijUIE1Q9QjjsBadc4zOadhj
         iJr7JmfJfIf3qjrm+nD89qsuIeBsdKaSTW7ohuMXPPowo9D8Fk+uh0QEfPTaUyQpGMbS
         vz498c+CfhFZZlsQLchobeuLiOCJzwfuDwxhzGAVF6/+Ts1ZpPOmY2qAlKsHoKcM0v/g
         p3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795422477; x=1796027277;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eAf/LYtQdzETgJNaoLTxIh/MMYqJFTgROGsz2hEz7zI=;
        b=HivFS/1Dn+whGZDO3LoGW4tvbj/Gq9uLFTp+y1jFkLvWFhyR2fgmawd4RSNglDLM87
         C8Lh7ZAUvb5vq73qoykfdxsIqRhA6C5zzTviNipTJDam3dxhj2PAqThHlkV8O7GqYmVD
         GvFnG7rIr8QTaeVmHy/R95Cn+hVNoPJF4AIfF5tNM8YbyppMZ2s0OqWVflanEO2IGZka
         /uX1MUgqhDoI91EJ8kqFx/ijvg1g62MzwhJ6ibCDbU/nyhUcDrDbSEucIaG0YW/RfDL9
         JUAUwP8vjtnrbGSuuM8T0pm504LsUWqn+BB/yynSIijkv66wefdefi9F+AmU1PjPpgWv
         zvTg==
X-Forwarded-Encrypted: i=1; AL+hErF1FPZQFipbPo6lDIVdgMqms4lIV+DtLWlysvJMVCROQmuYEz22KjNA70+0/ONkSrVO14YUzw8Pfk77@vger.kernel.org
X-Gm-Message-State: APuU4Z9zJy5tUBZQSBMCKBaXAVr0sjsqKvoCOmadny1PGEi6FvieSeZl
	yMMTINNDRiavA8+PKFGmE+EjWgqIEq4C+EJnHPbe0B85WtP0y7WycTx1CnUvT5h/ErVYdNF9MRA
	DzZmW
X-Gm-Gg: AZFdTZcAelCVlQKt+autW+CDlqgngGA/KmzjeUSu6NLdIY+ojQCxXC8x1K4lJflUxnQ
	ThZmxALExPjahE2rIxNmBYrYExfKcR3vGGEgMmYCzTOa3IWkqnwk6utLe+itfHCjpVAoWmwIbuB
	AZgyYAznntdDEkG0eLoatuOFoKhRLy8cSAQZ06woTmgMCzuIgQDgn7xYq3u+0+Q8LuRpPBJVTFe
	0yLarCzHJ1ujy9buXu519Jn/rjTNuEsRwoEdRuxU6BBmEH1CrdJXUA58R6jWhqEU/bF9YcD4Bnu
	liCOsYQDPsoLhIhrGEuJFWcZtwnb811KBS3ncXqa+cIIKEok8NFpFxjEMEljjVEEPL02PYNJt/T
	LtDzkt7tTtBsJVsqV887HjA6HHr+3VNkLC/qknr1AP8vUm8gsV/ZVz4cRBcDIvvJ+maaAsH73ZD
	JThLEiuAWnslEi1MMErNXbyk0HDNKZ71Lv9Gx+sna1pp8szo5tBTZkgQpon2Ty/k6wEFKQJXtZS
	LyFPHEyzQlJ/VRdj/RJG0vAMkNZPfqeODzSqMz9wnzmAjIsTvcBcyQSevICyZUy7F5xWxo1/Eas
	rdU/N41yHY23uPcQgtfBdP1LH4InyUiP8WM4NzSXaenxnzpwj3sVMY6TtCivvfuY+U63h7I=
X-Received: by 2002:a05:6000:188a:b0:4a9:dcdb:2e23 with SMTP id ffacd0b85a97d-4abb4f59b64mr19748393f8f.56.1795422476913;
        Mon, 23 Nov 2026 00:27:56 -0800 (PST)
Received: from ?IPV6:2001:a61:131e:b901:6da9:459e:7c6c:e85e? ([2001:a61:131e:b901:6da9:459e:7c6c:e85e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2e6dsm21089807f8f.6.2026.11.23.00.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 00:27:56 -0800 (PST)
Message-ID: <68f6376d-a0cf-4f87-9cbb-0afb7b8536d4@suse.com>
Date: Mon, 23 Nov 2026 09:27:55 +0100
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
Subject: Re: [PATCH 1/2] usb: uas: expose US_FL_NO_ATA_1X in sysfs as
 ata_passthrough_disabled
To: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
 Alan Stern <stern@rowland.harvard.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20261121155253.4980-1-mat.jonczyk@o2.pl>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261121155253.4980-1-mat.jonczyk@o2.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21.11.26 16:52, Mateusz Jończyk wrote:
> The uas driver blocks access to ATA passthrough commands for some
> devices it considers buggy. However, it does not expose any meaningful
> information whether the command was disabled by the driver or is
> genuinly not supported by the hardware. This creates a problem for the
> smartmontools program and makes it difficult for it to provide a useful
> error message.
Hi,

thank you for handling this. One thing though. This requires putting
the emit code into every driver. Can we centralize that somehow?

	Regards
		Oliver

