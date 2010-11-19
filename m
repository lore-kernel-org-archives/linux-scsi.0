From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] [PATCH 8/19]: SCST SYSFS interface implementation
Date: Fri, 19 Nov 2010 19:01:18 +0100
Message-ID: <AANLkTi=j_DPpRfKUYGG6oe2c6qKryyceoSFTN=pCtpqC@mail.gmail.com>
References: <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com>
 <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com>
 <4CE16B8E.1000300@panasas.com> <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
 <8985DEAF-4227-4629-B90A-938D2BA3534E@etechsoft.com> <4CE2846C.6070501@vlnb.net>
 <4CE59482.3050002@gmail.com> <20101118214619.GA29097@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32998 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab0KSSBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 13:01:40 -0500
In-Reply-To: <20101118214619.GA29097@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Vladislav Bolkhovitin <vvvvvst@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, Nov 18, 2010 at 10:46 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 19, 2010 at 12:02:58AM +0300, Vladislav Bolkhovitin wrote=
:
>> Since nobody objected, Greg, could you consider to ACK SCST SYSFS
>> management interface in /sys/kernel/scst_tgt/, please? Please find t=
he
>> SCST SYSFS ABI documentation file you requested below.
>
> No, sorry, again, you should not be using kobjects, and do not pollut=
e
> the main /sys/kernel/ namespace with this.
>
> Use 'struct device' please, that is what it is there for, and is what
> the rest of the kernel is using. =A0And use the rest of the
> driver/bus/device infrastructure as your model will work with it just
> fine.
>
> Yes, I know you said you didn't think you could use it, and that your
> code was different than everyone elses, but I still do not believe it=
,
> sorry.

Hello Greg,

As you can see in recent messages (e.g.
http://lkml.org/lkml/2010/11/18/578 or
http://lkml.org/lkml/2010/11/15/296), the abstractions represented in
SCST are:
* Target templates (scst_tgt_template), e.g. scst_local or ib_srpt.
These are drivers that implement a storage protocol.
* Target ports (scst_tgt), e.g. ib_srpt_target_0, which represent a
communication interface controlled by a storage protocol driver.
* Sessions (scst_session), e.g. 0x00000000000000000002c9030005f34b. A
session corresponds to a single initiator-target nexus.
* Device handlers (scst_dev_type), e.g. scst_disk or scst_vdisk, which
are drivers that allow SCST to export storage.
* Target devices (scst_device), e.g. disk01, which represent exported
storage. Each instance is controlled by a single device handler. This
concept includes e.g. block devices and files. Some but not all target
devices have a corresponding device node in /dev.
* Access control groups (scst_acg), which allow e.g. to implement LUN m=
asking.
* Device-specific information such as the SCSI LUN (scst_acg_dev).

As we all know the driver, bus and device abstractions were invented
to model how peripheral devices are connected to a system. What a
storage target does is the converse - define devices and make it
possible for other systems to use these devices. As a result,
unfortunately, the driver, bus and device abstractions do not map
one-to-one on all of the concepts used in a storage target. So I'm
still not sure whether it is a good idea to use the driver, bus and
or/device concepts for all of the above concepts.

Also, using the driver, bus or device concept for one or more of the
storage target concepts would open up a potential for naming
conflicts. There is already e.g. the well-known null device. SCST e.g.
defines a vdisk_nullio target template. Having these all as device
nodes under /dev might not only confuse users but also creates a huge
potential for naming conflicts. That's why we prefer separate
namespaces instead of reusing one of the existing concepts.

In case you are still convinced that we should use the existing
driver, bus and device abstractions, which concept should we map to
which abstraction ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
