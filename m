From: "Sachin Mhatre \(smhatre\)" <smhatre@cisco.com>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 6 Nov 2003 15:12:51 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <005801c3a44a$5847c6e0$8f074d0a@apac.cisco.com>
References: <20031027153932.A16679@infradead.org>
Reply-To: <smhatre@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:64814 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263462AbTKFJm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 04:42:57 -0500
In-Reply-To: <20031027153932.A16679@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com


Hi,
	The following is the reason for sending the TEST_UNIT_READY and
START_STOP initialization command in the iSCSI driver:- 

The iSCSI driver receives a CHECK CONDITION with sense key, NOT READY
and ASC/ASCQ=04/02 (i.e. an initialization command required). The Linux
SCSI mid-layer does not handle this condition. Hence the TUR and START
STOP initialization commands are sent from the iSCSI driver.

Should this condition be necessarily handled in the SCSI mid-layer or
the low-level driver?

Thanks,
Sachin

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Monday, October 27, 2003 9:10 PM
To: Krishna Murthy
Cc: linux-scsi@vger.kernel.org; davmyers@cisco.com
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1


On Thu, Oct 23, 2003 at 05:34:10PM +0530, Krishna Murthy wrote:
> Hi,
> 	Linux iSCSI driver 4.0.0.1 (linux-iscsi-4.0.0.1.tgz) is
available at
> 
> http://sf.net/projects/linux-iscsi/

Here's a list of a few comments I've come up with.  I haven't yet looked
at the data structurws much, but it seems there's a complete lack of
refcounting.  Also there's lots of comments were ysou complain about
scsi midlayer misbehaviour or bugs - please submit patches or submit
workarounds when you encounter them, that's what open source is all
about!

Also the same question that went to the unh folks goes to you:  why do
you think your implementation is better than theirs and why do you think
cooperation on one iscsi stack is impossible.

here's the list:


iscsi-probe.c:
	- lots of unchecked kmalloc()s
	- you can't allocate scsi_cmnds yourself but _must_ use
scsi_get_command
	- dito for scsi_device.
	- the whole iscsi_do_cmnd use looks very very strange.  you're
probably
	much better of to use the scsi_request based interfaces and use
midlayer
	queueing and sometimes even higher level interfaces, e.g. your
iscsi_send_tur
	coudld be replaced by an scsi_ioctl(sdp,
SCSI_IOCTL_TEST_UNIT_READY, NULL)
	I still don't understand, though why the heck you need to do a
TUR in
	a lowlevel driver and even more need a thread do a single TUR,
started from
	another kernel tread.  there more I dig into it your probing and
thread
	abuse looks horribly screwed.
	- reinitilialize disk is another such candidate.  again why do
you
	need to send START_STOP commands from the LLDD, why do you need
another
	thread instead of a state machine and again life would be a lot
simpler
	by using the midlayer queueing infrastructure.
	- dito for the reports luns and inquiry code in
iscsi_detect_luns.
	I'm very very unhappy to see a lowlevel driver mess with all
this.
	Even if you need to do it from a LLDD use the midlayer
functionality for
	it.  But I still want to see a very good explanation why you
need this at all.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

