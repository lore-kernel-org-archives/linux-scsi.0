From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Thu, 1 Mar 2012 17:37:58 +0300
Message-ID: <20120301143757.GT1003@mwanda>
References: <20120301142225.GA9789@elgon.mountain>
 <CAOD=uF46HF3iLto3AhnTkjzSDebAkCYtTE-UJ26s00CwgwRPYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vru7fAags9pVPvn5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42899 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519Ab2CAOgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 09:36:03 -0500
Content-Disposition: inline
In-Reply-To: <CAOD=uF46HF3iLto3AhnTkjzSDebAkCYtTE-UJ26s00CwgwRPYA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org


--vru7fAags9pVPvn5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 01, 2012 at 07:54:57PM +0530, santosh prasad nayak wrote:
> The warnings are  there since from the beginning.
> Even before my fix.
>=20
> There are two locks:
> 1.  pm8001_ha->lock
> 2. t->task_state_lock
>=20

Yes.  But IRQs are either enabled or disabled for the CPU.  You
can't enable them twice.

In this case we enable them in the first call to unlock and the
second call doesn't do anything.  So possibly the current behavior
is correct and we should change the second unlock or possibly the
current behavior is wrong and we should change the first unlock.

But actually the email was more of just a form letter.  Perhaps Jack
knows what to do here...

regards,
dan carpenter


--vru7fAags9pVPvn5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT4nFAAoJEOnZkXI/YHqR9dEQAK9NX7NHpXYmk2T+qZKuB86T
ooTNOp3ldbn3J8IXWX0AfconpPHx2we6VX+nieqPcqOO2IX2O6IqBEk/JzOQI6pN
4DmB+HEedLgjTfcRJ1vYOFEzptQME7oPJtv86b5nt3M5WRCZ3+NKV/ya5L6sEC5k
w6E5LU4QHAFQfw+nj5dstu4zO8JE53PW2o3mmzR6p69u6w/9GX/0gFh29fX357wB
0SbpcPeHo6azyFDTmtVq8UaW8/qSuQR79Bs1XSvEMZJ7CbLph2kO+Xrzmtdxz/g/
RvxtS3/BJ+z4zLBOk/NJinYf0fpDfgnK0HGzSbqd6rG95rnSD0EIgibs0HyfvtnS
uWDCXoWeg3F5lcVmT5dDxsE0zN1JtubHePRpmL+amaQBilc/x8c5Hk+HdRzVLVcl
jpkTDCcQ+qPsCsij9tckBbD2QMHcLTBXCbgHAXHZp3uA1LLiqVjZUzrSTHOjj1HU
C0aAz/B62zxSHB7uhVbaCPi13+Ut2QsoG/vpekM2cpUcVwGGokKZWiSPZMJ9TYQE
RmqT3bxBKXK2xva479LgwKvOicuWgW/4RTHiW2KYQvg6KbXZEXYD1/HnwaoR/Lrl
kgAlEKZMZpq8ol03SoiW18arpo40kKQ4wfWw5sMjxRH+yBuezt5gBzxBmz6SuEkz
QqkNVq9KOrPyPULvB4ET
=venf
-----END PGP SIGNATURE-----

--vru7fAags9pVPvn5--
