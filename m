From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Mon, 15 Nov 2010 22:03:36 -0800
Message-ID: <1289887416.22107.159.camel@haakon2.linux-iscsi.org>
References: <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
	 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net>
	 <20101112012315.GE17097@core.coreip.homeip.net> <4CDEC8D2.8080101@vlnb.net>
	 <20101113235938.GA1827@kroah.com>
	 <AANLkTi=PxYi8kCsAxbopUHBC+=2QPuoEcojdqugS88sH@mail.gmail.com>
	 <20101115184422.GA9566@kroah.com> <4CE19A94.8080504@vlnb.net>
	 <20101115221359.GA9530@kroah.com>  <4CE210D3.5060703@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49409 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab0KPGIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 01:08:51 -0500
In-Reply-To: <4CE210D3.5060703@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bvanassche@acm.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>, Joel Becker <joel.becker@oracle.com>

On Mon, 2010-11-15 at 21:04 -0800, Joe Eykholt wrote:
> 
> On 11/15/10 2:13 PM, Greg KH wrote:
> > On Mon, Nov 15, 2010 at 11:39:48PM +0300, Vladislav Bolkhovitin wrote:
> >> Greg KH, on 11/15/2010 09:44 PM wrote:
> >> > On Mon, Nov 15, 2010 at 06:45:24PM +0100, Bart Van Assche wrote:
> >> >> On Sun, Nov 14, 2010 at 12:59 AM, Greg KH <greg@kroah.com> wrote:
> >> >>>
> >> >>> On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
> >> >>>> So, I decided to reimplement it to be completely synchronous. SYSFS
> >> >>>> authors did really great job and thanks to the excellent internal SYSFS
> >> >>>> design and implementation it is absolutely safe. See:
> >> >>>>
> >> >>>> [root@tgt ~]# modprobe scst
> >> >>>> [root@tgt ~]# cd /sys/kernel/scst_tgt/
> >> >>>
> >> >>> Sorry, but no, you can't put this in /sys/kernel/ without getting the
> >> >>> approval of the sysfs maintainer.
> >> >>>
> >> >>> I really don't understand why you are using kobjects in the first place,
> >> >>> why isn't this in the main device tree in the kernel, using 'struct
> >> >>> device'?
> >> >>
> >> >> We might have missed something, but as far as we know it has not yet
> >> >> been explained in this thread why using 'struct device' would be an
> >> >> advantage over using 'struct kobject'.
> >> >
> >> > It's very simple.
> >> >
> >> > You want your device to show up in the global device tree in the kernel,
> >> > not off to one side, unconnected to anything else.
> >> >
> >> > Please use 'struct device', it is what you want to do here.
> >>
> >> But we don't have any device to show up in the global device tree!
> > 
> > Not true at all.
> > 
> >> We don't have any devices in the struct device's understanding at all!
> > 
> > Then create them just like you are doing so for your kobject use.
> > 
> > The first device would be the root one, and then everything trickles
> > down from there.
> > 
> > And use configfs for your configuration stuff, that's what it is there
> > for, and if it doesn't somehow work properly for you, please work with
> > the configfs developers to fix that up.
> > 
> > thanks,
> > 
> > greg k-h
> 

Greetings Joe,

> I don't have any opinion on the above, but I don't see why sysfs can't be
> used for configuration as well as its other roles. It seems to me wasteful
> to require configfs to be used in order to change configuration when
> sysfs works fine for this.
> 
> Here are a couple of existing examples where sysfs is used in a role that
> would seem similar to SCST's usage:
> 
> 1) scsi_transport_fc already has an sysfs file, fc_host/vport_create, which
> can be written to create new fc_host and scsi_host instances.
> 
> 2) fcoe.ko uses a write to the sysfs file /sys/module/fcoe/parameters/create
> to start the protocol on a particular ethernet interface.  There's another
> file for destroy.
> 
> I'll bet there are other examples in other subsystems, and I don't think
> there is anything wrong with the above usages of sysfs.
> 
> I agree with Vladislav's point that configfs doesn't work instead of sysfs
> because configs doesn't make it easy for the kernel side to create nodes for
> dynamic information like connected initiators and statistics.

I disagree that conversion of 'demo mode' struct se_node_acls to explict
userspace syscall driven configfs registered struct
se_node_acl->acl_group is overly complex, or otherwise difficult in
context of a configfs consumer for a transition demo mode -> explict
NodeACL via:

mkdir -p /sys/kernel/config/target/$FABRIC/$WWN/$TPGT/acls/$INITIATOR_WWPN.

Note the current v4.0 code supports this for LIO-Target and TCM/FC
fabric module code, and will just work 'out of the box' for v4.0
compatible fabric modules using target_core_fabric_configfs.c logic.

As for statistics point, this is also currently handled by TCM in struct
se_node_acl in target_core_mib.c:scsi_auth_intr_seq_show() for both
explict NodeACL and TPG context 'demo-mode' generated struct se_node_acl
attached to a struct se_portal_group fabric endpoint.

> So, if the above examples are considered a misuse of sysfs,
> SCST would need to use both sysfs and configfs.  It would use configfs to
> do configuration, and sysfs to display and access the dynamic information
> like connected initiators.  That seems a minor role for configfs,
> which is easily handled in sysfs as SCST currently does.
> 
> Just my two cents.
> 

I think the question is more along the lines of: does sysfs have a hard
requirement for target mode using native TCM/ConfigFS logic.?.  Early in
the development of TCM/LIO v3.0 I thought that driving creation of
configfs struct_groups from kernel code was in fact useful for my own
development and for future mainline code, but with the help of foresight
of jlbec, gregkh and others with our modern v4.0 code I am no longer
convinced we need any direct kernel level interaction between native
v4.0 target mode configfs code and existing sysfs code.

So far using interpreted userspace python/shell code has served this
purpose really quite well in terms of interaction between target mode
configfs and existing sysfs design, and I do not currently see any
inherient limitations from a userspace code driven persective for a full
native configfs target implementation.  I would be happy to be proven
wrong on this point, but so far the original decision to drive target
mode completely from userspace with native configfs code has in fact
proven to be a better decision than a hybrid kernel level configfs +
sysfs implementation from the perspective of the userspace developer
driving /sys/kernel/config/target/* code.

So on this basis I am currently not interested in moving TCM/LIO code
away from a native configfs control plane for the v4.0 release, but I am
happy to discuss positive benefits that a hybrid implementation can
potentially provide to our existing TCM/LIO userspace ecosystem.

Best,

--nab

