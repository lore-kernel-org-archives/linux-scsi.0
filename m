From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 16 Nov 2010 16:17:32 +0300
Message-ID: <4CE2846C.6070501@vlnb.net>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com> <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com> <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Williams <richard@etechsoft.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

(Since this discussion goes to a quite fundamental scope, I let myself
to add Joel Becker and Linus Torvalds on CC)

Richard Williams, on 11/16/2010 02:59 PM wrote:
> I'm just an outsider - but maybe my perspective has value - it seems
> there are two sides to this debate:
> 
> 1) sysfs is great for scst due to certain stability concerns and code
> concerns
> 2) sysfs is bad for scst due to the intended role of sysfs
> and its namespace

Your questions are very good, so let's summarize what we need to serve
the needs of a SCSI target subsystem (not necessary SCST) and see what
can fit them.

So, the needs:

1. Be capable to represent to user space internal configuration to let
user space be able to see and analyze it, including various statistics.

2. Let user space manage the internal configuration.

3. Desired: possibility to send to user space events about important
internal actions, like I/O failures, which may need user space
intervention to recover, like switching from active to passive role in a
cluster.

So, what can we do with ConfigFS:

(1): Only partially, because by design ConfigFS isn't supposed to
represent internal configuration, it can only manage it. Extending
ConfigFS to be capable to do that would be, in my understanding, a
strong violation of its purpose and, hence, design and if went this way
eventually ConfigFS would become just a duplication of the SYSFS
functionality.

(2): ConfigFS can do that. This is exactly for what it was designed and
implemented. But in this particular application it would have some
limitations derived from (1): to manage harware-related entries a user
should magically know from somewhen names of those entries to create
them by "mkdir" command.

For instance, consider a user has a Fibre Channel HBA and want to use it
in the target mode. Before he can configure it, he should somehow know
its ports names and for each of them run:

# mkdir /sys/kernel/config/.../50:50:00:00:00:00:00:11
# mkdir /sys/kernel/config/.../50:50:00:00:00:00:00:12
...

where 50:50:00:00:00:00:00:1x are the ports' names. Only after that
those ports appear on the ConfigFS and can be managed.

(3): No events at all.

Now consider SYSFS:

(1): Easily. This is exactly for what it was designed and implemented.

(2): Possible without any limitations and side effects.

(3): Also possible.

So, why not use SYSFS if it suits all the needs _without_ any additional
effort and patches?

Other alternatives? A set of custom IOCTLs? One more configuration FS? I
believe, those would be quite disgusting for all.

> Maybe I misunderstand - But if both sides have merit then wouldn't a
> compromise be appropriate?
> 
> Maybe the sensical compromise is to use sysfs code to create a new
> namespace that would fit this purpose?  It seems that I am also
> hearing that the alternatives to sysfs aren't always adequate - so
> why not use sysfs, but have a place where it's appropriate to use it?

This is exactly what we are proposing: to use SYSFS in additional
namespace /sys/kernel/scst_tgt.

As far as I can see, only Greg is against it. Greg keeps his reasons
private, so I can only guess that Greg is against extending usage of
SYSFS (note, _usage_, not implementation! Everything needed long ago
implemented.) beyond the scope it was originally designed around 10
years ago. But SYSFS is already widely used this way in the kernel, as
Joe illustrated, hence there is demand for it. People need it. So, why
not to just acknowledge this fact and go ahead the simplest and most
useful for both users and developers way?

Thanks,
Vlad
