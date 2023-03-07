Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1888C678D4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 15:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCGPLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 10:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjCGPKk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 10:10:40 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F1D87362
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 07:04:54 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C401C1FD75;
        Tue,  7 Mar 2023 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678201460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zZd+0fZmtY/0IVP3m7HVKUpSYAIzofHoxsni843yHMU=;
        b=IE7VzNEwWn5uGnnx5xLGOch/EXHH3bnpHILFloN6cNOuPDkEYYeExfbel63qGXjI1SwTH1
        NPs4v5SDFMoBhnYxJ4WS3DYFUaZWz051VnYcbKDeIlKtbYsXpztoVRyqyMZ6Apsc/aPs3f
        5LeL7G8IwBd+43kVVgLwq1k4/4pVm/k=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 735501341F;
        Tue,  7 Mar 2023 15:04:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GiZPGnRSB2TDFAAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 07 Mar 2023 15:04:20 +0000
Message-ID: <db12cf6e72c82441370efdf38a9133aab5be602c.camel@suse.com>
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
From:   Martin Wilck <mwilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org, regressions@lists.linux.dev
Date:   Tue, 07 Mar 2023 16:04:19 +0100
In-Reply-To: <yq1sfehmjnb.fsf@ca-mkp.ca.oracle.com>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
         <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
         <Y15lk+CPsjJ801iY@infradead.org>
         <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
         <yq1tu192iur.fsf@ca-mkp.ca.oracle.com> <Y8+m0w4Og2CLFImY@lorien.valinor.li>
         <Y/ZGe8c1XyqSuCSk@eldamar.lan>
         <9aa5e89f-6579-15e5-cc51-d226b5d4bea3@leemhuis.info>
         <yq1sfehmjnb.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-03-06 at 20:39 -0500, Martin K. Petersen wrote:
>=20
> There are three recent commit in this area. e0e0747de0ea was
> accidentally reverted by Linus during a merge and reinstated as
> 1a2dcbdde82e. So unless I'm missing something, the appropriate thing
> would be to backport these three commits:
>=20
> 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while
> reallocating pools")
> 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask fix")
> 06e472acf964 ("scsi: mpt3sas: Remove usage of dma_get_required_mask()
> API")
>=20

I used the same sequence of backports for the SUSE kernel.

Regards
Martin

