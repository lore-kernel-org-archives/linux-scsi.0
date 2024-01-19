Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABA65645A
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2024 20:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705694843; cv=none; b=nX7h1q4IajpHW+70/OI4855SK5PvZt6LQ9q7Ru0KzX/OMAgORpkxhblr3Tbdc+dUcZKO4KfMKgLHqHAswYnSmuZyFgw7ejiVzIG/8Fv9SLhmOxFsYBn99E/Yu8T5cmb4iqn7T4TiKLkH9RiTFu3TOSWh3IP4mA4RwutAnf5dwhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705694843; c=relaxed/simple;
	bh=YdNXxj0w17h5QP/tzMu7WSTG5VMhmCNDDh28oDicwvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jyNgnlcHt9Qffa/nuIin8Fg1vgCDhhzbPCtvIk6Vxz7AIZoM+dyj0zrrHdzNDZgUR+VApYQMZtvi/l077egfZ0lrIPmRCcaUadDLgAtUmP0plXnA38muXRJ5jV5xMGM/8FRFOOnqFLDzPD38j6zGgcVg6CYTmRtkwZsfd2gBh5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8RcVQaP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8RcVQaP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705694840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e+iHLJZxESiahEJj/CqZklWFw9w1AJTKhqRDxbdFUts=;
	b=R8RcVQaPy968lWKMg6E2RD81xDjHNDo+pVCZUy9N4gL5ztFqweDKAbDyveohSKXWMMbcyh
	dqk0ZQyj00xKz8YlDWyYFZdP8olQDRti2i3wpyAKog09Jp4C2GvksWq75CV0kBWEYQY84U
	izAyNlSC1+IDkF5y8nUuZBnrS2+ACYQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-s6X5FEmsMo2HBVFKkr3CAQ-1; Fri, 19 Jan 2024 15:07:19 -0500
X-MC-Unique: s6X5FEmsMo2HBVFKkr3CAQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-68192812b38so11108946d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2024 12:07:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705694838; x=1706299638;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+iHLJZxESiahEJj/CqZklWFw9w1AJTKhqRDxbdFUts=;
        b=lMCM7Emu6GChEOxxXrQqRhQr0/cxkWJA6rFPEwa0+v7V0JUcsVSFII6PYtB4zaMGbi
         t3tjslgdPe6RvPlUVR+gwFzDO/Qma38afSOHn71Y0jIwusZmXMnvoSsSWAOsor4sP+zx
         Z8ElEhniNJ6n1H6OGgqJtNjKGHg4O0pMpCxiaExbe/bTK0olMjfGoUepl5XL1lCrTnKV
         5AXQkDz2wdzr0puJtBjg2QUUVn2h5Tn3cD4kmoZBKGNg6X624fPZ+d/egc7Isx0qh2y0
         PLyr/fh8+jyq92N7eSEDXZH8tD8+WTmWam1Y79xmPdf+oFJxq1d1tgPG6CTfzPcC/Liq
         zhUQ==
X-Gm-Message-State: AOJu0YxxrERWG2D28hbKqtFHdFAxyfL13gKp1/Rknf3sZl201J2o7te2
	zZuCWGpWwzudrMOgypVTV/JlB0DZxMrNWYX6fIchcMH4KzDJoOdtjHqbwBYTxhDdvLVb6lLYd5M
	gFnNc16+MlO4zvyBgvvEq5eEwyrb4voR2usSQBzSAZmr539czd4aH2gQTxZqBH8ldzh8=
X-Received: by 2002:ad4:5945:0:b0:683:8515:f307 with SMTP id eo5-20020ad45945000000b006838515f307mr557864qvb.33.1705694838322;
        Fri, 19 Jan 2024 12:07:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDe+STdxmaFDENNUNvlMwVKvosPG8WQxaoWa8qAzfd+pnR9so75xcYFPgOr3sjFtSaQr6/ww==
X-Received: by 2002:ad4:5945:0:b0:683:8515:f307 with SMTP id eo5-20020ad45945000000b006838515f307mr557847qvb.33.1705694838035;
        Fri, 19 Jan 2024 12:07:18 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id fn15-20020ad45d6f000000b00680c25f5f06sm7131138qvb.86.2024.01.19.12.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jan 2024 12:07:17 -0800 (PST)
Date: Fri, 19 Jan 2024 14:07:15 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: avoid re-init quirk when gears match
Message-ID: <3xnedre2d32rkad6n2ln4rrah7sgg6epxnzsdm54uab3zrutnz@fww7wb5mvykj>
References: <20240119185537.3091366-11-echanude@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240119185537.3091366-11-echanude@redhat.com>

On Fri, Jan 19, 2024 at 01:55:47PM -0500, Eric Chanudet wrote:
> On sa8775p-ride, probing the hba will go through the
> UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH path although the power info
> are same during the second init.
> 
> If the host is at least v4, ufs_qcom_get_hs_gear() picked the highest
> supported gear when setting the host_params. After the negotiation, if
> the host and device are on the same gear, it is the highest gear
> supported between the two. Skip the re-init to save some time.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
> 
> "trace_event=ufs:ufshcd_init" reports the time spent where the re-init
> quirk is performed. On sa8775p-ride:
> Baseline:
>   0.355879: ufshcd_init: 1d84000.ufs: took 103377 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> With this patch:
>   0.297676: ufshcd_init: 1d84000.ufs: took 43553 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> 
>  drivers/ufs/host/ufs-qcom.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 39eef470f8fa..f9f161340e78 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -738,8 +738,12 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  		 * the second init can program the optimal PHY settings. This allows one to start
>  		 * the first init with either the minimum or the maximum support gear.
>  		 */
> -		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> +		if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> +			if (host->hw_ver.major >= 0x4 &&

Is this check really necessary?

The initial phy_gear state is something like this (my phrasing of
ufs_qcom_set_phy_gear()):

    if hw_ver < 4:
        # Comments about powering up with minimum gear (with no
        # reasoning in the comment afaict), and mentions switching
        # to higher gear in reinit quirk. This is opposite of the later
        # versions which start at the max and scale down
        phy_gear = UFS_HS_G2

    else if hw_ver == 4:
        phy_gear = hs_tx_gear # (so afaict always UFS_HS_G4)

    else if hw_ver >= 5:
        phy_gear = hs_tx_gear # (What ever the max is for this version)

        if dev_major:
            # Clears the reinit quirk in ufs_qcom_set_phy_gear() if the
            # device version is provided by bootloader / controller
            # because we already found it out and can init directly
            # to the ideal gear
            quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH

            if dev_major < 4:
                # Sets gear to UFS_HS_G4 to save power for UFS 3.1 and
                # older devices
                phy_gear = UFS_HS_G4

I guess what I'm saying is that I'm not totally seeing how this check
is dependent on the controller version. To me, if we're in the ideal
gear already and we know it, we should *not* reinit, no matter what the
controller version is. That's assuming there's not some other reasoning
for the quirk, but as far as I understand it the quirk exists because we
have to start with *some* phy gear value so we can talk to the device,
and once we discover what the device is capable of it makes sense to
scale down (or up for older controllers) to the ideal gear setting for
the attached device. Unfortunately to do the change we have to
reprogram the phy which I guess is only acceptable if we reprogram
everything (hence the reinit).

Does that make sense or do you think I'm missing something? I think say
even for an older controller this makes sense, if its attached to a
UFS_HS_G2 capable device there is no reason to reinit since we started
up in the ideal configuration.

Thanks,
Andrew

> +			    host_params->hs_tx_gear == dev_req_params->gear_tx)
> +				hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>  			host->phy_gear = dev_req_params->gear_tx;
> +		}
>  
>  		/* enable the device ref clock before changing to HS mode */
>  		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
> -- 
> 2.43.0
> 
> 

