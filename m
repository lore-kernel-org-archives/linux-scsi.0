From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: AIC7xxx kernel problem with 2.4.2[234] kernels
Date: 19 Jan 2004 12:21:50 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1074532919.1895.32.camel@mulgrave>
References: <400BDC85.8040907@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <400BDC85.8040907@wanadoo.es>
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2004-01-19 at 08:32, Xose Vazquez Perez wrote:
> It looks like the _kernel_ driver is going to be without a maintainer
> unless somebody works on it, porting ADAPTEC fixes/features to the kernel driver.

As I told you in private email, this is *not* the way I see it.  At the
moment, Ataptec is the maintainer of that driver unless they choose
formally to relinquish it.

There is a glimmering of a resolution of the problem in an early
notification API for command timeouts.

Although throwing away successful completions when error recovery is in
progress isn't a bug (scsi commands are either idempotent or non
retryable), it's certainly not ideal.  I'm thinking about a better
framework where we would quiesce the device but pull back from
activating the eh thread if all commands return.  This would also fix
the tag starvation issue that many drivers tackle independently too.

James
