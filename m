From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Tue, 17 Jan 2017 10:20:25 +0100
Message-ID: <20170117092025.GA9337@gmail.com>
References: <20161229080250.GA11605@infradead.org>
 <1483226343.2518.32.camel@linux.vnet.ibm.com>
 <1483280506.5512.1.camel@sandisk.com>
 <20170101.113311.417107391370623850.davem@davemloft.net>
 <1483292364.2345.5.camel@linux.vnet.ibm.com>
 <yq1y3ypgd7m.fsf@oracle.com>
 <1484596878.2540.58.camel@HansenPartnership.com>
 <yq14m0ylnx1.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq14m0ylnx1.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, David Miller <davem@davemloft.net>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, jbaron@akamai.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, sagi@grimberg.me, Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, dledford@redhat.com, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org


* Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> Subject: [PATCH] scsi: mpt3sas: fix hang on ata passthrough
> James> commands
> 
> James> mpt3sas has a firmware failure where it can only handle one pass
> James> through ATA command at a time.  If another comes in, contrary to
> James> the SAT standard, it will hang until the first one completes
> James> (causing long commands like secure erase to timeout).  The
> James> original fix was to block the device when an ATA command came in,
> James> but this caused a regression with
> 
> Broadcom folks: Please test and ack as soon as possible so we can get
> this fix queued up.
> 
> Ingo: Since you appear to have hardware, it would be great if you could
> test James' v3 (https://patchwork.kernel.org/patch/9519383/). Sorry for
> the inconvenience.

As per the interdiff below v2->v3 did not change the code in any way, only the 
name of the function and a comment, so you can add this to v3 as well:

  Reported-by: Ingo Molnar <mingo@kernel.org>
  Tested-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6f9b4c051e4d..830e2c10ba02 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3899,7 +3899,7 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
-static int set_satl_pending(struct scsi_cmnd *scmd, bool pending)
+static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 {
 	struct MPT3SAS_DEVICE *priv = scmd->device->hostdata;
 
@@ -3934,7 +3934,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
-		set_satl_pending(scmd, false);
+		_scsih_set_satl_pending(scmd, false);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -4084,7 +4084,9 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	}
 
 	/*
-	 * Bug work around for firmware SATL handling
+	 * Bug work around for firmware SATL handling.  The loop
+	 * is based on atomic operations and ensures consistency
+	 * since we're lockless at this point
 	 */
 	do {
 		if (sas_device_priv_data->ata_command_pending) {
@@ -4092,7 +4094,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 			scmd->scsi_done(scmd);
 			return 0;
 		}
-	} while (set_satl_pending(scmd, true));
+	} while (_scsih_set_satl_pending(scmd, true));
 
 	sas_target_priv_data = sas_device_priv_data->sas_target;
 
@@ -4661,7 +4663,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
-	set_satl_pending(scmd, false);
+	_scsih_set_satl_pending(scmd, false);
 
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
