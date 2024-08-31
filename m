Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30854C99;
	Sat, 31 Aug 2024 16:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725120961; cv=none; b=ttoFTkmvF7cG2lponY3gcirozejI+f181XL5rzJhVOToqok1XhLzdUmw0FThExzRgIVLNsO8U+J+LKYfoHG0z9VS5VHtCaYHerveoOu0SH+9igs/ycsyw4tjOQtGGHOdf58KYHu/cOvHFeHApYze2fBrg2vRbKQubrDvi166p8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725120961; c=relaxed/simple;
	bh=6+p4PQVrEHQoVX7EPGb2eKjPh9+AltZKy/5TaUNHraA=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=tb+tVBAz3wr4Q+y7uUPoO7snZzhtZL+o8jCd4Xjl3hzAAYT57V+kwHORKtIKniZOaabOOdVJa/3tqSoqVDoAFY4T2rgb/Nb0R2xbF9OTA37tOCeLe03itxFOAVL3m0XAxEeJxB6nlTjyidHZtogm3lyI36hHCBf38gm4aEDSLJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=e2PO6Gw/; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=e2PO6Gw/; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="e2PO6Gw/";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="e2PO6Gw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1725120956;
	bh=6+p4PQVrEHQoVX7EPGb2eKjPh9+AltZKy/5TaUNHraA=;
	h=Message-ID:Subject:From:To:Date:From;
	b=e2PO6Gw/x09hfyEoXxCAygRbhssWrZQsRoc/ebflnaEOkDXPjyHyU554GwKCDRtPB
	 7MSynpiPs3lwYGZkOyNmi6LL+4PEhdbE+Hg47QieSool+qfI3aLwY1XTj2Ju5Xaj06
	 sDZLtjA1ftBvDTUdLb0L7cYjhBlq3lUv86JomFqs=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id ED1611285D77;
	Sat, 31 Aug 2024 12:15:56 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id qk7KhdbDWRp2; Sat, 31 Aug 2024 12:15:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1725120956;
	bh=6+p4PQVrEHQoVX7EPGb2eKjPh9+AltZKy/5TaUNHraA=;
	h=Message-ID:Subject:From:To:Date:From;
	b=e2PO6Gw/x09hfyEoXxCAygRbhssWrZQsRoc/ebflnaEOkDXPjyHyU554GwKCDRtPB
	 7MSynpiPs3lwYGZkOyNmi6LL+4PEhdbE+Hg47QieSool+qfI3aLwY1XTj2Ju5Xaj06
	 sDZLtjA1ftBvDTUdLb0L7cYjhBlq3lUv86JomFqs=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::db7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4A1251285C8F;
	Sat, 31 Aug 2024 12:15:56 -0400 (EDT)
Message-ID: <73531af7c46f3f39acc1246e84cc8fe99d932a02.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.11-rc5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 31 Aug 2024 12:15:54 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Minor fixes only.  The sd.c one ignores a sync cache request if format
is in progress which can happen if formatting a drive across
suspend/resume.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ben Hutchings (1):
      scsi: aacraid: Fix double-free on probe failure

Sherry Yang (1):
      scsi: lpfc: Fix overflow build issue

Yihang Li (1):
      scsi: sd: Ignore command SYNCHRONIZE CACHE error if format in progress

And the diffstat:

 drivers/scsi/aacraid/comminit.c |  2 ++
 drivers/scsi/lpfc/lpfc_bsg.c    |  2 +-
 drivers/scsi/sd.c               | 12 +++++++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index bd99c5492b7d..0f64b0244303 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -642,6 +642,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 
 	if (aac_comm_init(dev)<0){
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 	/*
@@ -649,6 +650,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	 */
 	if (aac_fib_setup(dev) < 0) {
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 		
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 4156419c52c7..4756a3f82531 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5410,7 +5410,7 @@ lpfc_get_cgnbuf_info(struct bsg_job *job)
 	struct get_cgnbuf_info_req *cgnbuf_req;
 	struct lpfc_cgn_info *cp;
 	uint8_t *cgn_buff;
-	int size, cinfosz;
+	size_t size, cinfosz;
 	int  rc = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dad3991397cf..9db86943d04c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1823,13 +1823,15 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+
 			/*
-			 * This drive doesn't support sync and there's not much
-			 * we can do because this is called during shutdown
-			 * or suspend so just return success so those operations
-			 * can proceed.
+			 * If a format is in progress or if the drive does not
+			 * support sync, there is not much we can do because
+			 * this is called during shutdown or suspend so just
+			 * return success so those operations can proceed.
 			 */
-			if (sshdr.sense_key == ILLEGAL_REQUEST)
+			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
+			    sshdr.sense_key == ILLEGAL_REQUEST)
 				return 0;
 		}
 

