From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sym53c8xx_2 oops in lk 2.5.69-bk14
Date: Thu, 22 May 2003 12:17:19 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECC332F.1080404@torque.net>
References: <3ECAFCC1.40402@torque.net> <20030521091918.A21010@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:60681 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262454AbTEVCDW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 22:03:22 -0400
In-Reply-To: <20030521091918.A21010@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Wed, May 21, 2003 at 02:12:49PM +1000, Douglas Gilbert wrote:
> 
>>This oops in the sym53c8xx may have been recently
>>introduced since I run rescan-scsi-bus.sh reasonably
>>often. It locked my system solid, scrolled the useful
>>part of the oops off the screen and put nothing in
>>the log. Handwritten notes:
> 
> 
> The scsi_host_hn_get is not doing a scsi_host_get, so any scsi_host_put
> that follows can break things - for example causing the scsi_host to
> disappear out from under us. See the scsi_proc.c usage.
> 
> Christoph's "give ->proc_info a struct Scsi_Host * parameter" patch got
> rid of a lot of them (and is in scsi-miscs-2.5), but not in scsi_proc.c.
> 
> Looks like scsi_host_hn_get should always call scsi_host_get, but
> scsi_find_host_by_num really has to change to use driver model iterators
> (so its locking protection matches scsi_host_get), I assume this is a WIP
> for Christoph or Mike but for now you could use a patch like this
> (untested, on top of scsi-misc-2.5 or Christoph's changes):

Patrick,
Thanks, that patch fixed the problem I reported.

Doug Gilbert

