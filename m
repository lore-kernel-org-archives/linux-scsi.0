From: David Caldwell <david@porkrind.org>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA
 passthrough	CDBs
Date: Fri, 23 Dec 2005 11:12:48 -0800
Message-ID: <FEB7BF7CC02839AFCC0CF35D@dev.porkrind.org>
References: <20051221122442.GA16571@porkrind.org>
 <1135353160.3728.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-67-49-70-252.socal.res.rr.com ([67.49.70.252]:45817 "EHLO
	death.porkrind.org") by vger.kernel.org with ESMTP id S1030588AbVLWTM7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 14:12:59 -0500
In-Reply-To: <1135353160.3728.10.camel@mulgrave>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On 12/23/05 09:52:40 -0600 James Bottomley wrote:

> On Wed, 2005-12-21 at 04:24 -0800, David Caldwell wrote:
>> This patch does 2 things. It reimplements the SG_FLAG_LUN_INHIBIT flag
>> in the SG_IO ioctl which stops the scsi subsystem from overwriting the
>> 2nd byte of the CDB with the LUN. It also doesn't guess the CDB length
>> when sending the SG_IO ioctl to the sg device (the main scsi_ioctl
>> already did this).
>
> I think this approach is too invasive to the stack.  When this was
> discussed in november, there wasn't much enthusiasm for resurrecting the
> long dead LUN_INHIBIT flag.  The two suggested mechanisms are

Invasive because of the extra flag in the request structure?

> 2) If 1) doesn't work, then use a blacklist entry which the subsystems
> would also have access to.

I think this might not be optimal. The problem is that it's impossible to 
tell that it's a Cypress part from the USB side of things (or the SCSI side 
for that matter), so there would have to be an entry for each of the 50,000 
vendors of USB bridges.

What about the patch's cdb length additions in sg and scsi_lib.c? It seems 
like half the code guesses CDB length and the other half passes it around. 
Clearly, given devices like this, guessing isn't going to work 100% of the 
time. So either eveyone needs to pass around lengths, or there needs to be 
another flag somewhere. The code should at least be consistent though.

-David
