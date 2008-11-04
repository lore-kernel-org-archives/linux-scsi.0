From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: 2.6.27 and good_bytes -= scsi_get_resid(cmd)
Date: Wed, 05 Nov 2008 00:04:50 +0100
Message-ID: <1225839890.15241.5.camel@localhost.localdomain>
References: <20081103215014.GA20035@xs4all.net>
	 <491008B2.5030605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2334 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYKDXFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 18:05:05 -0500
In-Reply-To: <491008B2.5030605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Tue, 2008-11-04 at 10:32 +0200, Boaz Harrosh wrote:
> Miquel van Smoorenburg wrote:
> > I upgraded to 2.6.27 on a machine with the dpt_i2o scsi driver and
> > I'm seeing some weird number from iostat -x 2. Basically it thinks
> > that the size of every request is 32640 sectors (0xff0000 bytes),
> > and that throws off the stats considerably.

[... dpt_i2o.c patch ...]

> Why does the readl(reply+5) does not return the same number as
> scsi_bufflen(cmd). This is the real problem. 

You're right, ofcourse. Thanks. I had a good look over the code and
reply+5 is wrong. It should be reply + 5*sizeof(u32). In the same
function all other values read from an offset which is a multiple of 4,
which I should have noticed earlier I guess.

I'll send a new patch in a seperate mail.

Mike.

