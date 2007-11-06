From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [0/3] Last 3 patches for bidi support
Date: Tue, 06 Nov 2007 20:04:26 +0200
Message-ID: <4730ACAA.2060007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12990 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753359AbXKFSLn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 13:11:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>


[1]
I propose a small change to scsi_tgt_lib.c that will make
tgt completely neutral to the scsi_data_buffer patch. And will
make it all that more ready for bidi, too. TOMO is this OK?

(Can you do without the GFP_KERNEL allocation flag? It could
make the code a bit more simple)

[2]
scsi_data_buffer patch. 
As requested by TOMO the all patch is squashed into one, 600 
and some lines. TOMO if it makes you happy, OK, here it is.

There is one hunk from libsrp.c that I really hate. and from what 
I understand of the code, only the "request_bufflen =" is really used, 
All users of "request_buffer = addr" pass NULL, as far as I can see.
If you would like to make me happy, and it is at all possible, please 
clean it.

[3]
Once scsi_data_buffer is in, then scsi bidi support can be applied. 
(Block bidi was already merged 3 kernels ago). It makes no changes
to scsi_cmnd and only adds some, not-at-all-dangerous, code to scsi_lib.
So I don't see any reason to wait. please all review.

If ACKed by all parties and applied for inclusion for 2.6.25, 
then they will have a long time to sit in MM and collect
compilation breakage reports from ARCHs we never compiled.

I wish these make everybody happy this time

Boaz Harrosh

