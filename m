From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Thu, 15 Jul 2010 07:27:40 -0700
Message-ID: <20100715142740.GA17005@kroah.com>
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
	<m1zkxtinlw.fsf@fess.ebiederm.org>
	<201007150929.03916.konrad@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
Content-Disposition: inline
In-Reply-To: <201007150929.03916.konrad@kernel.org>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Sender: alsa-devel-bounces@alsa-project.org
Errors-To: alsa-devel-bounces@alsa-project.org
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org, Kay Sievers <kay.sievers@vrfy.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, David Howells <dhowells@redhat.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Andrew Morton <akpm@linux-foundation.org>, Dave Airlie <airlied@gmail.com>, Stephen Hemminger <shemminger@vyatta.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 15, 2010 at 09:29:01AM -0400, Konrad Rzeszutek Wilk wrote:
> 
> > > and the box still won't boot.
> >
> > The reason FC6 doesn't boot is there is a userspace tool
> > I believe in the initrd that cares about symlinks when it should
> > not.
> 
> It is not just nash. Also multipathd would fail (as it expects 
> the /sys/scsi_host/..<something> in certain directories), and 'lsscsi'. There 
> might be other tools that depend on libsysfs to be affected by this as well.

No tool should use libsysfs, that code broke a _long_ time ago.  Do you
know of anything using it?

> Oh, and I think 'udev' might have some trouble too - but not 100% certain 
> about that.

Heh, no udev works just fine :)

So basically, it's just the block links that are being affected, so that
might let me narrow down the code covered by the depreciated option.

thanks,

greg k-h
