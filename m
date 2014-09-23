From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V3 01/16] scsi: support well known logical units
Date: Tue, 23 Sep 2014 14:40:03 -0700
Message-ID: <000601cfd776$ef66d3c0$ce347b40$@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org> <1410350063-23267-2-git-send-email-draviv@codeaurora.org> <20140910185839.GA26364@infradead.org> <000f01cfce22$446f79c0$cd4e6d40$@codeaurora.org> <20140913185431.GB30010@infradead.org> <000401cfd364$8fa0bca0$aee235e0$@codeaurora.org> <000301cfd374$7a1afd90$6e50f8b0$@codeaurora.org> <20140922142833.GA1289@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140922142833.GA1289@infradead.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, "'Martin K. Petersen'" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi Chris,

> I don't really know devices exporting wluns by default. The wording in the
latests SPC-4 draft I have says:

That's true. In fact further finding showed me this: UFS device
specification has explicitly mentioned the purpose of SELECT REPORT field
when its set to 00h. When SELECT REPORT field is cleared, device should only
report LUs which support peripheral device addressing method. Even UFS
conformance test specification seems to confirm this explicitly. Hence if
the UFS device adhere the UFS device specification then its expected for
device to not report the W-LUs when SELECT REPORT is 00h.

But I have seen one UFS device vendor specifically reporting w-lus even when
select report is cleared. I am going to follow up them to fix their
behavior. But for now, I guess we are on same page that device shouldn't
report W-LUS when SELECT REPORT field is cleared.


>> For now in this patch, we will skip modifying SELECT REPORT field but 
>> we would still require the other part of this patch for fixing the 
>> scsi_device type to wlun (sdev->type = TYPE_WLUN). Hence we will 
>> change the commit text accordingly to reflect the exact purpose of the
change.

> Yes, please resend this change as a separate patch with an updated
description.  I'd love to merge the whole ufs update for this merge window,
so a timeline resent would be appreciated.

Yes, rest of the part in this patch would still remain applicable with
updated description. We will send it soon along with one more patch in UFS
driver which would manually add scsi_device instance for the UFS W-LUs.

Regards,
Subhash


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of 'Christoph Hellwig'
Sent: Monday, September 22, 2014 7:29 AM
To: Subhash Jadavani
Cc: 'Dolev Raviv'; James.Bottomley@HansenPartnership.com;
linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com; 'Sujit Reddy Thumma';
'Martin K. Petersen'
Subject: Re: [PATCH V3 01/16] scsi: support well known logical units

On Thu, Sep 18, 2014 at 12:12:22PM -0700, Subhash Jadavani wrote:
> Hi Chris,
> 
> While testing with another vendor's UFS devices, I realized that 
> SELECT REPORT need not to be set to 0x02 for making the device report the
W-LUs.
> Even when SELECT REPORT is set 0x00, this particular UFS device 
> reports the W-LUs so I looked at the SCSI specification in details and 
> it seems ideally device should report all the well-known logical units 
> (as it follows the extended logical unit addressing format) when SELECT
REPORT is set 0x00.

I don't really know devices exporting wluns by default. The wording in the
latests SPC-4 draft I have says:

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


Note that the reason I don't like reporting wluns by default is that so far
we haven't come up with a use case for them in either the kernel or generic
userspace.  As long as usage of the wluns you want to support is confirmed
to ufs, which is an unusually rightly coupled implementation of the
initiator and target side I'd like to keep it isolated to ufs.  If we ever
come up with a more generic usage of other wluns we should also report them
during the initial target scan.

> For now in this patch, we will skip modifying SELECT REPORT field but 
> we would still require the other part of this patch for fixing the 
> scsi_device type to wlun (sdev->type = TYPE_WLUN). Hence we will 
> change the commit text accordingly to reflect the exact purpose of the
change.

Yes, please resend this change as a separate patch with an updated
description.  I'd love to merge the whole ufs update for this merge window,
so a timeline resent would be appreciated.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
