From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH v5 7/7] libsas: let libata recover links that fail to
 transmit initial sig-fis
Date: Sat, 14 Jan 2012 10:21:35 -0800
Message-ID: <CABE8wwvUtvHtq10s68XcMXRrKD2WiCEntOzU3kp_zrRTUfM2MQ@mail.gmail.com>
References: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
	<20120114181048.25887.56612.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:34344 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756150Ab2ANSVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 13:21:36 -0500
In-Reply-To: <20120114181048.25887.56612.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-ide@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>, Jack Wang <jack_wang@usish.com>

On Sat, Jan 14, 2012 at 10:10 AM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> libsas fails to discover all sata devices in the domain. =A0If a devi=
ce fails
> negotiation and does not transmit a signature fis the link needs reco=
very.
> libata already understands how to manage slow to come up links, so tr=
eat these
> conditions as ata device attach events for the purposes of creating a=
n
> ata_port. =A0This allows libata to manage retrying link bring up.
>
> Cc: Jack Wang <jack_wang@usish.com>
> Cc: Xiangliang Yu <yuxiangl@marvell.com>
> Cc: Luben Tuikov <ltuikov@yahoo.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
[..]
> =A0static int smp_ata_check_ready(struct ata_link *link)
> =A0{
> =A0 =A0 =A0 =A0int res;
> - =A0 =A0 =A0 u8 addr[8];
> =A0 =A0 =A0 =A0struct ata_port *ap =3D link->ap;
> =A0 =A0 =A0 =A0struct domain_device *dev =3D ap->private_data;
> =A0 =A0 =A0 =A0struct domain_device *ex_dev =3D dev->parent;
> =A0 =A0 =A0 =A0struct sas_phy *phy =3D sas_get_local_phy(dev);
> + =A0 =A0 =A0 struct ex_phy *ex_phy =3D &ex_dev->ex_dev.ex_phy[phy->n=
umber];
>
> - =A0 =A0 =A0 res =3D sas_get_phy_attached_sas_addr(ex_dev, phy->numb=
er, addr);
> + =A0 =A0 =A0 res =3D sas_ex_phy_discover(ex_dev, phy->number);
> =A0 =A0 =A0 =A0sas_put_local_phy(phy);
> +
> =A0 =A0 =A0 =A0/* break the wait early if the expander is unreachable=
,
> =A0 =A0 =A0 =A0 * otherwise keep polling
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (res =3D=3D -ECOMM)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return res;
> - =A0 =A0 =A0 if (res !=3D SMP_RESP_FUNC_ACC || SAS_ADDR(addr) =3D=3D=
 0)
> + =A0 =A0 =A0 if (res !=3D SMP_RESP_FUNC_ACC)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> +
> + =A0 =A0 =A0 switch (ex_phy->attached_dev_type) {
> + =A0 =A0 =A0 case SATA_PENDING:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 case SAS_END_DEV:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ex_phy->attached_sata_dev)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return sas_ata_clear_pe=
nding(dev, ex_phy);
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> + =A0 =A0 =A0 }
> =A0}

Side comment, it strikes me as deadlock prone that we need to do
GFP_KERNEL allocations to recover a domain_device.  Since we're now
enforcing one in-flight smp command per expander, we might as well
pre-allocate the request/response buffers for managing remote phys.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
