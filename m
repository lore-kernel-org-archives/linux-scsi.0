From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: linux-2.4.18-modified-scsi-h.patch
Date: Tue, 19 Nov 2002 10:40:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021119104004.A21438@eng2.beaverton.ibm.com>
References: <Pine.LNX.4.10.10211182138310.2779-200000@master.linux-ide.org> <3DDA0E63.9050307@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3DDA0E63.9050307@torque.net>; from dougg@torque.net on Tue, Nov 19, 2002 at 09:11:47PM +1100
To: Douglas Gilbert <dougg@torque.net>, Andre Hedrick <andre@pyxtechnologies.com>
Cc: "J. E. J. Bottomley" <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 19, 2002 at 09:11:47PM +1100, Douglas Gilbert wrote:
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

So we should name it the same in 2.4 as in 2.5: upper_private_data, not
trace_ptr (thought it should really have been sr_upper_private_data,
like all the other fields in scsi_request).

I don't see why we need the #define, or is that another patch?

-- Patrick Mansfield
