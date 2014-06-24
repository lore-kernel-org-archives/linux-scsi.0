From: sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 18:29:32 +0300
Message-ID: <53A9995C.8020906@mellanox.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>	<1402477799-24610-2-git-send-email-sagig@mellanox.com>	<53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1mwd2h3ju.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 6/24/2014 3:53 PM, Martin K. Petersen wrote:
>
>
> SCSI: Use SCSI data buffer length to extract transfer size
>      
> Commit 8846bab180fa introduced a helper that can be used to query the
> wire transfer size for a SCSI command taking protection information into
> account.
>      
> However, some commands do not have a 1:1 mapping between the block range
> they work on and the payload size (discard, write same). After the
> scatterlist has been set up these requests use __data_len to store the
> number of bytes to report completion on. This means that callers of
> scsi_transfer_length() would get the wrong byte count for these types of
> requests.
>
> To overcome this we make scsi_transfer_length() use the scatterlist
> length in the scsi_data_buffer as basis for the wire transfer
> calculation instead of __data_len.
>
> Reported-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Debugged-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
> Signed-off-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 42ed789ebafc..e0ae71098144 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -318,7 +318,7 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
>   
>   static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
>   {
> -	unsigned int xfer_len = blk_rq_bytes(scmd->request);
> +	unsigned int xfer_len = scsi_out(scmd)->length;
>   	unsigned int prot_op = scsi_get_prot_op(scmd);
>   	unsigned int sector_size = scmd->device->sector_size;
>   

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
