From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Mon, 22 Oct 2007 21:10:49 +0200
Message-ID: <471CF5B9.2090800@panasas.com>
References: <20071019083239.D88FE18C61E@pentland.suse.de> <1192983563.3339.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29663 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752481AbXJVTLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Oct 2007 15:11:04 -0400
In-Reply-To: <1192983563.3339.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, Oct 21 2007 at 18:19 +0200, James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2007-10-19 at 10:32 +0200, Hannes Reinecke wrote:
>> The patch enables support for 16-bit CDBs in aic7xxx and aic79xx.
>> aic7xxx can actually support up to 32-bit CDBs, should they ever see
>> the light of day.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/aic7xxx/aic79xx.h     |    2 ++
>>  drivers/scsi/aic7xxx/aic79xx_osm.c |    1 +
>>  drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
>>  3 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
>> index ce638aa..883f26a 100644
>> --- a/drivers/scsi/aic7xxx/aic79xx.h
>> +++ b/drivers/scsi/aic7xxx/aic79xx.h
>> @@ -413,6 +413,8 @@ struct target_status {
>>   * the sense buffer address in the SCB.  This allows
>>   * us to retrieve sense information without interrupting
>>   * the host in packetized mode.
>> + * The current firmware relies on a CDB len of 16, so
>> + * don't change it unless you know what you're doing.
>>   */
>>  typedef uint32_t sense_addr_t;
>>  #define MAX_CDB_LEN 16
>> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
>> index 2d02040..f4e12e1 100644
>> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
>> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
>> @@ -1090,6 +1090,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
>>  	host->max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
>>  	host->max_lun = AHD_NUM_LUNS;
>>  	host->max_channel = 0;
>> +	host->max_cmd_len = 16;
> 
> Actually, the aic79xx doc we now have through the LF NDA programme says
> that the 79xx can also go up to 32 byte CDBs.
> 
>>  	host->sg_tablesize = AHD_NSEG;
>>  	ahd_lock(ahd, &s);
>>  	ahd_set_unit(ahd, ahd_linux_unit++);
>> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
>> index 390b0fc..d488764 100644
>> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
>> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
>> @@ -1048,6 +1048,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
>>  	host->max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
>>  	host->max_lun = AHC_NUM_LUNS;
>>  	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
>> +	host->max_cmd_len = 32;
>>  	host->sg_tablesize = AHC_NSEG;
>>  	ahc_lock(ahc, &s);
>>  	ahc_set_unit(ahc, ahc_linux_unit++);
> 
> But, I suppose the main point is: is this really necessary?  The
> default, when unspecified, is 16 bytes and the mid-layer can't deliver
> anything larger.  I would anticipate the large CDB infrastructure will
> have some separate enabling, so why not simply do nothing until that
> gets merged?
> 
> James

I'm about to finish an RFC patchset for the extended commands.
I have implemented a more aggressive approach than the one
I've been sending for the last year.
(Matthew I have an extra 8-bytes save to scsi_cmnd on 
64bit and 12 bytes for 32bit. Guess how? ;))

>From what I have now, (And also the old patch sets) host->max_cmd_len serves the same
function, Limit the command size sent by the mid-layer. Even more so with the support
of extended commands.

So I recommend this patch.

If a driver does not have internal fixed-sized buffers to store the CDB than 
setting of host->max_cmd_len, and use of cmnd->cmd_len will be enough to support
extended CDB's.

Boaz

