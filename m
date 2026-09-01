Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8023CEB99
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273572; cv=none; b=nKsI4Z3N9W646b/yaB3/OhyV56uOI81sSV9hso/Y5z5GjZxl2V1+3EXq3vLakn3n6hj6PQuEjjHJPyfwvUA5wMTvlmYnI3QECyioHTGaFzjqt4z1uDW+OWRe/+5ty2NJhZ+1Th5PgoDywajIzvLp+u92394an85LKeCq9vcaQA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273572; c=relaxed/simple;
	bh=PpjuOycMnvKcsr6i4JwrDRk3fLhhuojReIjxUw1zJuY=;
	h=Subject:Date:Message-ID:From:To:Cc:Content-Type:MIME-Version; b=hmpzxpYR3sUM+QttyvieQoG1t2BLbqjF8LHPB0BgNc9fiFbu7nQT/EdtrsK4pzHC7G+EjTd6paAyHcyxNdZ5odBxzS907Z50d4YsUFAdGZ/180e5Qa3tVmrgpIH2+FOlE+7CR3xMkKl9uF0l2itJJOpco+zQlCv8cOzNdx5bE+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E9o/nJgs; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9o/nJgs"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso1638181a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 07:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788273571; x=1788878371; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :message-id:date:subject:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sq8WERtPgYhkPbAu1lD9X5RHbMKk+hk5c82yqST5k6M=;
        b=E9o/nJgsD3nmRXeyyKjwqPAgLLTLQvaEZKQSEcBx4xjzI/Mwd7nEWobbpTs8j45r9J
         6GwHWhhDUDUHihgxEqSj6nMJ+bJYg2LD+tQ0hbTctzn0PxsppQ/pwuWH6g9GZwzGgibN
         KFMxR5u4egf5ogmzCauuFrd+Hy102S7swgDWoBclVbmcc6W2SMYpk76LiKbJUZnPpqfc
         VDTrG5mVKcNhz5Lm1wB4kamup/9xLpnY3e+8cCP0+AWVLPPJi7AJRoWI8fURef8cAZm9
         LUr81ZC1mm9BtOURc5bVZDUhXhelAeJPA7EiVpNdfwMvmpnnZBakk3Li4hO5ExoN2u9J
         azzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788273571; x=1788878371;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :message-id:date:subject:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Sq8WERtPgYhkPbAu1lD9X5RHbMKk+hk5c82yqST5k6M=;
        b=Wk58VU5SMk+O7P8bkS6JMKEuthhy7y3OZUT5EySYTVqXx5neChKD1LVJ3euo4VyHKk
         pkPzjIoD0ocF1RsxEknEUmf2rraHvlwlrrs55mHEB5JoMF9VDHjVGcVLRnak/ZMlw2EI
         HxkcbXti9UAVn9P1wINx5+9uwxmd45X0v4PlxiZUFVCVpbCrgQT5y0HnwWePcjevo8KG
         21mMpNjZGGj929W+e4MUdQHtDkqbO3BP7zj31YB8k5NcivhqkHHJ771mxtLoSJW4/rNo
         AkPo6N7WOejWs82+IoSiXjGOmgn2ruB9DVOsI174TNjvQCqx5Xw+1tAeVTwRaGbnrR7U
         fFFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDo4q8O5lwbPX9dKfS4RWZRW47EX1zOlVASCiCwzjfAmi/VDlxDlkmid+Wo0Syaoc7/MMMuyqkOP+a@vger.kernel.org
X-Gm-Message-State: AFuF++lwNQzSZSk81QfpnHiv5/cDGjNyNpSJhThT49wRxdfdK8egpOMe
	lH04rEKV9pu2m6wlsbZ9KNXIWJtRosPsVGvUFe/tgJDYaAehNyoJfRYd
X-Gm-Gg: AYBFou3VEEgz/VCuvPxBNBjwmyg+j2AGIJkP5gQtagxEFyqaZVrs4vWfTUvi9dgaViX
	gaFR4Z0V7SdtjdI1S68KB6RKcZ/nITsdRNGzA3nra+zZgsQxv+tRoXUaOiqv1eExxjYG56IZdJz
	K0s+DplE8tAkloXORQGBY4xD6HFZ9XprZiPApOQyCOaoBcGGmgzfSw1CZ+keU408ZmrKMrTa/QT
	c6lkpg9VNVJjy2XlHz/N0EoR3asqEC5lUrdJA5kVzMz69Gts21uQR9Dx/PROvhIoioUJq/naWoA
	t27fE6LOzoRIlfqRvJi7TQf+7lsfNra4RT00bQCjxXlu9lgqYqOWynLVsC/P8vL4ANqy1ATLZK7
	MUvMuVP7ZksohffCoFWcf/BwqwyjDUnYP3Ki0+12CpanJ7FC18k/p1GJXOqb5X2zut67gT/hXkk
	1nNTqqGviLO3VuFSLNa1M7mT61tEVqal+cYN1MCTpTnpdn9E2CTi9F+BiXf38sOPOAHhozKVUth
	Vtq
X-Received: by 2002:a17:90b:6c7:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-396d0e25905mr53255820a91.2.1788273570553;
        Tue, 01 Sep 2026 07:39:30 -0700 (PDT)
Received: from [192.168.71.146] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae0dfcd65sm59248a91.3.2026.09.01.07.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:39:29 -0700 (PDT)
Subject:
 [PATCH RFC 0/1] leds: add ASUS Aura SCSI driver for ROG NVMe enclosures
Date: Tue, 01 Sep 2026 22:26:46 +0800
Message-ID: <202609012200.RFC0.lhw@gmail.com>
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



Hello,

this is the v1 I promised in the "Placement of ASUS Aura and
platform/x86 ASUS files relocation" thread: the LED side of ASUS Aura
RGB on ROG external NVMe enclosures, posted for review in drivers/leds
as Armin suggested, and in line with the shared ASUS Aura interface
Denis has been coordinating.

The hardware: ROG external NVMe enclosures (ROG STRIX Arion, USB
0b05:1932) are plain USB mass-storage devices. They expose two mass
storage interfaces (BOT and UAS) and no HID interface; the Aura LEDs
hang off an ENE controller reached through vendor SCSI commands on the
same LUN as the disk. The Arion has 4 independently addressable LEDs,
verified on hardware.

The interface: the driver registers a scsi_device_handler, matches by
INQUIRY strings (vendor "ROG", model "ESD-S1C"), does not claim the
sdev (sd keeps owning the disk), and exposes each LED as a multicolor
LED class device, /sys/class/leds/asus-arion:led0 through led3.

Protocol summary: a 16-byte vendor CDB (opcode 0xec, 'A' 'S'
signature, register index, argument count in cdb[13]). MODE 0x8021
(Static) must be written first in every sequence or the device ignores
the whole sequence; colours are written to 0x8160 + 3 * led and
0x8100 + 3 * led (3 bytes each, order R, B, G; both tables are written
because firmware revisions pull from one or the other); APPLY 0x80a0
takes 0x01 to apply and 0xaa to save, and only the save makes a change
stick.

A transport gotcha that seems worth wider visibility: the CDB cannot
go through scsi_execute_cmd(), because it derives the command length
from scsi_command_size(opcode), which maps vendor opcode 0xec to
10 bytes. The ENE protocol is a 16-byte CDB with the data length in
cdb[13], so scsi_execute_cmd() drops that byte and the device silently
ignores the write (GOOD status, no error). The driver builds the block
request by hand and forces cmd_len =3D 16, which is what SG_IO does from
userspace. Any kernel driver sending a vendor CDB whose real length
does not match scsi_command_size(opcode) is going to hit the same
thing.

Placement: per Armin's suggestion in the thread, the LED side belongs
in drivers/leds, since the enclosure is not a platform device and the
user-facing interface is the multicolor LED sysfs. What is posted here
is the driver as verified on hardware, still monolithic. The agreed
shape going forward, with Denis, is a SCSI transport helper in
drivers/scsi feeding an Aura LED driver in drivers/leds behind a
shared ASUS Aura interface; the Kconfig, Makefile and MAINTAINERS
wiring lands with that split. So the main questions for this round are
the LED interface, the protocol handling and the placement.

Known caveats, stated up front:

- the handler attaches manually until a notifier lands
  (echo asus_aura > /sys/block/sdX/device/dh_state);
- SAVE (0xaa) is issued on every colour change, which writes the
  enclosure flash each time; wear has not been characterized yet;
- the LEDs are registered with a NULL parent device, because
  parenting them to the sdev creates a reference cycle that blocks
  the sdev's final release on unplug and leaks the LED nodes and the
  module refcount.

Comments on the interface shape and on folding this into the shared
Aura work are very welcome.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>

Liang Haowen (1):
  leds: add ASUS Aura SCSI driver for ROG NVMe enclosures

 drivers/leds/leds-asus-aura-scsi.c | 302 +++++++++++++++++++++++++++++++++++=
++
 1 file changed, 302 insertions(+)

--=20
2.55.0

