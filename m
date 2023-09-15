Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58101CD37AD
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjIOVZ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbjIOVZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:25:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F30E101
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:25:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 05CB82196E;
        Fri, 15 Sep 2023 21:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694813143; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zvPGHj8ylyncrvxNTAUC7sTwLdSrVObzH5FEKs6Qpwg=;
        b=CadtV/qhQxz+6eBU5vSFbGrbjqAtkyIAo00NfDi/OH8JkbnPUhHmEutAtR9Gxg4S74eS8g
        pUUxal4nu7fzfjiNdz+CrLXGwAWm1LGDAIPjKO5uv/k58k1b5Sf64dwUqFmVvRx6rVcTZM
        n5wRNaYf+EYg+EUhZS2ANzdnml3nRXE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B91FB13251;
        Fri, 15 Sep 2023 21:25:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NduYK9bLBGUkJgAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:25:42 +0000
Message-ID: <0c5b5fe6d9f8201088d82c58a4ad56161b652001.camel@suse.com>
Subject: Re: [PATCH v11 26/34] scsi: sd: Have scsi-ml retry read_capacity_10
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:25:42 +0200
In-Reply-To: <20230905231547.83945-27-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-27-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> This has read_capacity_10 have scsi-ml retry errors instead of
> driving
> them itself.
>=20
> There are two behavior changes:
> 1. We no longer retry when scsi_execute_cmd returns < 0, but we
> should be
> ok. We don't need to retry for failures like the queue being removed,
> and
> for the case where there are no tags/reqs the block layer
> waits/retries
> for us. For possible memory allocation failures from blk_rq_map_kern
> we
> use GFP_NOIO, so retrying will probably not help.
> 2. For device reset UAs, we would retry
> READ_CAPACITY_RETRIES_ON_RESET
> times, then once those are used up we would hit the main do loops
> retry
> counter and get 3 more retries. We now only get
> READ_CAPACITY_RETRIES_ON_RESET retries.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Martin Wilck <mwilck@suse.com>


