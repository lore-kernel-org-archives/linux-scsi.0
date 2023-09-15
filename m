Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D152CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbjIOVPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbjIOVPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:15:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52611BD3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:14:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 82FDC1FD7E;
        Fri, 15 Sep 2023 21:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694812439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SK6jtvK6zQjyZvFz13qgO4kOR/3pGp1FhwxPV7/a9ZU=;
        b=qwygbDZSPvjt4QfeZ4gEp0FWoI6bqUk/UJ4YkwHMeRM+Cf0A4i0ptYbtV7EH/e/rdWB8KA
        5OqdVBdXqRaN95CrvAcTA3T2iPegWFpH+GXTqbLGxF7qu/dJt0UlmX0zHjdRRec/qdAc2F
        W5H5MF1G3XPQyXc2gGMDGiW2hgHz6GQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38B6C13251;
        Fri, 15 Sep 2023 21:13:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3/4eCxfJBGVWIgAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:13:59 +0000
Message-ID: <c6d4c0bff0c9122f6dbe358865a96a304ba0a7c0.camel@suse.com>
Subject: Re: [PATCH v11 23/34] scsi: sd: Fix scsi_mode_sense caller's sshdr
 use
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:13:58 +0200
In-Reply-To: <20230905231547.83945-24-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-24-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> The sshdr passed into scsi_execute_cmd is only initialized if
> scsi_execute_cmd returns >=3D 0, and scsi_mode_sense will convert all
> non
> good statuses like check conditions to -EIO. This has scsi_mode_sense
> callers that were possibly accessing an uninitialized sshdrs to only
> access it if we got -EIO.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Martin Wilck <mwilck@suse.com>

