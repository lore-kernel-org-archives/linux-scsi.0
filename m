From: Nilesh Javali <nilesh.javali@qlogic.com>
Subject: Re: [PATCH 5/7] scsi: qla4xxx: shut up warning for rd_reg_indirect
Date: Mon, 1 Feb 2016 08:17:48 +0000
Message-ID: <D2D511DF.1CBA9%nilesh.javali@qlogic.com>
References: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
 <1453910247-3447628-6-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453910247-3447628-6-git-send-email-arnd@arndb.de>
Content-Language: en-US
Content-ID: <618D1F2A08DBE04C96EE41CC04D050D6@namprd11.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@qlogic.com>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 27/01/16 9:27 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:

>The qla4_83xx_rd_reg_indirect() function can fail when it is unable
>to read a register, but not all callers check its return value before
>using the register data, and gcc correctly warns about this:
>
>qla4xxx/ql4_83xx.c: In function 'qla4_83xx_process_reset_template':
>qla4xxx/ql4_83xx.c:1073:36: warning: 'value' may be used uninitialized in
>this function
>     ha->reset_tmplt.array[index++] = value;
>                                    ^
>qla4xxx/ql4_83xx.c:1050:11: note: 'value' was declared here
>  uint32_t value;
>           ^
>qla4xxx/ql4_83xx.c:902:8: warning: 'value' may be used uninitialized in
>this function
>  value &= p_rmw_hdr->test_mask;
>        ^
>qla4xxx/ql4_83xx.c:895:11: note: 'value' was declared here
>  uint32_t value;
>           ^
>In file included from ../include/linux/io.h:25:0,
>                 from ../include/linux/pci.h:31,
>                 from ../drivers/scsi/qla4xxx/ql4_def.h:16,
>                 from ../drivers/scsi/qla4xxx/ql4_83xx.c:10:
>asm/io.h:101:2: warning: 'value' may be used uninitialized in this
>function
>  asm volatile("str %1, %0"
>  ^
>qla4xxx/ql4_83xx.c:874:11: note: 'value' was declared here
>  uint32_t value;
>           ^
>
>Unfortunately, I don't see any helpful way to add proper error handling
>for this case, and the failure scenario for rd_reg seems rather obscure,
>so this bails out and makes the rd_reg accessor set the result to
>0xffffffff
>so we at least get a predictable value.
>
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>---
> drivers/scsi/qla4xxx/ql4_83xx.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c
>b/drivers/scsi/qla4xxx/ql4_83xx.c
>index 5d4f8e67fb25..638f72c5ab05 100644
>--- a/drivers/scsi/qla4xxx/ql4_83xx.c
>+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
>@@ -46,11 +46,13 @@ int qla4_83xx_rd_reg_indirect(struct scsi_qla_host
>*ha, uint32_t addr,
> 
> 	ret_val = qla4_83xx_set_win_base(ha, addr);
> 
>-	if (ret_val == QLA_SUCCESS)
>+	if (ret_val == QLA_SUCCESS) {
> 		*data = qla4_83xx_rd_reg(ha, QLA83XX_WILDCARD);
>-	else
>+	} else {
>+		*data = 0xffffffff;
> 		ql4_printk(KERN_ERR, ha, "%s: failed read of addr 0x%x!\n",
> 			   __func__, addr);
>+	}
> 
> 	return ret_val;
> }
>-- 
>2.7.0
>

Acked-by: Nilesh Javali <nilesh.javali@qlogic.com>
