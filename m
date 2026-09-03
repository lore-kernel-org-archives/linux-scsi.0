Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9724A0F07
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 12:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437332; cv=none; b=bJxIEhdr4A2EO9eYLyIWq9Z50dxF/7xe4Sspi8re13j7GA+A9VIwRI6Ok+HhP/EUUgVLODJ0P8C1XjP/BtiXJlMvWsFSWeD4x0gXLLQrYCnwTSAiy1C1pwFJPPRDTdA/9tkrMkFOPlhzlnh9Rgo/1Wiuyaxx0SeW1bs2NyN+Wp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437332; c=relaxed/simple;
	bh=DS92zY7UggopypjAfNvS0nI3xwM4VczeNIlJ4DH107g=;
	h=Subject:Date:Message-ID:In-Reply-To:References:From:To:Cc:
	 Content-Type:MIME-Version; b=SD1giOmbsdcTTGHNmVFCQsKkIvrO80rAPEabVc8Z8VrRf6vLSmC40XdEu0UA7bSmQNzR2Ydbu5e0cVfXuyVMvHylPOou8148Q8z0pGsjPSZ8qAGa+418zMjVufK4dAjSX8BdAZMZT2jRKP+2mttBwjTg8nCLDkdm3LRcLH1L9IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9Fzd3DH; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9Fzd3DH"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84830c774a0so2507445b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2026 05:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788437330; x=1789042130; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0cSmqLTzwH1GLgzGsnxGCY8DR/cpVAEWeeTTJ8+EvwM=;
        b=I9Fzd3DHr94RnEW96jbjjh0lOCRs2n0uCr8IiwQDB6Z++YbtCJrZESgK9f+VkpxCrG
         MrMSCeiu90unl4FhmHNdSebLSOQNBv+RqdXAg3eHW93m8U59JIx6+WG3xyfNYiD5cfC7
         C05aGUTkuaMvl6OuquhKwSRIwvu94nmhA6+rVgNuTpILGFSnhiu9PRJvVNyKOCsU9NK2
         E3GMpc3+TDCtpiY+rGfin8sJ19UY1VsD9//1SR3caiN73oHK68BdPwRM9tnspdkXnbzW
         UuCHxylht5SvWPTul4v6b+sxXfpdJu5P6IuaaL8dFTVu+9rcsxi9ZIe0ji3HEjcjl2+B
         43JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788437330; x=1789042130;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0cSmqLTzwH1GLgzGsnxGCY8DR/cpVAEWeeTTJ8+EvwM=;
        b=qRpA0+O+arsM1VTcPksxP6fwGUCmAVagvW/+tpA8TgqJvCsB0XQENKyPQ8TA2EwJT1
         Io5bf4N6EtHfhxb0pPRFuXoMsdGLEyCKAUztugoBQeYChHHJfeimNl19WE1lpKaFZCQH
         kIvZVQmHMmwCARFUpuDtf9GjFU5W71dH+zUzvXxURyD2CPM1wbQNI4Zc9mQcEVom0OFy
         x4O5zwHGZG8ZZLKdGT6d0DntuWuxwk/quLLAsxDI5XIZVRecJLEVOrp93wcB4s7rnoM2
         YqMGZ6m9T+PXMZPuFUlYreeGKPf48C3wdRhpOUZsd/E40d058MzP4V6/KaRh2IGYEpJu
         wTog==
X-Forwarded-Encrypted: i=1; AKwUvBzloi94bG3cEHfAgPKiflTKRlG+s4fl3wJLkpBdr9nqPebml14KTe8U8TGrG3gxuFXVFpZB/fnOIHrs@vger.kernel.org
X-Gm-Message-State: AFuF++moUUloq0KK0R4nL5QUnf0iAGSXVA62eJW8LhvTwnhZdGHKLGdI
	YDwa5HhJRuCI9aVce5eS94wMhStEUJiGs3pk1T5x0oG4cGe0DM1l+a+f
X-Gm-Gg: AYBFou3KnO68FMtgDYcmuDclOe867OCeabav1Ca2XxVFVo4cZ/ELsfZwACBDYor7Wxz
	2APStnXRJ+ScMZv/I3gixUhieewoP0FDnwrHlEAa8Zdph6btqeKj4Wau/+T3nw6hr3WhVT+qoHu
	B/1DIKhznlOf+NCxMxAVJ3gA0IzUNTwro5nNPF3rmeGa8Dk92Wd5MnxG6lnmMd+t535UoiuDIyB
	GLTDSch5KmlsCKPpcVgc1hrmmbCiVZq7eetu0ScsvfTHfXkmqgjlkMYVMoq1NVgKFptTx2thpOt
	TBcvGec0PO03LPqMBwH9FxDNXfwtxYqQ/ekyP1FMeKLSrgW+ezUNS/guE9wNQvT92plc9ylFqcO
	rJvvJUEZkTuGrgWrN4oLtj+FjzgI56/sV1gNxyND8YK7RORER4ng8lJernSayxRbixUrxFwnKjx
	hJ9OV57qQv0MR2pdPz1Xq6fUlrWLMETWSMVuLNJasXg+H1AQ0w1T5nDOnb+sbn9vtQFA==
X-Received: by 2002:a05:6a21:3944:b0:3d3:af85:eb98 with SMTP id adf61e73a8af0-3d9af3efa11mr19982146637.26.1788437329916;
        Thu, 03 Sep 2026 05:08:49 -0700 (PDT)
Received: from [192.168.71.146] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc43d424edesm869853a12.22.2026.09.03.05.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:08:49 -0700 (PDT)
Subject: [PATCH RFC v2 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Thu, 03 Sep 2026 20:00:00 +0800
Message-ID: <202609032000.RFCv2-0.lhw@gmail.com>
In-Reply-To: <202609012200.RFC0.lhw@gmail.com>
References:
 <202609012200.RFC0.lhw@gmail.com> <202609012200.RFC1.lhw@gmail.com>
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

v2 of the LED driver for ASUS Aura RGB on ROG external NVMe
enclosures. It addresses all seven points from the review v1 received
(from the sashiko AI bot; there has been no human review on v1 yet).

Changes since v1:

- Teardown order: .detach() and the attach error path now unregister
  the LED class devices first, then cancel_work_sync(), then free.
  The v1 order (cancel first) left a window where a brightness write
  could requeue the work after cancel_work_sync() returned, so the
  work would run on freed memory.

- Request allocation: ene_write() now builds the request with
  scsi_alloc_request() instead of a raw blk_mq_alloc_request().
  scsi_initialize_rq() zeroes cmnd, initializes the rcu head, sense
  length and retries; skipping that left those fields uninitialized.
  An explicit timeout and RQF_QUIET are set, matching what
  scsi_execute_cmd() does.

- Serialization of the ENE sequence: brightness_set() now only caches
  the colour and marks the LED in a per-zone dirty bitmap; a single
  work item per zone runs one sequence (MODE, colour slots, APPLY,
  SAVE) for all pending LEDs. The v1 per-LED works could interleave
  their sequences between concurrent updates. As a side effect,
  multi-LED updates now batch into one APPLY/SAVE.

- Subject line: switched to the leds subsystem prefix and
  capitalization.

- The attach success log message is gone.

Two of the reported items did not hold up against the kernel this
driver is built against (7.2.2):

- kzalloc_obj() is not an undefined macro; it lives in
  include/linux/slab.h (since v6.17).

- blk_rq_map_kern() with four arguments is the current signature
  (rq, buf, len, gfp); drivers/scsi/scsi_lib.c calls it that way from
  scsi_execute_cmd().

Everything else is unchanged from v1: the hardware (ROG external NVMe
enclosures, e.g. ROG STRIX Arion, USB 0b05:1932, no HID, ENE LED
controller behind vendor SCSI commands on the disk's LUN, 4
independently addressable LEDs), the scsi_device_handler that does
not claim the sdev, the multicolor LED interface, and the
protocol handling. v2 was re-verified on hardware.

Known caveats, unchanged:

- the handler attaches manually until a notifier lands
  (echo asus_aura > /sys/block/sdX/device/dh_state);

- SAVE (0xaa) is issued with every colour update, which writes the
  enclosure flash each time; wear has not been characterized yet;

- the LEDs are registered with a NULL parent device, because
  parenting them to the sdev creates a reference cycle that blocks
  the sdev's final release on unplug.

Comments on the interface shape and on folding this into the shared
Aura work with Denis remain very welcome.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>

Liang Haowen (1):
  leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

 drivers/leds/leds-asus-aura-scsi.c | 332 +++++++++++++++++++++++++++++
 1 file changed, 332 insertions(+)

--
2.55.0

