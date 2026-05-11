Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E7426FDBF
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778510288; cv=pass; b=Pn79gm7p2B8isXpE5dGayPOfHFX+NRlUBTJ+pSRWgPLYOsurmqrYPuIwSx8HPTmOSZ4lcVz3X0vNcviydvbfr2LCG/50XaV3J/a5YHk5KnQhwdbuxf48dnWCFKoBMYyry5UuBjO3vnnFIGfU8+egL2/fKIX8Mow7CIcip/3JaE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778510288; c=relaxed/simple;
	bh=yO05LFNEAYBK73U5xEGX5tNa60znCdmv/t4M7wxDpKI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=UcgS2lWTU4D4UHJC565eandO1ZEQUUIfajKmBIlRtMG7dPIt/zaQSBYky7OxuiZKSxHD1yPlHTvH93vx2u2CVTZnf2jiA0WWbBqEd01vMlwwu1m5HW4cbb+cIJKEC9wA3kT+tPy4MAXRksAXODbOWgM4s/gq3X5sSljKPRpG50c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJ3QJXse; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJ3QJXse"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a3e79fe2b8so2231045ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 07:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778510286; cv=none;
        d=google.com; s=arc-20240605;
        b=BC2ANToLLYwjAajNekTSlU/AIOyQEvXDtH2Qo0TALO5ikQ6zfVuNk4+8aeI26UxOjh
         0+YbEKXd6hepeqa/xEBcIszpVxhJjcFwQIj5TjXoUqodUFp/uhF7uUjmCDpoFPRizBxe
         6j+3XSmV2Gyu8FAr43yyylIZKtkTLWXAbKPI9ko2+IW9C4bo8fhz9jMLj95BX9WQ0x2Z
         8w+1Ql+mv5IvWg4t0syeOYubzyL8YaeAjraHh/2ab07LimQCjwk0RksfmwnzF9nmHIw6
         C17oph8FAQ5zKrBvW0qhU/7VXl5jjw8NOy+Mrx7w5JOARqlke4HnsyjpyqDyAp5IqcBD
         kQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=K3c7m1UmlUE6NjPSxT/wzlJuM81KyG6m9FLxvkKRAPI=;
        fh=CeJHpHI1olwmZBQ5NIrIk+jFoZUPm7nA7ymbyRM2jFk=;
        b=BAwvAo9opCpVX1vH6kfGrgGzGDLzWWzWdTW1Yp3mBSEMfgUbTr10Rmvbtpy7kbFK13
         BHaWx7ROFoSrn6gPzPPnEFdBNSX5viwB5gLXkqnZZXemWu8ULUj0WGCVFgUo+pT28VNZ
         U+2RECT4WrmhLZO9nzkr6EocFZWzZWHF6P/moytjuKIyyvgbiBJvLusHficLyO63kebi
         7bS9DVIand81/ZQTyQUyTEnrxbU3b3dD1rnPJq9gXizHoKlkp1OZ85eboplYdJlmicOP
         Scbv1m9qGBP0TV0ldYx3Mha7ajMMHXL5LjGj9fuhLlzhL8kn4PWCafkfIb2spj8n7l1k
         F4Cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778510286; x=1779115086; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K3c7m1UmlUE6NjPSxT/wzlJuM81KyG6m9FLxvkKRAPI=;
        b=YJ3QJXsejfALuHEcqx7JnGJ1VtthfPAm4Reyl85ZQRylvVKgCKjDIZ0ip/Yd3ZAZV+
         Aff6Nkw4FeDBxR91aKrIbtgGq5pRgnszWKMwlFZuttxavnGEcmOmKGuIhi0x6la/WV7E
         EMhCY4vuky/nlvkPwBXJgEm6/EXtkO/xuGdJIeru9oPeqjsQdDFpGUL+LRhjAhQqImDD
         j0Wwld1Dg0nHxT0uE2zWMhTF9I8X9YmXeuFGMJOgD79+tMdc41WuQ4mSqQMSTytgqY2Z
         4jcNHTs4GcUSNmFl+d7t41JaN6xkGgc3vqE9mcOqYL1Ak5CYeJ6HzshtNwmE3X/YsZ0b
         j5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510286; x=1779115086;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3c7m1UmlUE6NjPSxT/wzlJuM81KyG6m9FLxvkKRAPI=;
        b=g1klQvTCRpl2X9Z2SN86iDQAL8ZBKyPM6py1KDrUuF3NvKJELVHVfAT70vSo7QaHoe
         +/Tx2Z4XEmcV0SlDnxl10aTqtuKkmW5BcwBTlgMKsyrn5HHr+f/XZG/CQYwLfVex+mg6
         TJR9/g4pu1LagrfViTlxQ7ch83t+cBEugJ2EwXdJkYiMoE1oDniEKoDKdb3uQ1cQZBHN
         p9yMzrFat1ZbM1MKaE35qY+L8TA9+BsA/D3JfgowpQz2ZDV4inQfWm4VrAOGWyK82EHn
         6IlpI4ywtB5jhCrx4J6FyCGB/mAWFtqr6TP1V8FM0WhyFoYjlEzkzaGUd2yJpRDtHltD
         gTHg==
X-Forwarded-Encrypted: i=1; AFNElJ8jFEKZ9x+3JZRQRdXSoOGlnfmCktXwXzYTWnJ3k6k2nsHG7r+5tupA7GHrFlTJDfjQz5UH0bH/CC2C@vger.kernel.org
X-Gm-Message-State: AOJu0YwXhhGo/njEQE/J7YKXeU9uPTD4hNOsMDLXEgBYkBh0v8p8dR4t
	ECF2n/CubBqd9Un04AhToaaHKAEudsZD/YAwBkXgPrH+Suto1xfQqlKB4q30WSPpm/3tLhfnYE6
	Va+3hA46JfXzGk/h/uKrFElDxTw+IvpOtFZL5UsX/GQh2
X-Gm-Gg: Acq92OEgqNerPZq+NN5S+V6IeCYRmaPf8G5yyQCcoaLAlr+fxpSsSPnkXnjZo1j6q0C
	7wHcYiDSzP0Uv1tmnWr360b9wAH0ETZdumqPxLbYQl21+mCrhiQoznvBqfEmZ/DOhNRAUDneWF9
	lq20TKVpGbp9UnJB/KkktrK6a3precO2rjsE0ADeaEV4iFG1DGk7+Sp0FFuJUvqC0UR8jCKsgnP
	wW/sbfi8RxDMOltI0CDYIJuhu9+rFEYgGwTAxyI74GkBUCtz9oapwenR4XJ93oFFhma8uKolcjE
	S6Wp/VivivtFuj8oIa8=
X-Received: by 2002:a17:903:1a2f:b0:2b9:42a3:6013 with SMTP id
 d9443c01a7336-2ba7afccfa5mr125888295ad.1.1778510286014; Mon, 11 May 2026
 07:38:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Qihang <q.h.hack.winter@gmail.com>
Date: Mon, 11 May 2026 22:37:55 +0800
X-Gm-Features: AVHnY4Lle-zaUbLFe2T4XqyBrClUDCeJjrmj-VmLwFCZkdD-lGRi2ctCMvnAI8I
Message-ID: <CAH78GvtdG_4ZWnddW1HcS4W1jT4cwpEHEAzuHvcxS8NUBnq43w@mail.gmail.com>
Subject: [REPORT] be2iscsi: unchecked vendor offset may cause out-of-bounds
 write in BSG management path
To: ketan.mukadam@broadcom.com
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to report a potential security issue in the be2iscsi driver.

Summary
-------
The be2iscsi BSG vendor management path computes a write offset into a DMA
coherent command buffer from user-controlled vendor command fields, but does
not validate the computed offset against the allocated buffer size.

From source inspection, this appears to allow a local privileged user with
access to the be2iscsi BSG device to trigger an out-of-bounds write from the
BSG request payload into memory beyond the allocated DMA coherent buffer.

Affected versions
-----------------
Confirmed present by source inspection in a local Linux source tree identifying
itself as Linux 7.0.0-rc5.

I have not yet traced the exact introducing commit, so I am not claiming a
precise affected range at this point.

Affected code
-------------
- drivers/scsi/be2iscsi/be_main.c: beiscsi_bsg_request()
- drivers/scsi/be2iscsi/be_mgmt.c: mgmt_vendor_specific_fw_cmd()
- drivers/scsi/scsi_transport_iscsi.c: iscsi_bsg_host_dispatch()
- block/bsg-lib.c: bsg_transport_sg_io_fn()

Description
-----------
For ISCSI_BSG_HST_VENDOR requests, beiscsi_bsg_request() allocates a DMA
coherent command buffer using the BSG request payload length:

    nonemb_cmd.va = dma_alloc_coherent(&phba->ctrl.pdev->dev,
                                       job->request_payload.payload_len,
                                       &nonemb_cmd.dma, GFP_KERNEL);

mgmt_vendor_specific_fw_cmd() then stores this size in nonemb_cmd->size and
uses vendor command fields to prepare the firmware command:

    nonemb_cmd->size = job->request_payload.payload_len;
    memset(nonemb_cmd->va, 0, nonemb_cmd->size);

    region = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
    sector_size = bsg_req->rqst_data.h_vendor.vendor_cmd[2];
    sector = bsg_req->rqst_data.h_vendor.vendor_cmd[3];
    offset = bsg_req->rqst_data.h_vendor.vendor_cmd[4];

For BEISCSI_WRITE_FLASH, the final copy destination is computed as:

    offset = sector * sector_size + offset;

    sg_copy_to_buffer(job->request_payload.sg_list,
                      job->request_payload.sg_cnt,
                      nonemb_cmd->va + offset, job->request_len);

The computed offset is not checked against nonemb_cmd->size before being used
as a pointer offset into nonemb_cmd->va.

The iSCSI BSG dispatcher validates the message code and vendor ID, and checks
that the request is large enough to contain the base vendor header, but it does
not validate these be2iscsi-specific vendor_cmd[] fields or the computed flash
offset.

Reproducer
----------
I have not run a runtime reproducer yet. The following is the source-level
trigger path and input shape needed to reach the issue:

1. Use SG_IO on the be2iscsi host BSG device, for example /dev/bsg/iscsi_hostN.
2. Set protocol to BSG_PROTOCOL_SCSI.
3. Set subprotocol to BSG_SUB_PROTOCOL_SCSI_TRANSPORT.
4. Use ISCSI_BSG_HST_VENDOR as the iSCSI BSG message code.
5. Use a vendor_id matching the be2iscsi host template vendor ID.
6. Set vendor_cmd[0] to BEISCSI_WRITE_FLASH.
7. Provide a small dout_xfer_len so job->request_payload.payload_len is small.
8. Set vendor_cmd[2], vendor_cmd[3], and vendor_cmd[4] so that
   sector * sector_size + offset is greater than or equal to the allocated
   payload length.

For example, with a 256-byte request payload, choosing sector_size = 256,
sector = 200, and offset = 0 gives a computed offset of 51200, which is outside
the allocated DMA command buffer.

Conditions
----------
- CONFIG_BE2ISCSI enabled.
- A supported be2iscsi HBA present and online.
- The be2iscsi iSCSI host BSG device available.
- The caller must be able to open the BSG device.
- The BSG transport path requires CAP_SYS_RAWIO.
- No race or timing condition is required.

Impact
------
From source inspection, this appears to be a constrained out-of-bounds write
past a DMA coherent allocation. The copied bytes come from the BSG request
payload.

I do not currently claim reliable privilege escalation or arbitrary kernel
read/write. The practical impact depends on adjacent DMA/coherent allocations
and allocator state, but memory corruption or a crash appears plausible.

Suggested fix
-------------
Validate the computed offset before using it as a pointer into nonemb_cmd->va,
and clamp the copy length to the remaining buffer size.

The code should also reject command buffers that are too small for the fixed
be_bsg_vendor_cmd header before writing req->hdr and related fields.

A minimal fix direction would be:

    offset = sector * sector_size + offset;
    if (offset >= nonemb_cmd->size) {
            mutex_unlock(&ctrl->mbox_lock);
            return -EINVAL;
    }

    len = min_t(size_t, job->request_len, nonemb_cmd->size - offset);

    sg_copy_to_buffer(job->request_payload.sg_list,
                      job->request_payload.sg_cnt,
                      nonemb_cmd->va + offset, len);

It may also be preferable to perform the arithmetic in a wider type before the
bounds check.

Mitigations
-----------
Restricting access to the affected BSG device and CAP_SYS_RAWIO limits exposure.
Systems without be2iscsi hardware, without CONFIG_BE2ISCSI, or without the
be2iscsi BSG device exposed should not be reachable through this path.

Current status
--------------
This report is based on source inspection. I have not yet run a KASAN or
hardware-backed reproducer, and I have not traced the exact introducing commit.

Best regards,
Qihang
