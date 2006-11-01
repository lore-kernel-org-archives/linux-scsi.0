From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] SCSI: ISCSI build failure
Date: Wed, 01 Nov 2006 08:03:22 -0800
Message-ID: <4548C54A.2020708@oracle.com>
References: <200610291945.16948.toralf.foerster@gmx.de> <20061029190357.98fc9c98.randy.dunlap@oracle.com> <Pine.LNX.4.64.0610301206240.6761@scrub.home> <20061030083230.5e889415.randy.dunlap@oracle.com> <1162327892.13859.67.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0611010057111.6242@scrub.home> <1162394814.13859.100.camel@mulgrave.il.steeleye.com> <20061101153623.GF11399@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:58790 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1423951AbWKAQIA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Nov 2006 11:08:00 -0500
In-Reply-To: <20061101153623.GF11399@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Roman Zippel <zippel@linux-m68k.org>, Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

Matthew Wilcox wrote:
> On Thu, Nov 02, 2006 at 12:26:54AM +0900, James Bottomley wrote:
>> On Wed, 2006-11-01 at 01:00 +0100, Roman Zippel wrote:
>>> Please don't select NET, it's way too broad.
>> Then you'll make select implied dependencies work in Kbuild so we don't
>> need to do anything at all about this?

Roman said that CONFIG_NET is too broad to select,
and I agree with him.  Select is meant to be used to enable one
library-like kernel feature/function, not all of "Networking".

But yes, there do seem to be some depends/selects interaction
whose handling is missing.

> This is iSCSI ... how can it possibly be useful without NET?  Why
> doesn't CONFIG_ISCSI depend on NET, making this whole problem moot (for
> now).

There is no CONFIG_ISCSI symbol AFAIK.  I see:

CONFIG_SCSI_ISCSI_ATTRS
CONFIG_ISCSI_TCP
CONFIG_SCSI_QLA_ISCSI

If CONFIG_NET=n, CONFIG_SCSI_QLA_ISCSI can still be enabled
by a user and it will "select" CONFIG_SCSI_ISCSI_ATTRS.
SCSI_ISCSI_ATTRS depends on SCSI && NET, so there should be
some (either) depends or selects action going on there.  I think
we agree on that part at least.


-- 
~Randy
who still wishes that the SCSI low-level drivers menu were not in
some dog-awful random order
