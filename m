From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2.5 4/6] scsi_debug: vpd and mode page work
Date: Mon, 2 May 2016 11:48:28 -0400
Message-ID: <572776CC.1030305@interlog.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-5-git-send-email-dgilbert@interlog.com>
 <572711EA.3080600@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49449 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbcEBPsi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2016 11:48:38 -0400
In-Reply-To: <572711EA.3080600@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 2016-05-02 04:38 AM, Hannes Reinecke wrote:
> On 05/01/2016 04:44 AM, Douglas Gilbert wrote:
>> Cleanup some mode and vpd pages. Stop reporting SBC (disk) pages
>> when peripheral type is something else (e.g. tape). Update
>> version descriptors. Expand LBPRZ flag handling.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 187 ++++++++++++++++++++++++++--------------------
>>   1 file changed, 108 insertions(+), 79 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 0932111..814067d 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -125,7 +125,7 @@ static const char *sdebug_version_date = "20160430";
>>   #define DEF_PHYSBLK_EXP 0
>>   #define DEF_PTYPE   TYPE_DISK
>>   #define DEF_REMOVABLE false
>> -#define DEF_SCSI_LEVEL   6    /* INQUIRY, byte2 [6->SPC-4] */
>> +#define DEF_SCSI_LEVEL   7    /* INQUIRY, byte2 [6->SPC-4; 7->SPC-5] */
>>   #define DEF_SECTOR_SIZE 512
>>   #define DEF_UNMAP_ALIGNMENT 0
>>   #define DEF_UNMAP_GRANULARITY 1
>> @@ -657,7 +657,11 @@ static const int device_qfull_result =
>>   	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
>>
>>
>> -static inline unsigned int scsi_debug_lbp(void)
>> +/* Only do the extra work involved in logical block provisioning if one or
>> + * more of the lbpu, lbpws or lbpws10 parameters are given and we are doing
>> + * real reads and writes (i.e. not skipping them for speed).
>> + */
>> +static inline bool scsi_debug_lbp(void)
>>   {
>>   	return 0 == sdebug_fake_rw &&
>>   		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
>> @@ -918,10 +922,10 @@ static const u64 naa5_comp_b = 0x5333333000000000ULL;
>>   static const u64 naa5_comp_c = 0x5111111000000000ULL;
>>
>>   /* Device identification VPD page. Returns number of bytes placed in arr */
>> -static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
>> -			   int target_dev_id, int dev_id_num,
>> -			   const char * dev_id_str,
>> -			   int dev_id_str_len)
>> +static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
>> +			  int target_dev_id, int dev_id_num,
>> +			  const char *dev_id_str,
>> +			  int dev_id_str_len)
>>   {
>>   	int num, port_a;
>>   	char b[32];
>> @@ -1000,14 +1004,14 @@ static unsigned char vpd84_data[] = {
>>   };
>>
>>   /*  Software interface identification VPD page */
>> -static int inquiry_evpd_84(unsigned char * arr)
>> +static int inquiry_vpd_84(unsigned char *arr)
>>   {
>>   	memcpy(arr, vpd84_data, sizeof(vpd84_data));
>>   	return sizeof(vpd84_data);
>>   }
>>
>>   /* Management network addresses VPD page */
>> -static int inquiry_evpd_85(unsigned char * arr)
>> +static int inquiry_vpd_85(unsigned char *arr)
>>   {
>>   	int num = 0;
>>   	const char * na1 = "https://www.kernel.org/config";
>> @@ -1042,7 +1046,7 @@ static int inquiry_evpd_85(unsigned char * arr)
>>   }
>>
>>   /* SCSI ports VPD page */
>> -static int inquiry_evpd_88(unsigned char * arr, int target_dev_id)
>> +static int inquiry_vpd_88(unsigned char *arr, int target_dev_id)
>>   {
>>   	int num = 0;
>>   	int port_a, port_b;
>> @@ -1129,7 +1133,7 @@ static unsigned char vpd89_data[] = {
>>   };
>>
>>   /* ATA Information VPD page */
>> -static int inquiry_evpd_89(unsigned char * arr)
>> +static int inquiry_vpd_89(unsigned char *arr)
>>   {
>>   	memcpy(arr, vpd89_data, sizeof(vpd89_data));
>>   	return sizeof(vpd89_data);
>> @@ -1144,7 +1148,7 @@ static unsigned char vpdb0_data[] = {
>>   };
>>
>>   /* Block limits VPD page (SBC-3) */
>> -static int inquiry_evpd_b0(unsigned char * arr)
>> +static int inquiry_vpd_b0(unsigned char *arr)
>>   {
>>   	unsigned int gran;
>>
>> @@ -1187,7 +1191,7 @@ static int inquiry_evpd_b0(unsigned char * arr)
>>   }
>>
>>   /* Block device characteristics VPD page (SBC-3) */
>> -static int inquiry_evpd_b1(unsigned char *arr)
>> +static int inquiry_vpd_b1(unsigned char *arr)
>>   {
>>   	memset(arr, 0, 0x3c);
>>   	arr[0] = 0;
>> @@ -1198,24 +1202,22 @@ static int inquiry_evpd_b1(unsigned char *arr)
>>   	return 0x3c;
>>   }
>>
>> -/* Logical block provisioning VPD page (SBC-3) */
>> -static int inquiry_evpd_b2(unsigned char *arr)
>> +/* Logical block provisioning VPD page (SBC-4) */
>> +static int inquiry_vpd_b2(unsigned char *arr)
>>   {
>>   	memset(arr, 0, 0x4);
>>   	arr[0] = 0;			/* threshold exponent */
>> -
>>   	if (sdebug_lbpu)
>>   		arr[1] = 1 << 7;
>> -
>>   	if (sdebug_lbpws)
>>   		arr[1] |= 1 << 6;
>> -
>>   	if (sdebug_lbpws10)
>>   		arr[1] |= 1 << 5;
>> -
>> -	if (sdebug_lbprz)
>> -		arr[1] |= 1 << 2;
>> -
>> +	if (sdebug_lbprz && scsi_debug_lbp())
>> +		arr[1] |= (sdebug_lbprz & 0x7) << 2;  /* sbc4r07 and later */
>> +	/* anc_sup=0; dp=0 (no provisioning group descriptor) */
>> +	/* minimum_percentage=0; provisioning_type=0 (unknown) */
>> +	/* threshold_percentage=0 */
>>   	return 0x4;
>>   }
>>
>> @@ -1228,12 +1230,13 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>>   	unsigned char * arr;
>>   	unsigned char *cmd = scp->cmnd;
>>   	int alloc_len, n, ret;
>> -	bool have_wlun;
>> +	bool have_wlun, is_disk;
>>
>>   	alloc_len = get_unaligned_be16(cmd + 3);
>>   	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
>>   	if (! arr)
>>   		return DID_REQUEUE << 16;
>> +	is_disk = (sdebug_ptype == TYPE_DISK);
>>   	have_wlun = scsi_is_wlun(scp->device->lun);
>>   	if (have_wlun)
>>   		pq_pdt = TYPE_WLUN;	/* present, wlun */
>> @@ -1271,11 +1274,12 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>>   			arr[n++] = 0x86;  /* extended inquiry */
>>   			arr[n++] = 0x87;  /* mode page policy */
>>   			arr[n++] = 0x88;  /* SCSI ports */
>> -			arr[n++] = 0x89;  /* ATA information */
>> -			arr[n++] = 0xb0;  /* Block limits (SBC) */
>> -			arr[n++] = 0xb1;  /* Block characteristics (SBC) */
>> -			if (scsi_debug_lbp()) /* Logical Block Prov. (SBC) */
>> -				arr[n++] = 0xb2;
>> +			if (is_disk) {	  /* SBC only */
>> +				arr[n++] = 0x89;  /* ATA information */
>> +				arr[n++] = 0xb0;  /* Block limits */
>> +				arr[n++] = 0xb1;  /* Block characteristics */
>> +				arr[n++] = 0xb2;  /* Logical Block Prov */
>> +			}
>>   			arr[3] = n - 4;	  /* number of supported VPD pages */
>>   		} else if (0x80 == cmd[2]) { /* unit serial number */
>>   			arr[1] = cmd[2];	/*sanity */
>> @@ -1283,21 +1287,21 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>>   			memcpy(&arr[4], lu_id_str, len);
>>   		} else if (0x83 == cmd[2]) { /* device identification */
>>   			arr[1] = cmd[2];	/*sanity */
>> -			arr[3] = inquiry_evpd_83(&arr[4], port_group_id,
>> -						 target_dev_id, lu_id_num,
>> -						 lu_id_str, len);
>> +			arr[3] = inquiry_vpd_83(&arr[4], port_group_id,
>> +						target_dev_id, lu_id_num,
>> +						lu_id_str, len);
>>   		} else if (0x84 == cmd[2]) { /* Software interface ident. */
>>   			arr[1] = cmd[2];	/*sanity */
>> -			arr[3] = inquiry_evpd_84(&arr[4]);
>> +			arr[3] = inquiry_vpd_84(&arr[4]);
>>   		} else if (0x85 == cmd[2]) { /* Management network addresses */
>>   			arr[1] = cmd[2];	/*sanity */
>> -			arr[3] = inquiry_evpd_85(&arr[4]);
>> +			arr[3] = inquiry_vpd_85(&arr[4]);
>>   		} else if (0x86 == cmd[2]) { /* extended inquiry */
>>   			arr[1] = cmd[2];	/*sanity */
>>   			arr[3] = 0x3c;	/* number of following entries */
>>   			if (sdebug_dif == SD_DIF_TYPE3_PROTECTION)
>>   				arr[4] = 0x4;	/* SPT: GRD_CHK:1 */
>> -			else if (sdebug_dif)
>> +			else if (have_dif_prot)
>>   				arr[4] = 0x5;   /* SPT: GRD_CHK:1, REF_CHK:1 */
>>   			else
>>   				arr[4] = 0x0;   /* no protection stuff */
>> @@ -1311,20 +1315,20 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>>   			arr[10] = 0x82;	 /* mlus, per initiator port */
>>   		} else if (0x88 == cmd[2]) { /* SCSI Ports */
>>   			arr[1] = cmd[2];	/*sanity */
>> -			arr[3] = inquiry_evpd_88(&arr[4], target_dev_id);
>> -		} else if (0x89 == cmd[2]) { /* ATA information */
>> +			arr[3] = inquiry_vpd_88(&arr[4], target_dev_id);
>> +		} else if (is_disk && 0x89 == cmd[2]) { /* ATA information */
>>   			arr[1] = cmd[2];        /*sanity */
>> -			n = inquiry_evpd_89(&arr[4]);
>> +			n = inquiry_vpd_89(&arr[4]);
>>   			put_unaligned_be16(n, arr + 2);
>> -		} else if (0xb0 == cmd[2]) { /* Block limits (SBC) */
>> +		} else if (is_disk && 0xb0 == cmd[2]) { /* Block limits */
>>   			arr[1] = cmd[2];        /*sanity */
>> -			arr[3] = inquiry_evpd_b0(&arr[4]);
>> -		} else if (0xb1 == cmd[2]) { /* Block characteristics (SBC) */
>> +			arr[3] = inquiry_vpd_b0(&arr[4]);
>> +		} else if (is_disk && 0xb1 == cmd[2]) { /* Block char. */
>>   			arr[1] = cmd[2];        /*sanity */
>> -			arr[3] = inquiry_evpd_b1(&arr[4]);
>> -		} else if (0xb2 == cmd[2]) { /* Logical Block Prov. (SBC) */
>> +			arr[3] = inquiry_vpd_b1(&arr[4]);
>> +		} else if (is_disk && 0xb2 == cmd[2]) { /* LB Prov. */
>>   			arr[1] = cmd[2];        /*sanity */
>> -			arr[3] = inquiry_evpd_b2(&arr[4]);
>> +			arr[3] = inquiry_vpd_b2(&arr[4]);
>>   		} else {
>>   			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
>>   			kfree(arr);
> Probably beside the point, but why do you provide the ATA
> information VPD? Upon seeing this any tool _might_ be induced to
> think of it as an SATL device, and start sending interesting
> ATA_12 or ATA_16 commands ...

Yes that is a bit curious (and I put that code there some time ago).
If an application client does respond by sending ATA_12, ATA_16
or ATA_32 (new from T10) then it will get an illegal request (invalid
command operation code) from this driver. And the application client
should react gracefully to that.

So that could be removed, but that should be done as a separate patch
just in case somebody's test harness is relying on the current
behavior. The change in this patch is to make sure those SAT and SBC
related VPD pages are not returned if the pdt is other than a disk.
[Which brings up the question of RBC and ZBC).

Doug Gilbert

> Otherwise the patch looks okay:
>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
>
> Cheers,
>
> Hannes
>

