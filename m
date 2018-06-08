From: "sayali" <sayalil@codeaurora.org>
Subject: RE: [PATCH V1 3/3] scsi: ufs: Add sysfs support for ufs provision
Date: Fri, 8 Jun 2018 16:25:45 +0530
Message-ID: <000401d3ff17$4496a390$cdc3eab0$@codeaurora.org>
References: <1527849774-7623-1-git-send-email-sayalil@codeaurora.org> <1527849774-7623-4-git-send-email-sayalil@codeaurora.org> <MWHPR04MB113794E2654BEDA8E927F0FC9A660@MWHPR04MB1137.namprd04.prod.outlook.com> <20180605084200.GB8665@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180605084200.GB8665@kroah.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>, 'Stanislav Nijnikov' <Stanislav.Nijnikov@wdc.com>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, 'Bart Van Assche' <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, 'Adrian Hunter' <adrian.hunter@intel.com>, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Greg / Stanislav,

Thank you for your comments. 
Updated my comments inline. Please check.

Thanks,
Sayali
-----Original Message-----
From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, June 05, 2018 2:12 PM
To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: Sayali Lokhande <sayalil@codeaurora.org>; subhashj@codeaurora.org;
cang@codeaurora.org; vivek.gautam@codeaurora.org; rnayak@codeaurora.org;
vinholikatti@gmail.com; jejb@linux.vnet.ibm.com; martin.petersen@oracle.com;
asutoshd@codeaurora.org; evgreen@chromium.org; Bart Van Assche
<Bart.VanAssche@wdc.com>; linux-scsi@vger.kernel.org; Adrian Hunter
<adrian.hunter@intel.com>; open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 3/3] scsi: ufs: Add sysfs support for ufs provision

On Tue, Jun 05, 2018 at 08:16:50AM +0000, Stanislav Nijnikov wrote:
> Hi Sayali,
> 
> I think that passing an array of values in a string is not proper way 
> to work with a sysfs entry. There are binary attributes to do such 
> things.

No, don't do that, sysfs is for "one value per file", and binary attributes
are for "hardware value pass-through" type stuff.  Unless this is "raw" data
straight from the hardware, binary does not work, and neither does a normal
sysfs file either.

So this needs to be reworked please.

[Sayali] As per Documentation/filesystems/sysfs.txt :
	"Attributes should be ASCII text files, preferably with only one
value per file. It is noted that it may not be efficient to contain only one
value per file, 	so it is socially acceptable to express an array of
values of the same type."
	So it seems sysfs can be used to pass more than one value given that
they are of same type (which is ensured as I am passing char string).
	Also I have noticed , in scsi_sysfs.c (store_scan() or scsi_scan()),
we do pass char buffer (more than one value) via sysfs .
	As sysfs is already being used to read descriptors, I thought of
using sysfs as write interface for configuration descriptor.
	Appreciate, if you could suggest me some other interfaces that can
be used here (allow passing more than one value) or
	do you think I need to pass each configurable parameter one by one
for provisioning ?

thanks,

greg k-h
