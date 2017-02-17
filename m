From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCHv2 06/11] mpt3sas: Introduce mpt3sas_get_st_from_smid()
Date: Fri, 17 Feb 2017 10:35:08 +0100
Message-ID: <937a6f1c-ebc7-c8a6-b379-658db805f51f@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
 <1487319790-97340-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39159 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbdBQJfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 04:35:16 -0500
In-Reply-To: <1487319790-97340-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/17/2017 09:23 AM, Hannes Reinecke wrote:
> +struct scsiio_tracker *
> +mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
> +{
> +	WARN_ON(!smid);
> +	WARN_ON(smid >= ioc->hi_priority_smid);
> +	return &ioc->scsi_lookup[smid - 1];
> +}

Hmm if smid == 0 we'd be accessing &ioc->scsi_lookup[-1] and that's an
array out of bounds.

In patch 9/11 you'll get a unique tag of -2 (which is _not_ SCSI_NO_TAG)
and will be an array out of bounds as well in  blk_map_queue_find_tag()
or blk_mq_tag_to_rq().

if (WARN_ON(!smid))
	return NULL;

Should fix both.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
