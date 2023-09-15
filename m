Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD82CD37AC
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbjIOUJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237239AbjIOUJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:09:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E03C2707
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:08:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CE6E9218EC;
        Fri, 15 Sep 2023 20:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694808518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gP8mhPorR0NK9CYi4tZxZ6w8oTF+er/L9hb38BFvjlE=;
        b=NIAoStA24UQbSSlQydSXsbFgQnZ4xgzOT54W2U0RQe0188b6AKwXonwELfI6GZd0wuUljx
        PyEzRATuX/CHsbfmEhIb4Bj9AUR6FIaNTIfr0eh41eQGpGCXZJhDk9UWGWLrlDVWnBCFiS
        4u/nFvcmNLDxh0pCM94Sie7d0Fjia9g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6845E1358A;
        Fri, 15 Sep 2023 20:08:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WmZEF8a5BGXWCwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 20:08:38 +0000
Message-ID: <33a7c59a12fbbbb1f388835ac74dcee1034284a3.camel@suse.com>
Subject: Re: [PATCH v11 02/34] scsi: Allow passthrough to override what
 errors to retry
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 22:08:37 +0200
In-Reply-To: <20230905231547.83945-3-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-3-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> For passthrough, we don't retry any error we get a check condition
> for.
> This results in a lot of callers driving their own retries for those
> types
> of errors and retrying all errors, and there has been a request to
> retry
> specific host byte errors.
>=20
> This adds the core code to allow passthrough users to specify what
> errors
> they want scsi-ml to retry for them. We can then convert users to
> drop
> their sense parsing and retry handling.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>

