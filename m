From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] [RESEND] qla2xxx: prevent board_disable from running
 during EEH
Date: Fri, 26 Jun 2015 17:24:16 -0400
Message-ID: <558DC300.3020004@stratus.com>
References: <1430395985-17101-1-git-send-email-cascardo@linux.vnet.ibm.com> <558D7EF7.30104@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:36287 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbFZVY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2015 17:24:27 -0400
In-Reply-To: <558D7EF7.30104@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com, qla2xxx-upstream@qlogic.com, cascardo@debian.org

On 06/26/2015 12:33 PM, Mauricio Faria de Oliveira wrote:
> Commit f3ddac1918fe963bcbf8d407a3a3c0881b47248b ("[SCSI] qla2xxx:
> Disable adapter when we encounter a PCI disconnect.") has introduced a
> code that disables the board, releasing some resources, when reading
> 0xffffffff.
> 
> In case this happens when there is an EEH, this read will trigger EEH
> detection and set PCI channel offline. EEH will be able to recover the
> card from this state by doing a reset, so it's a better option than
> simply disabling the card.
> 
> Since eeh_check_failure will mark the channel as offline before
> returning the read value, in case there really was an EEH, we can simply
> check for pci_channel_offline, preventing the board_disable code from
> running if it's true.
> 
> Without this patch, EEH code will try to access those same resources
> that board_disable will try to free. This race can cause EEH recovery to
> fail.
> 
> [  504.370577] EEH: Notify device driver to resume
> [  504.370580] qla2xxx [0001:07:00.0]-9002:2: The device failed to
> resume I/O from slot/link_reset.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> Cc: <cascardo@debian.org>
> Cc: <mauricfo@linux.vnet.ibm.com>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> b/drivers/scsi/qla2xxx/qla_isr.c
> index a04a1b1..8132926 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -116,7 +116,7 @@ bool
>  qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
>  {
>      /* Check for PCI disconnection */
> -    if (reg == 0xffffffff) {
> +    if (reg == 0xffffffff && !pci_channel_offline(vha->hw->pdev)) {
>          if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags) &&
>              !test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags) &&
>              !test_bit(PFLG_DRIVER_PROBING, &vha->pci_flags)) {

Hi Mauricio,

Re: signed-off-by chain -- I believe if you are (re)sending another
person's patch, you will need a:  "From: Thadeu Lima de Souza Cascardo
<cascardo@linux.vnet.ibm.com>"  tag at the top of the message body to
retain original authorship and then your own:  "Signed-off-by: Mauricio
Faria de Oliveira <mauricfo@linux.vnet.ibm.com>" tag below Thadeu's
since the patch has passed through you.

Re: the patch -- I did some work last year to harden board_disable
against various races, but without having EEH hardware available, I was
uncertain about EEH behavior.  For example:

pci_read
   EEH -> marks channel offline
pci_read returns ~0

When do the EEH error handler callbacks run?

Thanks,

-- Joe
