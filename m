From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH] cciss: Fix warnings during compilation under 32bitenvironment
Date: Thu, 19 Apr 2007 16:27:26 -0000
Message-ID: <558F4D473FD7FE419B019232BF2D37B401167D74@G3W0634.americas.hpqcorp.net>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2><226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net><1176995934.31764.7.camel@mulgrave.il.steeleye.com><226E1C65E4F6164E8EA5FD3CC913AE8CF462EE@G3W0639.americas.hpqcorp.net> <1176999730.31764.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:44713 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXDSQbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 12:31:46 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Something like 

if (sizeof(blah) > 4) {
   do all the assignments with shifts
}

might be slighly better since the CDB is already zeroed
by cmd_alloc() and doesn't need to be zeroed a 2nd time.

-- steve

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
Sent: Thu 4/19/2007 11:22 AM
To: Miller, Mike (OS Dev)
Cc: Hisashi Hifumi; akpm@linux-foundation.org; jens.axboe@oracle.com; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Cameron, Steve
Subject: RE: [PATCH] cciss: Fix warnings during compilation under 32bitenvironment
 
On Thu, 2007-04-19 at 16:12 +0000, Miller, Mike (OS Dev) wrote:
> > > Nak. You still haven't told where you saw these warnings. What 
> > > compiler are you using? I do not see these in my 32-bit environment.
> > 
> > I think it's seen with CONFIG_LBD=n on 32 bits
> > 
> > In that configuration, sector_t is a u32 (it's u64 even on 32 
> > bits with CONFIG_LBD=y).  The proposed code change is a 
> > simple cut and paste from the sd driver.
> 
> Isn't there a better way than testing each one?

It's not such a bad option.  The sizeof() test is compile time
determinable, so the compiler simply zeros the fields in the
CONFIG_LBD=n case and does the shift for CONFIG_LBD=y.  It certainly
never compiles to four inline condition checks.

James



