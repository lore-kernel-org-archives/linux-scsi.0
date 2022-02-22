Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C1BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 08:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiBVICB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 03:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiBVICA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 03:02:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057AEDF74;
        Tue, 22 Feb 2022 00:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ORBF63952JWIlwFqVnXGFT6YnhmkLo2k4Gn5pDTRsuY=; b=JvdEnk6EijkAJ3snIkHL5LIdDJ
        nlEQqwCfKiy0UBENlPkKFdv5Fi8INhe5JE6i/OXSmIE+f+nTRxkPmjoP3TIgaqI4k5gBCfUqGEpKw
        qU53z0ZATsVSoxaVFl9khH8A52AcTLXdSL5G9VII1fW58mWKCd89ETkVypF0buokG2PFMXmrD9A66
        CyMBtp4eVlvLsUNYntYAOoyrPABWsiDvAcwYBD4Sn+dkSIgw8xoCarGpQIIt5V48Es+KcKcLZWk15
        x98HaTkv5gf1yFOxK79RRJC7DJZwAuvlguiHpgM3ngM3LMvfUGt0ywGo2sMs/uVBkqLohCXeYDHvt
        6J7ISLAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMQ6z-008R1k-I5; Tue, 22 Feb 2022 08:01:29 +0000
Date:   Tue, 22 Feb 2022 00:01:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mesh: Stop using struct scsi_pointer
Message-ID: <YhSYWUeOZ20s2qZI@infradead.org>
References: <fbf930e64af5b15ca028dfe25b00fe933951f19b.1645484982.git.fthain@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbf930e64af5b15ca028dfe25b00fe933951f19b.1645484982.git.fthain@linux-m68k.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2022 at 10:09:42AM +1100, Finn Thain wrote:
> This driver doesn't use SCp.ptr to save a SCSI command data pointer
> which means "scsi pointer" is a complete misnomer here. Only a few
> members of struct scsi_pointer are used and the rest waste memory.
> Avoid the "struct foo { struct bar; };" silliness.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
