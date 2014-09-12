From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Date: Fri, 12 Sep 2014 11:31:00 +0800
Message-ID: <1410492660.5045.12.camel@Centos6.3-64>
References: <1408433122.4748.73.camel@Centos6.3-64>
	 <53FDE490.1070201@redhat.com> <1409240809.4762.259.camel@Centos6.3-64>
	 <53FF2544.8020601@redhat.com> <20140909163057.GA25745@infradead.org>
	 <541020CB.8010302@redhat.com> <1410407950.4753.18.camel@Centos6.3-64>
	 <5411AFF3.5090708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62929 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaILDbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 23:31:08 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so267307pab.40
        for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2014 20:31:07 -0700 (PDT)
In-Reply-To: <5411AFF3.5090708@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:21 +0200, Tomas Henzl wrote:
> On 09/11/2014 05:59 AM, Ching Huang wrote:
> > On Wed, 2014-09-10 at 11:58 +0200, Tomas Henzl wrote:
> >> On 09/09/2014 06:30 PM, Christoph Hellwig wrote:
> >>> Ching,
> >>>
> >>> do you have a chance to address Thomas second concern below?  As
> >>> far as I can tell (Thomas, please correct me) that's the last
> >>> outstanding concern, and I'd really like to merge the arcmsr updates
> >>> for the Linux 3.18 merge window.
> >> Correct, still awaiting a response.
> > Christoph, Tomas,
> >
> > Sorry for the late reply.
> >
> > I think I misunderstand Tomas' meaning.
> > The spin lock in arcmsr_hbaD_polling_ccbdone() is necessary to protect doneq_index and have to be modified as following.
> 
> OK, so you are going to repost 16/17 ? If so, please describe all changes you'll do, in that new post.
> 
By previous review, I will post two patches.
One for 13/17 and another for 16/17.
These patches are relative to http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
> >
> > static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
> > 				struct CommandControlBlock *poll_ccb)
> > {
> > 	bool error;
> > 	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
> > 	int rtn, doneq_index, index_stripped, outbound_write_pointer, toggle;
> > 	unsigned long flags;
> > 	struct ARCMSR_CDB *arcmsr_cdb;
> > 	struct CommandControlBlock *pCCB;
> > 	struct MessageUnit_D *pmu = acb->pmuD;
> >
> > polling_hbaD_ccb_retry:
> > 	poll_count++;
> > 	while (1) {
> > 		spin_lock_irqsave(&acb->doneq_lock, flags);
> > 		outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
> > 		doneq_index = pmu->doneq_index;
> > 		if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {
> > 			spin_unlock_irqrestore(&acb->doneq_lock, flags);
> > 			if (poll_ccb_done) {
> > 				rtn = SUCCESS;
> > 				break;
> > 			} else {
> > 				msleep(25);
> > 				if (poll_count > 40) {
> > 					rtn = FAILED;
> > 					break;
> > 				}
> > 				goto polling_hbaD_ccb_retry;
> > 			}
> > 		}
> > 		toggle = doneq_index & 0x4000;
> > 		index_stripped = (doneq_index & 0xFFF) + 1;
> > 		index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
> > 		pmu->doneq_index = index_stripped ? (index_stripped | toggle) :
> > 			((index_stripped + 1) | (toggle ^ 0x4000));
> > 		spin_unlock_irqrestore(&acb->doneq_lock, flags);
> > 		doneq_index = pmu->doneq_index;
> > 		flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
> > 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
> > 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
> > 			ccb_cdb_phy);
> > 		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
> > 			arcmsr_cdb);
> > 		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
> > 		if ((pCCB->acb != acb) ||
> > 			(pCCB->startdone != ARCMSR_CCB_START)) {
> > 			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
> > 				pr_notice("arcmsr%d: scsi id = %d "
> > 					"lun = %d ccb = '0x%p' poll command "
> > 					"abort successfully\n"
> > 					, acb->host->host_no
> > 					, pCCB->pcmd->device->id
> > 					, (u32)pCCB->pcmd->device->lun
> > 					, pCCB);
> > 				pCCB->pcmd->result = DID_ABORT << 16;
> > 				arcmsr_ccb_complete(pCCB);
> > 				continue;
> > 			}
> > 			pr_notice("arcmsr%d: polling an illegal "
> > 				"ccb command done ccb = '0x%p' "
> > 				"ccboutstandingcount = %d\n"
> > 				, acb->host->host_no
> > 				, pCCB
> > 				, atomic_read(&acb->ccboutstandingcount));
> > 			continue;
> > 		}
> > 		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
> > 			? true : false;
> > 		arcmsr_report_ccb_state(acb, pCCB, error);
> > 	}
> > 	return rtn;
> > }
> >
> >
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


