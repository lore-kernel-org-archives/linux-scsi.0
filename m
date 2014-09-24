From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V4 11/17] scsi: ufs: add UFS power management support
Date: Tue, 23 Sep 2014 17:14:47 -0700
Message-ID: <000c01cfd78c$8d865ca0$a89315e0$@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>    <1411457499-8074-12-git-send-email-draviv@codeaurora.org>    <20140923101451.GA11623@infradead.org> <4bbf3e7f23b55b6609367f47d2e2fdea.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:45186 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaIXAOt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 20:14:49 -0400
In-Reply-To: <4bbf3e7f23b55b6609367f47d2e2fdea.squirrel@www.codeaurora.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dolev Raviv' <draviv@codeaurora.org>
Cc: james.bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>

>> It would be good to have an explanation why you need to call REQUEST 
>> SENSE from the driver.  OR your own START STOP later one.  This all 
>> seems very much against the normal model of operation for SCSI 
>> devices.
>>
>
> Let me rephrase the explanation from the commit message:
> We issue request sense before sending START_STOP_UNIT to the device
well-known logical unit (w-lun) to make sure that the device w-lun unit
attention condition is cleared. Otherwise START_STOP_UNIT will fail.

Yes, we need to clear the unit attention condition by sending request sense
command once.


>
>As mentioned in my previous mail (in response to [9/17] patch comments),
UFS driver power management is controlled via device W-LUN during the
suspend process.
>As documented in the comment above: "
> * For selecting the UFS device power mode (Active / UFS_Sleep /
> * UFS_PowerDown), SCSI power management command (START STOP UNIT)
> * needs to be sent to a "UFS device" Well known Logical Unit (W-LU).
> * As this command would be sent during the UFS host controller
> * runtime/system PM callbacks, ....
>"
>Do you have another suggestion for making it compatible to other scsi
drivers?
>Would you prefer this logic would go into core scsi?

Meaning of PC (Power Condition) field in SSU command is modified by UFS
device specification:
1. PC=1 means Active power mode, PC=2 means UFS_Sleep mode compared to IDLE
mode in SBC spec & PC=3 means UFS_PowerDown compared to Standby mode in SBC
spec.
2. PC values from 1 to 3 only make sense if its send the "UFS device" well
known logical unit and this power condition is applied to all the logical
units (normal & well known) hence putting the entire UFS device into power
mode described by PC

We didn't find any similar implementation in scsi core power management and
as meaning of PC field is quite specific to UFS device, it's better to keep
it local at UFS driver which can take advantage of these modes better.
Now, given above explaination, we had 2 ways to send the SSU (and request
sense command) to device. One is to queue it to scsi mid layer and let it
issue to LLD (the way we are doing it now) and other one was to directly
send the command within UFS driver (rather than going through SCSI mid
layer) but we choose the first approach as it looks cleaner.

Regards,
Subhash

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dolev Raviv
Sent: Tuesday, September 23, 2014 5:58 AM
To: Christoph Hellwig
Cc: Dolev Raviv; james.bottomley@hansenpartnership.com; hch@infradead.org;
linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com; Subhash Jadavani; Sujit
Reddy Thumma
Subject: Re: [PATCH V4 11/17] scsi: ufs: add UFS power management support


>>  /**
>>   * ufshcd_slave_alloc - handle initial SCSI device configurations
>>   * @sdev: pointer to SCSI device
>> @@ -2232,6 +2403,21 @@ static int ufshcd_slave_alloc(struct 
>> scsi_device
>> *sdev)
>>
>>  	ufshcd_set_queue_depth(sdev);
>>
>> +	ufshcd_get_lu_power_on_wp_status(hba, sdev);
>> +
>> +	/*
>> +	 * For selecting the UFS device power mode (Active / UFS_Sleep /
>> +	 * UFS_PowerDown), SCSI power management command (START STOP UNIT)
>> +	 * needs to be sent to a "UFS device" Well known Logical Unit
(W-LU).
>> +	 * As this command would be sent during the UFS host controller
>> +	 * runtime/system PM callbacks, we need a reference to "scsi_device"
>> +	 * associated to "UFS device" W-LU. This change saves the
>> "scsi_device"
>> +	 * reference for "UFS device" W-LU during slave_configure() callback
>> +	 * from SCSI mid layer.
>> +	 */
>> +	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN)
>> +		hba->sdev_ufs_device = sdev;
>> +
>
> Storing the pointer in slave_alloc is not safe as you don't known if 
> the probing was successful.  In addition you really need a reference 
> to a scsi_device that you store somewhere as a user could easily 
> delete the device through sysfs, which any access to it invalid.
>
> As mention earlier you should just add this wlun using 
> __scsi_device_add which gives you a pointer and a reference to the fully
probed device.

Sounds reasonable, I'll coordinate it with the previous patch.

>
>> +static int
>> +ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device 
>> +*sdp) {
>> +	unsigned char cmd[6] = {REQUEST_SENSE,
>> +				0,
>> +				0,
>> +				0,
>> +				SCSI_SENSE_BUFFERSIZE,
>> +				0};
>> +	char *buffer;
>> +	int ret;
>> +
>> +	buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
>> +	if (!buffer) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	ret = scsi_execute_req_flags(sdp, cmd, DMA_FROM_DEVICE, buffer,
>> +				SCSI_SENSE_BUFFERSIZE, NULL,
>> +				msecs_to_jiffies(1000), 3, NULL, REQ_PM);
>> +	if (ret)
>> +		pr_err("%s: failed with err %d\n", __func__, ret);
>> +
>> +	kfree(buffer);
>> +out:
>> +	return ret;
>> +}
>
> It would be good to have an explanation why you need to call REQUEST 
> SENSE from the driver.  OR your own START STOP later one.  This all 
> seems very much against the normal model of operation for SCSI 
> devices.
>

Let me rephrase the explanation from the commit message:
We issue request sense before sending START_STOP_UNIT to the device
well-known logical unit (w-lun) to make sure that the device w-lun unit
attention condition is cleared. Otherwise START_STOP_UNIT will fail.

As mentioned in my previous mail (in response to [9/17] patch comments), UFS
driver power management is controlled via device W-LUN during the suspend
process.
As documented in the comment above: "
 * For selecting the UFS device power mode (Active / UFS_Sleep /
 * UFS_PowerDown), SCSI power management command (START STOP UNIT)
 * needs to be sent to a "UFS device" Well known Logical Unit (W-LU).
 * As this command would be sent during the UFS host controller
 * runtime/system PM callbacks, ....
"
Do you have another suggestion for making it compatible to other scsi
drivers?
Would you prefer this logic would go into core scsi?

--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

