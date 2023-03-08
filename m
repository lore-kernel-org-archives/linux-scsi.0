Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44590C64EC4
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 19:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCHTD2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Mar 2023 14:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCHTDN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2023 14:03:13 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E087C9A5D;
        Wed,  8 Mar 2023 11:02:17 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id ky4so18638336plb.3;
        Wed, 08 Mar 2023 11:02:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=59ePLVmL3F1KrrKq89CAv86Sh6HNO1uk3XVJytbOGkk=;
        b=m1Hq98ECagHzzgBvzv2Ce0Q7UqSSdOGr+Vx97aYvIB37Ognq6buO11TQqCD/ZcbCkx
         mHuU/cJI98/4XzIJY7qfUx5QjhNyDA0hwRZ5JeuRFohO3BftvsREY5PbjE2KRqwCYCt+
         7nhc6oQecHsqHI92mkgkYTy2IKZG6wtzFzSwiagdIr62MXhicQSKkUbsUIqLi2l87z8M
         NnDWuqLKw5mAweJ7Ygq6MIpixKnVx04agxWMXiHhhXQovZbYkgOv+4DjNAS7NPcC/JVz
         OgyHhfua9tVcA/BJoelzHdzXgVvIDuII53tmi7VQKwdljrLnuVM3irqRZZmKamlfl3Mp
         HC0A==
X-Gm-Message-State: AO0yUKVSKgfekWGZQps20TNFn2QvxT/6Mr7EP9l9to4su+Eqvo0h5mrG
        Wo6r+/hGpJBU6m9pn5OG0tg=
X-Google-Smtp-Source: AK7set+iLuBw1GwVoKigqbk5yHxe7zgcH4+1FNXbwyPyyBwm18dAioKqZxj/N+dO9UbrAeym667ehA==
X-Received: by 2002:a17:902:e546:b0:19e:8675:af3 with SMTP id n6-20020a170902e54600b0019e86750af3mr23497306plf.33.1678302136885;
        Wed, 08 Mar 2023 11:02:16 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b001992fc0a8eesm1283638ple.174.2023.03.08.11.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 11:02:16 -0800 (PST)
Message-ID: <85994527-d09d-f381-3dda-7cfb9ce98d4b@acm.org>
Date:   Wed, 8 Mar 2023 11:02:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 4/4] ufs: mcq: Added ufshcd_mcq_abort()
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1678247309.git.quic_nguyenb@quicinc.com>
 <c7fcbb70f0e74d225c1a09f107ba1058270739be.1678247309.git.quic_nguyenb@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c7fcbb70f0e74d225c1a09f107ba1058270739be.1678247309.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/23 20:01, Bao D. Nguyen wrote:
> +	if (ufshcd_mcq_cqe_search(hba, hwq, tag)) {
> +		dev_err(hba->dev, "%s: cmd found in cq. hwq=%d, tag=%d\n",
> +				__func__, hwq->id, tag);
> +		/*
> +		 * The command should not be 'stuck' in the CQ for such a long time.
> +		 * Is interrupt missing? Process the CQEs here. If the interrupt is
> +		 * invoked at a later time, the CQ will be empty because the CQEs
> +		 * are already processed here.
> +		 */
> +		ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +		err = SUCCESS;
> +		goto out;
> +	}

Please remove the above code and also the definition of the 
ufshcd_mcq_cqe_search() function. The SCSI error handler submits an 
abort to deal with command processing timeouts. ufshcd_mcq_cqe_search() 
can only return true in case of a software bug at the host side. 
Addressing such bugs is out of scope for the SCSI error handler.

Thanks,

Bart.
