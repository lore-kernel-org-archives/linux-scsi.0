From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: tcm IBMVSCSIS driver
Date: Mon, 01 Nov 2010 14:46:56 -0700
Message-ID: <1288648016.7708.42.camel@haakon2.linux-iscsi.org>
References: <20101029143536R.fujita.tomonori@lab.ntt.co.jp>
	 <1288479943.21870.55.camel@haakon2.linux-iscsi.org>
	 <20101101215109E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46053 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0KAVwC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 17:52:02 -0400
In-Reply-To: <20101101215109E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, joel.becker@oracle.com

On Mon, 2010-11-01 at 21:56 +0900, FUJITA Tomonori wrote:
> On Sat, 30 Oct 2010 16:05:43 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > One final question in that regard is in your ibmvscsis_queuecommand()
> > code, only INQUIRY, REPORT_LUNS, and MODE_SENSE need to be handled
> > specially for other non Linux VIO SRP Initiator guests on the other
> > end..
> 
> INQUIRY and REPORT_LUNS need the special responses. Otherwise the
> initiators can't see the logical units.
> 

There also appears to be a bunch of magic bits set for MODE_SENSE as
well and seems to indicate a hard requirement for legacy non linux
guests, yes..?

Also wrt to the internal REPORT_LUNs emuation, is it just the LUN
encoding that is specific to ibmvscsis..?  I am wondering if can just
add a operation TCM fabric module TFO op for individual struct
se_lun->unmapped_lun -> REPORT_LUN payload encode, and drop this
internal emulation code.

Thanks!

--nab

> 
> > I would like to break this out (if possible) into individual
> > specialized CDB fields / bits if possible so these special cases so we
> > can drop excess emulation code in ibmvscsis.c.  This means we could
> > (eventually) allow TCM/IBMVSCSIS to utilize the SPC-3+ emulation bits in
> > INQUIRY for high level PR/ALUA emulation using SCSI_PROTOCOL_SRP for the
> > EVPD=0x83 case.
> > 
> > So then perhaps this is more a question for brking and the POWER IBM
> > folks.  Of the three CDBs in IBMVSCSIS (INQUIRY, REPORT_LUNS, and
> > MODE_SENSE) that we are expecting to be done internally to fabric module
> > code, are there any other specific bits you need set..?  Are there in
> > any bits/fields in the code below that can not *not* be set..?

