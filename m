Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A626130E57
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 23:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712273973; cv=none; b=JZtFHXQ+grj5K7ejzXL5IJn3/69QE/56KdzjCT0FzyYh3S2lLTLT5/XP3zontdoBPjTk9tRDLBs+WBjgNhr0oWnO8JN7ivM60Mr3VwFikVnf4Qs1D2QIeyT4bORWXMBTwTSLuQ7TfiqmumX/nz72g1Av8L9OwqTDkk4M/1ncDQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712273973; c=relaxed/simple;
	bh=QYbbCU0SQARatLZqlao9xJ+TDw07B10p6xR2XEzNZB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UquEdmL0ktGkAayRPdJ+PoK5n8/4JLYK1reKxlHGUT+LKN3X8NyoqSrUFbe74nssjVJFSYu75n6EiN6zRSi1AeXnbjz7bzZDgxt4+vQoxsRml4xk6z3J6iGhzz455Lt+Vc1XxbJSHTfUm081RjfvbELBxmHKvhjYgb9lQ0F2KNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cVIuYPJ0; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cVIuYPJ0"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e0878b76f3so13784015ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 16:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712273971; x=1712878771; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AFv7mZmZISpzKwRDuOvVk9+jMsMN4xkOpAGQx3CjAcA=;
        b=cVIuYPJ0zuDE3Rl6/uvXslZRFcH1/3Lt7YTjPt/Ci/efB59OaLuIeqaLrbMdCYuSla
         AoPpqxU9ET2l3DE5hqwPtVdLtXNj/dfVzgwPOAFbqgnowKCKFVivGn0A+FheJLd6XtJc
         +FzprIiaeS6oKn98bfJy8Rt0JCQxQAIfz0KgM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712273971; x=1712878771;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AFv7mZmZISpzKwRDuOvVk9+jMsMN4xkOpAGQx3CjAcA=;
        b=hAYu3wUYnYYRjmoDmGSn46qqySXt39kKZiY/USbBGSR/4Xw8/mqppsR/o1WZPVALrm
         nJ3phPkS6yKyrrms7uPMaJ02CNFjpNntROA6MQILdprE2kkfJWKttJJvIyuwdYn+SGFb
         6mcB42T0W94bi+sABT/A4/ZYq/CBJS41LIc9OtK5hb8xTP4pDqECT7flcHDpG35Pnyvm
         Ekbi1/ANOS4XBPf9DewONFFPyKFd2ZOYAkwSFe6sqcpSZcip7hLL1diiMVNcTKw+NEyK
         PCFDeiZV0VQtpySWxModr6tRTSmHSBLBhNxb0nkeZb5r8FGWBPwJz7FcfPIZibeC5dLp
         zGWg==
X-Forwarded-Encrypted: i=1; AJvYcCW8oYDzTt5nJ2uZHR/WGc2fJ9C0rkki3gYBTonuBlFXB0aW4qDhtfKe7M+liUswU4wi1HNpbf1IexfFRDoc5SBgTbs96XUENsypfg==
X-Gm-Message-State: AOJu0YzvmU9Y747YDmTBGgnl+OTKWjL5G4BPZAzuBao3lhJWC3sSlIHH
	R79k2OoFHZDsSTkjWkxosuXpGL00RoBFG19cwIiBm1Q3EUdjbYyar+GeUvDHyw==
X-Google-Smtp-Source: AGHT+IG0GcvAePt5bFrKtALW7aNTI4XlcZHiO5rGhAnnyQeJ4dEVUHdwqmTqEofEJH6G3srEJuiYqA==
X-Received: by 2002:a17:902:eccb:b0:1e0:c0b9:589e with SMTP id a11-20020a170902eccb00b001e0c0b9589emr1262039plh.25.1712273971497;
        Thu, 04 Apr 2024 16:39:31 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id kn11-20020a170903078b00b001e0eae230f2sm193824plb.151.2024.04.04.16.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 16:39:30 -0700 (PDT)
Date: Thu, 4 Apr 2024 16:39:29 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
Message-ID: <202404041629.D23DC8F7@keescook>
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
 <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
 <f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com>
 <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
 <CAFhGd8r1gGCAbsebK-4fD+cPeUCMgUG_XTx5fKa3cqJwNEEM8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFhGd8r1gGCAbsebK-4fD+cPeUCMgUG_XTx5fKa3cqJwNEEM8Q@mail.gmail.com>

On Thu, Apr 04, 2024 at 03:47:05PM -0700, Justin Stitt wrote:
> Cc'ing Kees.
> 
> On Thu, Apr 4, 2024 at 3:33 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > But additionally this is a common pattern in SCSI: using strncpy to
> > zero terminate fields that may be unterminated in the exchange protocol
> > so we can send them to sysfs or otherwise treat them as strings.  That
> > means we might have this problem in other drivers you've converted ...

That's why we've been doing these one at a time and getting maintainers
to review them. :) Justin (and the reviewers) have been trying to be
careful with these, and documenting the rationales, etc, but this is
kind of why we're doing the conversion: using strncpy is really
ambiguous as far as showing what an author intended to be happening.

> Correct. Although certain conditions must be met:
> 
> 1) length argument is larger than source but less than or equal to destination
> 2) source is not NUL-terminated
> 3) sizes known at compile-time
> 
> I think fortified strscpy needs to be a bit more lenient towards
> source buffer overreads when we know strscpy should just truncate and
> NUL-terminate.

Okay, so the problem here is that the _source_ fields aren't NUL
terminated?

struct sas_expander_device {
	...
        #define SAS_EXPANDER_VENDOR_ID_LEN      8
        char   vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
	...
};

struct rep_manu_reply {
	...
        u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
	...
};

Okay, so struct rep_manu_reply needs __nonstring markings, and the
strscpy()s need to be memcpy()s.

We've done those kinds of conversions in the past; it just looks like we
made an analysis mistake here. Sorry about that!

-Kees

-- 
Kees Cook
