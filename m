From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] FC pass through support - revised III
Date: Wed, 12 Nov 2008 11:58:36 +0900
Message-ID: <20081112115900T.fujita.tomonori@lab.ntt.co.jp>
References: <B125BA56-8293-4C42-AEBC-0C0DCAC365D0@qlogic.com>
	<20081111184216Q.fujita.tomonori@lab.ntt.co.jp>
	<D9222461-3AC2-438D-9DB1-63F12DB244C1@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46986 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYKLC7G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 21:59:06 -0500
In-Reply-To: <D9222461-3AC2-438D-9DB1-63F12DB244C1@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Tue, 11 Nov 2008 06:47:17 -0800
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> >> +	if (!copy_size)
> >> +		goto pt_error3;
> >> +
> >> +	/* Check for room in outstanding command list. */
> >> +	handle = req->current_outstanding_cmd;
> >> +	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
> >> +		handle++;
> >> +		if (handle == MAX_OUTSTANDING_COMMANDS)
> >> +			handle = 1;
> >> +		if (!req->outstanding_cmds[handle])
> >> +			break;
> >> +	}
> >
> > Hmm, needs to check the index overflow here?
> I think I've missed your point, here.
> Could you please elaborate a bit further?

I meant that you need to check index after the loop like this:

+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+	if (index == MAX_OUTSTANDING_COMMANDS)
+		goto handle_error;

qla2xxx and qla1280 drivers do the similar thing.

