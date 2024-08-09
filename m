Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9559818E25
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 05:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723180876; cv=none; b=RHRrTBjT/nK10g3FAs3K0ePlwrMo0mmFPSKYWKQp1LNvHa6dWihbS2K9/qg4MrNQ4VUrA1yOn8cZj/jvSe5GwS/fR+hV7+zSU5B2SSmRuw91VmhNVUwxwKrpOdGKZNup+U+6TBv4Z/kfoWBGQ4wIinjoeCJf1uoOk9XxUzVA55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723180876; c=relaxed/simple;
	bh=PpAGzidoEuyVWqwPu9WADZpfrkeMjgwza8y8xrc3xcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnG0fYVCKR1OF6/9G/2AiGtWnGaGYWiYEMT2xGhxPmU3vC74pkg6LnWbw0XrJ2TELNAEPWcmBDYcEZTLsw39vI93mVdKbJviUL8+O9QE9kw/Km5oVza4mDQAd5cxU1y6QJMfMeeR22dHoquCNm+eUSKiGvZHMTHzvg5N0bIWwP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RQfrjaKL; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RQfrjaKL"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7093705c708so1821517a34.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2024 22:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723180873; x=1723785673; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pz5ddJDrVG7luc3o5uJN9sGcB2P2TIvv8zgigoDGlDU=;
        b=RQfrjaKL60F0BUn2Ne/I4gb9mi4tbxCwxV3pi1mxsZJi8plP+KLXbvBWS7sfiMTJva
         Jvx+yOsH/wZCfVbWdcA1cI3RsnlFpbDSnRwjNReTq93ztdOkXT+N/DVDLyIiluRXZOG+
         MGj2mf7Ah9DRcTas8bV0cZKQ6nbeALAPpNT1ubVH/umqbZwarBD2x7NCxjE8TJGpxN0K
         OwxISIj9yYGS3OU6E4hssmY3SUXHk0pM+HfpqT+poHYviujii7WZ7V8igkj61sVPwFtE
         Jtg7u3i8aneiOfuLF20pSiS6w06OSsvoAdB+q4IZgHJz6YxAQQS+uJ0dY0j32wi9JfI3
         857Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723180873; x=1723785673;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pz5ddJDrVG7luc3o5uJN9sGcB2P2TIvv8zgigoDGlDU=;
        b=HgDgsQqva85ADn096WQu6hageZdwdRcW0gSFbrjSfrrBeVwQIoUIRMP9MDiSrPKxiR
         6hfVLsfGkaoRi8hUfFl7l208+/SiKywOwPou4huPwnWT33hWKKTkw1E+qaGx8w0H6uX/
         jIPVpnIU2+f1vYKTkEu/eDHzXOtBlrtYp0Qyu+U2dKDVztv3GmMgVCKs8Y5sPVTip2L5
         1tMSYtfkPjLmksEAf/chBc0KNr6HdU/jRV15kG2eDVLcjK6eHVtKEJXI+5ASmjLejG/Q
         ZkqzvTbRtQhWWEo+nPagEkx9CDMgoAULol28WZOAjVLIWZKIi2sPm/nEWoSJFB2KcPd9
         g5qQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6Jjggmx7pJ6DLRVhGH+/69qX+veCVvmz0OaxeC/FtCqSpx1vP/l0f162cZ91sMCnKpMa7J4kVx5UBGn75v+1nITHn+DIIwzFbzw==
X-Gm-Message-State: AOJu0YxNFyI+tpJ/TYTmyN6Aco1J8QY9sopOqeVegM+VnfmzvBzKiRMY
	GLT7I9uMo+i77oCFVsnxPDqwDv0erGIUBP20QJUcEW2WlEzI2B1gmJgwF8Whh011uL1ScPDnK3k
	=
X-Google-Smtp-Source: AGHT+IEBBmdzA4o5PJizsXh0aMT8Ip3q6OOr383yIJbvAZK3hxkCcP3uuLF4da/VeN9K6qZnZQ60WQ==
X-Received: by 2002:a05:6830:6a89:b0:709:4a6e:a567 with SMTP id 46e09a7af769-70b746e4093mr574935a34.14.1723180873679;
        Thu, 08 Aug 2024 22:21:13 -0700 (PDT)
Received: from thinkpad ([117.213.100.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb2fa3a7sm1912804b3a.196.2024.08.08.22.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 22:21:13 -0700 (PDT)
Date: Fri, 9 Aug 2024 10:51:06 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Super Ni <super.ni@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, bvanassche@acm.org, beanhuo@micron.com,
	peter.wang@mediatek.com, avri.altman@wdc.com,
	cw9316.lee@samsung.com
Subject: Re: [PATCH] scsi: ufs: add missing macro for the UFSHCI register map
Message-ID: <20240809052106.GA2826@thinkpad>
References: <20240809025610.1000310-1-super.ni@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240809025610.1000310-1-super.ni@intel.com>

On Fri, Aug 09, 2024 at 10:56:10AM +0800, Super Ni wrote:
> Add macro for register bit listed in JESD223C (v2.1).
> 
> For completeness all registers specified in the JEDEC doc should be
> included here.
> 

I wouldn't say it is necessary as the macro is currently unused.

- Mani

> Signed-off-by: Super Ni <super.ni@intel.com>
> ---
>  include/ufs/ufshci.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 38fe97971a65..534fbb8988e2 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -43,6 +43,7 @@ enum {
>  	REG_UTP_TRANSFER_REQ_DOOR_BELL		= 0x58,
>  	REG_UTP_TRANSFER_REQ_LIST_CLEAR		= 0x5C,
>  	REG_UTP_TRANSFER_REQ_LIST_RUN_STOP	= 0x60,
> +	REG_UTP_TRANSFER_REQ_LIST_COMPLETION	= 0x64,
>  	REG_UTP_TASK_REQ_LIST_BASE_L		= 0x70,
>  	REG_UTP_TASK_REQ_LIST_BASE_H		= 0x74,
>  	REG_UTP_TASK_REQ_DOOR_BELL		= 0x78,
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
