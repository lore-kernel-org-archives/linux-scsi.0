From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Wed, 25 May 2005 11:32:11 -0700
Message-ID: <1117045931.16262.149.camel@beastie>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>
	 <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave>
	 <000b01c560c0$42c59700$03031eac@ivivity.com>
	 <1116982816.7710.58.camel@mulgrave>  <4294972D.4030807@adaptec.com>
	 <1117044247.5210.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp011.mail.yahoo.com ([216.136.173.31]:58265 "HELO
	smtp011.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262391AbVEYScQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 14:32:16 -0400
In-Reply-To: <1117044247.5210.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, open_iscsi <ESQuicksall_open_iscsi@Comcast.net>, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com

On Wed, 2005-05-25 at 14:04 -0400, James Bottomley wrote:
> On Wed, 2005-05-25 at 11:18 -0400, Luben Tuikov wrote:
> > MC/S in iSCSI can be seen as a "wide port" in SAS.
> > 
> > That is, commands are ordered, nexus is the same, going to the same port,
> > etc, etc, etc.  MC/S, has nothing to do with multipathing, which sits above
> > the nexus level.  With MC/S the nexus is the same.
> 
> When I use the term "multi-pathing" I mean multiple virtual paths may be
> traversed to get a command from an application to a target device.
> Under that definition, dm-multipath, MC/S and even network bonding are
> all examples of multi-pathing.
> 
> The visibility of the coding is what I have an issue with.  bonding
> could be inherited invisibly from the network but MC/S has to be
> explicitly coded in the software initiator whereas dm-multipath is done
> above the driver: one code base for all multi-path implementations.
> 
> > MC/S is a good thing.
> 
> a) It's optional, so you can't rely on it.
> b) it requires explicit coding in the driver which is a big negative
> since you can't leverage our existing multi-path code (i.e. more bug
> prone)
> c) The feature set it provides to Linux is identical to the feature set
> that dm-multipath provides.
> 
> It's pointless to add support for an optional feature that provides no
> additional benefit (and its detrimental when the only addition is a
> potential negative impact to the code quality).

Those are very strong arguments against having MC/S implemented for the
software iSCSI initiator. Especially true is (a). Not that many targets
offers MC/S, since according to RFC it implies ERL=2.

Now, back to open-iscsi initiator business and its mainline acceptance.
We are going to met your requirement and will remove multi-connection
support before next patch-set submission. As Mike C. mentioned before,
it is fairly easy to do since the whole connection management resides in
user-space. Though it will exists as a kernel patches on our web site
(http://www.open-iscsi.org) for those who wonders.

Are there are some other requirements we need to met besides MC/S
removal ?

Thanks for the good explanation of your point of view!
Dima

> James
> 
> 

