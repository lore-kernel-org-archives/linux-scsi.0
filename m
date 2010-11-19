From: Vladislav Bolkhovitin <vvvvvst@gmail.com>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 19 Nov 2010 21:00:42 +0300
Message-ID: <4CE6BB4A.5060606@gmail.com>
References: <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com> <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com> <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com> <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com> <4CE2846C.6070501@vlnb.net> <4CE59482.3050002@gmail.com> <20101118214619.GA29097@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101118214619.GA29097@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Richard Williams <richard@etechsoft.com>, Bart Van Assche <bvanassche@acm.org>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Hannes Reinecke <hare@suse.de>, Andy Yan <ayan@marvell.com>, Andrew Morton <akpm@linux-foundation.org>, Vu Pham <vuhuong@mellanox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Greg KH, on 11/19/2010 12:46 AM wrote:
> On Fri, Nov 19, 2010 at 12:02:58AM +0300, Vladislav Bolkhovitin wrote:
>> Since nobody objected, Greg, could you consider to ACK SCST SYSFS
>> management interface in /sys/kernel/scst_tgt/, please? Please find the
>> SCST SYSFS ABI documentation file you requested below.
> 
> No, sorry, again, you should not be using kobjects, and do not polute
> the main /sys/kernel/ namespace with this.

Which other namespace should we "polute" then?

> Use 'struct device' please, that is what it is there for, and is what
> the rest of the kernel is using. And use the rest of the
> driver/bus/device infrastructure as your model will work with it just
> fine.

Greg, sorry, I don't understand your requirements and, because of this,
we can't go ahead implementing them. Could you explain your position,
please?

None of the SCST objects are Linux devices. None of them has entries in
/dev, none of them needs to send any events to udev and none of them
sends or receives data from DMA, hence has any DMA parameters or
restrictions. So, how can them fit into the driver/bus/device model you
are enforcing?

For instance:

 - struct sgv_pool (/sys/kernel/scst_tgt/sgv/<cache>) is an SG vectors
cache. Isn't it a nonsense to make it device?

 - struct scst_acg
(/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/)
is an access control group to define which initiators see which LUNs
from target <target>. Same, isn't it a nonsense to make it device?

 - struct scst_acn
(/sys/kernel/scst_tgt/targets/<target_driver>/<target>/ini_groups/<group>/initiators/<initiator_name>)
is an entry in the access control group <group> to define which
initiators should use group <group>. Again, isn't it a nonsense to make
it device?

Etc.

How could they fit in the driver/bus/device model?

I guess, your confusion comes from word "device" you see in the SCST
SYSFS tree and SCST supposed to work with "devices" and "dev handlers"?
But those devices are not Linux devices, they are just objects to couple
initiators' requests and backstorage which stores data.

In other words, SCST devices are just redirection points passing
incoming requests to Linux files and devices.

SCST devices are the same as NFS exported directories. Do you believe,
that struct device must be created for each NFS export?

In the cases when we need to present SCST devices as Linux devices we
use scst_local driver [1], which performs it exactly as you requesting,
i.e. doing:

root_device_register()
bus_register()
driver_register()
...

> Yes, I know you said you didn't think you could use it, and that your
> code was different than everyone elses, but I still do not believe it,
> sorry.

What can we do to make you believe it? Shall we write a document
describing all SCST objects and their relationship between each other?
(Although looks like you haven't read even detailed docs we already
written...)

Our position is based on careful study of all possible alternatives and
10+ years of Linux kernel development.

SCST is being developed for 7+ years and, despite of not being mainline,
has proved those years being the right way to go, not the mainline STGT
which was chosen 5 years ago as the right way, but now we are
considering to replace it.

Sorry, but we have an impression that you are judging without seeing the
full picture. Isn't it a duty of a subsystem's maintainer to see full
picture before deciding if it's good or bad?

We appreciate your effort reviewing SCST and willing to make all the
needed actions to help you.

The world of SCSI targets is pretty complex (I have been studying it for
7+ years), hence SCST is very big (20K LOC only core) and hard to
understand. But is it a sufficient reason to force to convert elegant,
nice and carefully thought design into something ugly, hardly usable and
hardly maintainable? If we do it, that wouldn't make SCST simpler to
review. Opposite, it would make it HARDER to review.

Thanks,
Vlad

[1] Patch for scst_local you can find in http://lkml.org/lkml/2010/10/1/131)
