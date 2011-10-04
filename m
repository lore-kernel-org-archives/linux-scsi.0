From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] [SCSI] libsas panic when single phy disabled on a wide port
Date: Tue, 4 Oct 2011 16:30:54 -0700
Message-ID: <CAA9_cmdAx7pw-2scX=mYP=i4zpAH+fAF-0WNM4cg97Ng6xFNAw@mail.gmail.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
	<1316691000.10571.6.camel@dabdike>
	<FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com>
	<A94E3BEBF01D46D5B15046388D9F7DE7@usish.com.cn>
	<CAA9_cmdq455AZJUPNdjCrn7JT90AXZtZbGGejcpLDX3zYfu+2A@mail.gmail.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE711@XYUS-EX22.xyus.xyratex.com>
	<FC1F9E38C0703341A1A750524E2525A9018AE726@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33848 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677Ab1JDXaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2011 19:30:55 -0400
Received: by qadb15 with SMTP id b15so822476qad.19
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2011 16:30:54 -0700 (PDT)
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE726@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <jbottomley@parallels.com>

On Mon, Oct 3, 2011 at 8:58 AM, Mark Salyzyn
<mark_salyzyn@us.xyratex.com> wrote:
> I am talking to myself ;->. Dan (et al), I inspected deeper and I
> *think* I see the culprit in sas_deform_port().

Thanks Mark, some notes below to help the investigation...

>
> Could the problem be that the code should have been refactored to:
>
> + =A0 =A0 =A0 BUG_ON(!phy->port);
> =A0 =A0 =A0 =A0sas_port_delete_phy(phy->port, phy->phy);
> - =A0 =A0 =A0 if (phy->port->num_phys =3D=3D 0)
> + =A0 =A0 =A0 if (phy->port->num_phys =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_port_delete(phy->port);
> - =A0 =A0 =A0 phy->port =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy->port =3D NULL;
> + =A0 =A0 =A0 }
>
> And also fixed up is sas_ex_discover_end_dev() at out_err (this is on
> soft territory, need to dig into sas_port_delete):
>
> =A0out_free:
> - =A0 =A0 =A0 sas_port_delete(phy->port);
> + =A0 =A0 =A0 =A0 if (phy->port->num_phys =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_port_delete(phy->port);
> =A0out_err:
> - =A0 =A0 =A0 phy->port =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0phy->port =3D NULL;
> + =A0 =A0 =A0 =A0 }

I think we are ok in this case because we checked for wide port
membership before entering this routine, so the number of phys could
only ever be 1 at this point, right?

>
> And finally in sas_prot.c at sas_deform_port() (simplified, I still v=
iew
> this as split-brained though):
>
> =A0 =A0 =A0 =A0if (port->num_phys =3D=3D 1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (dev && gone)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev->gone =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_unregister_domain_devices(port);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_port_delete(port->port);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port->port =3D NULL;
> - =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 } else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sas_port_delete_phy(port->port, phy->p=
hy);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (si->dft->lldd_port_deformed=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 si->dfp=
->lldd_port_deformed(phy);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (si->dft->lldd_port_deformed)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0si->dft->lldd_port_deformed(phy);
>
> =A0 =A0 =A0 =A0spin_lock_irqsave(&sas_ha->phy_port_lock, flags);
> =A0 =A0 =A0 =A0spin_lock(&port->phy_list_lock);
>
> =A0 =A0 =A0 =A0list_del_init(&phy->port_phy_el);
> =A0 =A0 =A0 =A0phy->port =3D NULL;
> =A0 =A0 =A0 =A0port->num_phys--;
> =A0 =A0 =A0 =A0port->phy_mask &=3D ~(1U << phy->id);
>
> =A0 =A0 =A0 =A0if (port->num_phys =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0INIT_LIST_HEAD(&port->phy_list);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(port->sas_addr, 0, SAS_ADDR_SIZ=
E);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(port->attached_sas_addr, 0, SAS=
_ADDR_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port->class =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port->iproto =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port->tproto =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port->oob_mode =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port->phy_mask =3D 0;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&port->phy_list_lock);
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
>
> =A0 =A0 =A0 =A0return;
>
> The way I see it, sas_deform_port() is the culprit that is clearing o=
ut
> phy->port when the num_phys is equal to two, falling through and
> decrementing the count one more time.

That initially looked convincing... but on closer look
sas_port_delete_phy is reducing the number of phys in the transport
class representation of the port (struct sas_port), while the
decrement that sas_deform port is doing is operating the on the
host-local port (struct asd_sas_port).

What is your reproduction scenario for this bug?  We see this in our
larger topology hotplug tests, but I don't think we have a simple
reproducer.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
