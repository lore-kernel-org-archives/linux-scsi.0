Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B147C433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EC94206DF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="J6u+7i4N";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="zbOV4FNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfHLOce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:32:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36487 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfHLOce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 10:32:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 55B9920260;
        Mon, 12 Aug 2019 10:32:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 12 Aug 2019 10:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=P0wi0PpykWML/yKIJ62vyF1mno1
        HZGC4tJREhnvhDWw=; b=J6u+7i4NUZmNZ58Dcat04bU40x6S3+9uUZdAsPy6yia
        U5cU7JLwYR7O5YdiVx+II4bweu2rjkM78MKN9Lq2k8/VjyRwgxmIEMZ7kDMhPMXB
        OlZbKjDnOZJGZ2Utgrz0g8Ir21gOeFOWXGttMUpArOfJNCo/Ywr0ktth+5Smd/Gf
        vvwaki9IPII4MIVQ2QmiR4DqvUvKFw6+IDW65gtfIoKM0aV/SeJh16GBrvP5bVyC
        SwFqexupwWd1EXOX9FRY5pfnmTcya1uXpyYFt9fsonxcZbMN0BNlJ5mh9fXfWhSp
        scKs2ub6T7caVYoSLSMn5l/tN9nfhKn8M6rhTwMbnbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=P0wi0P
        pykWML/yKIJ62vyF1mno1HZGC4tJREhnvhDWw=; b=zbOV4FNcKfI7TI+M5YrHG4
        W/WBCW9rGuHPwWmMc8wmnP3h4Bww46gOZFBVMVcpbbfJwls8vKE0iDq0diI/jxHy
        qj1NJ70Qaqf/2EaT3Ixr1+WAH6zVDz9CaVvxVAdhicgYlOM8d7GV7ozuVtZ5O33A
        3wKUIjKDXzCi+hrhnLx3ngw7OGne01GuUNDWOPbPq2qLUn34vgm3qAz9LKGitg2M
        HRQUrmYSFtoUtYWFv3l4/JMbji8jjsQ3cOCKJVOHPDM1fkQyidci6Wd1V5I3KyTl
        VsBq/aFhPDqvj2kMLrMy9a2lbAhgwSO9qS4GKmgfqBvZPRbeRdBboPLYz7ykgSzg
        ==
X-ME-Sender: <xms:gHhRXb4PFwbZLS-dTHh6giuDPXRgocAkcMaZL4Xt2PkFt4m5dod84A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvgedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:gHhRXcFbOScBgN6stsDktgk_dWqt-N3seIe488meDzOcb89cV7NnxQ>
    <xmx:gHhRXRnS3UP7SIL5iBPzlJx1gdeXSBYOD-3_D0FjaSEw1dno6dZ1Cw>
    <xmx:gHhRXcao2FrOZTbzIkdraZF6vPY8xDAFnUfC7fqrLVxgG8hHVMRUXw>
    <xmx:gXhRXT7uLVb-pBv7jq2nWXNx9beJk4iKm9MAY71Wroi67ZkE4-Sv9w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 016DF380075;
        Mon, 12 Aug 2019 10:32:31 -0400 (EDT)
Date:   Mon, 12 Aug 2019 16:32:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        linux-spdx@vger.kernel.org
Subject: Re: [PATCH v3 07/20] sg: move header to uapi section
Message-ID: <20190812143230.GB14068@kroah.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-8-dgilbert@interlog.com>
 <20190812142451.GG8105@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812142451.GG8105@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 12, 2019 at 07:24:51AM -0700, Christoph Hellwig wrote:
> > diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
> > new file mode 100644
> > index 000000000000..072b45bd732f
> > --- /dev/null
> > +++ b/include/uapi/scsi/sg.h
> > @@ -0,0 +1,329 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> 
> This needs the syscall noticed for uapi headers.  FYI, what is our
> stance of just adding that notice to headers newly moved to UAPI?

Just add them.

> Do we need agreement from everyone who touched the file?  Or just
> after we started the split and SPDX annotations, as in this case
> this header used to be available to user programs?

The license of the entire kernel source is pretty obvious that anything
UABI related needs the dual license, so adding it is fine.

If not, the scripts will notice and we will just end up generating a
patch to fix it anyway :)

thanks,

greg k-h
