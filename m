Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2D53AC;
	Tue, 29 Apr 2025 00:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745887448; cv=none; b=MVq6X0JcownUfcodVCviDgcP7YwEgbN+yIorGZbiIrio2jOdLzThXKt5so/o8L/OzT1z6wrWC/jDGha4MKB9OBkIHqaSRFNe4eSMBdDHFkz38mFsXhkjrQXZSLQGSeiOFs/CkVbcahZBAcwU+t/qom3Xz1jQ7VxX+roLrKggsjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745887448; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oVx6/TaJ+CGGVS3SXFEthAv0DV9zyDZvEUNVEsPbaHI/c1fHbxvpVTRrrsTwrL59G9C+nOT0m7l37mNx+a/1CzhN9Sgplvu/tJtri7ZePjOrDnB04qpKVX/2GU1P4mmOyI/lYQlhqJleKfhWYGeDpATDyqD37kHvC3MV4HpzKtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4zslNHh; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4zslNHh"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e589c258663so4867223276.1;
        Mon, 28 Apr 2025 17:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745887445; x=1746492245; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=J4zslNHhr8Fm91MLJkj1UgT/N0560/0zCAuPrckWjn0vBuBQLIg+uJP8S4eoW9fzV7
         MAleB1fzx1nKEW5leFStob16M6/w6q818UNuOJJKI2OStbKhgMBzZgQEVAHhMKnXo6CK
         UK7rkhM5hZ94CMLiC4u6Ok1bHOwxP3U3XXZ5CzyR/kdw3k4BEI2C5Xvg2RK3+K9sToC4
         /mDZ0SNyWBxxaIbmQejkG6qiBh3ZBrpDFEW1xpx9NfyDGh3zVfigDiyXXxgBn8ERyF24
         m8dW5R/CaqamAs5VZuOh2NGrdLKw0aq11FYM8NTkR4vvjyfMpixCwgNk3tS9Y/QqjiB9
         uYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745887445; x=1746492245;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=iXPliR5DyRI4eBiiPz6XZaRXZGhHaKGP+DLh/+1DmFBwfGasGM5GQndqBj21vboFgy
         U2cy6R2Mg//WjdCOSG5mxZz6IJOB3cIABM7oF1KxAqHWB+XmOIEQFi96h3dKQTQYMgv1
         GkJFr/oNxPC04tiPz/C2rj9h4C02R6/e8OJ20fv0cCSSw+DbW+XlwuFmgkA6St/Fj4qB
         H8dwO1+oFbGQtkYXzq6i/8POq7SGe8CqqMHsNmbOyJkbngcBACTPm/MUdDbwzOAvVO8V
         UqXTg9bJF9ki1u91N3oyCVg4S8ltX4FEZRGkPxHoFnJZYl0BkbhSy8cDojtgd/Fjh1ML
         8ekw==
X-Forwarded-Encrypted: i=1; AJvYcCUe4ACH92H8aG3cDtttThwQpG3EUOlu/jxMqdLml3+WGC/LUlyS8n6+xq+mSgnW5avgbHx46I3hDrdGoA==@vger.kernel.org, AJvYcCW2Qd168Y9gL2IGesQqkhovkUsfDa8ar7b0PW3iJ30PlEe6bmlgvR8H5Oumc29+UivmxW7SZnsn7yWY/w0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ0qmYpbJTmaXJfW/fh2FFH0APKKzP5PcePTV/oDJXm2j1ugXe
	rdw4XiH8i0JbFg7yS9IlvgAZxOfQSYHm35Kt/MGywows5ujh2bK4bAMnpjgD6u/JxtpXAX1fvMR
	MSHoEg99ChGIcBn6BV+Ik+CHq6Js=
X-Gm-Gg: ASbGncthyEJBDKJJgd0SpTuiqWvM1Zlx60eUI36aNWrypTY2Vlwu2UoRWRIpkjLOBVd
	lV18KI1Qg+DtSNlRRf2eWiWYpJDW6V53KUExdKpMeK4WV0qumRan6xlaeUhsA7uXHPZVpkPceLH
	8TbwAEAfffDzOQj+OvuOiu+Q0=
X-Google-Smtp-Source: AGHT+IE1horbkXJTz+oXO9Gw3xSvUtiIJNCav2lHKepZkhdFBJ1yeJLzy1rjntMhNDRdwdeRwMcW81760WwbHvcqsKM=
X-Received: by 2002:a05:690c:4d4a:b0:6f9:8605:ec98 with SMTP id
 00721157ae682-7089974d68bmr26482537b3.28.1745887445360; Mon, 28 Apr 2025
 17:44:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428171625.2499-2-thorsten.blum@linux.dev>
In-Reply-To: <20250428171625.2499-2-thorsten.blum@linux.dev>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 28 Apr 2025 17:42:11 -0700
X-Gm-Features: ATxdqUF9GC7wWJP216D_ZMgCXVqFYDpPGAHu8IIcoESCKPs8av44v9fuKYKUbY4
Message-ID: <CABPRKS8m5YLcGPnN-TWYR6K_VsDQnWv82pzQmnd+bsm9=4GrKg@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Use secs_to_jiffies() instead of msecs_to_jiffies()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	Justin Tee <justin.tee@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
