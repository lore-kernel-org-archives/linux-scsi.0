From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH v2] osd: remove deadcode
Date: Wed, 24 Feb 2016 16:58:51 +0200
Message-ID: <56CDC52B.1040407@electrozaur.com>
References: <1456312888-22074-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456312888-22074-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Benny Halevy <bhalevy@primarydata.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

On 02/24/2016 01:21 PM, Sudip Mukherjee wrote:
> The variable is_ver1 is always true and so OSD_CAP_LEN can never be
> used.
> Reported by Coverity.
> 
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

ACK-by: Boaz harrosh <ooo@elecrozaur.com>

Thanks
> ---
> 
> v2: Joe Perches asked to mention the tool used in the commit log.
> 
>  drivers/scsi/osd/osd_initiator.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index d8a2b51..3b11aad 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -2006,9 +2006,8 @@ EXPORT_SYMBOL(osd_sec_init_nosec_doall_caps);
>   */
>  void osd_set_caps(struct osd_cdb *cdb, const void *caps)
>  {
> -	bool is_ver1 = true;
>  	/* NOTE: They start at same address */
> -	memcpy(&cdb->v1.caps, caps, is_ver1 ? OSDv1_CAP_LEN : OSD_CAP_LEN);
> +	memcpy(&cdb->v1.caps, caps, OSDv1_CAP_LEN);
>  }
>  
>  bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms __unused)
> 
