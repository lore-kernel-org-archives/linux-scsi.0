Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B72FCD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbjIOVXv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbjIOVXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:23:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D17E6
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:23:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1DFE11FD7E;
        Fri, 15 Sep 2023 21:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694813019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPzrLcvqZsbzy8XmW+VHSYFKhT98fUGf8QOqdAfpjoQ=;
        b=h1ed3WJJgOG01YLzcyG9C3tySKE7F9xadSHXBpEed3k0CYVIj+C5u1z68nspS4F8X5iMRW
        W654iAJp4THjnvkrLsQur0AA8eaCuHiFOSQpet0YUul/DDhOdp+DU+os1RHN/jZYAq8eFx
        u9iFK7P8D5dyyYPaarQ1YxWWloL+cvc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CD69D13251;
        Fri, 15 Sep 2023 21:23:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RteIMFrLBGWKJQAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:23:38 +0000
Message-ID: <f63235559a72a33a6b97b594d8578404e324737b.camel@suse.com>
Subject: Re: [PATCH v11 10/34] scsi: Have scsi-ml retry sd_spinup_disk errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:23:38 +0200
In-Reply-To: <8c979a19-7005-421a-a321-4a6014a6f342@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-11-michael.christie@oracle.com>
         <c83a61021ecc165d20bfd0fee47ca83233e3078f.camel@suse.com>
         <8c979a19-7005-421a-a321-4a6014a6f342@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2023-09-15 at 15:58 -0500, Mike Christie wrote:
> On 9/15/23 3:46 PM, Martin Wilck wrote:
> > > =A0sd_spinup_disk(struct scsi_disk *sdkp)
> > > =A0{
> > > -=A0=A0=A0=A0=A0=A0=A0unsigned char cmd[10];
> > > +=A0=A0=A0=A0=A0=A0=A0static const u8 cmd[10] =3D { TEST_UNIT_READY }=
;
> > > =A0=A0=A0=A0=A0=A0=A0=A0unsigned long spintime_expire =3D 0;
> > > -=A0=A0=A0=A0=A0=A0=A0int retries, spintime;
> > > +=A0=A0=A0=A0=A0=A0=A0int spintime, sense_valid =3D 0;
> > > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int the_result;
> > > =A0=A0=A0=A0=A0=A0=A0=A0struct scsi_sense_hdr sshdr;
> > > +=A0=A0=A0=A0=A0=A0=A0struct scsi_failure failures[] =3D {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Fail immediately for=
 Medium Not Present */
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0{
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0.sense =3D UNIT_ATTENTION,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0.asc =3D 0x3A,
> > Shouldn't you set .ascq =3D SCMD_FAILURE_ASCQ_ANY here, and below as
> > well?
>=20
> You're right. Will fix all those cases.

I also noted that you don't treat .ascq =3D 0 consistently, e.g. in
07/34, where you set it for the NOT_READY case but not for others. It's
not wrong to omit it, but for code clarity it might be good to set it
explicitly.

Thanks,
Martin

