From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: lots and lots of disks again
Date: 12 Feb 2004 10:20:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076599243.1993.84.camel@mulgrave>
References: <20040210110417.GB4010@tpkurt.garloff.de>
	<20040210112658.GC4010@tpkurt.garloff.de>
	<20040210133932.A3870@infradead.org>
	<20040210154751.GH4010@tpkurt.garloff.de>
	<20040210102603.0c835212.akpm@osdl.org>
	<20040211145614.GA4010@tpkurt.garloff.de>
	<20040211132848.49eece0d.akpm@osdl.org>
	<20040211220918.GJ4010@tpkurt.garloff.de>
	<20040211142933.484ca978.akpm@osdl.org>
	<20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
	<20040212150035.GN1780@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:4773 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266472AbUBLPVL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 10:21:11 -0500
In-Reply-To: <20040212150035.GN1780@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

As I understand it, we can do aliasing in gendisk (two different
major/minor sets for the same disc), could we also do this if we have
different numbers of partitions on them?

What I was thinking is just keep the partition mask for our current
majors and allocate a new major for the large disk configurations with a
different partition mask.

As long as we can alias our old scheme to the new one (and obviously
everyone using the old scheme may have inaccessible partitions if the
disc were partitioned by the new scheme), it would seem to provide
backwards compatibility required by 2.6 and a way of moving to 64 (or
however many partitions we want) if the user desires.

As long as this won't induce any nasty complications, I think it's
workable and we can simply drop all the old SCSI majors in 2.7

James


