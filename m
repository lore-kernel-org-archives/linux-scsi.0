From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH] [RFC] sd: make error handling more robust
Date: Fri, 1 Feb 2008 05:44:11 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4396ED518@ADPE2K703.adaptec.com>
References: <387599.14710.qm@web31814.mail.mud.yahoo.com>
 <830195.4171.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:35832 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765594AbYBANoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 08:44:14 -0500
In-Reply-To: <830195.4171.qm@web31808.mail.mud.yahoo.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mike Snitzer <snitzer@gmail.com>, "ltuikov@yahoo.com" <ltuikov@yahoo.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tony Battersby <tonyb@cybernetics.com>

Serendipity, been working an issue for the past week where error reporting from aacraid's HARDWARE_ERROR when an array was marked DEAD in the Adapter was not propagating to MD. The trigger for this investigation was "AACRAID driver broken in 2.6.22.x (and beyond?) [WAS: Re: 2.6.22.16 MD raid1 doesn't mark removed disk faulty, MD thread goes UN]" as authored my Mike Snitzer.

I had attacked this yesterday by setting the deferred bit (0xF1) rather than invalidating the sense data (0x70) in the LLD (Patch to the aacraid would be forthcoming following some testing). The Valid bit in the SCSI layer sometimes (too many kernels, I am talking generically) throws away all the content and keys of the sense data, at least deferred appears to report that the info does not accompany the sense data.

The change needs to be SCSI compliant and possibly endure back-porting to other kernels. So where are we going to put this, in each respective LLD (invalidating info, but not the keys), in sd.c (where the bad_lba is calculated) or in scsi_error.c (where the info field is picked up)?

Sincerely -- Mark Salyzyn
