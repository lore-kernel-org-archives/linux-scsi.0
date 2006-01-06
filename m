From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] Make scsi error recovery play nice with devices blocked
 by transport
Date: Fri, 06 Jan 2006 15:33:50 -0600
Message-ID: <43BEE23E.8040707@sgi.com>
References: <43A35498.6030903@sgi.com> <43B2B77B.20602@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.26]:33420 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1750860AbWAFVeB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2006 16:34:01 -0500
In-Reply-To: <43B2B77B.20602@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Jeremy Higdon <jeremy@sgi.com>



James Smart wrote:
> This patch looks ok. It's certainly an issue that we (Emulex) have been
> fighting, with the answer being : always ensure that the device i/o timeout
> is 2x (+ some fudge?) the devloss_tmo. As we recommend setting the i/o
> timeout to 60 seconds for enterprise arrays, and as devloss_tmo defaults
> to 30, this generally worked.
> 
> One other point though that should be addressed. This doesn't affect the
> successive "bigger hammer" recovery steps in scsi_eh_ready_devs().  We
> should have the function recognize that the scsi_eh_stu(),
> scsi_eh_bus_device_reset(), scsi_eh_bus_reset() functions can fail due to
> a cable pull (e.g. devices being blocked), which is ok, and does not
> require the next level of reset. Causing a host reset because of a
> temporary cable pull, or a bus reset (all targets on a bus to be reset)
> because an unrelated one temporarily went away - are not good things.

Well, a device can go away for reasons other than a cable pull.
Sometimes (in my experience with SGI's driver for qlogic fc cards)
harder resets can bring it back whereas waiting won't.  Think firmware
problems....

I think letting the harder resets happen is a good thing (or at least
not a bad thing) as long as recovery waits for the driver to report that
the drive is gone (offline).

Mike

> 
> -- james s
> 
> 
> Michael Reed wrote:
>>As no one has commented, I'm reposting this rfc as a patch.  I've
>>been using it for all my testing during development of the LSI MPT Fusion
>>fc transport attribute patch and it has shown no ill effect.
>>
>>--
>>
>>Error recovery doesn't interact very well with fc targets which
>>have been blocked by the fc transport.  Error recovery continues
>>to attempt to recover the target and ends up marking the fc target
>>offline.  Once offline, if the target returns before the remote port is
>>removed, commands which could have been successfully reissued instead
>>are completed with an error status due to the offline status
>>of the target.
>>
>>This patch makes a couple of hopefully minor tweaks to the error
>>recovery logic to work better with targets which have been blocked
>>by the transport.
>>
>>First, if the target is blocked and error recovery gives up, don't
>>put the device offline.  Either the transport will delete the target
>>thus disposing of any queued requests or it will unblock the target and
>>requests will be reissued.
>>
>>Second, if a device is blocked, queue up commands being flushed from
>>the done queue for retry instead of completing them with an error.
>>
>>Thanks,
>> Mike Reed
>>
>>
>>
>>------------------------------------------------------------------------
>>
>>diff -ru linux-2.6.15-rc5-git6-patched/drivers/scsi/scsi_error.c linux-2.6.15-rc5-git6-patched-mdr/drivers/scsi/scsi_error.c
>>--- linux-2.6.15-rc5-git6-patched/drivers/scsi/scsi_error.c	2005-12-16 16:48:19.000000000 -0600
>>+++ linux-2.6.15-rc5-git6-patched-mdr/drivers/scsi/scsi_error.c	2005-12-16 17:42:07.000000000 -0600
>>@@ -1130,10 +1130,14 @@
>> 	struct scsi_cmnd *scmd, *next;
>> 
>> 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
>>-		sdev_printk(KERN_INFO, scmd->device,
>>-			    "scsi: Device offlined - not"
>>-			    " ready after error recovery\n");
>>-		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
>>+		/* if blocked, transport will provide final device disposition */
>>+		if (!scsi_device_blocked(scmd->device)) {
>>+			sdev_printk(KERN_INFO, scmd->device,
>>+				    "scsi: Device offlined - not"
>>+				    " ready after error recovery\n");
>>+			scsi_device_set_state(scmd->device, SDEV_OFFLINE);
>>+		}
>>+
>> 		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
>> 			/*
>> 			 * FIXME: Handle lost cmds.
>>@@ -1460,9 +1464,10 @@
>> 
>> 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
>> 		list_del_init(&scmd->eh_entry);
>>-		if (scsi_device_online(scmd->device) &&
>>+		if (scsi_device_blocked(scmd->device) ||
>>+		    (scsi_device_online(scmd->device) &&
>> 		    !blk_noretry_request(scmd->request) &&
>>-		    (++scmd->retries < scmd->allowed)) {
>>+		    (++scmd->retries < scmd->allowed))) {
>> 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
>> 							  " retry cmd: %p\n",
>> 							  current->comm,
>>diff -ru linux-2.6.15-rc5-git6-patched/include/scsi/scsi_device.h linux-2.6.15-rc5-git6-patched-mdr/include/scsi/scsi_device.h
>>--- linux-2.6.15-rc5-git6-patched/include/scsi/scsi_device.h	2005-12-05 12:39:40.000000000 -0600
>>+++ linux-2.6.15-rc5-git6-patched-mdr/include/scsi/scsi_device.h	2005-12-16 17:42:07.000000000 -0600
>>@@ -275,6 +275,11 @@
>> 			    int data_direction, void *buffer, unsigned bufflen,
>> 			    struct scsi_sense_hdr *, int timeout, int retries);
>> 
>>+static inline int scsi_device_blocked(struct scsi_device *sdev)
>>+{
>>+	return sdev->sdev_state == SDEV_BLOCK;
>>+}
>>+
>> static inline unsigned int sdev_channel(struct scsi_device *sdev)
>> {
>> 	return sdev->channel;
> 
