From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V5 02/17] scsi: sysfs: don't add scsi_device if its already added
Date: Wed, 24 Sep 2014 09:27:47 -0700
Message-ID: <000f01cfd814$7a6be2b0$6f43a810$@codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org> <1411571653-22729-3-git-send-email-draviv@codeaurora.org> <20140924160825.GB13541@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140924160825.GB13541@infradead.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, 'Dolev Raviv' <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com
List-Id: linux-scsi@vger.kernel.org

>> If LLD has added scsi device (by calling scsi_add_device) before 
>> scheduling async scsi_scan_host then scsi_finish_async_scan() will end 
>> up calling scsi_sysfs_add_sdev for scsi device which was already added by
LLD.
>> This patch fixes this issue by adding a check at the start of
>> scsi_sysfs_add_sdev() to skip the device add if it's already visible 
>> to rest of the kernel.
>
> This looks wrong to me.   I guess this happens for the case where you
> added the well known lun explicitly, and then have one of the devices that
also report it from REPORT LUNS?  I guess the right answer is to explicitly
ignore wluns in scsi_report_lun_scan.

No, It happens in this sequence of events:
1. LLD calls the __scsi_add_device() for well known logical units before
scsi_scan_host() (This is done as part of [PATCH V5 10/17] scsi: ufs:
manually add well known logical units). __scsi_add_device() will also add
the scsi device to sysfs by calling scsi_sysfs_add_sdev()
2. Now LDD calls the scsi_scan_host() (Note that CONFIG_SCSI_SCAN_ASYNC is
enabled) which will schedule the async scan. Device reports only normal LUs
(no w-lus reported here) when REPORT LUNs in sent with SELECT REPORT
cleared. At the end of async scan, scsi_finish_async_scan() calls
scsi_sysfs_add_devices(). scsi_sysfs_add_devices() iterates through all the
scsi_device instances attached to Scsi_Host hence end up calling
scsi_sysfs_add_sdev() 2nd time for the scsi_device which were already added
explicitly by LDD.


BTW, none of the UFS devices are reporting the W-LUs when SELECT REPORT is
cleared. I was confused with the crash (which is fixed by this patch) seen
with scenario mentioned above and thought that REPORT LUNs (with SELECT
REPORT=00h) is reporting W-LUs as well but I confirmed that that's not the
case with any of the UFS device vendors.


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Wednesday, September 24, 2014 9:08 AM
To: Dolev Raviv
Cc: James.Bottomley@HansenPartnership.com; hch@infradead.org;
linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com; Subhash Jadavani
Subject: Re: [PATCH V5 02/17] scsi: sysfs: don't add scsi_device if its
already added

On Wed, Sep 24, 2014 at 06:13:58PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> If LLD has added scsi device (by calling scsi_add_device) before 
> scheduling async scsi_scan_host then scsi_finish_async_scan() will end 
> up calling scsi_sysfs_add_sdev for scsi device which was already added by
LLD.
> This patch fixes this issue by adding a check at the start of
> scsi_sysfs_add_sdev() to skip the device add if it's already visible 
> to rest of the kernel.

This looks wrong to me.   I guess this happens for the case where you
added the well known lun explicitly, and then have one of the devices that
also report it from REPORT LUNS?  I guess the right answer is to explicitly
ignore wluns in scsi_report_lun_scan.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
