From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch RFC] Add FC transport host statistics
Date: Thu, 14 Oct 2004 19:42:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014184246.GA12337@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C0866CF@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:5894 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266905AbUJNSmr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 14:42:47 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C0866CF@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu

+	if (offset > sizeof(struct fc_host_statistics) ||
+	    offset % sizeof(uint64_t) != 0)

please always use u64 in core code - uint64_t is acceptable for drivers
but we want to keep the core code in a coherent style.

+	if (i->f->get_fc_host_stats) {
+		stats = (i->f->get_fc_host_stats)(shost);

superflous parenthes around the method invocation.

+		if (stats)
+			ret = snprintf(buf, 20, "0x%llx\n",
+			      *(uint64_t *)(((u8 *) stats) + offset));

shouldn't we instead pass an offset in terms of sizeof(u64) so we can do
simple pointer arithmetics like

			ret = snprintf(buf, 20, "0x%llx\n", stats + idx);

here?

