Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="L63DWHSy"
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26E4A1
	for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2023 18:33:19 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1fab887fab8so4775752fac.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2023 18:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1702434799; x=1703039599; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3Z9JoyfzsY5Msgpk7J3xKwjEP4qsoLvyMDzNBboZxQ=;
        b=L63DWHSyw764lh5KFe1pB7SH3T/tPvsOkWuRvhOUWXJUbmDh54hBIgUaV6pF9O5zjJ
         7ApfXQlI2R/60ll3Uu9I9kYwxKmAD+Tlix5N3DsSk3plaLycVl5hjFECLDJAgSS75ztE
         qwo/IFy+vsv/dgM3qO8vSUi5S9ABmQizUkQSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702434799; x=1703039599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3Z9JoyfzsY5Msgpk7J3xKwjEP4qsoLvyMDzNBboZxQ=;
        b=p27w/G5vBWecczzSea2X0n3NDh+qcsIPrUGe2R+cUd0ICBCvRhj/mt3MYPZEJyXyEF
         732oLYUYUSrn/IEhv2PVMpW8YurLDaJpHAPxi83tSkkfDS5xOXrsG7I69P6aFoW/6kxc
         Q5fXXYRFoFBWWpObY+byzU2/GAA8gxVPdSPTW3r2J+Ln4BtN30/ymb+PMl9x64Yzb/k2
         CH1NafUIEYcxxPaNn5x92aNwS+iJ1hUx7QgmOSojEgLDh0sXQaloFORuI7rUacI39Z9D
         s3kd3xUxZKO/T1K4dOvuvj8ac+0uRxxszsYftvwDGOrnWUGd2kRgE9WcgLgW4X0Gj9R2
         56ag==
X-Gm-Message-State: AOJu0Yx1zXs2Nj5hp5IGIBLAd90PoMh5mUBguKfGr6NB0M0ZQeWu6KZj
	MzYH1VL0WVskI1kjj9Kbl14GkA==
X-Google-Smtp-Source: AGHT+IE3whrRDNDQUcDGajjH0b22bNpJJTgCXoMQv6lkdzkXPDL1WhDozwCrzDj3USG8zDbkzGRDYQ==
X-Received: by 2002:a05:6870:d0c:b0:1fb:32a0:41ce with SMTP id mk12-20020a0568700d0c00b001fb32a041cemr9848854oab.0.1702434799232;
        Tue, 12 Dec 2023 18:33:19 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id o17-20020a656151000000b005c2420fb198sm7667429pgv.37.2023.12.12.18.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 18:33:18 -0800 (PST)
Date: Tue, 12 Dec 2023 18:33:17 -0800
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Cc: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fcoe: use sysfs_match_string over
 fcoe_parse_mode
Message-ID: <202312121833.E5062A3126@keescook>
References: <20231212-strncpy-drivers-scsi-fcoe-fcoe_sysfs-c-v2-1-1f2d6b2fc409@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212-strncpy-drivers-scsi-fcoe-fcoe_sysfs-c-v2-1-1f2d6b2fc409@google.com>

On Tue, Dec 12, 2023 at 11:19:06PM +0000, Justin Stitt wrote:
> Instead of copying @buf into a new buffer and carefully managing its
> newline/null-terminating status, we can just use sysfs_match_string()
> as it uses sysfs_streq() internally which handles newline/null-term:
> 
> |  /**
> |   * sysfs_streq - return true if strings are equal, modulo trailing newline
> |   * @s1: one string
> |   * @s2: another string
> |   *
> |   * This routine returns true iff two strings are equal, treating both
> |   * NUL and newline-then-NUL as equivalent string terminations.  It's
> |   * geared for use with sysfs input strings, which generally terminate
> |   * with newlines but are compared against values without newlines.
> |   */
> |  bool sysfs_streq(const char *s1, const char *s2)
> |  ...
> 
> Then entirely drop the now unused fcoe_parse_mode, being careful to
> change if condition from checking for FIP_CONN_TYPE_UNKNOWN to < 0 as
> sysfs_match_string can return -EINVAL. Also check explicitly if
> ctlr->mode is equal to FIP_CONN_TYPE_UNKNOWN -- this is probably
> preferred to "<=" as the behavior is more obvious while maintaining
> functionality.
> 
> To get the compiler not to complain, make fip_conn_type_names
> const char * const. Perhaps, this should also be done for
> fcf_state_names.
> 
> This also removes an instance of strncpy() which helps [1].
> 
> Link: https://github.com/KSPP/linux/issues/90 [1]
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Looks great; thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
