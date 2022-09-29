Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64738C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 14:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiI2Ogn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbiI2Ogk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 10:36:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6405F1B0529
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 07:36:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 23D1621A58;
        Thu, 29 Sep 2022 14:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664462198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qt2Tk6csTnxObGL6MmmX9A4GT//StP4tZbv0ROrxA0c=;
        b=ACMBu6arFnQmVZWfx6mk9Livt+X8nyMlov+7YmZqqUPmFdXYQ11T91mbvnCQq5KLjsz6JD
        PkagEgkrHJKk1vwWqOtnZculemh8/2fCnnTan8Yj5IKXgbJwuVh6jIozIy7GJqj2pSY2Nh
        QEZ1YauuVgD//jlk7CukcESbyxw3GjM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DBC3B13A71;
        Thu, 29 Sep 2022 14:36:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id n/QFNHWtNWO7RQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 29 Sep 2022 14:36:37 +0000
Message-ID: <5552df1883fb6fcb16c6351b7d25f9448b92e830.camel@suse.com>
Subject: Re: [PATCH v2 00/35] Allow scsi_execute users to control retries
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Thu, 29 Sep 2022 16:36:37 +0200
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-09-28 at 21:53 -0500, Mike Christie wrote:
> The following patches made over a combo of linus's tree and Martin's
> 6.1-queue tree (they are both missing patches so I couldn't build
> against just one) allow scsi_execute* users to control exactly which
> errors are retried, so we can reduce the sense/sshdr handling they
> have=20
> to do.
>=20
> The patches allow scsi_execute* users to pass in an array of failures
> which they want retried and also specify how many times they want
> them
> retried. If we hit an error that the user did not specify then we
> drop
> down to the default behavior. This allows us to remove almost all the
> retry logic from scsi_execute* users.
>=20
> We then only need to drive retries from the caller for:
>=20
> 1. wants to sleep between retries or had strict timings like in
> sd_spinup_disk or ufs.
> 2. needed to set some internal state between retries like in
> scsi_test_unit_ready)
> 3. retried based on the error code and it's internal state like in
> the
> alua rtpg handling.

In theory, 2) and 3) could be handled by callbacks, but that would seem
over-engineered for the few callers that are affected.

>=20
> v2:
> - Rename scsi_prep_sense
> - Change scsi_check_passthrough's loop and added some fixes
> - Modified scsi_execute* so it uses a struct to pass in args
>=20
>=20
>=20

For the series, except 02/35, 21/35, and 23/35:

Reviewed-by: Martin Wilck <mwilck@suse.com>

