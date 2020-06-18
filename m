Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79F6C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6FA2082F
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dOtH3Q4z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbgFRNtR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730345AbgFRNtP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 09:49:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF156C06174E;
        Thu, 18 Jun 2020 06:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n9BaMVUCaVyJLD8yPDoe2PtpH60KSIZHmuyQxc4LjSI=; b=dOtH3Q4zNMES4xCLLlwm8XQOUW
        toJqrLIhJk4+L36KIPooyLY2K+UIaOFzzH+nOTfHQn4SIFVcucJOYD41Peuylc3Cmoo+Kbx3eznT+
        yiJ8B0pqNDI5LBVOETjtrjUw8ikMKL3NhEOyPbWqbZl2a2o9feAYkULaMnIO3N0zzEUwh5XJIrtY9
        SXwQo/k2otshC7Kt906KTwQm27+bhgksFt+1c2mNvKd+nsB1pFykEHIfOCJnl8DfCsCn9JHfXlNoY
        nweICrbUL4Aq3invuQwb2yeiRR40IQLPk7otS2mHGH3fbstvgLwQLZlGrPbT7v0O4Y/UUefbSPZpw
        xVB/m5gA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jluue-0006zB-1Q; Thu, 18 Jun 2020 13:49:04 +0000
Date:   Thu, 18 Jun 2020 06:49:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Simon Arlott <simon@octiron.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200618134904.GA26650@infradead.org>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <20200618072138.GA11778@infradead.org>
 <9877e7de-d573-694b-2b75-95192756684b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9877e7de-d573-694b-2b75-95192756684b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 18, 2020 at 01:25:18PM +0100, Simon Arlott wrote:
> On 18/06/2020 08:21, Christoph Hellwig wrote:
> > On Wed, Jun 17, 2020 at 07:49:57PM +0100, Simon Arlott wrote:
> >> Avoiding a stop of the disk on a reboot is appropriate for HDDs because
> >> they're likely to continue to be powered (and should not be told to spin
> >> down only to spin up again) but the default behaviour for SSDs should
> >> be changed to stop them before the reboot.
> > 
> > I don't think that is true in general.  At least for most current server
> > class and older desktop and laptop class systems they use the same
> > format factors and enclosures, although they are slightly divering now.
> > 
> > So I think this needs to be quirked based on the platform and/or
> > enclosure.
> 
> Are you referring to the behaviour for handling HDDs or SSDs?

All of the above.

> 
> For HDDs, the default "1" option could mean "automatic" and apply to
> rotational disks when power loss is expected.
> 
> For SSDs, I don't think an extra stop should ever be an issue.

Extra shutdowns will usually cause additional P/E cycles.
