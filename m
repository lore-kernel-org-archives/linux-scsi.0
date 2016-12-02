From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] hpsa: fallback to use legacy REPORT PHYS command
Date: Fri, 2 Dec 2016 11:23:45 +0100
Message-ID: <f4f73b0d-2212-74f5-d782-07b07cad4202@suse.de>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
 <1479454369-100281-3-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D194180126E@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43909 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754978AbcLBKXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 05:23:49 -0500
In-Reply-To: <4993A297653ECB4581FA5C3C31323D194180126E@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Martin Wilck <martin.wilck@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On 12/01/2016 10:50 PM, Don Brace wrote:
>
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, November 18, 2016 1:33 AM
>> To: Martin K. Petersen
>> Cc: Christoph Hellwig; James Bottomley; Don Brace; Martin Wilck; linux-
>> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>> Subject: [PATCH 2/3] hpsa: fallback to use legacy REPORT PHYS command
>>
>> EXTERNAL EMAIL
>>
>>
>> Older SmartArray controller do not support the extended REPORT PHYS
>> command, so fallback to use the legacy version here.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/hpsa.c | 28 ++++++++++++++++++++++++++--
>>  1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 488e17c..3d89f74 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -3628,8 +3628,32 @@ static int hpsa_scsi_do_report_luns(struct
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
>> +               nphys = be32_to_cpu(*((__be32 *)lbuf->LUNListLength)) / 24;
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
> For a non-extended REPORT_PHYS, the buffer size is 8, so the divisor needs to be 8.
> REPORT_PHYS_EXTENDED has been around a long time, which controller and fw are you testing this on so I can
> Also run some tests.
>
That was seen on an Smart Array 64xx.
Yes, I know, horribly ancient.

But this was sort-of the idea, namely that we can use 'hpsa' as a 
complete replacement for cciss.

I'll be fixing up the patch and resubmit it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
