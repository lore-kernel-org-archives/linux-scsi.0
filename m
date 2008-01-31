From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Thu, 31 Jan 2008 08:48:26 +0100
Message-ID: <e2e108260801302348h5c139da3r7ec262cd48e956@mail.gmail.com>
References: <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <e2e108260801300510q94bf9c8g31a0ba9d77c3c0b9@mail.gmail.com>
	 <20080130225428S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:18073 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbYAaHs1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 02:48:27 -0500
Received: by rv-out-0910.google.com with SMTP id k20so467584rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 23:48:26 -0800 (PST)
In-Reply-To: <20080130225428S.tomof@acm.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Jan 30, 2008 2:54 PM, FUJITA Tomonori <tomof@acm.org> wrote:
> On Wed, 30 Jan 2008 14:10:47 +0100
> "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
>
> > On Jan 30, 2008 11:56 AM, FUJITA Tomonori <tomof@acm.org> wrote:
> > >
> > > Sorry, I can't say. I don't know much about iSER. But seems that Pete
> > > and Robin can get the better I/O performance - line speed ratio with
> > > STGT.
> >
> > Robin Humble was using a DDR InfiniBand network, while my tests were
> > performed with an SDR InfiniBand network. Robin's results can't be
> > directly compared to my results.
>
> I know that you use different hardware. I used 'ratio' word.

Let's start with summarizing the relevant numbers from Robin's
measurements and my own measurements.

Maximum bandwidth of the underlying physical medium: 2000 MB/s for a
DDR 4x InfiniBand network and 1000 MB/s for a SDR 4x InfiniBand
network.

Maximum bandwidth reported by the OFED ib_write_bw test program: 1473
MB/s for Robin's setup and 933 MB/s for my setup. These numbers match
published ib_write_bw results (see e.g. figure 11 in
http://www.usenix.org/events/usenix06/tech/full_papers/liu/liu_html/index.html
or chapter 7 in
http://www.voltaire.com/ftp/rocks/HCA-4X0_Linux_GridStack_4.3_Release_Notes_DOC-00171-A00.pdf)

Throughput measured for communication via STGT + iSER to a remote RAM
disk via direct I/O with dd: 800 MB/s for writing and 751 MB/s for
reading in Robin's setup, and 647 MB/s for writing and 589 MB/s for
reading in my setup.

>From this we can compute the I/O-performance to ib_write_bw bandwidth:
54 % for writing and 51 % for reading in Robin's setup, and 69 % for
writing and 63 % for reading in my setup. Or a slightly better
utilization of the bandwidth in my setup than in Robin's setup. This
is no surprise -- the faster a communication link is, the harder it is
to use all of the available bandwidth.

So why did you state that in Robin's tests the I/O performance to line
speed ratio was better than in my tests ?

Bart Van Assche.
