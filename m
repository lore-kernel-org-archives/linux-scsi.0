From: Andre Hedrick <andre@pyxtechnologies.com>
Subject: Re: linux-2.4.18-modified-scsi-h.patch
Date: Tue, 19 Nov 2002 04:16:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10211190350490.371-100000@master.linux-ide.org>
References: <3DDA0E63.9050307@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DDA0E63.9050307@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: "J. E. J. Bottomley" <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 19 Nov 2002, Douglas Gilbert wrote:

> Andre Hedrick wrote:
> > Greetings Doug et al.
> > 
> > Please consider the addition of this simple void ptr to the scsi_request
> > struct.  The addition of this simple void pointer allows one to map any
> > and all request execution caller the facility to search for a specific
> > operation without having to run in circles.  Hunting for these details
> > over the global device list of all HBA's is silly and one of the key
> > reasons why there error recovery path is so painful.
> > 
> > 
> > Scsi_Request    *req = sc_cmd->sc_request;
> > blah_blah_t     *trace = NULL;
> > 
> > trace = (blah_blah_t *)req->trace_ptr;
> > 
> > 
> > Therefore the specific transport invoking operations via the midlayer will
> > have the ablity to track and trace any operation.
> 
> Andre,
> No need to convince me: I have already put a similar pointer
> in that structure in lk 2.5 (for either sd, st, sr or sg to use).
> In sg case's it saved some ugly looping in (what was formerly
> called) the bottom half handler. Sounds like your motivation is
> similar.
> 
> Doug Gilbert

Hey there!

Well it needs to be in all kernels regardless, and if it is in the
scsi_request it is transparent to any given personality device and the
caller may reserve the option to include other key information.  Simple
stats of what the queue depth of a given device is and a means to flush
out the commands to force a failure in the case of calling a device reset.

Without being to obvious or rude about the driver model being top down and
not the converse, hunting for given set of operation(s) will almost insure
a driver/device deadlock when racing against the done function.

I am pleased you and I are thinking in the same direction again!

Cheers,

Andre Hedrick, CTO & Founder 
iSCSI Software Solutions Provider
http://www.PyXTechnologies.com/


