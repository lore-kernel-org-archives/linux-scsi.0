From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Wed, 04 Sep 2002 11:24:19 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200209041624.g84GOJC02683@localhost.localdomain>
References: <jeremy@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: Message from Jeremy Higdon <jeremy@classic.engr.sgi.com>
   of "Wed, 04 Sep 2002 00:40:26 PDT." <10209040040.ZM49716@classic.engr.sgi.com>
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

jeremy@classic.engr.sgi.com said:
> For example, in Fibrechannel using class 3 (the usual)

> 	send command (command frame corrupted; device does not receive)
> 	send barrier (completes normally)
> 	... (lots of time goes by, many more commands are processed)
> 	timeout original command whose command frame was corrupted 

This doesn't look right to me from the SCSI angle  I don't see how you can get 
a successful disconnect on a command the device doesn't receive (I take it 
this is some type of Fibre magic?).  Of course, if the device (or its proxy) 
does receive the command then the ordered queue tag implementation requires 
that the corrupted frame command be processed prior to the barrier,  this 
isn't optional if you obey the spec.  Thus, assuming the processor does no 
integrity checking of the command until it does processing (this should be a 
big if), then we still must get notification of the failed command before the 
barrier tag is begun.  Obviously, from that notification we do then race to 
eliminate the overtaking tags.

> There was also the problem of the queue full to the barrier command,
> etc. 

The queue full problem still exists.  I've used this argument against the 
filesystem people many times at the various fora where it has been discussed.  
The situation is that everyone agrees that it's a theoretical problem, but 
no-one is convinced that it will actually occur in practice (I think it falls 
into the "risk we're willing to take" category).

James
