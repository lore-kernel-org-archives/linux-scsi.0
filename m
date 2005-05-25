From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Wed, 25 May 2005 14:04:07 -0400
Message-ID: <1117044247.5210.15.camel@mulgrave>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>
	 <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave>
	 <000b01c560c0$42c59700$03031eac@ivivity.com>
	 <1116982816.7710.58.camel@mulgrave>  <4294972D.4030807@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:47852 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261889AbVEYSEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 14:04:25 -0400
In-Reply-To: <4294972D.4030807@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: open_iscsi <ESQuicksall_open_iscsi@Comcast.net>, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

On Wed, 2005-05-25 at 11:18 -0400, Luben Tuikov wrote:
> MC/S in iSCSI can be seen as a "wide port" in SAS.
> 
> That is, commands are ordered, nexus is the same, going to the same port,
> etc, etc, etc.  MC/S, has nothing to do with multipathing, which sits above
> the nexus level.  With MC/S the nexus is the same.

When I use the term "multi-pathing" I mean multiple virtual paths may be
traversed to get a command from an application to a target device.
Under that definition, dm-multipath, MC/S and even network bonding are
all examples of multi-pathing.

The visibility of the coding is what I have an issue with.  bonding
could be inherited invisibly from the network but MC/S has to be
explicitly coded in the software initiator whereas dm-multipath is done
above the driver: one code base for all multi-path implementations.

> MC/S is a good thing.

a) It's optional, so you can't rely on it.
b) it requires explicit coding in the driver which is a big negative
since you can't leverage our existing multi-path code (i.e. more bug
prone)
c) The feature set it provides to Linux is identical to the feature set
that dm-multipath provides.

It's pointless to add support for an optional feature that provides no
additional benefit (and its detrimental when the only addition is a
potential negative impact to the code quality).

James


