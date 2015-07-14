From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH v2] aic7xxx: replace kmalloc/strcpy by kstrdup
Date: Tue, 14 Jul 2015 13:27:33 +0200
Message-ID: <55A4F225.4070804@bfs.de>
References: <4159f01e6450cee8093e7d6a0d979bbeab8243d0.1436858599.git.christophe.jaillet@wanadoo.fr> <1436868133-32096-1-git-send-email-christophe.jaillet@wanadoo.fr> <55A4DF76.80800@suse.de>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55A4DF76.80800@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 14.07.2015 12:07, schrieb Hannes Reinecke:
> On 07/14/2015 12:02 PM, Christophe JAILLET wrote:
>> This replaces kmalloc + strcpy by an equivalent call to kstrdup.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> v2: remove useless curly braces
>>
>>  drivers/scsi/aic7xxx/aic79xx_osm.c | 6 ++----
>>  drivers/scsi/aic7xxx/aic7xxx_osm.c | 6 ++----
>>  2 files changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
>> index ce96a0b..ea4086e 100644
>> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
>> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
>> @@ -1250,11 +1250,9 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
>>  	ahd_set_unit(ahd, ahd_linux_unit++);
>>  	ahd_unlock(ahd, &s);
>>  	sprintf(buf, "scsi%d", host->host_no);
>> -	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
>> -	if (new_name != NULL) {
>> -		strcpy(new_name, buf);
>> +	new_name = kstrdup(buf, GFP_ATOMIC);
>> +	if (new_name != NULL)
>>  		ahd_set_name(ahd, new_name);
>> -	}
>>  	host->unique_id = ahd->unit;
>>  	ahd_linux_initialize_scsi_bus(ahd);
>>  	ahd_intr_enable(ahd, TRUE);
>> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
>> index a2f2c77..f0ac966 100644
>> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
>> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
>> @@ -1114,11 +1114,9 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
>>  	ahc_set_unit(ahc, ahc_linux_unit++);
>>  	ahc_unlock(ahc, &s);
>>  	sprintf(buf, "scsi%d", host->host_no);
>> -	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
>> -	if (new_name != NULL) {
>> -		strcpy(new_name, buf);
>> +	new_name = kstrdup(buf, GFP_ATOMIC);
>> +	if (new_name != NULL)
>>  		ahc_set_name(ahc, new_name);
>> -	}
>>  	host->unique_id = ahc->unit;
>>  	ahc_linux_initialize_scsi_bus(ahc);
>>  	ahc_intr_enable(ahc, TRUE);
>>
> Alright, if you insist ...
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>



If i did not miss an other use of buf,
you can replace the sprintf/strdup combo with:

new_name = kasprintf(GFP_ATOMIC, "scsi%d", host->host_no);


just my 2 cents
re,
 wh


> Cheers,
> 
> Hannes
