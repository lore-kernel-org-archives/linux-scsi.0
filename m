Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3739C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AEAD20665
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JHmufwhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfHLOYw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:24:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51246 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfHLOYw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PLJIvvBTdV9EjMwxu+D+ABFEIYQIUS5OWJSofu5BpKs=; b=JHmufwhhujSf1phXuI0Ah3yb9
        QStJ0p5GPKKSQ/AU7GyPXj41A3ugv9GGqb/Qko89oIVgntAoKFXbtt5LvxVh+jjwpSVaQSwuDQp/f
        HpS1wV94gBRBtxQE15bI0hfm0VwPbi4w/zQqv1dy/6SXAndfEW1IYp2t+dk+a0tN6smr9TzC8xOK1
        N0iIBKlALquOIF7WwXwIqrMPJKJ9vjTtFLDth/faML7rNtYJL3vKYKyfrALY/pVqCxCDpJDuI2ulZ
        SrrBYyu6UVMfaMRJype6T6X0qEIVyxflz9ofIFE8lqa6snTF9aZlJxjZPpHU4Yul+DBIyBDvfE8Sk
        VNWbM6MeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBFj-0004An-FV; Mon, 12 Aug 2019 14:24:51 +0000
Date:   Mon, 12 Aug 2019 07:24:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        linux-spdx@vger.kernel.org
Subject: Re: [PATCH v3 07/20] sg: move header to uapi section
Message-ID: <20190812142451.GG8105@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-8-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-8-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[note: question for the linux-spdx audience below]

> -
>  #ifdef __KERNEL__
>  extern int sg_big_buff; /* for sysctl */
>  #endif

FYI, these __KERNEL__ ifdefs in non-uapi headers should go away.

>  
> +/*
> + * In version 3.9.01 of the sg driver, this file was spilt in two, with the
> + * bulk of the user space interface being placed in the file being included
> + * in the following line.
> + */
> +#include <uapi/scsi/sg.h>

Splitting uapi headers is standard practive, no need for the comment,
especially not with a meaningless driver version number.

> diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
> new file mode 100644
> index 000000000000..072b45bd732f
> --- /dev/null
> +++ b/include/uapi/scsi/sg.h
> @@ -0,0 +1,329 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

This needs the syscall noticed for uapi headers.  FYI, what is our
stance of just adding that notice to headers newly moved to UAPI?
Do we need agreement from everyone who touched the file?  Or just
after we started the split and SPDX annotations, as in this case
this header used to be available to user programs?
