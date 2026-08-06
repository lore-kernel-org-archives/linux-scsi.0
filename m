Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BEA4D8D82;
	Thu,  6 Aug 2026 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044258; cv=pass; b=WYNxX42cE+mGUitcwcmoEUzWF/L1bD2+qA8aEznt6SBRF5ldf3zN0OyoDu8NS6HhJ/DsbyfB5oJSRxn/Hm9RlZTnkymA9dQR4NtEpqGLpTelCW225e3RUgumhyeYF+UiHUd985bp74zYyMwlP1639Sv9bHess3glqvl8IwLNOMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044258; c=relaxed/simple;
	bh=4BbnY4/j21/I8t5IgRCPUUAvyij8t/0TAQAsKMEjumw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WHP25KgO6gxTmNe1YU4JZ+jktE9+5NnYiEBXyWfGEjwDOCMkg/rAIZwSxH6yUdi5/XkwRo8kNhw/M7Wb78Jaw85I49YwJxF4F0LCVQ+ka7ybMw7P092WqEvFA38b77wdfjnxazHeHGzMfSRoAdbroF1QBZ4zbEb+aCa9pY4JASw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=k334h+Bf; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="k334h+Bf"
ARC-Seal: i=1; a=rsa-sha256; t=1786044240; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=dY3hOwk/KnLuZsGr6LK02N8VSYmefXvLSTLVA50OoINfk5ztbSfaTNUwW+ZTNtkd2xhgziEyu5LIfr56TDFxkoPv5rJ6XqHZUvaTvl7VMtoTyrh1MPRZeVMVzHKp+V7swNa3dPVPqax+tJf3RAt3vbnisSJelnsUDJvfh5SCsdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786044240; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=z8RYdDe9a98puOQuwJ66DJNO9/NZcwQZ7WsElzSXQDE=; 
	b=Um/Q2/MrQHIfJVVGbg0f36xjirnf1NOcW9J5arA2FKFL3QnK/Eu1fJTGFpg2V9T7KxWeVb2SVJbvQLBm2/I0aFD+fc1oJFlYISBDcCNgCylPtPQl0LH4P1Sz9+zjKDBRQbkwMMMjKHv/X4Oks8M5ZUaF+qXuIiUquOqX2OpKSYE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786044240;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=z8RYdDe9a98puOQuwJ66DJNO9/NZcwQZ7WsElzSXQDE=;
	b=k334h+BfnAK59arXOhM8RmVkeIXSFkP0fobuNsLt7dXuX/lVPpqkZLtumZu5Zz68
	ZylGSfzRAJsRxni5DxHMg7Le/wGRH7eYTIYLh0qJQQ1MWMB+OEm7oXfGe5BLm9tFuYT
	1LQjhSVG1pfLJwVGHXdmZIGMLTfWYLRlg6Gtn8xc=
Received: by mx.zoho.eu with SMTPS id 1786044238114475.3599695668004;
	Thu, 6 Aug 2026 21:23:58 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] scsi: elx: efct: fix resources stranded on failure paths
Date: Thu,  6 Aug 2026 19:23:40 +0000
Message-ID: <20260806192345.328621-1-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Five places in efct take a resource and then return an error without
giving it back. Three of them lose an entry from a fixed size pool, which
stops the driver working once the pool is empty rather than growing
memory; the other two are ordinary leaks.

  1  efct_els_hw_srrs_send() checks hw->state after taking an HIO
  2  the WQE builders in efct_els_hw_srrs_send() and efct_hw_bls_send()
  3  the WQE builder in efct_hw_send_frame(), which loses a request tag
  4  efct_hw_rx_buffer_alloc() drops the coherent buffers it mapped
  5  efct_hw_setup() leaves its two mempools behind

Patch 5 is the one I could exercise. Binding the driver to a PCI device
that is not an SLI-4 adapter makes sli_setup() fail after the mempools
have been created, and efct_pci_probe() then frees the struct efct that
held the only pointers to them. Repeating that probe 61 times under
CONFIG_DEBUG_KMEMLEAK:

  before   1566 unreferenced objects, every one from efct_hw_setup()
  after    none, and the probe still fails the same way

Patches 1 to 4 are reasoned from the code. They need a real Emulex SLI-4
adapter, and for 1 to 3 a live FC link as well, which I do not have. Each
patch builds on its own.

I deliberately left the efct_hw_wq_write() failure paths alone.
efct_hw_wq_write() appends to wq->pending_list and drains from the head,
so it can return an error while this request is still linked there.
Releasing the HIO or the request tag at that point would leave a later
completion looking at something that has been handed back, which needs
more than a free on the error path.

Also not addressed here: efct_xport_attach() and efct_xport_initialize()
return without efct_hw_teardown() on some paths, and efcport_init() leaves
its first two pools behind when the third allocation fails. Those cross
two modules and I would rather send them separately once this is settled.

Ali Ahmet Memis (5):
  scsi: elx: efct: check the HW state before allocating an HIO
  scsi: elx: efct: free the HIO when the WQE cannot be built
  scsi: elx: efct: free the request tag when the send frame WQE fails
  scsi: elx: efct: free the RQ buffers already allocated when one fails
  scsi: elx: efct: destroy the mailbox pools when setup fails

 drivers/scsi/elx/efct/efct_hw.c | 71 +++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 26 deletions(-)


base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
-- 
2.55.0

