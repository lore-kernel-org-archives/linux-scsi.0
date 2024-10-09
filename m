Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0942C190
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 01:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728438736; cv=none; b=ejVMpjRFGP9nlWBFxEGDO+CjLsltdMrGQKUsD0eowqJE19+VfO9spJkKTTPSlagrrql5Pp3UsV+Y65zk9OBOas7ufJ/FMKuXsM7alOhSoXUpyiWkEzq+Av+1hfDvcHR+VhLBVQacM8/8DbvNKWW2UdT7VRi4LuMAC3otUKZ15/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728438736; c=relaxed/simple;
	bh=2EsLEfdaspG2L4LOkTnzKNf9wunBqhTpXkXy/jPNHxc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=pcQjggbT0YDXxy0Lb5LIkRVeFaPDTAcCBv1xy/zd6d04aWuDGJP4xUS6gtzTKQ8hW8rpAimgcPCrQ5ObB8ecvqMK9XWuQAXov0wd84pshXWR6DkDrIt5Swzt1lejMPY4sVm//aO5UbJ+UZBqVY350qYYNCVBPbCPWoq1drMCFuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EEOtS3ie; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EEOtS3ie"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728438733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=0ywaP810UH8BBu4z7/g14sS1juTd1jb1As+ARihjTrA=;
	b=EEOtS3ieNZSkihouolbt8SoXs+gMhtEtbONvqy3CyyjJkrxEdLsdMjV+AxJcxKzy7H/bxK
	D2pWQHBYRHMOw9isK0WW1PoCo468J0tPQAfp9QKHASxL3mnQvnfA2S0XORL+DsX8Rzoy8K
	BI1jQ5NUdlax4dej98OS9Yxh/Kt7WKg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-Jn8OrqxIPlKzDx1r_LdE8Q-1; Tue, 08 Oct 2024 21:52:12 -0400
X-MC-Unique: Jn8OrqxIPlKzDx1r_LdE8Q-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2e21ed7eb75so3464161a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Oct 2024 18:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728438729; x=1729043529;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ywaP810UH8BBu4z7/g14sS1juTd1jb1As+ARihjTrA=;
        b=Ff3zIhxOZ7djKo5wsaZMqc28JVqMU/PUG5vFuyCPmAToxuK+UUVxW5RE/ATwuFJs3I
         7at+Kdem9E5NwX7cr+KQKAfrt+Ic3parXcsvIEg1jYfzl9lBT8lBH6OwN1NbvSG26UFL
         7tJt+9pw2hhSik7At4b8o8vKlNVrMngeMknKFM8SjF9V8VC0ANbv/72/oojvI7P996Rr
         K7dShVe+Edtj1N9RWYu/eULjeFYkX970ve6ssH4wTQs4ujL2QbMWSoR/mE9BHsOTIH6m
         ZDShD5SWc1ZRuTW4P84aGehIyONtGwCV3JQSUxjZ3gBKrTPSWKq7V3zyvubbPLzvNHih
         rOXg==
X-Gm-Message-State: AOJu0YzCju9pzX+diBpCWAchHrxHfnz7KwhhQP8mJAfgAa0Rqj33Ukxa
	0t7viC3aB3Sjn9xfpDXlmgLUejmId32EmR9eVxTrGoHIFjd3XdjB248ULVoXD7GCdt//1Cz9s6d
	rx5R6hfKxaBbK9tsJcdrDyjF4HrVLSA2tvdqlXfjROzt2TtUH0/IN2v/JXBl10cU3ROe0hdsdeA
	11BoawPWuy+rc1eRXUNOswnzR7kI7X46fcBCYwWLUW18mOdO0=
X-Received: by 2002:a17:90b:440b:b0:2dd:5e86:8c2f with SMTP id 98e67ed59e1d1-2e2a246d0dbmr1087431a91.21.1728438728659;
        Tue, 08 Oct 2024 18:52:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGT6TAv4b0S2alIdwsa+skr1NaDAOJhfKueZUmXFr+BGVBGlXwYpI2Di/HfBmd4sUITJ7nw6XXNdQPLrSsKY/s=
X-Received: by 2002:a17:90b:440b:b0:2dd:5e86:8c2f with SMTP id
 98e67ed59e1d1-2e2a246d0dbmr1087419a91.21.1728438728377; Tue, 08 Oct 2024
 18:52:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Wed, 9 Oct 2024 09:51:56 +0800
Message-ID: <CAHj4cs_EPxJe=7Rb=sjCxhj53qfdBJ_5VKoXPNrAOioYMcRFzg@mail.gmail.com>
Subject: [bug report][mpt3sas] kmemleak observed after system boots up
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Hi

I found this kmemleak after the system boots up on 6.12-rc2, please
help check it and let me know if you need any info/test for it,
thanks.


# lspci | grep -i mpt
0006:01:00.0 Serial Attached SCSI controller: Broadcom / LSI
Fusion-MPT 12GSAS/PCIe Secure SAS38xx

# cat  /sys/kernel/debug/kmemleak
unreferenced object 0xffff0000e2db5600 (size 192):
  comm "hardirq", pid 0, jiffies 4294939685
  hex dump (first 32 bytes):
    00 56 db e2 00 00 ff ff 00 56 db e2 00 00 ff ff  .V.......V......
    00 00 00 48 00 00 00 00 18 56 db e2 00 00 ff ff  ...H.....V......
  backtrace (crc 242ab20e):
    [<ffffd02433c58b40>] kmemleak_alloc+0xb8/0xe0
    [<ffffd02431e0acf4>] __kmalloc_noprof+0x2c4/0x3e0
    [<ffffd023f574ed40>] alloc_fw_event_work+0x28/0x90 [mpt3sas]
    [<ffffd023f577467c>] mpt3sas_scsih_event_callback+0x114/0xd80 [mpt3sas]
    [<ffffd023f573046c>] _base_async_event.isra.0+0x104/0x6a8 [mpt3sas]
    [<ffffd023f5731f10>] _base_process_reply_queue+0x480/0x13a0 [mpt3sas]
    [<ffffd023f573347c>] _base_interrupt+0xa4/0xf8 [mpt3sas]
    [<ffffd0243176dea8>] __handle_irq_event_percpu+0x140/0x390
    [<ffffd0243176e280>] handle_irq_event+0xb8/0x200
    [<ffffd0243177cb04>] handle_fasteoi_irq+0x21c/0x9b0
    [<ffffd0243176b610>] generic_handle_domain_irq+0x80/0xb8
    [<ffffd024325db6fc>] __gic_handle_irq_from_irqson.isra.0+0x3cc/0x6d8
    [<ffffd02431430214>] gic_handle_irq+0x4c/0xb8

(gdb) l *(mpt3sas_scsih_event_callback+0x114)
0x5467c is in mpt3sas_scsih_event_callback
(drivers/scsi/mpt3sas/mpt3sas_scsih.c:10992).
10987 default: /* ignore the rest */
10988 return 1;
10989 }
10990
10991 sz = le16_to_cpu(mpi_reply->EventDataLength) * 4;
10992 fw_event = alloc_fw_event_work(sz);
10993 if (!fw_event) {
10994 ioc_err(ioc, "failure at %s:%d/%s()!\n",
10995 __FILE__, __LINE__, __func__);
10996 return 1;

-- 
Best Regards,
  Yi Zhang

