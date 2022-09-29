Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F0BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 10:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiI2Km2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 06:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiI2Km1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 06:42:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E931476A1;
        Thu, 29 Sep 2022 03:42:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 253F121E2E;
        Thu, 29 Sep 2022 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664448145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epSANtpvCZ+CmdDt2oxmNcDoGWZ1PHjpXx0FPIg+Xxw=;
        b=D5r41dtMjPlAnaldYXV87VdSC41hZ8hL9/3lFlQNksz5JsBykNnY7++MyhzOqJm4jY8M4T
        XRT7xYBhogGCXgJ9kBzzJp4IYn+yUTgQ4GqgDMdxiX45neFWhcZokkhSVDoRplqUL59gRg
        VviJupZMIyrAAxz05wLS/y3rcX8johc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D9BE413A71;
        Thu, 29 Sep 2022 10:42:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id J20bM5B2NWNqWQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 29 Sep 2022 10:42:24 +0000
Message-ID: <544cc60fd36647ee5257f2a863dbecb905095c51.camel@suse.com>
Subject: Re: [PATCH] scsi: core: Add BLIST_NO_ASK_VPD_SIZE for some VDASD
From:   Martin Wilck <mwilck@suse.com>
To:     Lee Duncan <leeman.duncan@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>
Date:   Thu, 29 Sep 2022 12:42:24 +0200
In-Reply-To: <20220928181350.9948-1-leeman.duncan@gmail.com>
References: <20220928181350.9948-1-leeman.duncan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-09-28 at 11:13 -0700, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
>=20
> Some storage, such as AIX VDASD (virtual storage) and IBM 2076
> (front end) do not like the recent commit:
>=20
> commit c92a6b5d6335 ("scsi: core: Query VPD size before getting full
> page")
>=20
> That commit changed getting SCSI VPD pages so that we now read
> just enough of the page to get the actual page size, then read
> the whole page in a second read. The problem is that the above
> mentioned hardware returns zero for the page size, because of
> a firmware error. In such cases, until the firmware is fixed,
> this new black flag says to revert to the original method of
> reading the VPD pages, i.e. try to read as a whole buffer's
> worth on the first try.
>=20
> Fixes: c92a6b5d6335 ("scsi: core: Query VPD size before getting full
> page")
> Reported-by: Martin Wilck <mwilck@suse.com>
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Duncan <lduncan@suse.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
