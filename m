From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: SHOST_RECOVERY hang with host_busy < host_failed
Date: Mon, 16 May 2016 15:37:46 -0700
Message-ID: <573A4BBA.9010608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:54374 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbcEPWhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2016 18:37:52 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Mon, 16 May 2016 16:37:51 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0689419D803F
	for <linux-scsi@vger.kernel.org>; Mon, 16 May 2016 16:37:30 -0600 (MDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Brian King <brking@linux.vnet.ibm.com>

I'm seeing a non-deterministic I/O hang with the ibmvfc driver when we
migrate a guest/partition to a different machine. So, on the occasions
when this hits the systems becomes unresponsive blocked on I/O. I
started by inspecting Scsi_Host of the driver which shows shost->state =
SHOST_RECOVERY explaining the blocked I/O. What I found a little weird
however was shost->host_failed > shost->host_busy.

>From the EH documentation SHOST_RECOVERY is set by scsi_eh_scmd_add thus
blocking any new scmd's from the block queue to the host. So, every
scmnd in flight either completes or fails with failed commands being
inclusive of busy commands count, and the EH thread started once all
busy commands are failed commands (ie. host_busy == host_failed). So,
this should mean host_failed should never by greater than host_busy,
correct?

-Tyrel

