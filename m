From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/10] zfcp: fix payload trace length for SAN
 request&response
Date: Thu, 11 Aug 2016 13:24:40 +0200
Message-ID: <78ed972a-49a0-05fd-68a2-2ef1e73da0ef@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-10-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbcHKLYn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2016 07:24:43 -0400
In-Reply-To: <1470846653-90691-10-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> commit 2c55b750a884b86dea8b4cc5f15e1484cc47a25c
> ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
> started to add FC_CT_HDR_LEN which made zfcp dump random data
> out of bounds for RSPN GS responses because u.rspn.rsp
> is the largest and last field in the union of struct zfcp_fc_req.
> Other request/response types only happened to stay within bounds
> due to the padding of the union or
> due to the trace capping of u.gspn.rsp to ZFCP_DBF_SAN_MAX_PAYLOAD.
> 
> Timestamp      : ...
> Area           : SAN
> Subarea        : 00
> Level          : 1
> Exception      : -
> CPU id         : ..
> Caller         : ...
> Record id      : 2
> Tag            : fsscth2
> Request id     : 0x...
> Destination ID : 0x00fffffc
> Payload short  : 01000000 fc020000 80020000 00000000
>                  xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx <===
>                  00000000 00000000 00000000 00000000
> Payload length : 32                                  <===
> 
> struct zfcp_fc_req {
>     [0] struct zfcp_fsf_ct_els ct_els;
>    [56] struct scatterlist sg_req;
>    [96] struct scatterlist sg_rsp;
>         union {
>             struct {req; rsp;} adisc;    SIZE: 28+28=   56
>             struct {req; rsp;} gid_pn;   SIZE: 24+20=   44
>             struct {rspsg; req;} gpn_ft; SIZE: 40*4+20=180
>             struct {req; rsp;} gspn;     SIZE: 20+273= 293
>             struct {req; rsp;} rspn;     SIZE: 277+16= 293
>   [136] } u;
> }
> SIZE: 432
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: 2c55b750a884 ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
> Cc: <stable@vger.kernel.org> #2.6.38+
> Reviewed-by: Alexey Ishchuk <aishchuk@linux.vnet.ibm.com>
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> index 968897f5e1c6..d8c0bfb40366 100644
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c
> @@ -389,7 +389,7 @@ void zfcp_dbf_san_req(char *tag, struct zfcp_fsf_req *fsf, u32 d_id)
>  	struct zfcp_fsf_ct_els *ct_els = fsf->data;
>  	u16 length;
>  
> -	length = (u16)(ct_els->req->length + FC_CT_HDR_LEN);
> +	length = (u16)(ct_els->req->length);
>  	zfcp_dbf_san(tag, dbf, sg_virt(ct_els->req), ZFCP_DBF_SAN_REQ, length,
>  		     fsf->req_id, d_id);
>  }
> @@ -405,7 +405,7 @@ void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
>  	struct zfcp_fsf_ct_els *ct_els = fsf->data;
>  	u16 length;
>  
> -	length = (u16)(ct_els->resp->length + FC_CT_HDR_LEN);
> +	length = (u16)(ct_els->resp->length);
>  	zfcp_dbf_san(tag, dbf, sg_virt(ct_els->resp), ZFCP_DBF_SAN_RES, length,
>  		     fsf->req_id, ct_els->d_id);
>  }
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
