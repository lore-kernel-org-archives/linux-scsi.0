From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 1 Feb 2008 10:08:28 +0100
Message-ID: <e2e108260802010108h4595040aq236db9c6d0476571@mail.gmail.com>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
	 <47A1EE54.6000005@vlnb.net>
	 <1201799660.11265.121.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310940s5a6e963cva6c106a82388065f@mail.gmail.com>
	 <1201803339.11265.166.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.248]:44809 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756546AbYBAJIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 04:08:31 -0500
Received: by hs-out-2122.google.com with SMTP id 54so889366hsz.5
        for <linux-scsi@vger.kernel.org>; Fri, 01 Feb 2008 01:08:30 -0800 (PST)
In-Reply-To: <1201803339.11265.166.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Jan 31, 2008 7:15 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>
> I meant small referring to storage on IB fabrics which has usually been
> in the research and national lab settings, with some other vendors
> offering IB as an alternative storage fabric for those who [w,c]ould not
> wait for 10 Gb/sec copper Ethernet and Direct Data Placement to come
> online.  These types of numbers compared to say traditional iSCSI, that
> is getting used all over the place these days in areas I won't bother
> listing here.

InfiniBand has several advantages over 10 Gbit/s Ethernet (the list
below probably isn't complete):
- Lower latency. Communication latency is not only determined by the
latency of a switch. The whole InfiniBand protocol stack was designed
with low latency in mind. Low latency is really important for database
software that accesses storage over a network.
- High-availability is implemented at the network layer. Suppose that
a group of servers has dual-port network interfaces and is
interconnected via a so-called dual star topology, With an InfiniBand
network, failover in case of a single failure (link or switch) is
handled without any operating system or application intervention. With
Ethernet, failover in case of a single failure must be handled either
by the operating system or by the application.
- You do not have to use iSER or SRP to use the bandwidth of an
InfiniBand network effectively. The SDP (Sockets Direct Protocol)
makes it possible that applications benefit from RDMA by using the
very classic IPv4 Berkeley sockets interface. An SDP implementation in
software is already available today via OFED. iperf reports 470 MB/s
on single-threaded tests and 975 MB/s for a performance test with two
threads on an SDR 4x InfiniBand network. These tests were performed
with the OFED 1.2.5.4 SDP implementation. It is possible that future
SDP implementations will perform even better. (Note: I could not yet
get iSCSI over SDP working.)

We should leave the choice of networking technology open -- both
Ethernet and InfiniBand have specific advantages.

See also:
InfiniBand Trade Association, InfiniBand Architecture Specification
Release 1.2.1, http://www.infinibandta.org/specs/register/publicspec/

Bart Van Assche.
