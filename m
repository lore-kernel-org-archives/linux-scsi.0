From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 14:53:46 +0100
Message-ID: <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:39134 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYBDNxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 08:53:48 -0500
Received: by wr-out-0506.google.com with SMTP id c48so1501093wra.23
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2008 05:53:47 -0800 (PST)
In-Reply-To: <47A7049A.9000105@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Feb 4, 2008 1:27 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>
> So, James, what is your opinion on the above? Or the overall SCSI target
> project simplicity doesn't matter much for you and you think it's fine
> to duplicate Linux page cache in the user space to keep the in-kernel
> part of the project as small as possible?

It's too early to draw conclusions about performance. I'm currently
performing more measurements, and the results are not easy to
interpret. My plan is to measure the following:
* Setup: target with RAM disk of 2 GB as backing storage.
* Throughput reported by dd and xdd (direct I/O).
* Transfers with dd/xdd in units of 1 KB to 1 GB (the smallest
transfer size that can be specified to xdd is 1 KB).
* Target SCSI software to be tested: IETD iSCSI via IPoIB, STGT iSCSI
via IPoIB, STGT iSER, SCST iSCSI via IPoIB, SCST SRP, LIO iSCSI via
IPoIB.

The reason I chose dd/xdd for these tests is that I want to measure
the performance of the communication protocols, and that I am assuming
that this performance can be modeled by the following formula:
(transfer time in s) = (transfer setup latency in s) + (transfer size
in MB) / (bandwidth in MB/s). Measuring the time needed for transfers
with varying block size allows to compute the constants in the above
formula via linear regression.

One difficulty I already encountered is that the performance of the
Linux IPoIB implementation varies a lot under high load
(http://bugzilla.kernel.org/show_bug.cgi?id=9883).

Another issue I have to look further into is that dd and xdd report
different results for very large block sizes (> 1 MB).

Bart Van Assche.
