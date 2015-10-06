From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv3 1/1] SCSI: update hosts module to use idr index
 management
Date: Tue, 06 Oct 2015 12:19:56 -0700
Message-ID: <1444159196.10564.11.camel@HansenPartnership.com>
References: <cover.1444157464.git.lduncan@suse.com>
	 <e86885050b0dd09b2ed47a5dd5fd705cd747cc94.1444157464.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e86885050b0dd09b2ed47a5dd5fd705cd747cc94.1444157464.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-06 at 12:08 -0700, Lee Duncan wrote:
> Update the SCSI hosts module to use idr to manage
> its host_no index instead of an ATOMIC integer. This
> also allows using idr_find() to look up the SCSI
> host structure given the host number.
> 
> This means that the SCSI host number will now
> be reclaimable.
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hosts.c | 61 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 31 insertions(+), 30 deletions(-
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8bb173e01084..afe7bd962ddb 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
[...]
> +	spin_lock(&host_index_lock);
> +	shost = idr_find(&host_index_idr, hostnum);
> +	spin_unlock(&host_index_lock);
> +
> +	return shost ? scsi_host_get(shost) : NULL;

So the thing I don't like here is that there's a race between
scsi_host_get() and the final put.  What could happen is that idr_find()
returns the host just before but scsi_host_dev_release() is executed
before the return.  In that instance, we'll reference freed memory in
scsi_host_get() ... probably completely harmlessly, but it will show up
occasionally on some of the traces ... particularly the ones doing a
fuzz/stress test around host create/destroy.

James
