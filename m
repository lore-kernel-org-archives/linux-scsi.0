Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03B73BED31
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 19:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782846739; cv=none; b=T8gX7hhH8ymXrK9OcWXAeSRouGjo+lNMLE03GYgV4gt4ZoKVzCS1ieZvYjv8w9YrlLmt/SdAgkEmjChfkQXMgjTB0vnd6we9TOUM4Kuu3jm5FxcTpNNhmynzMPwz/VwUwa9f/Va2a/SGQh1DssgTYVtlcXnwfWmvq5UF2JuJyzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782846739; c=relaxed/simple;
	bh=/DSEQ2xqYIgfitDaGNpIeKt/o9+rudLGDg3Ye72WEdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2VIGHB3YlsUpO2Fx/CwV17CaIKmhp/3Bmt3u2jNlFLd3urd8q7H/LuqAuXAhbGa/904Na/77YGkR6h1ytILjYFDXlEstv5X7a9JqFa30cgFG0EWTqlZZ93K900/ecakY73m6etYghrPQ/RY9jWCY6odqzfPRkzLZ2Hu1UUH/5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8FiTwVz; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8FiTwVz"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-139f3eaaa49so2617611c88.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 12:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782846737; x=1783451537; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IVpHEl9caU7T4hBYJyvId9w6cxuR9iSE9E9+LhoY3dk=;
        b=h8FiTwVzy/Pv2da/r28WlnN8m+rl2iGXDrC4Ii/Q1bhttwb9WctB+H1z+tTKwC9yDs
         QufW4ZqTJQjsGkmxMJh+iqDp5rXzsZ4ozpo3wV2teuDZE80odVmKMhk5/EusWMdN2MI/
         1HZSWrDjp+S4FvG1bwVwhh05rKI9U6LBaAGzorKn+9KdHP0e8UKwN9S6diEHYFNj7B6J
         hvRIOM6YmY1xRjstTqVEI/Yyni2gCnA73wDU28zp+fvH6OdmJaCGJsmWXdoppb3jyu7G
         R2OR/Nd6UbkmkpnKiAYqs53ZjJ4+k7GnYBlGzXDHTmRqo99+Opej/cgHlp84wejwFbuy
         pkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782846737; x=1783451537;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVpHEl9caU7T4hBYJyvId9w6cxuR9iSE9E9+LhoY3dk=;
        b=SNPrvHbvlFQe0A1fNfnot8QkCKxTQO8Up5+2lyYIAI2hJ7vaijSbyP68HbK+MAxr4F
         lkPvu5zbLx8PN7Upy/UpuAlb583gLGtHvT/qESc8rLUlmTZ6oJdoWE4fEP0xAZrn6NPk
         sKg5ySeuu88OyNl+j5BuoojRe2CzMy79VcuiFZ5J71v6Nrv9vyvgLF2aLvCDX3mUvqip
         nQQ+bSn1u7hHEqiOJ/Ogrocj7l0c3NIR6nV6IajC8rfFsHKys9aRZWBx243H5UvJiVxC
         jT1ZPUXf2FeCKDDzna10heTDxb3iZI1ukWS1HKbkN6AA5jI9RhJuNwX3lIRij08w9KEq
         INHQ==
X-Forwarded-Encrypted: i=1; AFNElJ9VgBuOyewgV3Sbiq2rDU7e0P7JimgNU1lofqfar42Qlj/m2YTANqZqDw5EJIX6PZl+knnoGDfqJ0vs@vger.kernel.org
X-Gm-Message-State: AOJu0YyD2cmK0Pj6IAt+0PdwNvlXVCBw0fSbb6eG4GI6/sHg6mUPsDEy
	upeKc5Mx3CbULpVOTFKqz48LNFnGqDkHLAzFfZgAajL2SLyipJFXAGmm
X-Gm-Gg: AfdE7clkUmqymqAVsQK9s8rUuIYFdT1XHy8PB4Z2frGqvW1NqR4q4izWcwYbFoB3h2f
	BpjZieBB6GesdzgWFHiODaTNXKmAdS7P0jMZY9Up7Hl7uCuGQ3Gh6BZ9NCy3M0u19pMS19O0wfA
	7pyVWxRVruvW2uwA/TH45WRohr9XpKMidYIONRZO1RG/S85uKARtwqELdj0jrP69qMf20a6nF7o
	LNrC2pkKkXlN39tpjV+PZLJ/TuoTT/Rp108FJPQxpRvYRtVqBHCLGN9YuW6/Aea5iakoeN775Nn
	TsH5ef7I01KHrnms9gORgQbk4cFk81uKSxM+/ViaAY1A4bApqJzYItqjSGHx0++RT9mtTLxU2be
	ZGmQhspVUk7pQrga6sYF7wx0pzp29EpLekhlP1bHhXupNNgzDKHKUQ84ZlBLWr+fqzLsJL2bbHq
	tJ8w7lPXw1dUZo4IAZmKK5p3j9dqN5T0XfwFaq6LlUoqfTxlBfoNBddSj+uSaI8NqES7DL0stN9
	Bh7DbqZNO1QxLIOJ99/aql7N1b+y0k90H7BhG0/yAqw0Qc=
X-Received: by 2002:a05:7022:fa6:b0:136:d029:459 with SMTP id a92af1059eb24-13b3143a23emr1236125c88.22.1782846737048;
        Tue, 30 Jun 2026 12:12:17 -0700 (PDT)
Received: from [192.168.1.240] (172-1-152-236.lightspeed.irvnca.sbcglobal.net. [172.1.152.236])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2ab2e0e3sm10797161c88.7.2026.06.30.12.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 12:12:16 -0700 (PDT)
Message-ID: <10777a10-c65c-4dd0-b4ba-00d94351aaf1@gmail.com>
Date: Tue, 30 Jun 2026 12:12:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: lpfc: Add rport validation in
 lpfc_dev_loss_tmo_callbk
To: Vaibhav Nagare <nagarevaibhav@gmail.com>, justin.tee@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vaibhav Nagare <vnagare@redhat.com>,
 "paul.ely@broadcom.com" <paul.ely@broadcom.com>
References: <20260629190108.601212-1-vnagare@redhat.com>
Content-Language: en-US
From: Justin Tee <justintee8345@gmail.com>
In-Reply-To: <20260629190108.601212-1-vnagare@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Vaibhav,

1.) This patch looks like it was rebased on top of the first version of 
this patch instead of off the tree.

2.) lpfc_dev_loss_tmo_callbk is the .dev_loss_tmo_callbk routine for 
scsi transport layer to call into our driver when dev_loss_tmo event is 
detected.  A null ndlp->vport in lpfc_dev_loss_tmo_callbk is somewhat 
unexpected.  Rather than checking for a stale pointer, it is more likely 
that an ndlp kref accounting race caused the vport ptr to be freed 
before lpfc_dev_loss_tmo_callbk was called.

Is it possible to share the vmcore’s dmesg.txt file so that we may 
examine the root cause of the stale ndlp->vport ptr?

Regards,
Justin
