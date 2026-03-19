Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB617318EF6
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940759; cv=none; b=k+uKWldWAyQSi+3yGOVgpQRC8n1BejfgRSZWquiSbBUn3C+DTg1zE7BNEQaLnmlqam+DI+lN8A+fuUx2I9MqcKX5LhBeMVv0Nkh88waBaj8TKe2mij1DAl9WnmlPxxjftjh1sfdikwigRl1znri6yzLyY2Z5qLYH5X0GGbu4sEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940759; c=relaxed/simple;
	bh=txPm2KPLbr2A67SUot0NMUFBiy3OJLCXmwdS7cx+l+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUxgVWgSSvkF7JKaYig3rzJkj8SRkhBnzir4xSIPBnwWfGwxHAChDDRM10nvx0EmfJAhFboabtaB3nMABzqbeyWdAt7hoMl5Q3TaZmKbyaNkcafQ/bEHgxK5+cnYLXBVptTePzCSP2p9upKuaSAJzPAmfPi78S5csmhmV/KdJOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WBDFuZVl; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBDFuZVl"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43b446ee9b3so41868f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 10:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773940756; x=1774545556; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+EmpvHf2OI7v2k1uuTeZgZ4uT/TXFRLspVIKOW76nE=;
        b=WBDFuZVlKpFtF5RrvISND4xKNOJUR8UbrCcZztFR7dJxYsjGnvtIL4v0Mpp7fFF01C
         A0TQ9mUFooCsN1O2uFWzXQNyLiclvp5WTYLv+TI4P00IxxwxZ+ev6HLsTbhXvTHIEIBc
         oTGmV3IBYYborMkOlBJGDqx016/40AFw8wTu/zMW8s7UbHCuowi5IsCw6ocaAyVrl0Zi
         N7ZFwAIjnKRjvX5gGamMe2/GxNpigE/h/vWbawqgAGDDisGxJwF/VQXoItvEkL1Hp0EF
         oLInO5nHE3CTlri8qASxPjtgdtbQIjK+Hb2CldGuBGiUkr655EO9iX54DfjZ9tHVoAVW
         EiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773940756; x=1774545556;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+EmpvHf2OI7v2k1uuTeZgZ4uT/TXFRLspVIKOW76nE=;
        b=tINsQgouNJycoqJdNrybqrD/Fbe0lYJLNKg1UBjXsqGKgM8CFjdO407wlNMhvRxA8I
         OSOuqEuaejgYUWja79H5z9j8xOvmetwwR3XI/DivI6C2wAICE6iZ3OUdqznBWfscuaxB
         NBE9KDT35DhxaY0/rFrKoVXuqU/tE1nM5Y+hbxRTavTMFFVOygu5MlUelmapinosJU4c
         zYLmowdAe94QDNxj93RbxBOKmLeyxUk7WwvmmMDM8cENMCgrZrU+s0dHcCX6z/cMEEzo
         J1HMyuFGVDA1WPdntbGTHjr802vVTcKwbyPp603UWPKuk/hsELgyHwnVFffRUl1AJbYZ
         y1yA==
X-Forwarded-Encrypted: i=1; AJvYcCXlZg2JLUI14OgS0UgxTTGGn5aNAnjXJQY7G3Omztyq3Dj0a8J2vIG5jl2BiOXVvO/85yAJnNrXrj0L@vger.kernel.org
X-Gm-Message-State: AOJu0YxKWi7C2QvZCnzZlXeefwCzxKiwD0ylpQ1fA/4Pt5ITZMK58i+w
	1IV8JgwfzfTwVAm3JD3bqN82JLPOG7yxFVTK8TjBdYfPShULMsrSX4I=
X-Gm-Gg: ATEYQzxYg1AmbKMpv6rmjd2NVrLozWNEmQnwEuqggPyXTJ2IjAAEZj5wpJysYdwWboV
	J1XGmLXu+pCkloql8/mX4AGSbeWthsk6l54g9dFWssLl9Eq+YmoBLh84YHXJQLMV/Sa851HyZRI
	PkER4cFpz1NUambFLns4n8LP82jla8JcE6oBwLTzUjDn1QgP6C7VDuUg+kOPfFvkdrEPqum/ci8
	L52UXCc5flQm0PhsQjse+e4n8tfc0UYjeQGDV3Wpg1K0l5Lx6wknbi8BzkW4sDS5y5QshwoXNG3
	BeVrmpz6LvqZNfzNYpUubgn3AIkH3sAMDhMWWWpq54fKX5MJ0Uot56vCftHRxhgzqucL7V7C7DR
	yzMTb/14PKiats05L6LFmAjj8e6eJXjPkYtsEEtIpq1vzkAOFWJHFK5d6P/c8bZ3dqoTZTHiLmW
	72+965uVrzn7blqWzlr7QKMS/gIXzlW38mQsXOReRk1jPjxdZq6XgtzEKGxcuo
X-Received: by 2002:a05:600c:314c:b0:47b:d992:601e with SMTP id 5b1f17b1804b1-486f442f9e4mr92221045e9.2.1773940755879;
        Thu, 19 Mar 2026 10:19:15 -0700 (PDT)
Received: from localhost (30.red-80-39-21.staticip.rima-tde.net. [80.39.21.30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe89cbccsm448715e9.24.2026.03.19.10.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 10:19:15 -0700 (PDT)
Message-ID: <a37483bb-bc57-4c73-97a6-8410b67fef65@gmail.com>
Date: Thu, 19 Mar 2026 18:19:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] scsi: scsi_devinfo: blacklist HPE/DISK-SUBSYSTEM
To: Christoph Hellwig <hch@infradead.org>
Cc: "Ewan D. Milne" <emilne@redhat.com>,
 Anthony Cheung <anthony.cheung@hpe.com>,
 Takahiro Yasui <takahiro.yasui@hitachivantara.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 SCSI-ML <linux-scsi@vger.kernel.org>, Martin Wilck <mwilck@suse.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20251004145459.58259-1-xose.vazquez@gmail.com>
 <924c8c63-904f-4da4-afdb-5ac5de403dca@gmail.com>
 <aSRmXAQPSMHQXLCV@infradead.org>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <aSRmXAQPSMHQXLCV@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/25 3:06 PM, Christoph Hellwig wrote:

> On Sat, Nov 22, 2025 at 11:16:47PM +0100, Xose Vazquez Perez wrote:
>> On 10/4/25 4:54 PM, Xose Vazquez Perez wrote:
>>
>> Same here, any problem/drawback?
> 
> The could be asked the other way around.  What serious enough problem
> are you trying to fix that warrants bloating the devinfo lists?
> 

This entry was originally covered when "HP" was used as a prefix, as seen in
(add HP DISK-SUBSYSTEM device, for HP XP arrays)
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5f96f42b76e00e2871033745ff029056cc725c76

However, after (fixup string compare: ... Vendor strings must match exactly)
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b8018b973c7cefa5eb386540130fa47315b8e337
the "HP" entry no longer covers devices reporting as "HPE".

This patch simply restores the intended behavior for the newer "HPE" vendor string.


Thanks.


[ This thread is almost six months old, for reference:
https://lore.kernel.org/linux-scsi/20251004145459.58259-1-xose.vazquez@gmail.com/ ]
