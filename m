Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAED82F1FDE
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 11:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755085286; cv=none; b=Z5tiBk7w3Zy7VEa6XcMZf5eCjIZCIrA3nPtwzeKwFqcB9gmwsbHN+nh81MSvgzmGTFjbsOHadFUnFcWzzIXZGjJYLxIHrot1Qe3S3vhe6JnYbhGwAB1sbwF+uqOelZRQdDM/y/62TmqY/wiEODhc9Qw/JTyo1Fa9z7xH5IFfuXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755085286; c=relaxed/simple;
	bh=biRIPas1N87/fBnwI8Gt8gt91iGupOwkAOlNfs6T9hs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pQLHOM43SvfOALGwU4CLuzjGE8O8AyyR2rKJoWAvJTQB2xunLqxYPuNzPfwLiU4XrECh4elKy/AjnwbY9Pbiev1D87orXrNNIM0Gu3ja/5Y4t6N2RXwzMau768SIwUarUK5NialFiS06dmZpG4XxTqAmbS0XaSOuAqero+lIUds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrFjUZ2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrFjUZ2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071C2C4CEEB;
	Wed, 13 Aug 2025 11:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755085286;
	bh=biRIPas1N87/fBnwI8Gt8gt91iGupOwkAOlNfs6T9hs=;
	h=From:To:Cc:Subject:Date:From;
	b=RrFjUZ2q3vYy3sl4vYgxQDo9dKIFz0YdCZbysozKP6tnrbEACzMqBEoTP+fE/PmpM
	 v17lHoloxXy+G86yE3TGmCSGGJg8xjf4gLlhOahz5nIwKbBxKLEn0E1qfD9suWz2Mh
	 woR579ud9j/6uxVTGihP9XmeOMdpBXS23qGs5Ls7sYY9c++EckmDSaPf7UfgUKIgXO
	 cXN1jauMFhioG9s2jZAw7IDfXoU88k83U5Mt/16zbdlaNSnKlTNfHfSiWCvrvPxdIN
	 r47wtuvVNyCFvIqzcssmyLTZelLh6+1/m7O28ZX3XOtbhSBgbfCLgb09iQLHAApzJM
	 0EgCCJ9P2JJOQ==
From: Niklas Cassel <cassel@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	Viswas G <Viswas.G@microsemi.com>,
	Deepak Ukey <deepak.ukey@microsemi.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jack Wang <jinpu.wang@profitbricks.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 0/5] scsi: pm80xx: Fix expander support
Date: Wed, 13 Aug 2025 13:41:07 +0200
Message-ID: <20250813114107.916919-7-cassel@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1073; i=cassel@kernel.org; h=from:subject; bh=biRIPas1N87/fBnwI8Gt8gt91iGupOwkAOlNfs6T9hs=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGDLmVF7Ot3Zt2iu//uKzU1dd9z+IXl51o/Phy40PNK4vZ DpktSn1XkcJC4MYF4OsmCKL7w+X/cXd7lOOK96xgZnDygQyhIGLUwAmEmrFyLD1956Vessf7S7i C3fIqSqo6eELdxRImNUneJ1t37GLficZvikqXijMDn2ib37xo2taMmtp0BuFHfUz2BO7BGo6VrF yAQA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Hello all,

Some recent patches broke expander support for the pm80xx driver.

The first two patches in this series makes sure that expanders work with
this driver again.

It also fixes a bug in pm8001_abort_task() that was found through code
review.

The final two patches make the driver more robust, so that is less likely
that the expander support will break again in the future.

Please test and review.


Kind regards,
Niklas


Niklas Cassel (5):
  scsi: pm80xx: Restore support for expanders
  scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
  scsi: pm80xx: Add helper function to get the local phy id
  scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an
    expander
  scsi: pm80xx: Use pm80xx_get_local_phy_id() to access phy array

 drivers/scsi/pm8001/pm8001_hwi.c |  8 +++-----
 drivers/scsi/pm8001/pm8001_sas.c | 34 +++++++++++++++++++++++++-------
 drivers/scsi/pm8001/pm8001_sas.h |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c |  7 ++-----
 4 files changed, 33 insertions(+), 17 deletions(-)

-- 
2.50.1

