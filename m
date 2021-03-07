Return-Path: <SRS0=+FL9=IF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8618EC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Mar 2021 10:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596496516B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Mar 2021 10:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhCGKhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 05:37:15 -0500
Received: from wind.enjellic.com ([76.10.64.91]:43800 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231325AbhCGKg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 Mar 2021 05:36:59 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2021 05:36:59 EST
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 127ASsZJ003728;
        Sun, 7 Mar 2021 04:28:54 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 127ASs7F003727;
        Sun, 7 Mar 2021 04:28:54 -0600
Date:   Sun, 7 Mar 2021 04:28:54 -0600
From:   "Dr. G.W. Wettstein" <greg@wind.enjellic.com>
Message-Id: <202103071028.127ASs7F003727@wind.enjellic.com>
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.6-ESD1.0 03/31/2012)
To:     linux-scsi@vger.kernel.org
Subject: qla2xxx initiator mode fails in EXCLUSIVE mode.
Cc:     bvanassche@acm.org
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 07 Mar 2021 04:28:54 -0600 (CST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, I hope the weekend is going well for everyone.

In an upgrade to the 5.4 kernel for our storage targets and proxies we
noted what appears to be a regression with respect to the behavior of
interfaces that are used in initiator mode when the qlini_ini mode
variable is set to EXCLUSIVE.

The problem also appears to present itself when qlini_mode is set to
DUAL.

When the driver initializes, the interface comes up but appears to be
in a non-functional state.  As a result the enumeration of block
devices does not occur as would be expected.

Instead the driver ends up initiating a target, bus, adapter reset
sequence that ultimately ends up with the interface functioning in
initiator mode, but only after a 3-4 minute delay.

We reproduced this on a 5.11.2 kernel, so the problem still appears to
be there and is probably in current mainline.

We've reproduced the problem on both 16 GIG (2672) and 32 GIG (2742)
cards so it doesn't appear to be card specific.

On the switch side (Cisco) we see the interface initially come up when
the driver initializes the card.  After approximately 60-90 seconds
the switch notes an NOS event (No Operational Sequences received) and
then drops and re-enables the interface.  Approximately one minute
later the interface drops again due to the ADAPTER RESET after which
everything takes off.

I haven't worked through all of the code paths but it 'feels' like a
DPC reset or the equivalent is missing when EXCLUSIVE or DUAL mode is
in effect.

We are in a position to do additional testing if anyone has any
thoughts.

Have a good week.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"We know that communication is a problem, but the company is not going
 to discuss it with the employees."
                                -- Switching supervisor
                                   AT&T Long Lines Division
