From: "David Peterson \(Eng\)" <david_peterson@cnt.com>
Subject: RE: SSC-2 support in Linux
Date: Fri, 15 Oct 2004 10:50:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <82C736F456CA3E4EA3D0DC6CC31AA5CB01922846@esply09.cnt.ad.cnt.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatehider.cnt.com ([139.93.128.13]:31628 "EHLO esply07.cnt.com")
	by vger.kernel.org with ESMTP id S268084AbUJOPuc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 11:50:32 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Comments below...Dave

-----Original Message-----
From: Kai Makisara [mailto:Kai.Makisara@kolumbus.fi] 
Sent: Wednesday, September 15, 2004 1:39 PM
To: David Peterson (Eng)
Cc: SCSI Mailing List
Subject: Re: SSC-2 support in Linux

I am dropping linux-kernel from this subthread. This is a SCSI question.

On Tue, 14 Sep 2004, David Peterson (Eng) wrote:

> I'd like to hear from anyone interested, or has looked into, adding 
> support for SSC-2 (SCSI Stream Commands -2, i.e., tape devices) 
> explicit address mode into the Linux OS.
> 
I have looked at the specs but I am not sure we need to use explicit
address command now. One problem is that there are no/very few shipping
drives that support these commands. The explicit address commands will
be useful in future but we have to wait until they are a little more
than a theory.

Dave: Yes this is a classic chicken and egg scenario. Drive vendors are
waiting for support from host vendors and vice-versa. Would not be too
difficult to implement a virtual tape target/lun that supports explicit
address mode to get the ball rolling.

> In summary, SSC-2 explicit address mode enables for tape devices:
> - robust tagged command queuing

The tape driver (st) does not use any kind of tagged queuing. I have not
found this feature useful for tapes. The reasons are:
- The medium is sequential and so the drive can't intelligently sort the
  commands. The benefit would be to able to feed more than one command
to
  the drive at an time. However, this is not needed in order to keep the
  drive buffer non-empty.

Dave: When using explicit address mode the device server can
intelligently sort the commands. Drive transfer rates are on the
increase. As such it will not be easy to keep the drive buffer
non-empty, especially if latency via distance comes into play.

- The read()/write() semantics means that we can't touch the data buffer
  outside the commands. No parallelism is possible except with multiple
  threads. Here the problem is synchronization and I am not sure using
  multiple threads to handle tapes is a good solution.

If there is an interface that benefits from tagged commands and
- used by software and
- brings real advantages over using the current simple interface, then I
am more interested. I don't think we should use low-level interface
features unless they bring real benefits for real world user software.


> - multi-path I/O

This is a more general SCSI thing. Work is being done on the general
aspects.

> - enhanced error detection and recovery

Here also the problem is what to do with the information. The current
interface does not give methods to transfer fine-grained error
information to the user space. The final error recovery must in most
cases happen in user space. The driver does not have any more the data
needed in the recovery.

Dave: When I talk about enhanced error detection and recovery I don't
mean "transferring fine-grained error information" to user space. The
error detetection and recovery is built into the protocol and resides at
the tape driver level.

There have been some interesting suggestions for new interfaces that
could be used for more "free-form" error reporting (the event
interfaces). A traditional method is to use ioctls but here the problem
is that good, fixed-format definitions should be developed. I have
actually not seen any enthusiasm among users to do this ;-)

Doug Gilbert has worked on the infrastructure for the descriptor based
sense data. I have plans how to use this in st. I think we will be ready
when drives start returning this data. Using the new information coming
with this sense data takes more time.

--
Kai
