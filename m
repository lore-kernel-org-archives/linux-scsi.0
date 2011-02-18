From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 4/6] lpfc 8.3.21: Initialization and user interface changes
Date: Fri, 18 Feb 2011 17:29:37 -0500
Message-ID: <4D5EF2D1.4080106@emulex.com>
References: <1297877997.1492.27.camel@wookie> <1298062769.3007.181.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:44392 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754895Ab1BRWaB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2011 17:30:01 -0500
In-Reply-To: <1298062769.3007.181.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On 2/18/2011 3:59 PM, James Bottomley wrote:
> On Wed, 2011-02-16 at 12:39 -0500, James Smart wrote:
>> - Make link speed not supported by port message an error message.
>> - Add support for new SLI failure codes add sysfs parameter to reflect the
>>    security setting and current state.
>> - Add all lpfc module parameters to the /sys/modules/lpfc/parameters directory.
>>
>>   Signed-off-by: Alex Iannicelli<alex.iannicelli@emulex.com>
>>   Signed-off-by: James Smart<james.smart@emulex.com>
>
> Someone didn't compile check this:
>
> drivers/scsi/lpfc/lpfc_debugfs.c:96: error: 'S_IRUGO0' undeclared here (not in a function)
> drivers/scsi/lpfc/lpfc_debugfs.c:96: error: bit-field '<anonymous>' width not an integer constant
> make[3]: *** [drivers/scsi/lpfc/lpfc_debugfs.o] Error 1
>
> The error is here:

Actually I did. I compile check after every patch application, and started 
with a scsi-misc-2.6 git snapshot the evening prior to the post.  We also do 
PPC cross builds and checks as well before posting.  So I'm a little at a loss 
why this is failing.  Hmmm.... maybe my check didn't enable DEBUGFS, as we've 
been running this in so many places it didn't seem meaningful.  If so - crud. 
I apologize.

Checking it out now....

-- james s




>
>> diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
>> --- a/drivers/scsi/lpfc/lpfc_debugfs.c	2010-08-04 10:31:45.000000000 -0400
>> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2011-02-16 11:33:35.000000000 -0500
>> @@ -82,23 +82,23 @@
>>    *                               the HBA. X MUST also be a power of 2.
>>    */
>>   static int lpfc_debugfs_enable = 1;
>> -module_param(lpfc_debugfs_enable, int, 0);
>> +module_param(lpfc_debugfs_enable, int, S_IRUGO);
>>   MODULE_PARM_DESC(lpfc_debugfs_enable, "Enable debugfs services");
>>
>>   /* This MUST be a power of 2 */
>>   static int lpfc_debugfs_max_disc_trc;
>> -module_param(lpfc_debugfs_max_disc_trc, int, 0);
>> +module_param(lpfc_debugfs_max_disc_trc, int, S_IRUGO);
>>   MODULE_PARM_DESC(lpfc_debugfs_max_disc_trc,
>>   	"Set debugfs discovery trace depth");
>>
>>   /* This MUST be a power of 2 */
>>   static int lpfc_debugfs_max_slow_ring_trc;
>> -module_param(lpfc_debugfs_max_slow_ring_trc, int, 0);
>> +module_param(lpfc_debugfs_max_slow_ring_trc, int, S_IRUGO0);
>>   MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
>>   	"Set debugfs slow ring trace depth");
>
> I assume this is just supposed to be S_IRUGO like everything else?
>
> James
>
>
