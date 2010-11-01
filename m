From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: tcm IBMVSCSIS driver
Date: Mon, 1 Nov 2010 21:56:29 +0900
Message-ID: <20101101215109E.fujita.tomonori@lab.ntt.co.jp>
References: <20101029143536R.fujita.tomonori@lab.ntt.co.jp>
	<1288479943.21870.55.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38681 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab0KAM45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2010 08:56:57 -0400
In-Reply-To: <1288479943.21870.55.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, joel.becker@oracle.com

On Sat, 30 Oct 2010 16:05:43 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> One final question in that regard is in your ibmvscsis_queuecommand()
> code, only INQUIRY, REPORT_LUNS, and MODE_SENSE need to be handled
> specially for other non Linux VIO SRP Initiator guests on the other
> end..

INQUIRY and REPORT_LUNS need the special responses. Otherwise the
initiators can't see the logical units.


> I would like to break this out (if possible) into individual
> specialized CDB fields / bits if possible so these special cases so we
> can drop excess emulation code in ibmvscsis.c.  This means we could
> (eventually) allow TCM/IBMVSCSIS to utilize the SPC-3+ emulation bits in
> INQUIRY for high level PR/ALUA emulation using SCSI_PROTOCOL_SRP for the
> EVPD=0x83 case.
> 
> So then perhaps this is more a question for brking and the POWER IBM
> folks.  Of the three CDBs in IBMVSCSIS (INQUIRY, REPORT_LUNS, and
> MODE_SENSE) that we are expecting to be done internally to fabric module
> code, are there any other specific bits you need set..?  Are there in
> any bits/fields in the code below that can not *not* be set..?
