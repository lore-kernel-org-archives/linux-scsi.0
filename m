From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 2/4] sound: isa: sscape: Use correct format identifier for size_t
Date: Mon, 11 Apr 2016 09:25:52 -0400
Message-ID: <903e7f51989907f3de2159efb99bd65bf3dc30f7.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:36020 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbcDKN0b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 09:26:31 -0400
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, William Breathitt Gray <vilhelm.gray@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>

The 'size' member of a struct firmware is passed to snd_printk with a
respective format string using the %d identifier. The 'size' member is
of type size_t, but format identifier %d indicates a signed int data
type. This patch replaces the %d format identifier with the correct %zu
format identifier for size_t data types.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 sound/isa/sscape.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index 7b248cd..fdcfa29 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -591,7 +591,7 @@ static int sscape_upload_microcode(struct snd_card *card, int version)
 	}
 	err = upload_dma_data(sscape, init_fw->data, init_fw->size);
 	if (err == 0)
-		snd_printk(KERN_INFO "sscape: MIDI firmware loaded %d KBs\n",
+		snd_printk(KERN_INFO "sscape: MIDI firmware loaded %zu KBs\n",
 				init_fw->size >> 10);
 
 	release_firmware(init_fw);
-- 
2.7.3

