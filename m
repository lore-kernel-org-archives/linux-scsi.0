From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 17/25] hpsa: move scsi_add_device and scsi_remove_device calls to new function
Date: Fri, 30 Oct 2015 10:56:55 -0500
Message-ID: <B5CF36FC-31B1-481B-B269-A2F8147323AC@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220613.5323.52829.stgit@brunhilda> <90741AFD-5D5E-4588-A7B1-53A3E80DA984@linux.vnet.ibm.com> <563281CB.5040409@pmcs.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50452 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbJ3P5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 11:57:02 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 09:57:01 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 2E2E61FF0021
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 09:45:10 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UFtpMM3015050
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 08:55:51 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UFuviZ016509
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 09:56:58 -0600
In-Reply-To: <563281CB.5040409@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Oct 29, 2015, at 3:30 PM, Don Brace <brace77070@gmail.com> wrote:
> 
> On 10/29/2015 12:21 PM, Matthew R. Ochs wrote:
>>> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
>>> 
>>> From: Kevin Barnett <kevin.barnett@pmcs.com>
>>> 
>>> preparation for adding the sas transport class
>>> 
>>> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
>>> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
>>> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
>>> Signed-off-by: Don Brace <don.brace@pmcs.com>
>>> ---
>>> drivers/scsi/hpsa.c |   65 +++++++++++++++++++++++++++++++--------------------
>>> 1 file changed, 39 insertions(+), 26 deletions(-)
>>> 
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>>> index 24b3c8c..06207e2 100644
>>> --- a/drivers/scsi/hpsa.c
>>> +++ b/drivers/scsi/hpsa.c
>>> @@ -1660,6 +1660,37 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
>>> 	}
>>> }
>>> 
>>> +static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
>>> +{
>>> +	int rc = 0;
>>> +
>>> +	rc = scsi_add_device(h->scsi_host, device->bus,
>>> +					device->target, device->lun);
>>> +	return rc;
>>> +}
>>> +
>>> +static void hpsa_remove_device(struct ctlr_info *h,
>>> +			struct hpsa_scsi_dev_t *device)
>>> +{
>>> +	struct scsi_device *sdev = NULL;
>>> +
>>> +	sdev = scsi_device_lookup(h->scsi_host, device->bus,
>>> +						device->target, device->lun);
>>> +
>>> +	if (sdev) {
>>> +		scsi_remove_device(sdev);
>>> +		scsi_device_put(sdev);
>>> +	} else {
>>> +		/*
>>> +		 * We don't expect to get here.  Future commands
>>> +		 * to this device will get a selection timeout as
>>> +		 * if the device were gone.
>>> +		 */
>>> +		hpsa_show_dev_msg(KERN_WARNING, h, device,
>>> +					"didn't find device for removal.");
>>> +	}
>>> +}
>>> +
>>> static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>>> 	struct hpsa_scsi_dev_t *sd[], int nsds)
>>> {
>>> @@ -1672,7 +1703,6 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>>> 	unsigned long flags;
>>> 	struct hpsa_scsi_dev_t **added, **removed;
>>> 	int nadded, nremoved;
>>> -	struct Scsi_Host *sh = NULL;
>>> 
>>> 	/*
>>> 	 * A reset can cause a device status to change
>>> @@ -1792,46 +1822,29 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>>> 	if (hostno == -1 || !changes)
>>> 		goto free_and_out;
>>> 
>>> -	sh = h->scsi_host;
>>> -	if (sh == NULL) {
>>> -		dev_warn(&h->pdev->dev, "%s: scsi_host is null\n", __func__);
>>> -		return;
>>> -	}
>> Are we guaranteed that h->scsi_host will never be NULL when running in here? Or when
>> the newly introduced hpsa_remove_device() is invoked elsewhere for that matter?
>> 
>> This commit loses this check and scsi_device_lookup() is not tolerant of a NULL
>> scsi_host * (first action is to grab the host_lock).
> Better to be safe. I'll add a check in both functions.

With these changes

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

