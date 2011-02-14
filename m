From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 18:46:29 +0900
Message-ID: <20110214184635I.fujita.tomonori@lab.ntt.co.jp>
References: <1297674072.7114.46.camel@haakon2.linux-iscsi.org>
	<20110214182941R.fujita.tomonori@lab.ntt.co.jp>
	<1297675668.7114.64.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37992 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab1BNJqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2011 04:46:34 -0500
In-Reply-To: <1297675668.7114.64.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Mon, 14 Feb 2011 01:27:48 -0800
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Mon, 2011-02-14 at 18:29 +0900, FUJITA Tomonori wrote:
> > On Mon, 14 Feb 2011 01:01:12 -0800
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > > btw, can we kill the non scatter/gather data path? I think that we
> > > > should always use the scatter/gather data transfer.
> > > 
> > > Unfortuately it's not that easy.  The main reason why CDB type
> > > SCF_SCSI_CONTROL_NONSG_IO_CDB was originally added (back in 2.2/2.4
> > > days) was because certain LLDs had a problem with basic control CDBs
> > > using SGLs..
> > > 
> > > Obviously we are way past that point with drivers/scsi today, but the
> > > main reason today why SCF_SCSI_CONTROL_NONSG_IO_CDB still exists is
> > > because of CDB emulation for complex stuff in target_core_cdb.c.  It has
> > > historically proven much easier to code complex CDB emulation using a
> > > contigious buffer, than with walking SGL formatted memory.
> > > 
> > > Converting over the more complex CDB emulation stuff to SGLs would
> > > somewhat painful, at least without adding an extra location allocation +
> > > copy into SGLs (not a big deal for CONTROL CDB stuff),
> > 
> > lib/scatterlist.c provides nice helper functions to copy data between
> > a linear buffer and an SG list. I think that at least, it's more clear
> > than now.
> > 
> 
> Yeah, I think this is going to make the most sense for a proper long
> term conversion and removal of SCF_SCSI_CONTROL_NONSG_IO_CDB.

Ok, I take care of this.


> > Hmm, I don't think that very large contiguous buffer for CONTROL CDB
> > so why can't we allocate a physically contiguous buffer for it?
> > 
> 
> Well, that depends what you consider large..  ;)

2 pages is enough for most? REPORT_LUNS might need a large buffer but
I don't think it's so difficult to handle REPORT_LUNS with
scatter/gather.
