Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CA8C25B50
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbjAXTtE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjAXTsq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:48:46 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2211ABE2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 11:48:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A13591FDBF;
        Tue, 24 Jan 2023 19:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674589720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WgWSWk/3xVHSidch44G9lPs53oWn+k3VpLJaSg+aDVw=;
        b=PQsJ4NXd1GMniRS8m8R6XNNjPBnHzLCGyQzOB1QA3x+DNO28cCS6VvxjG65KtLX6GcelR8
        u3IY4avpQ6RWGaknTtrgeuyZunFDKnlsST1Bo/jeJAJ43tb9N4xKR+v5cAz7SZLVyDQtq5
        nx83Cgdp9JHvMj6kc2VTPrJUiLRv4vY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B34C13487;
        Tue, 24 Jan 2023 19:48:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id brVuOhc20GOtLgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 24 Jan 2023 19:48:39 +0000
Message-ID: <c50ccfdc6fc8cb61f44713fd64697b20383a71fc.camel@suse.com>
Subject: Re: [PATCH v3] scsi: add non-sleeping variant of scsi_device_put()
 and use it in alua
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 24 Jan 2023 20:48:39 +0100
In-Reply-To: <aa6759a1-44db-cb2d-8f12-1ef44dd03791@acm.org>
References: <20230124154953.17807-1-mwilck@suse.com>
         <aa6759a1-44db-cb2d-8f12-1ef44dd03791@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-24 at 10:01 -0800, Bart Van Assche wrote:
> On 1/24/23 07:49, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Since the might_sleep() annotation was added in scsi_device_put()
> > and
> > alua_rtpg_queue(), we have seen repeated reports of "BUG: sleeping
> > function
> > called from invalid context" [1], [2]. alua_rtpg_queue() is always
> > called
> > from contexts where the caller must hold at least one reference to
> > the scsi
> > device in question. This means that the reference taken by
> > alua_rtpg_queue() itself can't be the last one, and thus can be
> > dropped
> > without entering the code path in which scsi_device_put() might
> > actually
> > sleep.
> >=20
> > Add a new helper function, scsi_device_put_nosleep() for cases like
> > this,
> > where a device reference is put from atomic context, and at the
> > same time
> > it is certain that this reference is not the last one, and use it
> > from
> > alua_rtpg_queue().
>=20
> Something I should have asked earlier, has this alternative been=20
> considered? This alternative has the advantage that no new functions
> are=20
> introduced.

Looks good to me, too. No, I didn't have this idea before.

Martin

>=20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1426b9b03612..9feb0323bc44 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -588,8 +588,6 @@ void scsi_device_put(struct scsi_device *sdev)
> =A0 {
> =A0=A0=A0=A0=A0=A0=A0=A0struct module *mod =3D sdev->host->hostt->module;
>=20
> -=A0=A0=A0=A0=A0=A0=A0might_sleep();
> -
> =A0=A0=A0=A0=A0=A0=A0=A0put_device(&sdev->sdev_gendev);
> =A0=A0=A0=A0=A0=A0=A0=A0module_put(mod);
> =A0 }
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 981d1bab2120..8ef9a5494340 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -452,5 +451,7 @@ static void scsi_device_dev_release(struct device
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned long flags;
>=20
> +=A0=A0=A0=A0=A0=A0=A0might_sleep();
> +
> =A0=A0=A0=A0=A0=A0=A0=A0scsi_dh_release_device(sdev);
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0parent =3D sdev->sdev_gendev.parent;
>=20
> Thanks,
>=20
> Bart.

