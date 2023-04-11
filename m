Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07283C7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 08:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjDKIRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 04:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjDKIQ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 04:16:59 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F8240DD;
        Tue, 11 Apr 2023 01:16:24 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id r27so9375617lfe.0;
        Tue, 11 Apr 2023 01:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681200983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sJS8zBMIa4yGBM2pgCprY9MksHdmJSvWOQj5E2cptIA=;
        b=YU81fhc+WGDqA6vOmGunfX4wlX0aWpvJfjNP2HLqlHL0v/g/5iUm/RouVRjGLji7Rv
         wd2d6ao9fhevKhdS70pbgQV/vN7rrn1X4zyFDdv5LeksBSImIgvzLv5ClSL6Injduk6s
         +itWkhz7StLKQel+CkAF0Pxs5xFHZraozkJzIt6pxZPkOyjbrAfsSCsGmm5x/6uF+6cZ
         bRIk7EEMcIDhI6saDXvo+dtzWw7IgUNbJd1QNbIO4TOfGP4SS/6Wsb0aJUP3u9CzMI/0
         557rYNr4R5BmCw/OpJjxPOcbxm8POKplhyolcURPzUkGK+HVysy1YSPpoZ3IE+W2swzm
         xFlQ==
X-Gm-Message-State: AAQBX9eZl+XBPYLl78C5bU7YitwG4tGWTuKDNknUxR4rK6SLCwAKVfWz
        a5Ry92bgti1WZF5lgJLPEU/OBEA74vj2ySme
X-Google-Smtp-Source: AKy350a7UaZAMSCzn65xlOqJYW/R9qLP7XhnRL4cIMZYtWbJHPPiE2f0rGK8HWRza1gugcKQzoaSaA==
X-Received: by 2002:a19:700b:0:b0:4e9:cb57:8fdc with SMTP id h11-20020a19700b000000b004e9cb578fdcmr3820604lfc.46.1681200982963;
        Tue, 11 Apr 2023 01:16:22 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id v24-20020a197418000000b004dc48d91061sm2444436lfe.304.2023.04.11.01.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 01:16:22 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 6D7DD4B7; Tue, 11 Apr 2023 10:16:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1681200980; bh=+xFiDUCypiXlTexCbmMF+XAWO9WmzRa1fOW09nLMocM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ibq7d9dddBbkfabWeP8xXgGdCACgJrRqmAAMVmrY6y3XPDt3qRtaD9zilG8fuwWe5
         A1f6ldQ/Jw/1SaZXl098GsFQYYUrGNUKEjsXt6Xrb769EalKkCJ4LjK1M9C+KgJ1Vw
         jhKmMlA/Zx52gk6HWVPIS+XC1xBrCWTkq4uuLyeQ=
Received: from x1-carbon (unknown [87.116.37.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id CDB263D7;
        Tue, 11 Apr 2023 10:15:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1681200953; bh=+xFiDUCypiXlTexCbmMF+XAWO9WmzRa1fOW09nLMocM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OH0YopyPaCiccsKR+08v3dLYx744pK6HLeF7kcGGtfX+JafgLIGeMYZKEJv3enXGC
         btOhP7SnWyE8z+9NU8+W/cNc4maQIsc0JR9d+qrquiIHVQQGFa0LVzlUBVy0P6PQD8
         xRWsBZTZf66yT0rmqK8/LNxECy6Ahilf9A3rO9kk=
Date:   Tue, 11 Apr 2023 10:15:46 +0200
From:   Niklas Cassel <nks@flawful.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
Message-ID: <ZDUXMl7HO8hEcMDv@x1-carbon>
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org>
 <20230411061648.GD18719@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411061648.GD18719@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2023 at 08:16:48AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 06, 2023 at 01:32:38PM +0200, Niklas Cassel wrote:
> > +	/*
> > +	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
> > +	 */
> > +	if (is_ata) {
> 
> I don't think these hacks have any business in the SCSI layer.  We should
> probbaly just do this unconditionally for CDL enabled ATA devices at
> probe time.

Hello Christoph,

While I agree that the pattern isn't especially beautiful,
the pattern is used in the SCSI layer already,
authored by none other than one of the SCSI maintainers themselves:
https://github.com/torvalds/linux/blame/v6.3-rc6/drivers/scsi/sd.c#L3066-L3074

I guess we could try to clean up all the occurrences of this pattern,
but considering that the pattern has existed in the SCSI layer for
10 years already, is it something that has to be addressed before this
series can be accepted?


Kind regards,
Niklas
