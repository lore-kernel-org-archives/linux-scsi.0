From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Problem with mptsas handling of ATA devices in a shared environment
Date: Mon, 14 Jan 2008 18:36:06 -0600
Message-ID: <1200357366.3159.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39203 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbYAOAgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 19:36:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

When the expander can manage it, shared devices are handled with
affiliations.  However, the 1068 firmware doesn't seem to be aware of
this.  It always seems to close connections with CLOSE(NORMAL) instead
of CLOSE(CLEAR AFFILIATION).

The upshot is that once mptsas sees an ATA device in a shared
environment, that device becomes irrevocably (well up until a hard
reset) bound to the mptsas initiator ... even if I shut down and power
off the box with the mptsas initiator, the expander still remembers it,
so no other box can get at the device until they either send a hard
reset or the expander gets powered off ...

Doug's smp_utils with smp_rep_phy_sata confirms the affiliation.

James


