Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF2BCD37A9
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjIOUNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbjIOUMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:12:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98757271C
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:12:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5343B219AC;
        Fri, 15 Sep 2023 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694808719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ul01/aIBIaND3SywiB0CJJoDTKHp0Kjf5ynqxJEhmkg=;
        b=HmBWkXbyLnwOuAqyupItMo6VVLPfAt4gSQBfSrVKjuyq+wq4mwj3ye6mcmbyfkifEHtRHt
        axcIaFPLobd407Rb/UTxXjU+Tr24SX5o6W0EdOpj6gJG3b5DbVA0hK+NaLbiZSmo6OJMjq
        +TPXhsvIBFy8kE3TGG9s2zbI57e65II=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B49BF1358A;
        Fri, 15 Sep 2023 20:11:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lNxaKI66BGUhDQAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 20:11:58 +0000
Message-ID: <94bf3a59f77268c57fd5bbe174dcf4ae04fe160e.camel@suse.com>
Subject: Re: [PATCH v11 05/34] scsi: retry INQUIRY after timeout
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 22:11:57 +0200
In-Reply-To: <20230905231547.83945-6-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-6-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> Description from: Martin Wilck <mwilck@suse.com>:
>=20
> The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
> scsi_noretry_cmd()). Packet loss in the fabric can cause spurious
> timeouts
> during SCSI device probing, causing device probing to fail. This has
> been
> observed in FCoE uplink failover tests, for example.
>=20
> This patch fixes the issue by retrying the INQUIRY.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Martin Wilck <mwilck@suse.com>

