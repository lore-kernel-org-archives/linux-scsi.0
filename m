From: John Washer <johnkwasher@gmail.com>
Subject: Re: scsi:sd: provisioning_mode not being set to unmap
Date: Wed, 31 Oct 2012 21:53:56 +0900
Message-ID: <CADHvswCsbOEosYsvOU7hA6bDdN=NRxYu5B_QHe05US3d6Ftcdg@mail.gmail.com>
References: <CADHvswAnKx7COQrtnXp7LTmRP2euC0xortkcd2+HgwAxUc3-Rw@mail.gmail.com>
	<yq1r4og8vjl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54664 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2JaMx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 08:53:57 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so1352585obb.19
        for <linux-scsi@vger.kernel.org>; Wed, 31 Oct 2012 05:53:56 -0700 (PDT)
In-Reply-To: <yq1r4og8vjl.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com

The culprit was VPD page 0. Inquiry on VPD page 0 wasn't returning
0xb0 as one of the supported pages.
So, the *scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))* was
failing. Corrected VPD page 0 response.
Now everything works as expected... :-)

Thanks anyway...

-John

On Tue, Oct 30, 2012 at 12:53 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "John" == John Washer <johnkwasher@gmail.com> writes:
>
> John> Provisioning mode is not being set to "unmap" even though it seems
> John> that device firmware provides all the required information to SD.
>
> I instrumented scsi_debug to provide the same values as your device
> (LBPME=1, identical Block Limits VPD, no LBP VPD) and we end up choosing
> unmap. So I'm not sure what's going on in your case. Which kernel are
> you using?
>
>
> John> 3. The device does not support VPD 0xb2.
> John> $ sudo sg_vpd  -p 0xb2 /dev/sg1
> John> VPD page=0xb2
> John> fetching VPD page failed
>
> FWIW, the Logical Block Provisioning VPD page is now mandatory.
>
>
> John> But when I check the "/sys.../provisioning_mode" it is set to
> John> Write Same 16.
>
> What happens if you override it by writing "unmap" to that file?
>
> --
> Martin K. Petersen      Oracle Linux Engineering
