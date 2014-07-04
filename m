From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri, 04 Jul 2014 16:38:42 +0200
Message-ID: <53B6BC72.6040204@acm.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-3-git-send-email-hare@suse.de> <53B69E97.4050901@acm.org> <53B6A5B4.2040807@suse.de> <20140704134835.GB12345@infradead.org> <53B6B669.10704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:55012 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaGDOir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 10:38:47 -0400
In-Reply-To: <53B6B669.10704@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/04/14 16:12, Hannes Reinecke wrote:
> On 07/04/2014 03:48 PM, Christoph Hellwig wrote:
>> I think storing the struct scsi_lun in the scsi_device is the right way
>> to go ahead.  Any "accessors" for 8 or 32-bit LUNs should be simply
>> enough by just ignoring bits in the array, so there's very little
>> performance overhead.
>>
>> If we can get rid of the old scalar LUN field that would be great,
>> and given that we know the printk format fallout already it doesn't look
>> like too much work.  Do you want to look into this?
>
> Already working on it.

That sounds great. Regarding the SRP initiator driver: if the "__be64
lun" declarations in <scsi/srp.h> are changed into "struct scsi_lun lun"
then that allows to encode / decode LUNs inside the SRP initiator
without having to cast the address of these "lun" members into struct
scsi_lun *. In case you would prefer me to have a look into this, please
let me know.

Bart.
