From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Tue, 09 Apr 2019 08:16:47 -0700
Message-ID: <1554823007.161891.6.camel@acm.org>
References: <Pine.LNX.4.44L0.1904091014570.1599-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1904091014570.1599-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kento.A.Kobayashi@sony.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, Oliver Neukum <oneukum@suse.com>, gregkh@linuxfoundation.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Jacky.Cao@sony.com, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-04-09 at 10:44 -0400, Alan Stern wrote:
+AD4 On Mon, 8 Apr 2019, Martin K. Petersen wrote:
+AD4 
+AD4 +AD4 
+AD4 +AD4 Alan,
+AD4 +AD4 
+AD4 +AD4 +AD4 So it looks as though the SCSI subsystem doesn't like to have a reset 
+AD4 +AD4 +AD4 handler call scsi+AF8-remove+AF8-host.
+AD4 +AD4 
+AD4 +AD4 Are you talking about a PCI device removal handler or a SCSI error
+AD4 +AD4 handler?
+AD4 
+AD4 The context of this discussion is a USB mass-storage device where the
+AD4 device's port on its upstream hub has been powered off.  The
+AD4 powered-off port causes an executing command to time out.  As a result
+AD4 the SCSI error handler runs and calls the USB reset routine, but the
+AD4 reset fails because the kernel is unable to communicate with the device
+AD4 through the powered-off port.  This causes the USB reset routine to
+AD4 unbind the device from its USB driver, which in turn calls
+AD4 scsi+AF8-remove+AF8-host -- while the error handler is still running.

>From which context does that unbind happen? From inside a SCSI EH callback
or from the context of a workqueue? I think the former is not allowed but
that the latter is allowed. The SRP initiator driver (ib+AF8-srp.c) follows the
latter approach. See also srp+AF8-queue+AF8-remove+AF8-work().

Bart.
