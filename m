Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951462E228D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 06:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763446651; cv=none; b=HtfuE9Ycx09It5rgnlz35Nn6eMEgjWiWoNbKOSdFCoxAIYNDmkHuznu/00ThK+h8+WHxlARRZjkeW6GDKjCIQ2mYRGNdiaA+0SAhCUDKCWdY1ArUzGxFJcP7yhwkeSzhs57KglYCg4OhCtdUKN+XJnhM+gMK+JVSJ/HaFX9JEx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763446651; c=relaxed/simple;
	bh=/Hl0SyaQKq7MXxmBS18GDEuFsU+H8ICOxIkyP0l5OZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJBERJrhWjIRn62rft3/VDkrXoe4eIUtXQUQ1zBl9coNTApeBD+JuE/JjaFRlZkLlGzf0f8GKWP08+QR2JCQlPcWBMgYtoig8/ESFsmw8OKBqd4LanJy/PYCJ38X2WIZqlJeF/qCUOjLX03HGEufMed4zQvb6noqFLdD+V++xc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DhmQmLK6; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DhmQmLK6"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b32a5494dso2970603f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 22:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763446647; x=1764051447; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QhKA75k+Zw8gzay9nDZLfcMI74InQfiHryR7d9dLK1M=;
        b=DhmQmLK6AWNEsu7r05+MZ635VhN6qeYrE4d3TgvPnFc7dsB+PTnK0LW/oQD0jAi9Gk
         HWPcM3lyh+LNmPtNCpofdLt21D3GtDe4Gp4l/RTiXgOl+xHbmeZFHXVlATlT3f4mwNBC
         6Bf7t+MkpUkNv94vnml+P5EorrjMCKnMX/EPIJdroJKhBDmv2xBagb0Ae3o7f5up54w3
         WuPLiUgC93bb94CWlXNAf38w7snkPcpQgQTHTW/XEVnaZaCtZGVx5H/ba+B1zymN67vF
         uHgmPwRkGPf1AIdYlID5to+RNmprixTMJD5na/dsVWAtbxCoWhLWDOIZ6JIwF4XzIBX7
         68Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763446647; x=1764051447;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QhKA75k+Zw8gzay9nDZLfcMI74InQfiHryR7d9dLK1M=;
        b=IDEt+hYKj6gEDeiBrdQzD3XRip4SnDK8XXjbAbIPhsUlwKJmPL4HGa8ezDztIpFuLN
         ZUtR6W5U4XdDtEQRNwuLILBm4kdTUYsfrSXbs3aChP/06VB9dMnj69hGfHebJOnhkvt0
         NKhdCnHHlwYKycpq6UvmtuRR5mcVPAO14odCZtwd2NJOEeoUJGmYVnT5FEYECjZrKpMY
         jvpGh1aq40UshCgrSl5NLjce64xLuNC2L62womXDViA6PHkX/sfiKLNpw+7SFYPic0vu
         b1ucu5KLdSbrVBpssjVbZIwqm+b6GDeUGzZJA2XRXRIAOPktICEP7Eh6WuxA8m0X77Ir
         4B6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVDpdHUFRHv4/ABWaj3Y2dOpEX+GXwfMp8am7vYi7xKJjhnaiMV8HNrWmM0WhA34LkEfe9FgmsiLUi1@vger.kernel.org
X-Gm-Message-State: AOJu0YxCYhfglSgykGoVPBdfEMn6SUi7JCKcV0avRr1o+qMFUL5Idc8Z
	8PilPzHRdOdnS00qxjkTYPzO1fQwSKRRswmGOu5OPviymOXOOuaiqM3arNCT1o1d3KE=
X-Gm-Gg: ASbGncvwdXYJY3NiT6Q15gd7WHerhZzNADwozVq+APgb4R64NBNNbLPAmAvlDjJLH8x
	s8ZPXPZrJ/Yum4t+NC8rFeW+Q7zeti/IUXxHu4k7C9xKDYNAa4sCmQlsFX8kxLErt0mIDv4RDS5
	Os0PHl2gus8WWy8pq5nC2om0fZcOlKQM7SqUfyhW0IjhgXFq35x+bLkRqIi1x4GyXnrpaTBMXhH
	/0OATeoMIdt2sU4Hh8mpEHbKVEqZB36p7uH04Pv204fPSsZdrp32OPoR99/YTBnXA3XAz/KZBjV
	lNKHCsi0OS7D4WNgSyx74gI1OE7sAAUsbPlS7gCxVv12EcN663PMj/uZcQtBQpWlzriAQ3eJLGt
	iSkr3z+3ugtwB2XuLgXykBB7HwMFOYsNJzhAPAHMpsmTtV7VcUiUaNPYMdhzwcyXBYLon/MDMEz
	4ieMljLw==
X-Google-Smtp-Source: AGHT+IEHpZGS4hYZGqTOsvKogsPZXoWir9+8fCWoV/jfwArZND55RBtGjjXc5CkVEdyW6tfv9aqUsw==
X-Received: by 2002:a05:6000:1a8d:b0:42b:3746:3b86 with SMTP id ffacd0b85a97d-42b5938aab5mr15512287f8f.54.1763446646736;
        Mon, 17 Nov 2025 22:17:26 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42b53f0b62dsm30231845f8f.24.2025.11.17.22.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 22:17:25 -0800 (PST)
Date: Tue, 18 Nov 2025 09:17:22 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ally Heev <allyheev@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix uninitialized pointers with free attr
Message-ID: <aRwPcgDXSE9s4jKS@stanley.mountain>
References: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
 <6d199d062b16abfbf083750820d7a39cb2ebf144.camel@HansenPartnership.com>
 <f6592ccc-155d-48ba-bac6-6e2b719a5c3e@suswa.mountain>
 <407aed0ff7be4fdcafebd09e58e25496b6b4fec0.camel@HansenPartnership.com>
 <f7f26ae6-31d7-4793-8daa-331622460833@suswa.mountain>
 <bed8636bc4d036f4b2fe532e7bb4bb4b05c059fc.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bed8636bc4d036f4b2fe532e7bb4bb4b05c059fc.camel@HansenPartnership.com>

On Thu, Nov 06, 2025 at 11:06:29AM -0500, James Bottomley wrote:
> On Thu, 2025-11-06 at 17:46 +0300, Dan Carpenter wrote:
> > On Wed, Nov 05, 2025 at 10:32:19AM -0500, James Bottomley wrote:
> > > > > > diff --git a/drivers/scsi/scsi_debug.c
> > > > > > b/drivers/scsi/scsi_debug.c
> > > > > > index
> > > > > > b2ab97be5db3d43d5a5647968623b8db72448379..89b36d65926bdd15c0a
> > > > > > e93a
> > > > > > 6bd2
> > > > > > ea968e25c0e74 100644
> > > > > > --- a/drivers/scsi/scsi_debug.c
> > > > > > +++ b/drivers/scsi/scsi_debug.c
> > > > > > @@ -2961,11 +2961,11 @@ static int resp_mode_sense(struct
> > > > > > scsi_cmnd
> > > > > > *scp,
> > > > > >  	int target_dev_id;
> > > > > >  	int target = scp->device->id;
> > > > > >  	unsigned char *ap;
> > > > > > -	unsigned char *arr __free(kfree);
> > > > > >  	unsigned char *cmd = scp->cmnd;
> > > > > >  	bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
> > > > > >  
> > > > > > -	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
> > > > > > +	unsigned char *arr __free(kfree) =
> > > > > > kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
> > > > > > +
> > > > > 
> > > > > Moving variable assignments inside code makes it way harder to
> > > > > read. Given that compilers will eventually detect if we do a
> > > > > return before initialization, can't you have smatch do the same
> > > > > rather than trying to force something like this?
> > > > 
> > > > This isn't a Smatch thing, it's a change to checkpatch.
> > > > 
> > > > (Smatch does work as you describe).
> > > 
> > > So why are we bothering with something like this in checkpatch if
> > > we can detect the true problem condition and we expect compilers to
> > > catch up?  Encouraging people to write code like the above isn't in
> > > anyone's best interest.
> > 
> > Initializing __free variables has been considered best practice for a
> > long time.  Reviewers often will complain even if it doesn't cause a
> > bug.
> 
> Well, not responsible for the daft ideas other people have.
> 
> However, why would we treat a __free variable any differently from one
> without the annotation?  The only difference is that a function gets
> called on it before exit, but as long as something can detect calling
> this on uninitialized variables their properties are definitely no
> different from non-__free variables so the can be treated exactly the
> same.
> 
> To revisit why we do this for non-__free variables: most people
> (although there are definitely languages where this isn't true and
> people who think we should follow this) think that having variables at
> the top of a function (or at least top of a code block) make the code
> easier to understand.  Additionally, keeping the variable uninitialized
> allows the compiler to detect any use before set scenarios, which can
> be somewhat helpful detecting code faults (I'm less persuaded by this,
> particularly given the number of false positive warnings we've seen
> that force us to add annotations, although this seems to be getting
> better).
> 
> So either we throw out the above for everything ... which I really
> wouldn't want, or we enforce it for *all* variables.
> 

Yeah.  You make a good point...

On the other hand, a bunch of maintainers are convinced that every free
variable should be initialized to a valid value at declaration time and
will reject patches which don't do that.  I see checkpatch as a way of
avoiding this round trip where a patch is automatically rejected because
of something trivial.

The truth is that the cleanup.h stuff is really new and I don't think
we've necessarily figured out all the best practices yet.

regards,
dan carpenter
