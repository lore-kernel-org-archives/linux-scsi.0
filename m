Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783573D88F1;
	Thu, 21 May 2026 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370410; cv=none; b=W80YcKp/g6nuVsnWFcAi9+4fmG4w0a1zI7dPzcn3S0qmTMPfcFfssGmp9U0EUm682OAMXD/dZr8BlmFWZwm9PAQM7jE9SbIAAoK9vJPdEhPF7lG0PI5iDc2a5YhL8WcgHMvouaVxCBT+mk3SDv9HzYYO8RcRt664o5xEXpV03n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370410; c=relaxed/simple;
	bh=vLGSuUHmnLi1/YHHelOJK4C4TcXRiKv4YFWn5np0glM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oU+vyFNwa/iAVuj1yjd+xIJafNuoFh+v4X0DwBTo2t+CxiatqMIUA/A5AnVTDpKHQ4g1x0hUTm+gIjlKEKxpJoBeMIcwheffd7BAQrrrzlUI0BzXCiCSdy//P2SxJBg8n/vZWKYYkq53PE3Rx93OOMNcQTuC3GcxuHBTleCfGB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OsMbrSfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OsMbrSfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD6A1F00ADE;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370406;
	bh=D92GfeXfztwtGh+NKFXW+ejJ7GCi/ckBt7Icqwg1tfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsMbrSfwtX1kazk5IQM74ggG4Dvao03ITo2rB7fjYJyw9ABWXfqI+9aA5qAj2SR/5
	 bCJNN1CMD9hyb5ppglH/pZwAMSiek0jplgAMqEVVQL5JpcL8KAc0T0+rQaEkPfLgZJ
	 h9CesS2RNlFMe0lhxQwlPJ5aoyzt8jSouyNeQ/ut9fjkrIWPM1iotTIo8B7ZH0pEOt
	 PXBO5iwh3tZMUmZ6TsOUjTCKa3JTEC0MG2ngQVnXCKyNc+yajzL20Z6iBGWjesqILa
	 wl9GSf1Gtg2R6s/MvPcceAUrPZB+a/bbJr58Jk3b4DpNimJFAtwQW4sG1Fmcwkxlwv
	 gBE9pRr5KxqXg==
From: Kees Cook <kees@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Corey Minyard <corey@minyard.net>,
	Gabriel Somlo <somlo@cmu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	kvm@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	qemu-devel@nongnu.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 05/11] moduleparam: Rename .get field to .get_str
Date: Thu, 21 May 2026 06:33:18 -0700
Message-Id: <20260521133326.2465264-5-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
References: <20260521133315.work.845-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3072; i=kees@kernel.org; h=from:subject; bh=vLGSuUHmnLi1/YHHelOJK4C4TcXRiKv4YFWn5np0glM=; b=owGbwMvMwCVmps19z/KJym7G02pJDFn8nAsD4o0V/uTmcB53njx1B6e/bj7HRgn2VXOEOnsWp wZ2X7zWUcrCIMbFICumyBJk5x7n4vG2Pdx9riLMHFYmkCEMXJwCMBEONkaGy7PKr73Ur1Czz5B6 etdJJuEbm4bhmk/7zrsdOuT8PYl9KSPDwTtq/fyyAtr+f2YaPvkpdWtWnGfLNNfmFeI5M+tXlVf wAAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Now that every kernel_param_ops initializer in the tree goes through
DEFINE_KERNEL_PARAM_OPS, no source file outside kernel/params.c and
include/linux/moduleparam.h references the .get field by name. Take
advantage of that to rename the field to .get_str.

The bare .get name is now free for the next commit, which adds it
back as a struct seq_buf *-based callback.

Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/moduleparam.h | 8 ++++----
 kernel/params.c             | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 26bf45b36d02..f5f4148e2504 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -63,7 +63,7 @@ struct kernel_param_ops {
 	/* Returns 0, or -errno.  arg is in kp->arg. */
 	int (*set)(const char *val, const struct kernel_param *kp);
 	/* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
-	int (*get)(char *buffer, const struct kernel_param *kp);
+	int (*get_str)(char *buffer, const struct kernel_param *kp);
 	/* Optional function to free kp->arg when module unloaded. */
 	void (*free)(void *arg);
 };
@@ -82,7 +82,7 @@ struct kernel_param_ops {
 #define DEFINE_KERNEL_PARAM_OPS(_name, _set, _get)			\
 	const struct kernel_param_ops _name = {				\
 		.set = (_set),						\
-		.get = (_get),						\
+		.get_str = (_get),					\
 	}
 
 /* As DEFINE_KERNEL_PARAM_OPS, with KERNEL_PARAM_OPS_FL_NOARG set. */
@@ -90,14 +90,14 @@ struct kernel_param_ops {
 	const struct kernel_param_ops _name = {				\
 		.flags = KERNEL_PARAM_OPS_FL_NOARG,			\
 		.set = (_set),						\
-		.get = (_get),						\
+		.get_str = (_get),					\
 	}
 
 /* As DEFINE_KERNEL_PARAM_OPS, with an additional .free callback. */
 #define DEFINE_KERNEL_PARAM_OPS_FREE(_name, _set, _get, _free)		\
 	const struct kernel_param_ops _name = {				\
 		.set = (_set),						\
-		.get = (_get),						\
+		.get_str = (_get),					\
 		.free = (_free),					\
 	}
 
diff --git a/kernel/params.c b/kernel/params.c
index e19fff2926bc..6852caea1785 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -467,7 +467,7 @@ static int param_array_get(char *buffer, const struct kernel_param *kp)
 	for (i = off = 0; i < (arr->num ? *arr->num : arr->max); i++) {
 		p.arg = arr->elem + arr->elemsize * i;
 		check_kparam_locked(p.mod);
-		ret = arr->ops->get(elem_buf, &p);
+		ret = arr->ops->get_str(elem_buf, &p);
 		if (ret < 0)
 			goto out;
 		ret = min(ret, (int)(PAGE_SIZE - 1 - off));
@@ -554,11 +554,11 @@ static ssize_t param_attr_show(const struct module_attribute *mattr,
 	int count;
 	const struct param_attribute *attribute = to_param_attr(mattr);
 
-	if (!attribute->param->ops->get)
+	if (!attribute->param->ops->get_str)
 		return -EPERM;
 
 	kernel_param_lock(mk->mod);
-	count = attribute->param->ops->get(buf, attribute->param);
+	count = attribute->param->ops->get_str(buf, attribute->param);
 	kernel_param_unlock(mk->mod);
 	return count;
 }
-- 
2.34.1

