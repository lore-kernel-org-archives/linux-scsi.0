From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/4] sg: disable SET_FORCE_LOW_DMA
Date: Fri, 3 Feb 2017 11:16:49 +0100
Message-ID: <6500a0ae-e08c-210e-fc13-a28d1eaca949@suse.com>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
 <1486112091-68470-2-git-send-email-hare@suse.de>
 <56d69348-13e0-8daa-9fac-942033ab564a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:43103 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752648AbdBCKQw (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 3 Feb 2017 05:16:52 -0500
In-Reply-To: <56d69348-13e0-8daa-9fac-942033ab564a@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On 02/03/2017 10:32 AM, Johannes Thumshirn wrote:
> 
> On 02/03/2017 09:54 AM, Hannes Reinecke wrote:
>> The ioctl SET_FORCE_LOW_DMA has never worked since the initial
>> git check-in, and the respective setting is nowadays handled
>> correctly.
>> So disable it entirely.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
> 
> [...]
> 
>>       case SG_SET_FORCE_LOW_DMA:
>> -        result = get_user(val, ip);
>> -        if (result)
>> -            return result;
>> -        if (val) {
>> -            sfp->low_dma = 1;
>> -            if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
>> -                val = (int) sfp->reserve.bufflen;
>> -                sg_remove_scat(sfp, &sfp->reserve);
>> -                sg_build_reserve(sfp, val);
>> -            }
>> -        } else {
>> -            if (atomic_read(&sdp->detaching))
>> -                return -ENODEV;
>> -            sfp->low_dma = sdp->device->host->unchecked_isa_dma;
>> -        }
>> -        return 0;
>> +        return -EINVAL;
> 
> I'm not sure if returning a bogus '0' is better here to not break any
> existing application, which assumed it always worked.
> 
Well, the ioctl already was returning error numbers, so any calling
application had to protect against that.
And I don't really see the point to protect against failures in legacy
applications relying on a functionality which never did anything.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
