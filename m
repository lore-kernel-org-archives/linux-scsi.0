From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and auditing
Date: Mon, 16 Jul 2007 12:22:20 +0300
Message-ID: <469B38CC.50501@panasas.com>
References: <4695F76F.5000305@panasas.com> <20070712135750.2a4a4a54.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040600090503090206010400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7762 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754700AbXGPJWq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 05:22:46 -0400
In-Reply-To: <20070712135750.2a4a4a54.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040600090503090206010400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Randy Dunlap wrote:
> On Thu, 12 Jul 2007 12:42:07 +0300 Boaz Harrosh wrote:
> 
>> In motivation for the !use_sg cleanup and use of accessors
>> I needed to do some restructuring of the aha152x.c driver.
>>
>> I have tried to be as careful as I could, but with out
>> the hardware for testing, it is hard. Christoph and James
>> You are signed on a couple of the last patches to this driver
>> So you are probably somewhat familiar with the code. Could
>> you please review the patchset to see that nothing is broken.
>>
>> If any one has an Hardware that uses aha152x.c, please help me
>> with testing this patchset. If it does not work could you please
>> do a short bisect of which patch breaks out of the 4.
> 
> I could test it on PCMCIA.  However, the patches are against
> the scsi-misc git tree, correct?  So I would have to clone
> that git tree first...  that's not good.
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

If you could do some testing it is grate. The first 3 patches do not
need scsi-misc specifically. Any post 2.6.20 tree will do. The last patch
could be done together with attached patch on any 2.6.22 tree.
(Apply attached patch anywhere before the last patch (4/4) of the patchset)
Though I do recommend scsi-misc tree.

Testing:
Doing a regular Mount, FS testing is good for checking the last (4/4) 
patch, and it would be good news if it works, but ...
I'm afraid that it will not exercise the code change all that much, 
since my patches touch the Error-handling and Reset code paths.

Maybe someone can help:
How can we cause an ->eh_device_reset_handler() call from scsi-ml?

As for the patch 3/4 we need a SAM_STAT_CHECK_CONDITION return 
from a device. If you have a device with known bad sectors than
a dd over the bad block should exercise that. Again anyone can
think of an easy way to exercise a Status==SAM_STAT_CHECK_CONDITION?

Thanks for any testing you can do. Even if it's only the first 3
it could be nice

Boaz


--------------040600090503090206010400
Content-Type: text/plain;
 name="scsi-accesors-backport-out-of-tree.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-accesors-backport-out-of-tree.patch"

[SCSI] scsi_cmnd: add data buffer accessors
    
    This adds a set of accessors for the scsi data buffer. This is in
    preparation for chaining sg lists and bidirectional requests 
    
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2e0c10..53e1705 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -135,4 +135,21 @@ extern void scsi_kunmap_atomic_sg(void *virt);
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+#define scsi_sg_count(cmd) ((cmd)->use_sg)
+#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
+#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
+
+static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
+{
+	cmd->resid = resid;
+}
+
+static inline int scsi_get_resid(struct scsi_cmnd *cmd)
+{
+	return cmd->resid;
+}
+
+#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
+	for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
+
 #endif /* _SCSI_SCSI_CMND_H */

--------------040600090503090206010400--
