Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0430A30D41E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 08:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794355; cv=none; b=eBnPGpCiQId1L0DXxrSq8wwrerSRZGCIZwHSExCOZTl1puco0VJPD4BeHLqTQby3OPOUpykwq9HjkgzlVErj9OMIYjOgbpcoD07ZSx9FOFiLF4x3LEW9AjyUrEWL150qy6OEzrOiErjo8H51j5rF+vyeWpUYR815TT9Ec2bhqwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794355; c=relaxed/simple;
	bh=FC2hDtl/dV3I33NTPtbR7udY/rZiXDYFq4s4FBbzPGs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJ6geOpdrvnfwTbIJ0g009u+Y20+9/Bm0qFpHJN+KHCplSjTcD5XOL6qcXvNs3IgQaz1W1xm5+FRxunRG/PXyBV4ureGiYrM/AvjUDF9Wq8hYwnI1+5kVI7NgL6aGYQn4DWfIJLVA+rApY4crulcolo38EOxDGAXrpLv3/2v6F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AORoo0vg; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AORoo0vg"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49550ec592cso1175465e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 01:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784794352; x=1785399152; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aW9v+GOaM69UrXh4AgU/G+ySvHEZ55OKVJScDmqNygA=;
        b=AORoo0vgZ/Bn2cbcI2lq/rAbm21x6phY8/cGkejZCap7wFerMh+nxnq3qfd7n2u/Am
         lfk//DR6dk1KmQ+Jofqv4DxzyUdG24iW6rm81TioTdg17+Unr9gRbLgrRiewQ4wzKOlk
         dCgC79mAZyVmw+JZCdhZUMy/nCc/SXqglKuvQDrETUg6c/77CEMQfsV3e/aAs5A7lNAx
         4N/FXEG/IProwYg3tRlQpIYca0j9SQmy0DY13i96HKs8tO1wtbzbLVkM0TuEOiKyFUeQ
         dMnx3Xh7kBbCWTduWwVDLmIYhBoYoMtzlzOqgOt55NuvhQ2j5Cnk00IC4iRSh1/az2Wv
         cqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784794352; x=1785399152;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aW9v+GOaM69UrXh4AgU/G+ySvHEZ55OKVJScDmqNygA=;
        b=pdZ9HIS2IUkw+rRPtlefsAG5xIVxO5gY0AUSMkWlt0CzGGPpDEKQ+NS9lVZM4Z48UP
         nMOlOpOffEoFZTTZUSAaLM27d9WueN8nIKz8elBc3J0txrv9rQsovMLgzR4qyYVLNXjY
         P3TYjmCN3XikjS58LNYIEgjq/sjhTZJQ1Mzi4Q6c2XBJvHIUavdY7IEpjqalFI4MRuI1
         ltl4bvmei1gjnuWdNlPm5qYBXir04c0mMUwGgfKJzNuVqAuZRb7WpdUROG3tHWD3VKJ2
         bvwshWmk/0zqm9S5CF403YBYDPH8y8z090mJo92re5ZfCjlfAh+USSDp+lU1U2FIDkhp
         bWgw==
X-Forwarded-Encrypted: i=1; AHgh+RrR8sQISV16f1ri96/axhTIVickGrveW1Zw/xD27vkyI/tHkTMCI/SvEdDzWqzRY1V9jHQEvTbxoQwc@vger.kernel.org
X-Gm-Message-State: AOJu0YwMZIwQckz3N6RYd/VdPMKNXdHfGYsR88hLJed3CYSvWh0pHf+m
	EkQqrPxlW5CUR7h7UfB3PF3eILGH3ypTpmYyX2/f2Nw58DtR+aObbhhD
X-Gm-Gg: AR+sD13yjsjlBksbxjagXbKEupJMYglVE+YgdTi2ezTn4OwnjJAFEhoiwb/ptqYgzJT
	bWBYmbGxRikB758yrLxhVMSRHcbjL+NfDbox+WtrhoJyRZWe+wV45TdKd5FQxv4N+Pb7gdZPQ/A
	tpNnTtB7N2vrJrApsm09GmMc8MlARmi8tK9W7YIHqQSgH1KgSfLuluOfS8gtSBKxdwx1UZDKUFo
	DTTBDu843UQqKDRn0mhVFbHaJoS9mqRTClJsEJjw9QK2MI2AEbdokTXNpLfizKl663k6iSai22E
	faitweC1ac/OJSBt5JPzjcQhJmsChLLF/fpwvn5krfI2rj5tZxPZlQqOFL1JeJqis9VwhrHgF8T
	A6jfMB5eaU/SI1+6GdvFbdcPMXFBlIp7QlMil8F6HUnk3RPRxVw6os9rKNIN2a5Tz1/RaJ6uQPI
	QbKvFRYU8UJzCXbQQ4sVAw3EX/T7NxM58yY0osK3g=
X-Received: by 2002:a05:600c:26d3:b0:493:f478:4c71 with SMTP id 5b1f17b1804b1-49574593d20mr9993285e9.7.1784794352054;
        Thu, 23 Jul 2026 01:12:32 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49571c4b664sm44359805e9.4.2026.07.23.01.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 01:12:31 -0700 (PDT)
Date: Thu, 23 Jul 2026 09:12:29 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Bean Huo <beanhuo@iokpp.de>, Li Qiang <liqiang01@kylinos.cn>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, beanhuo@micron.com, can.guo@oss.qualcomm.com,
 adrian.hunter@intel.com, tomas.winkler@intel.com
Subject: Re: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for
 RPMB frames
Message-ID: <20260723091229.72bc2da8@pumpkin>
In-Reply-To: <a74b5d01-feaf-47a1-ae40-09f737ad3a6a@acm.org>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	<20260717153914.26321-1-liqiang01@kylinos.cn>
	<20260717153914.26321-6-liqiang01@kylinos.cn>
	<fd02332e6bd8630c8b3d7dd89e9f7502bb9d1166.camel@iokpp.de>
	<a74b5d01-feaf-47a1-ae40-09f737ad3a6a@acm.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Jul 2026 06:54:16 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 7/22/26 5:33 AM, Bean Huo wrote:
> > consider Sashiko's suggestion, it's better to add __packed on struct rpmb_frame
> > {}?  
> 
> Do not add __packed to an entire data structure. Only use it on
> data structure members that need it.

That depends...
If the structure itself can be misaligned in memory then the structure
needs to be packed.
OTOH if there is (for example) a 32bit field on a 16bit boundary then
just marking that field __packed will remove the pad.
The compiler can then use two 16bit instructions to access the data
rather than four 8bit ones.

	David

> 
> Thanks,
> 
> Bart.
> 

