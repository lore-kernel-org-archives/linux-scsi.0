From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [patch] [SCSI] scsi_transport_sas: check for allocation failure
Date: Fri, 08 Mar 2013 18:25:00 -0500
Message-ID: <513A734C.80807@interlog.com>
References: <20130308120215.GB18712@longonot.mountain>  <513A2678.5000803@interlog.com> <1362783019.2370.45.camel@dabdike.int.hansenpartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1362783019.2370.45.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 13-03-08 05:50 PM, James Bottomley wrote:
> On Fri, 2013-03-08 at 12:57 -0500, Douglas Gilbert wrote:
>> On 13-03-08 07:02 AM, Dan Carpenter wrote:
>>> Static checkers complain that this allocation isn't checked.  We
>>> should return zero if the allocation fails.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
>>> index 1b68142..a022997 100644
>>> --- a/drivers/scsi/scsi_transport_sas.c
>>> +++ b/drivers/scsi/scsi_transport_sas.c
>>> @@ -379,9 +379,12 @@ sas_tlr_supported(struct scsi_device *sdev)
>>>    {
>>>    	const int vpd_len = 32;
>>>    	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
>>> -	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
>>> +	char *buffer;
>>>    	int ret = 0;
>>>
>>> +	buffer = kzalloc(vpd_len, GFP_KERNEL);
>>> +	if (!buffer)
>>> +		goto out;
>>>    	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
>>>    		goto out;
>>>
>>
>> For 32 bytes, why not use the stack?
>
> Because the buffer is a DMA target.  You can't DMA to stack because of
> padding and cacheline issues.

And I went to the definition of scsi_get_vpd_page()
to see if that was called out in the header comments.
Guess what ... and those same header comments talked
about freeing a returned pointer. It needs to be
cleaned up, IMO.

Doug Gilbert

/**
  * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
  * @sdev: The device to ask
  * @page: Which Vital Product Data to return
  * @buf: where to store the VPD
  * @buf_len: number of bytes in the VPD buffer area
  *
  * SCSI devices may optionally supply Vital Product Data.  Each 'page'
  * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
  * If the device supports this VPD page, this routine returns a pointer
  * to a buffer containing the data from that page.  The caller is
  * responsible for calling kfree() on this pointer when it is no longer
  * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
  */
int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
                       int buf_len)
