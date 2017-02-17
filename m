From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Fri, 17 Feb 2017 09:06:14 +0100
Message-ID: <c889eed7-6262-2e54-0b1e-1d833c033324@suse.de>
References: <1487257943-72264-1-git-send-email-hare@suse.de>
 <20170216170519.GA9630@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33859 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754721AbdBQIGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:06:16 -0500
In-Reply-To: <20170216170519.GA9630@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>

On 02/16/2017 06:05 PM, Keith Busch wrote:
> On Thu, Feb 16, 2017 at 04:12:23PM +0100, Hannes Reinecke wrote:
>> The device handler needs to check if a given queue belongs to
>> a scsi device; only then does it make sense to attach a device
>> handler.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
> 
> The thing I don't like is that this still has dm-mpath directly calling
> into scsi. I don't think dm-mpath has any business calling protocol
> specific APIs, and doesn't help other protocols with similar needs.
> 
> Can we solve this with an indirection layer instead? 
> 
> (untested; just checking if this direction is preferable)

We could, but why?
ATM we're only having SCSI devices able to use device handler; adding
another layer of indirection doesn't solve anything here.
Moving the infrastructure one level up will only make sense if we're
getting non-SCSI device handler (ANA?), but until then I'd think it's
just overengineering.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
