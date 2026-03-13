Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5788E377014;
	Fri, 13 Mar 2026 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773400094; cv=none; b=WCa24o4qFbE4Dp4xO7UGF7JCh/7aqDnCJB8H5exs2cS/lK1jcBUPZktPUy0ti5yYRQphNKViNIltZeyqX46UPecuIBK+4F2eX/ZUf+M5cp9uJT8EzI6ZXf+SGHXoihngiCkF63ItTKPq5Jy9HbAXwRWi+PzGsAfEgLDF1adSxxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773400094; c=relaxed/simple;
	bh=Cf5l6n023JmRVMEGoiHsKj8gPoJnCH/gYx+67lOpN1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRw+xJrdclKyuFWnur90Yyaqk4zAch1eUNruraJTtpHpgfcERkuhrtblhhZKBxSjpgM3a/E5xUQVvl3pRTp1t8U9weZ6WP+B2iTBZN/FDR/RlRUeo9FKZLGO13/5vWAde1/VLpBH4RpZp+mWiS5ENG4TEqf1vwwZkAb3AnawEUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V+cY0BjR; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V+cY0BjR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773400079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F4uzVIqz7pq7OLZ2jBdjHr4kmFUvKLHY52M+cHA2QeM=;
	b=V+cY0BjRyCwwv+an7013A6hvA3GyXKTxVzI0c7mg6CUX4RHl0JdUtUuEibl7yaHJKANQrY
	sfoNtKukyd5R0qYUnFCiFxmhMBVUE3qhkBh4TFl3MaFTV1RL2OfuYZ423tSWXHrbh2SiI7
	HmHqIv7Jx07xOw2GrVC1AFAIcvl9ClA=
From: Usama Arif <usama.arif@linux.dev>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 05/15] fs: afs: correctly drop reference count on mapping failure
Date: Fri, 13 Mar 2026 04:07:43 -0700
Message-ID: <20260313110745.2573005-1-usama.arif@linux.dev>
In-Reply-To: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour of
> the deprecated mmap callback.
> 
> However, it did not account for the fact that mmap_prepare can fail to map
> due to an out of memory error, and thus should not be incrementing a
> reference count on mmap_prepare.
> 
> With the newly added vm_ops->mapped callback available, we can simply defer
> this operation to that callback which is only invoked once the mapping is
> successfully in place (but not yet visible to userspace as the mmap and VMA
> write locks are held).
> 
> Therefore add afs_mapped() to implement this callback for AFS.
> 
> In practice the mapping allocations are 'too small to fail' so this is
> something that realistically should never happen in practice (or would do
> so in a case where the process is about to die anyway), but we should still
> handle this.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  fs/afs/file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index f609366fd2ac..69ef86f5e274 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
>  static void afs_vm_open(struct vm_area_struct *area);
>  static void afs_vm_close(struct vm_area_struct *area);
>  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
> +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +		      const struct file *file, void **vm_private_data);
>  
>  const struct file_operations afs_file_operations = {
>  	.open		= afs_open,
> @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
>  };
>  
>  static const struct vm_operations_struct afs_vm_ops = {
> +	.mapped		= afs_mapped,
>  	.open		= afs_vm_open,
>  	.close		= afs_vm_close,
>  	.fault		= filemap_fault,
> @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area_desc *desc)
>  	afs_add_open_mmap(vnode);

Is the above afs_add_open_mmap an additional one, which could cause a reference
leak? Does the above one need to be removed and only the one in afs_mapped()
needs to be kept?

>  
>  	ret = generic_file_mmap_prepare(desc);
> -	if (ret == 0)
> -		desc->vm_ops = &afs_vm_ops;
> -	else
> -		afs_drop_open_mmap(vnode);
> +	if (ret)
> +		return ret;
> +
> +	desc->vm_ops = &afs_vm_ops;
>  	return ret;
>  }
>  
> +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +		      const struct file *file, void **vm_private_data)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> +
> +	afs_add_open_mmap(vnode);
> +	return 0;
> +}
> +
>  static void afs_vm_open(struct vm_area_struct *vma)
>  {
>  	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> -- 
> 2.53.0
> 
> 
