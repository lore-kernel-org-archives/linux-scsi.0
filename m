From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: Qlogic FC driver(s)
Date: Wed, 7 May 2003 13:47:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41EBA11203419D4CA8EB4C6140D8B40101021118@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:35221 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S264279AbTEGUgV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 16:36:21 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>, brian.auld@adic.com
Cc: linux-scsi@vger.kernel.org

The official Qlogic driver 6.x has been qualified by numerous OEMs and =
ourselves in multi-node SANs environments.  We have a 2.5 kernel driver=
 which will soon be available on Soureforge. It contains the suggestion=
s that was made by the scsi maintainers and alot more. Feel free to pla=
y around with it and send us your suggestions.   =20

>>-----Original Message-----
>>From: Fabien Salvi [mailto:fabien@cri74.org]
>>Sent: Wednesday, May 07, 2003 9:25 AM
>>To: brian.auld@adic.com
>>Cc: linux-scsi@vger.kernel.org
>>Subject: Re: Qlogic FC driver(s)
>>
>>
>>
>>
>>brian.auld@adic.com a =E9crit:
>>> Hello,
>>>=20
>>> Can someone in the 'know' comment on the=20
>>differences/background as to why there is a Qlogic Fibre=20
>>Channel driver in the kernel tree and a separate driver=20
>>released by qlogic.=20
>>>=20
>>> Is one preferable over the other?
>>>=20
>>> I'm doing some iSCSI target driver work. I have an FC=20
>>target driver as a reference that was superimposed on top of=20
>>the qlogic intitiator driver found in the kernel tree (as=20
>>opposed to glogic). I want to make sure this base driver=20
>>(kernel tree vs. qlogic) is the preferred choice before proceeding.=20
>>>=20
>>
>>Hello Brian,
>>
>>There are a lot of differences between the kernel one and the Qlogic=20
>>official driver.
>>The first one is based on an old driver, it's not really maintained.
>>I can't use it when I use FC switch in F_port.
>>
>>The official Qlogic driver works betten in my opinion, but it's not=20
>>integrated because of specific coding not accepted by scsi=20
>>maintainer :
>>
>>Here is what Christoph Hellwig said :
>>
>>
>>First thing is of course to actually port the driver to=20
>>2.5-CURRENT, there's
>>no way it'll get into 2.4 before 2.5.
>>
>>The it needs some massaging into an actual linux driver:
>>
>>* remove typedef abuse
>>* remove #ifdef abuse.  The current driver is ifdef hell at it's best=
=2E
>>   examples:
>>
>>#ifdef UNIQUE_FW_NAME
>>unsigned short fw2300ip_version =3D 3*1024+1;
>>#else
>>unsigned short risc_code_version =3D 3*1024+1;
>>#endif
>>
>>   just always use the unique name, it can't harm
>>
>>#if QLA2X_PERFORMANCE
>>
>>   WTF?  Either your performance changes work and can always=20
>>be enabled
>>   or you should remove them from a submitted driver.
>>   The useful remaining options should be turned into CONFIG_* symbol=
s
>>   for use with the kernel config tools.
>>
>>* the source file organization is a mess.  Don't ever include c files
>>   in other c files.  Reorganize the code into qla2100/qla2200/qla230=
0
>>   specific sources and common sources instead of the ifdef mess and
>>   turn the shared code into a library module (e.g. qla2x00.ko)
>>
>>* don't delcare the host template in a header but as normal struct,
>>   see the many 2.5 driver that underwent that change (i.e. aic7xxx)
>>
>>Second there's a bunch of functional changes that need to be done:
>>
>>* Convert to the new pci API and scsi_add_host/scsi_remove_host for
>>   proper PCI hotplug support.
>>* Remove failover/multipath support.  It has been frequently stated
>>   multipathing for linux schould be handle in the driver-independant
>>   later, like the merged md-level support or IBM's scsi midlayer
>>   MP patches.
>>* Don't use deprecated functions like check_region :)
>>* Use proper abstraction instead of version checking hell in the
>>   source files.  I.e. the many occurances of
>>
>>#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
>>         spin_lock_irq(&io_request_lock);
>>#else
>>	spin_lock_irq(ha->host->host_lock);
>>#endif
>>
>>   should be hidden behing a proper wrapper.
>>* scsi_block_requests/scsi_unblock_requests instead of=20
>>queueing commands
>>   yourself in ->queuecommand if the port stated is "dead" and remove
>>   much of the then obsolete queueing code.
>>
>>
>>Janitoral stuff:
>>
>>* there seems to be lots of missing error return checks (i.e.=20
>>copy_from_user)
>>* rename kmem_zalloc or just use kmalloc directly - Linux 2.5=20
>>already has
>>   a kmem_zalloc (in XFS)
>>
>>I guess there's some more stuff that can be found once the=20
>>driver is in
>>a saner shape, but the list is already huge enough 8)
>>
>>
>>
>>
>>--=20
>>Fabien SALVI      Centre de Ressources Informatiques
>>                   Archamps, France -- http://www.cri74.org
>>                   PingOO GNU/linux distribution :=20
http://www.pingoo.org

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
