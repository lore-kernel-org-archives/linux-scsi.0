From: Dave Boutcher <sleddog@us.ibm.com>
Subject: Re: [PATCH] ibmvscsi driver (private)
Date: Tue, 10 Feb 2004 10:47:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <opr25x89jjl6e53g@us.ibm.com>
References: <opr232htwdl6e53g@us.ibm.com> <1076363704.1804.48.camel@mulgrave>  <opr25llojql6e53g@us.ibm.com> <1076428747.1804.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:6574 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265933AbUBJQrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 11:47:25 -0500
In-Reply-To: <1076428747.1804.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On 10 Feb 2004 10:59:06 -0500, James Bottomley 
<James.Bottomley@SteelEye.com> wrote:
> But the question still remains: why not use nbd?  That can project the
> block devices over any transport from one node to another.  A good
> reason might be that you need more capability than nbd provides (it
> doesn't support handoff of ioctls for instance).

The two main reasons are (a) not requiring a TCP/IP stack and associated 
configuration, and (b) the desire to support any SCSI device, including 
writable optical devices, tape, etc.  The goal is to put a RedHat/SuSE CD 
in the (perhaps virtual) CD driver and do a normal install to a (virtual) 
disk.

> Secondly, even if you do this in the SCSI stack, why not follow the nbd
> approach: that's client partly at user level and party in kernel with
> server purely at user level.  You could still do the rdma handoff in the
> client, and we'd have something that could be network encapsulated as
> well.
For the client side, I'm not sure I see a good reason for pushing up to 
user level.  With Christoph's comments, the code is getting even simpler 
than before and there is no RDMA on the client side.  For the server side, 
I think that will be part of the discussion.

Converging this with other network protocols is probably only interesting 
if/when there are other RDMA interfaces.

> Your server code is this, isn't it:
>
> http://source.scl.ameslab.gov:14690//linux-2.4/anno/drivers/scsi/ibmvscsis.c@1.3?nav=index.htmlsrc/|src/drivers|src/drivers/scsi
>
> Well, yes, there will be a huge fight over that.  You are essentially
> only doing what nbd does, since you expect to attach any block device
> and translate the SCSI commands internally.

Yup, that's the server code.  It's not as pretty as I would like.  When I 
post it I am going to be very open minded about tearing it up and starting 
over.

Thanks for the comments, by the way.

Dave B
