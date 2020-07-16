Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AE7C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 07:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E50C420760
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 07:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TlbRof+r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgGPH7d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 03:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPH7c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 03:59:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6976BC061755
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 00:59:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so9219266wmh.4
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 00:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uG4bBgdzPJcKA1q7g4FtFtpm2iBs2j/GM+Sb6kg25uc=;
        b=TlbRof+rYJlkBPf8XiptFqKuw2HrpXZ1VY4dgL8lhgvotH8WSLyZ6WM5ruscewMAa/
         xc8y9a9PChZfMkR5G0/NVytcBx4Y9PVe3GR7dLCSUBzo7OBL+RpyOd1TCZfT2kenRSsg
         0mbN78mKxk+0+yPRqC3otegshWkTJX8r1/kG3NQ7V7HFd2D0LmYH+ySmqG3N2ePvboKZ
         R3bwfzAraRNU6h2ioXevSw5Q93gTIOF3UqNyryoZYAnnxWv9zPvWDsRpEOEtp5i+LSr6
         P3OrcHrF6qrr3+O8Mnp1vLE7RlOmhgFRni+aJZ0IjGln2bX3swC8L9sB6lVb+cH6j0bN
         TXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uG4bBgdzPJcKA1q7g4FtFtpm2iBs2j/GM+Sb6kg25uc=;
        b=TnJxmaS6Gz7XkMqkd0YFH9gLyvwqw7bip0EWoz5DNtDXuEzg9xJbjM2vY18DIAuF2F
         9CEafnuVDARoMQnOni3V9piWZyGOcwzv1u/Vh0E879+msOv+hPbBU836z2mDX7O2EFgU
         AbcLL8+G8uB68Uhm7JsW2R7KKTemaZxtmBrAuoWy7ZCWvIyYu+3F6+VM4eI8AFOlCt8g
         gMW2gxKjlGonlvJIxVpb8v6inrok34JOZQ/BN+wokqkCe9YyEh+fodIqWS7R10uofz09
         tSnPGdgZhPmSrzfhXp1sVa69hvkyWIOl1lt2OTDsyCxxpqhcmDdge0hDisaX/FSI+6HQ
         39Bw==
X-Gm-Message-State: AOAM530R2CIaFBLB5WnI0qzsSqpz51sc6ZKhLlijWeFBb16RigNLVaol
        DzcN/HY46Zd/xEpT3AZMnKM+Mw==
X-Google-Smtp-Source: ABdhPJwOWKHeO5JFPkGEDdmH3ebAmbF9RF3hYNjhebMarBxozbvU+CI7OjLE5KoTSHn8veV3NC5PYA==
X-Received: by 2002:a7b:cc85:: with SMTP id p5mr3106237wma.18.1594886371110;
        Thu, 16 Jul 2020 00:59:31 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id m4sm6951240wmi.48.2020.07.16.00.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 00:59:30 -0700 (PDT)
Date:   Thu, 16 Jul 2020 08:59:28 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, support@areca.com.tw
Subject: Re: [PATCH 16/30] scsi: arcmsr: arcmsr_hba: Make room for the
 trailing NULL, even if it is over-written
Message-ID: <20200716075928.GN3165313@dell>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
 <20200708120221.3386672-17-lee.jones@linaro.org>
 <yq1h7u8o7ck.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1h7u8o7ck.fsf@ca-mkp.ca.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Jul 2020, Martin K. Petersen wrote:

> 
> Lee,
> 
> > Ensure we do not copy the final one (which is not overwitten).
> >
> > -		strncpy(&inqdata[8], "Areca   ", 8);
> > +		strncpy(&inqdata[8], "Areca   ", 9);
> >  		/* Vendor Identification */
> > -		strncpy(&inqdata[16], "RAID controller ", 16);
> > +		strncpy(&inqdata[16], "RAID controller ", 17);
> >  		/* Product Identification */
> > -		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
> > +		strncpy(&inqdata[32], "R001", 5); /* Product Revision */
> 
> SCSI INQUIRY strings are fixed length and not NULL-terminated. Please
> address this warning using either memcpy() or strlcpy().

Will do.  Thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
