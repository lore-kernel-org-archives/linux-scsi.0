From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 08/14] isci: kill iphy->isci_port lookups
Date: Mon, 23 Jan 2012 15:45:12 -0800
Message-ID: <CAA9_cmc-pJ5x7C-v8DwHqn6WvdZNECS4rTAKBAmGhTMDLGvP1Q@mail.gmail.com>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
	<20120106005941.11464.12937.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38700 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2AWXpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2012 18:45:13 -0500
In-Reply-To: <20120106005941.11464.12937.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>, linux-ide@vger.kernel.org, David Milburn <dmilburn@redhat.com>

On Thu, Jan 5, 2012 at 4:59 PM, Dan Williams <dan.j.williams@intel.com>=
 wrote:
> This field is a holdover from the OS abstraction conversion. =A0The s=
table
> phy to port lookups are done via iphy->ownining_port under scic_lock.
> After this conversion to use port->lldd_port the only volatile lookup=
 is
> the initial lookup in isci_port_formed(). =A0After that point any loo=
kup
> via a successfully notified domain_device is guaranteed to be valid
> until the domain_device is destroyed.
>
> Delete ->start_complete as it is only set once and is set as a
> consequence of the port going link up, by definition of getting a por=
t
> formed event the port is "ready".
>
> While we are correcting port lookups also move the asd_sas_port table
> out from under the isci_port. =A0This is to preclude any temptation t=
o use
> container_of() to convert an asd_sas_port to an isci_port, the
> association is dynamic and under libsas control.
>
> Tested-by: Maciej Trela <maciej.trela@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[..]
> @@ -1714,24 +1721,55 @@ int isci_port_perform_hard_reset(struct isci_=
host *ihost, struct isci_port *ipor
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> -/**
> - * isci_port_deformed() - This function is called by libsas when a p=
ort becomes
> - * =A0 =A0inactive.
> - * @phy: This parameter specifies the libsas phy with the inactive p=
ort.
> - *
> - */
> =A0void isci_port_deformed(struct asd_sas_phy *phy)
> =A0{
> - =A0 =A0 =A0 pr_debug("%s: sas_phy =3D %p\n", __func__, phy);
> + =A0 =A0 =A0 struct isci_host *ihost =3D phy->ha->lldd_ha;
> + =A0 =A0 =A0 struct isci_port *iport =3D phy->port->lldd_port;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 /* we got a port notification on a port that was subseq=
uently
> + =A0 =A0 =A0 =A0* torn down and libsas is just now catching up
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!iport)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(&ihost->scic_lock, flags);
> + =A0 =A0 =A0 for (i =3D 0; i < SCI_MAX_PHYS; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iport->active_phy_mask & 1 << i)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_irqrestore(&ihost->scic_lock, flags);
> +
> + =A0 =A0 =A0 if (i >=3D SCI_MAX_PHYS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(&ihost->pdev->dev, "%s: port: %=
ld\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, iport - &ihos=
t->ports[0]);
> =A0}

As spotted by David this causes 32-bit build breakage.  I'll fold in
the fix, rebase, and re-post for the next round of libsas fixups.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
