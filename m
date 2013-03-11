From: Vijay Mohan Guvva <vmohan@Brocade.com>
Subject: RE: [PATCH] bfa: Fix possible NULL pointer dereference & magic no
Date: Mon, 11 Mar 2013 16:43:18 -0600
Message-ID: <51BD2AE8016AE441B63F5661159C990203A17E0D9D@BRM-EXCH-3.corp.brocade.com>
References: <1361747271-29352-1-git-send-email-s.syam@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:45762 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188Ab3CKXS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Mar 2013 19:18:58 -0400
Received: from pps.filterd (m0000542 [127.0.0.1])
	by mx0a-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id r2BMgLZc028987
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 15:43:13 -0700
Received: from brmwp-exchub01.corp.brocade.com ([208.47.132.227])
	by mx0a-000f0801.pphosted.com with ESMTP id 1b1pcgg2e4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 15:43:13 -0700
In-Reply-To: <1361747271-29352-1-git-send-email-s.syam@samsung.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Syam Sidhardhan <syamsidhardh@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Anil Gurumurthy <agurumur@Brocade.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Syam Sidhardhan
> Sent: Sunday, February 24, 2013 3:08 PM
> To: linux-scsi@vger.kernel.org
> Cc: syamsidhardh@gmail.com; Anil Gurumurthy; Vijay Mohan Guvva;
> JBottomley@parallels.com
> Subject: [PATCH] bfa: Fix possible NULL pointer dereference & magic no
> 
> Check for (port == NULL) has to be done before accessing port.
> Also fixes the magic number.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> ---
>  drivers/scsi/bfa/bfa_fcs_lport.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
> index 1224d04..69cf977 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
> @@ -5615,11 +5615,13 @@
> bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
>  	bfa_port_speed_t max_speed = 0;
>  	struct bfa_port_attr_s port_attr;
>  	bfa_port_speed_t port_speed, rport_speed;
> -	bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
> +	bfa_boolean_t trl_enabled;
> 
> 
>  	if (port == NULL)
> -		return 0;
> +		return BFA_PORT_SPEED_UNKNOWN;
> +
> +	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
> 
>  	fcs = port->fcs;
> 

Thanks for the patch Shyam.
Acked-by: Vijay Mohan Guvva <vmohan@Brocade.com>

