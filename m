Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8472428851E;
	Sat, 20 Dec 2025 03:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766201872; cv=none; b=bXVaeA9UCKhPztVbVhTfnsS+XRhLADEKV2HtQnlufjEetVBycWjMVtGWkDSOq1BmVflFynX4YH6MPuDjtjZppEem0fYmTrH7ZvcUqKSw2yzbMUW3Nwk/YPgjApI2g6gmdiaUWPqoUJ8C5B3VEPnNhUC1JXrwWVtyL9C9fdGethU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766201872; c=relaxed/simple;
	bh=HH/JkDbNtOuD2LUYt73XeTz04R3YloDbVp6N3jCsuLo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ealx8yCV62LX7O98pndTN3IFxYnYY3GQULT9HCsXp696COCQc+O7HiMZ7p5o7KrkuuqL8Js0dCnCf5QD82WnW3cvw2+ri8T43HCzIg5FZfWPnm5sKcfR1vPna5dXIPeoZdTzyW0UPIMiww6TVvf8uqdbMceTts7CC4CXpQ1/C5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3/fmvXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3/fmvXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0036C116D0;
	Sat, 20 Dec 2025 03:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766201872;
	bh=HH/JkDbNtOuD2LUYt73XeTz04R3YloDbVp6N3jCsuLo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f3/fmvXFHtzt9PtxK9qrxGV1fUBjOhRnv5R8uNJmBBI20i4s5FK6HbLfvhmW8L2cb
	 ku4VxlqtLDSNX9x6TOYgJXNcJoaZT/4Yo+KXweM6qq5m41bgrN1o9aZSDOg732zMKh
	 G5t1FBXUsy9eD1ZS4G4AnSBNfmsSCqZcWBDUEbLnlSXZjF5Z8w6f0e8lPxR2yueeOs
	 +bTf3WULY4ruMdX51OLdGBN8NAihHToZcU9kbDdYGXFmycu0/Nd5IeMImsI8quUUSm
	 GxZVTxPSxLHrroyotDQKgWTj5933kZOWrH3BZSO+w239oRIfA+y0KWBasxLRaXBaCD
	 vZD7Y9Drw4x/w==
From: Daniel Gomez <da.gomez@kernel.org>
Date: Sat, 20 Dec 2025 04:37:33 +0100
Subject: [PATCH 2/2] scsi: fcoe: replace -EEXIST with -EBUSY
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-dev-module-init-eexists-linux-scsi-v1-2-5379db749d54@samsung.com>
References: <20251220-dev-module-init-eexists-linux-scsi-v1-0-5379db749d54@samsung.com>
In-Reply-To: <20251220-dev-module-init-eexists-linux-scsi-v1-0-5379db749d54@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Hannes Reinecke <hare@suse.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, Lucas De Marchi <demarchi@kernel.org>, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daniel Gomez <da.gomez@samsung.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1199; i=da.gomez@samsung.com;
 h=from:subject:message-id; bh=FgSTMAzeVqUCp3js9k2Z85lbAWLiKtgMkleg7Noq7jY=;
 b=owEBbQKS/ZANAwAIAUCeo8QfGVH7AcsmYgBpRhoGuU7bc3awxEAzGNi42WmPFgOXPTCEPZhrD
 TppiRhKBFCJAjMEAAEIAB0WIQTvdRrhHw9z4bnGPFNAnqPEHxlR+wUCaUYaBgAKCRBAnqPEHxlR
 +xf8D/44XWi0lkbuwLb2VzoLqtxPN39O9Eti8wfngbn9bRy5nSbhF3n/RHcvj10qm2y0LZQTGGu
 mjmBK7lGe26JvDZnmzeWg+9KR+aOXXAZWI9jW2vxkQocqgL89HAG7QOfGtZjO9Q+mJZKEN6ejX3
 4eCYU+JxTitEgD4YRx70GZ9p7tXXT+rmzHu76OA4FhsCc5fnLmJzhHkn3FrK+XUxDZWOrcViBMG
 qT6yWwYneCudTKlIqwRQyJY3okLCN5hWah33S/5dwTHMIwYAT3L7qK2RSHoVU6uexVhs4NUukZc
 M7VG4q4EIKou3dnPpVrYe+bbA+04r+S/3xprv7feOebOuKiqSP6/2tqHgLpYXNhDVNaUVzQgJLX
 6te4DFuRCyB02lOF1DecMGdCjfxZb3MBBQAr40CrF3eH07P43mZdvqPOMtVitB/9UxPzEztLTQw
 9zWvjhdelfjjZNADD4u/R8oxaoWlbwQrmnqWHaN5oD2bRecWitgUP2XM2NyC7+V/HJclrIBxF/G
 T9D6N8SXHrrt/hGNI6OCwqGOWVqqJsjhEdlmjrRBAKN/ZxkNk1EcLFkITMngam0iNhzieq4h2Tn
 1Yr7CrRbBlrJ6DgIv8D3qTnH0yGWrlP0B0+jqFqWbr7regtpzVHGoP3lLFQFG4zrFuZSQp//On3
 El92YFkjfixKH8w==
X-Developer-Key: i=da.gomez@samsung.com; a=openpgp;
 fpr=B2A7A9CFDD03B540FF58B27185F56EA4E9E8138F

From: Daniel Gomez <da.gomez@samsung.com>

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

This follows the precedent set by commit 54416fd76770 ("netfilter:
conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
issue in nf_conntrack_helper_register().

Affected modules:
  * bnx2fc fcoe

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
 drivers/scsi/fcoe/fcoe_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 2f478426f16e..d0f9ff4893e3 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -533,7 +533,7 @@ int fcoe_transport_attach(struct fcoe_transport *ft)
 	if (ft->attached) {
 		LIBFCOE_TRANSPORT_DBG("transport %s already attached\n",
 				       ft->name);
-		rc = -EEXIST;
+		rc = -EBUSY;
 		goto out_attach;
 	}
 

-- 
2.52.0

