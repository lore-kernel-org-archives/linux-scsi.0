Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pXIHZx2n"
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEE0D3
	for <linux-scsi@vger.kernel.org>; Tue,  5 Dec 2023 00:15:05 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-50bf26f8988so2772011e87.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2023 00:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701764104; x=1702368904; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFh4sreB7l+0wd04Jel4MZuihX2/fKdzWhKfHhTeeVw=;
        b=pXIHZx2nbfO4gIMwysxqUR9CIHn4GxE228uzfRtGcQ2EqHN1GvPYPtmiuFJYokqQhR
         w5Of/cULDnyWmS8C12GfK7+QlHeXwvIu2UZNmiNoXDVRAtJfXv+AhCqzUQfudKTI5Spy
         eBB/WLjXk8FG3XtVRNDz/T7fld/83w1b86SpCJMmu267k9dhTmztU9HiMvSfs5c9fjqy
         6U/La6Y8q515wjI3769ASYDjmVdmr3nhgaPCEFDJUNsVBllNcxhC7uvZ5Py226IhiGpk
         hrgvR/xm4ADhrOb6CiwC2q1cFeBzifqEvX6CcdBCCVmY6639Yrb0Ov3bmV+3DYxCiayV
         WlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701764104; x=1702368904;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFh4sreB7l+0wd04Jel4MZuihX2/fKdzWhKfHhTeeVw=;
        b=lkFMp+sS1UyWqT/cQK18X8vnCuMRunB+wPO0v0RMZ2ivByISW5D5JlF6dHHQqdy8Lo
         Usb4FjYhhoc2N/r6n/ndUzAG1xMl9C7YC45mWf1DyrnQcPOUwfsTUG0iToe19nvQSEss
         v/VUyRPJQHt4jz5kEdXnjC2wa7aU6qNpslrT2762QkCMiah1SI0iRMQpZeH/KGwa36WZ
         5i4NKJ0XbJRtMMFrQBRZ2asXxyS5IXmLkSOool7r9aqmQCC1a8EMpm4hTFridgDLbjVq
         mMVkYL5ZF4e9vGXUXkVnMmOyAJiDt9V/47Do+N3ONLjfdrVqLTdUq9o26xeoTwSA5BSS
         RbNA==
X-Gm-Message-State: AOJu0YxI1wVz0/PgHYOOQJ9CP/S48uoK5AswRwT3w2AbIUXUx6+bXA+N
	//rcJNmBQj+044wUzH4RY2h+pQ==
X-Google-Smtp-Source: AGHT+IGzRT2leBvSAXHabDcfWrzEL2wM5vzp5If5hcLSzCa8FvgjWo6PPGInNRrJoP+FYKglqPD/pw==
X-Received: by 2002:ac2:5629:0:b0:50b:f0ab:6d73 with SMTP id b9-20020ac25629000000b0050bf0ab6d73mr1610310lff.124.1701764104036;
        Tue, 05 Dec 2023 00:15:04 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r12-20020a05600c458c00b0040b4b66110csm17775792wmo.22.2023.12.05.00.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 00:15:03 -0800 (PST)
Date: Tue, 5 Dec 2023 11:14:59 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Su Hui <suhui@nfschina.com>
Cc: hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: aic7xxx: fix some problem of return value
Message-ID: <8fb66471-9131-4990-a622-461f5735120f@suswa.mountain>
References: <d37560ef-d67f-4493-a7bf-1d192ff7351d@suswa.mountain>
 <56b21cd8-7634-895e-6610-2a087ce8fc13@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56b21cd8-7634-895e-6610-2a087ce8fc13@nfschina.com>

On Tue, Dec 05, 2023 at 11:33:36AM +0800, Su Hui wrote:
> On 2023/12/1 15:53, Dan Carpenter wrote:
> > On Fri, Dec 01, 2023 at 10:59:53AM +0800, Su Hui wrote:
> > > v2:
> > >   - fix some problems and split v1 patch into this patch set.(Thanks to
> > >     Dan)
> > > 
> > > v1:
> > >   - https://lore.kernel.org/all/20231130024122.1193324-1-suhui@nfschina.com/
> > > 
> > Would have been better with Fixes tags probably.  Otherwise, it looks
> > good to me.
> 
> Hi, Dan
> 
> Sorry for the late reply.
> 
> I'm not sure if it's worth to add Fixes tags.
> These codes are very old which come from "Linux-2.6.12-rc2".

I know some people use Fixes tags to point to Linux-2.6.12-rc2 but
other people don't like it...  Or they didn't like it back in the day,
I'm not sure now.

> It's seems like a cleanup or improvement.

It's definitely a Fix.  It affects runtime.

> 
> Umm, should I send v3 patches to add Fixes tags?

I don't really care, I guess.  Probably yes?  Not a lot of people use
aic7xxx these days so from a practical perspective it's not super
important either way.

regards,
dan carpenter

