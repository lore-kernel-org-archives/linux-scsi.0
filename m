From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] qla2xxx: Don't memset buffer unless debug level is enabled
Date: Thu, 01 Dec 2011 09:12:27 +0100
Message-ID: <4ED736EB.4090201@linutronix.de>
References: <1322690639-20756-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1322690639-20756-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 11/30/2011 11:03 PM, Nicholas A. Bellinger wrote:
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index 07372de..cc32ec8 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -1676,11 +1676,11 @@ ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
>   	uint32_t len;
>   	struct pci_dev *pdev = NULL;
>
> -	memset(pbuf, 0, QL_DBG_BUF_LEN);
> -
>   	va_start(ap, msg);
>
>   	if ((level&  ql2xextended_error_logging) == level) {
> +		memset(pbuf, 0, QL_DBG_BUF_LEN);
> +		

512bytes on the stack is brave. Anyway, why do you memset the whole
buffer? As far the string processing is concerned, setting the first
byte to zero is enough.

Sebastian
