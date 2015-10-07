From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv3 0/1] Update SCSI hosts to use idr for host number mgmt
Date: Wed, 7 Oct 2015 16:52:30 -0700
Message-ID: <5615B03E.6080302@suse.com>
References: <cover.1444157464.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1444157464.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Duplicate email, please ignore

On 10/07/2015 04:47 PM, Lee Duncan wrote:
> This patch updates the SCSI hosts module to use the idr
> index-management routines to manage its host_no index instead
> of using an ATOMIC integer. This means that host numbers
> can now be reclaimed and re-used.
> 
> It also updates the hosts module to use the idr routine idr_find()
> to lookup hosts based on the host number, hopefully speeding
> up said lookup.
> 
> After noticing that my idr calling sequences where very close
> to those in other modules, I considered creating some idr helper
> functions (and using them), but because idr usage almost always
> requires the caller to manage their own locks, I gave up on
> this approach (as suggested by Tejon -- thank you).
> 
> Changes from v1:
>  - no longer using helper routines
> Changes from v2:
>  - added back missing scsi_host_get() in scsi_host_lookup()
> 
> Lee Duncan (1):
>   SCSI: update hosts module to use idr index management
> 
>  drivers/scsi/hosts.c | 61 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 31 insertions(+), 30 deletions(-)
> 

-- 
Lee Duncan
SUSE Labs
