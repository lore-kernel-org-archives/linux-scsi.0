From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 12:05:53 -0500
Message-ID: <53A9AFF1.4010404@cs.wisc.edu>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net> <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu> <yq1fviugtgq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1fviugtgq.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/24/2014 11:31 AM, Martin K. Petersen wrote:
>>>>>> "Mike" == Michael Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> writes:
> 
> Mike> Do we need to check for the data direction. Something like
> 
> Mike> if (scmd->sc_data_direction == DMA_TO_DEVICE)
> Mike> 	xfer_len = scsi_out(scmnd)->length;
> Mike> else
> Mike> 	xfer_len = scsi_in(scmnd)->length;
> 
> I guess that depends on the context the wrapper is called in. I think
> iscsi is the only place where there's a distinction thanks to bidi.
> 

We were using it generically, so we did not check if bidi or t10 pi. We
were calling it just expecting it to do the right thing for us.

> Looks like there are several places where that's done. In that case I
> wonder if we should have explicit scsi_in_transfer_length() and
> scsi_out_transfer_length() wrappers?

Yeah, maybe.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
