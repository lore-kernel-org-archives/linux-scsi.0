From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SSC-2 support in Linux
Date: Wed, 15 Sep 2004 21:38:30 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409152114090.1972@kai.makisara.local>
References: <82C736F456CA3E4EA3D0DC6CC31AA5CB01651157@esply09.cnt.ad.cnt.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep31-0.kolumbus.fi ([193.229.0.35]:30896 "EHLO
	fep31-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S267248AbUIOSic (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 14:38:32 -0400
In-Reply-To: <82C736F456CA3E4EA3D0DC6CC31AA5CB01651157@esply09.cnt.ad.cnt.com>
List-Id: linux-scsi@vger.kernel.org
To: "David Peterson (Eng)" <david_peterson@cnt.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

I am dropping linux-kernel from this subthread. This is a SCSI question.

On Tue, 14 Sep 2004, David Peterson (Eng) wrote:

> I'd like to hear from anyone interested, or has looked into, adding
> support for SSC-2 (SCSI Stream Commands -2, i.e., tape devices) explicit
> address mode into the Linux OS.
> 
I have looked at the specs but I am not sure we need to use explicit 
address command now. One problem is that there are no/very few shipping 
drives that support these commands. The explicit address commands will be 
useful in future but we have to wait until they are a little more than a 
theory.

> In summary, SSC-2 explicit address mode enables for tape devices:
> - robust tagged command queuing

The tape driver (st) does not use any kind of tagged queuing. I have not 
found this feature useful for tapes. The reasons are:
- The medium is sequential and so the drive can't intelligently sort the 
  commands. The benefit would be to able to feed more than one command to 
  the drive at an time. However, this is not needed in order to keep the
  drive buffer non-empty.
- The read()/write() semantics means that we can't touch the data buffer
  outside the commands. No parallelism is possible except with multiple 
  threads. Here the problem is synchronization and I am not sure using
  multiple threads to handle tapes is a good solution.

If there is an interface that benefits from tagged commands and
- used by software and
- brings real advantages over using the current simple interface,
then I am more interested. I don't think we should use low-level interface 
features unless they bring real benefits for real world user software.

> - multi-path I/O

This is a more general SCSI thing. Work is being done on the general 
aspects.

> - enhanced error detection and recovery

Here also the problem is what to do with the information. The current 
interface does not give methods to transfer fine-grained error information 
to the user space. The final error recovery must in most cases happen in 
user space. The driver does not have any more the data needed in the 
recovery.

There have been some interesting suggestions for new interfaces that could 
be used for more "free-form" error reporting (the event interfaces). A 
traditional method is to use ioctls but here the problem is that good, 
fixed-format definitions should be developed. I have actually not seen any 
enthusiasm among users to do this ;-)

Doug Gilbert has worked on the infrastructure for the descriptor based 
sense data. I have plans how to use this in st. I think we will be ready 
when drives start returning this data. Using the new information coming 
with this sense data takes more time.

-- 
Kai
