From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 3/5] libata-scsi: fix overflow in mode page copy
Date: Thu, 21 Jul 2016 17:17:14 -0400
Message-ID: <20160721211714.GE23759@htj.duckdns.org>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
 <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
 <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33483 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbcGUVRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 17:17:22 -0400
Content-Disposition: inline
In-Reply-To: <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de, sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org

Hello,

On Fri, Jul 22, 2016 at 02:41:52AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> ata_mselect_*() would initialize a char array for storing a copy of
> the current mode page. However, if char was actually signed char,
> overflow could occur.

Do you mean sign extension?

> For example, `0xff` from def_control_mpage[] would be "truncated"
> to `-1`. This prevented ata_mselect_control() from working at all,
> since when it did the read-only bits check, there would always be
> a mismatch.

Heh, the description doesn't really make sense.  Are you talking about
something like the following?

	char ar[N];
	int i;

	i = ar[x];
	if (i == 0xff)
		asdf;

If so, the description isn't quite right.

Thanks.

-- 
tejun
