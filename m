From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] ses: skip error messages for invalid LUNs
Date: Sat, 23 Dec 2017 15:37:23 +0100
Message-ID: <50d1463b-efaf-f95f-1681-7c482c73fc11@suse.de>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
 <1513855354-86603-3-git-send-email-hare@suse.de>
 <1513964351.3163.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42231 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752334AbdLWOh0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Dec 2017 09:37:26 -0500
In-Reply-To: <1513964351.3163.14.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 12/22/2017 06:39 PM, James Bottomley wrote:
> On Thu, 2017-12-21 at 12:22 +0100, Hannes Reinecke wrote:
>> Some storage array set the 'Embedded enclosure' bit even though
>> no LUN is present, causing the first RECEIVE DIAGNOSTIC call to
>> be returned with sense code 'LOGICAL UNIT NOT SUPPORTED'.
>> This patch skips the annoying 'Failed to get diagnostic page 0x1'
>> messages for those cases.
> 
> What disagnostic pages does this thing support?  Can you do a receive
> diagnostic on page 0 to find out?  I suspect a lot of embedded
> enclosure services are simple and support page 7 only.  If it really
> refuses all diagnostic page requests (which would be a gross standards
> violation), then it should probably be blacklisted by inquiry string as
> unusable.
> 
If a LUN is connected it'll respond to the usual set (0, 1, 2, und 6).
Sending a RECEIVE DIAGNOSTIC to page 0 will probably yield the same
result (ie being returned with that sense code), but at least we won't
try to access the other pages.
But anyway, yes, the implementation is dodgy.
I'm in contact with the vendor and try to straighten things out.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
