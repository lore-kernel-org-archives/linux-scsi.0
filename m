Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE6FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 15:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347858AbiCHPhV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 10:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346911AbiCHPhU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 10:37:20 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8130D38BC5;
        Tue,  8 Mar 2022 07:36:23 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E305C5C018C;
        Tue,  8 Mar 2022 10:36:20 -0500 (EST)
Received: from imap47 ([10.202.2.97])
  by compute3.internal (MEProxy); Tue, 08 Mar 2022 10:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ttwalkertt.com;
         h=cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=pqibhZXEYNtOvRFmApEgPbaPmCxVr+WcKFwgCy
        WJWqE=; b=WOoN+PfKoUTEKZb/FIMCvA94Cb5efx6tfMX4Uap8JmA48ZTEFcZaC4
        B16DwC+X4aM7uSfIfGKMwWWgLLB3AGcGsOymdL5YbhMPO0iDcFiJsgH4HXVSCsEn
        IFKh2s+bZvmUdvrXywXgT4+Dob0W72BSFf1BQbzgrARnvtNNy3UzGxvjbzD0bz5h
        wZ/esmVhyFXbVFFqJCX7Z4du1OaTvxrIncgtLGF+KZLWZ9ZMH6bdoGzyQcizU6qW
        HlYmWkM1mSnXqKRJySGy7URLTWORVngG61RewBOzrtddMDwlUF7Qfj6tpPfASrse
        XN4++Q0eu+66yMviIpBxQdlfolpB5ttg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:date:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pqibhZXEYNtOvRFmA
        pEgPbaPmCxVr+WcKFwgCyWJWqE=; b=HcHo6aC9h/H5SuCHTs82D1UFGNEnWxaJ0
        QJZebfDIWrhZQzDpxrR0iX0lZLVxuKLOM569mHuiEgBQ0fPMBauXceq96S3tvm/J
        VilvdlcMCw1Ti+D19YosVxl5lEZoPTGQCspygjh0tEWiMR1kA43kgu9BpqDjQdYd
        k9waLU5t+p4GG64G/xD5Q4bYXhrhSxF6pBUeWt2b3nAldGYwiEZbn56KYF+qpdMY
        XDprj+GX60LK/4SMA5rqzBNv3JQDVW0LXipq+MSGnOROyfMJSb373S5iie67fgqy
        P4gtbFieqR+Y7N56ZQV2Uwcck17AyWUkmNAgTGP7aLHmhbNAQaJAQ==
X-ME-Sender: <xms:9HcnYlMdvW7C4eMKcUeeguIJaktwYIUkf05ORNTSeujA33vdKk-3rw>
    <xme:9HcnYn8qWFm_eFH3LCTZMFy60Rd3spiQfxJO140ImPPShyWKTILlGgHqf4Nhla8xC
    82bd5PqniJAPcwE9zQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudduiedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenuc
    fjughrpefofgggkfffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdhtihhmucif
    rghlkhgvrhdfuceothhimhesthhtfigrlhhkvghrthhtrdgtohhmqeenucggtffrrghtth
    gvrhhnpeevlefgleegtedvheejheeikedttdduieeivdegheeigfefgeefgfejudeuhfel
    leenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtih
    hmsehtthifrghlkhgvrhhtthdrtghomh
X-ME-Proxy: <xmx:9HcnYkSKLIcgXeVicA9V6MXyG-DpV4vTO3pyAxWQojAu9OzCfJjZpg>
    <xmx:9HcnYhtjw0X_YRJPXF_2hgoPsfpccPbdQTopjvz7XzmmT7Y6rRZwjw>
    <xmx:9HcnYtc4Y0KhlLdEDqG449DbqdmX6RCSZrr0oyjQjKp19EfhLw8Dkg>
    <xmx:9HcnYtkrv3ZhVaPeiWQBmLsdeHMUWWAimHHnnlvaajpYRT9awNsPKg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 6121E2740108; Tue,  8 Mar 2022 10:36:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <cb64d74c-1f19-40d9-880c-dc8ba1bba020@www.fastmail.com>
Date:   Tue, 08 Mar 2022 10:36:00 -0500
From:   "tim walker" <tim@ttwalkertt.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject:  [LSF/MM/BPF TOPIC] NVMe HDD planning and directions
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all-
I'd like to propose we talk about the PCIe-NVMe HDD this year. The=20
topic comes up informally from time to time, but now that we have
products with actual delivery schedules I think it would be valuable
to discuss the impact to our systems.=20

Background:
NVMe specification has hardened over the decade and now NVMe=20
devices are well integrated into our customers=E2=80=99 systems. I think
moving HDDs to the PCIe/NVMe interface is the next logical step.=20
Consolidating on a single API for rotational and static storage=20
technologies. PCIe-NVMe offers SATA-level costs while supporting=20
features and performance suitable for high-cap HDDs, and optimal=20
interoperability for storage automation, tiering, and common=20
management tools.=20
We will share some early integration results, and review the
OCP design guidelines, but really don't want to turn this into
a status report or marketing blitz. HDDs, PCIe, and NVMe are=20
all mature technologies, but the combination is new. We are=20
looking to the experts to help us anticipate the challenges=20
and benefits.

Discussion Proposal:

-What Linux storage stack pitfalls do we need to be aware of as=20
we field these devices with drastically different performance
characteristics than traditional NAND? For example, what=20
schedular or device driver level changes will be needed to=20
integrate NVMe HDDs?

-Are there NVMe feature trade-offs that make sense for HDDs=20
that won=E2=80=99t break the HDD-SSD interoperability goals?

-How would multi-actuator HDDs be presented under NVMe?=20
Namespace-per-actuator?

-NVMe HDD power management proposals. This might=20
turn out to be the hardest part.

-NVMe HDD System architecture (maybe, if there is interest?)

Thanks, and best regards,
Tim Walker
