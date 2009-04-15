From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 9/13] mpt2sas: T10 DIF Support - EEDP
Date: Wed, 15 Apr 2009 14:07:34 -0600
Message-ID: <660360F4F2570145BD872F298951B17A76B5F1A5@cosmail03.lsi.com>
References: <yq163h5zpbe.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:51922 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbZDOUHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 16:07:50 -0400
In-Reply-To: <yq163h5zpbe.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wednesday, April 15, 2009 1:32 PM,  Martin K. Petersen  wrote:
> 
> +_scsih_setup_eedp(struct scsi_cmnd *scmd, 
> Mpi2SCSIIORequest_t *mpi_request)
> [...]
> +	/*
> +	 * enable ref/app/guard checking
> +	 * auto increment ref tag
> +	 */
> +	mpi_request->EEDPFlags = eedp_flags |
> +	    MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
> +	    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
> +	    MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG |
> +	    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
> 
> How can you check the app tag?

The SAS controller firmware checks the tags, not device driver.   What this code is doing is setting flags in the SCSI_IO Request message that is being sent to controller firmware.

> 
> 
> +_scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
> [...]
> +	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
> +		sk = ILLEGAL_REQUEST;
> +		host_byte = DID_ABORT;
> +	} else {
> +		sk = ABORTED_COMMAND;
> +		host_byte = DID_OK;
> +	}
> 
> ILLEGAL REQUEST is used when the HBA detects a mismatch 
> between data and
> protection information.  If you are not receiving PI from the 
> OS (WRITE
> INSERT) then the HBA can't detect an integrity error.  So in the
> DMA_TO_DEVICE case only the target can catch the error (and it will
> return ABORTED_COMMAND).
> 

Your right.

> For READ, both the drive firmware and the HBA can ostensibly 
> check that
> the data buffers and PI match.
> 
> Are your EEDP error flags only set when the HBA firmware detects a
> problem or also when the drive returns ABORTED COMMAND/0x10?

I wrote is a generic function based on chapter 3.3 in your linux-hba.pdf doc found at http://oss.oracle.com/projects/data-integrity/dist/documentation/linux-hba.pdf.

Obviously the only errors the current implementation will only be flaged on READs.   

My line of thinking was I write the code so it won't need to be rewrote later when DIX support is added for SAS3.0. 

> 
> I.e. do we get double failure scenarios (both drive and HBA detect the
> mismatch)?

Yes, I was told by the LSI  software test lab, they saw drives returning check condition with these ref tag errors.  I wasn't able to repro that.   What I saw were the IOCSTATUS errors, which is what the code handles in _scsih_eedp_error_handling().   Either way, both cases are covered right?

I have a 3gb SAS drive with EEDP support, model HITACHI HUS153073VLS300.  This support type 1 and 2.

I also EEDP support for target mode driver for this 6gb part, type 1, 2, and 3.

I used both to test the driver.

> 
> 
> +	scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
> +	    | SHOST_DIF_TYPE3_PROTECTION);
> 
> How do you handle Type 3?  The application tag and reference tags are
> both defined as being opaque storage for Type 3.

Yeah I know that.    Since its app tag, it can be set to anything you want it to be.  For our internal implementation of type 3 DIF, I'm setting the lower 32bit part of the tag to the lba.  I was able to test this with a type 3 target, and it work fine.

> 
> If I understand correctly, your firmware only deals with the Type 2
> usage model of the application tag.  And Type 1 + 2 usage of the
> reference tag.
> 

Our controller firmware support all three types of protection.. 


> 
> +	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
> 
> Technically speaking that is only required for DIX exchange.  But
> setting it doesn't hurt.

I wasn't sure whether it needed to be set.    Our controller generates the CRC. I'm not sure whether firmware or hardware implementation.  

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 
> 