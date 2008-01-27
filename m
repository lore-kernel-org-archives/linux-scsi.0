From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH] sym53c8xx: fix bad memset argument in sym_set_cam_result_error
Date: Sun, 27 Jan 2008 01:18:58 +0100
Message-ID: <200801270119.00429.m.kozlowski@tuxland.pl>
References: <20080126220730.GN14201@localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3492 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbYA0ATD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 19:19:03 -0500
In-Reply-To: <20080126220730.GN14201@localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, FUJITA Tomonori <tomof@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

Hello,

> On a big powerpc box I got the following oops with 2.6.24-git2:
> 
> sym0: <1010-66> rev 0x1 at pci 0000:d0:01.0 irq 215
> sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.2.3
>  target0:0:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
> scsi 0:0:8:0: Direct-Access     IBM      ST318305LC       C509 PQ: 0
> ANSI: 3
>  target0:0:8: tagged command queuing enabled, command queue depth 16.
>  target0:0:8: Beginning Domain Validation
>  target0:0:8: asynchronous
>  target0:0:8: wide asynchronous
>  target0:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
>  target0:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc000000000038460
> cpu 0x25: Vector: 300 (Data Access) at [c00000000f567840]
>     pc: c000000000038460: .memcpy+0x60/0x280
>     lr: d000000000050280: .sym_set_cam_result_error+0xfc/0x1e0 [sym53c8xx]
>     sp: c00000000f567ac0
>    msr: 8000000000009032
>    dar: 0
>  dsisr: 42000000
>   current = 0xc000006d1e0af0a0
>   paca    = 0xc0000000004afc00
>     pid   = 0, comm = swapper
> enter ? for help
> [link register   ] d000000000050280
> .sym_set_cam_result_error+0xfc/0x1e0 [sym53c8xx]
> [c00000000f567ac0] c00000000f567b80 (unreliable)
> [c00000000f567b80] d0000000000552b8 .sym_complete_error+0x12c/0x1bc [sym53c8xx]
> [c00000000f567c20] d0000000000561a4 .sym_int_sir+0xaa4/0x1718 [sym53c8xx]
> [c00000000f567d00] d000000000057e8c .sym_interrupt+0x4e4/0x6ec [sym53c8xx]
> [c00000000f567dc0] d00000000004fdf4 .sym53c8xx_intr+0x6c/0xdc [sym53c8xx]
> [c00000000f567e50] c0000000000a83e0 .handle_IRQ_event+0x7c/0xec
> [c00000000f567ef0] c0000000000aa344 .handle_fasteoi_irq+0x130/0x1f0
> [c00000000f567f90] c00000000002a538 .call_handle_irq+0x1c/0x2c
> [c000004d5e0b3a90] c00000000000c320 .do_IRQ+0x108/0x1d0
> [c000004d5e0b3b20] c000000000004790 hardware_interrupt_entry+0x18/0x1c
> 
> The memset() in sym_set_cam_result_error() would appear to be trashing
> the scsi_cmnd struct instead of clearing sense_buffer.
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index 21e926d..e939f38 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -207,7 +207,7 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
>  			/*
>  			 *  Bounce back the sense data to user.
>  			 */
> -			memset(&cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> +			memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>  			memcpy(cmd->sense_buffer, cp->sns_bbuf,
>  			       min(SCSI_SENSE_BUFFERSIZE, SYM_SNS_BBUF_LEN));
>  #if 0

I was looking into it and found something interesting. What you see was just exposed by:

commit b80ca4f7ee36c26d300c5a8f429e73372d153379
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Sun Jan 13 15:46:13 2008 +0900

    [SCSI] replace sizeof sense_buffer with  
    
    This replaces sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in
    several LLDs. It's a preparation for the future changes to remove
    sense_buffer array in scsi_cmnd structure.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

But this is not a simple replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
It has a side effect. Take a look a this portion of the commit:

--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -207,10 +207,9 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
                        /*
                         *  Bounce back the sense data to user.
                         */
-                       memset(&cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+                       memset(&cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
                        memcpy(cmd->sense_buffer, cp->sns_bbuf,
-                             min(sizeof(cmd->sense_buffer),
-                                 (size_t)SYM_SNS_BBUF_LEN));
+                              min(SCSI_SENSE_BUFFERSIZE, SYM_SNS_BBUF_LEN));

Before the patch:
1) memset sets cmd->sense_buffer pointer value to zero (only 4 bytes which is wrong)
2) memcpy copies min(sizeof(cmd->sense_buffer), (size_t)SYM_SNS_BBUF_LEN)) which
   is equal to min(4, 32) so after this only first four bytes were copied from 32 bytes
   long cp->sns_bbuf into the sense_buffer

After the patch:
1) memset zeroes 96 bytes of cmd structure starting at offset where sense_buffer in
   cmd is and results in an oops which you fixed
2) memcpy copies min(SCSI_SENSE_BUFFERSIZE, SYM_SNS_BBUF_LEN)) is equal to
   min(96, 32). cp->sns_bbuf is 32 bytes so I guess that's ok but that's different from
   the code before b80ca4f7 which was wrong (copied only 4 bytes) but 'worked'.

Someone more experienced with that code should take a look at the logic of it.

Regards,

	Mariusz
