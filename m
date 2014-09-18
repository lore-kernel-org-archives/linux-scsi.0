From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V3 01/16] scsi: support well known logical units
Date: Thu, 18 Sep 2014 10:18:26 -0700
Message-ID: <000401cfd364$8fa0bca0$aee235e0$@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org> <1410350063-23267-2-git-send-email-draviv@codeaurora.org> <20140910185839.GA26364@infradead.org> <000f01cfce22$446f79c0$cd4e6d40$@codeaurora.org> <20140913185431.GB30010@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140913185431.GB30010@infradead.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, "'Martin K. Petersen'" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> If those are the only LUs you specificly need I'd suggest you just
manually call scsi_add_device from your driver for those instead of listing
them in REPORT_LUNS and making them part of the normal LUN scan. 

Yes, we can do that but not sure what would be advantage of making the LLDs
to add these ad-hoc hooks instead of scsi_scan handle it on its own and
leaving the LLDs from adding them explicitly? Do you foresee any issues
(other than few extra scsi_device instances which may not be useful all scsi
devices) with scsi_scan scanning all the LUs (including well known LUs)?

Regards,
Subhash

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of 'Christoph Hellwig'
Sent: Saturday, September 13, 2014 11:55 AM
To: Subhash Jadavani
Cc: 'Christoph Hellwig'; 'Dolev Raviv';
James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org;
linux-scsi-owner@vger.kernel.org; linux-arm-msm@vger.kernel.org;
santoshsy@gmail.com; 'Sujit Reddy Thumma'; 'Martin K. Petersen'
Subject: Re: [PATCH V3 01/16] scsi: support well known logical units

On Thu, Sep 11, 2014 at 05:41:18PM -0700, Subhash Jadavani wrote:
> 
> UFS device has supports 4 different well known logical units:
"REPORT_LUNS"
> (address: 01h), "UFS Device" (address: 50h), "RPMB" (address: 44h) and 
> "BOOT" (address: 30h).
> 
> UFS device's power management needs to be controlled by "POWER CONDITION"
> field of SSU (START STOP UNIT) command. But this "power condition"  
> field will take effect only when its sent to "UFS device" well known 
> logical unit
> (address: 50h) hence we require the scsi_device instance to represent 
> this logical unit in order for the UFS host driver to send the SSU 
> command for power management.
> 
> We also require the scsi_device instance for "RPMB" (Replay Protected 
> Memory
> Block) LU so user space process can control this LU.

If those are the only LUs you specificly need I'd suggest you just manually
call scsi_add_device from your driver for those instead of listing them in
REPORT_LUNS and making them part of the normal LUN scan.  One advantage of
the well known LUNs is that you always know where in the LUN namespace they
are :)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
