From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Wed, 18 Apr 2012 08:46:51 -0700
Message-ID: <CABE8wwscnUrh62L5Z1sNKDS4BLucZz2fVUqMVK3znhHbFp1XEA@mail.gmail.com>
References: <20120416224250.GA1983@bill-the-cat>
	<CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
	<4F8CAC6F.6070907@ti.com>
	<1334620782.23541.2.camel@ultramagnus.opencreations.com>
	<4F8CCD0C.5060900@ti.com>
	<1334633159.13899.4.camel@dwillia2-mobl>
	<1334677637.3766.66.camel@dabdike>
	<CABE8wwvThcO4B+qQUMBg+OMdTbF5VMZ0THD9SftSocj+oBOARw@mail.gmail.com>
	<CAA9_cmeY0VaRqgfjqZbFbqP8u+wvkJ8=dJUNk9kkBabAF15t1w@mail.gmail.com>
	<4F8EDC5F.9090600@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:21367 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751320Ab2DRPq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 11:46:59 -0400
Received: by bkcjm19 with SMTP id jm19so5656432bkc.25
        for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2012 08:46:51 -0700 (PDT)
In-Reply-To: <4F8EDC5F.9090600@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Rini <trini@ti.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

On Wed, Apr 18, 2012 at 8:23 AM, Tom Rini <trini@ti.com> wrote:
> Performance isn't in-line with what I would expect (in playing with f=
io), so
> if you want to whip something up, or point me some changesets / other
> drivers I can take a stab here. =A0Thanks!
>

The thrust is to change this loop in mvs_pci_init:

        do {
                mvi =3D mvs_pci_alloc(pdev, ent, shost, nhost);
                if (!mvi) {
                        rc =3D -ENOMEM;
                        goto err_out_regions;
                }

                memset(&mvi->hba_info_param, 0xFF,
                        sizeof(struct hba_info_page));

                mvs_init_sas_add(mvi);

                mvi->instance =3D nhost;
                rc =3D MVS_CHIP_DISP->chip_init(mvi);
                if (rc) {
                        mvs_free(mvi);
                        goto err_out_regions;
                }
                nhost++;
        } while (nhost < chip->n_host);

=2E..to assume that mvs_pci_alloc will do the allocation of a scsi_host
per chip, rather than passing in a global host.

Then would need to clean up warts like the following in mvs_phy_control=
:

        while (sha->sas_phy[i]) {
                if (sha->sas_phy[i] =3D=3D sas_phy)
                        break;
                i++;
        }

=2E..since this model means that the sas_phy->id can be used directly t=
o
look up the local mvsas phy.

I might circle back to this once 3.4 finalizes (since the random ids
libsas uses for identifying local ports is onerous), but if someone
else beats me to it I wouldn't mind ;-).

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
