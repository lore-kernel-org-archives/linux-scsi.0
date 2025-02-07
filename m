Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68D240606;
	Fri,  7 Feb 2025 15:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738943189; cv=none; b=TZbFBhMzl2GIU3K+uOHvDmcwslK3DfwK9m42RDC+9vWZmta0vcS1CXY2jcboCOnkclanZOhC4PLhoDcwOChOLKJLnzFgAZmyk5+lK/tCLpDKPFRPrIg4DPbEkF8tc/Hi5fwfY6SQ3NjuLKgM65MjhGSeoEQHQYoWr6sq2N0IuIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738943189; c=relaxed/simple;
	bh=m7rdOWHmcb+xPyY4sSux5AD6yPcRJtWDJjxhXuJ0oB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LQJkDBe9conCo4oVA0X5hu33zGzT9wNNcSwXiyyshPQJ081nkrVsP+X55/pyjPnlkuDAO/HthuQ29aSqaJf77QBMe5BPl2TMQVBJ/w0Tk5UY4kA9SE95/aVh4SbXFaKhoc8uaXXW63aMOXMKgmiaHludtRGL26yVAK1J6uZ3bZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L890SniA; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L890SniA"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4678afeb133so30906601cf.0;
        Fri, 07 Feb 2025 07:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738943187; x=1739547987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6WEYNdnx+FiHzsZTOr5pP7gueGwdNGj0QScjPVTFYw=;
        b=L890SniAfK9mAbMzj36qq8QyA689xgKcqKr8yOIbwGudxE2zhvIRSGsf8cgcx6NthG
         aJmTe3UOCE+h45mj0gPtlCsZg8cb0ol5vqzuW6zSgkdn1uxBNblXuL8oQfrngzHxFBzl
         U+KW1AstB9hkKwX49QEXwkH1zaLHr5xkVA3qMH16wR+ceSc5+E9Pg3yq+O5SuyFQXrQM
         81es0wVP2dxqjpUmNVeIp/WnMt2+1JoNxZGJnPrFA2hXcF/teWJX4emv50RRsBsz7ooh
         JDOXfIoOSVl5F61374q0WraC8VKHdtddbj7MBrtN8tJufPhaEL8hMsbol8/oNB36kbAj
         PGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738943187; x=1739547987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U6WEYNdnx+FiHzsZTOr5pP7gueGwdNGj0QScjPVTFYw=;
        b=o8/Gz8QU7PADtnfbHTVMtSxhpJhBTKZJFQ2jk1LqhGESBaw7HHJVfoRkron6Hp3U44
         PUeFQeQYpoPhv1d2LzUOQcbf6nGBvlOemfF5MuQ7Xcxt1PW6Vf9V051iW3mpOvDHaCO2
         0dvxWMhCAzvnNydoSPDtpJYbrpr4YubU40NP3pLMesq7mhvFPtIBsfhUFUKRY4yJ/lpT
         k9mUHYfVV9Cs648Zu1wIJLGpuulLrbAV9oUTsnE8hhJkCL/gKKcC7CckvOwZG5+exlVS
         bCq7ycytOxtY3x7NXN18zLtjK5dD+kt6yJtsFPh0sf+wBDWC5bQmJujGyYVfC/AiL8mG
         zRsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUF1pZlYISn7mZ/04cnUVDyEE2duTMfJnW7hmMvVQdYI5gzKnvmPnXDxO3rOa0tqFbLXGgzHfvB/ruk/g0=@vger.kernel.org, AJvYcCX7huGC+3mBzxOJdK5saZ+nzFIDS6wgAhZj9x+c96I0u/ZF6JdQltUNXavoGSLSWCiPiHq6hBjg@vger.kernel.org, AJvYcCXB7ws34R4S/2EypopNWEMG0peNlBdA6WH6wOImxnzxFus44zlaFZOgYbZ68qNn0bQK61QOk47OC0Fj4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfUDbZeIOTnA2dt1j1MjQzf0DwV+NJDPCojslMr44mtiErXljP
	6S8+ePJ2YJ7mFhffGwqefpiE3ZPkynhH6TGzzyg4P/DEuEQfHUITT7pkaWWCLTp26RD6RYLXZYt
	9g63dNLU+Ul6cJ5OA5BJCByR+35T9hg==
X-Gm-Gg: ASbGncvhie37mnoSBS4fE+yuWrusHpccS5hETTHVpmXHTOShs0tZs49l7EA8MHONpPh
	0WLjbfy6f3clL3egOc5dIyRPF0aAv6mEiK+tbXpLc9/tL3aks2DqUlh3lABJgyPDKgUt4AM/3
X-Google-Smtp-Source: AGHT+IElm5my5xTJ2v9nE1Ou6jzXXlg/X/CAyfb4gsv4lvlsqDHo1xjhuzSDFN1RF7YLIoGkd2njQyQDkWiCCwum/zo=
X-Received: by 2002:ac8:5d0d:0:b0:467:7076:37c7 with SMTP id
 d75a77b69052e-470337541c2mr113267481cf.22.1738943186829; Fri, 07 Feb 2025
 07:46:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2025020658-backlog-riot-5faf@gregkh> <20250206192000.17827-1-jiashengjiangcool@gmail.com>
 <2025020721-silver-uneasy-5565@gregkh>
In-Reply-To: <2025020721-silver-uneasy-5565@gregkh>
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Date: Fri, 7 Feb 2025 10:46:16 -0500
X-Gm-Features: AWEUYZlnZYiNZLhyAd6W1RYOSMZAjrBQEddA7-XZNq349TO23dSwfJVbvszfXPc
Message-ID: <CANeGvZX8F-TGn0tfuLqUMFN89aepML6mtAvvSjRJyysvUDzGhg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: GR-QLogic-Storage-Upstream@marvell.com, 
	James.Bottomley@hansenpartnership.com, arun.easi@cavium.com, 
	bvanassche@acm.org, jhasan@marvell.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, manish.rangankar@cavium.com, 
	markus.elfring@web.de, martin.petersen@oracle.com, nilesh.javali@cavium.com, 
	skashyap@marvell.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, Feb 7, 2025 at 10:10=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Feb 06, 2025 at 07:19:59PM +0000, Jiasheng Jiang wrote:
> > Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
> > used/freed.
>
> "Potentially" being freed.  It will not be used.  And this is only for
> an error path that obviously no one has hit before.
>
> Please explain this much better.
>
> thanks,
>
> greg k-h

Thanks, I have submitted a v3 and added "potentially" in the commit message=
.

-Jiasheng
