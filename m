From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Patches for SCSI scanning
Date: 20 Apr 2004 11:08:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082477331.2191.44.camel@mulgrave>
References: <20040418185751.GC4868@tpkurt.garloff.de>
	<1082330192.1969.37.camel@mulgrave>
	<20040420115419.GG4356@tpkurt.garloff.de>
	<1082471881.1804.34.camel@mulgrave>
	<20040420160334.GO4356@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:54224 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262802AbUDTQIz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 12:08:55 -0400
In-Reply-To: <20040420160334.GO4356@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, 2004-04-20 at 11:03, Kurt Garloff wrote:
> Linux maps 8 byte LUNs to a 32bit number in scsilun_to_int().
> There are several ways to use the 8 bytes, but the mapping assumes
> a particular model which is often used and the mapping is nice in
> that it results in LUNs being 0, 1, 2, ...
> However, there are other possibilities. And as soon as the last
> four bytes are non-zero, the mapping will break down :-/
> The S/390 folks seem to have such devices.

This looks like it needs fixing in our lun mapping support, doesn't it,
rather than trying to work around it with a flag?

I'd rather only have an actual blacklist flag if there's genuinely a
stupid device with a real problem, rather than just a "we don't do this
entirely correctly in the kernel" problem.

James


