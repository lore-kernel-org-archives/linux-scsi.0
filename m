Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9548EC64EC4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 23:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjCFXby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 18:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCFXbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 18:31:52 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFDB3CE2D
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 15:31:51 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B63F95C012E;
        Mon,  6 Mar 2023 18:31:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 06 Mar 2023 18:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678145508; x=1678231908; bh=BzPnuklHHpQ5b
        rtNuQArtjOZ6AxCwq1ZupwFUwKxREI=; b=UCpCiV8rS/2wLRWdVJouk5oKIJRIv
        A5cez51H29UY3ZZWJMZKHJxIGsM88+IDT6185pzb1WZ/9HSoUyO6dju44x1MF+Ai
        M6zyNTb9Lq/58t4jthdB09rIvRU9qDdna66gTZB7qQ0p553Ckgf+l9nSPBUC4tzZ
        DRUgwzw1ZuTDatbZm2KdemzS/uOqqmSjgYR2BuXAWKxnD307ruxXPdx2EzOIw+Bz
        qLbXu3JEujuO2Mxqy2Bes+UbF+pbLsJvncuV8NVYd2Aj6k97EBn3unt47m+SR9cn
        lP4dvPDtsOzyWHjf+0TRaIU23k0plWYUYmylzTW+GeDtcMNwFawBMKZog==
X-ME-Sender: <xms:5HcGZC3WLIo7_AcTSoYAiBoK-pCIgs-X0bLq6AtCQROxRIm_jE9GWw>
    <xme:5HcGZFG79dyzVNZjbgkYG72w7ywjFuPQ1KaV9NwT0r9rD4ewqh_jIG2CKVhhCwkr-
    OM0mwSqdxyKFmU190E>
X-ME-Received: <xmr:5HcGZK7f977g9j5IrPFqYr-KTwO8ddrH6rGPjpLZMEv8Gj57MXYFZequeupSUrbvYSfQi7mfF7oTK1fYqAdBF_JlotpD07OKm-4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddtledgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehmtderredttdejnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelfeeklefggfetkedukeevfffgvdeuheetffekledtfeejteelieejteeh
    geelieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:5HcGZD39y19WEulwuoC_R1kxD-CND2CmVr5lpmS4IvPXIcJKPBMFog>
    <xmx:5HcGZFFl36UaxnFR8P-xfGDUH5bOomBrsGoC9lMYqTaGLBbfw1ElgA>
    <xmx:5HcGZM-Ft3olr6PLOkQsCDfDhXAAM6KYJH-sFfjqOV6nSP4XwSUtJQ>
    <xmx:5HcGZK4g4AZpR-B2stfsNmhAjlFMCWMRdbEIWCqKEV6HAiOfdLTSXQ>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Mar 2023 18:31:45 -0500 (EST)
Date:   Tue, 7 Mar 2023 10:34:17 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 02/81] scsi: core: Declare most SCSI host template pointers
 const
In-Reply-To: <d438393a-4047-40e7-c6fc-15ba6631973c@acm.org>
Message-ID: <0b74e472-f743-bcc2-48ed-3e564a6c0714@linux-m68k.org>
References: <20230304003103.2572793-1-bvanassche@acm.org> <20230304003103.2572793-3-bvanassche@acm.org> <495d7eeb-bf5c-8333-1945-2ab1614f011f@oracle.com> <d8503629-3151-b408-a298-9583ec71a099@acm.org> <59da25c2-a903-d004-ba23-712df9259f5e@oracle.com>
 <d438393a-4047-40e7-c6fc-15ba6631973c@acm.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811774-190670109-1678145657=:14301"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811774-190670109-1678145657=:14301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 6 Mar 2023, Bart Van Assche wrote:

> On 3/6/23 10:55, John Garry wrote:
> > On 06/03/2023 16:07, Bart Van Assche wrote:
> >> Another example from drivers/scsi/bnx2fc/bnx2fc_fcoe.c:
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bnx2fc_shost_template.can_queue =3D hba-=
>max_outstanding_cmds;
> >=20
> > BTW, surely we should be setting shost->can_queue =3D
> > hba->max_outstanding_cmds after scsi_host_alloc() and not modifying
> > bnx2fc_shost_template, right? The series is already huge, so this stuff
> > would be done separately, I suppose.
>=20
> Hi John,
>=20
> If anyone else wants to work on this that's fine with me. My view is=20
> that the SCSI core should support declaring host templates const but I'm=
=20
> not sure it's worth it to make changes in old drivers such that their=20
> SCSI host template can be declared const.

Would it alter the driver .o files? If not, the changes won't require=20
actual testing.

> One class of SCSI LLDs that does not have a const SCSI host template are=
=20
> the NCR drivers. The NCR SCSI host controller was popular 40 years ago.=
=20
> There are probably not many working SCSI devices left that are based on=
=20
> this SCSI controller.
>=20

True, the NCR 5380 controller was popular 40 years ago among early=20
adopters like Sun and Apple. Is this relevant?
---1463811774-190670109-1678145657=:14301--
