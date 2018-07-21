From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: prevent ISA driver from building on PPC32
Date: Sat, 21 Jul 2018 12:58:21 -0700
Message-ID: <5928f120-5a23-eff9-6c1d-41344d588b11@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: PowerPC <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Prevent drivers from building on PPC32 if they use isa_bus_to_virt(),
isa_virt_to_bus(), or isa_page_to_bus(), which are not available and
thus cause build errors.

../drivers/scsi/aha1542.c: In function 'aha1542_queuecommand':
../drivers/scsi/aha1542.c:461:30: error: implicit declaration of function 'isa_page_to_bus'; did you mean 'page_to_bus'? [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20180720.orig/drivers/scsi/Kconfig
+++ linux-next-20180720/drivers/scsi/Kconfig
@@ -428,7 +428,7 @@ config SCSI_AHA152X
 
 config SCSI_AHA1542
 	tristate "Adaptec AHA1542 support"
-	depends on ISA && SCSI && ISA_DMA_API
+	depends on ISA && SCSI && ISA_DMA_API && !PPC32
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.4 of the SCSI-HOWTO, available from
