From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/22] be2iscsi: Fix negotiated parameters upload to FW
Date: Mon, 16 Sep 2013 21:58:52 -0500
Message-ID: <5237C56C.1060605@cs.wisc.edu>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com> <1379049014-32716-4-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45441 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab3IQD05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Sep 2013 23:26:57 -0400
In-Reply-To: <1379049014-32716-4-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 09/13/2013 12:09 AM, Jayamohan Kallickal wrote:
>  - If target does not send MaxRecvDSL in login repsonse, then
>    initiator should consider the MaxRecvDSL for target is 8K.
>    In this scenario driver was setting the value to 64K and this
>    caused target to close cxn as data xfer was more than the
>    MaxRecvDSL
>  - Update connection offload data structure for SKH-R adapters.
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_iscsi.c |    9 +++++++--
>  drivers/scsi/be2iscsi/be_main.h  |   29 ++++++++++++++++-------------
>  drivers/scsi/be2iscsi/be_mgmt.c  |    8 +++-----
>  3 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index 2496ea7..60c1dff 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -672,9 +672,10 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
>  			session->max_burst = 262144;
>  		break;
>  	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
> -		if ((conn->max_xmit_dlength > 65536) ||
> -		    (conn->max_xmit_dlength == 0))
> +		if (conn->max_xmit_dlength > 65536)
>  			conn->max_xmit_dlength = 65536;
> +		else if (conn->max_xmit_dlength == 0)
> +			conn->max_xmit_dlength = 8192;

Was the target sending 0 or not sending anything at all? Userspace
should not be sending 0 if the target did not send MaxRecvDSL. It looks
like it should be sending 8k for that case. It looks like there is a bug
in the tools where it will pass 0 if the target sent 0.

It seems other drivers would be hitting this bug too and we should fix
everyone.
