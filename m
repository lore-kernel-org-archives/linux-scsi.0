From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [patch for 2.6.32? 3/3] scsi: fix another crash at disconnect of usb strorage
Date: Thu, 19 Nov 2009 15:59:47 +0300
Message-ID: <20091119125947.GB23095@ms2.inr.ac.ru>
References: <200911172210.nAHMADAW014298@imap1.linux-foundation.org> <Pine.LNX.4.44L0.0911171742380.3501-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from minus.inr.ac.ru ([194.67.69.97]:50474 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752490AbZKSNOa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 08:14:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911171742380.3501-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk, den@openvz.org

Hello!

> Alexey, have you seen the patches I posted?

Sorry, I have not.


> It does what you want to accomplish and more.

Yes, it looks like this.

I am no expert in this area and cannot tell exactly.

I can only suggest a practical way to test the patch: you take some USB flash
(the older and the slower is the better, usb1.1 flash is the best),
then do the following:

        for (;;) {
	        usb_detach_kernel_driver_np(handle, 0);
        	usleep(1000*(random() % 10000));
	        usb_attach_kernel_driver_np(handle, 0);
        	usleep(1000*(random() % 10000));
    	}

(handle is libusb handle for the device)

Unpatched kernels crash almost instantly.

Alexey
