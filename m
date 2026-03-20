Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6AF3ECBD0;
	Fri, 20 Mar 2026 22:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774046443; cv=none; b=UAa/t6vGn+cC1P0k29kZy/1tPbEUdjakbN5F8TSLCxQ+ECWoEU+QkNDOkpXOsft1ZVkOhdyNSv5xpKjhgPFHQrP5azxraPVAD9ZsFcxb+EYS1oMmrxtcCqO5deF5f6AEpYe8g5AQOOD8LDmebtqmeIUHtpcOYZts7+gRJUGNh58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774046443; c=relaxed/simple;
	bh=LhT0XvoqFL5inoAn3uLwrHjF8WgiWC6oU1y5hKpoQX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDZenYo0oR2Y9E1O9BdYSeyORnvz5Fsyws+Ik7hB2/4qipi3ro0SCRp9CRVtVhEaECwa1j4/LZlNQ45bTYCJvJ/CGhw1AbzKso0xd3anXNQ8mJqrXnq4ScGohC2ht8yUmcaNPwD9mftNhKkCInsANPacZ07YnL+mw6IZiVMvWq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4wHJxsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4wHJxsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DC0C2BCB2;
	Fri, 20 Mar 2026 22:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046443;
	bh=LhT0XvoqFL5inoAn3uLwrHjF8WgiWC6oU1y5hKpoQX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4wHJxsh7bYrI5l9ypzEJJtRUNeMWoz2qQ6/CYcGcW6jBmZWlRSJKuTUhZQe/WKcc
	 VsRAogHYE/GMTSF9k7KQwCnYeraYqnjeiTQJaiZBwJd5wOH1b5ayrRDW5yDMQKY6dy
	 bW61X0wOKU66c5WTPw0B4hbi18iGnFEHGTz0G67J9Z6ohhrp6ooCSCEj89MEkcqpqQ
	 DBw1rYls5FAig8H/X2et7iKJdCKYxZ3BBE/j4VlCfyTSw9b6kXjs+yVPrNaB4Jc0wx
	 j64mDAAaOvoFQEKZ6nZg2+wIkP8ME7WDB+olROlFem2adm+nNFPwxfPpzTeZ7TkxD6
	 hVTZFsJ0VtaSw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 13/21] hpet: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:39 +0000
Message-ID: <094c5fcfb2459a4f6d791b1fb852b01e252a44d4.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The f_op->mmap interface is deprecated, so update driver to use its
successor, mmap_prepare.

The driver previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/char/hpet.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 60dd09a56f50..8f128cc40147 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char *str)
 }
 __setup("hpet_mmap=", hpet_mmap_enable);
 
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	struct hpet_dev *devp;
 	unsigned long addr;
 
@@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 	if (addr & (PAGE_SIZE - 1))
 		return -ENOSYS;
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	return vm_iomap_memory(vma, addr, PAGE_SIZE);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
+	return 0;
 }
 #else
-static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+static int hpet_mmap_prepare(struct vm_area_desc *desc)
 {
 	return -ENOSYS;
 }
@@ -710,7 +712,7 @@ static const struct file_operations hpet_fops = {
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
-	.mmap = hpet_mmap,
+	.mmap_prepare = hpet_mmap_prepare,
 };
 
 static int hpet_is_known(struct hpet_data *hdp)
-- 
2.53.0

