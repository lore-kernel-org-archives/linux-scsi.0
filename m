From: "Paul Grun" <pgrun@systemfabricworks.com>
Subject: RE: srp_transport: Fix atttribute registration race
Date: Sun, 13 Nov 2011 14:46:55 -0800
Message-ID: <000301cca256$279057c0$76b10740$@com>
References: <201110211857.23622.bvanassche@acm.org> <1320053608.8283.29.camel@dabdike> <CAO+b5-oxshsL7Dm7vhv4zC8m0P4dG3iNzxU9sdbi5cBkAnTpMQ@mail.gmail.com> <045e01cca1bb$3dee1070$b9ca3150$@systemfabricworks.com> <20111113215523.GA6117@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:59416 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403Ab1KMWzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2011 17:55:24 -0500
Received: from cdptpa-bc-oedgelb.mail.rr.com ([10.127.134.103])
          by cdptpa-bc-qmta01.mail.rr.com with ESMTP
          id <20111113225357918.VBJK6456@cdptpa-bc-qmta01.mail.rr.com>
          for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2011 22:53:57 +0000
In-Reply-To: <20111113215523.GA6117@ornl.gov>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dave Dillow' <dillowda@ornl.gov>, 'Bill Boas' <bboas@systemfabricworks.com>
Cc: 'Bart Van Assche' <bvanassche@acm.org>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, 'Fujita Tomonori' <fujita.tomonori@lab.ntt.co.jp>, 'Brian King' <brking@linux.vnet.ibm.com>, 'Roland Dreier' <roland@purestorage.com>

Thanks for the suggestions. The problem turned out to be much more
pedestrian...the destination MAC ID of packets being injected into the long
distance link was wrong and thus many packets were being dropped.  We
haven't gotten back to trying to run RC over the long distance link.  I
understand the issues with running SRP over UC, and don't expect to do that.
Thanks again,
-Paul Grun


> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Dave Dillow
> Sent: Sunday, November 13, 2011 1:55 PM
> To: Bill Boas
> Cc: 'Bart Van Assche'; 'James Bottomley'; linux-scsi@vger.kernel.org;
> linux-rdma@vger.kernel.org; 'Fujita Tomonori'; 'Brian King'; 'Roland
> Dreier'
> Subject: Re: srp_transport: Fix atttribute registration race
> 
> On Sat, Nov 12, 2011 at 11:18:04PM -0500, Bill Boas wrote:
> > Bart, James, Dave,
> >
> > At SC we are running a video streaming demo across a 7000 mile fiber
> > distance using IB extension boxes from Bay Microsystems at 40 Gbps. The
> > video streaming app uses SRP to transmit the streams across this long
> > distance link. Performance is not all what we would have hoped. We think
> > that because SRP uses RC mode between initiator and target that it is
> the RC
> > behavior over this distance that is impacting performance. Are any of
> you
> > aware of an SRP implementation that uses UC mode.
> 
> SRP uses RDMA, so you cannot use UC mode.
> 
> Your problem sounds a lot like issues we saw when starting to run over
> 100m+ optical cables; IIRC it required increasing the credits available
> the link. You should contact Jason Gunthorpe or Makia Minnich. Makia was
> involved in that investigation at ORNL, but Jason may also be able to tell
> you off the top of his head.
> 
> Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

