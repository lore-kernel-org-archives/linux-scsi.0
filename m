From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Clarification for Persistent Reservation + All Registrants
Date: Fri, 12 Dec 2014 14:59:23 -0800
Message-ID: <1418425163.10743.61.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39398 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaLLW7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2014 17:59:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "t10@t10.org" <t10@t10.org>
Cc: target-devel <target-devel@vger.kernel.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello T10/SCSI folks,

A question came up on the LIO target-devel mailing list recently wrt the
proper handling of Persistent Reservations + All Registrants logic in a
couple of different scenarios.

The crux of the confusion stems from how registrations are treated
before an explicit PR-OUT RESERVE service action with All Registrants
type occurs, and after that explicit PR-OUT RESERVE of All Registrants
type has been released.

My original interpretation was that an explicit PR-OUT RESERVE with All
Registrants type had to first occur before other non reservation holding
registrations (existing or not) would gain the implicit reservation.

This was primarily because the reservation type was not known until the
explicit PR-OUT RESERVE occurred, and AFAICT at the time there where no
host implementations that actually specified the reservation type at
registration time.

So Is it correct to assume that one explicit PR-OUT RESERVE with All
Registrants type needs to occur before other non reservation holding
registrations gain an implicit reservation..?

How about when the explicit reservation is removed..?  Do the implicit
reservations need to remain in effect for the existing registrations,
even though the explicit reservation of All Registrants type no longer
exists..?

The second point that Ilias raised is what should be the correct
R_HOLDER bit status for PRIN READ_FULL_STATUS descriptors when All
Registrants type is specified.  My original interpretation was that
R_HOLDER was to signal the explicit reservation holder obtained with
PR-OUT RESERVE, and not for the implicit reservations from the other
registrations.  Is this the correct approach..?

Also, does anyone have any experience with a host side implementation of
All Registrants to use as a reference for what's already out in the
wild..?

Thank you,

--nab

FYI, the pointer to Ilias's original question and my response with
additional background is available here:

http://comments.gmane.org/gmane.linux.scsi.target.devel/7632

