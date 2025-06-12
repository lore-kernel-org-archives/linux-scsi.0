Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E621C226CF8
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 08:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749717573; cv=none; b=gA9HZW8m9wa982AJ06m4asHGp1Tb/V7cka44wZshh6xmup++j2tg+IEc3xBwAxpJoseOWMVoIVXl735++bBEimQm9LJ2l5XEQuUWk0uvK1eOC2UkGdxNojo558IyHiL6o5XQ9XshOubFZw84gYcXpU1dINYCPxdBmwMfnrhpmEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749717573; c=relaxed/simple;
	bh=hJ7X/tNOTl73bwX25xhIlJdNu9sTqCaD1Ms/vj4d5r8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPAnT5NG2v74HVOZJzUWKPj9rEhTS0WuRhpZcdb9TA9HaKQ3knmfA6w3vwatcHVY1z0kNoyHRwq9BTSvwK3EIxZBkFgfsQ0VH47s4w/NweUijBZD30+/EOmmi+OposU4XImRW54+QWS07QRPBbzMg+b5tWD7Pcbbsdn76ojXbLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f6HpwNVF; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f6HpwNVF"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a3798794d3so766013f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 01:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749717570; x=1750322370; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMn86gBGFQBElUD4C04aCEWWj1Sy8fLs55GPp5ijFjA=;
        b=f6HpwNVFfRi6W2Sms6MVNsmZYI8KveHZfl5sXNiONtB3sWnyVSGfRsYBZTYaCAhKHS
         ow9wJHssthE1f/VBDrhhCvzvLJpgdxwdcPQ4hsd+rOMAkPPTpKzX4X+tzcK636E2lwDc
         jd8hF1Zx0dpZcHRNNRvRrl7dXNWfyVu4tdI47FliadoQX2UoRhBGLT0pRe54aOZZp4Nr
         /qmJO86dAlFVhMP2YP5q9V5VOefgEry+/t6ZSO2lUrGzJ832ddopLSwIfnNU2RLBc0ED
         8TROy/N9a8W7zpmJWHf/SfccoGJs1Z96uOA/OK+lDTI41JBkfAH/nQa/xNrFrpz8KKz/
         lNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749717570; x=1750322370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMn86gBGFQBElUD4C04aCEWWj1Sy8fLs55GPp5ijFjA=;
        b=vwZGcd/gLPsxrUmzXTpsTM1zu9c8z1a0yqCc8uJfLCMoibizKMwz0yR80hw9c+YZ5O
         BmkGQw1D6x9su+GFiUoMmerTg8+MGB/ODK25ZY6RQNLFjiWFvypNLCTv5y1fphmMdUNL
         rIN9sbfGoWtoMMKW8O35RteLgEpwdoYpPrIGbtsJfLPytezuh9QV79ISsWulfAwdx1ij
         K6WyBJjVLNcmTptDsCJeFxjX5q08z0qwgivqxzD36/HZTUF4w9I6S+NDfTxintREymCQ
         e4VKjHj+kor9iEgm7XMT821v2jhNxo/F2/G+cyzuvyZYdW2facnEAHECbPpBP+jM14dT
         baag==
X-Forwarded-Encrypted: i=1; AJvYcCXMp/TQzvLyjdz1BEw0dug893KdPQiJoGj209sTY6SEYbYMwJDWlRFqYkFC7yQwwnj3m0GyWMbzMsSH@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq87VVD/cAFiGPfqB7cpyeU03zJqMxzsArVpD5L3tZhp+sbUjr
	8GgO+/IzQVuXnt5vlkZvClwHqhBfilpt/acelqGcg2Zu4SgTNzf+bdNsMuB5PLhZvDA=
X-Gm-Gg: ASbGncsIG0X02S79kXMFqaFsj9QUDWvBY5/T6gfQW6C9Ys8c8LZZU/5AJJvMUy2plqR
	XmG+8l+nE8c2lSSlmxVNqzcW47aSL3KbFyI4Lw8WktqsXAaWTsLvFa+Ov23lSlA9UiGBKi6ZPIx
	UrtmUBsWiFx+Uzvh2Q/wSzKI5ph3coZOrqABbEZ2CWWBl5M6bBp7BBUp6+9H6VfdYBHF7x1jUXN
	EkYr42qKqjWrosCJbQaxMKYSPKmezNfUfF3aZCCv1gB1IwbxYDIEeIQ/csbwDZrQb4lrg0QuH/O
	2DiIC0tYvQ/b/TdwJKqnNcdS7+rfe7kFw5VldtgI0z09noGu06M4E+wfjALYpvflhsQ=
X-Google-Smtp-Source: AGHT+IF/U38N89Oos/Ii+uKueDvpQelJtkG4+ZSkUxRWatEFCL62scczRT/E2Bk0UmIqZpbCKrbN4g==
X-Received: by 2002:a05:6000:178a:b0:3a4:f038:af76 with SMTP id ffacd0b85a97d-3a56130bf3emr1772951f8f.53.1749717570107;
        Thu, 12 Jun 2025 01:39:30 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a561b4bb17sm1299122f8f.68.2025.06.12.01.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 01:39:29 -0700 (PDT)
Date: Thu, 12 Jun 2025 11:39:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com, revers@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler
 when FDMI times out
Message-ID: <aEqSPahh0b5h39J0@stanley.mountain>
References: <20250612004426.4661-1-kartilak@cisco.com>
 <20250612004426.4661-2-kartilak@cisco.com>
 <aEqE5okf2jfV9kwt@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEqE5okf2jfV9kwt@stanley.mountain>

On Thu, Jun 12, 2025 at 10:42:30AM +0300, Dan Carpenter wrote:
> On Wed, Jun 11, 2025 at 05:44:23PM -0700, Karan Tilak Kumar wrote:
> > When both the RHBA and RPA FDMI requests time out, fnic reuses a frame
> > to send ABTS for each of them. On send completion, this causes an
> > attempt to free the same frame twice that leads to a crash.
> > 
> > Fix crash by allocating separate frames for RHBA and RPA,
> > and modify ABTS logic accordingly.
> > 
> > Tested by checking MDS for FDMI information.
> > Tested by using instrumented driver to:
> > Drop PLOGI response
> > Drop RHBA response
> > Drop RPA response
> > Drop RHBA and RPA response
> > Drop PLOGI response + ABTS response
> > Drop RHBA response + ABTS response
> > Drop RPA response + ABTS response
> > Drop RHBA and RPA response + ABTS response for both of them
> > 
> > Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
> > Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> > Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> > Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> > Tested-by: Arun Easi <aeasi@cisco.com>
> > Co-developed-by: Arun Easi <aeasi@cisco.com>
> > Signed-off-by: Arun Easi <aeasi@cisco.com>
> > Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> > Cc: <stable@vger.kernel.org> # 6.14.x Please see patch description
> 
> I'm a bit confused.  Why do we need to specify 6.14.x?  I would have
> assumed that the Fixes tag was enough information.  What are we supposed
> to see in the patch description?
> 
> I suspect you're making this too complicated...  Just put
> Cc: <stable@vger.kernel.org> and a Fixes tag and let the scripts figure
> it out.  Or put in the commit description, "The Fixes tag points to
> an older kernel because XXX but really this should only be backported
> to 6.14.x because YYY."

But here even with the comment in the commit description, you would still
just say:

Cc: <stable@vger.kernel.org> # 6.14.x

The stable maintainers trust you to list the correct kernel and don't
need to know the reasoning.

I much prefer to keep it simple whenever possible.  We had bad CVE where
someone left off the Fixes tag and instead specified
"Cc: <stable@vger.kernel.org> # 4.1" where 4.1 was the oldest supported
kernel on kernel.org.  The patch should have been applied to the older
vendor kernels but it wasn't because the the tag was wrong.

regards,
dan carpenter

