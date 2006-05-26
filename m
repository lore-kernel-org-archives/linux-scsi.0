From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in scsi_scan_host_selected()
Date: Fri, 26 May 2006 16:50:06 -0700 (PDT)
Message-ID: <20060526235006.25875.qmail@web31801.mail.mud.yahoo.com>
References: <20060523011619.GG4093@parisc-linux.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:1636 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751685AbWEZXuG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 19:50:06 -0400
In-Reply-To: <20060523011619.GG4093@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Amit Arora <aarora@in.ibm.com>, linux-scsi@vger.kernel.org, patmans@us.ibm.com

--- Matthew Wilcox <matthew@wil.cx> wrote:
> So as scsi maintainer, what's your preference for the 'right way' to fix
> this?  Clearly a whole-scale driver audit is needed, so my preference is
> to rename the variable (how about id_limit?) and then do a sweep
> checking that everybody's using it correctly.
> 
> Then we need to do a similar check for max_lun and max_channel.  As far
> as conventions go, I think we should use 8 and 16; it's just so much
> more natural to write 'for (id = 0; id < id_limit; id++)'.

Think about it: "id_limit".  What if I set "id_limit" equal 0?
Does this mean that the last id is 0 or does it mean that are simply no
ids.

The literature calls such things "number of" ("num_of_xyz") or
"maxiumum number of" ("max_num_xyz").

If you called it "num_of_ids" or "max_num_ids" then there is no
ambiguity that what it talks about is the (maximum) _number_ (as in count)
of the ids.  An index can never be >= the count, else BUG.

     Luben
P.S. Then after that patch, seeing that there is no possible enumeration
to ids other tha in an SPI layer, another patch should possibly get rid of it.

