From: Douglas Gilbert <dougg@torque.net>
Subject: Re: linux-2.4.18-modified-scsi-h.patch
Date: Tue, 19 Nov 2002 21:11:47 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DDA0E63.9050307@torque.net>
References: <Pine.LNX.4.10.10211182138310.2779-200000@master.linux-ide.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@pyxtechnologies.com>
Cc: "J. E. J. Bottomley" <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andre Hedrick wrote:
> Greetings Doug et al.
> 
> Please consider the addition of this simple void ptr to the scsi_request
> struct.  The addition of this simple void pointer allows one to map any
> and all request execution caller the facility to search for a specific
> operation without having to run in circles.  Hunting for these details
> over the global device list of all HBA's is silly and one of the key
> reasons why there error recovery path is so painful.
> 
> 
> Scsi_Request    *req = sc_cmd->sc_request;
> blah_blah_t     *trace = NULL;
> 
> trace = (blah_blah_t *)req->trace_ptr;
> 
> 
> Therefore the specific transport invoking operations via the midlayer will
> have the ablity to track and trace any operation.

Andre,
No need to convince me: I have already put a similar pointer
in that structure in lk 2.5 (for either sd, st, sr or sg to use).
In sg case's it saved some ugly looping in (what was formerly
called) the bottom half handler. Sounds like your motivation is
similar.

Doug Gilbert


