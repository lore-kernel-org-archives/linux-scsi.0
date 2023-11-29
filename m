Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6068036B12
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ll43keoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AD4C433C8;
	Wed, 29 Nov 2023 16:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701277114;
	bh=GixZblgZ9/f+iq5yErFhEEQrK+gjEG59Ft4IXq8mnkE=;
	h=From:To:Cc:Subject:Date:From;
	b=ll43keoVx+6mYna+4ZH/BXi2hTrbCjetPKZCbBaJ2mS/xP9isBZNNAyhYmLJZNDiP
	 L6+umOWq4oyE52XTauxva2GuGHc/4krFQNGQINVUdcQiiL4xnLzj4OAOaeXoborHeM
	 2nHQ/xzsgGDADq0/2O8JhwgJ4zhKjI4dLa52IVWrXEFjikagfe8a4jv7+biZOBk7t1
	 /pOwVA0mQ6F63bmFDrY7k5RpaQdyhpwcULsGy2QvcAz5gktHtyQnUKuuTPoog6yVWC
	 JR4Kf2Vdi5aB8jG3PLU9zbYjnT7vU+1ZPlSnfGfqUAjKIz24Q66K7PPIi3vryWyJ3y
	 n5DjL4Fo7JTOQ==
From: hare@kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] libfc: fixup command abort handling
Date: Wed, 29 Nov 2023 17:58:29 +0100
Message-Id: <20231129165832.224100-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

Hi all,

when testing command timeout with the help of XDP I found
that scsi_try_to_abort_cmd() would always return 'SUCCESS'
for FCoE, even if no commands could be sent over the wire.
Which is not only surprising, but also can lead to data
corruption as commands were never aborted.
Root cause was that aborts had been sent twice, once
from FC error recovery and once from SCSI EH, with the
former inducing the latter to assume that the command
was already aborted.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  libfc: don't schedule abort twice
  libfc: Fixup timeout error in fc_fcp_rec_error()
  libfc: map FC_TIMED_OUT to DID_TIME_OUT

 drivers/scsi/libfc/fc_fcp.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

-- 
2.35.3

