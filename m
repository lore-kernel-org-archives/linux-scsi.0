From: Brian King <brking@linux.vnet.ibm.com>
Subject: SCSI scanning behavior
Date: Thu, 20 Aug 2015 17:11:14 -0500
Message-ID: <55D65082.6020504@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:42888 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbbHTWLU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 18:11:20 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 20 Aug 2015 18:11:19 -0400
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 2F65538C8039
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 18:11:16 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7KMBFBW65077258
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 22:11:16 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7KMBF44020052
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 18:11:15 -0400
Received: from skaro.rchland.ibm.com (sig-9-48-96-74.ibm.com [9.48.96.74])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id t7KMBEFu019985
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2015 18:11:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

In one of our SAN test labs where there is some storage controller error injection going on,
I'm seeing some interesting behavior. We are getting into a scenario, when the target is coming
back where we are going through SCSI scan for it and the Report LUNs we are issuing to it times
out, so we fall back to a sequential LUN scan. When performing the sequential LUN scan, we 
end up adding a bunch of LUNs than we didn't previously see, 512 in fact. The target is reporting
PQ=1, PDT=0 for every LUN that doesn't exist. When Report LUNs *does work*, it doesn't report
these LUNs. 

In net, we end up with a different result if we do a sequential LUN scan compared to a report LUNs
scan.

Now, one could argue this is a defect in the SCSI target, since SPC says:

The REPORT LUNS parameter data should be returned even though the device server is not ready for other
commands. The report of the logical unit inventory should be available without incurring any media access
delays. If the device server is not ready with the logical unit inventory or if the inventory list is null for the
requesting I_T nexus and the SELECT REPORT field set to 02h, then the device server shall provide a default
logical unit inventory that contains at least LUN 0 or the REPORT LUNS well known logical unit (see 8.2). A
non-empty peripheral device logical unit inventory that does not contain either LUN 0 or the REPORT LUNS
well known logical unit is valid.

However, I'm still left wondering why we are adding PQ=1, PDT=0 devices in the sequential LUN scan at all.
Are there media changer devices out there that we've seen respond like this? Even so, does it make sense
to add PQ=1, PDT=0 LUNs for LUN > 0?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


