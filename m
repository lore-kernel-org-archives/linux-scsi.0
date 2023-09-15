Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57389CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbjIOU5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237659AbjIOU4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:56:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26DF1BEB
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:54:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 827371FD7E;
        Fri, 15 Sep 2023 20:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694811272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JBD5ccumwPAMUbxXP928CeOoNML1wRHhjpd1tWUgVSg=;
        b=lM0cLRKEZqoAnsd9wKWXFVeQYo7OVUfZgwVl/RUgTl775HW41gyGpOSPx99kFspSiW/lg6
        W8XFt+WA+vAHV2Gz3V5YU85+G9JodCu+OUR1GLr+hHgQky2nf3IVicEoMentK5DSydA5l0
        idFPLGBpzj20RgESPp2gajxWreUFSIM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2EA2D13251;
        Fri, 15 Sep 2023 20:54:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yLdPCYjEBGXMGwAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 20:54:32 +0000
Message-ID: <f76db8d29cbc048471b1431020549e85d8a928b8.camel@suse.com>
Subject: Re: [PATCH v11 13/34] scsi: rdac: Fix send_mode_select retry
 handling
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 22:54:31 +0200
In-Reply-To: <20230905231547.83945-14-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-14-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> If send_mode_select retries scsi_execute_cmd it will leave err set to
> SCSI_DH_RETRY/SCSI_DH_IMM_RETRY. If on the retry, the command is
> successful, then SCSI_DH_RETRY/SCSI_DH_IMM_RETRY will be returned to
> the scsi_dh activation caller. On the retry, we will then detect the
> previous MODE SELECT had worked, and so we will return success.
>=20
> This patch has us return the correct return value, so we can avoid
> the
> extra scsi_dh activation call and to avoid failures if the caller had
> hit its activation retry limit and does not end up retrying.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

