Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A331330C360
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097778; cv=pass; b=qL5lZG23pwVooMUM+xZXneQDbEaaCXDCmxmu2UQin9bXZnl1wLgogeZmfO+j0vFynGl9eq4Az3VXPG27ojJZWWj9HkgblENa2jPuSd9oQEVZaBZXMFyDevhpwRKt7ZzllmATHT9TpuID/N2furUJ5dDnEE9UeuUUuxdZtgrcok8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097778; c=relaxed/simple;
	bh=bEjebhaXS2aMNTxdu70YIrL7kuxqNDfmED6djvP94EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MwwiJ5IYcY1rJbSFNfyP1OIK6INJDFXnjamlvsQSQ1XgcrkuIByOgDjoj+k2EAZoDkLZjiS6+O/2J3vrQHkmDHFXQkvmpZ9rXdUGes8aS0smssTFWGr06msG0hONU3CAf3rBvXMpw47GvKJrXgb3pry2BBmcT9TjW5KlzH0hJlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FOOH3fVm; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FOOH3fVm"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb5c9ba82bso710474585a.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 09:29:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776097777; cv=none;
        d=google.com; s=arc-20240605;
        b=UiNBhTFELYsRUjSv/yTbtEkksOTA42LXJJV1uMvLAapOV4OYYawhfmKbda9jFqfwbJ
         nyPaIAdUnzbVSuCnCG6VEQ6uJoZIt2LNAbanS/HsUONOdOe5PE75lhcw+U4+mdV2Po+X
         +CCCAfzEkQNf/9sjMlKqEfUtjTQ6peTmi5z0B9XYUWUg1gFCzJ1bxfMK5Pml8/snR+M6
         Ch+PfYTxdFVZLnyp1OIXN1uRNEjDz5mu2vp8beWpAm8riwFMkG1e2SNhKkXrRfjNlX68
         d8tJe5PPQ1VAj4VPuDgolkGqEsM7rUpm0TLUJW8TNnHebKlgYu8aG2XqFkDgXdOwlM80
         ZNrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bEjebhaXS2aMNTxdu70YIrL7kuxqNDfmED6djvP94EM=;
        fh=zsAFc9vlbxS+3bXMSvqLbACQwYkCFeVwphamvdifVz8=;
        b=XdiD1eGwhQwHF/gaN6VMvPiagoDWnB/tL4wDp/wv3BOK0jonl55c+OgUGNbCfMHRV/
         gR0iOl3MYbQ0O6EWOwDjf2lYDjF/AHQJLuYF6HapsjY4Q0n7nWI3cC/+h6Ryo7fRRBO4
         ToKr1LqqTz7uJ/bPnT+seZrPrs0PsJmW9qW+2iNiYw3N+37GTPcAHyRmZnWmef296V/m
         HV09wEzZ5XVKjTzF5OZopqacI9MmqvGKB01IZ/MwedJgFKTvrmkdojQt1VRrM/LBCUDp
         aXlbgewaLgw4ZQisDZ+rnV/Y/ld6Is58X3vWw/MGCmn733i94BhN9lj0HDGyrlpf1rjq
         ElMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776097777; x=1776702577; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bEjebhaXS2aMNTxdu70YIrL7kuxqNDfmED6djvP94EM=;
        b=FOOH3fVmR4Ua7bVq/YTgvQh94CJR70KGtiBwAjyFTL1lKWwC2VuTfrIRToy/JT+Frt
         I4KLZV64FAAVWw0Ta06dzzLDDdpxpI0Q8w4OtX399m5C9SLTkIHdjCK2EXKL+/6k7DTT
         XNqOxoD4M5d3T9mZRcxHpQoE+XLP3WkqNPdEv/IMEXjoWRnpvfMJ4LLEC9kC5rudchTj
         nTHROT2KMPpkNeHmUX26jXemTG4QtVAPTyQfse+H+G2I02jmhyDoJe1n1Ir5htlBkbNa
         lK50UgUt8j9393r6aW17oHEuzh71/Ct0y/1AkYK3lVCN5X/fhtTsP2hX4et+x6wwzRCV
         TM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776097777; x=1776702577;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEjebhaXS2aMNTxdu70YIrL7kuxqNDfmED6djvP94EM=;
        b=SQtgioAVS+k6IRxyRGPf8rXd9OQEzeE40hEKAKswFM8UI11LZ3b9l7p6oYn1cNrOMZ
         VjU/QhN47WC4yYaJ8rryCz1cX/bZVyrN/iLfzaySOEnDXXmNH4no7ufcXzoojIoOEflB
         MLmFoemuuJxOF+g7J6j15zTUvhStSzPB89qeudZ249S/QoNibrrl4FwMdVxvHoCOjuY2
         euCP7ccs3G8njVNPGVtIkv93jeXfpBrjkxfol05Zc4Y9UvWJRyfjYxUYhYCYI2z80Rpj
         g/8N1zurgzycWUsXJDN5RLIvD//X8bDsMq7/NK9DTSGVGfZmdoskGU87D2VkHK7kmD4r
         PoyQ==
X-Gm-Message-State: AOJu0YwVWQB1A9DQKMcqXJoS6q2nSg+zlE0tdSOF4DtYW0N30cDRI9Za
	4TrypHUqUULe4EbO5Rlh8jfBGirvQ3BljvHoGS/GzJw1nJx80CpO5STfZwV/ruLSfX1aZgR1pbn
	TudCDBOsLE54TSQOwAENIZMWNsXqFl5c=
X-Gm-Gg: AeBDieuBBajeXcKsF3yCuKLH6NumIsYpAZ8G8fdjegA0Djgw+ZzKLOGwDLtMWKJJNRk
	6+ONXkSsTkCuvMCJcG97YFokSglskDXSWAy2lqmffsHXTB3Avm0N9yzKZzc6p1P6apX0xdLkiFQ
	UlG35s1JQBLvjnMrv2kKgIXwjxVtPmQNZjnalJPHqhVEZlry4CJCh+/jHWNIHJhZZL4pF9dUZjO
	ICdxUEq2lQFowwGF326Nurh3W+WHXe44Qw082nid7RLUzqU+K8enMSGzT8MSW1KpMno+kIyulXG
	EqFs2WAEs6zB6U4Pv4dtnLxCzXwDjEK0ssjB2yes
X-Received: by 2002:a05:6214:4018:b0:89d:b093:936f with SMTP id
 6a1803df08f44-8ac86312e43mr214977626d6.52.1776097776521; Mon, 13 Apr 2026
 09:29:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
In-Reply-To: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 13 Apr 2026 09:28:38 -0700
X-Gm-Features: AQROBzBJR8RbNuM6NVgcCWo1U0znk3JqY1eo4WClU06kB_rjKFuqjP1E1_lhQoE
Message-ID: <CABPRKS_Ek4JHDs9pBg2nium+AjHhM_JQ8su1=vrcOg+xME7PjQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	paul.ely@broadcom.com, thinhtr@linux.ibm.com, 
	Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Hi Kyle,

Broadcom is currently reviewing this patch set and will report back.

Regards,
Justin Tee
