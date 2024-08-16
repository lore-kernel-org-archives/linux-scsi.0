Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853AB75817;
	Fri, 16 Aug 2024 06:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723788535; cv=none; b=aAwCbH5YbGngdrG/iPsO3i+rlpBoi1+8hrzDWVMGtqESxEQY0yiIMBgn9zh1F0tnwWHXf+DB8nsv2SPOL1yMNbWQGJfqGNWJws3QWHQZX12FIGrPn1Dx2FSBMblDr3W7zGZifAVHV5X351oL3BsaAEu3wT8XEayvh3I9/EHsQN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723788535; c=relaxed/simple;
	bh=6vEqT34sXONcN+h8n7GFxvTvC61LkDaA17QipPFMyO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TIG9kiqutmz7D3FFG/YtAqVwqFUvYP39dNUB7Mie01sS3TCc/J+/ypcGSUPLbkHYEn5HhOewVpzE1/zzvcsXVzKEi2yHEbsmWVSDO0BRYp2SoxOqX8U4bz38MPrsd7Lphm6LRNrQBoa1l7qvdCqaGi3LXrfLbj2i962axdSItyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m+Ir0vfK; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+Ir0vfK"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-654cf0a069eso15867887b3.1;
        Thu, 15 Aug 2024 23:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723788533; x=1724393333; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6vEqT34sXONcN+h8n7GFxvTvC61LkDaA17QipPFMyO8=;
        b=m+Ir0vfKItO6StWKSt4mnfr3Nax9KOQ19VgIl7gAIpKNRKsL1o4KnPAQPtphh9eaB8
         f/JWJe9nI0H64WSjJlk5yezz9amcNrfn+sTeGnO+eb+JwAQ3W1qQQSaBhH14p2q6XJ8V
         6ibqEstGDDhUDzvIndGwsCOHp3MW1gm+3k5aZST/XXE8ofzIGdKRbbQ7K7g+aKXA1LLA
         ZOR7rRJcLowvHARwp/CPGeKQfw5r4jYG5WlA3LKy89pTMMO011uszapdkvwnkE7ce4bo
         iGj5vt52IiWMr5KaJt11VGdi15yrXQqkcWSd3D7CZaqecjfLMw0LvRNYTHxkJWhUJhDR
         HsGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723788533; x=1724393333;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6vEqT34sXONcN+h8n7GFxvTvC61LkDaA17QipPFMyO8=;
        b=WGXTAwvVs/6jPQGQvrOQdCaSMaNkljLkd01hehWdZZpCJlm0ALkC0PlCuHFK0pg4fD
         gtJpjQGfhDzmxRxzYGlXY9fZzqrP//Mr/SCXEfBx0pX90k1VXe3W6LASF3/I8XQC1zKM
         hA+UpzGT9V6/dkuXCK3CVdyO6lo0KYx54o7UAJeADDZ15DMHt1y+11Q+Oj9tNu5gu3Pl
         teKW/wLdWHAdUVLCZZ8qmO7daqep778Ictqu9bfT31+ACH9LTiigkYWY8yO6DUTIAdBF
         eiw5tn7pcx9ZrfcrCgHKqDJasewAbR/+k02aoxhxhpmdyT73TC5dYlPkGcBYs2D629DX
         SwXw==
X-Forwarded-Encrypted: i=1; AJvYcCUP/3EUDY5r3UhbOcRzqrw/AE0qTdLHZpsBsnDtghSvrtL1uKeoHCN6lSQI+PHEClTxw1qlTznj6wLJa+anqnp/eQEirwI0zm4ZEFf2WdamGI2PyCkcPcmPdtQXa4udyxTFrFDFUnlacg==
X-Gm-Message-State: AOJu0YzETCMz+EW2Su5xIBIp3aO7ylgLq+dlYaMhgo/JPu4fAByN1rlc
	S9Q1G5Uw1kMh6ncq+VJ1y6UdoFmuDWNis2dZGSH/ODr2PI2R9vdkay3dfqjcpDc7gQCaAOwYbTO
	Nb3eXLgpBXhjNfxVrrEkG6kLXsUQ=
X-Google-Smtp-Source: AGHT+IHl+FkKq7UakatGyPIPNGjN/fraqzL1pp3fdrre1Wa3ZdQzIeS27HHAZuZLNJp/aMExskiiQtJoa6jken3/ZIs=
X-Received: by 2002:a05:690c:6482:b0:6af:6762:eba1 with SMTP id
 00721157ae682-6b1b91bcc62mr20634577b3.20.1723788533419; Thu, 15 Aug 2024
 23:08:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zrog4DYXrirhJE7P@debian.local> <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com>
From: Chris Bainbridge <chris.bainbridge@gmail.com>
Date: Fri, 16 Aug 2024 07:08:42 +0100
Message-ID: <CAP-bSRYC6sGJMRXYbHDKwgN9ve15hccw_HK-7Mdd9c70788RvA@mail.gmail.com>
Subject: Re: [REGRESSION] critical target error, bisected
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: fengli@smartx.com, hch@lst.de, axboe@kernel.dk, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Aug 2024 at 04:56, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> I would appreciate if you could test the following patch.

Works for me.

Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
