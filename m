Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6245BC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 12:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2FC2076C
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 12:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591618721;
	bh=IxaSzRjxanv/DR7UbdfuWQJ8sWNLNQqOrjxqUE5oSqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=n3QFBN7AUJgFPkzfthMmdesHLjXH5bmTWgeYtsS6M6PyIN6xAGoe+8Nm2xpocbpcH
	 vPj6UcNIgFQaEPvtAUKLrEMkbzqoQ4onB0ICpjf8yEUfVXKAxTBOPPlaXTDyBQKUiE
	 F87r4/tK47GsYf5oFBQSXUFd8gmIekYxvqz6UrQ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgFHMSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 08:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729310AbgFHMSk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jun 2020 08:18:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B804206C3;
        Mon,  8 Jun 2020 12:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591618720;
        bh=IxaSzRjxanv/DR7UbdfuWQJ8sWNLNQqOrjxqUE5oSqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n9JpKCzl3mOSV0Yisss9s7Hm4rqO2E0s3fhmEStYBdZ7Kkk0DAy4k6C1Xrnt8sQFd
         Stw0/sDGBl1uQhPZ2bsOaPI6SFTA9ngkYl7Wr12JdA9AG+mQSuDXDpTpVz4Gogb+84
         rVx4lsfMLlzvsycBM//tavufpgaIz3TOJ+kCjFIc=
Date:   Mon, 8 Jun 2020 14:18:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-ID: <20200608121838.GC306451@kroah.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 07, 2020 at 03:35:58PM -0500, Mike Christie wrote:
> +#define target_attr_str(field)		\
> +	target_attr_show(field)		\
> +static DEVICE_ATTR(field, S_IRUGO, show_target_##field, NULL)

DEVICE_ATTR_RO()

> +#define tpt_id_attr(name, fmt_str)		\
> +	tpt_id_attr_show(name, fmt_str)		\
> +static DEVICE_ATTR(name, S_IRUGO, show_tpid_##name, NULL)

DEVICE_ATTR_RO()

