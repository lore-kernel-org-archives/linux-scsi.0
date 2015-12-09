From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 0/3] Fix the problem of SATA devices within SAS enclosures
Date: Wed, 09 Dec 2015 11:10:06 -0800
Message-ID: <1449688206.2226.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55072 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346AbbLITKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 14:10:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 42FBE8EE0CC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:10:07 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MrdgTfvO7bOp for <linux-scsi@vger.kernel.org>;
	Wed,  9 Dec 2015 11:10:07 -0800 (PST)
Received: from [153.66.254.242] (unknown [184.11.141.41])
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DB2548EE04D
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:10:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A big use of SAS enclosures is actually to hold SATA devices.  Right at
the moment, the ses enclosure system doesn't recognize SATA devices.
The reason for this is that SAS actually makes up an endpoint address
for a SATA device since SATA doesn't have an addressing scheme.  The
problem this causes is that the made up SAS address doesn't match the
SATA NAA identifier in VPD page 0x83, so the address for the device the
enclosure reports never matches.

We can fix this by using the SAS transport class to give us the actual
end point address instead of using the identity VPD page.  This ensures
SATA devices are always correctly matched at the expense of pulling in
all the SAS transport code.  Instead of making ses depend on the SAS
transport class, I've introduced an is_sas_attached() function that will
allow us to compile out the code if the kernel isn't built with SAS.  If
anyone ever gets around to doing FC enclosures, they should probably be
done in the same way.

James

---

James Bottomley (3):
  scsi_transport_sas: add is_sas_attached() function
  scsi_transport_sas: add function to get SAS endpoint address
  ses: fix discovery of SATA devices in SAS enclosures

 drivers/scsi/scsi_transport_sas.c |   30 ++++++++++++++++++++++++++++++
 drivers/scsi/ses.c                |   22 ++++------------------
 include/scsi/scsi_transport_sas.h |   10 ++++++++++
 3 files changed, 44 insertions(+), 18 deletions(-)


