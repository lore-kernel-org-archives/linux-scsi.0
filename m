Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C927CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbjIOVK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238015AbjIOVK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:10:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2558CC1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:10:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C9FB21FD7E;
        Fri, 15 Sep 2023 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694812214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E1U+fXBBNsatyRXG6P10X1iYTLo8ao9/Bh+Nm5YDC5w=;
        b=vRuKGhUM3uD8auD/C95600DR4KnwKA9DpJBiE6s9CxpSuZLNFtcXlD8sY4lAB7XepWer0c
        dxZBXFCCntaVrPJmlCA7q+JmtqkjtYJcckTgerBzx+40+acV8cTyLF+20S6rIsCeiiZDgC
        u8K0yjxpRr5et5URqYnBujA3EekrpO8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8781613251;
        Fri, 15 Sep 2023 21:10:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wvpoHzbIBGUpIQAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:10:14 +0000
Message-ID: <a8f07a810b444269522c05bd79c63080c6a9bd24.camel@suse.com>
Subject: Re: [PATCH v11 19/34] scsi: sd: Have scsi-ml retry sd_sync_cache
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:10:13 +0200
In-Reply-To: <20230905231547.83945-20-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-20-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> This has sd_sync_cache have scsi-ml retry errors instead of driving
> them
> itself.
>=20
> There is one behavior change where we no longer retry when
> scsi_execute_cmd returns < 0, but we should be ok. We don't need to
> retry
> for failures like the queue being removed, and for the case where
> there
> are no tags/reqs the block layer waits/retries for us. For possible
> memory
> allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
> will probably not help.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

