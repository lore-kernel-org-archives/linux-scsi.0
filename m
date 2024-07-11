Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757E01A00DE;
	Thu, 11 Jul 2024 21:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720735060; cv=none; b=DjWF6AoBvdBBRNgKNor63k5vX0S8g2lrKbk2gRw9BfiWKk0BUok6PgZ4lkFIh18Ka2Fe91LTJ4rybNwvzAeOmb/7hDNeEEhLp4RXSLq/8AEz+qCG+yYRlwAd2zeVX8GAH6dPuiym00GUvI81IkID+PuCtLLiNVcbCBPbbUbI/VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720735060; c=relaxed/simple;
	bh=ybyGHtzigMOqjGxyaBFEijGZXpaJVJQ9vmvlN/xYw6k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DNTBZmfmhxr3MrhKQlJFhVuq7ilwGMvhKlg29oCHANplgcmyx9K8wIRSOyEsOI/qZAaZsfiY3jBzptjo8w4rQgOeDvOxpVqoowSg+4LfhxSlizO4UW/RDu3TUNP+rBWGYlkJJ16yzz2Mz/Q9jfqV4C4K4SM784NtxM1EUHXEAxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyxhCn65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyxhCn65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15511C116B1;
	Thu, 11 Jul 2024 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720735060;
	bh=ybyGHtzigMOqjGxyaBFEijGZXpaJVJQ9vmvlN/xYw6k=;
	h=From:To:Cc:Subject:Date:From;
	b=fyxhCn65O0fL5Nm5CGAL/QB4Do+KHjGMMjZPxX+sVc4H83mjnFayLNnl4htXv69SQ
	 3qdD88En/n9wrZuHkwO3M/W3+nY1rm+viDEVIkwCBLtKOICL2RHfKu3wB+Q5Usky4T
	 e9TgzzFPwxyYnpDRb6os6pePlIiiyX5Z6XOXrXiZuqYzjC0YByjBdGeoOeR8NnM3r9
	 hdJ+0VtH21xpII2hHACWCV64uPIHTopTWOnXbG/nn8opETJImp0GN6kCc+HV0DyA/H
	 I57L36qLf8PzyRHK99LDUJmQVzH/v08D9sT1foVoJ3X6ijsYXHigjU1b/gHIgTNMxz
	 y2an+BjZuuaxQ==
From: Kees Cook <kees@kernel.org>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 0/2] scsi: aacraid: struct sgmap: Replace 1-element arrays with flexible arrays
Date: Thu, 11 Jul 2024 14:57:36 -0700
Message-Id: <20240711212732.work.162-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022; i=kees@kernel.org; h=from:subject:message-id; bh=ybyGHtzigMOqjGxyaBFEijGZXpaJVJQ9vmvlN/xYw6k=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkFVSFXvDE+43NNFnHJ1H7JDM3JDiB473Tr38G QFs5Y1V3SCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpBVUgAKCRCJcvTf3G3A Js26D/9tz2/3LOkXmEYeBUeNrZkqGkGNi55YQp9+H7SwRq0hmT1BEFDlB6ufjRkHMvWs41Y1sEy vNvC7gOgi1DVp+lxTyJCxByUT1a5490MoJwzuI6hRuia0HXJuWXOc0JGZL86T1yhUartNOcK3GF 0xs0/Sh8QwxnLQfD9vd5CkxfV+CN5wfJrwwhgHe8LtjIZ+srv8rfKCYfhoNjV1Wx0xwCm+RC+3o tdFAJLEgeFiglAPUdhdoJDmdALq224DFBkJVA9HxBkQYRR49hIfYR6h7GX2pxR0iRZQKjiB+mZT sB6N/HXNmfxs2rVEhEO+uMw/LIi+qmSagO0ChUQSvXOaVuzTCqW59iEWMKp9hFnFeeo63zonBt2 FR8zAl1x5aXGMkLIe9rXjuji4jiaUjCK27tWo5TKrkkgrtX1M0xwxcxq1Q4bfkpjPG9QXaEuBko yWa1/s9jf3ldMHxTYGzOyM9844vXZC2bGaDLfEWx0t55gt/duAYnj7sFPqO7Iqk2FCuxrCOAGD7 V6w4ens4bvF4/YHJB5nVwiEAMDFmKBCL7A3TBxjW/15f2kZYagDxFwoRdsFUulgJHgDNy/e7RtO QaYaFJSv6hlxzFp3wPH44QB1ekz9DBWMgu+0g5B2iNRAp7JUoaAw5jPTTp34OgWiKLa7LCBr0sO luYgP4Lnkg6Xx
 gw==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Hi,

This replaces some of the last remaining uses in the kernel of 1-element
"fake" flexible arrays with modern C99 flexible arrays. Some refactoring
is done to ease this, and binary differences are identified. For the
on stack size changes in patch 2, the "yes, that is the source of the binary
differences" debugging patch can be found here[1].

Thanks!

-Kees

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=dev/v6.10-rc2/1-element&id=45e6226bcbc5e982541754eca7ac29f403e82f5e

Kees Cook (2):
  scsi: aacraid: Rearrange order of struct aac_srb_unit
  scsi: aacraid: struct {user,}sgmap{,64,raw}: Replace 1-element arrays
    with flexible arrays

 drivers/scsi/aacraid/aachba.c   | 26 ++++++++++++--------------
 drivers/scsi/aacraid/aacraid.h  | 17 ++++++-----------
 drivers/scsi/aacraid/commctrl.c |  4 ++--
 drivers/scsi/aacraid/comminit.c |  3 +--
 drivers/scsi/aacraid/commsup.c  |  5 +++--
 5 files changed, 24 insertions(+), 31 deletions(-)

-- 
2.34.1

