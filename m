Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C347740DFC7
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773149234; cv=none; b=DRuXKB0XuNwIKAgXvqJFZxBj99XrVuqHZ/y7++2KPxrerr7YLgnugh/evHKVSZqQxMu8QvXo0GirQ4Hk5Pw6jyrhTLJ7h3ZKr/SO50qRktmV/xRib17z5207rG0WAmtw0WfPkSgpboN/ntlJgWPG4Q8SZ8BhmBS0nO2FsOu8RE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773149234; c=relaxed/simple;
	bh=Q0M3CsB4GtTszDcqyzgt4PMuFmQpYA4jX4liu+GU3Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lnk6FTxBu7pG/uo4yeYAjR2lJNE0nJh5fJgqIHhSmBkraAu3w6sIVlPtxpx8gqnUM7dthfmFjsmF4aMNiqUNf0ENd13mSoVWVQE9uyqWH7m9ci+REI8FRge8uWO+BtwpxPpxcL/8kDboqTFttJ9fr3t5v+pDyZdN7BmaHxjC9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TLjgrmmH; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TLjgrmmH"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4852fdb36a8so36370165e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 06:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773149231; x=1773754031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KQMwiNesWOvbkCjUoTZhAGMhdNBr4mXDGAT5peoa0g4=;
        b=TLjgrmmHE0GUilpJBH1/iUkAeSmlo5kut98A7se84KbdkSxfT23PzI83M/WH87CfV5
         BOTW6RhXaJENHkbVItQilATs9McxTVLauF64gknV+fCNnSNfbCl6NlMfLrzRNnu1QQsI
         aVDVYTwh2zelTHZErz2yI4EahFD/16wznrvvBqmmaHThVv0SnkB8djm99ATv11cFuHO2
         dD57HFhkzzC+w66Z3TM4CTuPgVmbVHu/hjggtON1G0NZXTLXWlclbMkZBRTHw8fHMjm4
         BuOWLXcJIJPhJx62ufMyzZBVGIhys2HniglYzp6l6jm1yiVg7Ygn6hbi66YRXbGXWR64
         6ERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773149231; x=1773754031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQMwiNesWOvbkCjUoTZhAGMhdNBr4mXDGAT5peoa0g4=;
        b=O3HMPsUIC4xUXsvufTwg06vzZdmQM1x4idzGLClnC3NHxriNOMvqrsomgPsc6xrUT3
         BSgn4qg+jgZH3VzYEINYJwMMaUdoQMpnm/pGWlXGiy0XQrOXUjwt+zjHvdZOGF8cVTUF
         zxZBEIjGwc+zGIx2GzazDR2CuCP1ievdMlfsNUuX77kIuas9Q+Iys+sZiKTS1psDaOAP
         c8UycEsAqqjJREBptz45wXCFMBM+Agqak3LfSKclAOqIN9KqUoUPbPiQXB+io22B0wMa
         V57E5TKmNJL54Q2TjmzrlybqLe3V0BdNRTi+hQVygudne3stfBRrhKkgPVZVkCOjBHl2
         MEBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfCUJhQLENqhwiVxnhJT1XC8DVqxFcn1BLcnlGwu/P4dG3/4tYGUqWq2sr9SKkSs0BWNZO5Kz4l22F@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2BrRo44xNIn9Mn1T637faQW8+hkgnXRZo87TcPX4AzULnEgIn
	RJp8WTZuq7aEROLQbqJD93WhLQ4Oc/2ZpDwImi71n5pxFMkGzsC10AvveAkEhgT49VA=
X-Gm-Gg: ATEYQzyKtfDlxzwB9T7BpXj/ugfgcmObLU8YBs6I7uWMcsdjYtDu2CFBCPKI4vlZLn1
	suShZTpK6PkvCuRH3xgsE0KztCe/ecogUjZKbw592y0RFwd2JDTeiu0g6GccAKprZlQemHGolqp
	DFJOwbfJqZ/sDks12mL1sKub9gg97nb8Xid8eq/jqE02wEwMHYlfmEWyfAsExZBmul3c5hNF9b4
	zOdlYOrIhh8jLIWUJqoPEqVjmtgFnic24Y1LUzKpoc1MaXeBvXn4nRRvp9uYbVKuV0OJY5U0vci
	m2cgdBXpPoYzhwaAtbeIN2X4iWxL906NipQgeR1T5uV1WMZ1/usj6c7fxL6wB8VzFyvnbdFzwd1
	B38Rfc6YxFm0UpXPCb7LAM2n5Kb4Gssux7PxVyuC3HUEVLbJEprYMOCgzxsHnp0xVsD7JULOURO
	zTNeQN8P8qrHUgkXgEPzexOHMiEAjvpkVb5Hh7ZPheiaGKKMDzqGsugWVk
X-Received: by 2002:a05:600d:1a:b0:485:2c61:9457 with SMTP id 5b1f17b1804b1-4852c61be45mr169997465e9.10.1773149231164;
        Tue, 10 Mar 2026 06:27:11 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae46353sm42155639f8f.33.2026.03.10.06.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 06:27:10 -0700 (PDT)
Message-ID: <c7a62f70-8a69-426e-9947-d2363a124583@suse.com>
Date: Tue, 10 Mar 2026 14:27:09 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] scsi: scsi-multipath: Maintain sdev->access_state
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
 axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-7-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260310114925.1222263-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/26 12:49, John Garry wrote:
> Now that ALUA is supported, we can maintain sdev->access_state.
> 
> However, preferred_path is still not maintained as that that is related
> to transitioning  state and we do not yet support that (for SCSI
> multipath).
> 
There is an issue with the preferred path in general, namely that it 
overlays the ALUA states (ie you can have 'acive/non-optimized' _and_
the preferred path bit set). So it only makes sense for explicit ALUA
as then the preferred path bit gives us an indicator that we might /
should switch paths.

If we restrict ourselves to implicit ALUA (which I'm advocating anyway
for scsi-multipath) the preferred path becomes rather pointless as
we cannot influence path selection at all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
