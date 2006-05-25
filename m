From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: driver removal problems with mptsas?
Date: Thu, 25 May 2006 14:04:31 -0700
Message-ID: <1148591071.11298.0.camel@localhost.localdomain>
References: <447602C5.10007@sanblaze.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:58798 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751237AbWEYVEE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 17:04:04 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4PL438d000798
	for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 17:04:03 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4PL43jP255826
	for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 15:04:03 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4PL4357004117
	for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 15:04:03 -0600
In-Reply-To: <447602C5.10007@sanblaze.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Scott O'Connor <soconnor@sanblaze.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Scott,

Your right this was a problem, but was addressed with a recent patch
in scsi-misc:
http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=92aab6464be735139f9ea38fd039c3b84c722630

--Alexis


On Thu, 2006-05-25 at 15:17 -0400, Scott O'Connor wrote:
> Hello,
> 
> I have noticed that if I 'rmmod mptsas', the scsi_eh_<n> kernel
> thread is not stopped.  If I 'modprobe mptsas' a new scsi_eh_<n>
> is started.  If I put the above in a loop, a new scsi_eh_<n>
> is started for each modprobe of mptsas.
> 
> I also believe that mptsas is not cleaning up properly
> when removed.  I have a 1068 and during probe, sas_phy_alloc()
> is called for each of the 8 phys.  During mptsas_remove() I
> would expect to see those 8 allocated sas_phy structures
> freed by calls to sas_phy_delete()/sas_phy_free().  Or are they
> removed elsewhere?
> 
> I'm running 2.6.16.18 and using LSISAS1068 card.
> 
> -Scott.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

