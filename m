From: Simon Munton <simon@munton.demon.co.uk>
Subject: PROBLEM: aic7xxx can hang PC on SMP kernel 2.4.22
Date: Thu, 6 Nov 2003 21:09:58 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311062109.58979.simon@munton.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:29458 "EHLO
	anchor-post-35.mail.demon.net") by vger.kernel.org with ESMTP
	id S263845AbTKFVKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 16:10:06 -0500
Received: from munton.demon.co.uk ([62.49.24.21] helo=intrepid.munton.demon.co.uk)
	by anchor-post-35.mail.demon.net with esmtp (Exim 3.35 #1)
	id 1AHrOH-000H4G-0Z
	for linux-scsi@vger.kernel.org; Thu, 06 Nov 2003 21:10:05 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I've recently had a problem of my PC freezing when using my scsi scanner via 
the aic7xxx driver. It only occurs when built for SMP,and is triggered by the 
scanner returning busy status.

The busy status results in the driver creating a timer to freeze the device 
for half a second (in ahc_linux_handle_scsi_status()). When the timer 
expires, the function ahc_linux_dev_timed_unfreeze() is called, and this can 
call ahc_linux_free_device(). ahc_linux_free_device() calls del_timer_sync(), 
and this is the point at which the PC hangs.

Essentially, del_timer_sync() has been called from the timer expiry function; 
it then waits for the timer function to finish, which won't happen (on SMP 
machines).

I looked at the aic79xx driver which has similar code to handle busy status, 
but in the aic79xx driver, the ahd_linux_free_device() function calls 
del_timer(), not del_timer_sync().

Simon

