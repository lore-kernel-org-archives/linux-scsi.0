Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB9E16C856;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713398; cv=none; b=R1Ic/eAwAUTchenL1Pgxk8NwVfvxLMyYCXp4K29Ux1y3aG2oX9l0acqfKI7dCGhGfamEKbz9zmSkOefMuULvVrj7fE7lf0lOlWUrkyh+HuG0eaOMESQeYvpyWmPMIqQP2RARiTO1kMzMQYf+BD6zfC3YNH6qpqYI8r2wg6HREUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713398; c=relaxed/simple;
	bh=i/3KGFDv66qPSD7n8HNYgQVzkx1HgSs2Cuq88INApqE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DxZe44pfyp5BdgAPZL5Fmly1Ijz6CwQCy8Ki1BeTOwSjPObRLeL5U1RqQytrxjSVIKaYxQ4Fi1vhA5wU5FQQ3he+/U3DVTivxggo0yvPc26axBZynKTTzOtEWwmXKVC75oGxS3s8lTrfLqzPprZHhcNTy6BAp7HiGlePPIxpB/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDPV6WCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDPV6WCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54572C4AF0E;
	Thu, 11 Jul 2024 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720713398;
	bh=i/3KGFDv66qPSD7n8HNYgQVzkx1HgSs2Cuq88INApqE=;
	h=From:To:Cc:Subject:Date:From;
	b=LDPV6WCEeLdWxGnzuPqd+N7zJXLwhLdOMkEBcF3OyTWenjUSwLSbWAjVaf/iUH1/W
	 x31HO8clVqM+2ynh+PD+iNnb6xQ7nJoKJCCVktx/xhkKOOX6g2GYkrTaoy/Kz01pbK
	 i0bQDUrLK0qgT3ptXsQdnmIHq6pv4rLEUWuwRgrhAom/PEd0RfnDgLbxZmRpnD/4rb
	 xXIng4m/Otz8uGLnX47NCfvKrNxhupZliaWTtKHVfRizO7gssiUB1DbvuV/Onnl11U
	 dMIdMaS8ct1hhB1IHU/AK9Kg4eodhADY4SqRKaw6Thk/zZ1vlpZ6/b/PXOqsv3hQke
	 GGqksx1b0ZrRQ==
From: Kees Cook <kees@kernel.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 0/4] scsi: mpi3mr: Replace 1-element arrays with flexible arrays
Date: Thu, 11 Jul 2024 08:56:32 -0700
Message-Id: <20240711155446.work.681-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=752; i=kees@kernel.org; h=from:subject:message-id; bh=i/3KGFDv66qPSD7n8HNYgQVzkx1HgSs2Cuq88INApqE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkAC0s6wYNwVUvVXvmE9n8rfNWa+Pc+TWPFWrc 7n3AvVJtnWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAAtAAKCRCJcvTf3G3A JleHD/9E1wzUy9O7FLZxiQGIIl3hn8QhUcnidlHV22PCgtnZBRDBU5xN5WtTZj2vpp+glk92I9I wWMjbat/+zemiBgCwaq9mPvFtJqUni2VX70mrlEg9YUS+Kz8bhJxyrMvMXto+NfREnmZsUAfp6S Qg1xGEIApURdtbPBY7P+xYUiZ9MctA7yc6aa5m4YuxRcqYU2pQVnvtsSZ47hAs2RvUhMZZgPoSP riTNNxNz4aTDk5HgryJHBzo4UczK+3xQvPBUQsv6qB5ZsgODbQyL2C4ISJeyZZVozBqXBeIYDni C4Rped7msEM6R5rRYxkumlcfr5LJLSLH35qKpFY5Sjnih+CUe70eR+eD0h7S43c0e2u6ciWSz4P KsWZyXxe9mrpnq4y3a62bmknU99vZHbCzNfY+nd9Yke+rpPaKaJqH4OLB5nE/MQI7TDQG3ppJUV 2hDeo6tHpRWDoxA8nfO0ET5qI6Okv1CQHeVzJE/Q4tNWktErMcJ0qDNOUHjC3x4CdeWSKmCaS4g +N0L5xDx7spzkiCpZBgPrwN4xPtmZQu8fx1GFe3rWyObdtR6qWXCyBnXM4mxXrh2WBq+bmAN9pL 7RoLuzoHT95znhGsiuiWi85MMtS4JVBfcoaFNcH9u47JPKMTBqBfKnBGFlY36gUvoOH1siBAsYk oBh0ebaQipLVhI
 Q==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi,

Replace all the uses of deprecated 1-element "fake" flexible arrays
with modern C99 flexible arrays.

Thanks!

-Kees

Kees Cook (4):
  scsi: mpi3mr: struct mpi3_event_data_sas_topology_change_list: Replace
    1-element array with flexible array
  scsi: mpi3mr: struct mpi3_event_data_pcie_topology_change_list:
    Replace 1-element array with flexible array
  scsi: mpi3mr: struct mpi3_sas_io_unit_page0: Replace 1-element array
    with flexible array
  scsi: mpi3mr: struct mpi3_sas_io_unit_page1: Replace 1-element array
    with flexible array

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h | 10 ++--------
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h  | 10 ++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

-- 
2.34.1

