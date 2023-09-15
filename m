Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C913ECD37AD
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbjIOVSa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbjIOVSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:18:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D9AC7
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:17:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EF1382188F;
        Fri, 15 Sep 2023 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694812676; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0uEvLUdr7KFKTnyJpPslxP1XW9AdtkXeZa1UeEqyq3c=;
        b=Ok3eFqcRnBqwZzbbjmWlCbBSYBYbWWlgX+Y9TupA+Kw/CFklFGykE74tbkNKfvPI6DrrDO
        IAvYr1J5J/4nzQy8tckB5Zoyce98PuzMiJg9BZ3sECWlvKy3iZfJ0INzJm70+rEM4R4YCH
        8g9omUapJEz+Eno3b1jeMEpyXD57OXk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AA06A13251;
        Fri, 15 Sep 2023 21:17:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VfLQJwTKBGWmIwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:17:56 +0000
Message-ID: <9002ed3b03ec2420d41a2018712989489f49a40a.camel@suse.com>
Subject: Re: [PATCH v11 24/34] scsi: Have scsi-ml retry scsi_report_lun_scan
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:17:56 +0200
In-Reply-To: <20230905231547.83945-25-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-25-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> This has scsi_report_lun_scan have scsi-ml retry errors instead of
> driving
> them itself.
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

Another minor behavior change is that we may now get up to 3 retries
for UAs plus up to 3 retries for non-CC errors. Anyway,

>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

