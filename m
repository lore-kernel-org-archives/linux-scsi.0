From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [dm-devel] failover does not work with rdac device handler
Date: Mon, 06 Oct 2008 12:53:37 -0700
Message-ID: <1223322817.14830.593.camel@chandra-ubuntu>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>
	 ,<1223081419.14830.585.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BB949D3@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBCCF2@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:44281 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYJFTya (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 15:54:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m96JsTRV019340
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 15:54:29 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m96JsS37178260
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 13:54:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m96JrvX6020047
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 13:53:59 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BBBCCF2@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Is this the only rdac device that is present ?

Can you also get me the o/p of "lsmod | grep scsi_dh_rdac" (just wanted
to make sure if each (SCSI) device has a module.

On Mon, 2008-10-06 at 13:26 -0600, Moger, Babu wrote:
> Hi Chandra,
> 
> All the dh_state values show "rdac".  I have cut pasted the output below.
> 
> I am seeing the following error messages when I tried to failover.
> 
>         Oct  6 13:50:01 localhost multipathd: 8:96: reinstated
>         Oct  6 13:50:01 localhost kernel: device-mapper: multipath: Cannot              failover device because scsi_dh_rdac was not loaded.
>         Oct  6 13:50:01 localhost kernel: device-mapper: multipath: Failing             path 8:96.
>         Oct  6 13:50:01 localhost kernel: device-mapper: multipath: Could not           failover device. Error 15.
>         Oct  6 13:50:01 localhost multipathd: 8:96: mark as failed
> 
> 
> Output of # multipath -ll
> 
>         mpath2 (3600a0b80000f6a7d000080454714d058) dm-2 LSI,INF-01-00
>         [size=10G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
>         \_ round-robin 0 [prio=6][active]
>          \_ 3:0:0:2 sdf 8:80  [active][ready]
>          \_ 3:0:2:2 sdl 8:176 [active][ready]
>         \_ round-robin 0 [prio=0][enabled]
>          \_ 3:0:1:2 sdi 8:128 [active][ghost]
>          \_ 3:0:3:2 sdo 8:224 [active][ghost]
> 
> 
> dh_state values.
> 
>         #cat /sys/block/sdf/device/dh_state
>         rdac
> 
>         #cat /sys/block/sdl/device/dh_state
>         rdac
> 
>         #cat /sys/block/sdi/device/dh_state
>         rdac
> 
>         # cat /sys/block/sdo/device/dh_state
>         rdac
> 
>  Please let me know what you think.
>  Note (Kernel version 2.6.27-rc7 and multipath-tools v0.4.8)
> 
> Thanks
> Babu Moger
> 
> -----Original Message-----
> From: Moger, Babu
> Sent: Friday, October 03, 2008 10:35 PM
> To: sekharan@us.ibm.com
> Cc: device-mapper development; linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] failover does not work with rdac device handler
> 
> Thanks Chandra for the response..
> 
> That is the good news. So, we do not have to change the kernel  code everytime we want to support the new product.
> 
> I will do the steps you mentioned first thing on Monday and reply your back.
> 
> Thanks
> Babu Moger
> 
> ________________________________________
> From: Chandra Seetharaman [sekharan@us.ibm.com]
> Sent: Friday, October 03, 2008 7:50 PM
> To: Moger, Babu
> Cc: device-mapper development; linux-scsi@vger.kernel.org
> Subject: Re: [dm-devel] failover does not work with rdac device handler
> 
> It is supposed to work. I will look into it and respond.
> 
> Can you try one thing
> 
> for all your devices, do
>         echo rdac > /sys/block/sd?/dh_state
> 
> (first you can read the files and see if they all show rdac or not)
> 
> and then do your fail over. Let me know what happens.
> 
> chandra
> On Fri, 2008-10-03 at 18:12 -0600, Moger, Babu wrote:
> > Hi,
> >
> > I have quick question.
> >
> > I am trying to configure device mapper for my FC array (on my Linux box). I have passed all the arguments from /etc/multipath.conf(like vendor, model etc ..).
> >
> > Discovery seems fine. But, failover is not working.  I am seeing the following error.
> >
> > "device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded."
> >
> > Is it required to add vendor id and model id anywhere else to support this device?
> >
> > Thanks
> > Babu Moger
> >
> >
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Moger, Babu
> > Sent: Wednesday, October 01, 2008 4:48 PM
> > To: device-mapper development; linux-scsi@vger.kernel.org
> > Subject: [dm-devel] failover does not work with rdac device handler
> >
> > Hi All,
> >
> > I am new to the device mapper and just thought I will set-up device mapper on our arrays. I am using the latest kernel 2.6.27.rc6 and got the latest multipath-tools from upstream.
> >
> > I updated /etc/multipath.conf with all the information (vendor, product, hardware_handler, prio etc  ...). Note that my device is not part of rdac_dev_list.
> >
> > Discovery worked fine. "multipath -ll" displays all the information. I can see that it is picking up rdac device handler.
> >
> > But I found that for some reason failover/failback is not working.  I am seeing following these messages.
> >
> > "device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded."
> >
> > I can see that scsi_dh_rdac driver is already loaded.
> >
> > I did some more investigation. Found that failover works fine if I add vendor, model in rdac_dev_list (in file scsi_dh_rdac.c).
> >
> > My question - is it required to add all the supported vendor and model names in rdac_dev_list?
> >
> > Appreciate your responses.
> >
> > Thanks
> > Babu Moger
> >
> >
> >
> >
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

