Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0BF16DC0F;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720718902; cv=none; b=XElRPNuy8QpW0yUzmfi4WZzvqI6k969kYEFgkMELyCHD6nCO+kptnDpWbZwgJkD2d0LUHhey7Nw4PoqyfQAeRMj10N22NqEfIg8A4TlGlUVg4kZQc/Hy0U3gND3Jr43HIxQxar3VON5Cxz0BP+5mqwXAB+M56/bfdX4c7Dqrtf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720718902; c=relaxed/simple;
	bh=V1YprhAmorpwrONXWh+NHJ2n1tCH1SDtbs2oxzRP8Sc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lWmC0/1+1Wdm42nf1kTbsKTenlQ51AgJnt4Uvbgv+5V/pn9WvHVM58m55dxZGs4CzsjjojWbyfkMMegMUSrjtTZGO6Vt6DXZKqu2s5zmb6mJhoT4rH3wO0XiVtDPn0QZBeUgwfCc0JRBuGceiE4y+T9jFLOd/dIpAvIVjtOFtas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jM4VKXa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jM4VKXa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E99C32786;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720718902;
	bh=V1YprhAmorpwrONXWh+NHJ2n1tCH1SDtbs2oxzRP8Sc=;
	h=From:To:Cc:Subject:Date:From;
	b=jM4VKXa2LxfHcB3j7rlu1fknEoLHy8oYGGdxVVwjoD7IPi6RBifzLYdH5rvw/8fwG
	 gt+p/5GSs+EHXw5aMp4bwhEviArbsH3w4kh0XOgqqftFPEfjYD+tV6+YKgCcbn41Yr
	 0EARCCMt5EBcM2FZuBqYGSZae6n0hiTVk4TZw2bbovwbDy/TK0dE79CrJLEhwDPFiw
	 TVnkeqnvZV3MuUmsvxQhjJMN1bZIurMbyw9jVGdNH1pw9sestB0531hTUTVhRwfPi3
	 63O7g+Tmsl1Ed3zoEJEn9l3zLYzYSG8nWx7echGT6zwOhXzklDGpwTxhrbF+CRiLZw
	 wf72jzJB2PSDg==
From: Kees Cook <kees@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 0/6] scsi: message: fusion: Replace 1-element arrays with flexible arrays
Date: Thu, 11 Jul 2024 10:28:14 -0700
Message-Id: <20240711172432.work.523-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=975; i=kees@kernel.org; h=from:subject:message-id; bh=V1YprhAmorpwrONXWh+NHJ2n1tCH1SDtbs2oxzRP8Sc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBYzIn64pgvfTCbTO9TZjopxPJO2NthyC8yVV cQ6YPmSc9uJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAWMwAKCRCJcvTf3G3A Jm0nD/9ra65WzdfD1AZ90IYwRQyH5y1/k/Db3vsdyfGwrQbWVPpCWci6pnmd7Qi33S0fYS0mF6L moaj73hu48n0ED5mlQBI3NN9mLx5569HRH1ZnTdRWZFpvKKv2/cSCtDw3ipRYOf24J7I+wMUn75 jQfZshvwne+R+Qgr62j+Zz/nTJCT5lLE+Ntg7ET3Y+0NFTD56NCw1csr31S7AYrPLo/DMTqzlti +tvAh06Yxm9VMIiunp/DFv1b7WlXLh73K/JzQqPZPWSFtm0BRAWqJkzd6umhD8+JljGBq5GS1/d AS3s2pBNaTjEOz7Jm7aJt1CvIO4bbggBaV1fqynnI/XCa7LOImxPCiIWK/vDPmtpfXDOHS9VVW1 nR9Xz8dNB7i4uMfqG2ScO0ARCC5BEyzsOTopcKDNB+ebImO1xlN5kNNSQ64l6u3fJcOIGbCA7OH hCLl8zHbtPmo5o7fVJ7ofo/VpLECCMT06USH/bawaRaHsZwPoGzb/GEaBHzlZiLxDTJafVAQ/kv H6k7mo0j7zU3La4j+XVF16LNEesY0GmDhd/rIRA+o80x7G+PDX8HsZZc7Ua4cKG/3asVAdGVjuH hEo5CTjdFzwwndMSV1RVc2I9DUqGso01IdO7Gemb7Y9Ci3C+qWEP/K8/a1HuxVSz6FaoPHrnjEu b4rMy5UnBzUZi1
 Q==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi,

Replace all remaining uses of deprecated 1-element "fake" flexible arrays
with modern C99 flexible arrays. Add __counted_by annotations at the
same time.

Thanks!

-Kees

Kees Cook (6):
  scsi: message: fusion: struct _RAID_VOL0_SETTINGS: Replace 1-element
    array with flexible array
  scsi: message: fusion: struct _CONFIG_PAGE_SAS_IO_UNIT_0: Replace
    1-element array with flexible array
  scsi: message: fusion: struct _CONFIG_PAGE_RAID_PHYS_DISK_1: Replace
    1-element array with flexible array
  scsi: message: fusion: struct _CONFIG_PAGE_IOC_2: Replace 1-element
    array with flexible array
  scsi: message: fusion: struct _CONFIG_PAGE_IOC_3: Replace 1-element
    array with flexible array
  scsi: message: fusion: struct _CONFIG_PAGE_IOC_4: Replace 1-element
    array with flexible array

 drivers/message/fusion/lsi/mpi_cnfg.h | 60 +++------------------------
 1 file changed, 6 insertions(+), 54 deletions(-)

-- 
2.34.1

