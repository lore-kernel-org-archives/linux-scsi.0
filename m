Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346F316132F;
	Fri,  7 Nov 2025 03:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762487062; cv=none; b=U+4EYs0M2Kl91Bimr/48ledeIGXpVtCjqFjmqnEmO3BPh5fhVWDmxZDyXcB1p1uK7Es8TOjwyPxEHD7zJPHPikYhXzzMmKMe033gSVJSVEftArG+V9Z9KcPuJxT0qPhH2D7Y+xVjgEVHjT97q7nkPNmXjjz6QrtKuzeIUj3EGxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762487062; c=relaxed/simple;
	bh=7fuQRn1aRSqszY0C6oplUSNmlKClIn2MUSqb7n035C8=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=p/jgjwo4+oS6YY5qB25aZDqhXjWi/koKdjT+Y/8bEAG7QALsUuiTApl1M1Tu/Q49taJR4kMXoTxPXcgMAt77Ydai80HPP/SwGEPryTWXP+vJlhR8O7PS+sTjA4qvNS5+UiVxGIn1opmxK/yQy+iyGzFEDD6BpmYniMhBR4JmdWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=dIek1/f7; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="dIek1/f7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1762487058;
	bh=7fuQRn1aRSqszY0C6oplUSNmlKClIn2MUSqb7n035C8=;
	h=Message-ID:Subject:From:To:Date:From;
	b=dIek1/f7FT3CSH0TMiXR4DdMcifZX1qckyeM5PAtRPAsaxMZ7NsDuOvZkk2g+On2H
	 yezvYUjKCuJ1DpjQjcaUZKGUMoQ+9uBdn8mZsmFKnPdJVbsRp4oiuBvV4TvcD6ry8j
	 bjCWgWwnWbxuFUpBMaHsZSW1npInfYQ5x7ajknkk=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id EFA991C00EE;
	Thu, 06 Nov 2025 22:44:17 -0500 (EST)
Message-ID: <9f265f47e0b99894996b89c8d79d2e40d324ddce.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.18-rc4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2025 22:44:17 -0500
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNElecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHURfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmBLmY0FCRs1hL0ACgkQgUrkfCFIVNaEiQgAg18F4G7PGWQ68xqnIrccke7Reh5thjUz6kQIii6Dh64BDW6/UvXn20UxK2uSs/0TBLO81k1mV4c6rNE+H8b7IEjieGR9frBsp/+Q01JpToJfzzMUY7ZTDV1IXQZ+AY9L7vRzyimnJHx0Ba4JTlAyHB+Ly5i4Ab2+uZcnNfBXquWrG3oPWz+qPK88LJLya5Jxse1m1QT6R/isDuPivBzntLOooxPk+Cwf5sFAAJND+idTAzWzslexr9j7rtQ1UW6FjO4CvK9yVNz7dgG6FvEZl6J/HOr1rivtGgpCZTBzKNF8jg034n49zGfKkkzWLuXbPUOp3/oGfsKv8pnEu1c2GbQpSmFtZXMgQm90dG9tbGV5IDxqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbT6JAVYEEwEIAEACGwMHCwkIBwMCAQYVC
	AIJCgsEFgIDAQIeAQIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mXBQkbNYS9AAoJEIFK5HwhSFTWEYEH/1YZpV+1uCI2MVz0wTRlnO/3OW/xnyigrw+K4cuO7MToo0tHJb/qL9CBJ2ddG6q+GTnF5kqUe87t7M7rSrIcAkIZMbJmtIbKk0j5EstyYqlE1HzvpmssGpg/8uJBBuWbU35af1ubKCjUs1+974mYXkfLmS0a6h+cG7atVLmyClIc2frd3o0zHF9+E7BaB+HQzT4lheQAXv9KI+63ksnbBpcZnS44t6mi1lzUE65+Am1z+1KJurF2Qbj4AkICzJjJa0bXa9DmFunjPhLbCU160LppaG3OksxuNOTkGCo/tEotDOotZNBYejWaXN2nr9WrH5hDfQ5zLayfKMtLSd33T9u0IUphbWVzIEJvdHRvbWxleSA8amVqYkBrZXJuZWwub3JnPokBVQQTAQgAPwIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCYEuZmAUJGzWEvQAKCRCBSuR8IUhU1gacCAC+QZN+RQd+FOoh5g884HQm8S07ON0/2EMiaXBiL6KQb5yP3w2PKEhug3+uPzugftUfgPEw6emRucrFFpwguhriGhB3pgWJIrTD4JUevrBgjEGOztJpbD73bLLyitSiPQZ6OFVOqIGhdqlc3n0qoNQ45n/w3LMVj6yP43SfBQeQGEdq4yHQxXPs0XQCbmr6Nf2p8mNsIKRYf90fCDmABH1lfZxoGJH/frQOBCJ9bMRNCNy+aFtjd5m8ka5M7gcDvM7TAsKhD5O5qFs4aJHGajF4gCGoWmXZGrISQvrNl9kWUhgsvoPqb2OTTeAQVRuV8C4FQamxzE3MRNH25j6s/qujtCRKYW1lcyBCb3R0b21sZXkgPGplamJAbGludXguaWJtLmNvbT6JAVQEEwEIAD
	4CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCYEuZmQUJGzWEvQAKCRCBSuR8IUhU1kyHB/9VIOkf8RapONUdZ+7FgEpDgESE/y3coDeeb8jrtJyeefWCA0sWU8GSc9KMcMoSUetUreB+fukeVTe/f2NcJ87Bkq5jUEWff4qsbqf5PPM+wlD873StFc6mP8koy8bb7QcH3asH9fDFXUz7Oz5ubI0sE8+qD+Pdlk5qmLY5IiZ4D98V239nrKIhDymcuL7VztyWfdFSnbVXmumIpi79Ox536P2aMe3/v+1jAsFQOIjThMo/2xmLkQiyacB2veMcBzBkcair5WC7SBgrz2YsMCbC37X7crDWmCI3xEuwRAeDNpmxhVCb7jEvigNfRWQ4TYQADdC4KsilPfuW8Edk/8tPtCVKYW1lcyBCb3R0b21sZXkgPEpCb3R0b21sZXlAT2Rpbi5jb20+iQEfBDABAgAJBQJXI+B0Ah0gAAoJEIFK5HwhSFTWzkwH+gOg1UG/oB2lc0DF3lAJPloSIDBW38D3rezXTUiJtAhenWrH2Cl/ejznjdTukxOcuR1bV8zxR9Zs9jhUin2tgCCxIbrdvFIoYilMMRKcue1q0IYQHaqjd7ko8BHn9UysuX8qltJFar0BOClIlH95gdKWJbK46mw7bsXeD66N9IhAsOMJt6mSJmUdIOMuKy4dD4X3adegKMmoTRvHOndZQClTZHiYt5ECRPO534Lb/gyKAKQkFiwirsgx11ZSx3zGlw28brco6ohSLMBylna/Pbbn5hII86cjrCXWtQ4mE0Y6ofeFjpmMdfSRUxy6LHYd3fxVq9PoAJTv7vQ6bLTDFNa0KkphbWVzIEJvdHRvbWxleSA8SkJvdHRvbWxleUBQYXJhbGxlbHMuY29tPokBHwQwAQIACQUCVyPgjAIdIAAKCRCBSuR8IUhU1tXiB/9D9OOU8qB
	CZPxkxB6ofp0j0pbZppRe6iCJ+btWBhSURz25DQzQNu5GVBRQt1Us6v3PPGU1cEWi5WL935nw+1hXPIVB3x8hElvdCO2aU61bMcpFd138AFHMHJ+emboKHblnhuY5+L1OlA1QmPw6wQooCor1h113lZiBZGrPFxjRYbWYVQmVaM6zhkiGgIkzQw/g9v57nAzYuBhFjnVHgmmu6/B0N8z6xD5sSPCZSjYSS38UG9w189S8HVr4eg54jReIEvLPRaxqVEnsoKmLisryyaw3EpqZcYAWoX0Am+58CXq3j5OvrCvbyqQIWFElba3Ka/oT7CnTdo/SUL/jPNobtCxKYW1lcyBCb3R0b21sZXkgPGplamJAaGFuc2VucGFydG5lcnNoaXAuY29tPokBVwQTAQgAQRYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJjg2eQAhsDBQkbNYS9BQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAAAoJEIFK5HwhSFTWbtAH/087y9vzXYAHMPbjd8etB/I3OEFKteFacXBRBRDKXI9ZqK5F/xvd1fuehwQWl2Y/sivD4cSAP0iM/rFOwv9GLyrr82pD/GV/+1iXt9kjlLY36/1U2qoyAczY+jsS72aZjWwcO7Og8IYTaRzlqif9Zpfj7Q0Q1e9SAefMlakI6dcZTSlZWaaXCefdPBCc7BZ0SFY4kIg0iqKaagdgQomwW61nJZ+woljMjgv3HKOkiJ+rcB/n+/moryd8RnDhNmvYASheazYvUwaF/aMj5rIb/0w5p6IbFax+wGF5RmH2U5NeUlhIkTodUF/P7g/cJf4HCL+RA1KU/xS9o8zrAOeut2+4UgRaZ7bmEwgqhkjOPQMBBwIDBH4GsIgL0yQij5S5ISDZmlR7qDQPcWUxMVx6zVPsAoITdjKFjaDmUATkS+l5zmiCrUBcJ6MBavPiYQ4kqn4/xwaJAbMEGAEIACYCGwIWIQTVYG5zyLRi
	cb6tmt+BSuR8IUhU1gUCZag0LwUJDwLkSQCBdiAEGRMIAB0WIQTnYEDbdso9F2cI+arnQslM7pishQUCWme25gAKCRDnQslM7pishdi9AQDyOvLYOBkylBqiTlJrMnGCCsWgGZwPpKq3e3s7JQ/xBAEAlx29pPY5z0RLyIDUsjf9mtkSNTaeaQ6TIjDrFa+8XH8JEIFK5HwhSFTWkasH/j7LL9WH9dRfwfTwuMMj1/KGzjU/4KFIu4uKxDaevKpGS7sDx4F56mafCdGD8u4+ri6bJr/3mmuzIdyger0vJdRlTrnpX3ONXvR57p1JHgCljehE1ZB0RCzIk0vKhdt8+CDBQWfKbbKBTmzA7wR68raMQb2D7nQ9d0KXXbtr7Hag29yj92aUAZ/sFoe9RhDOcRUptdYyPKU1JHgJyc0Z7HwNjRSJ4lKJSKP+Px0/XxT3gV3LaDLtHuHa2IujLEAKcPzTr5DOV+xsgA3iSwTYI6H5aEe+ZRv/rA4sdjqRiVpo2d044aCUFUNQ3PiIHPAZR3KK5O64m6+BJMDXBvgSsMy4VgRaZ7clEggqhkjOPQMBBwIDBMfuMuE+PECbOoYjkD0Teno7TDbcgxJNgPV7Y2lQbNBnexMLOEY6/xJzRi1Xm/o9mOyZ+VIj8h4G5V/eWSntNkwDAQgHiQE8BBgBCAAmAhsMFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmWoNBwFCQ8C4/cACgkQgUrkfCFIVNZs4AgAnIjU1QEPLdpotiy3X01sKUO+hvcT3/Cd6g55sJyKJ5/U0o3f8fdSn6MWPhi1m62zbAxcLJFiTZ3OWNCZAMEvwHrXFb684Ey6yImQ9gm2dG2nVuCzr1+9gIaMSBeZ+4kUJqhdWSJjrNLQG38GbnBuYOJUD+x6oJ2AT10/mQfBVZ3qWDQXr/je2TSf0OIXaWyG6meG5yTqOEv0eaTH22yBb1nbodoZkmlMMb56jzRGZuorhFE06
	N0Eb0kiGz5cCIrHZoH10dHWoa7/Z+AzfL0caOKjcmsnUPcmcrqmWzJTEibLA81z15GBCrldfQVt+dF7Us2kc0hKUgaWeI8Gv4CzwLkCDQRUdhaZARAApeF9gbNSBBudW8xeMQIiB/CZwK4VOEP7nGHZn3UsWemsvE9lvjbFzbqcIkbUp2V6ExM5tyEgzio2BavLe1ZJGHVaKkL3cKLABoYi/yBLEnogPFzzYfK2fdipm2G+GhLaqfDxtAQ7cqXeo1TCsZLSvjD+kLVV1TvKlaHS8tUCh2oUyR7fTbv6WHi5H8DLyR0Pnbt9E9/Gcs1j11JX+MWJ7jset2FVDsB5U1LM70AjhXiDiQCtNJzKaqKdMei8zazWS50iMKKeo4m/adWBjG/8ld3fQ7/Hcj6Opkh8xPaCnmgDZovYGavw4Am2tjRqE6G6rPQpS0we5I6lSsKNBP/2FhLmI9fnsBnZC1l1NrASRSX1BK0xf4LYB2Ww3fYQmbbApAUBbWZ/1aQoc2ECKbSK9iW0gfZ8rDggfMw8nzpmEEExl0hU6wtJLymyDV+QGoPx5KwYK/6qAUNJQInUYz8z2ERM/HOI09Zu3jiauFBDtouSIraX/2DDvTf7Lfe1+ihARFSlp64kEMAsjKutNBK2u5oj4H7hQ7zD+BvWLHxMgysOtYYtwggweOrM/k3RndsZ/z3nsGqF0ggct1VLuH2eznDksI+KkZ3Bg0WihQyJ7Z9omgaQAyRDFct+jnJsv2Iza+xIvPei+fpbGNAyFvj0e+TsZoQGcC34/ipGwze651UAEQEAAYkBHwQoAQIACQUCVT6BaAIdAwAKCRCBSuR8IUhU1p5QCAC7pgjOM17Hxwqz9mlGELilYqjzNPUoZt5xslcTFGxj/QWNzu0K8gEQPePnc5dTfumzWL077nxhdKYtoqwm2C6fOmXiJBZx6khBfRqctUvN2DlOB6dFf5I+1QT9TRBvceGzw01E4Gi0xjWKAB6OII
	MAdnPcDVFzaXJdlAAJdjfg/lyJtAyxifflG8NnXJ3elwGqoBso84XBNWWzbc5VKmatzhYLOvXtfzDhu4mNPv/z7S1HTtRguI0NlH5RVBzSvfzybin9hysE3/+r3C0HJ2xiOHzucNAmG03aztzZYDMTbKQW4bQqeD5MJxT68vBYu8MtzfIe41lSLpb/qlwq1qg0iQElBBgBAgAPBQJUdhaZAhsMBQkA7U4AAAoJEIFK5HwhSFTW3YgH/AyJL2rlCvGrkLcas94ND9Pmn0cUlVrPl7wVGcIV+6I4nrw6u49TyqNMmsYam2YpjervJGgbvIbMzoHFCREi6R9XyUsw5w7GCRoWegw2blZYi5A52xe500+/RruG//MKfOtVUotu3N+u7FcXaYAg9gbYeGNZCV70vI+cnFgq0AEJRdjidzfCWVKPjafTo7jHeFxX7Q22kUfWOkMzzhoDbFg0jPhVYNiEXpNyXCwirzvKA7bvFwZPlRkbfihaiXDE7QKIUtQ10i5kw4C9rqDKwx8F0PaWDRF9gGaKd7/IJGHJaac/OcSJ36zxgkNgLsVX5GUroJ2GaZcR7W9Vppj5H+C4UgRkuRyTEwgqhkjOPQMBBwIDBOySomnsW2SkApXv1zUBaD38dFEj0LQeDEMdSE7bm1fnrdjAYt0f/CtbUUiDaPodQk2qeHzOP6wA/2K6rrjwNIWJAT0EGAEIACcDGyAEFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmWoM/gFCQSxfmUACgkQgUrkfCFIVNZhTgf/VQxtQ5rgu2aoXh2KOH6naGzPKDkYDJ/K7XCJAq3nJYEpYN8G+F8mL/ql0hrihAsHfjmoDOlt+INa3AcG3v0jDZIMEzmcjAlu7g5NcXS3kntcMHgw3dCgE9eYDaKGipUCubdXvBaZWU6AUlTldaB8FE6u7It7+UO+IW4/L+KpLYKs8V5POInu2rqahlm7vgxY5iv4Txz4EvCW2e4dAlG
	8mT2Eh9SkH+YVOmaKsajgZgrBxA7fWmGoxXswEVxJIFj3vW7yNc0C5HaUdYa5iGOMs4kg2ht4s7yy7NRQuh7BifWjo6BQ6k4S1H+6axZucxhSV1L6zN9d+lr3Xo/vy1unzA==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

All fixes in the UFS driver.  The big contributor to the diffstats is
the Intel controller S0ix/S3 fix which has to special case the
suspend/resume patch for intel controllers in ufshcd-pci.c

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (4):
      scsi: ufs: core: Fix invalid probe error return value
      scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for In=
tel ADL
      scsi: ufs: core: Add a quirk to suppress link_startup_again
      scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers

Bart Van Assche (3):
      scsi: ufs: core: Revert "Make HID attributes visible"
      scsi: ufs: core: Reduce link startup failure logging
      scsi: ufs: core: Fix a race condition related to the "hid" attribute =
group

Nitin Rawat (1):
      scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3D3)

And the diffstat:

 drivers/ufs/core/ufs-sysfs.c  |  2 +-
 drivers/ufs/core/ufs-sysfs.h  |  1 -
 drivers/ufs/core/ufshcd.c     | 17 ++++-------
 drivers/ufs/host/ufs-qcom.c   | 15 +++++++++-
 drivers/ufs/host/ufshcd-pci.c | 70 +++++++++++++++++++++++++++++++++++++++=
++--
 include/ufs/ufshcd.h          |  7 +++++
 6 files changed, 95 insertions(+), 17 deletions(-)

With full diff below.

Regards,

James

---

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index c040afc6668e..0086816b27cd 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobjec=
t *kobj,
 	return	hba->dev_info.hid_sup ? attr->mode : 0;
 }
=20
-const struct attribute_group ufs_sysfs_hid_group =3D {
+static const struct attribute_group ufs_sysfs_hid_group =3D {
 	.name =3D "hid",
 	.attrs =3D ufs_sysfs_hid,
 	.is_visible =3D ufs_sysfs_hid_is_visible,
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 6efb82a082fd..8d94af3b8077 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -14,6 +14,5 @@ void ufs_sysfs_remove_nodes(struct device *dev);
=20
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
-extern const struct attribute_group ufs_sysfs_hid_group;
=20
 #endif
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ca27de4767a..d6a060a72461 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5066,7 +5066,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 	 * If UFS device isn't active then we will have to issue link startup
 	 * 2 times to make sure the device state move to active.
 	 */
-	if (!ufshcd_is_ufs_dev_active(hba))
+	if (!(hba->quirks & UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE) &&
+	    !ufshcd_is_ufs_dev_active(hba))
 		link_startup_again =3D true;
=20
 link_startup:
@@ -5131,12 +5132,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 	ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
 	ret =3D ufshcd_make_hba_operational(hba);
 out:
-	if (ret) {
+	if (ret)
 		dev_err(hba->dev, "link startup failed %d\n", ret);
-		ufshcd_print_host_state(hba);
-		ufshcd_print_pwr_info(hba);
-		ufshcd_print_evt_hist(hba);
-	}
 	return ret;
 }
=20
@@ -8503,8 +8500,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
=20
-	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
-
 	model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
=20
 	err =3D ufshcd_read_string_desc(hba, model_index,
@@ -10661,7 +10656,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *hba=
)
  * @mmio_base: base register address
  * @irq: Interrupt line of device
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success; < 0 on failure.
  */
 int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int=
 irq)
 {
@@ -10891,8 +10886,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
-	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
+	async_schedule(ufshcd_async_scan, hba);
=20
 	device_enable_async_suspend(dev);
 	ufshcd_pm_qos_init(hba);
@@ -10902,7 +10897,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
 	hba->is_irq_enabled =3D false;
 	ufshcd_hba_exit(hba);
 out_error:
-	return err;
+	return err > 0 ? -EIO : err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_init);
=20
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 3e83dc51d538..eba0e6617483 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -740,8 +740,21 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum =
ufs_pm_op pm_op,
=20
=20
 	/* reset the connected UFS device during power down */
-	if (ufs_qcom_is_link_off(hba) && host->device_reset)
+	if (ufs_qcom_is_link_off(hba) && host->device_reset) {
 		ufs_qcom_device_reset_ctrl(hba, true);
+		/*
+		 * After sending the SSU command, asserting the rst_n
+		 * line causes the device firmware to wake up and
+		 * execute its reset routine.
+		 *
+		 * During this process, the device may draw current
+		 * beyond the permissible limit for low-power mode (LPM).
+		 * A 10ms delay, based on experimental observations,
+		 * allows the UFS device to complete its hardware reset
+		 * before transitioning the power rail to LPM.
+		 */
+		usleep_range(10000, 11000);
+	}
=20
 	return ufs_qcom_ice_suspend(host);
 }
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index b87e03777395..5f65dfad1a71 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -15,6 +15,7 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
+#include <linux/suspend.h>
 #include <linux/debugfs.h>
 #include <linux/uuid.h>
 #include <linux/acpi.h>
@@ -31,6 +32,7 @@ struct intel_host {
 	u32		dsm_fns;
 	u32		active_ltr;
 	u32		idle_ltr;
+	int		saved_spm_lvl;
 	struct dentry	*debugfs_root;
 	struct gpio_desc *reset_gpio;
 };
@@ -347,6 +349,7 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 	host =3D devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
+	host->saved_spm_lvl =3D -1;
 	ufshcd_set_variant(hba, host);
 	intel_dsm_init(host, hba->dev);
 	if (INTEL_DSM_SUPPORTED(host, RESET)) {
@@ -425,7 +428,8 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 static int ufs_intel_adl_init(struct ufs_hba *hba)
 {
 	hba->nop_out_timeout =3D 200;
-	hba->quirks |=3D UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	hba->quirks |=3D UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8 |
+		       UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
 	hba->caps |=3D UFSHCD_CAP_WB_EN;
 	return ufs_intel_common_init(hba);
 }
@@ -538,6 +542,66 @@ static int ufshcd_pci_restore(struct device *dev)
=20
 	return ufshcd_system_resume(dev);
 }
+
+static int ufs_intel_suspend_prepare(struct device *dev)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	struct intel_host *host =3D ufshcd_get_variant(hba);
+	int err;
+
+	/*
+	 * Only s2idle (S0ix) retains link state.  Force power-off
+	 * (UFS_PM_LVL_5) for any other case.
+	 */
+	if (pm_suspend_target_state !=3D PM_SUSPEND_TO_IDLE && hba->spm_lvl < UFS=
_PM_LVL_5) {
+		host->saved_spm_lvl =3D hba->spm_lvl;
+		hba->spm_lvl =3D UFS_PM_LVL_5;
+	}
+
+	err =3D ufshcd_suspend_prepare(dev);
+
+	if (err < 0 && host->saved_spm_lvl !=3D -1) {
+		hba->spm_lvl =3D host->saved_spm_lvl;
+		host->saved_spm_lvl =3D -1;
+	}
+
+	return err;
+}
+
+static void ufs_intel_resume_complete(struct device *dev)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	struct intel_host *host =3D ufshcd_get_variant(hba);
+
+	ufshcd_resume_complete(dev);
+
+	if (host->saved_spm_lvl !=3D -1) {
+		hba->spm_lvl =3D host->saved_spm_lvl;
+		host->saved_spm_lvl =3D -1;
+	}
+}
+
+static int ufshcd_pci_suspend_prepare(struct device *dev)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+
+	if (!strcmp(hba->vops->name, "intel-pci"))
+		return ufs_intel_suspend_prepare(dev);
+
+	return ufshcd_suspend_prepare(dev);
+}
+
+static void ufshcd_pci_resume_complete(struct device *dev)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+
+	if (!strcmp(hba->vops->name, "intel-pci")) {
+		ufs_intel_resume_complete(dev);
+		return;
+	}
+
+	ufshcd_resume_complete(dev);
+}
 #endif
=20
 /**
@@ -611,8 +675,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops =3D {
 	.thaw		=3D ufshcd_system_resume,
 	.poweroff	=3D ufshcd_system_suspend,
 	.restore	=3D ufshcd_pci_restore,
-	.prepare	=3D ufshcd_suspend_prepare,
-	.complete	=3D ufshcd_resume_complete,
+	.prepare	=3D ufshcd_pci_suspend_prepare,
+	.complete	=3D ufshcd_pci_resume_complete,
 #endif
 };
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..0f95576bf1f6 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -688,6 +688,13 @@ enum ufshcd_quirks {
 	 * single doorbell mode.
 	 */
 	UFSHCD_QUIRK_BROKEN_LSDBS_CAP			=3D 1 << 25,
+
+	/*
+	 * This quirk indicates that DME_LINKSTARTUP should not be issued a 2nd
+	 * time (refer link_startup_again) after the 1st time was successful,
+	 * because it causes link startup to become unreliable.
+	 */
+	UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE		=3D 1 << 26,
 };
=20
 enum ufshcd_caps {

