From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Qlogic FC driver(s)
Date: Wed, 07 May 2003 18:24:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB9334B.7020409@cri74.org>
References: <995FF289C9D69747A09E42992644595405B2372F@penguin.adic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:23748 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S264116AbTEGQMK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 12:12:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: brian.auld@adic.com
Cc: linux-scsi@vger.kernel.org



brian.auld@adic.com a =E9crit:
> Hello,
>=20
> Can someone in the 'know' comment on the differences/background as to=
 why there is a Qlogic Fibre Channel driver in the kernel tree and a se=
parate driver released by qlogic.=20
>=20
> Is one preferable over the other?
>=20
> I'm doing some iSCSI target driver work. I have an FC target driver a=
s a reference that was superimposed on top of the qlogic intitiator dri=
ver found in the kernel tree (as opposed to glogic). I want to make sur=
e this base driver (kernel tree vs. qlogic) is the preferred choice bef=
ore proceeding.=20
>=20

Hello Brian,

There are a lot of differences between the kernel one and the Qlogic=20
official driver.
The first one is based on an old driver, it's not really maintained.
I can't use it when I use FC switch in F_port.

The official Qlogic driver works betten in my opinion, but it's not=20
integrated because of specific coding not accepted by scsi maintainer :

Here is what Christoph Hellwig said :


=46irst thing is of course to actually port the driver to 2.5-CURRENT, =
there's
no way it'll get into 2.4 before 2.5.

The it needs some massaging into an actual linux driver:

* remove typedef abuse
* remove #ifdef abuse.  The current driver is ifdef hell at it's best.
   examples:

#ifdef UNIQUE_FW_NAME
unsigned short fw2300ip_version =3D 3*1024+1;
#else
unsigned short risc_code_version =3D 3*1024+1;
#endif

   just always use the unique name, it can't harm

#if QLA2X_PERFORMANCE

   WTF?  Either your performance changes work and can always be enabled
   or you should remove them from a submitted driver.
   The useful remaining options should be turned into CONFIG_* symbols
   for use with the kernel config tools.

* the source file organization is a mess.  Don't ever include c files
   in other c files.  Reorganize the code into qla2100/qla2200/qla2300
   specific sources and common sources instead of the ifdef mess and
   turn the shared code into a library module (e.g. qla2x00.ko)

* don't delcare the host template in a header but as normal struct,
   see the many 2.5 driver that underwent that change (i.e. aic7xxx)

Second there's a bunch of functional changes that need to be done:

* Convert to the new pci API and scsi_add_host/scsi_remove_host for
   proper PCI hotplug support.
* Remove failover/multipath support.  It has been frequently stated
   multipathing for linux schould be handle in the driver-independant
   later, like the merged md-level support or IBM's scsi midlayer
   MP patches.
* Don't use deprecated functions like check_region :)
* Use proper abstraction instead of version checking hell in the
   source files.  I.e. the many occurances of

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
         spin_lock_irq(&io_request_lock);
#else
	spin_lock_irq(ha->host->host_lock);
#endif

   should be hidden behing a proper wrapper.
* scsi_block_requests/scsi_unblock_requests instead of queueing command=
s
   yourself in ->queuecommand if the port stated is "dead" and remove
   much of the then obsolete queueing code.


Janitoral stuff:

* there seems to be lots of missing error return checks (i.e.=20
copy_from_user)
* rename kmem_zalloc or just use kmalloc directly - Linux 2.5 already h=
as
   a kmem_zalloc (in XFS)

I guess there's some more stuff that can be found once the driver is in
a saner shape, but the list is already huge enough 8)




--=20
=46abien SALVI      Centre de Ressources Informatiques
                   Archamps, France -- http://www.cri74.org
                   PingOO GNU/linux distribution : http://www.pingoo.or=
g

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
