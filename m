Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793092899;
	b=nUHH5JPEXQLnhGD/j0y37T1UykGmevJ5CBlIZkw2mVQMSw5LoJ2I6qj970JZWYQTNU8z
	 1l7Kh9ZjMXe/w0Uj4BLP0ARhPdk0pI67zz88/szLAvRyPzPL7k8Baa/M2tXEA2WbXEjCa
	 nOwsT9o+TwQOot3jfolXeUR817KK0pGdqnHNp+Rnpk1bvB62K1UopFlg/fAurjCDAwSdE
	 crrOncVPn1ZlmWVIb88I8UglS8lRPZYXvwSWBAd/XaLvpugSNSZinBV9VMzd1YHCfWzGk
	 LLmWiybE/86//1qwNnpNiqSNBMlSER55QLURtRZz/jhu7J1DUZIKUR7KLeqvw6SRS4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793092899;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7ADcUnp4proYsWbdFg56tAcNwpkklMHnW/J4M42WqqU=;
	b=yZn7tVNnmru8JI4c5S8fl0BaRn+fTJXxN4eTcI5lxq2ysenJYWbSxc9h5jP0uLZ1N/tE
	 ExdQGjYAMoxI6cP/YtihlyrWcRg6d/5L6qJUB6hL/T/+uTRAlgLwn18dtbHmyL85qQ8OT
	 FWGQ2dEMaHBspNrFz63N5I/EP42lCzF/eXCuxKTEPeYwXFyDAxkvUDhFT4H4N0wYHI1lW
	 QBUo2lfJBmc+NwrIjvFwyjH/PIVxNsB5IjPRh2a/bxU9bG9ZFdJNzUFHuUvpemcXcGR8F
	 D6g1F6vcF6S77TQf4Ch/zwDxuCORd8dqNmla4kdIG4sBpLVZsw+OPYTWOwXENU3GmVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HKeto6TE;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F79B606A32E
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 09:21:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F79B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HKeto6TE
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so27272325e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 02:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793092897; x=1793697697; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ADcUnp4proYsWbdFg56tAcNwpkklMHnW/J4M42WqqU=;
        b=HKeto6TEqhT/Kmt3LtGRwmpX3Qjn2/N4v80HIvwRBwzBca+QWFl2eRdlqdQRNjceZx
         Kv0z9sU6QaAlA660MPA2nM0wWxC3ya86QEwfutyzhfw/XYBsfQKwhnAxuSPXDa3Y9ZBS
         XDf8Xa9xcm6QPOU6gpG65nPRbOXiwImy2PpqulEQAL2gt7eDckC+dhH7yjB2VhwyqPod
         gcLiKMwaLvuTV9HYAtNMByfHgN+388Athul+NhaKGwgqMdsZ78YRrJr5jlUBFZp2dYzo
         fyGHHEEXpugjCoRtFOgXZt+J5nr91ZlPsmaxroz6RiDepTn/BNYcVo7ODXAyrrGhx5vl
         ALkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793092897; x=1793697697;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ADcUnp4proYsWbdFg56tAcNwpkklMHnW/J4M42WqqU=;
        b=uMyGi0XsRNXWyFG4Y40TonDPb0iH8GOKsVR4lGzmjWfQNsCXiF6sBpcREOP6DeEbkg
         63tbR3usp+JfwDgMxpd9sSnAb0cb9cyGoTQM+bshVgtN5+3OvL0deKOXFhgLratAlM1A
         rxwXFKbQBDp94Ub/WW/jWEijYL61sbvqXohgy5yUFtbgPJQ6LlP2HZbysQJB3k9B4SB/
         WbnTur/OPpASRwBrv2yxPTZV+1cvyOGGeDnX+15nFTyFTKOgY6Agr307C19n6t7ckRsO
         lVgSLTFT3L27P9jiA6qHEn9wtVvxqzBg3+ip9v1saSbb5weRM6Y7SSz/tLoXbISDhgwo
         7rEQ==
X-Forwarded-Encrypted: i=1; AKwUvBzuEzN8w1/mTBqxpv7VqzZXgZvQT494Tzs1OhaZCDupXkZxrxl8vAfkipV8BnR3ln+ApgW+Jy7CDUfq@vger.kernel.org
X-Gm-Message-State: AFq9FYIl0/W6nLtVu+ZC0KZSEIEFBvyNzyu5YwY/eZieAusq0SUBLtYf
	lH9teyNOWnKEJ20LMRRRoWR4mn+1x9rdg2LOQH7NkhO00BtsysC9sXO1y6A9E+CwvFc=
X-Gm-Gg: AYBFou3Gs7UaqM+Ht70c728r13ONUcHudSlJyDnTbmvlM4i2G9AAlpctfC8a+9FThq5
	PHyrjANfQZED9wUOOcqQvbb82UbH9PqgssG7tDqs8F1k/b9cKn1jrx7fJ3pwX8UbSwRhJJFSeYR
	1W8S/8Xykk+hOjZmE3/S/QzhrjRJelqBD6aTA3RUH83dAdNUrx8ibCDDJu2ppEaScN8Rr5SsMFs
	5dRyuzDRmcIfYZagpcE4ygwIoRTuYnBqLVww7RidNyiCXoYFUcOFT1inPBNjy8PWE1wRDdwAbcs
	vIaZb0+lf1UlgFkspndTB9PtUblKtfF0GiFqJ1fDU03/3Eq7AyGnTS3Bi8gX7Js9qeGwb/9SLNK
	xMJlWGxFdbBVH+9U5hnDIPpoMIiDykLJSCt/N9AA6z+ztlzdGMT0ZyXI61g0fvplJl23Ot9RbFr
	LsB3M2OQimPcPr/VitDa2KqAHii+3AbKTMGXFxyQqhMSQdbhh2ej7LQCFof/PQ8EsOt78tbisdf
	7H5y8AGjR4fqy8MNjx5gvlD7acOMnMENpeAkgnoUNmHFDkkb0EYsI5XcSZP3RgTDBqWw5H+Y4t4
	PeuftqeqzANfsSrLkttfGw==
X-Received: by 2002:a05:600c:4e87:b0:4a1:f99e:f22d with SMTP id 5b1f17b1804b1-4a35acafe0dmr181678695e9.6.1793092897467;
        Tue, 27 Oct 2026 02:21:37 -0700 (PDT)
Received: from ?IPV6:2001:a61:13a7:df01:6e79:f35a:ab88:b157? ([2001:a61:13a7:df01:6e79:f35a:ab88:b157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3eb8f36asm21839576f8f.1.2026.10.27.02.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 02:21:36 -0700 (PDT)
Message-ID: <caa4542a-f1af-4a24-bc1f-f6c17d6e93ee@suse.com>
Date: Tue, 27 Oct 2026 10:21:35 +0100
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
Subject: Re: [PATCH v2] usb: uas: wait for pending commands before unbinding
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Michal Pecio <michal.pecio@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <e6009e1b-2d95-4350-8374-d5930200ed24@suse.com>
 <20261027073800.648951-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261027073800.648951-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.10.26 08:38, Jiayi Li wrote:
> Hi,
> 
> Thank you for the review.
> 
> On Mon, Oct 26, 2026, Oliver Neukum wrote:
>> 1. If an error happens while disconnect is running, why do we want to schedule
>> work?
>> 2. Why only this and not also scan_work?
> 
> devinfo->work retries allocation and URB submission for commands already
> accepted by UAS. Those commands may need further URBs submitted before
> they can complete, so I intended to allow that work to continue while
> new SCSI requests are blocked.

Even if an error occured? Does it make sense to wish to complete
commands that have failed while the driver is being unloaded. 
> However, the existing queue_work() calls already schedule these retries;
> flush_work() is not needed to enable them.

Indeed, but shouldn't we cancel scan_work _before_ we even try to complete
commands?

[..]
>> Some commands run longer
> 
> Yes. This is intended as a best-effort grace period before cancellation.
> The timeout values were taken from uas_wait_for_pending_cmnds(); they
> were not selected to cover the maximum duration of every SCSI command.
> 
> If a command remains unfinished when preparation times out, the
> existing cleanup proceeds. An affected bridge may still require a
> physical disconnect and reconnect in that case.

Understood. We need a genuine cancellation code.

>> Is the resetting flag even needed anymore?
>> If it is needed, why set it so late?
> 
> resetting is still needed before scsi_unblock_requests(), so requests
> dispatched during the remaining teardown cannot submit new URBs.

Yes, but that doesn't answer you why you are setting resetting
only _after_ waiting for commands to complete.> 
> Setting it before preparation also prevents the submission worker from
> progressing and makes the status and data callbacks skip normal command
> completion processing. In the hardware comparison with the flag set
> earlier, the URBs returned, but the command table remained populated
> until preparation timed out.

This answers it, but why do you unblock the device then at all?

	Regards
		Oliver

