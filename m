Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D90C158DD4
	for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2025 07:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740555133; cv=none; b=rbusj+utkWTDd4tNicSGRf3qwl/PgmGxfD+JVRaIE3cnlmF59l3AwTnC0uU0OsE7F1RQFV2gER8pM2PnVY/5Q8I6NRXy8EXPmNAFQocwkeoNR5jxU1GSFXebrc7ZMC57H9yWdGkMWkBd7tDia5ud8jD3SiJ6unFrJxi7zvc8F4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740555133; c=relaxed/simple;
	bh=2d7ZYo/J6xNOpi6uaMp2ccWOTHvJMpT+pl0WNwgOe4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REJ+pEfUHl/OiA4TI+bmTrHlGE/iVwcQ9nxQG1NNc0XFA/TmYQoRl4WsbEKuA1OwGxiDJg9geo5MjIISnliFFkLTa2NDqMIIjWwx9VCuCIiQQJOoiDv4q6xsxwIu48xSGxwWrPk0GJsGa8e/Ck+jAd1s+O3vrjMt/zmXkSwbuRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bf/wJYKa; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bf/wJYKa"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e02eba02e8so8719485a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 23:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740555130; x=1741159930; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fV/8UPNYlCCgRVHTwtkpq+W+pfg36jdrdbg5juiRqX0=;
        b=bf/wJYKaBz5PcBGldDLGM5AhUG8EVBoUB2WB4W1J4hyei3TSuWbSYDc61yJEK0yGOH
         MzqAUmpb7Lve4O0eDzYcz0GXEdVf0D/YZLovYwtNg3uGIrqHCMZYEVAFqQd2HkPVvvqC
         eZgi6TflAkFmx7GZXo1aumGXr3CQGIZrOcib22MRwQ7MqQ77fymUGGsTVlMLOznzKfY5
         IQR9CdIEc256f7Ma/9cuw9eSLpsVUmC5gSCh+ljfatIoXdO4YiDLFJGLgQHobjsVygYS
         +kRkOecAkD2t1fDcsFo2AnOIyAQIuLRisS6EhUFz2o9kZ9kpOjorFjCF6a5aooxjSHpq
         yXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740555130; x=1741159930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fV/8UPNYlCCgRVHTwtkpq+W+pfg36jdrdbg5juiRqX0=;
        b=sHRdk38aFSC+v8kn0I6gGOY4HfDrt7bwcJZQeGM/onq5lJYz/gX9QnUrsIiQpg0rIn
         EuFwCSynnXbxrMM3LzLcnfmQA5XT1Tng4OrYepQJ9z1PussY+agrQreq3yTe8hHPIJLP
         lUfPH91U/+M5pfuWNLViKCZ+b5eB8wdOoR3G7eRgYp1lWBimLMjdfkoiEqgN51mf3IRM
         4hoxRW3QupcOP3I8D77w3gaZMGKqUJaf+4YK2DQaD0TwBhIKeoWyl2dqwIztE46oBWLM
         o1oqnbHXHESTIdJDMTBrztysJ7uj+Af7asrIXyzorSMkUtvI5kL4DJBd0TFmMJPfE/mv
         EDjA==
X-Forwarded-Encrypted: i=1; AJvYcCWBzrQONawpebKLXGnfPL/Aug5O4KEsrRRIW2y9QiZEibZvZdyWr1KJfxSwu2wx2Onyyd4BQgQfbHU6@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2SdZYMhf9CAFXhKpOqKK+sfxH+FnMriBBYa9+Wjf+918qUHyD
	VGdF9BCRx108kAamhkWZBZ7ZLQopjjJs/4zwuWoU3bgFGepIJDNh5ofdVNRBXd4=
X-Gm-Gg: ASbGncsw2Pa8JU/fmkbYvqOtFA3JwFou4BBJkxLeysqhnW5gM9o8RXMDH9v811NOEZa
	y55YZ+NghN5Bm9QXFUl/zmA0sba8470dXIVFOfxEYFEjDG2lKyWvp/D8sWc6h4Ct2voXYz62xzf
	2+XHTv7nik+NUhgzdzFcXxiFMxS1kCfQnHtKNoDJuksRjs2rC0p80uBmQrLn4cYfSRfQxeTTmsz
	5l4UY9om3pgV1s7GdyZbcU2diPuGxF4wZOVBmiqg/SSwVQqhNkBDDeY3JvnwyJZQpmMJ+gnx2RD
	gANQgPoEzbndytZK8atjLWLaGkKyTXE=
X-Google-Smtp-Source: AGHT+IEn3LearM21K5U7hoqi12X3IHtk0Y4SVgsVZwZq95cg2z1JvH53DBpCfb50hAH/YxGjgv13xg==
X-Received: by 2002:a05:6402:51d0:b0:5e0:818a:5f43 with SMTP id 4fb4d7f45d1cf-5e4a0e29a82mr2240541a12.30.1740555129678;
        Tue, 25 Feb 2025 23:32:09 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5e4a6353eb6sm572296a12.48.2025.02.25.23.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 23:32:08 -0800 (PST)
Date: Wed, 26 Feb 2025 10:32:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: fnic: Remove unnecessary spinlock locking and
 unlocking
Message-ID: <80809232-9490-4a0d-8159-af53228b612b@stanley.mountain>
References: <20250225215146.4937-1-kartilak@cisco.com>
 <20250225215146.4937-2-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225215146.4937-2-kartilak@cisco.com>

On Tue, Feb 25, 2025 at 01:51:46PM -0800, Karan Tilak Kumar wrote:
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index 8843d9486dbb..6530298733f0 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -311,36 +311,30 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
>  	unsigned long flags;
>  	int idx;
>  
> -	spin_lock_irqsave(&fnic->fnic_lock, flags);
> -
>  	for_each_set_bit(idx, oxid_pool->pending_schedule_free, FNIC_OXID_POOL_SZ) {
>  
>  		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
>  			"Schedule oxid free. oxid idx: %d\n", idx);
>  
> -		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  		reclaim_entry = kzalloc(sizeof(*reclaim_entry), GFP_KERNEL);
> -		spin_lock_irqsave(&fnic->fnic_lock, flags);
> -
>  		if (!reclaim_entry) {
>  			schedule_delayed_work(&oxid_pool->schedule_oxid_free_retry,
>  				msecs_to_jiffies(SCHEDULE_OXID_FREE_RETRY_TIME));
> -			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  			return;
>  		}
>  
>  		if (test_and_clear_bit(idx, oxid_pool->pending_schedule_free)) {

We discussed this earlier and I really should have brought it up then,
but what is this check about?  We "know" (scare quotes) that it is true
because we're inside a for_each_set_bit() loop.  I had assumed it was to
test for race conditions so that's why I put it under the lock.  If the
locking doesn't matter then we could just do a clear_bit() without doing
a second test.

regards,
dan carpenter

>  			reclaim_entry->oxid_idx = idx;
>  			reclaim_entry->expires = round_jiffies(jiffies + delay_j);
> +			spin_lock_irqsave(&fnic->fnic_lock, flags);
>  			list_add_tail(&reclaim_entry->links, &oxid_pool->oxid_reclaim_list);
> +			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  			schedule_delayed_work(&oxid_pool->oxid_reclaim_work, delay_j);
>  		} else {
>  			/* unlikely scenario, free the allocated memory and continue */
>  			kfree(reclaim_entry);
>  		}
>  	}

> -
> -	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  }
>  
>  static bool fdls_is_oxid_fabric_req(uint16_t oxid)
> -- 
> 2.47.1
