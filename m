From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Question about invoking of "Task management" functions in USB
 driver 	(from newbie)
Date: Tue, 29 Sep 2009 15:26:57 -0400
Message-ID: <4AC25F81.3070105@interlog.com>
References: <ac9fc6790909290721y6b046793rd28357595be2f3a9@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50170 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbZI2T05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2009 15:26:57 -0400
In-Reply-To: <ac9fc6790909290721y6b046793rd28357595be2f3a9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yukta eswar <yukta.eswar@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

yukta eswar wrote:
> Dear Experts,
> 
> I am developing a new USB attached SCSI (UAS) driver for Linux.
> I have implemented "task management" functions by taking reference
> from SAS driver.
> But I am confused about how to invoke these functions from my application.
> 
> Do I need to make any specific function calls from my application to
> invoke these driver functions?
> Can I get any reference code which can invoke Task management functions ?

The bsg driver is designed to handle SCSI and related
protocols. It can handle SCSI commands (e.g. my sg3_utils
package uses bsg) and the SAS Management Protocol (SMP) but I
have not seen examples for task management functions from the
user space. The gentleman referred to in the last "cc" may
know more information.

The various task management function hooks that you put
in your UAS low level driver are mainly for the Linux SCSI
mid-level's error processing. One way to trip that for
your testing is to send a SCSI command that is going
to take some time (e.g. a READ of thousands of blocks
should take some time, even on flash) and setup the
command timeout to zero seconds and or close as you can to
zero.


Greg KH wrote:
 > On Tue, Sep 29, 2009 at 07:51:47PM +0530, yukta eswar wrote:
 >> Dear Experts,
 >>
 >> I am developing a new USB attached SCSI (UAS) driver for Linux.
 >
 > Why?
 >
 > Do you have a pointer to your source code for your driver?

Greg,
It would seem that several groups might be working on UAS ***
drivers for Linux. They may even be in commercial competition.
Why ask them to show all their cards on the table at this
stage?
When they ask informed questions like this one, why not try
to answer them or find someone (else) who can?

Doug Gilbert


*** UAS ( http://www.t10.org/cgi-bin/ac.pl?t=f&f=uas-r02.pdf )
     is a new SCSI transport protocol that is designed to use
     efficiently the bandwidth available in USB-3 for storage
     devices. It should be much better than the (horrible)
     mass storage class. UAS should also work on USB-2 and
     even USB-1.1 .
