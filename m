Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E6AC3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 21:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A2172087E
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 21:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfICVEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 17:04:10 -0400
Received: from wind.enjellic.com ([76.10.64.91]:41810 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfICVEK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 17:04:10 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2019 17:04:10 EDT
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x83Kcqax027110;
        Tue, 3 Sep 2019 15:38:52 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x83Kcpiu027109;
        Tue, 3 Sep 2019 15:38:51 -0500
Date:   Tue, 3 Sep 2019 15:38:51 -0500
From:   "Dr. G.W. Wettstein" <greg@wind.enjellic.com>
Message-Id: <201909032038.x83Kcpiu027109@wind.enjellic.com>
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.6-ESD1.0 03/31/2012)
To:     hmadhani@marvell.com, qtran@marvell.com,
        qla2xxx-upstream@qlogic.com
Subject: SRR response handling.
Cc:     linux-scsi@vger.kernel.org
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 03 Sep 2019 15:38:52 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Good afternoon, I hope the week is going well for everyone.

Himanshu/Quinn, it has been a while since we spoke but I think I have
the right group targeted for this.  I see that you have evolved from
Qlogic to Cavium to Marvell e-mail addresses, which must indicate the
transition of who is making the hardware... :-)

I've been away focused on other issues but I noted with interest that
you are now distributing the Qlogic-Target/SCST interface driver that
we developed with your 32GBPS hardware capable driver.  I'm pleased to
see that it must have utility with respect to providing support for
SCST on mainstream Linux.

I wanted to bounce an issue off your collective judgement since you
may be the only people that know the answer to this and we may be the
only ones that can demonstrate and/or test the issue.

In the following commit:

commit 2c39b5c ("qla2xxx: Remove SRR code")

Himanshu had pulled the SRR code handling out of the target driver.
The changelog indicates that the code was removed since no one
appeared to be using it but it could be re-added if there was a need
for it.

While SRR is ostensibly in support of tape, a block target initiator
on an FCOE fabric will issue SRR's in response to frame drops on the
underlying ethernet fabric.  In the following commit:

commit 6f58c78 ("qla2xxx: Fix kernel panic on selective retransmission request")

We fixed a bug that caused the Qlogic target driver to immediately
panic the kernel if an SRR was received and debugging was enabled.  We
found this bug secondary to debugging an issue with the fact that the
Clipper ASIC's on Cisco Nexus 7K switches are not configured by
default to support lossless fibre-channel frame transport.

We have been using a version of the target driver from before when the
SRR code was removed that has been performing flawlessly which is why
we haven't spent time monkeying with upgrades.

Secondary to a recent firmware upgrade on the Nexus switches that we
conducted, we ended up in a situation where one of the ethernet
interfaces in a port-channel began dropping frames at high rates.
This caused one of our target servers, running a 4GBPS 2462 HBA in
target mode, to immediately panic on what appears to be the BUG_ON
assertion at the start of the scst_tgt_cmd_done() function.

We were going to run this down when we noticed that you had officially
married the Qlogic target driver with the SCST interface driver.  So
we rolled a 4.9.190 kernel with the driver out of the SCST trunk to
see how it handled all of this since we would prefer to be on
something that you guys are directly and actively maintaining.

We tested the resultant kernel and target driver and it appears to be
functioning fine.  After thinking about things for a bit we elected to
not expose the target server to the initiators on the other side of
the port-channel which has the interface with the high frame discard
rate.  The rationale for this is that we are unsure of what the
behavior is going to be when a block initiator issues an SRR against a
target server that has had the SRR handling code removed.

We currently have three target servers that are handling thousands of
SRR's from these initiators on a day in and day out basis with no ill
effects, with the old driver that has SRR handling support.  One of
the local patches we carry has debug code that prints out which
initiator has issued an SRR.  So we know that the SRR handling code is
being invoked and appears to be coping with the situation just fine,
which is what is giving us pause with respect to exposing the new
target server to those initiators.

If the initiators throw an error that is well and good but we are
obviously concerned about possible silent failures and/or corruption.

Since all of this is so esoteric and uncommon we wanted to bounce this
off the experts to get your sense on what we are dealing with.
Obviously if we can help debug and/or improve the driver or provide a
rationale for folding the SRR code back into the driver we would be
more then happy to contribute and test.

Let me know your thoughts and we will go from there.

Have a good day.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you plugged up your nose and mouth right before you sneezed, would
 the sneeze go out your ears or would your head explode?  Either way I'm
 afraid to try."
                                -- Nick Kean

-- 
