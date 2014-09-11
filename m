From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Date: Thu, 11 Sep 2014 11:59:10 +0800
Message-ID: <1410407950.4753.18.camel@Centos6.3-64>
References: <1408433122.4748.73.camel@Centos6.3-64>
	 <53FDE490.1070201@redhat.com> <1409240809.4762.259.camel@Centos6.3-64>
	 <53FF2544.8020601@redhat.com> <20140909163057.GA25745@infradead.org>
	 <541020CB.8010302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <541020CB.8010302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Tomas Henzl <thenzl@redhat.com>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-09-10 at 11:58 +0200, Tomas Henzl wrote:
> On 09/09/2014 06:30 PM, Christoph Hellwig wrote:
> > Ching,
> >
> > do you have a chance to address Thomas second concern below?  As
> > far as I can tell (Thomas, please correct me) that's the last
> > outstanding concern, and I'd really like to merge the arcmsr updates
> > for the Linux 3.18 merge window.
> 
> Correct, still awaiting a response.

Christoph, Tomas,

Sorry for the late reply.

I think I misunderstand Tomas' meaning.
The spin lock in arcmsr_hbaD_polling_ccbdone() is necessary to protect doneq_index and have to be modified as following.

static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
				struct CommandControlBlock *poll_ccb)
{
	bool error;
	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
	int rtn, doneq_index, index_stripped, outbound_write_pointer, toggle;
	unsigned long flags;
	struct ARCMSR_CDB *arcmsr_cdb;
	struct CommandControlBlock *pCCB;
	struct MessageUnit_D *pmu = acb->pmuD;

polling_hbaD_ccb_retry:
	poll_count++;
	while (1) {
		spin_lock_irqsave(&acb->doneq_lock, flags);
		outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
		doneq_index = pmu->doneq_index;
		if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {
			spin_unlock_irqrestore(&acb->doneq_lock, flags);
			if (poll_ccb_done) {
				rtn = SUCCESS;
				break;
			} else {
				msleep(25);
				if (poll_count > 40) {
					rtn = FAILED;
					break;
				}
				goto polling_hbaD_ccb_retry;
			}
		}
		toggle = doneq_index & 0x4000;
		index_stripped = (doneq_index & 0xFFF) + 1;
		index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
		pmu->doneq_index = index_stripped ? (index_stripped | toggle) :
			((index_stripped + 1) | (toggle ^ 0x4000));
		spin_unlock_irqrestore(&acb->doneq_lock, flags);
		doneq_index = pmu->doneq_index;
		flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
			ccb_cdb_phy);
		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
			arcmsr_cdb);
		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
		if ((pCCB->acb != acb) ||
			(pCCB->startdone != ARCMSR_CCB_START)) {
			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
				pr_notice("arcmsr%d: scsi id = %d "
					"lun = %d ccb = '0x%p' poll command "
					"abort successfully\n"
					, acb->host->host_no
					, pCCB->pcmd->device->id
					, (u32)pCCB->pcmd->device->lun
					, pCCB);
				pCCB->pcmd->result = DID_ABORT << 16;
				arcmsr_ccb_complete(pCCB);
				continue;
			}
			pr_notice("arcmsr%d: polling an illegal "
				"ccb command done ccb = '0x%p' "
				"ccboutstandingcount = %d\n"
				, acb->host->host_no
				, pCCB
				, atomic_read(&acb->ccboutstandingcount));
			continue;
		}
		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
			? true : false;
		arcmsr_report_ccb_state(acb, pCCB, error);
	}
	return rtn;
}


> 
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
