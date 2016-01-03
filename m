From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/20] scsi_dh_alua: Use workqueue for RTPG
Date: Sun, 3 Jan 2016 11:53:28 +0100
Message-ID: <20160103105328.GB10025@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-12-git-send-email-hare@suse.de> <20151230131923.GA15270@lst.de> <56852737.4000803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60019 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbcACKxa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jan 2016 05:53:30 -0500
Content-Disposition: inline
In-Reply-To: <56852737.4000803@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Dec 31, 2015 at 02:01:43PM +0100, Hannes Reinecke wrote:
>>>   	if (tmp_pg) {
>>>   		spin_unlock(&port_group_lock);
>>> -		kfree(pg);
>>> -		return tmp_pg;
>>> +		kref_put(&pg->kref, release_port_group);
>>> +		pg = tmp_pg;
>>> +		tmp_pg = NULL;
>>
>> The only thing release_port_group does in addition to the kfree
>> is a list_del on pg->entry.  But given that we never added
>> the pg to a list it doesn't need to be deleted, and it can't
>> have another reference.  Why this change?
>>
> Mainly for symmetry; with this patch we're always calling kref_put() to 
> delete the port_group structure.

Given that it has never been added it's not actuallt symmetric.

Either way it shouldn't be added in this patch - either use kref_put
from the patch introducing the kref or not use it at all.  I would
prefer the second option.

>>
>> pg_found should be pg_updated, right?
>>
>>> +	if (pg_found)
>>> +		synchronize_rcu();
>>> +	if (old_pg) {
>>> +		if (old_pg->rtpg_sdev)
>>> +			flush_delayed_work(&old_pg->rtpg_work);
>>> +		kref_put(&old_pg->kref, release_port_group);
>>> +	}
>>
>> This code looks odd.  I can't see why we need a synchronize_rcu here.
>> The only thing we should need is a kfree_rcu for the final free in
>> release_port_group.  I also don't quite understand the flush_delayed_work.
>> As far as I can tell we only need it if rtpg_sdev is the sdev passed
>> in, so it we probably should check for that.
>>
> rtpg_sdev is set whenever the port_group structure needs or is scheduled 
> for alua_rtpg_work(), ie whenever some action needs to be taken.
> As the sdev might be a different sdev than that one we've been called from 
> (a port_group might have several sdevs pointing to it), the existence of an 
> sdev signals that we need to flush the workqueue item.

So why do we only need to flush it for some kref_put callers and not the
others?
