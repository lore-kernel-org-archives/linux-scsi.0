From: Scott O'Connor <soconnor@sanblaze.com>
Subject: driver removal problems with mptsas?
Date: Thu, 25 May 2006 15:17:25 -0400
Message-ID: <447602C5.10007@sanblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gazungle.com ([207.210.240.68]:31416 "HELO
	mail.gazungle.com") by vger.kernel.org with SMTP id S1030358AbWEYTR0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 15:17:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

I have noticed that if I 'rmmod mptsas', the scsi_eh_<n> kernel
thread is not stopped.  If I 'modprobe mptsas' a new scsi_eh_<n>
is started.  If I put the above in a loop, a new scsi_eh_<n>
is started for each modprobe of mptsas.

I also believe that mptsas is not cleaning up properly
when removed.  I have a 1068 and during probe, sas_phy_alloc()
is called for each of the 8 phys.  During mptsas_remove() I
would expect to see those 8 allocated sas_phy structures
freed by calls to sas_phy_delete()/sas_phy_free().  Or are they
removed elsewhere?

I'm running 2.6.16.18 and using LSISAS1068 card.

-Scott.

