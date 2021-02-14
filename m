Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478C1C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Feb 2021 09:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 117EE64E52
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Feb 2021 09:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhBNJya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Feb 2021 04:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229528AbhBNJy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 14 Feb 2021 04:54:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C06BA64E08;
        Sun, 14 Feb 2021 09:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613296428;
        bh=P7YH5U72rLYY0NLz86z2yrEBx/saP1+3AifXty9JevQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZ6hJFFOa/FRrqi/XhUc/S6Ef4mCS/qbHCuBXiAl/4DnhI2SMjC3oqEkuEZf2hdUY
         SW7Xe895SVpfztfh96pyArBQE6JjBtUAsqypQ5Wllb4DZNpoPYJRjdWbhQoeh3Q1Hj
         esjMZf9RsAAb1GcI5ZWtztMLGgsTlhouMDjfjtAE=
Date:   Sun, 14 Feb 2021 10:53:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Arthur Simchaev <Arthur.Simchaev@sandisk.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>
Subject: Re: [PATCH] scsi: ufs: sysfs: add is_ascii_output entry
Message-ID: <YCjzKOEV9fUPf3Ja@kroah.com>
References: <1612954425-6705-1-git-send-email-Arthur.Simchaev@sandisk.com>
 <4bba4245-df01-f23d-65ba-4ff133cae0bc@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bba4245-df01-f23d-65ba-4ff133cae0bc@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 10, 2021 at 07:35:25PM -0800, Bart Van Assche wrote:
> On 2/10/21 2:53 AM, Arthur Simchaev wrote:
> > +static bool is_ascii_output = true;
> 
> [ ... ]
> 
> >  static const char *ufschd_uic_link_state_to_string(
> >  			enum uic_link_state state)
> >  {
> > @@ -693,7 +695,15 @@ static ssize_t _name##_show(struct device *dev,				\
> >  				      SD_ASCII_STD);			\
> >  	if (ret < 0)							\
> >  		goto out;						\
> > -	ret = sysfs_emit(buf, "%s\n", desc_buf);			\
> > +	if (is_ascii_output) {						\
> > +		ret = sysfs_emit(buf, "%s\n", desc_buf);		\
> > +	} else {							\
> > +		int i;							\
> > +									\
> > +		for (i = 0; i < desc_buf[0]; i++)			\
> > +			hex_byte_pack(buf + i * 2, desc_buf[i]);	\
> > +		ret = sysfs_emit(buf, "%s\n", buf);			\
> > +	}								\
> >  out:									\
> >  	pm_runtime_put_sync(hba->dev);					\
> >  	kfree(desc_buf);						\
> 
> Please do not introduce a mode variable but instead introduce a new
> attribute such that there is one attribute for the unicode output and
> one attribute for the ASCII output. Mode variables are troublesome when
> e.g. two scripts try to set the mode attribute concurrently.

Agreed, just make a new sysfs file, please never change the output of an
existing sysfs file, that way will guarantee confusion in userspace.

thanks,

greg k-h
