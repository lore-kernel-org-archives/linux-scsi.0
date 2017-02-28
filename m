From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_error: count medium access timeout only once per EH run
Date: Mon, 27 Feb 2017 22:04:53 -0500
Message-ID: <yq1a897xbfu.fsf@oracle.com>
References: <1487845639-73322-1-git-send-email-hare@suse.de>
        <1488223993.10197.146.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:18976 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdB1DHa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 22:07:30 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1S37CjZ024619
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 03:07:13 GMT
In-Reply-To: <1488223993.10197.146.camel@localhost.localdomain> (Ewan
        D. Milne's message of "Mon, 27 Feb 2017 14:33:13 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Lawrence Oberman <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@de.ibm.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan,

Ewan> So, this is good, the current implementation has a flaw in that
Ewan> under certain conditions, a device will get offlined immediately,
Ewan> (i.e. if there are a few medium access commands pending, and they
Ewan> all timeout), which isn't what was intended.

Yeah. That was OK for my use case. I was trying to prevent the server
from going into a tail spin. There was no chance of recovering the disk.

But ideally we'd be offlining based on how many times we retry the same
medium access command.

Ewan> as separate medium access timeouts, but I think the original
Ewan> intent of Martin's change wasn't to operate on such a short
Ewan> time-scale, am I right, Martin?

On the device that begat my original patch, SPC command responses were
handled by the SAS controller firmware on behalf of all discovered
devices. Regardless of whether said drives were still alive or not.

Medium Access commands, however, would always get passed on to the
physical drive for processing. So when a drive went pining for the
fjords, TUR would always succeed whereas reads and writes would time
out.

-- 
Martin K. Petersen	Oracle Linux Engineering
