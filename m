From: David Milburn <dmilburn@redhat.com>
Subject: Re: [RFC] aic7xxx - ahc_done check SCB_ACTIVE for tagged transactions
Date: Tue, 29 Jan 2008 10:11:50 -0600
Message-ID: <479F5046.4010800@redhat.com>
References: <20080125181618.GB26158@dhcp-210.hsv.redhat.com> <479F43B8.2090902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759510AbYA2QCg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 11:02:36 -0500
In-Reply-To: <479F43B8.2090902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> David Milburn wrote:
> 
>>Hannes,
>>
>>Does ahc_done need to check the SCB_ACTIVE flag only if the SCB
>>is not in the untagged queue before panic?
>>
>>If the driver is in error recovery, you may end panic'ing
>>on a TUR that is in the untagged queue.
>>
>>Attempting to queue an ABORT message
>>CDB: 0x0 0x0 0x0 0x0 0x0 0x0
>>SCB 3 done'd twice
>>
>>This patch is included in Adaptec's 6.3.11 driver on their 
>>website.
>>
>>Thank you,
>>David
>>
>>--- scsi-misc-2.6.git/drivers/scsi/aic7xxx/aic7xxx_osm.c.abort
>>+++ scsi-misc-2.6.git/drivers/scsi/aic7xxx/aic7xxx_osm.c
>>@@ -1658,9 +1658,12 @@ ahc_done(struct ahc_softc *ahc, struct s
>> 		untagged_q = &(ahc->untagged_queues[target_offset]);
>> 		TAILQ_REMOVE(untagged_q, scb, links.tqe);
>> 		BUG_ON(!TAILQ_EMPTY(untagged_q));
>>-	}
>>-
>>-	if ((scb->flags & SCB_ACTIVE) == 0) {
>>+	} else if ((scb->flags & SCB_ACTIVE) == 0) {
>>+		/*
>>+		 * Transactions aborted from the untagged queue may
>>+		 * not have been dispatched to the controller, so
>>+		 * only check the SCB_ACTIVE flag for tagged transactions.
>>+		 */
>> 		printf("SCB %d done'd twice\n", scb->hscb->tag);
>> 		ahc_dump_card_state(ahc);
>> 		panic("Stopping for safety");
>>
> 
> Yes, this looks correct. The SCB_ACTIVE flag is reset when doing an ahc_scb_free()
> at the very end of ahc_done(). And seeing that we are re-using scbs for error recovery
> we might indeed end up with an scb with SCB_ACTIVE is set.
> 
> But I'll do some more investigation.
> Do you have any setup to exercise this?

Hannes,

I don't have a hands on setup, but, I verified the fix
by providing a rhel4 test kernel to prevent the panic
above.

James committed to scsi-misc-2.6.git

cddb3e38076639aacf2182e4b164e45ee8bbe6d8

Thanks,
David


> 
> Cheers,
> 
> Hannes

