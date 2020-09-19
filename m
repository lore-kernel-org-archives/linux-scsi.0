Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF36C43464
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 05:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACFE420DD4
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 05:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r87xVDIj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgISFX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Sep 2020 01:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgISFX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Sep 2020 01:23:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D17C0613CE;
        Fri, 18 Sep 2020 22:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0fDOlzlc1pbD3D4J71zqPcDTsBH2r4s5TUXViHL8Vgw=; b=r87xVDIjDj9huTU7i312YRYhvM
        YIdZ7Ua89YhHJ+tmnVueuxW6UD/jdD0kE+p6+wNvlDUtkozc4z7oFtTBtS+y/Y/UQNgEA5NVj3pO7
        X95TdoVEMm6QyPK3pesEhayGJfroIZxoTD07MkGqEh+Z2oO84je4H5f2LXa5KkKHvFCMg3h28cnCe
        EhuX+X7UDMpbhsr1u1uak2/f6uaX/MGzykc+AiIOHHkqoBOASerFNmQIUgS5KLhz5w0gdZz6ymmjb
        xk8xy0nB/lkJ0nMRSsUiC9esWe6Q8eoNwFGP00L2wnqYIDBXMyrjQjzwp+ZAnq3mCDx4RMwVCaLcN
        8voqzQxg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVLk-00005i-TS; Sat, 19 Sep 2020 05:23:52 +0000
Date:   Sat, 19 Sep 2020 06:23:52 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        anand.lodnoor@broadcom.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/3] scsi: megaraid_sas: check user-provided offsets
Message-ID: <20200919052352.GD30063@infradead.org>
References: <20200918120955.1465510-1-arnd@arndb.de>
 <20200918121522.1466028-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918121522.1466028-1-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 18, 2020 at 02:15:22PM +0200, Arnd Bergmann wrote:
> It sounds unwise to let user space pass an unchecked 32-bit
> offset into a kernel structure in an ioctl. This is an unsigned
> variable, so checking the upper bound for the size of the structure
> it points into is sufficient to avoid data corruption, but as
> the pointer might also be unaligned, it has to be written carefully
> as well.
> 
> While I stumbled over this problem by reading the code, I did not
> continue checking the function for further problems like it.
> 
> Cc: <stable@vger.kernel.org> # v2.6.15+
> Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 861f7140f52e..c3de69f3bee8 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -8095,7 +8095,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  	int error = 0, i;
>  	void *sense = NULL;
>  	dma_addr_t sense_handle;
> -	unsigned long *sense_ptr;
> +	void *sense_ptr;
>  	u32 opcode = 0;
>  	int ret = DCMD_SUCCESS;
>  
> @@ -8218,6 +8218,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>  	}
>  
>  	if (ioc->sense_len) {
> +		/* make sure the pointer is part of the frame */
> +		if (ioc->sense_off > (sizeof(union megasas_frame) - sizeof(__le64))) {

Add a line break to avoid the overly long line - also the braces
around the arithmetics aren't actually needed.
