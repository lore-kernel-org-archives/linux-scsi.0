From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Tue, 1 Nov 2016 20:22:01 +0100
Message-ID: <1ee99c69-be1c-b357-a058-225fcb824d66@suse.de>
References: <1477936770-106687-1-git-send-email-hare@suse.de>
 <1477936770-106687-2-git-send-email-hare@suse.de>
 <20161101144744.GB17827@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41868 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbcKATWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 15:22:07 -0400
In-Reply-To: <20161101144744.GB17827@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 11/01/2016 03:47 PM, Christoph Hellwig wrote:
> On Mon, Oct 31, 2016 at 06:59:28PM +0100, Hannes Reinecke wrote:
>> Switch to using scsi_execute_req_flags() instead of using the
>> block primitives.
>
> __scsi_execute adds RQF_QUIET and RQF_PREEMPT to the request flags, which
> would be a change in behavior.  A little analysis on why that's safe or
> even desireable would be nice.  (This also applies to the other two patches
> I think).
>
Hmm. Yeah, guess I'll need to reconcile that.

>>
>>  static void release_controller(struct kref *kref)
>>  static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
>>  			char *array_name, u8 *array_id)
>>  {
>> +	int err = SCSI_DH_IO, i;
>>  	struct c8_inquiry *inqp;
>>
>> +	if (!scsi_get_vpd_page(sdev, 0xC8, (unsigned char *)h,
>> +			       sizeof(struct c8_inquiry))) {
>
> This looks completely bogus to me - h is a struct rdac_dh_data pointer,
> which is an in-kernel data structure that scsi_get_vpd_page would
> scramble over.
>
Indeed, you are right. I'll be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
