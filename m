From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Sample implementation of a scheme to handle missing interrupts
Date: Mon, 28 Jul 2008 13:01:36 -0600
Message-ID: <660360F4F2570145BD872F298951B17A3AC7E178@cosmail03.lsi.com>
References: <20080728055622.GB18026@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62117 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYG1TBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 15:01:52 -0400
In-Reply-To: <20080728055622.GB18026@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Sunday, July 27, 2008 11:56 PM, Matthew Wilcox wrote:

> There has been some discussion recently (both on the mailing
> list and at
> OLS) of MSI and it reminded me of a perennial problem that I have with
> sym2.  When interrupts don't work, I often get the bug
> reports, because
> the user seems sym2 spewing error messages right before the panic when
> it fails to mount their root filesystem.
>

In my case, the MSI problem will manifest itself well before we bind with the scsi midlayer.    Meaning when there is a MSI problem, we can't even bring up the card.  Hence adding code in a eh_timed_out callback handler would be meaningless in solving our problem. What I need to do is find a problematic card, so I can verify some things.   My beliefs are that all the doorbell request at driver load time work becuase we are polling with interrupts masked.  The first command sent with interrupts enabled would be SendPortEnable.  If we have a timeout after calling mpt_handshake_req_reply_wait, we resend the port enable with MSI turned off, right?

Eric
