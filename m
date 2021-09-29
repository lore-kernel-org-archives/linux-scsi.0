Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F27C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B850F61406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 07:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243462AbhI2H6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 03:58:46 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:59725 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244268AbhI2H6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 03:58:21 -0400
Received: from [192.168.0.3] (ip5f5aef97.dynamic.kabel-deutschland.de [95.90.239.151])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A473961E64761;
        Wed, 29 Sep 2021 09:56:34 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH V2 05/11] smartpqi: add tur check for
 sanitize operation
To:     Don Brace <don.brace@microchip.com>
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, john.p.donnelly@oracle.com,
        mwilck@suse.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-6-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <c50efe26-2ee2-e880-3bb1-dd0ba60d2ec5@molgen.mpg.de>
Date:   Wed, 29 Sep 2021 09:56:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928235442.201875-6-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don,


Thank you for the patch. Maybe rephrase the summary:

 > Check TUR for sanitize operation


Am 29.09.21 um 01:54 schrieb Don Brace:
> Add in a TUR to HBA disks and do not present them to the OS if

Maybe add what TUR means: Test Unit Ready.

> 0x02/0x04/0x1b (sanitize in progress) is returned.
> 
> During boot-up, some OSes appear to hang when there are one or
> more disks undergoing sanitize.

It’d be great, if you gave at least one concrete test setup, where the 
hang occurred.

> According to SCSI SBC4 specification
> section 4.11.2 Commands allowed during sanitize,
> some SCSI commands are permitted, but read/write operations are not.
> 
> When the OS attempts to read the disk partition table a
> CHECK CONDITION ASC 0x04 ASCQ 0x1b is returned which causes the OS
> to retry the read until sanitize has completed. This can take hours.
> 
> Note: According to document HPE Smart Storage Administrator User Guide
> Link: https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=c03909334
> 
> During the sanitize erase operation, the drive is unusable.
> I.E.
>        The expected behavior for sanitize is the that disk remains
>        offline even after sanitize has completed. The customer is
>        expected to re-enable the disk using the management utility.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 87 +++++++++++++++++++++++++++
>   1 file changed, 87 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 01330fd67500..838274d8fadf 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -555,6 +555,10 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
>   	cdb = request->cdb;
>   
>   	switch (cmd) {
> +	case TEST_UNIT_READY:
> +		request->data_direction = SOP_READ_FLAG;
> +		cdb[0] = TEST_UNIT_READY;
> +		break;
>   	case INQUIRY:
>   		request->data_direction = SOP_READ_FLAG;
>   		cdb[0] = INQUIRY;
> @@ -1575,6 +1579,85 @@ static int pqi_get_logical_device_info(struct pqi_ctrl_info *ctrl_info,
>   	return rc;
>   }
>   
> +/*
> + * Prevent adding drive to OS for some corner cases such as a drive
> + * undergoing a sanitize operation. Some OSes will continue to poll
> + * the drive until the sanitize completes, which can take hours,
> + * resulting in long bootup delays. Commands such as TUR, READ_CAP
> + * are allowed, but READ/WRITE cause check condition. So the OS
> + * cannot check/read the partition table.
> + * Note: devices that have completed sanitize must be re-enabled
> + *       using the management utility.
> + */
> +static bool pqi_keep_device_offline(struct pqi_ctrl_info *ctrl_info,
> +	struct pqi_scsi_dev *device)
> +{
> +	u8 scsi_status;
> +	int rc;
> +	enum dma_data_direction dir;
> +	char *buffer;
> +	int buffer_length = 64;

Use size_t? And could be made const?

> +	size_t sense_data_length;
> +	struct scsi_sense_hdr sshdr;
> +	struct pqi_raid_path_request request;
> +	struct pqi_raid_error_info error_info;
> +	bool offline = false; /* Assume keep online */
> +
> +	/* Do not check controllers. */

I’d remove the dot/period at the end of the short comments.

> +	if (pqi_is_hba_lunid(device->scsi3addr))
> +		return false;
> +
> +	/* Do not check LVs. */
> +	if (pqi_is_logical_device(device))
> +		return false;
> +
> +	buffer = kmalloc(buffer_length, GFP_KERNEL);
> +	if (!buffer)
> +		return false; /* Assume not offline */
> +
> +	/* Check for SANITIZE in progress using TUR */
> +	rc = pqi_build_raid_path_request(ctrl_info, &request,
> +		TEST_UNIT_READY, RAID_CTLR_LUNID, buffer,
> +		buffer_length, 0, &dir);
> +	if (rc)
> +		goto out; /* Assume not offline */
> +
> +	memcpy(request.lun_number, device->scsi3addr, sizeof(request.lun_number));
> +
> +	rc = pqi_submit_raid_request_synchronous(ctrl_info, &request.header, 0, &error_info);
> +
> +	if (rc)
> +		goto out; /* Assume not offline */
> +
> +	scsi_status = error_info.status;
> +	sense_data_length = get_unaligned_le16(&error_info.sense_data_length);
> +	if (sense_data_length == 0)
> +		sense_data_length =
> +			get_unaligned_le16(&error_info.response_data_length);

As the variable is named `sense_data_length`, for an outsider like me, 
it’s suprising that `response_date_length` is stored in there.

> +	if (sense_data_length) {
> +		if (sense_data_length > sizeof(error_info.data))
> +			sense_data_length = sizeof(error_info.data);
> +
> +		/*
> +		 * Check for sanitize in progress: asc:0x04, ascq: 0x1b

Add a space after the second colon?

> +		 */
> +		if (scsi_status == SAM_STAT_CHECK_CONDITION &&
> +			scsi_normalize_sense(error_info.data,
> +				sense_data_length, &sshdr) &&
> +				sshdr.sense_key == NOT_READY &&
> +				sshdr.asc == 0x04 &&
> +				sshdr.ascq == 0x1b) {
> +			device->device_offline = true;
> +			offline = true;
> +			goto out; /* Keep device offline */
> +		}
> +	}

Should a error, warning, or debug message be printed, when 
`sense_data_length = 0` again?

> +
> +out:
> +	kfree(buffer);
> +	return offline;
> +}
> +
>   static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
>   	struct pqi_scsi_dev *device,
>   	struct bmic_identify_physical_device *id_phys)
> @@ -2296,6 +2379,10 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
>   		if (!pqi_is_supported_device(device))
>   			continue;
>   
> +		/* Do not present disks that the OS cannot fully probe */
> +		if (pqi_keep_device_offline(ctrl_info, device))

I’d use the positive `!pqi_get_device_online()`, but it’s subjective.

> +			continue;
> +
>   		/* Gather information about the device. */
>   		rc = pqi_get_device_info(ctrl_info, device, id_phys);
>   		if (rc == -ENOMEM) {
> 


Kind regards,

Paul
