Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BF2C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 03:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D587E207D8
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 03:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bF66ETAA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgEZDBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 23:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgEZDBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2020 23:01:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1F9C061A0E
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2020 20:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SnRXYj2ibbIaL8JMN42ihxMgZRRhxfkb9uccAYVEXRk=; b=bF66ETAAi8JVtaHodyPIodZhU6
        mCKhu6+2OmwHZ1M/paLQdsP0ZaChUEXNDRpigKzQcO52pXZe1oWdW2Wv3pGJ15QI9NW/zfDxVox3Y
        PmQSFRnX706CzniMBqsV+lLDl275zMRAz6/iGKdMLeuVkgZ+5L06lbaTh7NZBtClJlnh6YUiVCGJV
        Ihrya7n8X2/x8gHNcSVnGNsbgT5dnZljbIQWI12OKV4s4ua3F0ex5+JbB6YfY9b3yLPa4FlUz1Wrn
        0prfVW4fsjQo3RBrN25MxOLs21M5SlMAkNPrqkcCGqIAqModWblKQAs26erVwyc5EX2uq78e243/x
        MJ4lgKQw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdPqA-0003nG-S9; Tue, 26 May 2020 03:01:18 +0000
Date:   Mon, 25 May 2020 20:01:18 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Subject: Re: [RFC v2 1/6] scsi: xarray hctl
Message-ID: <20200526030118.GF17206@bombadil.infradead.org>
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-2-dgilbert@interlog.com>
 <6527a0ca-954c-70e8-f0f5-08206c1779f2@suse.de>
 <8dab99d1-a22d-0065-5a7a-fd9b80bc661a@interlog.com>
 <20200525174052.GD17206@bombadil.infradead.org>
 <f11f3d83-19a5-7a2a-bf14-917536514f68@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f11f3d83-19a5-7a2a-bf14-917536514f68@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 25, 2020 at 10:01:59PM -0400, Douglas Gilbert wrote:
> When using xarray to store a bitset (e.g. say the 9 states in:
>    enum scsi_device_state   [include/scsi/scsi_device.h]
> as 2**0, 2**1, 2**2 .... 2**8), is there a mask to indicate which bit
> positions are used internally by xarray? Or are the full 32 bits available,
> other than the special value 0 aka NULL?

erm ... not quite sure what you mean by 'bitset'.  Are you saying that
you want to store a number between [0..511] at a particular offset in
the array?  If so, you want xa_mk_value(N) to turn a value into an xarray
entry.  When you load it, you can check it's a value with xa_is_value()
and convert it back to an integer with xa_to_value().  You han have up
to 31/63 bits that way, depending on sizeof(void *).

> Plus, based on the answers I get from above questions, in the
> scsi_lu_low32 class I would like to add another xarray, that holds
> bitsets rather than pointers. Each bitset holds amongst other things
> the 9 scsi_device states. That way you could iterate through all
> LU devices looking for an uncommon state _without_ dereferencing
> pointers to any sdev_s that are bypassed. And if xarray is cache
> efficient in storing its data, then it would be much faster. The
> same thing (i.e. bitset xarray) could be done in scsi_channel, for
> starget states.

Sounds like you really want more search marks.  This is a relatively common request and is disappointingly hard to do efficiently with the current XArray.
It's a request that should be solved with the new data structure, but
see earlier comments on when you might see that.

In the meantime, you might consider using an IDA for an efficient
expandable bitmap.  It's built on top of the XArray, but stores only
one bit per index instead of a pointer.  You'd need nine IDAs for nine
bits of state ...


