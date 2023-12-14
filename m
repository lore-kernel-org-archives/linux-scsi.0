Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c/cZNQ2Z"
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDDF18E
	for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 05:01:36 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-50be10acaf9so593033e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 05:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702558894; x=1703163694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hEBNj87fP9250zui4T/Hvg1xpkDfzNZnKnVDxt1bMUY=;
        b=c/cZNQ2Z0vfSqTkKgxr6lG0OXRJajUMTqpoy7zJ3VvQkPKHDIDqROQqUXD/DNNhz3w
         soLa1tsM9s7HUvfzVaXAKPrbejdY68Kkvu5UCN4q6raPbwHXHAoNswcy6qnI+gHixg2k
         egNpuOllT5hdaPCMfhC1KHhi+cISA249t8amqu8M7/IIr+725/WJIfq6GkQXM7YLU0aR
         sgtp2msCe9hTpuKtrJIZCSbb0mHtqPcqIu5Vb3WxOM7hZzPKJCAFe50eYvXDkuXRx+u5
         Ma8Kk6H811winPIQ2eRrn3d7ZBV3J8eR/x9JzfJyTCHP3hv0W37GJ2uDQMu6pehIGeX+
         B8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702558894; x=1703163694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hEBNj87fP9250zui4T/Hvg1xpkDfzNZnKnVDxt1bMUY=;
        b=Ct5cR8cUzEcCBVVXa1dzP0TtiOcHh0dR8FMsUUUFpb4Kgpzu+nF7Rgd+V8YrnBiS2H
         iUJA29f9yUJsNME+lN3CiFd6m/YW/ouNzajBCO+RtHBQSZq/E01EMrHLLhv1ZGVGRo7t
         qG8YNrfM8DIY5IeIny/u7rMlEDw7QZCnJEgDRevc2oMXB35eAQ86pI5wRvviOR6oR7oS
         jzqYl8d57l1JvDGriSp+614oeK/lPZOaXvtcPxwusdS7FczLgZ1p+lGUZoEYwjBR1B/S
         kLThroDUuZYUopXhwwKO+RHmMD5J/u41TiwvfwQReZbo7qON5lg1GxDzlEKmx2mLilYn
         PeVg==
X-Gm-Message-State: AOJu0YxsJ2XtxJopwZxhLWv168VByyafgQ3a1/lmnCyeUfMYt71yvuN9
	XihJ6TVVNfa+VeIXsISTI5omIA==
X-Google-Smtp-Source: AGHT+IHDwfUDUX4A8h+6BpYMmsxXIr+8mmt9c12FvptD9zihDInwN3uM8coAVGJ5D7hEzSztlmtQhw==
X-Received: by 2002:a05:6512:3ba6:b0:50b:e472:d825 with SMTP id g38-20020a0565123ba600b0050be472d825mr7069181lfv.20.1702558893836;
        Thu, 14 Dec 2023 05:01:33 -0800 (PST)
Received: from [172.30.204.158] (UNUSED.212-182-62-129.lubman.net.pl. [212.182.62.129])
        by smtp.gmail.com with ESMTPSA id m16-20020a056512115000b0050e1b9c6ff5sm34796lfg.265.2023.12.14.05.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 05:01:33 -0800 (PST)
Message-ID: <32a47aa9-4b4a-493d-879a-0cf3f7fe9c00@linaro.org>
Date: Thu, 14 Dec 2023 14:01:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: qcom: Fix ESI vector mask
Content-Language: en-US
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 andersson@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Halaney <ahalaney@redhat.com>
References: <20231214125532.55109-1-manivannan.sadhasivam@linaro.org>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20231214125532.55109-1-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: *



On 12/14/23 13:55, Manivannan Sadhasivam wrote:
> While cleaning up the code to use ufshcd_rmwl() helper, the ESI vector mask
> was changed incorrectly. Fix it and also define a proper macro for the
> value together with FIELD_PREP().
> 
> Reported-by: Andrew Halaney <ahalaney@redhat.com>
> Fixes: 0e9f4375db1c ("scsi: ufs: qcom: Use ufshcd_rmwl() where applicable")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
Looks sound

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
