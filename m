From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 9/13] mpt2sas: T10 DIF Support - EEDP
Date: Wed, 15 Apr 2009 15:31:33 -0400
Message-ID: <yq163h5zpbe.fsf@sermon.lab.mkp.net>
References: <20090414043511.GJ20124@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:60000 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZDOTbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 15:31:46 -0400
In-Reply-To: <20090414043511.GJ20124@lsil.com> (Eric Moore's message of "Mon,
	13 Apr 2009 22:35:14 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Eric" == Eric Moore <eric.moore@lsi.com> writes:

Eric,

+_scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
[...]
+	/*
+	 * enable ref/app/guard checking
+	 * auto increment ref tag
+	 */
+	mpi_request->EEDPFlags = eedp_flags |
+	    MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
+	    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
+	    MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG |
+	    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;

How can you check the app tag?


+_scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
[...]
+	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
+		sk = ILLEGAL_REQUEST;
+		host_byte = DID_ABORT;
+	} else {
+		sk = ABORTED_COMMAND;
+		host_byte = DID_OK;
+	}

ILLEGAL REQUEST is used when the HBA detects a mismatch between data and
protection information.  If you are not receiving PI from the OS (WRITE
INSERT) then the HBA can't detect an integrity error.  So in the
DMA_TO_DEVICE case only the target can catch the error (and it will
return ABORTED_COMMAND).

For READ, both the drive firmware and the HBA can ostensibly check that
the data buffers and PI match.

Are your EEDP error flags only set when the HBA firmware detects a
problem or also when the drive returns ABORTED COMMAND/0x10?

I.e. do we get double failure scenarios (both drive and HBA detect the
mismatch)?


+	scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+	    | SHOST_DIF_TYPE3_PROTECTION);

How do you handle Type 3?  The application tag and reference tags are
both defined as being opaque storage for Type 3.

If I understand correctly, your firmware only deals with the Type 2
usage model of the application tag.  And Type 1 + 2 usage of the
reference tag.


+	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);

Technically speaking that is only required for DIX exchange.  But
setting it doesn't hurt.

-- 
Martin K. Petersen	Oracle Linux Engineering

