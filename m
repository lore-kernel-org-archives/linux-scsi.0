From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix read capacity for large disks when CONFIG_LBD=n
	(updated)
Date: Tue, 04 Jan 2005 11:45:56 -0600
Message-ID: <1104860756.5327.50.camel@mulgrave>
References: <05Jan4.115956est.332208@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:14286 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261726AbVADRqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 12:46:10 -0500
In-Reply-To: <05Jan4.115956est.332208@cyborg.cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-04 at 11:59 -0500, Tony Battersby wrote:
> If CONFIG_LBD=n, then sd_read_capacity computes the capacity of a large
> disk on a 32-bit platform as 1 + 0xffffffff = 0.  Make it 0xffffffff
> instead.

Actually, I don't think this is at all a good idea.  Not allowing a LBD
device to be configured if the user hasn't enabled LBD (which is
accidentally what the current code does) seems better to me.

Imagine a 4TB fs.  Plug it in to a system like this and you're going to
corrupt it because you can't see half the disc.

James


