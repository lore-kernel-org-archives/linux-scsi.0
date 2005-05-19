From: Pg <pg@atlavia.it>
Subject: Re: megaraid Error 40005 on cluster
Date: Thu, 19 May 2005 21:39:03 +0200
Message-ID: <428CEB57.9020103@atlavia.it>
References: <151.92.176.3.1249009224.1116511903@webmail.atlavia.it> <20050519142355.GA2261@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp4.tin.it ([212.216.176.224]:55716 "EHLO vsmtp4.tin.it")
	by vger.kernel.org with ESMTP id S261225AbVESTjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 15:39:06 -0400
Received: from [82.48.126.22] (82.48.126.22) by vsmtp4.tin.it (7.0.027) (authenticated as silvia.pg@virgilio.it)
        id 428876B400190E56 for linux-scsi@vger.kernel.org; Thu, 19 May 2005 21:39:04 +0200
In-Reply-To: <20050519142355.GA2261@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Matt Domsch ha scritto:

>On Thu, May 19, 2005 at 02:11:43PM +0000, pg@atlavia.it wrote:
>  
>
>>I exerienced the following error on a RedHat cluster configuration
>>with Dell hardware (Perc 3/DC controller and PowerVault 220 disk
>>array).  When the error occurs the cluster manager shutdown the
>>cluster node, but the filesystem is corruped and the other node
>>cannot mount it until a manual fsck.
>>
>>Any idea?
>>    
>>
>
>The firmware on the PERC 3/DC is not multi-initiator cluster-capable
>under Linux.  For this reason, neither Dell nor Red Hat recommend
>trying to create a HA shared storage cluster with this configuration.
>Even with write cache disabled, the lock sectors used by the cluster
>manager don't manage to stay coherent.
>
>I understand that newest versions of the Red Hat Cluster Suite may no
>longer use lock sectors on the disk as the I/O fencing mechanism,
>which may then enable such configurations.  But neither Dell nor Red
>Hat have done any testing with the hardware config you've got.
>
>The price is right, until you actually need your data to be highly
>available and it crashes.
>
>Thanks,
>Matt
>
>  
>
As I'm not so expert in HA clusters I got an hw ans sw solution 
"suggested" by DELL and my hw/sw configuration, that is working quiet 
well since a couple of years. May be i've been luky.

As racommended I don't mount the same filesystem on both nodes of the 
cluster at the same time; every service has its own filesystem and a 
service is active on a single node.
The uniqe shared partition is the quorum, that is on a RAID-1 volume. 
The other partitions are on a single RAID-5 volume: do you think that to 
make a seaprate volume for each partition could help?

Thanks





