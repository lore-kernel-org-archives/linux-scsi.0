From: Steven Pratt <slpratt@austin.ibm.com>
Subject: MPTSAS Driver and scatter gather lists
Date: Tue, 04 Dec 2007 09:45:04 -0600
Message-ID: <47557600.5040902@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44456 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbXLDPpB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 10:45:01 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB4Fj0eF017097
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 10:45:00 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB4Fj0Rs446314
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 10:45:00 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB4Fj0nW023472
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 10:45:00 -0500
Received: from [9.41.47.41] (dyn9414741.austin.ibm.com [9.41.47.41])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id lB4Fj07p023406
	for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 10:45:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was doing some performance comparisons between the aic94xx sas adapter 
and the mptsas (lsi1078 chip) and saw that performance was slightly 
lower on lsi using the same drive. One thing I noticed the mptsas driver 
was only setting sg_tablesize to 40 which restricts the maximum size of 
the IO to 160kb.  This is inefficient and so I changed it to 255 (max 
value) for testing purposes.  The results were not what I expected.  
While CPU efficiency was improved at the larger block sizes (like I had 
hopped), there were drastic improvements at small (<16k) block sizes 
which is completely surprising).  So I decided to see where all the time 
was being spent.  When doing oprofile, loss of idle ticks was confusing 
things so I booted with idle=poll, and magically the original mptsas 
driver now performs like the modified version at the small block sizes.
My suspicion is that we have some some sleep delay which is minimized by 
going into poll mode, but I have no idea why changing the sg_tablesize 
gives the same results regardless of poll mode.  I should reiterate that 
I am not talking about small difference. This is 2x performance at 1/3 cpu.

Also, is there any reason we can't increase sg_tablesize for mptsas?

Any thoughts or experiments to try are welcome.
Steve
