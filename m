From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI commands order when using scsi_do_req
Date: Fri, 03 Jun 2005 10:03:04 +1000
Message-ID: <429F9E38.4070700@torque.net>
References: <OFE0914CA0.DA8D0415-ONC2257014.004F2855-C2257014.00603EFB@il.ibm.com> <1117734886.5025.55.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:55225 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261462AbVFCACr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2005 20:02:47 -0400
In-Reply-To: <1117734886.5025.55.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Liran Schour <LIRANS@il.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-06-02 at 20:31 +0300, Liran Schour wrote:
> 
>>I am developing a new SCSI upper layer driver. (Object based SCSI device)
>>I noticed that scsi_do_req execute commands in LIFO order (add new commands
>>to the head of the Q).
>>This behavior can cause a starvation of commands (or at least long delays).
>>What is the proper solution to this?
> 
> 
> Well, to use the proper interfaces.
> 
> scsi_do_req is deprecated, so don't use it.  scsi_wait_req is its
> replacement.

James,
scsi_wait_req() doesn't look like a replacement of
scsi_do_req() to me. The "wait" call is synchronous
while scsi_do_req() is asynchronous with a done()
callback.

  Note: they're only really intended to allow ULDs to
> execute commands that are necessary for controlling the device (that's
> why they go at the head of the queue).

The "char" ULDs use scsi_do_req() exclusively for
SCSI command injection. The sg driver could be sharing
the device with sd driver, but then again it could
be talking to a SES target. The block layer SG_IO ioctl
is the only use in "mixed" mode (e.g. smartmontools
usage). However the block layer SG_IO is not being
used in "mixed" mode when a CD/DVD is being burnt.
IMO the mid level should not arbitrarily adopt LIFO
order.

   Block commands are executed in
> order using ULD init_command() (or REQ_BLOCK_PC).

OSDs break the UNIX block paradigm. Perhaps
it's time to start thinking about how to properly
support them.

Doug Gilbert
