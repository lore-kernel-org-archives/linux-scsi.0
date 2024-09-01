Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0A6433CB
	for <linux-scsi@vger.kernel.org>; Sun,  1 Sep 2024 11:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725189604; cv=none; b=j7d+j1CfCxXF+6VnyTP4ieortUedt54dW8wJeje8DLXA8jSLAuIk/KC/nQ1BAcmwBNAhudplcjtuK9WywAqXWyf7dRDYSDeoJU5YO5Wlr9M9YFXQKJcb+kCNKRTmfQDVnapOR2bWgUrysqVtcafz/KnLYzSqAEuMVAudLqE4IoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725189604; c=relaxed/simple;
	bh=WEaFixyg2xlfyYAifs4RCB7Qh9l/D2JRzFUrHg9HaXo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tihIVP/h0+CuenYpJ8KGCT9QhLqdiVEIlv/zrwnN781cetKH32+TVh7NnP/4PHndRvt3miZYLDHl1htdsIA1qahVGr3UgBJh11/B4kit8iKSJSuyTSJxJzu0BfGJjBF+qI7bQN1iwg5L/LGTL7n+pG3hi6aqYaRGwXyxyPVWM9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WdbHYAqG; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdbHYAqG"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c24c8aab71so677970a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Sep 2024 04:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725189601; x=1725794401; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WEaFixyg2xlfyYAifs4RCB7Qh9l/D2JRzFUrHg9HaXo=;
        b=WdbHYAqGSJTOwgQmp7p7/iELC6GIRfl7uImD4M/3J/2UDwN7bWSZPAHYJge5nOwA9w
         42h31D+UdPgzmuvXmOT56eDyILEF9YV0ELxd7DKhfaYkdrmWtkJWvMyJp5CC28p3T7nv
         CUHtSEiF0kRlDhc+0OniQ7R8oBfzhhSwyGYq7RLUciV6Y/gyj/NuYHpqoq/bWISgNMbL
         ZI5lDBZAWcmmFgtXKApNitpyyGpGhrO/RlVi0SNx1G9cyHw1+LKSIbkkCILqyjLHq+Yh
         zv53d68yJEb4L4dH60qG/6XpXqGWDhl8X7hKhHZfRDeme1anUycNRZ7NPL7WYU4Hg2La
         igMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725189601; x=1725794401;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WEaFixyg2xlfyYAifs4RCB7Qh9l/D2JRzFUrHg9HaXo=;
        b=PTU+id5gCo5dhLKk/Jb9HRSu995voXlv3ndIDJVZ12msJe8uAXHrleGj7PwJS+TLPq
         acU0hEfrFbWbdBp/52RMR1tlzV1+widuP7itlO8fURX3DoR9rLkZ4eSv2pAZvZSbaVif
         g8mOjPluJG1mfckb0parEmz7oaz9MemF81PDsmIJgURWJF1cf0GCTTh+KWWzZroxvxB5
         Xdrrhp9rioCwyFrLsIaL/Z1R/U8CfeI+2Gblrj4Muj65gghB3NnTNfo9FrLk3WIMDTsj
         OUYLDd+an2vewNa3h20ZcqkkY5dczpEVoO+852l1qxLGxnXYhujbU7kYOHYczEfok4mj
         g3rw==
X-Gm-Message-State: AOJu0YzZdBs8wxtmT0PiR4HJTR0myocc4H6QYbap7L/zmx5siYeIQhvl
	uA1dnNL2FVA0Q3DPv/LlqbjfWeq//D5C++t+IbKUUKzQglEr9dhJ
X-Google-Smtp-Source: AGHT+IFH2JdhZRZ4oRe73n8/ZGmIJEh2f9qTl6Am4sTo4aw1uGTrJAaHwdhbF5TBWCOosJAlX65Rvg==
X-Received: by 2002:a05:6402:2753:b0:5c0:c223:48a1 with SMTP id 4fb4d7f45d1cf-5c243741935mr3453476a12.21.1725189599914;
        Sun, 01 Sep 2024 04:19:59 -0700 (PDT)
Received: from p200300c5873875735579a6543d78f9b3.dip0.t-ipconnect.de (p200300c5873875735579a6543d78f9b3.dip0.t-ipconnect.de. [2003:c5:8738:7573:5579:a654:3d78:f9b3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226ce4fb9sm4187931a12.87.2024.09.01.04.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 04:19:59 -0700 (PDT)
Message-ID: <9548c30e7906069184493ad60d5639781b0c47ba.camel@gmail.com>
Subject: Re: [PATCH v3 2/9] ufs: core: Introduce ufshcd_activate_link()
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  Peter Wang
 <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>, Andrew Halaney
 <ahalaney@redhat.com>
Date: Sun, 01 Sep 2024 13:19:58 +0200
In-Reply-To: <20240828174435.2469498-3-bvanassche@acm.org>
References: <20240828174435.2469498-1-bvanassche@acm.org>
	 <20240828174435.2469498-3-bvanassche@acm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Reviewed-by: Bean Huo <beanhuo@micron.com>
