From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: esp_scsi QTAG in FAS216
Date: Mon, 14 Apr 2014 10:38:09 +1200
Message-ID: <CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com>
References: <CAOmrzkKP4YcvnHcrtucMvS9WSaeg+6-qnobOWN6hBK=wkUHemg@mail.gmail.com>
	<CAMuHMdUH=9sv-Vb3ZTAGyfvEQOO0x0x1cUYhfd7040k8d+bSYg@mail.gmail.com>
	<5231DF69.6070807@aalto.fi>
	<20140404.162830.1700547572091852195.davem@davemloft.net>
	<CAOmrzkL_6Y2RhpKANmTEWL53-6Ts+PF9Hhk_4Fh1s0wx7f_NhQ@mail.gmail.com>
	<CACz-3rg3LNFKNPUNwc1OF_O_b5k=28hw8Nj50dWhxy4A5_QbVg@mail.gmail.com>
	<CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com>
	<CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63803 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDMWiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Apr 2014 18:38:10 -0400
In-Reply-To: <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: David Miller <davem@davemloft.net>, Tuomas Vainikka <tuomas.vainikka@aalto.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>

Hi Kars,

thanks for the PDFs!

> Bit 2 SCSI-2
>
> Setting this bit allows the FSC to support two new features adopted in
> SCSI-2: the 3-byte message exchange for Tagged-Queueing and Group 2
> commands. These features can also be set independently in the Config 3
> register.
>
> Tagged-Queueing
> When this bit is set and the FSC is selected with ATN (Attention), it
> will request either one or three message bytes depending on whether
> ATN remains true or goes false. If ATN is still true after the first
> byte has been received, the FSC may request two more message bytes
> before switching to Command phase. If ATN goes false, it will switch
> to Command phase after the first message byte. When the bit is not set
> it will request a single message byte (as a target) when selected with
> ATN, and abort the selection sequence (as an initiator) if the target
> does not switch to Command phase after one message byte has been
> transferred.

That appears to be our problem if I recall correctly Tuomas' debugging
report. (reselection, not selection as initiator). As
esp_slave_configure() enables queue tags regardless of chip config,
we'd best make certain the chip is configured correctly.

The SCSI2 bit is used to test for presence of config register 2 in
esp_get_revision but later cleared in the same function. It appears
we'd need to set it after the call to scsi_esp_register() - can you
test whether that obsoletes the zorro_esp_slave_configure hack,
Tuomas?

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index 1a1eb95..b33c3b5 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -418,9 +418,6 @@ static int zorro_esp_init_one(struct zorro_dev *z,
                return -EBUSY;
        }

-       /* Fill in the required pieces of hostdata */
-       scsi_esp_template.slave_configure = zorro_esp_slave_configure;
-
        host = scsi_host_alloc(tpnt, sizeof(struct esp));

        if (!host) {
@@ -508,6 +505,10 @@ static int zorro_esp_init_one(struct zorro_dev *z,
        if (err)
                goto fail_free_irq;

+       esp->config2 = ESP_CONFIG2_SCSI2ENAB;
+       zorro_esp_write8(esp, esp->config2, ESP_CFG2);
+
+
        zorro_set_drvdata(z, host);

        return 0;


> Group 2 Commands
> (seems to only be relevant for target mode).
>
> And about the QTE bit:
>
> Bit 6 Queue Tag Enable
>
> When this bit is set, the 53CF94/96 can receive 3-byte messages during
> bus-initiated Select With ATN. This feature is also enabled by setting
> bit 3 in the Configuration 2 register.

My preference would be to set this one (named ESP_CONFIG3_TBMS). Your
opinion, Dave?

Cheers,

  Michael
