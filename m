From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 18 Feb 2008 12:01:27 +0100
Message-ID: <e2e108260802180301o5c376024t72e649a9debd5157@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <47A89660.1080804@Voltaire.COM>
	 <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>
	 <47B95343.9060802@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.239]:64847 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbYBRLB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 06:01:29 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1287829wxd.4
        for <linux-scsi@vger.kernel.org>; Mon, 18 Feb 2008 03:01:28 -0800 (PST)
In-Reply-To: <47B95343.9060802@Voltaire.COM>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@voltaire.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Feb 18, 2008 10:43 AM, Erez Zilber <erezz@voltaire.com> wrote:
> If you use a high value for FirstBurstLength, all (or most) of your data
> will be sent as unsolicited data-out PDUs. These PDUs don't use the RDMA
> engine, so you miss the advantage of IB.

Hello Erez,

Did you notice the e-mail Roland Dreier wrote on Februari 6, 2008 ?
This is what Roland wrote:
> I think the confusion here is caused by a slight misuse of the term
> "RDMA".  It is true that all data is always transported over an
> InfiniBand connection when iSER is used, but not all such transfers
> are one-sided RDMA operations; some data can be transferred using
> send/receive operations.

Or: data sent during the first burst is not transferred via one-sided
remote memory reads or writes but via two-sided send/receive
operations. At least on my setup, these operations are as fast as
one-sided remote memory reads or writes. As an example, I obtained the
following numbers on my setup (SDR 4x network);
ib_write_bw: 933 MB/s.
ib_read_bw: 905 MB/s.
ib_send_bw: 931 MB/s.

Bart Van Assche.
