From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/8] scsi-drivers Don't use SG_ALL as allocation size
Date: Thu, 17 Jan 2008 20:11:57 +0200
Message-ID: <478F9A6D.1010605@panasas.com>
References: <478F8435.5000907@panasas.com> <478F85E7.20503@panasas.com> <20080117174745.GB20186@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7781 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752520AbYAQSMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 13:12:06 -0500
In-Reply-To: <20080117174745.GB20186@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jan 17 2008 at 19:47 +0200, Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> On Thu, 17 Jan 2008, Boaz Harrosh wrote:
> 
>>   below list of drivers have used SG_ALL as a size to
>>   preallocate maximum possible command's sg-count.
>>   This is no longer possible since the maximum is not
>>   set at compile time but as a run time configuration.
>>
>>   A better schema can be advised with a more dynamic allocation.
>>   Perhaps from a kmem_cache.
>>
>>   Affected drivers/files:
>> 	drivers/scsi/atari_scsi.[ch]
>> 	drivers/scsi/eata_pio.c
>> 	drivers/scsi/ibmvscsi/ibmvscsi.[ch]
>> 	drivers/scsi/mac53c94.c
>> 	drivers/scsi/mesh.c
>> 	drivers/scsi/nsp32.h
>> 	drivers/scsi/qla1280.c
>> 	drivers/scsi/qla2xxx/qla_os.c
>> 	drivers/scsi/qla4xxx/ql4_def.h
> ...
> 
> There's no functional change in your patches to qla2xxx and qla4xxx.
> Perhaps a cut-n-paste typo from qla1280.c (which should be capped):
> 
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>> index 78d1103..e368f38 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -111,6 +111,8 @@ static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
>>  static int qla2x00_change_queue_depth(struct scsi_device *, int);
>>  static int qla2x00_change_queue_type(struct scsi_device *, int);
>>  
>> +#define QLA2XXX_MAX_SG 255
>> +
>>  struct scsi_host_template qla2x00_driver_template = {
>>  	.module			= THIS_MODULE,
>>  	.name			= QLA2XXX_DRIVER_NAME,
>> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
>> index accaf69..64cd43b 100644
>> --- a/drivers/scsi/qla4xxx/ql4_def.h
>> +++ b/drivers/scsi/qla4xxx/ql4_def.h
>> @@ -101,6 +101,7 @@
>>  #define MBOX_AEN_REG_COUNT	5
>>  #define MAX_INIT_RETRIES	5
>>  #define IOCB_HIWAT_CUSHION	16
>> +#define QLA_MAX_SG		255
> 
> 
> I don't forsee any issues with maintaining SG_ALL (~0) usage within
> qla2xxx and qla4xxx, as the number of unused entries on the HBA's
> request-queue shall ultimately be the rate-limiting factor.
> 
> --
Please forgive me I have forgot to put the use of this constants at
body, see patch below.

I have seen the use of a device memory at the scsi_for_each_sg loop and was
not at all sure what is the size limit for that. So I played it safe,
actually I changed nothing. Please give me the OK to remove ql[24]xxx from
these patches, and have them change to SG_ALL==~0 in the last patch.
Or should I resend the patch with below added.

Thanks for catching this
Boaz

--  
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e368f38..b0999b6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -134,7 +134,7 @@ struct scsi_host_template qla2x00_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= QLA2XXX_MAX_SG,
 
 	/*
 	 * The RISC allows for each command to transfer (2^32-1) bytes of data,
@@ -165,7 +165,7 @@ struct scsi_host_template qla24xx_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= QLA2XXX_MAX_SG,
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla2x00_host_attrs,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b128da5..0b8de79 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -94,7 +94,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= QLA_MAX_SG,
 
 	.max_sectors		= 0xFFFF,
 };


