From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: usb3 fails to write when using usb3 hub in usb3 port
Date: Tue, 25 Sep 2012 14:19:10 -0700
Message-ID: <20120925211910.GH32108@xanatos>
References: <CAEG-z29ipgOj+-k3etiMFjtji3sZRj+Otj32vXbpqAJ0iVQSGA@mail.gmail.com>
 <Pine.LNX.4.44L0.1209241121160.1583-100000@iolanthe.rowland.org>
 <CAEG-z28fpo7yu9GbdvHnm2k4APLNLOZYaMrBhcimkZjbg5RFdQ@mail.gmail.com>
 <20120924180743.GA29893@xanatos>
 <CAEG-z29DC6sctz1vXozG_1seXn-0Ev63CgwDvDyk+_X8jcW_6Q@mail.gmail.com>
 <20120924201325.GC29990@xanatos>
 <CAEG-z29jRZhVHeFg2P_KbWHRWEnBLFAm=Vhfus_ZfJJkYhqJxw@mail.gmail.com>
 <20120924213819.GE29990@xanatos>
 <CAEG-z2-iHYCx7rarOg03TnbSZFyjDYCmd1g=3Hhm9LE2dO+U8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26913 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab2IYVT3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 17:19:29 -0400
Content-Disposition: inline
In-Reply-To: <CAEG-z2-iHYCx7rarOg03TnbSZFyjDYCmd1g=3Hhm9LE2dO+U8Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Tue, Sep 25, 2012 at 09:26:00AM +0300, Adrian Sandu wrote:
> On Tue, Sep 25, 2012 at 12:38 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > Ok, so 3.4.11 doesn't work, and the log file was from 3.5.
> 
> If you want I can provide a 3.4 log...

Hmm, does a 3.3 stable kernel work for you?  I have a hypothesis.

Alan, I'm wondering if the xHCI ring expansion is causing issues with
USB hard drives under xHCI.  Testing with a Buffalo USB 3.0 hard drive
with an NEC uPD720200 xHCI host, I see that the usb-storage and SCSI
initialization produces I/O errors on random sectors in 3.4.0, 3.4.6,
and 3.5.0.  I can't get those errors to be reproduced in 3.3.1.

The xHCI ring expansion was added in 3.4, and we changed the xHCI's
sg_tablesize:

int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
{
...
        /* Accept arbitrarily long scatter-gather lists */
        hcd->self.sg_tablesize = ~0;

The usb-storage driver sets the tablesize thus:

static unsigned int usb_stor_sg_tablesize(struct usb_interface *intf)
{
        struct usb_device *usb_dev = interface_to_usbdev(intf);

        if (usb_dev->bus->sg_tablesize) {
                return usb_dev->bus->sg_tablesize;
        }
        return SG_ALL;
}

I notice that SG_ALL is set to SCSI_MAX_SG_SEGMENTS, which is only 128.
Should we be passing an arbitrarily large number to the SCSI core?
There's some wording in include/scsi/scsi.h about also limiting the
number of chained sgs to 2048.  I'm wondering if we're hitting some bugs
in the SCSI layer because we're setting the sg_tablesize so high.

Alternately, we could be hitting bugs in the USB 3.0 firmware when we
attempt to issue a read or write that's too big.  The read on Adrian's
hard drive failed on a bigger read request (122880 bytes).  It would be
interesting to see if it works fine if the xHCI sg_tablesize is limited.
I'm going to try that with my own drive on 3.5.4 and see if it helps.

Sarah Sharp
