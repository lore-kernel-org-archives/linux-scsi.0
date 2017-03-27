From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: [REGRESSION][v3.12.y][v4.4.y][v4.9.y][v4.10.y][v4.11-rc1]
 scsi: storvsc: properly set residual data length on errors
Date: Mon, 27 Mar 2017 18:25:40 -0400
Message-ID: <4b82a87c-4ee7-f653-8ca0-2f179abc17f8@canonical.com>
References: <5df6cd65-92d5-e4c5-56e3-771643f86861@canonical.com>
 <BLUPR0301MB2098AF08A8AFFC22F2B5D67ACC330@BLUPR0301MB2098.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <BLUPR0301MB2098AF08A8AFFC22F2B5D67ACC330@BLUPR0301MB2098.namprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Stephen Hemminger <sthemmin@microsoft.com>, Long Li <longli@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On 03/27/2017 06:14 PM, Stephen Hemminger wrote:
> Are you sure the real problem is not the one fixed by this commit?
>
> commit f1c635b439a5c01776fe3a25b1e2dc546ea82e6f
> Author: Stephen Hemminger <stephen@networkplumber.org>
> Date:   Tue Mar 7 09:15:53 2017 -0800
>
>     scsi: storvsc: Workaround for virtual DVD SCSI version
>     
>     Hyper-V host emulation of SCSI for virtual DVD device reports SCSI
>     version 0 (UNKNOWN) but is still capable of supporting REPORTLUN.
>     
>     Without this patch, a GEN2 Linux guest on Hyper-V will not boot 4.11
>     successfully with virtual DVD ROM device. What happens is that the SCSI
>     scan process falls back to doing sequential probing by INQUIRY.  But the
>     storvsc driver has a previous workaround that masks/blocks all errors
>     reports from INQUIRY (or MODE_SENSE) commands.  This workaround causes
>     the scan to then populate a full set of bogus LUN's on the target and
>     then sends kernel spinning off into a death spiral doing block reads on
>     the non-existent LUNs.
>     
>     By setting the correct blacklist flags, the target with the DVD device
>     is scanned with REPORTLUN and that works correctly.
>     
>     Patch needs to go in current 4.11, it is safe but not necessary in older
>     kernels.
>     
>     Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>     Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
>     Reviewed-by: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> -----Original Message-----
> From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com] 
> Sent: Monday, March 27, 2017 1:22 PM
> To: Long Li <longli@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Martin K. Petersen <martin.petersen@oracle.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>; jejb@linux.vnet.ibm.com; devel@linuxdriverproject.org; linux-scsi <linux-scsi@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; stable@vger.kernel.org; Greg KH <gregkh@linuxfoundation.org>
> Subject: [REGRESSION][Stable][v3.12.y][v4.4.y][v4.9.y][v4.10.y][v4.11-rc1] scsi: storvsc: properly set residual data length on errors
>
> Hi Long Li,
>
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:
>
> commit 40630f462824ee24bc00d692865c86c3828094e0
> Author: Long Li <longli@microsoft.com>
> Date:   Wed Dec 14 18:46:03 2016 -0800
>
>     scsi: storvsc: properly set residual data length on errors
>
>
> The regression was introduced in mainline as of v4.11-rc1.  It was also
> cc'd to stable and has landed in v3.12.y, v4.4.y, v4.9.y and v4.10.y.
>
>
> This regression seems pretty severe since it's preventing virtual
> machines from booting.  It's affecting a couple of users so far.  I was
> hoping to get your feedback, since you are the patch author.  Do you
> think gathering any additional data will help diagnose this issue, or
> would it be best to submit a revert request?
>
>
> Thanks,
>
> Joe
>
>
> [0] http://pad.lv/1674635
>
>
Thanks for the pointer, Stephen.  I'll have this patch tested and
respond with the results.


Joe
