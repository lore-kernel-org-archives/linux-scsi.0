Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788128479
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 01:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719884676; cv=none; b=Zh33pGF4bQy42qq8+9qNBj+aPU8KuZSK0TLnZM4LsXwruIGHfnebG/234auIlwUbtgz7Yrkxe6GxEWl64B1mivfRrMHP3iANmB9mSRHYiit8ztggaVjDTOUZmsSIusde2i8Y9MeDAUr3ZJxETncbU1qB/Q41eC4kKFV3XQ5CnWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719884676; c=relaxed/simple;
	bh=6OChGbeYQud/3ufNY8dVAz4Cwcbp2c1p5q9LXz7tcNE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B1m2/f00vhMCQi/vlwyZAAMIXl2qjzZU5hsWoxvpwa5lMXsgGYDcNE/ArfWlwcgea2nAkUmESFpbSerLV3SbI6xcQEEmrQC/v9DUdKVcZ2kn5eqA0XQNWsmFqdCQUbVEirc7yt1GmASZnoXaZ+X9jw9KCRFiLx4Qlz5pz63muX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de; spf=pass smtp.mailfrom=zettlmeissl.de; dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b=KAGd55tI; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b="KAGd55tI"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5c21a17760fso1682682eaf.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jul 2024 18:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zettlmeissl.de; s=2024-02-28; t=1719884673; x=1720489473; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6OChGbeYQud/3ufNY8dVAz4Cwcbp2c1p5q9LXz7tcNE=;
        b=KAGd55tIDtE/Ba27nq9HhhvGDy2B8LaHl3+WTvu2MHIjxt9cAz56eqWqIkim1MI3Cw
         5m7K0WQWIBqvlntZNk169jyQ/2oGrEvhq3nudbPPr+dCPCBPHAVZyK1u3XCJxQuN5YYa
         RwBtcPBKne6eng8E9jlsOaxMlWfseUR1CkIKTHqqBOCM0P/vJ3SlyQBIvvixd9HJRpfc
         ZUiDwE7v/o35NeLmFZnY3KbObR4GF+8jKU8zAQ1oe9CIpE3g4i8ARwCK7wKJHPYXz9sK
         /hRxMxEENfuVGzQc1DKzYCWom30pJxfH+UWMFM7t2WwSLN0r5KG2x3vxubrVhYz9lhsX
         AM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719884673; x=1720489473;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6OChGbeYQud/3ufNY8dVAz4Cwcbp2c1p5q9LXz7tcNE=;
        b=awX/A0XszdclSohJmKu6iVaq9OIHBtwHCsAuVOAdUdbvXnKpwZarEQjBvNKQg1Mgpl
         IbWaakwV/6DvIhcBms6gIsB6Sk4y1QAaeJCMZw5lJrcocwdOfNOcwXhOb8hAFClKHdzr
         yy0qzrW53kpcsjfqdoCknhYrKpTGRyeabUKBcOEICp3gNA4pKM55BvVvVh0h+kDrH9xm
         7mdt0/lUEACvr0N9PNr4WTyNyAxwEsdQht8w6F6Z+T0iusYPZJDZRS+FYQj6lUr5b08U
         QyXdXdGtfR5FjQ6prVw6z52fG1h3ix36Wrm3FUtXhlrNXGM5+60eblbIKpvBSCI6Yje9
         AfbA==
X-Gm-Message-State: AOJu0Yx6nK5OEaVM7vYYaH0WDUz+Kl9PTU2fE0mo0XlUsJ5OAeGqPVcc
	UNrI2iwAB/EVMntHAoHcDSwFC/VZeYQmpeVJuf1P3KNY7mPWweAfdmfqqSh6A9K00urRx2CJf31
	I0+1NEw==
X-Google-Smtp-Source: AGHT+IHbG+KnrRW2clWAr3dZqZfZ/+VBo6bgdDdrk01peWmvo1L4yPe+eo1ZPjQaLenftLIUPQ2bjQ==
X-Received: by 2002:a4a:b246:0:b0:5c4:4787:1d4 with SMTP id 006d021491bc7-5c447870301mr5865921eaf.5.1719884673539;
        Mon, 01 Jul 2024 18:44:33 -0700 (PDT)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5c45bdf7589sm213354eaf.41.2024.07.01.18.44.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jul 2024 18:44:33 -0700 (PDT)
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-700cb05c118so1800610a34.2
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jul 2024 18:44:32 -0700 (PDT)
X-Received: by 2002:a05:6871:522a:b0:250:7465:d221 with SMTP id
 586e51a60fabf-25db3447b45mr7218655fac.28.1719884672615; Mon, 01 Jul 2024
 18:44:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zi5YTR98mKEsPqQQ@zettlmeissl.de>
In-Reply-To: <Zi5YTR98mKEsPqQQ@zettlmeissl.de>
From: =?UTF-8?Q?Max_Zettlmei=C3=9Fl?= <max@zettlmeissl.de>
Date: Tue, 2 Jul 2024 03:44:21 +0200
X-Gmail-Original-Message-ID: <CACjvM=dA7MqfAC6_fiWv4LvmN8mNPnNG_YXoKnEz6t0vzyRkSw@mail.gmail.com>
Message-ID: <CACjvM=dA7MqfAC6_fiWv4LvmN8mNPnNG_YXoKnEz6t0vzyRkSw@mail.gmail.com>
Subject: Re: Oops (nullpointer dereference) in SCSI subsystem
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

So is there no interest in this issue?
