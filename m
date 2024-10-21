Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07301E1A37
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729498324; cv=none; b=ml7HKHADcKIUgZHzAyCtydZWkkiZPK72ywBHyaM/Hnr3InsySsvwqYm9k/EPF5pQS+HMYdzH1il7PymdXxx8Is+pPpx8J2TW7dsitiH4dRd5VJzSDumhffAN2vz4JgsIz307QS8ddLUSuU0+TRoP8X8iJt/R/N3iU+/ODQ8V6lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729498324; c=relaxed/simple;
	bh=1n6GapVbZcOL3mKFA9+Ayomnfwcosh5/H/Z5hJqdhkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/NWDvXwM3DY/4rRJqH5OvlpX72EUHcqcozj0fE5B1jzUxmOoPPI/YfO0uC204X7IF+ZE1rj5r/gTGAt9ompCYogWwNOBOGoO66n13MPuKivFCxRmIaz3TetMth55G94qwI7IsjI+tXhWQ5doAsqavaYg0K1Yg9qWIOup4TFV44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sBIOKc5R; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sBIOKc5R"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4314fa33a35so42494805e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 01:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729498321; x=1730103121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u3rz/STqmLShVUJEde2A5H4MnGVzSmMX2DRmn6WXzis=;
        b=sBIOKc5RbJy7n4oUJVRQ527vb+JZC4j6Gsoeu+SUabrQ8dZ+Go+t5asEQ+ToiEdPV5
         zpMXCP5396vmcDW8J5yVdgjiO7hk6zDYUEvTAKpI7toOwQS/4EoecZvbjKYVEm/rUGEK
         hjU5H4ZLFfNtLKIUE1vQW6tmUhbgnkMhsyjSc4FYUAVuOry6KW0bZIStfmFBap+XQCna
         aZXJN8mJZPR57SDYGXwFHl4J0b6cJQuelqdBvkI3VNVOYehCLe6KRhkaih0Z0EQ8opCB
         s1ZXcTYfO16KsSeYaiLAjWUlufiLu6qtqhU2epO2bQWFAKmnfrvhZDuDWrGpg0uepQ52
         JeMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729498321; x=1730103121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3rz/STqmLShVUJEde2A5H4MnGVzSmMX2DRmn6WXzis=;
        b=ag45FRxFseHeEunYnF1tEgFx5AuFP7910PgM+aoHH6ultpOfcrON0CL0CflzENlvJK
         elEivhUwBWUw2CFcfeZ+/AmSuuJ+89/4plueyvLjbXWPNamKrLehUk6WysMzC2ELlJrK
         e9x2nHN5H4BvjaoMu+LkzsxVrhVEt9ilcFkIbgbVqmTOIC2yYCIwUzNw8V2j14JNCGze
         9K6HqFoQPYlzBBDedch3zZVHkZCaJYekDwPxLTdyS2DIHxSQUnTQ4kA3XedAfVoAIZb2
         bXbb+QWPEEC9nD4NWITyuymUP7XE8HD5QjQ01NPC7A13139Q2vX8iAafP6hceMZRk0pU
         ILgw==
X-Forwarded-Encrypted: i=1; AJvYcCVSjfTRpnKQ/uc2oT+LStmnJEZX1gyCocrJH4vgSG5Y3nY0R8UMdvDQIzN1EmDyh9qzMcNZ1QD1ea8G@vger.kernel.org
X-Gm-Message-State: AOJu0YwaSV9oQBm/EzTDRQLg0lFnMbfUYNQnIiEgULTEw+H6+ej0vpkS
	a9PVdu7hrEGISQu0THCq4ScfRr7wfxcSpd+HVxeq2ucHjATw/Zzk8UeSqVV48G0=
X-Google-Smtp-Source: AGHT+IGqOGPzuQO2AEraKFf+z3GnaIg1kPhyD9oeLzbyrjIaVZlTkrYTcZ0JfoatTvjxTGEBLUAx9Q==
X-Received: by 2002:a05:600c:474e:b0:42c:a89e:b0e6 with SMTP id 5b1f17b1804b1-43161641cf8mr86267525e9.11.1729498320851;
        Mon, 21 Oct 2024 01:12:00 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a37e1asm3676724f8f.20.2024.10.21.01.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 01:12:00 -0700 (PDT)
Date: Mon, 21 Oct 2024 11:11:56 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, colin.i.king@gmail.com
Subject: Re: [PATCH] scsi: scsi_debug: Fix do_device_access() handling of
 unexpected SG copy length
Message-ID: <e4169ff7-e038-422c-ba00-52818870c2b4@stanley.mountain>
References: <20241018101655.4207-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018101655.4207-1-john.g.garry@oracle.com>

On Fri, Oct 18, 2024 at 10:16:55AM +0000, John Garry wrote:
> If the sg_copy_buffer() call returns less than sdebug_sector_size, then we
> drop out of the copy loop. However, we still report that we copied the
> full expected amount, which is not proper.
> 
> Fix by keeping a running total and return that value.
> 
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Reported-by: Colin Ian King <colin.i.king@gmail.com>
> Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good to me.

Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>

regards,
dan carpenter

