Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB79C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 09:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243333AbiDFJjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457676AbiDFJe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 05:34:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0B4FE437;
        Tue,  5 Apr 2022 23:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Kh6DytC11gdNi8W6tlBfwxpwxAPXKhPZpYoYh3mWIWo=; b=rRSov9iUqX+soc4Uk47rVun/mb
        1kHfGTdgUwvptEg3vKe3iXKdrPPFWvn6KeXus0ze6+vOm8kx5mnC0UZcXWWE00Hm1lMPwLUgWLeVq
        hKB8eV0YXTs3/JpRIjS5KD33MBVJb6zndYj4uQlgdKaYNlJaRWGwXS+7uW4h4d9seTyTYeROJsTIB
        nO56czjBojnbv2To07xtTwvAgIlEhVVjU6MzrcMbUT3w0u0Km5R4IIjMLJHRvnoUjPKPzdtuLv1Ij
        OoXnzo4ekfrLvXUuPNHJOAeDUFvW6AO/0UpYQkBLSL2fKtqJBlyy/9qEpWMORDLL5v4PAGZ7wQ0Jk
        eAbzc2GQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbz0V-0042HW-3T; Wed, 06 Apr 2022 06:19:07 +0000
Date:   Tue, 5 Apr 2022 23:19:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sym53c500_cs: Stop using struct scsi_pointer
Message-ID: <Yk0w2ywoQzEnl/SV@infradead.org>
References: <4948f86703d23e5048f4e24e649680259b2610f9.1649146056.git.fthain@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4948f86703d23e5048f4e24e649680259b2610f9.1649146056.git.fthain@linux-m68k.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +
> +static struct sym53c500_cmd_priv *SYM53c500_priv(struct scsi_cmnd *cmd)
>  {
>  	return scsi_cmd_priv(cmd);
>  }

I don't even think we need this helper, all callers can just use
scsi_cmd_priv directly.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
