From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Don't memset buffer unless debug level is
 enabled
Date: Thu, 1 Dec 2011 13:01:23 -0500
Message-ID: <alpine.WNT.2.00.1112011259150.1224@N5102REMCQXM4BS.qlogic.org>
References: <1322690639-20756-1-git-send-email-nab@linux-iscsi.org>  <4ED736EB.4090201@linutronix.de> <1322731309.25753.30.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:2781
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755956Ab1LASCR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 13:02:17 -0500
In-Reply-To: <1322731309.25753.30.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, James Bottomley <JBottomley@Parallels.com>



On Thu, 1 Dec 2011, Nicholas A. Bellinger wrote:

> On Thu, 2011-12-01 at 09:12 +0100, Sebastian Andrzej Siewior wrote:
>> On 11/30/2011 11:03 PM, Nicholas A. Bellinger wrote:
>>> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
>>> index 07372de..cc32ec8 100644
>>> --- a/drivers/scsi/qla2xxx/qla_dbg.c
>>> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
>>> @@ -1676,11 +1676,11 @@ ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
>>>     uint32_t len;
>>>     struct pci_dev *pdev = NULL;
>>>
>>> -   memset(pbuf, 0, QL_DBG_BUF_LEN);
>>> -
>>>     va_start(ap, msg);
>>>
>>>     if ((level&  ql2xextended_error_logging) == level) {
>>> +           memset(pbuf, 0, QL_DBG_BUF_LEN);
>>> +
>>
>> 512bytes on the stack is brave.
>
> ...
>
>>  Anyway, why do you memset the whole
>> buffer? As far the string processing is concerned, setting the first
>> byte to zero is enough.
>>
>
> After converting qla_target.c in a few hundred locations to use
> qla_dbg() my wrists are still hurting, so you can imagine I'm not real
> eager to look into this code.  ;)
>
> Anyways, memset of the whole buffer is overkill.  Since sprintf() is
> being used for qla_dbg.c cases, even the 1 byte memset is unnecessary.

I do want to note that there is a patch posted already that removes the
memset as well:
http://marc.info/?l=linux-scsi&m=132163664809856&w=2.

>
> --nab
>
> From 25541e7f09b87de0000b11506d49695183aab4f1 Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Wed, 30 Nov 2011 13:57:02 -0800
> Subject: [PATCH] qla2xxx: Remove memset debug buffer with sprintf usage
>
> During recent perf testing with qla_target.c logic, dl_dbg() appeared
> as one of the top CPU consumers (~5% CPU) with small block random I/O
> even when no debug levels have been enabled.
>
> This patch drops the explict memset() in four qla_dbc.c functions
> as we expect sprintf() to add the trailing NULL when debug is enabled.
>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Cc: Roland Dreier <roland@purestorage.com>
> Cc: Joern Engel <joern@logfs.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
> drivers/scsi/qla2xxx/qla_dbg.c |    8 --------
> 1 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index 07372de..ef31819 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -1676,8 +1676,6 @@ ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
>       uint32_t len;
>       struct pci_dev *pdev = NULL;
>
> -     memset(pbuf, 0, QL_DBG_BUF_LEN);
> -
>       va_start(ap, msg);
>
>       if ((level & ql2xextended_error_logging) == level) {
> @@ -1724,8 +1722,6 @@ ql_dbg_pci(uint32_t level, struct pci_dev *pdev, int32_t id, char *msg, ...) {
>       if (pdev == NULL)
>               return;
>
> -     memset(pbuf, 0, QL_DBG_BUF_LEN);
> -
>       va_start(ap, msg);
>
>       if ((level & ql2xextended_error_logging) == level) {
> @@ -1763,8 +1759,6 @@ ql_log(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
>       uint32_t len;
>       struct pci_dev *pdev = NULL;
>
> -     memset(pbuf, 0, QL_DBG_BUF_LEN);
> -
>       va_start(ap, msg);
>
>       if (level <= ql_errlev) {
> @@ -1823,8 +1817,6 @@ ql_log_pci(uint32_t level, struct pci_dev *pdev, int32_t id, char *msg, ...) {
>       if (pdev == NULL)
>               return;
>
> -     memset(pbuf, 0, QL_DBG_BUF_LEN);
> -
>       va_start(ap, msg);
>
>       if (level <= ql_errlev) {
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

