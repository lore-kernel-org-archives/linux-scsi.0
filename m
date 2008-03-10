From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH 07/10] aacraid: use sg buffer copy helper functions
Date: Mon, 10 Mar 2008 08:45:47 -0400
Message-ID: <18D0D30A-E546-413D-907B-A62952A52506@adaptec.com>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-6-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-7-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:35302 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYCJMpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 08:45:49 -0400
In-Reply-To: <1205037877-12843-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tomof@acm.org" <tomof@acm.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

ACK

Especially like that flush_kernel_dcache_page is performed in the  
block layer helper function, one less architectural piece of code in  
an LLD.

Sincerely -- Mark Salyzyn

On Mar 8, 2008, at 11:44 PM, FUJITA Tomonori wrote:

> This replaces aac_internal_transfer with scsi_sg_copy_to/from_buffer.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
> drivers/scsi/aacraid/aachba.c |   49 +++++++++++++ 
> +--------------------------
> 1 files changed, 17 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/ 
> aachba.c
> index b9fc9b1..c947e72 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -379,24 +379,6 @@ int aac_get_containers(struct aac_dev *dev)
>        return status;
> }
>
> -static void aac_internal_transfer(struct scsi_cmnd *scsicmd, void  
> *data, unsigned int offset, unsigned int len)
> -{
> -       void *buf;
> -       int transfer_len;
> -       struct scatterlist *sg = scsi_sglist(scsicmd);
> -
> -       buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
> -       transfer_len = min(sg->length, len + offset);
> -
> -       transfer_len -= offset;
> -       if (buf && transfer_len > 0)
> -               memcpy(buf + offset, data, transfer_len);
> -
> -       flush_kernel_dcache_page(kmap_atomic_to_page(buf - sg- 
> >offset));
> -       kunmap_atomic(buf - sg->offset, KM_IRQ0);
> -
> -}
> -
> static void get_container_name_callback(void *context, struct fib *  
> fibptr)
> {
>        struct aac_get_name_resp * get_name_reply;
> @@ -419,14 +401,17 @@ static void get_container_name_callback(void  
> *context, struct fib * fibptr)
>                while (*sp == ' ')
>                        ++sp;
>                if (*sp) {
> +                       struct inquiry_data inq;
>                        char d[sizeof(((struct inquiry_data *)NULL)- 
> >inqd_pid)];
>                        int count = sizeof(d);
>                        char *dp = d;
>                        do {
>                                *dp++ = (*sp) ? *sp++ : ' ';
>                        } while (--count > 0);
> -                       aac_internal_transfer(scsicmd, d,
> -                         offsetof(struct inquiry_data, inqd_pid),  
> sizeof(d));
> +
> +                       scsi_sg_copy_to_buffer(scsicmd, &inq,  
> sizeof(inq));
> +                       memcpy(inq.inqd_pid, d, sizeof(d));
> +                       scsi_sg_copy_from_buffer(scsicmd, &inq,  
> sizeof(inq));
>                }
>        }
>
> @@ -811,7 +796,7 @@ static void get_container_serial_callback(void  
> *context, struct fib * fibptr)
>                sp[2] = 0;
>                sp[3] = snprintf(sp+4, sizeof(sp)-4, "%08X",
>                  le32_to_cpu(get_serial_reply->uid));
> -               aac_internal_transfer(scsicmd, sp, 0, sizeof(sp));
> +               scsi_sg_copy_from_buffer(scsicmd, sp, sizeof(sp));
>        }
>
>        scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |  
> SAM_STAT_GOOD;
> @@ -1986,8 +1971,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                                arr[4] = 0x0;
>                                arr[5] = 0x80;
>                                arr[1] = scsicmd->cmnd[2];
> -                               aac_internal_transfer(scsicmd,  
> &inq_data, 0,
> -                                 sizeof(inq_data));
> +                               scsi_sg_copy_from_buffer(scsicmd,  
> &inq_data,
> +                                                         
> sizeof(inq_data));
>                                scsicmd->result = DID_OK << 16 |
>                                  COMMAND_COMPLETE << 8 |  
> SAM_STAT_GOOD;
>                        } else if (scsicmd->cmnd[2] == 0x80) {
> @@ -1995,8 +1980,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                                arr[3] = setinqserial(dev, &arr[4],
>                                  scmd_id(scsicmd));
>                                arr[1] = scsicmd->cmnd[2];
> -                               aac_internal_transfer(scsicmd,  
> &inq_data, 0,
> -                                 sizeof(inq_data));
> +                               scsi_sg_copy_from_buffer(scsicmd,  
> &inq_data,
> +                                                         
> sizeof(inq_data));
>                                return  
> aac_get_container_serial(scsicmd);
>                        } else {
>                                /* vpd page not implemented */
> @@ -2027,7 +2012,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                if (cid == host->this_id) {
>                        setinqstr(dev, (void *) (inq_data.inqd_vid),  
> ARRAY_SIZE(container_types));
>                        inq_data.inqd_pdt = INQD_PDT_PROC;      /*  
> Processor device */
> -                       aac_internal_transfer(scsicmd, &inq_data, 0,  
> sizeof(inq_data));
> +                       scsi_sg_copy_from_buffer(scsicmd, &inq_data,
> +                                                sizeof(inq_data));
>                        scsicmd->result = DID_OK << 16 |  
> COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
>                        scsicmd->scsi_done(scsicmd);
>                        return 0;
> @@ -2036,7 +2022,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                        return -1;
>                setinqstr(dev, (void *) (inq_data.inqd_vid),  
> fsa_dev_ptr[cid].type);
>                inq_data.inqd_pdt = INQD_PDT_DA;        /* Direct/ 
> random access device */
> -               aac_internal_transfer(scsicmd, &inq_data, 0,  
> sizeof(inq_data));
> +               scsi_sg_copy_from_buffer(scsicmd, &inq_data,  
> sizeof(inq_data));
>                return aac_get_container_name(scsicmd);
>        }
>        case SERVICE_ACTION_IN:
> @@ -2070,8 +2056,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                             + (scsicmd->cmnd[12] << 8) + scsicmd- 
> >cmnd[13]);
>
>                alloc_len = min_t(size_t, alloc_len, sizeof(cp));
> -               aac_internal_transfer(scsicmd, cp, 0, alloc_len);
> -
> +               scsi_sg_copy_from_buffer(scsicmd, cp, alloc_len);
>                if (alloc_len < scsi_bufflen(scsicmd))
>                        scsi_set_resid(scsicmd,
>                                       scsi_bufflen(scsicmd) -  
> alloc_len);
> @@ -2104,7 +2089,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                cp[5] = 0;
>                cp[6] = 2;
>                cp[7] = 0;
> -               aac_internal_transfer(scsicmd, cp, 0, sizeof(cp));
> +               scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
>                /* Do not cache partition table for arrays */
>                scsicmd->device->removable = 1;
>
> @@ -2139,7 +2124,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                        if (mode_buf_length > scsicmd->cmnd[4])
>                                mode_buf_length = scsicmd->cmnd[4];
>                }
> -               aac_internal_transfer(scsicmd, mode_buf, 0,  
> mode_buf_length);
> +               scsi_sg_copy_from_buffer(scsicmd, mode_buf,  
> mode_buf_length);
>                scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE <<  
> 8 | SAM_STAT_GOOD;
>                scsicmd->scsi_done(scsicmd);
>
> @@ -2174,7 +2159,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
>                        if (mode_buf_length > scsicmd->cmnd[8])
>                                mode_buf_length = scsicmd->cmnd[8];
>                }
> -               aac_internal_transfer(scsicmd, mode_buf, 0,  
> mode_buf_length);
> +               scsi_sg_copy_from_buffer(scsicmd, mode_buf,  
> mode_buf_length);
>
>                scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE <<  
> 8 | SAM_STAT_GOOD;
>                scsicmd->scsi_done(scsicmd);
> --
> 1.5.3.7
>

