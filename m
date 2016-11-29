From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH] xen/scsifront: don't advance ring
 request pointer in case of error
Date: Tue, 29 Nov 2016 04:14:39 -0700
Message-ID: <583D712F0200007800123283@prv-mh.provo.novell.com>
References: <20161125202650.GK6266@mwanda>
 <20161129105013.7419-1-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:50230 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753824AbcK2LOp (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:6:2>);
        Tue, 29 Nov 2016 06:14:45 -0500
In-Reply-To: <20161129105013.7419-1-jgross@suse.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <JGross@suse.com>
Cc: lambert.quentin@gmail.com, jejb@linux.vnet.ibm.com, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, dan.carpenter@oracle.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>> On 29.11.16 at 11:50, <JGross@suse.com> wrote:
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -184,8 +184,6 @@ static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
>  
>  	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
>  
> -	ring->req_prod_pvt++;

Please note the "_pvt" suffix, which stands for "private": This field is
not visible to the backend. Only ring->sring fields are shared, and
the updating of the shared field happens in RING_PUSH_REQUESTS()
and RING_PUSH_REQUESTS_AND_CHECK_NOTIFY().

Jan

