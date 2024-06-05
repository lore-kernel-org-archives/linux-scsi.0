Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5525C192B62;
	Wed,  5 Jun 2024 12:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717591083; cv=none; b=DXzWq+gZq6hsriCN3jO0Gp/go4RNh+V/Cc+NnnPhNwdnqPg6m2L9cLcdaMMBY1/NsqiFvcabYFeE936rG7Bg5FMTkhRCvQz+R8agzerQesdYP2INBf/fIXCfXXPFWo4214JRn0cefezOPJYncyUblzpaygDuT4lAAxy2OOD3C2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717591083; c=relaxed/simple;
	bh=fOdt3Fytv6HQI3+mzylm/2AcpvWV0Ln/zAUcHTb4EVQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oQ7P0W1u7FTQEOY+3nXA3+Kl8rqRpXcwg4VbvJJ+lum2jkFo3bCb59KedAhItZQF+eSUjL5Qy3qApRB20wQPiIWad0sHk34kk/tPklU5tZER5KfNGKYqBgg73aXMgvKG9ectVbO+MqYx69ICv1OtGWrRv6zxl0o3ysKwjJuq1hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=QVtEtJEa; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="QVtEtJEa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717591078;
	bh=tXmul2YvdKxY1b4BfQmztqVfezCv2YwMW6gaWIjxWyc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QVtEtJEaETyY3TIJz+BqxEhlpdsOyG+VD8ca4zr1Re2bJfG7/+4yVtUM+6dcSadla
	 5Qile4iLRhEqKbrsOhvW7fDiPMV9wt7m6K1qWQOEm7y8YiAqk0RVI3THBKvcaEZk6B
	 LsOyox3Y9MQXLVnsNFw59VKkvUJ+dxJkKGHCfOt7iw/s3CeoYOAXCNC9q9vc0MySDw
	 kvzBhAXul9CmIBSiGC52nN/nCaNaqPh27jwkulmNwxccTxSuwJv3lptjJdlv9uZiKW
	 PJz2OCXxqIW6D/4ezjqnN+5+sMHLJRgU4jV1w80ofUcOp5JwLLa+ZKUfi5O9q2EodR
	 +de6MFfeZauYA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VvRnb3wLZz4wc3;
	Wed,  5 Jun 2024 22:37:54 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Christoph Hellwig <hch@lst.de>
Cc: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>, John Garry <john.g.garry@oracle.com>, Jens
 Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Damien Le Moal <dlemoal@kernel.org>, Niklas
 Cassel <cassel@kernel.org>, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org, Guenter Roeck
 <linux@roeck-us.net>, Christoph Hellwig <hch@lst.de>, Linux kernel
 regressions list <regressions@lists.linux.dev>, doru.iorgulescu1@gmail.com
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
In-Reply-To: <87sexy2yny.fsf@mail.lhotse>
References: <20240520151536.GA32532@lst.de>
 <fc6a2243-6982-45e9-a640-9d98c29a8f53@leemhuis.info>
 <8734pz4gdh.fsf@mail.lhotse> <87wmnb2x2y.fsf@mail.lhotse>
 <20240531060827.GA17723@lst.de> <87sexy2yny.fsf@mail.lhotse>
Date: Wed, 05 Jun 2024 22:37:53 +1000
Message-ID: <87wmn3pntq.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Michael Ellerman <mpe@ellerman.id.au> writes:
> Christoph Hellwig <hch@lst.de> writes:
>> On Fri, May 31, 2024 at 12:28:21AM +1000, Michael Ellerman wrote:
>>> No that's wrong. The actual hardware page size is 4K, but
>>> CONFIG_PAGE_SIZE and PAGE_SHIFT etc. is 64K.
>>> 
>>> So at least for this user the driver used to work with 64K pages, and
>>> now doesn't.
>>
>> Which suggested that the communicated max_hw_sectors is wrong, and
>> previously we were saved by the block layer increasing it to
>> PAGE_SIZE after a warning.  Should we just increment it to 64k?
>
> It looks like that user actually only has the CDROM hanging off
> pata_macio, so it's possible it has been broken previously and they
> didn't notice. I'll see if they can confirm the CDROM has been working
> up until now.
>
> I can test the CDROM on my G5 next week.

I can confirm that the driver does work with 64K pages prior to the
recent changes. I'm able to boot and read CDs with no errors.

However AFAICS that's because the driver splits large requests in
pata_macio_qc_prep():

static enum ata_completion_errors pata_macio_qc_prep(struct ata_queued_cmd *qc)
{
       ...
       for_each_sg(qc->sg, sg, qc->n_elem, si) {
              u32 addr, sg_len, len;
              ...
              addr = (u32) sg_dma_address(sg);
              sg_len = sg_dma_len(sg);

              while (sg_len) {
                     ...
                     len = (sg_len < MAX_DBDMA_SEG) ? sg_len : MAX_DBDMA_SEG;
                     table->command = cpu_to_le16(write ? OUTPUT_MORE: INPUT_MORE);
                     table->req_count = cpu_to_le16(len);
                     ...
                     addr += len;
                     sg_len -= len;
                     ++table;
              }
  }

 
If I increase MAX_DBMA_SEG from 0xff00 to 64K I see IO errors at boot:

  [   24.989755] sr 4:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=6s
  [   25.007310] sr 4:0:0:0: [sr0] tag#0 Sense Key : Medium Error [current]
  [   25.020502] sr 4:0:0:0: [sr0] tag#0 ASC=0x10 <<vendor>>ASCQ=0x90
  [   25.032655] sr 4:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
  [   25.047232] I/O error, dev sr0, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0


On the other hand increasing max_segment_size to 64K while leaving MAX_DBDMA_SEG
at 0xff00 seems to work fine. And that's effectively what's been happening on
existing kernels until now.

The only question is whether that violates some assumption elsewhere in the
SCSI layer?

Anyway patch below that works for me on v6.10-rc2.

cheers


diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 817838e2f70e..3cb455a32d92 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -915,10 +915,13 @@ static const struct scsi_host_template pata_macio_sht = {
 	.sg_tablesize		= MAX_DCMDS,
 	/* We may not need that strict one */
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	/* Not sure what the real max is but we know it's less than 64K, let's
-	 * use 64K minus 256
+	/*
+	 * The SCSI core requires the segment size to cover at least a page, so
+	 * for 64K page size kernels this must be at least 64K. However the
+	 * hardware can't handle 64K, so pata_macio_qc_prep() will split large
+	 * requests.
 	 */
-	.max_segment_size	= MAX_DBDMA_SEG,
+	.max_segment_size	= SZ_64K,
 	.device_configure	= pata_macio_device_configure,
 	.sdev_groups		= ata_common_sdev_groups,
 	.can_queue		= ATA_DEF_QUEUE,
