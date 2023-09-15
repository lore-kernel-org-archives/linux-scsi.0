Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07527C46CA1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbjIOVFk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbjIOVFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:05:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B38189
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:04:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 373731FD6E;
        Fri, 15 Sep 2023 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694811895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amrJE9kcPox5q9M++KRiFGaQ/52G5S5ijof+v0B4vso=;
        b=ON1z90HIZKPZPAqsvyx9sAB8RgEqcehr5D1IqZQy6rVSLzVJKoAJaLZ+rOIllDgzEjfRqq
        BTh9I6Nup2aCn11uHr/wRED/P5I1eRa7N2yyRCApvC+0aXUQpk1CWATJcPkE+MYsiQd3bt
        OJKMj8t5w9tsEOXcPS5jKilmEQk1GPo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E506D13251;
        Fri, 15 Sep 2023 21:04:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9ThTNvbGBGVcHwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:04:54 +0000
Message-ID: <f0700eb093274bd677476963d60d4290c29541a6.camel@suse.com>
Subject: Re: [PATCH v11 18/34] scsi: sd: Fix sshdr use in sd_suspend_common
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:04:54 +0200
In-Reply-To: <20230905231547.83945-19-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-19-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so
> we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. sd_sync_cache
> will
> only access the sshdr if it's been setup because it calls
> scsi_status_is_check_condition before accessing it. However, the
> sd_sync_cache caller, sd_suspend_common, does not check.
>=20
> sd_suspend_common is only checking for ILLEGAL_REQUEST which it's
> using
> to determine if the command is supported. If it's not it just ignores
> the error. So to fix its sshdr use this patch just moves that check
> to
> sd_sync_cache where it converts ILLEGAL_REQUEST to success/0.
> sd_suspend_common was ignoring that error and sd_shutdown doesn't
> check
> for errors so there will be no behavior changes.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Martin Wilck <mwilck@suse.com>

