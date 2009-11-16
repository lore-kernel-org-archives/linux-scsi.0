From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas : Enable TLR for SSP TAPE drives
Date: Mon, 16 Nov 2009 17:32:56 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C7481E@inbmail01.lsi.com>
References: <20091113082620.GB18271@lsi.com>
 <1258124030.4065.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:46804 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbZKPMDD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2009 07:03:03 -0500
In-Reply-To: <1258124030.4065.11.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@suse.de]
> Sent: Friday, November 13, 2009 8:24 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
> Subject: Re: [PATCH] mpt2sas : Enable TLR for SSP TAPE drives
> 
> On Fri, 2009-11-13 at 13:56 +0530, Kashyap, Desai wrote:
> > The driver is sending vpd page 0, to get a list of supported pages. Then
> it
> > will traverse the list searching for page 0x90. when page 0x90 is
> present,
> > the driver will enable the TLR logic for Tape devices only.  The TLR
> logic
> > will enable the TLR bits in the SCSI_IO for every request. If there is a
> > response with MPI2_SCSITASKMGMT_RSP_INVALID_FRAME, the driver will turn
> off
> > the TLR logic.
> 
> This is applicable to all SAS drivers, isn't it?  So it should be in the
> sas transport class and we should be figuring out how to add it to all
> SAS drivers, shouldn't we?
> 
> James
> 
Agree. Nice to have it in transport layer. In that case, we have to add *tlr_enabled* field in *struct scsi_device*.
Currently we are using "sdev->hostdata" to store tlr flags.(this can be replaced by above proposed field in scs_device)

We can add functions like 

/*Enable*/  Void sas_enable_tlr(struct scsi_device *sdev)
/*Disable*/ Void sas_disable_tlr(struct scsi_device *sdev)
/*Check*/   int  sas_check_tlr(struct scsi_device *sdev)

Caller can take care of checking IOC capabilities of supporting TLR at HBA level and they can call sas_enable_tlr to enable TLR for particular drive.

Suggestion?

Kashyap


