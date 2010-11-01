From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tcm IBMVSCSIS driver
Date: Tue, 2 Nov 2010 07:20:29 +0900
Message-ID: <20101102071513A.fujita.tomonori@lab.ntt.co.jp>
References: <1288479943.21870.55.camel@haakon2.linux-iscsi.org>
	<20101101215109E.fujita.tomonori@lab.ntt.co.jp>
	<1288648016.7708.42.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:48445 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab0KAWUt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2010 18:20:49 -0400
In-Reply-To: <1288648016.7708.42.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, joel.becker@oracle.com

On Mon, 01 Nov 2010 14:46:56 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Mon, 2010-11-01 at 21:56 +0900, FUJITA Tomonori wrote:
> > On Sat, 30 Oct 2010 16:05:43 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > One final question in that regard is in your ibmvscsis_queuecommand()
> > > code, only INQUIRY, REPORT_LUNS, and MODE_SENSE need to be handled
> > > specially for other non Linux VIO SRP Initiator guests on the other
> > > end..
> > 
> > INQUIRY and REPORT_LUNS need the special responses. Otherwise the
> > initiators can't see the logical units.
> > 
> 
> There also appears to be a bunch of magic bits set for MODE_SENSE as
> well and seems to indicate a hard requirement for legacy non linux
> guests, yes..?

No, see ibmvio.c in tgt's user space code.


> Also wrt to the internal REPORT_LUNs emuation, is it just the LUN
> encoding that is specific to ibmvscsis..?  I am wondering if can just
> add a operation TCM fabric module TFO op for individual struct
> se_lun->unmapped_lun -> REPORT_LUN payload encode, and drop this
> internal emulation code.

Yeah.
