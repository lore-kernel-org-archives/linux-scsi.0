From: Tejun Heo <tj@kernel.org>
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Date: Sat, 27 Aug 2011 15:20:44 +0200
Message-ID: <20110827132044.GN2632@htj.dyndns.org>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
 <20110825101602.GI3286@htj.dyndns.org>
 <4E58C3BD.3000609@hitachi.com>
 <20110827102655.GJ2632@htj.dyndns.org>
 <4E58E905.4020704@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E58E905.4020704@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hello, Nao.

On Sat, Aug 27, 2011 at 09:54:29PM +0900, Nao Nishijima wrote:
> > Hmm... I don't follow.  Why wouldn't it be able to?  All the
> > informations are in the log.  It is messy but it's there.  If you want
> 
> In many cases, the script is able to convert the name. However there is
> the special case that the logs do not exist in memory and disk due to
> the crash except console.

Sorry but I still don't get it.  If you can extract the log, the
information is there and w/ remote logging (be it via serial or
network), the information always has to be there.  Are you talking
about the case where somehow only the video console somehow succeeds
to print out oops?  I don't think that's a common case as serial (also
on IPMI) tends to be pretty robust, often more robust than vide
output, and even when such case occurs, the only thing you want is
mapping kernel device name to more recognizable information, which
isn't difficult at all.  If you wanna do it in a really simple manner,
just save udisks --dump output after boot and each hotplug event and
write a simple script to search it.

> > more structured information, u{dev|disks} already maintain device
> > libarary - what maps to what, connected how with what attributes and
> > so on.  Sending them off to the log machine as device hotplug events
> > occur and consulting it when post-processing log message would work
> > fine.  All you need is just some python scripting.  I don't really see
> > much point in messing with device names directly.  The only thing is
> > that the raw log would be prettier.  I don't think that is useful
> > enough to justify changing kernel device names.
> 
> A kernel device names (e.g. sda) is not useful information because it
> doesn't always point the same disk at each boot-up time.

Eh?  What difference does that make?  Just make the target machines
send up-to-date disk config info to the log server.

> An alias is just an option and provides the ability to give all
> kernel devices a "preferred name".
> 
> By default, dev_printk's will show a kernel device name. They show an
> alias only when the user assigns a "preferred name" to an alias.
> Even if the persistend device name is used, the device names in logs are
> different from the name that the users are using. So, an alias helps the
> user identify the disk.

Yes, I do understand what it's doing and can see there can be cases it
can be somewhat useful but I still think it's too adhoc an approach
which doesn't really justify itself.  It just does too little to solve
the actual problem and even that 'little' part isn't very trivial - it
adds whole lot of policy decisions to make and I'm pretty sure it will
cause good amount of havoc w/ all the system tools which currently
don't expect block device names to change to some admin determined
free format string on the fly.

Thanks.

-- 
tejun
