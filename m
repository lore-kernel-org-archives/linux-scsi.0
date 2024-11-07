Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C244C1EE01A
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730976603; cv=none; b=E5OyiJUXtPzAu3rwu6skrgezaMeFvsVKI1stDOq2ha6znj767rJY0pxli9kYkJNYJuupmpzuONdoeEBLVMjej30M2K+X+uCjmBYW3n8wtVbVf0fT3tH+XDFUFXKIYxzH2YDq+iHlH1ea1nqTCTNn76/0xu/fu29YRnDOH90QhvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730976603; c=relaxed/simple;
	bh=gMn8YDea/YRpuQGOaEGD+Otb5SAWn9i8yRRholZmtqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ieNDBTrs77CG4369fmplgm9LUsvJBTTynZVYJj4FmRz4SyBcAC+TzkAeh9ceh4uGbyAbJjktFxj0VGQ30SkOPc9CX6/j95ClYEVj40B0gMTEd8OWts+xu0bxt200WDaKSnm+OjwGhoy/ILN+NDIUQZ9JViQcvotXLLGG4Hr9OE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AhAw7AUG; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AhAw7AUG"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d47b38336so552922f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2024 02:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730976600; x=1731581400; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3rZTXCjOa5hTE5xeWoRiKizFddIJm9m7cEOdNlU7WYU=;
        b=AhAw7AUGYPH4aVOxbHiRagM4+qPKnwpIMyriQ9sQ8R6uCc4vMPDHIPYX6qB8r2Ly8t
         jWSenjFA7T5AcDR+hBpjUuKedIRr6f3z+DelzvKdYeWMMJS3eEzsoktY8G7RuenhlcNO
         yEtqlJYalDzrrCSd2Uoes2bp5qhklnlVCztFACu0ghNqSQ+TCZjwqZ5nUQTmHpdlQLR+
         KCA0AuZOn0S4W52Wd5AHTmrMxzp6XhYLfnto3y/KOq8MHoYr6YnQ17LQANO9jq8vrtYk
         n7A1Ps2kYbXxAI3cjEgsSEmXZqIYhTyymtd1iXBZMhWz4vSVK7Wn3l86XhgGtkTGrGWK
         6OLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730976600; x=1731581400;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rZTXCjOa5hTE5xeWoRiKizFddIJm9m7cEOdNlU7WYU=;
        b=bfw4Fj4m1hqPSwgss4mnfMNqNTUmWZOR2gWVhjCsVScURQiQze77mtg4BD0WtXfDo1
         amhoPC9WVhVV0QL9kNXOX+kmsW10TeH8EkzxhjX8nW956kX+YpEkIMvzApMXuNc9PL/4
         BVKKu2zzK+C72aZ6wWnggQbtmzIusJnTd57U1tih2j4ZPY2vI8oKeAo7wG4OaPQNBErk
         mKk6ou/ZqXiaHT4uKvP45ZdOtHcfv+nR7sCYjdmzpNQrr6rUFpmNRdoLoMQNDZcpIIMF
         FUPq9XJMlBgqlEv1h47LtzdtP7ehMBP/zmpG8XGS0UJEEeel9LlV4TE82yiYD5+mrlrL
         qwlw==
X-Forwarded-Encrypted: i=1; AJvYcCV+Gpnut/esPLX7i0+AqAptGaDEySNlfsQvM3d+THYn6v5neMPWwiH43m30UxjpPRpmT2mZptUjdoqm@vger.kernel.org
X-Gm-Message-State: AOJu0YxnHxM0awk66tzM67Gdlv0q6NjDRtX4V7424T2noQpjrErjrvcp
	VKqCcLViu3ZIf8sf+B7K0LSnhamFMBJbxwUASxpplqMeKUby7S/ZD2webt7j4w==
X-Google-Smtp-Source: AGHT+IETxLU4h4BMJIqYUqiK9iZfGOl3umybZQ0qi4ff4C2lxoysb7JF8iMFcWg8xWmkaKaDZJwmSg==
X-Received: by 2002:a5d:5711:0:b0:37d:47b0:6adc with SMTP id ffacd0b85a97d-380610f8251mr31259498f8f.4.1730976600141;
        Thu, 07 Nov 2024 02:50:00 -0800 (PST)
Received: from thinkpad ([89.101.134.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed987d95sm1393241f8f.44.2024.11.07.02.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 02:49:59 -0800 (PST)
Date: Thu, 7 Nov 2024 10:49:58 +0000
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: neil.armstrong@linaro.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH v6 11/11] scsi: ufs: core: Move code out of an
 if-statement
Message-ID: <20241107104958.ufanaxocws2dmdwq@thinkpad>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
 <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
 <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
 <19b75e1d-bc36-494d-a33a-d36a1646bcc7@linaro.org>
 <6b20595d-c7f6-42aa-922e-3671abd7917c@acm.org>
 <1c9acc01-7b1d-41ac-a0da-4e50dc8f0319@acm.org>
 <6b37ac2c-e3bd-48d0-bc50-4fa2e5789d3d@linaro.org>
 <79516d73-7ca1-4af7-87cb-d8d87d4dc6ac@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79516d73-7ca1-4af7-87cb-d8d87d4dc6ac@acm.org>

On Wed, Nov 06, 2024 at 09:51:06AM -0800, Bart Van Assche wrote:
> On 11/6/24 1:57 AM, Neil Armstrong wrote:
> > Thanks, it does fix the issue. But it won't scale since the next
> > platforms will probably need the same tweak in the future.
> > 
> > Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
> > Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
> 
> Hi Neil,
> 
> Thanks for testing!
> 
> The comment about future platforms is not clear to me. This patch fixes
> support for a non-standard controller (reports UFSHCI version 4 but
> supports UFSHCI 3 register set). Shouldn't all future platforms support
> the UFSHCI 4 register set?
> 

Yeah, the future platforms should (hopefully) no longer have this issue.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
