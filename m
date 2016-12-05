From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2] xen/scsifront: don't request a slot on the ring until
 request is ready
Date: Mon, 5 Dec 2016 16:35:13 +0100
Message-ID: <2f607bd6-f058-34bd-fb92-642e78ee283e@suse.com>
References: <20161125202650.GK6266@mwanda>
 <20161202061545.14614-1-jgross@suse.com>
 <6cbdced5-c4fe-8083-3a90-09c428f3ff8f@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45497 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751176AbcLEPfR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Dec 2016 10:35:17 -0500
In-Reply-To: <6cbdced5-c4fe-8083-3a90-09c428f3ff8f@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: lambert.quentin@gmail.com, linux-scsi@vger.kernel.org, dan.carpenter@oracle.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

On 05/12/16 16:32, Boris Ostrovsky wrote:
> On 12/02/2016 01:15 AM, Juergen Gross wrote:
>>  
>> -static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
>> +static int scsifront_do_request(struct vscsifrnt_info *info,
>> +				struct vscsifrnt_shadow *shadow)
>>  {
>>  	struct vscsiif_front_ring *ring = &(info->ring);
>>  	struct vscsiif_request *ring_req;
>> +	struct scsi_cmnd *sc = shadow->sc;
>>  	uint32_t id;
>> +	int i, notify;
>> +
>> +	if (RING_FULL(&info->ring))
>> +		return -EBUSY;
>>  
>>  	id = scsifront_get_rqid(info);	/* use id in response */
>>  	if (id >= VSCSIIF_MAX_REQS)
>> -		return NULL;
>> +		return -EBUSY;
>> +
>> +	info->shadow[id] = shadow;
>> +	shadow->rqid = id;
>>  
>>  	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
>> -
>>  	ring->req_prod_pvt++;
>>  
>> -	ring_req->rqid = (uint16_t)id;
>> +	ring_req->rqid        = id;
>> +	ring_req->act         = shadow->act;
>> +	ring_req->ref_rqid    = shadow->ref_rqid;
>> +	ring_req->nr_segments = shadow->nr_segments;
> 
> Shouldn't req_prod_pvt be incremented after you've copied everything? (I
> realize that there is not error until everything has been copied but still.)

That doesn't really matter as it is private.

>> @@ -473,44 +496,14 @@ static int map_data_for_request(struct vscsifrnt_info *info,
>>  	}
>>  
>>  	if (seg_grants)
>> -		ring_req->nr_segments = VSCSIIF_SG_GRANT | seg_grants;
>> +		shadow->nr_segments = VSCSIIF_SG_GRANT | seg_grants;
> 
> Are we guaranteed that seg_grants is not going to have VSCSIIF_SG_GRANT
> bit set?

Absolutely, yes. Can't be larger than VSCSIIF_SG_TABLESIZE which is 26.


Juergen
