From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/5] (REPOST) arm: implement flush_kernel_dcache_page()
Date: Sun, 4 Jun 2006 12:49:16 +0900
Message-ID: <20060604034916.GD8106@htj.dyndns.org>
References: <1149392479501-git-send-email-htejun@gmail.com> <1149392479281-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1149392479281-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, rmk@arm.linux.org.uk, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Implement flush_kernel_dcache_page() for arm.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

Sorry, the patch contained in the previous post was generated against
the wrong base.  Please ignore it.

 include/asm-arm/cacheflush.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

fad719d62838161fb0d6f306c6e060f8ef2ddfd0
diff --git a/include/asm-arm/cacheflush.h b/include/asm-arm/cacheflush.h
index 746be56..7ab6ec3 100644
--- a/include/asm-arm/cacheflush.h
+++ b/include/asm-arm/cacheflush.h
@@ -331,6 +331,12 @@ #define flush_dcache_mmap_lock(mapping)
 #define flush_dcache_mmap_unlock(mapping) \
        write_unlock_irq(&(mapping)->tree_lock)

+static inline void flush_kernel_dcache_page(struct page *page)
+{
+       __cpuc_flush_dcache_page(page_address(page));
+}
+#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
+
 #define flush_icache_user_range(vma,page,addr,len) \
        flush_dcache_page(page)

--
1.3.2
