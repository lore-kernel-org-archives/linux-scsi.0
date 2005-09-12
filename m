From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 10/20] aic94xx: aic94xx_reg.c Register access
Date: Mon, 12 Sep 2005 13:04:16 -0400
Message-ID: <4325B510.4010205@adaptec.com>
References: <4321E3CB.2060806@adaptec.com> <20050911102649.GA2742@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:60616 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932099AbVILREX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 13:04:23 -0400
In-Reply-To: <20050911102649.GA2742@elf.ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/11/05 06:26, Pavel Machek wrote:
> Hi!
> 
> 
>>+/* We know that the register wanted is in the range
>>+ * of the sliding window.
>>+ */
>>+#define ASD_READ_SW(ww, type, ord)                                     \
>>+static inline type asd_read_##ww##_##ord (struct asd_ha_struct *asd_ha,\
>>+					  u32 reg)                     \
>>+{                                                                      \
>>+	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];    \
>>+	u32 map_offs=(reg - io_handle-> ww##_base )+asd_mem_offs_##ww ();\
>>+	return asd_read_##ord (asd_ha, (unsigned long) map_offs);      \
>>+}
>>+
>>+#define ASD_WRITE_SW(ww, type, ord)                                    \
>>+static inline void asd_write_##ww##_##ord (struct asd_ha_struct *asd_ha,\
>>+				  u32 reg, type val)                   \
>>+{                                                                      \
>>+	struct asd_ha_addrspace *io_handle = &asd_ha->io_handle[0];    \
>>+	u32 map_offs=(reg - io_handle-> ww##_base )+asd_mem_offs_##ww ();\
>>+	asd_write_##ord (asd_ha, (unsigned long) map_offs, val);       \
>>+}
>>+
>>+ASD_READ_SW(swa, u8,  byte);
>>+ASD_READ_SW(swa, u16, word);
>>+ASD_READ_SW(swa, u32, dword);
>>+
>>+ASD_READ_SW(swb, u8,  byte);
>>+ASD_READ_SW(swb, u16, word);
>>+ASD_READ_SW(swb, u32, dword);
>>+
>>+ASD_READ_SW(swc, u8,  byte);
>>+ASD_READ_SW(swc, u16, word);
>>+ASD_READ_SW(swc, u32, dword);
>>+
>>+ASD_WRITE_SW(swa, u8,  byte);
>>+ASD_WRITE_SW(swa, u16, word);
>>+ASD_WRITE_SW(swa, u32, dword);
>>+
>>+ASD_WRITE_SW(swb, u8,  byte);
>>+ASD_WRITE_SW(swb, u16, word);
>>+ASD_WRITE_SW(swb, u32, dword);
>>+
>>+ASD_WRITE_SW(swc, u8,  byte);
>>+ASD_WRITE_SW(swc, u16, word);
>>+ASD_WRITE_SW(swc, u32, dword);
> 
> 
> This is certainly nice entry into "best abuse of macros" contest. Do
> you really need all those inline functions?

Hehehee, you may be right Pavel.  I just wanted to minimize bugs which
could be introduced by syntax errors (not necessarily compilation errors).

Yes, reading byte/word/dword from HA memory is needed.

>>+static void __asd_write_reg_byte(struct asd_ha_struct *asd_ha, u32 reg, u8 val)
>>+{
>>+	struct asd_ha_addrspace *io_handle=&asd_ha->io_handle[0];
>>+	BUG_ON(reg >= 0xC0000000 || reg < ALL_BASE_ADDR);
> 
> 
> Will this work correctly with 2GB/2GB split kernels?

"reg" is an address in the host adapter's memory.  Will this matter?

	Luben


