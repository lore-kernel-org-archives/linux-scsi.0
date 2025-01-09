Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FF1214A9E
	for <linux-scsi@vger.kernel.org>; Thu,  9 Jan 2025 08:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736411045; cv=none; b=a2A/wcrNV2LXYTwETNzT1UJzXiXsdeLQkAw8eENx6XfmT6+B4qK5oEy6MACoUEPPSYn1I43qL6FvqtJzC7xuWhcSnpeY0VIxgricJaGGmfx8v+Swz0TXs3V4qwMVn8JdwV2p5GltBydmYsR6sYieHc4L+VZR3iGnEeID9RQOwoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736411045; c=relaxed/simple;
	bh=MSNeJz0Huk0TwBc9UgkNVtHhKt8LAnrEFngU8OXJr5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7/6adzimzx02RM/vc69hO4P86odhZ+WpjkEjBPB6om0n01fm6r/XmaZwlRlV2gpaQoFUGxBSSZNp6iy0KQby2OzKrFjjjueOqTI1KP+vPZ3ymnArrF4dynntB17nKnLmF8OLsEqo7GfU/TU8hvFoqbb/fq0gT3R1RjXJSrr8b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CRWSh4Ly; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CRWSh4Ly"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361f664af5so7930655e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jan 2025 00:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736411042; x=1737015842; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wnm9AGLch8GGnjS8vjcF9yN23+k8ZR+kh6vr2nGpBSE=;
        b=CRWSh4LyQPPVK7/dC66CiVWQSFws/gzm7zdV1h9VQedvSIVjX2fEXIIEObaNkAKpcH
         rQZLXJjfYgjOnd3/kY8VFNr3BfqPqPOpz3EIJ+RKDxDY5j/FMVQ6ziWegBePKKbNOp2v
         k2qrMGjvGMGklVJUCWnhIpqUlVZlS/JuMH1hoHfXn0P0S8jzxoTQ3IUjZFcp6CPB+wv9
         B1qTcaFF8FI8mrPg4TbeQU/m5HuhRd+lZnvM8R2G7gkC5+IsvtxISxENpvyOEW5YeaGb
         9VOgqKutifod21FEr7OJ4xhjfwSjgWvhUvP6HkAam6whvLC4620FMLhBIuW8dW4ZTVRB
         4WuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736411042; x=1737015842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wnm9AGLch8GGnjS8vjcF9yN23+k8ZR+kh6vr2nGpBSE=;
        b=UXavZDrfTan5eRM4uhMFPSrfD8r+7e0BgvshIyOLpxAsXdpyCJZSURuH2JfcugRExM
         kMZlUfuMaYJPL4bIPf6gnmRztauSx3JtPTd0+eCf46VOzhLn64wVy5mHhja0/2HwuM6X
         h1/SPl5y/o1/4R6CzuYhxUOu0ZmH/gfTzNgomLGN27m95qauuLT4ETLk2pDXZ6RGnhnC
         fEhzdw8GTBMdwufiXUqq7A8JyBhWMQAs50ayUy/v2cODoqAD/qBcQIQdKFsKnKK2PxBN
         2Kv0o107pffntF63fVml75e2nlZaeW6q9zNkNuGokX0zy2O+26ilj2Meaz7BjrwVoAoe
         aMfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw1FInFCsRSKVmjFl05EhyxX9T4McMpHImtDmpf6Uuh+uXUKczBBiEQjO6xfpxZCAiMHjION9KLUkW@vger.kernel.org
X-Gm-Message-State: AOJu0YyzffZbL/Zd2ya8XHHKkFnuGlBIBi0neUSKvL0ge11lTa8Tvo9s
	tqitc2OH9+Lv/boElFeEK5hrYVSrWeNVlY/1Mm8teA1ol2j9QeDYA0l9pd9l2UM=
X-Gm-Gg: ASbGncsQRGSYR+ZRqxMDWVmEkrGKDy665liYGcseDXpIYBqSTMsszVT17FH27jjdV5E
	a2OFGC0R1IWez+ehg5tTVM9V+C2f4rxnynBZMpB+2m9LRhmGfF+YrpxiTS9q5rCuNVL6ZXSKe6J
	UdvIwVm8wi3l4gkhER/ioWeO2P2M1xokp9aO8ZnbzSyXPy3hVq9fMXDsJsO6u92SSN52xZQNhbp
	KIKwk/189E46n3liI4N6poR5caCXzQ2qIhsPApFyW2AoLfGlXhrGccXig46pg==
X-Google-Smtp-Source: AGHT+IFXxIVAxLIFeBFbzLzNfGVQf+g061dbMsI4fjb007gS4h4MqquBvkUhUoB4LhJUgqbIT9D6vg==
X-Received: by 2002:a05:6000:144f:b0:386:416b:9c69 with SMTP id ffacd0b85a97d-38a8730465amr4810178f8f.16.1736411042071;
        Thu, 09 Jan 2025 00:24:02 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38378csm1115761f8f.25.2025.01.09.00.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 00:24:01 -0800 (PST)
Date: Thu, 9 Jan 2025 11:23:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
	"Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
	"Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
	"Masa Kai (mkai2)" <mkai2@cisco.com>,
	"Satish Kharat (satishkh)" <satishkh@cisco.com>,
	"Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 11/15] scsi: fnic: Modify fnic interfaces to use FDLS
Message-ID: <232ddea0-3c7b-45c3-8851-566118a893e3@stanley.mountain>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-12-kartilak@cisco.com>
 <9d458a93-c2bf-4414-b050-98631fcdb1a3@stanley.mountain>
 <SJ0PR11MB5896C6D97A0A738C7B67EAC9C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB5896C6D97A0A738C7B67EAC9C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>

On Wed, Jan 08, 2025 at 09:40:48PM +0000, Karan Tilak Kumar (kartilak) wrote:
> On Tuesday, January 7, 2025 5:18 AM, Dan Carpenter <dan.carpenter@linaro.org> wrote:
> > > @@ -1236,8 +1286,10 @@ static void __exit fnic_cleanup_module(void)
> > >  {
> > >     pci_unregister_driver(&fnic_driver);
> > >     destroy_workqueue(fnic_event_queue);
> > > -   if (fnic_fip_queue)
> > > +   if (fnic_fip_queue) {
> > > +           flush_workqueue(fnic_fip_queue);
> > >             destroy_workqueue(fnic_fip_queue);
> >
> > I don't think this change is necessary or related.  But if it is then it
> > needs to be split into its own patch with a Fixes tag.
> 
> Thanks Dan.
> We believe it is necessary to flush the frames in the fip queue before cleaning up.
> We would like to keep this as it is.

The issue with the patch is that it should have been split up into
probably five separate small patches.  Each change needs to be considered
on its own and explained why it's required.  This flush_workqueue()
change wasn't even mentioned in the commit message at all.  I don't blame
*you* for that because you didn't know but someone should have told you.

With regards to flush_workqueue(), I have looked some more today and the
flush_workqueue() is not required so this chunk does not need to be
backported to -stable kernels.  But if it had been required, there is no
way we could have done that with it all mixed together with other
changes.

I think there is a tool out somewhere which complains about code like
this because I've seen a lot of patches removing the extra call to
flush_workqueue().

97d26ae764a4 ("bcache: remove unnecessary flush_workqueue")
fb4b9685779f ("EDAC/wq: Remove unneeded flush_workqueue()")
d81c7cdd7a6d ("net/tls: Remove redundant workqueue flush before destroy")
etc..

regards,
dan carpenter
