From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH V3 01/16] scsi: support well known logical units
Date: Mon, 22 Sep 2014 07:28:33 -0700
Message-ID: <20140922142833.GA1289@infradead.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
 <1410350063-23267-2-git-send-email-draviv@codeaurora.org>
 <20140910185839.GA26364@infradead.org>
 <000f01cfce22$446f79c0$cd4e6d40$@codeaurora.org>
 <20140913185431.GB30010@infradead.org>
 <000401cfd364$8fa0bca0$aee235e0$@codeaurora.org>
 <000301cfd374$7a1afd90$6e50f8b0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000301cfd374$7a1afd90$6e50f8b0$@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, "'Martin K. Petersen'" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 18, 2014 at 12:12:22PM -0700, Subhash Jadavani wrote:
> Hi Chris,
> 
> While testing with another vendor's UFS devices, I realized that SELECT
> REPORT need not to be set to 0x02 for making the device report the W-LUs.
> Even when SELECT REPORT is set 0x00, this particular UFS device reports the
> W-LUs so I looked at the SCSI specification in details and it seems ideally
> device should report all the well-known logical units (as it follows the
> extended logical unit addressing format) when SELECT REPORT is set 0x00.

I don't really know devices exporting wluns by default. The wording in
the latests SPC-4 draft I have says:

00h	The list shall contain the logical units accessible to the I_T nexus
	with the following addressing methods (see SAM-4):
	  a) Logical unit addressing method,
	  b) Peripheral device addressing method; and
	  c) Flat space addressing method.
	If there are no logical units, the LUN LIST LENGTH field shall be
	zero.
01h	The list shall contain only well known logical units, if any.
	If there are no well known logical units, the LUN LIST LENGTH field
	shall be zero.
02h The list shall contain all logical units accessible to the I_T nexus.


SAM-4 defines WLUNs as their own addressing format in 4.6.11:

Well known logical units are addressed using the well known logical unit
extended address format (see table 28).


Note that the reason I don't like reporting wluns by default is that
so far we haven't come up with a use case for them in either the
kernel or generic userspace.  As long as usage of the wluns you want
to support is confirmed to ufs, which is an unusually rightly coupled
implementation of the initiator and target side I'd like to keep it
isolated to ufs.  If we ever come up with a more generic usage of
other wluns we should also report them during the initial target scan.

> For now in this patch, we will skip modifying SELECT REPORT field but we
> would still require the other part of this patch for fixing the scsi_device
> type to wlun (sdev->type = TYPE_WLUN). Hence we will change the commit text
> accordingly to reflect the exact purpose of the change.

Yes, please resend this change as a separate patch with an updated
description.  I'd love to merge the whole ufs update for this merge
window, so a timeline resent would be appreciated.
