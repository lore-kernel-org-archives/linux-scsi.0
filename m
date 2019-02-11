From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Mon, 11 Feb 2019 17:23:40 +0000
Message-ID: <20190211172340.GG22391@sirena.org.uk>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
 <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Cp3Cp8fzgozWLBWL"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


--Cp3Cp8fzgozWLBWL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 11, 2019 at 02:32:15PM +0100, Marc Gonzalez wrote:

> Unfortunately, this optimization breaks UFS on systems where vccq
> powers not only the Flash chip, but the host controller as well,
> such as APQ8098 MEDIABOX or MTP8998:

...

> In my opinion, the rationale for the original patch is questionable.
> If neither the UFSHC, nor the Flash chip, require any load from vccq,
> then that power rail should simply not be specified at all in the DT.

If the supply is physically connected it should be valid to represent
this in DT regardless of how or if the supply gets used at runtime.
However it does sound like this support needs to be better thought
through to make sure we have represented the supplies to the flash chip
and the controller separately - it seems like right now there's no
tracking of the supplies needed for the controller and the assumption is
that only the flash chip needs managing which is breaking things.

--Cp3Cp8fzgozWLBWL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlxhr5sACgkQJNaLcl1U
h9DznAf+PetfOWZBsXUecbqnEpq3HNh++HyGkM2V6YeTI2IexM+xHc7igRo1ouCC
fuKl0fPPAY8LEN0UPRMKNN/BDasMYDIq5N5LbMLC/an/eVXql6PKz9zLYNyf823p
UwY6H779Ah947Qb2BZNKLNmO5wbp9gvq1DyRFvSAz62mMe7aWAx+B9xLyULe23MV
6+iR9ud/p5qIrHRat/4ey0S2z6ENntgOtGMvSE7t4Ks/nrgpmsl/Tj+V+rXBf9eX
W5DXlbC7OqFbynBEx+Zco/9S2VpNyIrpA6JLcRX/d/kk5owY36MIArTaKCf//Fjz
mzG6c4B1j3+gWSPmwgj9F0Nqj1Q2Lw==
=Eslj
-----END PGP SIGNATURE-----

--Cp3Cp8fzgozWLBWL--
