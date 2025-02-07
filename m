Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB43BA50;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=ekm7oQCHj+g7tVjRo8gt47efjpjOoku+RvU9Px0rvwxwyQFyJ3FT2IxMCZdqhUsikGpGL+pv1PUznQSRryY35j2zsYT5n+WQeOnq9vnS6y2HkiFPjfYa2hg8Pu4kDFNST5XFp5Iz7wBqZqHIgJlyDNeWGZlwgcxqGFJ71GxcnAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=Xl48osgyHHoTY3BQVlAMnzyCSuWwjBF6yC7+Hu6Y2Fs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EeNXB/tmMR8Fir6MiyB4mwr6Oy5wi+XJeHpK65PKs1rDIoakePXcrs9nnORIv58AZr4sjyXTpJnHUvj7tf+poTuDf+HQvdweH69JlyjmBzvIQyOS/HrUoLmJnA1qGrbhwZohcKvCySm57KyA7pNrk7Alhibq6sU0re81pG9x5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWwgAitt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWwgAitt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF74DC4CEE0;
	Fri,  7 Feb 2025 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890022;
	bh=Xl48osgyHHoTY3BQVlAMnzyCSuWwjBF6yC7+Hu6Y2Fs=;
	h=From:To:Cc:Subject:Date:From;
	b=FWwgAitt9vwqNllYKfs5Qt9bUsDidDT+yD6nWxRxP3cdmmvO/3dFTcsssmYhI1dR0
	 jsvCLK7uGjxqO2xvB8pPSlgnmhnsBmjHxdsm5pf8B7VCeZTB8YrjOwTUrXfc1pCSIP
	 nPltKClrPq1h1EvO3AFa+Qi978jidyavwfAfxAdTskaIJ/RwjgdUNgsXsOZKMDJqeJ
	 jLHUqEle3pxmHevzTKBXNroC01J4Izm+O0BiDWDIOL7OOIXP7f5XnjxUmAC2z2LXwM
	 xGHHJqZZ6sNlYLueqcg+4+X53JOAxcCiF6YrikzWjJwWqIulEc6rDQ+SIv4oRbArsj
	 QT4O2Wg4zU5rQ==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Tadeusz Struk <tadeusz.struk@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Erick Archer <erick.archer@outlook.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 00/10] Annotate arguments of memtostr/strtomem with __nonstring
Date: Thu,  6 Feb 2025 17:00:09 -0800
Message-Id: <20250207005832.work.324-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1681; i=kees@kernel.org; h=from:subject:message-id; bh=Xl48osgyHHoTY3BQVlAMnzyCSuWwjBF6yC7+Hu6Y2Fs=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLo+U7dh/aHBQTzjftj+VeB6PFqyyv/rHk/MdXZe688 WV4odXcjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIncUGT4p7RXY6Xwg62zarf5 dhl8XdLOorvWeM+fmkKFAIljy5Yt9WNkmNnwzu69VtHZSe62595nea1+EsO2cnHJza1nXsz2Mu2 6yQ4A
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi,

The memtostr*() and strtomem*() helpers are designed to move between C
strings (NUL-terminated) and byte arrays (that may just be zero padded and
may not be NUL-terminated). The "nonstring" attribute is used to annotated
these kinds of byte arrays, and we can validate the annotation on the
arguments of the helpers. Add the the infrastructure to do this, and
then update all the places where these annotations are currently missing.

-Kees

Kees Cook (10):
  scsi: mptfusion: Mark device strings as nonstring
  scsi: mpi3mr: Mark device strings as nonstring
  scsi: mpt3sas: Mark device strings as nonstring
  scsi: qla2xxx: Mark device strings as nonstring
  string: kunit: Mark nonstring test strings as __nonstring
  x86/tdx: Mark message.str as nonstring
  uapi: stddef.h: Introduce __kernel_nonstring
  nilfs2: Mark on-disk strings as nonstring
  compiler.h: Introduce __must_be_noncstr()
  string.h: Validate memtostr*()/strtomem*() arguments more carefully

 arch/x86/coco/tdx/tdx.c                  |  2 +-
 drivers/message/fusion/mptsas.c          |  8 ++++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c   |  8 ++++----
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 ++++----
 drivers/scsi/qla2xxx/qla_mr.h            |  4 ++--
 include/linux/compiler.h                 | 18 +++++++++++++++++-
 include/linux/string.h                   | 16 ++++++++++++----
 include/uapi/linux/nilfs2_ondisk.h       |  3 ++-
 include/uapi/linux/stddef.h              |  6 ++++++
 lib/string_kunit.c                       |  4 ++--
 11 files changed, 55 insertions(+), 24 deletions(-)

-- 
2.34.1

