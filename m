Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCFB285068
	for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2026 11:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388481; cv=pass; b=rqOkEPzC6MdxOoBSMZNRXCRRr0QICLocxu6306X+ABdOgCbStCA3oG+68E8nmw+jn33FXjLuD9ho8fPnF8CzzbeHyZ+NNAEjE22+qbh36Uu8syFdwvTo1Rh4cKoG6JHGYQA6qKfDJQ9qBX7fi65NZ85Jy5Al+p4Da0Ot7jjaYcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388481; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJZkIF5HzfbXwZojP+oiI01edF++pbpp23Eu5g+oH6Nni2uwwKT8I5jFckCynydwXT50wsxhPKefgNeeoiZny/5vo0K62Kchw2QPpYJWEBTKm49Zgigt9sDlTn0r5op4zXgKz5qIzPcRLphaTFWm+PSbuPBNZEYJpxphbA4xD6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjS9Eoje; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjS9Eoje"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66bd4f7b2d3so3675396a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2026 04:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388479; cv=none;
        d=google.com; s=arc-20240605;
        b=IhduXUaoLWSiBDv1eZpfVol/bqAmin6yg7cW7yaxn3DzMFXqD1eDSGd5zZ5k1jp3Rq
         HDPhXnqWLyEipjf7fX0mzu+9vxCu+w2TgoXdFdvW2tJC+/x3DIlnP9p1uagY+3gk4RHa
         HENBRRwGRCLtOdhRD+ZCtbwSDyfJFaa1y14BNvSZe1ur0dBra4CetoJ383NXQzQkOibM
         Go1Ja9UG8aOuWoLFh/0Q2yR21SEbt/XU0ox4mAB5ky0kREvn432BGU5voS5+HDkrlWWQ
         N1CbwPiUef/NCOzDIZNjvxwZKH2594g3tZ00bJ+u1IEqyM8fBXV6hHtEAS2eJsP1HmVl
         5ZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=z7iRaYb5j0JLmtyYOl58Tdq+KwiHWGznYuqkdojSbNE=;
        b=ivChWEFMXTCWzxLHQS70V9YG+kbIPwhJ3YHXRStC2lkEI72Ug/Vfny+Olca3uD+r/m
         7pfHC7Kn9aSV+UjszB1c68cMC8RPtAPJIsEHZJPyBDFVn6/Ulesgb7fZC2zGM4Ni0xFB
         S6gTr9my+s0OJhAPtwBb5gPQW5Pr8XsZJBpOBv9Z4gTEN8gBa6Ift//F/1ztHyorB3eU
         cPSPtj/f4D/nGeDdkyXLIKabDvzUidZ1UAFipmcRw+dp0omIez9Zi6NVz9T+UX72n05g
         ONxvgNf68T5By37h1XgY7D8aTAoB2k/pNQegiKneuNTazkVGphYIYocalyq/pb57/IxE
         k38A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388479; x=1775993279; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=jjS9Eojet1qPR5yY/IjndT2lJaD3dpqe/pRi4GbdvW6C0Du3Y3NIDIX76x9DesnTsX
         sFBJsxpk0Moia6w/r8Eax8/VS75YpHPxo6UaRBApQ0u5iiM2xMWAFyKsn6HdCIrpdUnp
         FlciLQzrVLv+5B7Fh0fobc+7j08vQ/uJIB8d9rmUYRNT1rZS3iSTE/k7Nzsf7J145gh7
         gJC6zBtKeNClATmHUS+MBKCg1/dx8YHgDWjTbMMVKbE7mmtvrMVaCt3ijjbZg4MwbdhV
         N1DqYidKYWPOtvJhHy1VXw4/RauZ365gF868Y7VovIoW0TQoRCyZZdae3b4aRh0jdqrJ
         cI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388479; x=1775993279;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=HfCccgr9nyegGzwGHviPiwKNKO4LN97TG/YrTIkK8eHguwJDA+i2pYCXlc5rtMq6Ho
         W9RE07ZD8ZTKk7+npffKY0oOpE8LzUK6q1FEmLR3gWQgUXf65HMK93bYiFt1+zIGcG3y
         yye1CyTVHatTrxXi1renWj7ptPywdAh+vwxkSz4bn8DR+tvyZyEBmBEZoigoW8wDfBTj
         as1O/oom/CL19UL6h5saCjn+KTZt/LIszCCmNk3D87QSHTrkkP6NrDBmtRm+ZYzlEw/K
         xVzXNrYqIupRX0qWUvAhJPjWcUYHOb1vEY1EFMH0IpXzWNqyQlDcHH/xiO9KJaJBdFqI
         yMxw==
X-Forwarded-Encrypted: i=1; AJvYcCUsCSKhdrVP9Vq9GsPyDnSyvPU9LumS4J9RjvxUJBWWQdSKAQ8y6R0KpJW6ZoZRCycgqCHYKrc41nGr@vger.kernel.org
X-Gm-Message-State: AOJu0YxMIC+kvFfKRSYi7xCUvpXe4puchawnNhtDN4VYtpcM8x3W0r76
	HtoUyNr+en+KYoVxkjB+URgfVYKWeNzcnBf7ya4lDVnrDi+nGvXS9Cq/u3ZWIADGmX5FVax/jzf
	g8Wy+wXrKMZhPWsApDIuY/T3/gyHLZg==
X-Gm-Gg: AeBDieuRnKUD8NvT9xp9u6KR9SNvnsv8kokBsnddvCADr8uE1xoU08GE32UzhHb2AoV
	HfpHD0u9bS7zf2xJ4UonG1GMvCQxV5kdMR6hr5+gDFpu4HwvAqzpZgesUCOf5+TO35hnQP/wQkT
	sh6KvPxoXApKx/eIBlCl6e2EV4/yNnuisYcPKW/j5SlSvuN7Q0WlqwF/PIv4Z2YVKqo+5nrKk8R
	JjSwCmbLGo7lLwGARh6WMfUWLrYx/OcHELB6FP/zfPnGahx25yplV42w9P3y8cqsKd+kaNKXvK9
	jdhCXkz6HvyQiXDzIPr/nnyZ7LgqOVbvz7C+OVZ8z4u6EP11dUFKYmRr8xzerI+eMD8shQ==
X-Received: by 2002:a05:6402:1ed6:b0:66e:d57a:7023 with SMTP id
 4fb4d7f45d1cf-66ed57a708cmr577928a12.6.1775388478798; Sun, 05 Apr 2026
 04:27:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-2-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-2-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:57:19 +0530
X-Gm-Features: AQROBzCwSmUwg2hzQ9ILQEZ1j4iBp-ZNL42-_yQcEJYC_dnQvWOfGvOnI16w6Bs
Message-ID: <CACzX3Auxb=D1PabMdVng1N7G_7zmn5poknRR-k5r-iJU7aWrGA@mail.gmail.com>
Subject: Re: [PATCH 1/6] blk-integrity: take sector_t in bio_integrity_intervals()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
