From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/10] esp: enable CONFIG2_FENAB for am53c974
Date: Fri, 21 Nov 2014 11:52:41 +0100
Message-ID: <546F1979.70900@redhat.com>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-11-git-send-email-hare@suse.de> <546F0F2B.40901@redhat.com> <546F1276.9000704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaKUKwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:52:53 -0500
In-Reply-To: <546F1276.9000704@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org



On 21/11/2014 11:22, Hannes Reinecke wrote:
> On 11/21/2014 11:08 AM, Paolo Bonzini wrote:
>>
>>
>> On 21/11/2014 10:27, Hannes Reinecke wrote:
>>> CONFIG2_FENAB ('feature enable') changed definition between chip
>>> revisions, from 'Latch SCSI Phase' to 'Latch SCSI Phase, display
>>> chip ID upon reset, and enable 24 bit addresses'.
>>> So only enable it for am53c974 where we know what it's doing.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>  drivers/scsi/am53c974.c | 30 ++++++++++++++++++++++++++++++
>>>  drivers/scsi/esp_scsi.c |  4 ++++
>>>  2 files changed, 34 insertions(+)
>>>
>>> diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
>>> index 0452ed1..722e781 100644
>>> --- a/drivers/scsi/am53c974.c
>>> +++ b/drivers/scsi/am53c974.c
>>> @@ -252,6 +252,8 @@ static void pci_esp_send_dma_cmd(struct esp *esp, u32 addr, u32 esp_count,
>>>  
>>>  	pci_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
>>>  	pci_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
>>> +	if (esp->config2 & ESP_CONFIG2_FENAB)
>>> +		pci_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
>>
>> Why do this conditionally?  We know that FENAB is true here, don't we?
>>
>> (Maybe I'm missing something obvious though).
>>
> Not really. Point is that 'FENAB' does actually three things:
> - Enable TCHI for 24-bit DMA transfer lengths
> - Provide Chip ID in TCHI after reset
> - Latch SCSI phase after completion in SCSI STATUS
> So we _might_ run into timing issues due to the last point, so I've
> made it conditional in case we'd have to disable it.

Maybe make it a module parameter maybe?

Something like this lets you set esp->config2 from the driver.  Look at
it with -b to avoid insanity, it changes half a dozen line modulo the
reindendation.

-------------- 8< --------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] esp_scsi: let DMA driver provide a config2 value

On PCscsi, the FENAB configuration also enables 24-bit DMA transfer lengths
(and provides the chip id in TCHI after reset).  We want this to be available
as a module parameter.

Check if the caller of scsi_esp_register provided a value for esp->config2.
If this is the case, assume this is not an ESP100, skip the detection
phase and leave esp->config2 untouched.  It will be used in esp_reset_esp.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 55548dc5cec3..123edcf439c0 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2149,47 +2149,50 @@ static void esp_get_revision(struct esp *esp)
 	u8 val;
 
 	esp->config1 = (ESP_CONFIG1_PENABLE | (esp->scsi_id & 7));
-	esp->config2 = (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY);
+	if (esp->config2 == 0) {
+		esp->config2 = (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY);
+		esp_write8(esp->config2, ESP_CFG2);
+
+		val = esp_read8(ESP_CFG2);
+		val &= ~ESP_CONFIG2_MAGIC;
+
+		esp->config2 = 0;
+		if (val != (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY)) {
+			/* If what we write to cfg2 does not come back, cfg2 is not
+			 * implemented, therefore this must be a plain esp100.
+			 */
+			esp->rev = ESP100;
+			return;
+		}
+	}
+
+	esp_set_all_config3(esp, 5);
+	esp->prev_cfg3 = 5;
 	esp_write8(esp->config2, ESP_CFG2);
+	esp_write8(0, ESP_CFG3);
+	esp_write8(esp->prev_cfg3, ESP_CFG3);
 
-	val = esp_read8(ESP_CFG2);
-	val &= ~ESP_CONFIG2_MAGIC;
-	if (val != (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY)) {
-		/* If what we write to cfg2 does not come back, cfg2 is not
-		 * implemented, therefore this must be a plain esp100.
+	val = esp_read8(ESP_CFG3);
+	if (val != 5) {
+		/* The cfg2 register is implemented, however
+		 * cfg3 is not, must be esp100a.
 		 */
-		esp->rev = ESP100;
+		esp->rev = ESP100A;
 	} else {
-		esp->config2 = 0;
-		esp_set_all_config3(esp, 5);
-		esp->prev_cfg3 = 5;
-		esp_write8(esp->config2, ESP_CFG2);
-		esp_write8(0, ESP_CFG3);
+		esp_set_all_config3(esp, 0);
+		esp->prev_cfg3 = 0;
 		esp_write8(esp->prev_cfg3, ESP_CFG3);
 
-		val = esp_read8(ESP_CFG3);
-		if (val != 5) {
-			/* The cfg2 register is implemented, however
-			 * cfg3 is not, must be esp100a.
-			 */
-			esp->rev = ESP100A;
+		/* All of cfg{1,2,3} implemented, must be one of
+		 * the fas variants, figure out which one.
+		 */
+		if (esp->cfact == 0 || esp->cfact > ESP_CCF_F5) {
+			esp->rev = FAST;
+			esp->sync_defp = SYNC_DEFP_FAST;
 		} else {
-			esp_set_all_config3(esp, 0);
-			esp->prev_cfg3 = 0;
-			esp_write8(esp->prev_cfg3, ESP_CFG3);
-
-			/* All of cfg{1,2,3} implemented, must be one of
-			 * the fas variants, figure out which one.
-			 */
-			if (esp->cfact == 0 || esp->cfact > ESP_CCF_F5) {
-				esp->rev = FAST;
-				esp->sync_defp = SYNC_DEFP_FAST;
-			} else {
-				esp->rev = ESP236;
-			}
-			esp->config2 = 0;
-			esp_write8(esp->config2, ESP_CFG2);
+			esp->rev = ESP236;
 		}
+		esp_write8(esp->config2, ESP_CFG2);
 	}
 }
 

Paolo
