From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] target: Return descriptor format sense data
Date: Tue, 14 Jul 2015 07:40:32 -0700
Message-ID: <20150714144032.GA2763@infradead.org>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
 <1436697423-20611-4-git-send-email-sagig@mellanox.com>
 <20150714071703.GC31117@infradead.org>
 <yq1r3obrvyn.fsf@sermon.lab.mkp.net>
 <55A4F9B7.905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A4F9B7.905@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2015 at 02:59:51PM +0300, Sagi Grimberg wrote:
> diff --git a/include/target/target_core_backend.h
> b/include/target/target_core_backend.h
> index 1e5c8f9..6ce370f 100644
> --- a/include/target/target_core_backend.h
> +++ b/include/target/target_core_backend.h
> @@ -3,6 +3,9 @@
> 
>  #define TRANSPORT_FLAG_PASSTHROUGH             1
> 
> +#define TARGET_SENSE_DESC_FORMAT(dev)          \
> +       dev->transport->get_blocks(dev) >= 0xffffffffULL

Make this a proper function, given that MODE SENSE isn't in the fast
path it doesn't even have to be inline.

Together with a fix for the comment from Bart this looks good to me.
