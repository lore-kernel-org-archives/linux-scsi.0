From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3] scsi: report 'INQUIRY result too short' once per host
Date: Tue, 13 Oct 2015 13:17:05 +0200
Message-ID: <87eggzxbke.fsf@vitty.brq.redhat.com>
References: <1444323291-16447-1-git-send-email-vkuznets@redhat.com>
	<561BA89B.2040504@suse.de> <87egh0yv5s.fsf@vitty.brq.redhat.com>
	<561CA1C6.2010207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <561CA1C6.2010207@suse.de> (Hannes Reinecke's message of "Tue, 13
	Oct 2015 08:16:38 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke <hare@suse.de> writes:

> On 10/12/2015 05:16 PM, Vitaly Kuznetsov wrote:
>> Hannes Reinecke <hare@suse.de> writes:
>> 
>>> On 10/08/2015 06:54 PM, Vitaly Kuznetsov wrote:
>>>> Some host adapters (e.g. Hyper-V storvsc) are known for not respecting the
>>>> SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain at
>>>> least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
>>>> INQUIRY result too short (5), using 36' messages on console. This can be
>>>> problematic for slow consoles. Introduce short_inquiry flag in struct
>>>> Scsi_Host to print the message once per host.
>>>>
>>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>>> ---
>>>> Changes since v2:
>>>> - This is a successor of previously sent (and still not merged) "scsi:
>>>>   introduce short_inquiry flag for broken host adapters" patch. I'm not
>>>>   particularly sure which solution is better but I'm leaning towards this
>>>>   one as it doesn't require changes to adapter drivers.
>>>> ---
>>>>  drivers/scsi/scsi_scan.c | 9 ++++++---
>>>>  include/scsi/scsi_host.h | 3 +++
>>>>  2 files changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>>> index f9f3f82..cd347e4 100644
>>>> --- a/drivers/scsi/scsi_scan.c
>>>> +++ b/drivers/scsi/scsi_scan.c
>>>> @@ -701,9 +701,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>>>>  	 * strings.
>>>>  	 */
>>>>  	if (sdev->inquiry_len < 36) {
>>>> -		sdev_printk(KERN_INFO, sdev,
>>>> -			    "scsi scan: INQUIRY result too short (%d),"
>>>> -			    " using 36\n", sdev->inquiry_len);
>>>> +		if (!sdev->host->short_inquiry) {
>>>> +			shost_printk(KERN_INFO, sdev->host,
>>>> +				    "scsi scan: INQUIRY result too short (%d),"
>>>> +				    " using 36\n", sdev->inquiry_len);
>>>> +			sdev->host->short_inquiry = 1;
>>>> +		}
>>>>  		sdev->inquiry_len = 36;
>>>>  	}
>>>>  
>>> At least you need to check if you've received any valid data here;
>>> 'INQUIRY result too short' is also a common error if the interrupt
>>> is hosed when trying to access the device.
>>> So please check for 'inquiry_len > 4' before setting 'short_inquiry'.
>> 
>> Currently we proceed even with a shorter reply... Should we abort the
>> scan (and return -EOI?) in case we got inquiry_len <= 4?
>> 
> Yes please. We need to ensure that we actually received some data,
> and not running into an error scenario here.
> So we need to read at least five bytes of data, as byte 4 carries
> the response length. If we read less than that we have no way of
> figuring out if the response data is even remotely sane.
>

I just checked and it seems such check would be redundant. inquiry_len
is always >=5 as we have the following code:

response_len = inq_result[4] + 5;

where inq_result is unsigned char *

After that we do:
sdev->inquiry_len = min(try_inquiry_len, response_len);

As far as I can see try_inquiry_len can be lower than 36 only in case
some driver sets it manually. I don't see a '>=5' check for it but I'm
not sure it is needed.

-- 
  Vitaly
