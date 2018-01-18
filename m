From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS
Date: Thu, 18 Jan 2018 11:17:21 +0100
Message-ID: <00bbbaed-215a-4af9-1576-1c25008d0e23@suse.de>
References: <20180115201852.15152-1-mwilck@suse.com>
 <yq1efmpt3hs.fsf@oracle.com> <1516174344.3303.1.camel@suse.com>
 <yq1shb3ring.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755523AbeARKRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jan 2018 05:17:24 -0500
In-Reply-To: <yq1shb3ring.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Martin Wilck <mwilck@suse.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, saito.kazuya@jp.fujitsu.com

On 01/18/2018 03:43 AM, Martin K. Petersen wrote:
> 
> Martin,
> 
>> You'd like to spend a precious BLIST bit for this single device which
>> uses vendor-specific ASC/Q?
> 
> I really don't want string comparisons in the regular code paths. Also
> not a fan of vendor-specific ASCs. But if you must use them, please add
> a flag and trigger on that.
> 
> Since this is a bit of an unusual check condition combo, we could
> entertain whether we should simply always ADD_TO_MLQUEUE on
> 0xb/0xc1/0x1. I wonder what would break?
> 
That's the usual problem I have with vendor-specific sense codes.
In general the risk is quite low of different vendors actually using the
same code; I guess we can get away with just adding a debug message here
and enable it without any vendor check.
Then we can reconsider the whole thing once we notice several vendors
using the same sense codes.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
