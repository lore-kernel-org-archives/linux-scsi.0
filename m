From: Jan Vesely <jvesely@redhat.com>
Subject: Re: [PATCH] [SCSI] scsilun_to_int should ignore the highest 2 bits
Date: Thu, 06 Jun 2013 11:46:00 +0200
Message-ID: <51B05A58.1070006@redhat.com>
References: <1370506691-22933-1-git-send-email-jvesely@redhat.com> <51B04B68.8080001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51B04B68.8080001@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Thu 06 Jun 2013 10:42:16 CEST, Hannes Reinecke wrote:
> On 06/06/2013 10:18 AM, Jan Vesely wrote:
>> From: Jan Vesely <jvesely@redhat.com>
>>
>> The comment says the function does this but it does not.
>> Reported luns change from weirdly high numbers (like 16640)
>> to something saner (256), when using flat space addressing.
>>
>> CC: James Bottomley <JBottomley@Parallels.com>
>> CC: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Jan Vesely <jvesely@redhat.com>
>> ---
>>  drivers/scsi/scsi_scan.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 3e58b22..38dc093 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1244,7 +1244,7 @@ int scsilun_to_int(struct scsi_lun *scsilun)
>>
>>  	lun = 0;
>>  	for (i = 0; i < sizeof(lun); i += 2)
>> -		lun = lun | (((scsilun->scsi_lun[i] << 8) |
>> +		lun = lun | ((((scsilun->scsi_lun[i] & 0x3f) << 8) |
>>  			      scsilun->scsi_lun[i + 1]) << (i * 8));
>>  	return lun;
>>  }
>>
> Bzzt. It's not that simple.
>
> For SCSI-3 _all_ numbers are valid, and doesn't know of any
> addressing scheme. It's only SPC-2 which introduced the addressing
> scheme. So at the very least you should be checking the scsi
> revision before attempting something like this.
>
> But in general doing a sequential scan past 256 is criminally
> dangerous. Any array / device attempting to is in most cases
> misconfigured or does not have the correct BLIST flag set.
>
> I know of some older Hitachi and EMC firmware which would pretend to
> be SCSI-2, but supporting more than 256 LUNs per host.
> Which, of course, it totally bonkers.
>
> I'll be posting my 64-bit LUN patchset, that should fix this issue.
>
> Cheers,
>
> Hannes

thanks for your response.

I'm concerned with iSCSI. it uses SAM2 LUN addressing scheme,
and since I found that comment I did not investigate further.

I'll wait for your lun64 patches,
thanks again
--
Jan Vesely <jvesely@redhat.com>
