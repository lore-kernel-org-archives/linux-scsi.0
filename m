From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH][RESEND] scsi_sysfs: add 'is_bin_visible' callback
Date: Wed, 2 Mar 2016 17:34:48 +0800
Message-ID: <56D6B3B8.8070109@suse.com>
References: <1456807945-88857-1-git-send-email-hare@suse.de>
 <20160301130448.GB7616@lst.de> <56D6973A.4070901@suse.de>
 <20160302091916.GE1308@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:46216 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbcCBJfH (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Wed, 2 Mar 2016 04:35:07 -0500
In-Reply-To: <20160302091916.GE1308@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/02/2016 05:19 PM, Christoph Hellwig wrote:
> On Wed, Mar 02, 2016 at 03:33:14PM +0800, Hannes Reinecke wrote:
>>>> +	rcu_read_lock();
>>>> +	if (attr == &dev_attr_vpd_pg80 &&
>>>> +	    !rcu_dereference(sdev->vpd_pg80)) {
>>>> +		rcu_read_unlock();
>>>> +		return 0;
>>>> +	}
>>>> +	if (attr == &dev_attr_vpd_pg83 &&
>>>> +	    !rcu_dereference(sdev->vpd_pg83)) {
>>>> +		rcu_read_unlock();
>>>> +		return 0;
>>>> +	}
>>>> +	rcu_read_unlock();
>>>
>>> We are only checking the pointers for being non-zero.  No need for the
>>> rcu_read_lock() or rcu_dereference() here.
>>>
>> Better to be same than sorry; some overly clever code analysis tool
>> might trip over it otherwise.
> 
> It shouldn't.  There is no dereference going on here.
> 
Ok.

>>
>>> Otherwise this looks fine to me.
>>
>> Reviewed-by: ?
> 
> Only without the cargo culted rcu magic.
> 
Okay, will be resending it.

Cheers,

Hannes
