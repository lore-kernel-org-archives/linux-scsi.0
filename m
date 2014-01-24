From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: Open/INQUIRY fails on RESERVE'd tape device
Date: Fri, 24 Jan 2014 09:36:15 -0600
Message-ID: <52E2886F.3060604@tributary.com>
References: <CAKbOo_KDVtCw1U7wD7L=aE-qug-3UwQQkDjuvyG2_xVEA8tnvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.53]:6119 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaAXPln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 10:41:43 -0500
In-Reply-To: <CAKbOo_KDVtCw1U7wD7L=aE-qug-3UwQQkDjuvyG2_xVEA8tnvg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Eble <psychotrahe@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 1/23/2014 4:02 PM, Matthias Eble wrote:

> So: should open() fail on a reserved tape device?

	Yes, this is expected behavior for tape devices, reserve 6/release is sometimes
used by backup applications in SAN environments as an arbitration mechanism
across multiple machines.

	Its not that the INQUIRY is failing, its that the st open sequence is doing a
reserve/TUR/etc during the open.

	If that fails then you can't open the drives sufficiently to send a inquiry via
pass-through. In some environments you can bypass that processing with
O_NDELAY/O_NONBLOCK. Or you just use the sg device which doesn't perform the
tape open processing that st does.




