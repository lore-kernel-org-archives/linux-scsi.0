From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Wed, 2 Nov 2016 22:27:02 +0100
Message-ID: <6bb2b352-d137-a9da-2f35-e6b0cdef4774@suse.com>
References: <1478036978-30583-1-git-send-email-hare@suse.de>
 <1478036978-30583-2-git-send-email-hare@suse.de>
 <1478101469.1001.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:55127 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757568AbcKBV1j (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 2 Nov 2016 17:27:39 -0400
In-Reply-To: <1478101469.1001.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 11/02/2016 04:44 PM, Ewan D. Milne wrote:
> On Tue, 2016-11-01 at 22:49 +0100, Hannes Reinecke wrote:
> ...
>>  static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
>>  			char *array_name, u8 *array_id)
>>  {
>> -	int err, i;
>> -	struct c8_inquiry *inqp;
>> +	int err = SCSI_DH_IO, i;
>> +	struct c8_inquiry *inqp = &h->inq.c8;
>>
>> -	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
>> -	if (err == SCSI_DH_OK) {
>> -		inqp = &h->inq.c8;
>> +	if (!scsi_get_vpd_page(sdev, 0xC8, (unsigned char *)inqp,
>> +			       sizeof(struct c8_inquiry))) {
>>  		if (inqp->page_code != 0xc8)
>>  			return SCSI_DH_NOSYS;
>>  		if (inqp->page_id[0] != 'e' || inqp->page_id[1] != 'd' ||
>> @@ -453,20 +382,20 @@ static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
>>  		*(array_name+ARRAY_LABEL_LEN-1) = '\0';
>>  		memset(array_id, 0, UNIQUE_ID_LEN);
>>  		memcpy(array_id, inqp->array_unique_id, inqp->array_uniq_id_len);
>> +		err = SCSI_DH_OK;
>>  	}
>>  	return err;
>>  }
>>
>
> In this and other places the patch changes the code from submitting the
> INQUIRY/EVPD command for the page it wants, to calling scsi_get_vpd_page().
> scsi_get_vpd_page() will return -EINVAL if the device did not report in
> VPD page 0 that the requested page is in the list of supported pages.
> Did you actually verify that the RDAC returns all of these VPD pages in
> its VPD page 0 list?
>
> I mean, I know it's supposed to, but these are old devices.
>
Errm.

Old? Don't tell that to the E-Series folk; you'll never again get 
something sponsored :-)

No, seriously: RDAC mode is continued to be supported even on the latest 
models, and all firmware revisions I've got support VPD page 0x0.
And incidentally, this is the very same method we're using for basically 
all tools accessing VPD page 0x83, be it in the kernel or something like 
sg3_utils.
_Not_ asking for page 0x0 lead to crashes on several older devices.

Cheers,

Hannes
