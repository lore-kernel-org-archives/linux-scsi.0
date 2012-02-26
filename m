From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Sun, 26 Feb 2012 18:07:20 +0300
Message-ID: <20120226150720.GB4763@mwanda>
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: jack_wang@usish.com, lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 26, 2012 at 07:03:30PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>=20
> Static checker is giving following warning:
> " error: calling 'spin_unlock_irqrestore()' with bogus flags"
>=20
> The code flow is as shown below:
> process_oq() --> process_one_iomb --> mpi_sata_completion
>=20
> In 'mpi_sata_completion'
> the first call for 'spin_unlock_irqrestore()' is with flags=3D0,
> which is as good as 'spin_unlock_irq()' ( unconditional interrupt
> enabling).
>=20
> So for better performance 'spin_unlock_irqrestore()' can be replaced
> with 'spin_unlock_irq()' and 'spin_lock_irqsave()' can be replaced by
> 'spin_lock_irq()'.
>=20

process_oq() is called from the interrupt handler pm8001_chip_isr()
with interrupts disabled.

drivers/scsi/pm8001/pm8001_hwi.c
  4301          spin_lock_irqsave(&pm8001_ha->lock, flags);
  4302          pm8001_chip_interrupt_disable(pm8001_ha);
  4303          process_oq(pm8001_ha);
  4304          pm8001_chip_interrupt_enable(pm8001_ha);
  4305          spin_unlock_irqrestore(&pm8001_ha->lock, flags);

Probably we should just be doing a spin_lock() and spin_unlock()
without re-enabling the IRQs.  Should we even be doing that in the
irq handler anyway?

regards,
dan carpenter


--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSkqnAAoJEOnZkXI/YHqRMF4P/jZn0tklrsklESB5qd8kOrW8
UZRmxq1wfv9ut3EFGDjPNl2HNSKCNknOgEWAZlOTvys/kZXmF4U2svQHwGvLGnFs
9c9cf6APIFLrHwacFhW8HO5U/au/D0POTrqreHMyGQeNFlQqRcXW7ScIRu4v/QsZ
fgRNPPFtXEmKBUHF0pBshdGW8qSb+FuljsBdYZLSq/Op+PhbJCo0UeQzVXKmTGGT
+vyOb/2mOf7YATH7oc+5H7oTbneih/rV9ReKePJWyfdkyZ91dgghS5j6rJeXdW/5
dOcgo0asUvI8GxZO6O/ozgJuKmPd7mgMp6m42JXXYeddQpNG/7ndQ1mLmxrLOmVo
H0TgspSMByLZ2qQUzIu14TDRro5t29LqjnOdIpHNqgkRth+Xvs6mv9PZ0dN4j7ZT
xg0YNn6qa1MTtnHlm1WxxDLES0BWT5P706561Y6Lc7PIrAs22nEgpnB2ELQp3l3S
enUmMA7tX7tcSQP3ExPghBwy9NiFS+0LbGBf4jBPG/1i5tqHZ93Lv44kW9xVg2uR
EbN9bm7yPyKcFVyg5rZeUM+AtnfSLKx5QMQSxjaDjp/B5nFJ8i8v47Vhjfy6YihR
hnCkvJtTB8bHtb5rzNfOg8mYLvMHLFixdIVJuR1tJuc1yea/R1BIITv9inwU1IqB
VeF2NlKgIhb9gcdXryM3
=G+Ch
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
