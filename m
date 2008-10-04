From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] failover does not work with rdac device handler
Date: Fri, 03 Oct 2008 17:50:19 -0700
Message-ID: <1223081419.14830.585.camel@chandra-ubuntu>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49945 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYJDAvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 20:51:09 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m940p7dP021493
	for <linux-scsi@vger.kernel.org>; Fri, 3 Oct 2008 20:51:07 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m940p7oa101876
	for <linux-scsi@vger.kernel.org>; Fri, 3 Oct 2008 18:51:07 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m940obwo017281
	for <linux-scsi@vger.kernel.org>; Fri, 3 Oct 2008 18:50:38 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

It is supposed to work. I will look into it and respond.

Can you try one thing 

for all your devices, do
	echo rdac > /sys/block/sd?/dh_state

(first you can read the files and see if they all show rdac or not)

and then do your fail over. Let me know what happens.

chandra
On Fri, 2008-10-03 at 18:12 -0600, Moger, Babu wrote:
> Hi,
> 
> I have quick question.
> 
> I am trying to configure device mapper for my FC array (on my Linux box). I have passed all the arguments from /etc/multipath.conf(like vendor, model etc ..).
> 
> Discovery seems fine. But, failover is not working.  I am seeing the following error.
> 
> "device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded."
> 
> Is it required to add vendor id and model id anywhere else to support this device?
> 
> Thanks
> Babu Moger
> 
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Moger, Babu
> Sent: Wednesday, October 01, 2008 4:48 PM
> To: device-mapper development; linux-scsi@vger.kernel.org
> Subject: [dm-devel] failover does not work with rdac device handler
> 
> Hi All,
> 
> I am new to the device mapper and just thought I will set-up device mapper on our arrays. I am using the latest kernel 2.6.27.rc6 and got the latest multipath-tools from upstream.
> 
> I updated /etc/multipath.conf with all the information (vendor, product, hardware_handler, prio etc  ...). Note that my device is not part of rdac_dev_list.
> 
> Discovery worked fine. "multipath -ll" displays all the information. I can see that it is picking up rdac device handler.
> 
> But I found that for some reason failover/failback is not working.  I am seeing following these messages.
> 
> "device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded."
> 
> I can see that scsi_dh_rdac driver is already loaded.
> 
> I did some more investigation. Found that failover works fine if I add vendor, model in rdac_dev_list (in file scsi_dh_rdac.c).
> 
> My question - is it required to add all the supported vendor and model names in rdac_dev_list?
> 
> Appreciate your responses.
> 
> Thanks
> Babu Moger
> 
> 
> 
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

