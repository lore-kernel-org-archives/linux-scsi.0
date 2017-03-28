From: Stephen Hemminger <sthemmin@microsoft.com>
Subject: RE: [REGRESSION][Stable][v3.12.y][v4.4.y][v4.9.y][v4.10.y][v4.11-rc1]
 scsi: storvsc: properly set residual data length on errors
Date: Tue, 28 Mar 2017 16:14:09 +0000
Message-ID: <BLUPR0301MB2098105B51A887EEBA6EFD90CC320@BLUPR0301MB2098.namprd03.prod.outlook.com>
References: <5df6cd65-92d5-e4c5-56e3-771643f86861@canonical.com>
 <BLUPR0301MB2098AF08A8AFFC22F2B5D67ACC330@BLUPR0301MB2098.namprd03.prod.outlook.com>
 <f8e619e0-d8b6-bd2f-1a92-c52fbc4b5550@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <f8e619e0-d8b6-bd2f-1a92-c52fbc4b5550@canonical.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>, Long Li <longli@microsoft.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

I decided not to send it to stable since problem was only observed on 4.11 but it is probably endemic to all GEN2 VM's

-----Original Message-----
From: Joseph Salisbury [mailto:joseph.salisbury@canonical.com] 
Sent: Tuesday, March 28, 2017 7:29 AM
To: Stephen Hemminger <sthemmin@microsoft.com>; Long Li <longli@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>; Martin K. Petersen <martin.petersen@oracle.com>; Haiyang Zhang <haiyangz@microsoft.com>; jejb@linux.vnet.ibm.com; devel@linuxdriverproject.org; linux-scsi <linux-scsi@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; stable@vger.kernel.org; Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION][Stable][v3.12.y][v4.4.y][v4.9.y][v4.10.y][v4.11-rc1] scsi: storvsc: properly set residual data length on errors

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
Hi Stephen,


Thanks again for pointing out commit
f1c635b439a5c01776fe3a25b1e2dc546ea82e6f.  It does indeed fix the bug. 
I noticed the commit was not cc'd to stable.  Would it be possible to do
that?


Thanks,


Joe
