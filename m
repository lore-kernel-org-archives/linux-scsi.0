From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libsas: Check for completed commands before calling
 lldd_abort_task()
Date: Mon, 8 Jan 2018 12:41:44 +0100
Message-ID: <7c62e4c6-6fc3-8571-5f92-d58f14e25f40@suse.de>
References: <1515408716-102111-1-git-send-email-hare@suse.de>
 <20180108112348.GA7106@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756014AbeAHLls (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 06:41:48 -0500
In-Reply-To: <20180108112348.GA7106@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.com>

On 01/08/2018 12:23 PM, Christoph Hellwig wrote:
> On Mon, Jan 08, 2018 at 11:51:56AM +0100, Hannes Reinecke wrote:
>> The abort handler might be racing with command completion, so the
>> task might already be NULL by the time the abort handler is called.
> 
> But without taking dev_done_lock (or using cmpxchg) what prevents
> use from still hitting this, although in a more narrow window?
> 
Good point.
Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
