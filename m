From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH V6 10/18] scsi: ufs: manually add well known logical units
Date: Sun, 5 Oct 2014 16:31:01 +0900
Message-ID: <CAC5umyjwu-v_Zgs3PdMyoW+zHJ_h3BxXyp3uZOWiAfnY3+2YnQ@mail.gmail.com>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
	<1411648356-3883-11-git-send-email-draviv@codeaurora.org>
	<CAC5umyhYko5woZhkroi3zm4ow8qp=DeCX62hcr0n3oxw4w8fjw@mail.gmail.com>
	<20141003163534.GA25051@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20141003163534.GA25051@infradead.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dolev Raviv <draviv@codeaurora.org>, Jej B <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

2014-10-04 1:35 GMT+09:00 Christoph Hellwig <hch@infradead.org>:
> On Sat, Oct 04, 2014 at 01:16:16AM +0900, Akinobu Mita wrote:
>> These __scsi_add_device() calls for W-LUs increase the module reference
>> count of ufshcd.ko by three.  But no one calls scsi_device_put() for
>> these W-LUs, so it is impossible to unload ufshcd.ko.
>>
>> There are scsi_remove_device() calls for W-LUs in ufshcd_scsi_remove_wlus(),
>> But these calls do nothing (please see a comment below).
>>
>> I could fix this issue by putting scsi_device_put() just after each
>> __scsi_add_device() call.  I'll prepare a patch if I haven't missed
>> something.
>
>
>> When ufshcd_scsi_remove_wlus() is called in ufshcd_remove(), these
>> three W-LU devices have already been deleted by scsi_remove_host() which
>> is called just before ufshcd_scsi_remove_wlus().  The scsi
>> device state of these W-LU devices is SDEV_DEL at this time, and
>> scsi_remove_device() does nothing.
>
>
> No, we need to keep a reference to avoid them going away due to a manual
> delete.  We need a scsi_device_put where we currently call
> scsi_remove_device I guess.

This also works for now.  But there is a concern.

In the previous email, I said that __scsi_add_device() calls for W-LUs
increase the module reference count of ufshcd.ko by three.  But the
module reference count of ufshcd-pci.ko (or ufshcd-pltfrm.ko) should be
increased instead of ufshcd.ko.  Because ufshcd.ko is core driver and
it just provides library function for the actual LLD (ufshcd-pci.ko and
ufshcd-pltfrm.ko).

Once this problem is fixed (by setting correct ufshcd_driver_template.module
or else way), it is impossible to unload ufshcd-pci.ko (or
ufshcd-pltfrm.ko).

So the fix I proposed in the previous email plus additional work to
avoid breakage with manual delete of W-LUs (specifically, correct mutal
exclusion for hba->sdev_ufs_device accesses from ufshcd_slave_destroy()
and from ufshcd_set_dev_pwr_mode()) is acceptable?
