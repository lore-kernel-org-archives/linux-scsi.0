Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003D31F426C;
	Mon,  5 May 2025 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746434518; cv=none; b=gUflxysc+bO7W+W9/y+3w6kaVGw9bNyAKv2EJGFwmU9MrV48K2aojrtolw0cu1MlfpsuBMIObdwCYVDYkYBLqBa9MG8e8Squ7yGJmrGD4fwfhwE7yvh1FCaBJQvMzHW2GfNVBprBarH+HNROu7ZDE1gDAauChJ9GMN5bYjnzXuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746434518; c=relaxed/simple;
	bh=GXgUr/ueXDal49hHixLxYsfEjpnFGd/wJ+lm79tjq+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCx8+qac2dEGgqTYFa0Ff285qBi9BAfQ+/ZEfZ3HCRlhkJGWstVdFutEVNSi1igD7jb5c6yvuBQMPZcsbXfqos30+BXmOtIBH8Gr5G+HCRVD5BFMY+ByrklbQb3MmsA+H7YLrdv2B6bSFf/TfYzoMxg6hE0adHr7xQ7p8oODgPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so26142775e9.1;
        Mon, 05 May 2025 01:41:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746434515; x=1747039315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6l78IWpKeCD5XLJCd4To9WBB21MJVFSRgrzcgdX6x6c=;
        b=OG4xBDTrHmMaQgp1GGeKJefcm+1EeHiKN9kZkxOUBEQWroWmWN30Mlq0vEjYSL2T8m
         EeIFIhu+4drlCQnWYTORGjQFI6/nXWrWFm8pAymE6E6rI/ZbCh3b2ZgUds6bS94Oejwp
         QrKdVQr20oh8wgmZxaGLg1nqMZyeFGmOWIAvIBWaNasTXLOxFcO2LL2gE+vG92Hk6Oit
         DWqGADAZCIJMFR7ED6sfHLfmSgEdBnNwQ2mnvFejml2rIS/JbFzBzfpc0L/L9TE3Nose
         I5+5Q3ypJ5NTR5D2pdOKXPj3/L79aNf3GI4PqH4Kr/yF0KILndHLn0PbRMtbRLb9RQ+k
         6Pvg==
X-Forwarded-Encrypted: i=1; AJvYcCUSsAThbKz75jPLSa4i+I1/7OdLWazc+6XQOBry8R/Z7GXIClfL61EOnoEfC97cejC+bwMIGDY65qCktA==@vger.kernel.org, AJvYcCW4jO+uwgLJHHtdTmx0yMAQgPe/maGyxaCJBi10E64u8p1ANyCofb9jMQq1AFucbMMFyS9bpejKGIe1tA==@vger.kernel.org, AJvYcCWXFaTiMnXUylcAwJ3ocGByQJ0B1X0XInZdFuZUqAYtjDgc7EZmuOFZmwyqgM6V8HA8sKS+0hvLCSe6@vger.kernel.org
X-Gm-Message-State: AOJu0YwL8xTtbNSutyx1zP/WD4Fs159Sp7uWDKBe6DmcdeREQSIaOfBj
	ZSPK+U1DsRaN9nfsUyS/f2O078toSRvdIsPTsj2yWozyq2pMq9Em
X-Gm-Gg: ASbGncvXmdBIusj+pJ+1Qwg68Tlk1I+rdfxtORpxbqdAebhh0As1iaqLDVaVumOcRKG
	0eSyRJ8RbWj+l66sjir/KsOA4QTxYOUOrp7C99kKGpWAZU01ry/q0Uu8o4Ffcv6iaz3QNfZk0oF
	32b08ryfd/LQ5Y8krFToqbC3RkJPJBRbUsOc0Ma7md2VpVjIEIxPevylbQTuEOR86xu5d6R/MXp
	dvF/qRRe46lNOY7LYTy0hnb8z32dM28FwJZZ+BHRJQ8ZrNvhbTO2HP0zAHk4lZ2yXEXcjqzjaJ7
	AlKKly6K/VFwfhDbRZdBUu8vAlLREZe6juo4Uo+F3b0espEAw2Bhui/9
X-Google-Smtp-Source: AGHT+IHizeahuBw+QGetKBVhj0XAi2oYfwOQPB10brmf3gbYSrCYMngUbSYbidPa9HLYuclaQQixCA==
X-Received: by 2002:a05:600c:8283:b0:43d:8ea:8d7a with SMTP id 5b1f17b1804b1-441c4948691mr46858925e9.28.1746434515156;
        Mon, 05 May 2025 01:41:55 -0700 (PDT)
Received: from fedora (p4ffae10f.dip0.t-ipconnect.de. [79.250.225.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae3339sm9637506f8f.21.2025.05.05.01.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 01:41:54 -0700 (PDT)
Date: Mon, 5 May 2025 10:41:52 +0200
From: Johannes Thumshirn <jth@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: Re: remove block layer bounce buffering v2
Message-ID: <aBh50ErQRhyfL1Y8@fedora>
References: <20250505081138.3435992-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505081138.3435992-1-hch@lst.de>

On Mon, May 05, 2025 at 10:11:19AM +0200, Christoph Hellwig wrote:
> Hi all,
> Changes since v1:
>  - return -EINVAL from usb-storage ->probe
>  - improve the error message in usb-storage
>  - improve comments in usb-storage

Sorry for sending it to v1:
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
