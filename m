From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] multipath: Evaluate request result and sense
	code
Date: Sun, 22 Nov 2009 15:00:17 -0600
Message-ID: <4B09A661.10102@cs.wisc.edu>
References: <20091119122503.413AD3A174@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091119122503.413AD3A174@ochil.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
>  /*
> + * Evaluate scsi return code
> + */
> +static int eval_scsi_error(int result, char *sense, int sense_len)
> +{
> +	struct scsi_sense_hdr sshdr;
> +	int r = DM_ENDIO_REQUEUE;
> +
> +	if (host_byte(result) != DID_OK)


For values like DID_NO_CONNECT or DID_TRANSPORT FAILFAST, I think it 
makes sense to fail the path. Not in this patch, but a new one, would we 
want to modify dm-mpath so that we do not fail the path for errors like 
DID_ABORT or DID_SOFT_ERROR, DID_RESET or DID_ERROR?
