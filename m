From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 20/25] hpsa: add discovery polling for PT RAID devices.
Date: Thu, 29 Oct 2015 15:59:13 -0500
Message-ID: <CC13A5AD-7DF6-420F-B1F8-54B6D79BB6CF@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220631.5323.15176.stgit@brunhilda> <BB4A1B04-92A0-46CF-8D08-9F56709268F3@linux.vnet.ibm.com> <563286B7.8070200@pmcs.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45684 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbJ2U7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 16:59:17 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 29 Oct 2015 14:59:17 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id D24AC19D803F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 14:47:24 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9TKw8ER11141572
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:58:08 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9TKxEhb024392
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 14:59:15 -0600
In-Reply-To: <563286B7.8070200@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Oct 29, 2015, at 3:51 PM, Don Brace <brace77070@gmail.com> wrote:
> On 10/29/2015 03:20 PM, Matthew R. Ochs wrote:
>>> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com>
>>>  wrote:
>>>=20
>>> From: Scott Teel=20
>>> <scott.teel@pmcs.com>
>>>=20
>>>=20
>>> There are problems with getting configuration change notification
>>> in pass-through RAID environments.  So, activate flag
>>> h->discovery_polling when one of these devices is detected in
>>> update_scsi_devices.
>>>=20
>>> After discovery_polling is set, execute a report luns from
>>> rescan_controller_worker (every 30 seconds).
>>>=20
>>> If the data from report_luns is different than last
>>> time (binary compare), execute a full rescan via update_scsi_device=
s.
>>>=20
>>> Reviewed-by: Scott Teel=20
>>> <scott.teel@pmcs.com>
>>>=20
>>> Reviewed-by: Justin Lindley=20
>>> <justin.lindley@pmcs.com>
>>>=20
>>> Reviewed-by: Kevin Barnett=20
>>> <kevin.barnett@pmcs.com>
>>>=20
>>> Signed-off-by: Don Brace=20
>>> <don.brace@pmcs.com>
>>>=20
>>> ---
>>> drivers/scsi/hpsa.c |   68 ++++++++++++++++++++++++++++++++++++++++=
+++++++++++
>>> drivers/scsi/hpsa.h |    2 ++
>>> 2 files changed, 70 insertions(+)
>>>=20
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>>> index 8d67648..e521acd 100644
>>> --- a/drivers/scsi/hpsa.c
>>> +++ b/drivers/scsi/hpsa.c
>>> @@ -276,6 +276,7 @@ static int hpsa_scsi_ioaccel_queue_command(stru=
ct ctlr_info *h,
>>> static void hpsa_command_resubmit_worker(struct work_struct *work);
>>> static u32 lockup_detected(struct ctlr_info *h);
>>> static int detect_controller_lockup(struct ctlr_info *h);
>>> +static int hpsa_luns_changed(struct ctlr_info *h);
>>>=20
>>> static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sde=
v)
>>> {
>>> @@ -3904,6 +3905,18 @@ static void hpsa_update_scsi_devices(struct =
ctlr_info *h, int hostno)
>>> 		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
>>> 		this_device =3D currentsd[ncurrent];
>>>=20
>>> +		/* Turn on discovery_polling if there are ext target devices.
>>> +		 * Event-based change notification is unreliable for those.
>>> +		 */
>>> +		if (!h->discovery_polling) {
>>> +			if (tmpdevice->external) {
>>> +				h->discovery_polling =3D 1;
>>> +				dev_info(&h->pdev->dev,
>>> +					"External target, activate discovery polling.\n");
>>> +			}
>>> +		}
>>> +
>>> +
>>> 		*this_device =3D *tmpdevice;
>>> 		this_device->physical_device =3D physical_device;
>>>=20
>>> @@ -8022,6 +8035,41 @@ static int hpsa_offline_devices_ready(struct=
 ctlr_info *h)
>>> 	return 0;
>>> }
>>>=20
>>> +static int hpsa_luns_changed(struct ctlr_info *h)
>>> +{
>>> +	int rc =3D 1; /* assume there are changes */
>>> +	struct ReportLUNdata *logdev =3D NULL;
>>> +
>>> +	/* if we can't find out if lun data has changed,
>>> +	 * assume that it has.
>>> +	 */
>>> +
>>> +	if (!h->lastlogicals)
>>> +		goto out;
>>> +
>>> +	logdev =3D kzalloc(sizeof(*logdev), GFP_KERNEL);
>>> +	if (!logdev) {
>>> +		dev_warn(&h->pdev->dev,
>>> +			"Out of memory, can't track lun changes.\n");
>>> +		goto out;
>>> +	}
>>> +	if (hpsa_scsi_do_report_luns(h, 1, logdev, sizeof(*logdev), 0)) {
>>> +		dev_warn(&h->pdev->dev,
>>> +			"report luns failed, can't track lun changes.\n");
>>> +		goto out;
>>> +	}
>>> +	if (memcmp(logdev, h->lastlogicals, sizeof(*logdev))) {
>>> +		dev_info(&h->pdev->dev,
>>> +			"Lun changes detected.\n");
>>> +		memcpy(h->lastlogicals, logdev, sizeof(*logdev));
>>> +		goto out;
>>> +	} else
>>> +		rc =3D 0; /* no changes detected. */
>>> +out:
>>> +	kfree(logdev);
>>> +	return rc;
>>> +}
>>> +
>>> static void hpsa_rescan_ctlr_worker(struct work_struct *work)
>>> {
>>> 	unsigned long flags;
>>> @@ -8037,6 +8085,18 @@ static void hpsa_rescan_ctlr_worker(struct w=
ork_struct *work)
>>> 		hpsa_ack_ctlr_events(h);
>>> 		hpsa_scan_start(h->scsi_host);
>>> 		scsi_host_put(h->scsi_host);
>>> +	} else if (h->discovery_polling) {
>>> +		if (hpsa_luns_changed(h)) {
>>> +			struct Scsi_Host *sh =3D NULL;
>>> +
>>> +			dev_info(&h->pdev->dev,
>>> +				"driver discovery polling rescan.\n");
>>> +			sh =3D scsi_host_get(h->scsi_host);
>>> +			if (sh !=3D NULL) {
>>> +				hpsa_scan_start(sh);
>>> +				scsi_host_put(sh);
>>> +			}
>>> +		}
>>> 	}
>>> 	spin_lock_irqsave(&h->lock, flags);
>>> 	if (!h->remove_in_progress)
>>> @@ -8277,6 +8337,8 @@ reinit_after_soft_reset:
>>>=20
>>> 	/* Enable Accelerated IO path at driver layer */
>>> 	h->acciopath_status =3D 1;
>>> +	/* Disable discovery polling.*/
>>> +	h->discovery_polling =3D 0;
>>>=20
>>>=20
>>> 	/* Turn the interrupts on so we can service requests */
>>> @@ -8284,6 +8346,11 @@ reinit_after_soft_reset:
>>>=20
>>> 	hpsa_hba_inquiry(h);
>>>=20
>>> +	h->lastlogicals =3D kzalloc(sizeof(*(h->lastlogicals)), GFP_KERNE=
L);
>>> +	if (!h->lastlogicals)
>>> +		dev_info(&h->pdev->dev,
>>> +			"Can't track change to report lun data\n");
>>> +
>>> 	/* Monitor the controller for firmware lockups */
>>> 	h->heartbeat_sample_interval =3D HEARTBEAT_SAMPLE_INTERVAL;
>>> 	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker)=
;
>>> @@ -8368,6 +8435,7 @@ static void hpsa_shutdown(struct pci_dev *pde=
v)
>>> 	hpsa_flush_cache(h);
>>> 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
>>> 	hpsa_free_irqs(h);			/* init_one 4 */
>>> +	kfree(h->lastlogicals);
>>>=20
>> Is this the best place to free this memory? If your rescan worker is=
 running
>> concurrently you might run into trouble.=20
>>=20
> Since hpsa_shutdown is called from hpsa_remove_one, at a point after=20
> cancel_delayed_work_sync(&h->rescan_ctlr_work) has already been calle=
d,=20
> I  think that the rescan worker won=92t be running at this point.

My concern wasn't about the remove path but rather the shutdown notific=
ation path.


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
