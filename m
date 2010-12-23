From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] [SCSI] scst: Move SCST device documentation to Documentation/ABI
Date: Thu, 23 Dec 2010 12:33:53 +0100
Message-ID: <AANLkTikLTnCCGTUKs=81LbhCFXUmxWmcW67ijKQ=ahmx@mail.gmail.com>
References: <201012222144.47522.bvanassche@acm.org> <201012222146.28782.bvanassche@acm.org>
 <20101223002053.GA7475@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52022 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0LWLeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 06:34:14 -0500
Received: by iwn9 with SMTP id 9so6076063iwn.19
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2010 03:34:13 -0800 (PST)
In-Reply-To: <20101223002053.GA7475@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, realrichardsharpe@gmail.com, scst-devel@lists.sourceforge.net

(resending as plain text)

On Thu, Dec 23, 2010 at 1:20 AM, Greg KH <gregkh@suse.de> wrote:
>
> On Wed, Dec 22, 2010 at 09:46:28PM +0100, Bart Van Assche wrote:
> > Move the documentation about the sysfs attributes of the SCST
> > virtual device to Documentation/ABI/stable.
> >
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Vladislav Bolkhovitin <vst@vlnb.net>
> > ---
> > =A0Documentation/ABI/stable/sysfs-devices-scst | =A0150 +++++++++++=
++++++++++++++++
> > =A0Documentation/scst/README.scst =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =
71 -------------
> > =A02 files changed, 150 insertions(+), 71 deletions(-)
> > =A0create mode 100644 Documentation/ABI/stable/sysfs-devices-scst
> >
> > diff --git a/Documentation/ABI/stable/sysfs-devices-scst b/Document=
ation/ABI/stable/sysfs-devices-scst
> > new file mode 100644
> > index 0000000..80bc258
> > --- /dev/null
> > +++ b/Documentation/ABI/stable/sysfs-devices-scst
> > @@ -0,0 +1,150 @@
> > +What: =A0 =A0 =A0 =A0 =A0 /sys/devices/scst/mgmt
>
> How did you get a file into this directory? =A0Are you sure that's
> acceptable? =A0Same for the other files you added here.

Hello Greg,

All that was needed to create the entry /sys/devices/scst/mgmt was to
call device_register() for the device with the name "scst" and
device_create_file() for the attribute called "mgmt". We are not aware
of any documentation that disallows creating files there. So whether
or not creating a file there is acceptable is something we can't know
if the kernel maintainers do not speak up.

> > +Date: =A0 =A0 =A0 =A0 =A0 December 2010
> > +KernelVersion: =A02.6.38
>
> Really? =A0That's pretty presumptious, isn't it?
>
> > +Contact: =A0 =A0 =A0 =A0linux-scsi@vger.kernel.org
>
> Why not the "owner" of this code, not the scsi mailing list.
>
> > +Description:
> > + =A0 =A0 =A0 =A0 =A0 =A0 Interface through which SCST management c=
ommands can be issued.
>
> You mix tabs and spaces above and in all of your other files. =A0Plea=
se
> make them only tabs.

Will address the above comments.

> > + =A0 =A0 =A0 =A0 =A0 =A0 The documentation of the syntax of these =
commands can be
> > + =A0 =A0 =A0 =A0 =A0 =A0 obtained by reading this file:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 # cat mgmt
> > + =A0 =A0 =A0 =A0 =A0 =A0 in device/<dev> <dev_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in device_driver/<devt> <devt_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in target_driver/<tgtt> <tgtt_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in target_driver/<tgtt>/<target>/luns <tg=
t_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in target_driver/<tgtt>/<target>/luns <lu=
ns_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in target_driver/<tgtt>/<target>/ini_grou=
ps <acg_mgmt_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in target_driver/<tgtt>/<target>/ini_grou=
ps/<acg> <acg_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in target_driver/<tgtt>/<target>/ini_grou=
ps/<acg>/luns <luns_cmd>
> > + =A0 =A0 =A0 =A0 =A0 =A0 in target_driver/<tgtt>/<target>/ini_grou=
ps/<acg>/initiators <acg_ini_cmd>
>
> What? =A0sysfs is one value per file, why would the mgmt file return =
more
> than one line? =A0That's not acceptable, sorry.

As far as I understood the sysfs philosophy, the intention of the one
value per file rule is to avoid that software reading data from sysfs
files has to parse what it reads. The above data is documentation only
and is not intended to be parsed by software. So that file could be
left empty, but that would not be very helpful for users who configure
SCST by issuing shell commands instead of using the scstadmin tool.
I'm not sure though how to proceed here.

> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 dev_cmd syntax:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 set_filename <filename>
> > + =A0 =A0 =A0 =A0 =A0 =A0 set_threads_num <n>
> > + =A0 =A0 =A0 =A0 =A0 =A0 set_thread_pool_type <thread_pool_type>
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 devt_cmd syntax:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 add_device device_name [parameters]
> > + =A0 =A0 =A0 =A0 =A0 =A0 del_device device_name
> > + =A0 =A0 =A0 =A0 =A0 =A0 add_attribute <attribute> <value>
> > + =A0 =A0 =A0 =A0 =A0 =A0 del_attribute <attribute> <value>
> > + =A0 =A0 =A0 =A0 =A0 =A0 add_device_attribute device_name <attribu=
te> <value>
> > + =A0 =A0 =A0 =A0 =A0 =A0 del_device_attribute device_name <attribu=
te> <value>
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 devt_cmd syntax for pass-through device t=
ypes:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 add_device H:C:I:L
> > + =A0 =A0 =A0 =A0 =A0 =A0 del_device H:C:I:L
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 tgtt_cmd syntax:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 add_target target_name [parameters]
> > + =A0 =A0 =A0 =A0 =A0 =A0 del_target target_name
> > + =A0 =A0 =A0 =A0 =A0 =A0 add_attribute <attribute> <value>
> > + =A0 =A0 =A0 =A0 =A0 =A0 del_attribute <attribute> <value>
> > + =A0 =A0 =A0 =A0 =A0 =A0 add_target_attribute target_name <attribu=
te> <value>"
> > + =A0 =A0 =A0 =A0 =A0 =A0 del_target_attribute target_name <attribu=
te> <value>"
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 where parameters is one or more <name>=3D=
<value> pairs separated by ';'
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 tgt_cmd syntax:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 enable
> > + =A0 =A0 =A0 =A0 =A0 =A0 disable
> > + =A0 =A0 =A0 =A0 =A0 =A0 set_cpu_mask <mask>
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 luns_cmd syntax:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 add|del H:C:I:L lun [parameters]
> > + =A0 =A0 =A0 =A0 =A0 =A0 add VNAME lun [parameters]
> > + =A0 =A0 =A0 =A0 =A0 =A0 del lun
> > + =A0 =A0 =A0 =A0 =A0 =A0 replace H:C:I:L lun [parameters]
> > + =A0 =A0 =A0 =A0 =A0 =A0 replace VNAME lun [parameters]
> > + =A0 =A0 =A0 =A0 =A0 =A0 clear
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 where parameters is either 'read_only' or=
 empty.
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 acg_mgmt_cmd syntax:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 create <group_name>
> > + =A0 =A0 =A0 =A0 =A0 =A0 del <group_name>
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 acg_cmd syntax:
> > + =A0 =A0 =A0 =A0 =A0 =A0 set_cpu_mask <mask>
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 acg_ini_cmd syntax:
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 add <initiator_name>
> > + =A0 =A0 =A0 =A0 =A0 =A0 del <initiator_name>
> > + =A0 =A0 =A0 =A0 =A0 =A0 move <initiator_name> <dest_group_name>
> > + =A0 =A0 =A0 =A0 =A0 =A0 clear
>
> That's quite complex, are you sure it's correct, and actually describ=
es
> it in a manner that anyone else can use?

More detailed documentation of these commands is present in
Documentation/scst/README.scst. Should that documentation be moved to
Documentation/ABI/stable/sysfs-devices-scst too ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
