Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974CBC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 06:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 712C320776
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 06:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590474823;
	bh=ekoHJmuDYgfF1SuG9z404kGqxsTf0Kd2lPtuC2TdX78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZK4vWxSo/6czpszF+rtOZMTnkjK0UHIxlVyIuKZ2+9dpaDL/p50ts6qVZIf+ve4Yn
	 MG/dZsFqY5GIC6yKjg2A2zQ/5lbm2Gy9ideR0hkFFXZ44ksEWTLVOhv8K//u3Z0ppp
	 E4tAEtrfjlorlt+ZIAqahlUUtGA8G7Oi0tfowha8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgEZGdk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 02:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgEZGdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 02:33:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 493922073B;
        Tue, 26 May 2020 06:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590474816;
        bh=ekoHJmuDYgfF1SuG9z404kGqxsTf0Kd2lPtuC2TdX78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=upgmfSg6+hyi2RnYD15UKVCUWWpzVmk35guz+ryNT4da9EZJ7evbDVNO0PKMLrqsQ
         +fGZzarS6/XMZfmdW21nbzBX5BfMvv+D0W3fk0eD7I2f2aKeRnpBAyI0v+M2ILIryk
         7qnBc+AjLpsROB+BxZwolVoeKKpBh4GZdOQAKZLI=
Date:   Tue, 26 May 2020 08:33:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/8] driver core: Add helper for accessing Power
 Management callbacs
Message-ID: <20200526063334.GB2578492@kroah.com>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-2-kw@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525182608.1823735-2-kw@linux.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 25, 2020 at 06:26:01PM +0000, Krzysztof Wilczyński wrote:
> Add driver_to_pm() helper allowing for accessing the Power Management
> callbacs for a particular device.  Access to the callbacs (struct
> dev_pm_ops) is normally done through using the pm pointer that is
> embedded within the device_driver struct.
> 
> Helper allows for the code required to reference the pm pointer and
> access Power Management callbas to be simplified.  Changing the
> following:
> 
>   struct device_driver *drv = dev->driver;
>   if (dev->driver && dev->driver->pm && dev->driver->pm->prepare) {
>       int ret = dev->driver->pm->prepare(dev);
> 
> To:
> 
>   const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
>   if (pm && pm->prepare) {
>       int ret = pm->prepare(dev);
> 
> Or, changing the following:
> 
>      const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> 
> To:
>      const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
> 
> Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
> ---
>  include/linux/device/driver.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
> index ee7ba5b5417e..ccd0b315fd93 100644
> --- a/include/linux/device/driver.h
> +++ b/include/linux/device/driver.h
> @@ -236,6 +236,21 @@ driver_find_device_by_acpi_dev(struct device_driver *drv, const void *adev)
>  }
>  #endif
>  
> +/**
> + * driver_to_pm - Return Power Management callbacs (struct dev_pm_ops) for
> + *                a particular device.
> + * @drv: Pointer to a device (struct device_driver) for which you want to access
> + *       the Power Management callbacks.
> + *
> + * Returns a pointer to the struct dev_pm_ops embedded within the device (struct
> + * device_driver), or returns NULL if Power Management is not present and the
> + * pointer is not valid.
> + */
> +static inline const struct dev_pm_ops *driver_to_pm(struct device_driver *drv)
> +{
> +	return drv && drv->pm ? drv->pm : NULL;

I hate ? : lines with a passion, as they break normal pattern mattching
in my brain.  Please just spell this all out:
	if (drv && drv->pm)
		return drv->pm;
	return NULL;

Much easier to read, and the compiler will do the exact same thing.

Only place ? : are ok to use in my opinion, are as function arguments.

thanks,

greg k-h
