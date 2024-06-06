Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7A6770F9
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 06:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717655444; cv=none; b=B8vOoGH46zbGwzl/yREHPHSpsbap8eiVldsCEfywDss/dR+f1tyqneEHbgnj46Sp00xz0GGrNRMnSoJ4XQ2n7m8OQoZSXjpSdEGsw0041qlsH0KKSlc3cuqplI4k50ZQFmOstoCHKd2EM/t4U+N6LUSdLRSJla3GL06TZHmm+dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717655444; c=relaxed/simple;
	bh=AMkaXye/IgD3XuHEkVsmSZIJrIZykK1f41X0hFiOvqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HNOptgbmYhId+/QjYFoOtvFyl8jY19BmPQYhpjdiU4TpGD4Z1IBxt0uYkZ4ZFIhbk7rkg/PKftNoIMcHh21RUyQpsIl7P9tbiRhI83jZ3aTqWf/pMx02s2VTEPnVSvi56TvtI5wqTBcMkFSRAGeM+I9K8P/KqhtaeXjXdtuhv54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WSmmy26i; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WSmmy26i"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-35e4be5bd7fso657808f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jun 2024 23:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717655441; x=1718260241; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xb1aTIKqnCa6pPO/mwgnoF+k95Ug37iMONFe351z//A=;
        b=WSmmy26iY8bTmaQkA31eDX9RpdKPJhrF2SsjKY6ZvdV56WCqQbozIBYfg5nvusQ+fF
         a+bQVuWP5MSlDTJxvdVFGnZz9oQ4eDaz3DoS2UOb0c+FYQpHs+C6e0iE/vgWjM2ST4b7
         7LE5ojc6KDxrvY2WVNrpqamZ3tuoKezQqeneXn29iLxGv9u7Qg9fPLenjSVdFIu9ZCFI
         fVFW06nQA/XYwKV6t8E1tzxtb39/q3GlP3YCH3nv7yUwBwIxTX79n6UnwP1XIXPPBsAv
         leszcIFBye9W+M+4PHb45LJMsCx+rwCF7Vu2WDVoDnK7X4DNPq+BqZ4UlFNh7k8a84hI
         unMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717655441; x=1718260241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xb1aTIKqnCa6pPO/mwgnoF+k95Ug37iMONFe351z//A=;
        b=p8xnXZ4bKY4Kq1323EiOI/gq60JJnvlzAFrHxTjlA5PgRnq/4waG0Vloe5RjC8F7HV
         /MKQvqRK1HWgVxicLi6R3/cRuFMRH2wV/7cV5lkuNEhPEiZUghzGCIqAjxpugg0oYX+6
         XKg790Nv2BWN26bMvN4yXjdX8yqUx4DKcWrD8NoAkD8zHbgSs8wk3HrSlWEWgqbSbAyV
         UPESVFblaHvHZH25MWMpWmjDIA3kpRMRQvlK3vC8kSQVCKrVB9wrrvLCcynrfSC/ZhmH
         tATQHdUT9w8SkD1GgvchLWNksL4NKSi66GICtXfrnyG/i388wYd4abIJtnSJjRs05Ibd
         WjBA==
X-Forwarded-Encrypted: i=1; AJvYcCXB+Y8Y0YNWSaZgRrALfCklVAoHgknVRmhzfKlZvL1dO1yGjSpJv8dTVGzMJmgg74E7ggG0q9yWagt30DH6KislNqpkH5MVZyUxqQ==
X-Gm-Message-State: AOJu0Yw7MAlEVZeaWiGOgd8kvDkLEYei8Zn1I/3qHW+Uw9FN+7PTvHhw
	CEmhUsWdZWWzGINz1UbK0K1UjHx0ydMkKhqj1vsXIeAbsaTlvjekRxOrL9OFxsL/JufWLNGhwmx
	R
X-Google-Smtp-Source: AGHT+IEXqD5EgpuXIBPjTWIIfTAtJQjXTOnOLdJx/Qm17nIB6q9Z38oRFaF1mLcqWpGcYsafpDzPkQ==
X-Received: by 2002:a5d:4bcb:0:b0:354:faf4:fa87 with SMTP id ffacd0b85a97d-35e84057d18mr3414053f8f.3.1717655440686;
        Wed, 05 Jun 2024 23:30:40 -0700 (PDT)
Received: from ?IPV6:2001:a61:139b:bf01:c0fa:2aad:468a:2d84? ([2001:a61:139b:bf01:c0fa:2aad:468a:2d84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35ef5d293f6sm679335f8f.12.2024.06.05.23.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 23:30:39 -0700 (PDT)
Message-ID: <4a60e45b-de56-414f-85eb-71541e5d2cf5@suse.com>
Date: Thu, 6 Jun 2024 08:30:37 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] uas: set host status byte on data completion error
To: Shantanu Goel <sgoel01@yahoo.com>, Oliver Neukum <oneukum@suse.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <675774215.2024605.1717624320352.ref@mail.yahoo.com>
 <675774215.2024605.1717624320352@mail.yahoo.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <675774215.2024605.1717624320352@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 05.06.24 23:52, Shantanu Goel wrote:
> Hi,
Hi,

thank you for the patch. Good catch.
Could you submit in the form that the Docuemntation describes?
That is inline and not attached, with your sign off also
inline, preferably generated with the script?

	Regards
		Oliver


