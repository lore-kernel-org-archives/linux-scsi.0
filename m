Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895219AD93
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 21:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724708211; cv=none; b=cYoUrPCsKaB9ougGAu0waoxhd4HBxnAXHIvnYTLcNWJ2WLqaqC+FhP4Zq1EJOolqj2FtSyRuIiu9XsVXJ3PsnE3TlOmm6y4rVoSHqGQRM6uD8VLMtye/7RXC7mLx/1nXvnAVcd1pzKvBI9G8zimzDXF5195J3xI78c+pjy1qaBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724708211; c=relaxed/simple;
	bh=GYfQ2aJ6+j6KIn4wswZK8fwF1ipJKIXjPWzU4CXaGP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UgXdNy0IK1RInD5FDNrTGYw2ML7hTQ/RXTcmtsA055Ltlx5Zi8gvuZDRnHKhQ0SPEtYO+O3tdPUyQAaKiAZNsTlihF00ZbPp68PMD990tzgHuie3mp3nQ8xJl9ocusO0wDqh6L2WMUk2J4zSoITiwwZaZEZZkNaAVjEinvYUpCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B1/oPVTl; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B1/oPVTl"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5bed83487aeso5079491a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 14:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724708208; x=1725313008; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mrXFFnRr4yU7Etmc4wy+t+cJrIu15SH8enM9SvrbiKQ=;
        b=B1/oPVTlX+yDzK4bvCS1Z1YFot/1P1vFlrMY0K1oYiiPqx1n9mdMYYdJCRXZIirRVT
         wucPoqvTeGfHGZHpgmamx/Tw6oirfp+mik/E5BkIBhjZAm/CW3Awzbdj/nm+yPaxXblU
         FSQXjapPE/191djxKDsT5rJiyheOPkROHNT7ku2QNyCltlRrbHs2o0tOTr82Qnh8r1zm
         EHy09lz8VWtiNBI3seaQ6HsIiOJBn4T6oIMKYU7/6YKQCJmrUBJvYxbbZ94VknPiomj8
         5N0s5S+xV5MoEq3QO8CxzVRlVdbsvQoaOC620Hn3seCJvND+/pZ+1OKe9/wJwePMbrii
         On+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724708208; x=1725313008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrXFFnRr4yU7Etmc4wy+t+cJrIu15SH8enM9SvrbiKQ=;
        b=tzJn6qc5iqZ/7dTOXsQcmn0twfT3s7PPobH4eb1KCANlgxV1CDQeSjpWMwO6LCETL0
         7HG8mKoCrZnj4vhNzXyVpc4HpKdUYLhaSmG56h1Vkr+SGZueOsdvbP/dgOpdZLOnJefb
         OhCl792g+e/I8GOy9QMCQ4sTb3bneN4q5ZJJK1GL8gDEx0Oun0bVrOUjydPN2xpZu+jY
         xiVaxwOJN+1ayDqosqES05j8mVdfNTjgr732Lall2Bmq1KvH1kzPK4aHBuE/2EonMemT
         Qv8cxG/hNaHVUfhKm+lOW4mEdfNAO3vSkMTKmXz3Gxz1uE9a6Nn2i6mOJnX8971DUz6B
         KisA==
X-Forwarded-Encrypted: i=1; AJvYcCU7Vy+e1rgSJYMdmxdhyUPEXsxKEuC+pDyRCQ07Vj6VbH/kZ2JzId1Rt60qsQ9XWAkRreh9+jfIjTKQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzKa6R1vgz12QJbqnOSJAgxDVEzCLGpbxWavZZTQ70YyBhgSnnL
	6y2Zr9sWWh1OutluIK8dLWepD2jWwNH+Rw0DDykgtjGqTa3Dp3PF1niZBthfUGM=
X-Google-Smtp-Source: AGHT+IFDd3BFQ04/0ytE5hJOoHnNG49Q5+Iezc5rR48h02qI4ikRCEhCnfwG37487ZRj5/YBze6HTw==
X-Received: by 2002:a05:6402:84b:b0:5be:f1a7:c2cd with SMTP id 4fb4d7f45d1cf-5c0ba312cc8mr388408a12.31.1724708207427;
        Mon, 26 Aug 2024 14:36:47 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c0bb48106dsm218224a12.79.2024.08.26.14.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 14:36:46 -0700 (PDT)
Date: Tue, 27 Aug 2024 00:36:42 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: oe-kbuild@lists.linux.dev,
	"Martin K . Petersen" <martin.petersen@oracle.com>, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
Message-ID: <48a483e2-6a20-493a-80d8-7292c96aadcc@stanley.mountain>
References: <2d3d17c7-c3f9-4596-aa50-3226163242eb@stanley.mountain>
 <602421aa-d546-49c2-a08f-6779d3c0f9af@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602421aa-d546-49c2-a08f-6779d3c0f9af@acm.org>

On Mon, Aug 26, 2024 at 11:05:47AM -0700, Bart Van Assche wrote:
> On 8/25/24 11:25 PM, Dan Carpenter wrote:
> > New smatch warnings:
> > drivers/ufs/core/ufshcd.c:5484 ufshcd_uic_cmd_compl() error: we previously assumed 'cmd' could be null (see line 5474)
> 
> This smatch warning is a false positive. There are multiple code blocks
> in this functions that are guarded by if-statements. The two code blocks
> this warning applies to are mutually exclusive. Hence, the 'cmd' check
> from one block should not be used to draw conclusions about other code
> blocks. I will consider to introduce the 'else' keyword to suppress this
> false positive.

I thought that might be the case, but I wasn't sure.

If it's a false positive, then you can just ignore it.  All old warnings are
false positives.  People can find this thread if they have questions.

regards,
dan carpenter

