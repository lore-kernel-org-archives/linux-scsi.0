Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400A4C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 23:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2BD207BA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589411104;
	bh=MFOJdxtS3/IHpGHNwAsHtxdCXiGJ3XzgovPrUtXJWWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1X6zwhE+B+tO9jPdeLQ8eJhQzeZrV/gErDEngqb+/PeAbufw105kp03QAZRB2HtB+
	 RCQS0BP7z0Yncs/ADxCF552XF8/fpg6AsZGDZmzc7aRYlO9bA2Uz3JlSy40/lWjIuK
	 uxKwbs8zBFYUv8MhModaJHZXSPisfYpadYLycIDw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbgEMXFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 19:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731815AbgEMXFD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 19:05:03 -0400
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2332A20693;
        Wed, 13 May 2020 23:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589411102;
        bh=MFOJdxtS3/IHpGHNwAsHtxdCXiGJ3XzgovPrUtXJWWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6Z5m73PLAC/1EjuSrPHG0cnziR0COEQ+x8h7DZpq9EyP5mGBqka5pDwAXOpFoqCQ
         wlVCetyg2N3VlBtjekqyGKBGoRxs5P7irKPvtqgJSURov8fIEhX2fegbNrawE/BQAx
         uu9MmecrNrpKLhYHhhFmrq4RNdg4/Dxhh3xiMYt8=
Date:   Thu, 14 May 2020 08:04:55 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Tony Asleson <tasleson@redhat.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/7] nvme: Add durable name for dev_printk
Message-ID: <20200513230455.GA1503@redsun51.ssa.fujisawa.hgst.com>
References: <20200513213621.470411-1-tasleson@redhat.com>
 <20200513213621.470411-8-tasleson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513213621.470411-8-tasleson@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 13, 2020 at 04:36:21PM -0500, Tony Asleson wrote:
> +static int dev_to_nvme_durable_name(const struct device *dev, char *buf, size_t len)
> +{
> +	char serial[128];
> +	ssize_t serial_len = wwid_show((struct device *)dev, NULL, serial);

wwid_show() can generate a serial larger than 128 bytes.

> +
> +	if (serial_len > 0 && serial_len < len) {
> +		serial_len -= 1;  // Remove the '\n' from the string

Comments in this driver should use the /* */ style.

> +		strncpy(buf, serial, serial_len);
> +		return serial_len;
> +	}
> +	return 0;
> +}
