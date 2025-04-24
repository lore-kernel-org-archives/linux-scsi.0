Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6ED221275
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2025 09:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745487855; cv=none; b=F45DT9xa784QPPe/TdDiarM0qKCr369xqDZ/YjYzHm1U6fWkqR1sHRBZCshTf1EwuEQHiNNI6TAhEl+h6PWKkwQNQC0saqnvNJ00GRd1tfZc6XO5fVBNyGR96tXE94qyiQX01QFrUvOR5skoj5ArVVnaIPECzLqPJEytVLvE5lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745487855; c=relaxed/simple;
	bh=MwdZHCqoOa7UC1GRiFLqeRXN+akYsh2GZzlGgx8yQhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9pFzgELbHgg2x1SBRWhlVWNhF9j8Vb3UdWJ6okIbEeGn4SMfINPTDvF0CNiTBSRejDJAZDO4SK7cl+OCqfs+UYwAVVwIhaTb+VjksRk2fYWSiuMooxqjGXluTFjv1xq/43f2OIJFSWVmpGDsfGYsEA6M5vrq9X3j7Qt6iKXHwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=H7dXEqnq; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="H7dXEqnq"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22da3b26532so7518725ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2025 02:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1745487852; x=1746092652; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i6Sm2Sefq4TT11w/sXp14WqAq4etg6y6vhDyNnpKZvo=;
        b=H7dXEqnq85UBG1ZLfq/XMxX2x04/qFlKc0luv+n52Dslafr/VD0o2zn1cDWRgHzey4
         Z0JR6JwBr6VBqrRIK1EQriDbmhhaMZCtv9BaSaH8YGGVpcQo4sJRwgVj7yF4oAArqbJq
         +miyHgRFvH3nMTLLZRgwhGCdg+wrz4go8qhvZz1iAoXCaJY02NLBGn1L2PLz2A6icB8Z
         2VI+YQin1N1+uZuBEHU/LAcwgMAXLVnggOmwzyIKMMgoxOKpqIitFEFXHJIdy30hj/Dv
         As+rC3QDDfrZ6imvjbvy9rdKtlLZSbR8VDDCPr7/nl4KUE66JqclOLiRzHOLaiho/aQe
         pD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745487852; x=1746092652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6Sm2Sefq4TT11w/sXp14WqAq4etg6y6vhDyNnpKZvo=;
        b=oQyXrtmMGlE5itzAbrl4eeDetv2tP+mriJ04YhLjnBrBYkDuIi6Q/8gjdOw3mbMspc
         nx/fZWUbNJg6Oimi+pFrkclB6XIm8gx7bkEzNztzQ4qVZX95oLfCJviCGoXfXsWq+KvB
         yUjmfar5gFBSwCidcYOU9U10nl1nBa1Pjz+XncWjra4kCwhipCvbkxYbwWJpnQkBBQ+1
         pdyX+gyktV98LnbsVtLwUsxZUYaAJUpGhu1EjH8ng9E9z4d9a7I/Mguwd7t0dEW4FHb4
         AAh51yQcwdsYx/UY6duBg/axnKMx+kjmY/OUr7+feChV3cB54Wz8uzmQoBs7F3IU5mnB
         S23w==
X-Forwarded-Encrypted: i=1; AJvYcCWacYw2bHZj38djSHZTYye/FcOoT+4UDQbFMJagJH2YBtj4IOSb9yhnpQKq2wxlkRpIjSJXWQm7o+DO@vger.kernel.org
X-Gm-Message-State: AOJu0YyRGRRyGSJMy8qA1SAe/kOEJzzSZyYEh70/OIdKONkmoSBzIX4j
	lhizxigPRTbe5vyoqma7L6+4XFGg1ehrgBS71BwhtUgN1zIl+audu89ADVk4CLM=
X-Gm-Gg: ASbGncvcDvGPG0JqSst+3Sh/DnNV/dFEiPBtQ/X8hJ/5seGS8jBUrOuWg306qnvUf3Y
	OHrYJs081USUU99Zj2kAOcJOdFLeTCQYNXHWi/mJNDS0Y7U5j5Gpwzh5NR31VbUwgnZCsJVvjxl
	Dr8UWO/ZAeQuTZdjV7KC1bDyGlEnnk0iUmV60I+RwuBLhJmh+ZUHEkAnDgR7qeZ+LxNqS0jlued
	CQX+nnGL79UD4rcumGaEBlAr2NntT6yh5aM9MLobMyVNHo6c73k37dQhXDea2GPgxX6iAdmhXkv
	81YHRQhf8S3LaFWfgVlJVJwanro/I/idNbTPnQZe9SY2dGPmCBCxy/vgpDCxt52Hb/0y
X-Google-Smtp-Source: AGHT+IGukAsBU7Q5nnnMlHg+4I8VzMt30RKwOjK1lfUSNCSc8vF0+ANSupH8FH8jzNSzinh9FvpGVw==
X-Received: by 2002:a17:902:d102:b0:224:584:6f07 with SMTP id d9443c01a7336-22db3d777d0mr20300035ad.37.1745487852455;
        Thu, 24 Apr 2025 02:44:12 -0700 (PDT)
Received: from H7GWF0W104 ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbcc1bsm9003585ad.74.2025.04.24.02.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 02:44:12 -0700 (PDT)
Date: Thu, 24 Apr 2025 17:44:06 +0800
From: Diangang Li <lidiangang@bytedance.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, JiangJianJun <jiangjianjun3@huawei.com>,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	lixiaokeng@huawei.com, hewenliang4@huawei.com,
	yangkunlin7@huawei.com, changfengnan@bytedance.com
Subject: Re: [RFC PATCH v3 00/19] scsi: scsi_error: Introduce new error
 handle mechanism
Message-ID: <20250424094406.GB48639@bytedance.com>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
 <f35b2485-588b-40c4-a2e7-1bb65fb7a9fc@suse.de>
 <fc08e3a1-da7f-4eb0-a738-cf6b6958316b@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc08e3a1-da7f-4eb0-a738-cf6b6958316b@acm.org>

On Fri, Mar 14, 2025 at 08:55:25AM -0700, Bart Van Assche wrote:
> On 3/14/25 2:01 AM, Hannes Reinecke wrote:
> > 3. The current EH framework is designed around 'struct scsi_cmnd'.
> > Which means that the command _initiating_ the error handling can
> > only be returned once the _entire_ error handling (with all
> > escalations) is finished. And more often than not, the application
> > is waiting on that command to be completed before the next I/O
> > is sent. And that really limits the effectiveness of any improved
> > error handler; the application ultimatively has to wait for a
> > host reset before it can contine.
> > 
> > But anyway.
> > We already have a mechanism for asynchronous command aborts;
> > have you checked if you can adapt if for LUN reset, too?
> > That would be the easiest solution, I guess ...
> 
> Hmm ... does this mean submitting a LUN reset while concurrently new
> SCSI commands can be submitted from another thread? I don't think that's
> safe.
> 
> Additionally, how could a LUN reset help if a SCSI abort doesn't help?
> If a SCSI abort doesn't help, it probably means that the host controller
> locked up, e.g. due to a firmware bug. How to recover from this without
> resetting the host controller?
>

Hi Bart,

Based on our statistic data, nearly 80% of scsi_error_handler cases recover
successfully after scsi_eh_target_reset. The current solution effectively
prevents all targets under the host from being blocked, which is particularly
beneficial for servers with large numbers of HDD data disks.
 
> Thanks,
> 
> Bart.

Thanks,

Diangang Li
