From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4.21 fix race condition in sg.c
Date: 27 Jun 2003 09:10:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056723054.1825.16.camel@mulgrave>
References: <002901c33cb3$4b262730$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:42502 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264308AbTF0N4u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 09:56:50 -0400
In-Reply-To: <002901c33cb3$4b262730$e0019d89@cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: marcelo@conectiva.com.br, Alan Cox <alan@lxorguk.ukuu.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dougg@torque.net

On Fri, 2003-06-27 at 08:52, Tony Battersby wrote:
> Note: I have added smp_wmb() since the last time I sent this patch.  I think
> it is necessary for 100% correctness.

Actually, I don't believe it is.  memory barriers are only needed if the
code cares about the ordering of the write.  Either for externally
visible ordering (like MMIO to a device, or other CPU visibility in SMP)
or for internal consistency to prevent gcc reordering the writes to give
states that could be temporarily bogus.

I don't believe any of the above applies to the sg request pointer done
flag.

Memory barriers can be expensive on some architectures, so it's best to
use them only where necessary.

James






