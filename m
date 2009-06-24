From: Joe Eykholt <jeykholt@cisco.com>
Subject: how to do fc_remote_port_delete correctly
Date: Tue, 23 Jun 2009 17:27:38 -0700
Message-ID: <4A4172FA.70008@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21717 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZFXA1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2009 20:27:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "devel@open-fcoe.org" <devel@open-fcoe.org>, linux-scsi@vger.kernel.org

This seems pretty basic, but I'm having trouble with it.

The current libfc code has a private structure called fc_rport_libfc_priv
that gets allocated along with the fc_rport structure.

I'm working on patches that restructure this to be separately allocated,
since we need a the private structure to be around before we can do
fc_remote_port_add().  It's a long story, but my question applies to
any FC driver that wants to allocate its rport private data separately.

How should rport->dd_data be set to NULL before/after calling
fc_rport_delete().

I used to set it to NULL before, but figure it's safer to clear it after
terminate_io has been called.  I did a get_device(&rport->dev) first
to be sure the rport doesn't get freed in the meantime.

However, other threads may be in queuecommand already and already
beyond their call to fc_remote_port_chkready() and will reference dd_data.
Maybe they just aren't allowed do that?

Or maybe dd_data isn't allowed to go NULL until the rport times
out and is getting deleted?

Maybe we need a small private rport data with just enough info for the I/O
that's already in progress, or I can recode the I/O path to not use
dd_data (it's mostly stuff that can be gotten through scsi_host instead).

Or maybe we need to do more in our fc_rport_terminate_io callback
from fc_remote_port_delete() to be sure that all I/O really ceases.
We currently do an exch_mgr_reset(), but perhaps some I/O thread hasn't
allocated an exchange yet.

Ideas?

	Thanks,
	Joe



