From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH v2] scsi:libiscsi: Hold back_lock when calling
 iscsi_complete_task
Date: Thu, 7 Mar 2019 17:48:29 -0800
Message-ID: <20190308014829.GD68002@straylight.hirudinean.org>
References: <20190225174130.29496-1-leeman.duncan@gmail.com>
 <20190306182349.GB68002@straylight.hirudinean.org>
 <88c1457c-7831-3341-1c63-11eb82244c4b@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <88c1457c-7831-3341-1c63-11eb82244c4b@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 07, 2019 at 05:37:50PM -0800, Lee Duncan wrote:
> On 3/6/19 10:23 AM, Chris Leech wrote:
> > On Mon, Feb 25, 2019 at 09:41:30AM -0800, Lee Duncan wrote:
> >> From: Lee Duncan <lduncan@suse.com>
> >>
> >> If there is an error queueing an iscsi command in
> >> iscsi_queuecommand(), for example if the transport fails
> >> to take the command in sessuin->tt->xmit_task(), then
> >> the error path can call iscsi_complete_task() without
> >> first aquiring the back_lock as required. This can
> >> lead to things like ITT pool can get corrupt, resulting
> >> in duplicate ITTs being sent out.
> >>
> >> The solution is to hold the back_lock around
> >> iscsi_complete_task() calls, and to add a little commenting
> >> to help others understand when back_lock must be held.
> >>
> >> Signed-off-by: Lee Duncan <lduncan@suse.com>
> >> ---
> > 
> > Lee,
> > 
> > Quick question, can you confirm that you tested this with lockdep?
> > 
> > It seems right to me, it's just that we've been hit with lockdep
> > problems dealing with these locks before.
> > 
> > - Chris
> 
> I'm glad you asked, to keep me honest -- I had not done it yet, because
> it seemed obvious to me.
> 
> But I did check today, and did not find any deadlock nor leaks. I was
> testing on a 5.0.0-1 kernel.

Thanks!

Acked-by: Chris Leech <cleech@redhat.com>
