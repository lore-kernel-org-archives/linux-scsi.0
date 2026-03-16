Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA8537649C;
	Mon, 16 Mar 2026 21:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773695657; cv=none; b=C5+QH1aLzYLoI7l+1CZGmXsluLnpWg2vM6jfNea3K0LAJUZ4xPTVy2RtlIUF88ZM9+DnrBd1hQMKHmJn2sQJirTWN573oDEByuXqmVvjbhT5BA17j2DhVcewE34F1WNfzkcKdYeZBp+T/+UsmTLjUvu/DSurYc49GygDwG/wGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773695657; c=relaxed/simple;
	bh=fgCpyzFg81kyNJg/EfR9MYplzdNgFwcM7fKHK8x1TBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb0WCluGZif1FNJV24+p4qDxhGrRHCJ2WmGGISLHxn+e9Rigi8MHQEA9+4DAjcYMway/vlMjLFPw2QrdWid8bmYRkdI6zDGEFI2bsw7VTnzrD+HE2Z6LRGjqhyvYeziLTkfmuNrYy2bg5Ezs/DJ+hGYp+CwQOB6kT/DL4Awwbn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9wa1g+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9wa1g+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B998C19424;
	Mon, 16 Mar 2026 21:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695656;
	bh=fgCpyzFg81kyNJg/EfR9MYplzdNgFwcM7fKHK8x1TBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9wa1g+qYZKP6JvRfHYdd3Mi7gE2gobzLF3Ef0Hpjr5s4CKaZ03ETRYKOxBQksNe5
	 kvq7s2PDuJ1CxtBB2Zbp24YhKCzCA6585G1sYDVP59cf4EQTIvrNaxH6jCTahGeH8+
	 nX2aJven1SgNUxh6mp5GdVaNUBRPKrwHJHJpRPFDvJSR/h0YUmjAWYZI/S+ef9Cxp1
	 TuIHRbmGdEMHNnllEIgEiUsIIGxhRkjTEHGe1m8A0voIHe2vkHveO0bJ2nsGF/BeXt
	 +XAAykshocro6yJ4+7d6BUurBngpzoZH0nPFZ3REHSh7l8WhwsIHx/5WwesU3quOSL
	 ph8COYuLyZSyA==
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
Subject: [PATCH v2 14/16] uio: replace deprecated mmap hook with mmap_prepare in uio_info
Date: Mon, 16 Mar 2026 21:12:10 +0000
Message-ID: <892a8b32e5ef64c69239ccc2d1bd364716fd7fdf.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The f_op->mmap interface is deprecated, so update uio_info to use its
successor, mmap_prepare.

Therefore, replace the uio_info->mmap hook with a new
uio_info->mmap_perepare hook, and update its one user, target_core_user,
to both specify this new mmap_prepare hook and also to use the new
vm_ops->mapped() hook to continue to maintain a correct udev->kref
refcount.

Then update uio_mmap() to utilise the mmap_prepare compatibility layer to
invoke this callback from the uio mmap invocation.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 drivers/target/target_core_user.c | 26 ++++++++++++++++++--------
 drivers/uio/uio.c                 | 10 ++++++++--
 include/linux/uio_driver.h        |  4 ++--
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index af95531ddd35..9d211dad5e53 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1860,6 +1860,17 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 	return NULL;
 }
 
+static int tcmu_vma_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+			   const struct file *file, void **vm_private_data)
+{
+	struct tcmu_dev *udev = *vm_private_data;
+
+	pr_debug("vma_open\n");
+
+	kref_get(&udev->kref);
+	return 0;
+}
+
 static void tcmu_vma_open(struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = vma->vm_private_data;
@@ -1919,26 +1930,25 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 }
 
 static const struct vm_operations_struct tcmu_vm_ops = {
+	.mapped = tcmu_vma_mapped,
 	.open = tcmu_vma_open,
 	.close = tcmu_vma_close,
 	.fault = tcmu_vma_fault,
 };
 
-static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
+static int tcmu_mmap_prepare(struct uio_info *info, struct vm_area_desc *desc)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
 
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &tcmu_vm_ops;
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &tcmu_vm_ops;
 
-	vma->vm_private_data = udev;
+	desc->private_data = udev;
 
 	/* Ensure the mmap is exactly the right size */
-	if (vma_pages(vma) != udev->mmap_pages)
+	if (vma_desc_pages(desc) != udev->mmap_pages)
 		return -EINVAL;
 
-	tcmu_vma_open(vma);
-
 	return 0;
 }
 
@@ -2253,7 +2263,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	info->irqcontrol = tcmu_irqcontrol;
 	info->irq = UIO_IRQ_CUSTOM;
 
-	info->mmap = tcmu_mmap;
+	info->mmap_prepare = tcmu_mmap_prepare;
 	info->open = tcmu_open;
 	info->release = tcmu_release;
 
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5a4998e2caf8..1e4ade78ed84 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -850,8 +850,14 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 		goto out;
 	}
 
-	if (idev->info->mmap) {
-		ret = idev->info->mmap(idev->info, vma);
+	if (idev->info->mmap_prepare) {
+		struct vm_area_desc desc;
+
+		compat_set_desc_from_vma(&desc, filep, vma);
+		ret = idev->info->mmap_prepare(idev->info, &desc);
+		if (ret)
+			goto out;
+		ret = __compat_vma_mmap(&desc, vma);
 		goto out;
 	}
 
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 334641e20fb1..53bdc557c423 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -97,7 +97,7 @@ struct uio_device {
  * @irq_flags:		flags for request_irq()
  * @priv:		optional private data
  * @handler:		the device's irq handler
- * @mmap:		mmap operation for this uio device
+ * @mmap_prepare:	mmap_pepare operation for this uio device
  * @open:		open operation for this uio device
  * @release:		release operation for this uio device
  * @irqcontrol:		disable/enable irqs when 0/1 is written to /dev/uioX
@@ -112,7 +112,7 @@ struct uio_info {
 	unsigned long		irq_flags;
 	void			*priv;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
-	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
+	int (*mmap_prepare)(struct uio_info *info, struct vm_area_desc *desc);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
-- 
2.53.0

