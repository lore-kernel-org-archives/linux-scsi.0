Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3270C4741F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 17:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D49B20C09
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 17:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K3GjiPVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgI2RvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgI2RvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 13:51:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C84AC061755;
        Tue, 29 Sep 2020 10:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K0HIZbd/IW8lh9ZNFKueIeHzbdTWMGh2WLJ5iwa1bDI=; b=K3GjiPVUSNcqOt+DqMFciinpgK
        bW5vn31ffFvKXEPMSXBZ4KO40Svjj4L43Iu4+qg/jmsmNSONdvwbGLR5yPP5NwhUvY6IaNx3kqkNF
        lIiA78KaltunExefi8x+arOH/wRWEGpzyfpZovZCIq2yLzLlITQ7LayurF1VOd8FL0r+BpGVypwHm
        4gVKQP032/aFpcQLE8uC6/pFb6u80kWwMaJO065Y833g5xzzsLKhDmqmHzYHErRQmoC1JoVrVosLW
        j1Etn3FcWZjXy+NdYGls739qMGXYbSWMIaktCYeSvTu/TuVETRqxqUq2XtJGe50lFIr9PsxgiBxA2
        UZOM9/Yg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kNJmI-0000bT-7v; Tue, 29 Sep 2020 17:51:02 +0000
Date:   Tue, 29 Sep 2020 18:51:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Tony Asleson <tasleson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
Message-ID: <20200929175102.GA1613@infradead.org>
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925161929.1136806-2-tasleson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Independ of my opinion on the whole scheme that I shared last time,
we really should not bloat struct device with function pointers.

On Fri, Sep 25, 2020 at 11:19:18AM -0500, Tony Asleson wrote:
> Function callback and function to be used to write a persistent
> durable name to the supplied character buffer.  This will be used to add
> structured key-value data to log messages for hardware related errors
> which allows end users to correlate message and specific hardware.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> ---
>  drivers/base/core.c    | 24 ++++++++++++++++++++++++
>  include/linux/device.h |  4 ++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 05d414e9e8a4..88696ade8bfc 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2489,6 +2489,30 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
>  }
>  EXPORT_SYMBOL_GPL(dev_set_name);
>  
> +/**
> + * dev_durable_name - Write "DURABLE_NAME"=<durable name> in buffer
> + * @dev: device
> + * @buffer: character buffer to write results
> + * @len: length of buffer
> + * @return: Number of bytes written to buffer
> + */
> +int dev_durable_name(const struct device *dev, char *buffer, size_t len)
> +{
> +	int tmp, dlen;
> +
> +	if (dev && dev->durable_name) {
> +		tmp = snprintf(buffer, len, "DURABLE_NAME=");
> +		if (tmp < len) {
> +			dlen = dev->durable_name(dev, buffer + tmp,
> +							len - tmp);
> +			if (dlen > 0 && ((dlen + tmp) < len))
> +				return dlen + tmp;
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dev_durable_name);
> +
>  /**
>   * device_to_dev_kobj - select a /sys/dev/ directory for the device
>   * @dev: device
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 5efed864b387..074125999dd8 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -614,6 +614,8 @@ struct device {
>  	struct iommu_group	*iommu_group;
>  	struct dev_iommu	*iommu;
>  
> +	int (*durable_name)(const struct device *dev, char *buff, size_t len);
> +
>  	bool			offline_disabled:1;
>  	bool			offline:1;
>  	bool			of_node_reused:1;
> @@ -655,6 +657,8 @@ static inline const char *dev_name(const struct device *dev)
>  extern __printf(2, 3)
>  int dev_set_name(struct device *dev, const char *name, ...);
>  
> +int dev_durable_name(const struct device *d, char *buffer, size_t len);
> +
>  #ifdef CONFIG_NUMA
>  static inline int dev_to_node(struct device *dev)
>  {
> -- 
> 2.26.2
> 
---end quoted text---
