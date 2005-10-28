From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: 2.6.14: aic7xxx broken with blktool
Date: Fri, 28 Oct 2005 10:21:48 -0500
Message-ID: <1130512908.3328.8.camel@mulgrave>
References: <20051028040227.37dfef86.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:49639 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030213AbVJ1PV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 11:21:57 -0400
In-Reply-To: <20051028040227.37dfef86.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Meelis Roos <mroos@linux.ee>

On Fri, 2005-10-28 at 04:02 -0700, Andrew Morton wrote:
> I'm using blktool to find info about installed disks. With Debian's 
> 2.6.8, "blktool /dev/sda id" worked fine. With 2.6.14 it's broken (see 
> below). Adaptec 2940UW with a 4.5G Quantum Viking II disk.
> 
> It outputs random data from memory as a response to the scsi command, 
> different recent strings different times.
> 
> Otherwise the disk works OK.

This is a bug in blktool, so please refile appropriately.

The change is that we now believe hdr->cmd_len if it's set and block
tool is setting it wrongly.  aic7xxx detects the mismatch between the
actual command length and the set length in its sequencer and barfs.

James


