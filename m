From: Douglas Gilbert <dougg@torque.net>
Subject: Re: question about SG_ ioctls
Date: Thu, 29 Sep 2005 16:01:02 +1000
Message-ID: <433B831E.6040904@torque.net>
References: <21c20ce70509271912142ef77@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:56733 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751191AbVI2GAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 02:00:12 -0400
In-Reply-To: <21c20ce70509271912142ef77@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Parimi <rparimi@gmail.com>
Cc: linux-scsi@vger.kernel.org

Ravi Parimi wrote:
> Hi,
> 
> I have a SCSI controller thats need to be tested for correct
> performance with all the SG_ and SCSI_ ioctls. I've been using the
> sg3_utils package to do this so far. The various programs in sg3_utils
> issue calls to different ioctls depending on the command line
> arguments passed onto them. I would like to have just one program that
> issues calls to a few IOCTLs that I really care about, and want to
> calls to these IOCTLs lined up in a C program like this:
> 
> ===================================================================
>    if ((res = ioctl(sg_fd, SG_GET_VERSION_NUM, &ver) < 0)) {
>       printf("IOCTL SG_GET_VERSION_NUM failed\n");
>       return 1;
>    }
>    printf("SG_GET_VERSION_NUM:\n");
>    printf("\tversion = %d\n", ver);
> 
>    if ((res = ioctl(sg_fd, SCSI_IOCTL_GET_IDLUN, &my_idlun) < 0)) {
>       printf("IOCTL SCSI_IOCTL_GET_IDLUN failed\n");
>       return 1;
>    }
>    printf("SCSI_IOCTL_GET_IDLUN:\n");
>    printf("\tchannel = %d\n\tid = %d\t\n\tlun = %d\n",
>    (my_idlun.dev_id >> 16) & 0xff, my_idlun.dev_id & 0xff,
>    (my_idlun.dev_id >> 8) & 0xff);
> ===================================================================
> 
> I want to know if doing the above is OK?

It looks ok as far as it goes. It doesn't pick up the
host number (SCSI_IOCTL_GET_BUS_NUMBER ioctl) which
may be useful if multiple adapters are involved.

If you are targetting the lk 2.6 series only then the
above information can be derived from sysfs. **

 I do not know if calling
> certain IOCTLs in a specific order has any problems/issues.

No ordering issue. The age of the ioctls is reflected
in the fact that they can only handle 8 bit quantities
(e.g. luns are now 32 bits in linux and 64 ...). There
seems to be a policy of not updating ioctls that are
no longer deemed politically correct.

 Also, if
> the above program reports success for all the IOCTLs called, it is
> safe to assume that the scsi controller is able to handle all IOCTLs
> properly?

No, those ioctls just indicate the sg driver or the block layer
SG_IO handler plus the SCSI mid level are operating. They send
nothing to a low level device driver (LLDD). May I suggest
sending a SCSI INQURY command to a device connected to the
scsi controller. All working SCSI devices should respond
to an INQUIRY without delay. To minimize unpleasant surprises,
set the allocation_length of the INQUIRY command to 36 .


** I intend adding a sg_map26 utility to sg3_utils to map between
a device node name (e.g. /dev/my_scsi_disk) and the corresponding
sg device node name (and vice versa). A similar mapping can be
done within sysfs (e.g. sdc to sg4). As this will use sysfs, then
it won't work in the lk 2.4 series (breaking my sg3_utils policy
somewhat :-) ).

Doug Gilbert
