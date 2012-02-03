From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [LSF/MM TOPIC] yet another RAID engine
Date: Fri, 3 Feb 2012 02:29:56 +0200
Message-ID: <4F2B2A84.8010205@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:53601 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2BCAaL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2012 19:30:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Bhamare, Sachin" <sbhamare@panasas.com>, Benny Halevy <bhalevy@tonian.com>, "Welch, Brent" <welch@panasas.com>

I have mentioned this in the past and people might be interested. If not please ignore.

In Kernel 3.2 I introduced RAID5 support into the ORE. Objects Raid Engine

The ORE is a pretty compact code that has a simple interface of:
- Given a RAID layout description. And a device table
- Page-array or BIO supplied on top
- Will produce a set of BIOs on the bottom one for each device.

The same generic engine has support for many RAID topologies. I might say
that it supports all the existing topologies that I've encountered and
some more that are not.

It's a 3 level RAID topology.
- The bottom most level have one or more copies (mirrors).
- The middle level supports striping (raid0), raid4, raid5, raid6,
- The Top level supports striping over device groups. Or what we call
  raid groups.

So all the combination of raid10/50/501/51/60/61 and so on and so forth
are simple and much more.

This is all pretty much old news, OK it might have a bit more, But there is one
advantage to the ORE that does not exist in any other system:

Since the same code changes it's output according to a layout descriptor.
The topology is *no longer static*. Directories can be mirrors, large files
raid5, small files raid10, /tmp raid0. Inner disk smaller stripes, outer
larger, you name it. Every write request can have it's own topology.
Also the topology can be dynamic. More devices add/removed online

Currently at the bottom level the BIOs are pushed into T10 OSD objects hard coded.
But this can change into an IOer-function-vector and be fed to block-devices,
fs-inodes, ... What ever wants to implement the simple dev_read_bio/dev_write_bio
API.

I see two immediate possible candidates to the ORE.
  - One is an md replacement for static multi-devices topology.
  - Second is BTRFS which wanted a RAID5 RAID6 implementation and last I asked does not have one.
    This could fit well into their structures.

OK, now did I just shoot myself in the foot?

Thanks
Boaz
