From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3] hpsa: fallback to use legacy REPORT PHYS command
Date: Sat, 3 Dec 2016 09:00:35 +0100
Message-ID: <f76c13ab-7bf5-95ea-f737-0ad341b9707f@suse.de>
References: <1480674973-118250-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D1941807694@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36087 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbcLCINt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 3 Dec 2016 03:13:49 -0500
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1941807694@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On 12/03/2016 01:36 AM, Don Brace wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, December 02, 2016 4:36 AM
>> To: Martin K. Petersen
>> Cc: Christoph Hellwig; James Bottomley; Don Brace; linux-
>> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>> Subject: [PATCHv3] hpsa: fallback to use legacy REPORT PHYS command
>>
>> EXTERNAL EMAIL
>>
>>
>> Older SmartArray controllers (eg SmartArray 64xx) do
>> not support the extended REPORT PHYS command, so
>> fallback to use the legacy version here.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/hpsa.c | 28 ++++++++++++++++++++++++++--
>>  1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 216c137..3783ef6 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -3640,8 +3640,32 @@ static int hpsa_scsi_do_report_luns(struct
>> ctlr_info *h, int logical,
>>  static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
>>                 struct ReportExtendedLUNdata *buf, int bufsize)
>>  {
>> -       return hpsa_scsi_do_report_luns(h, 0, buf, bufsize,
>> -                                               HPSA_REPORT_PHYS_EXTENDED);
>> +       int rc;
>> +       struct ReportLUNdata *lbuf;
>> +
>> +       rc = hpsa_scsi_do_report_luns(h, 0, buf, bufsize,
>> +                                     HPSA_REPORT_PHYS_EXTENDED);
>> +       if (!rc || !hpsa_allow_any)
>> +               return rc;
>> +
>> +       /* REPORT PHYS EXTENDED is not supported */
>> +       lbuf = kzalloc(sizeof(*lbuf), GFP_KERNEL);
>> +       if (!lbuf)
>> +               return -ENOMEM;
>> +
>> +       rc = hpsa_scsi_do_report_luns(h, 0, lbuf, sizeof(*lbuf), 0);
>> +       if (!rc) {
>> +               int i;
>> +               u32 nphys;
>> +
>> +               /* Copy ReportLUNdata header */
>> +               memcpy(buf, lbuf, 8);
>> +               nphys = be32_to_cpu(*((__be32 *)lbuf->LUNListLength)) / 8;
>> +               for (i = 0; i < nphys; i++)
>> +                       memcpy(buf->LUN[i].lunid, lbuf->LUN[i], 8);
>> +       }
>> +       kfree(lbuf);
>> +       return rc;
>>  }
>>
>>  static inline int hpsa_scsi_do_report_log_luns(struct ctlr_info *h,
>> --
>> 1.8.5.6
>
> Acked-by: Don Brace <don.brace@microsemi.com>
>
> Note: there has been zero testing on our end of these ancient controllers with the hpsa driver.
> While it might work there is no official support from either us or HPE on this configuration.
>
Understood. Additionally this will only ever be used if the 
'hpsa_allow_any' parameter is set, which already should be a hint to the 
user that he's about to enter unchartered territory.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
