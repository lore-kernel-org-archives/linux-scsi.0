Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF5DCD37AC
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbjIOU5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbjIOU46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:56:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4CA3A9E
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:55:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4B26321904;
        Fri, 15 Sep 2023 20:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694811330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=imcfAfVpEHFCZjPRKG1bdGqwe0QLlRnI//iN8h0hF+g=;
        b=krYoyTsEo1h9TtLrdcUUbrkHAB+zuGqUcRof4Ubr4twq/UQW/fBd90UpclbRrzHv3UfZNi
        SJbZmT4ofj4M9YWUiF7sAm5NOAEdGbNjt0E7jHD8Xm4TpgISyt0c49hk4pVRti11GNs7/d
        RG7O+Z0whp6oHNOSHZtoHBRgmLWriNo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7CF7B13251;
        Fri, 15 Sep 2023 20:55:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jOVeG8HEBGUaHAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 20:55:29 +0000
Message-ID: <f614e856aa9aace63978e631faf3dc3ff28aa1d7.camel@suse.com>
Subject: Re: [PATCH v11 14/34] scsi: rdac: Fix sshdr use
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 22:55:28 +0200
In-Reply-To: <20230905231547.83945-15-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-15-michael.christie@oracle.com>
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
> successfully, so there is no need to check the sshdr. This has us
> access
> the sshdr when we get a return value > 0.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Martin Wilck <mwilck@suse.com>

