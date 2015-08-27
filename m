From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH 2/2] mpt3sas: Refcount fw_events and fix unsafe list usage
Date: Wed, 26 Aug 2015 19:06:32 -0700
Message-ID: <20150827020632.GA12485@mail.thefacebook.com>
References: <1440562184-23945-1-git-send-email-nab@daterainc.com>
 <1440562184-23945-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440562184-23945-3-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 08/26 at 04:09 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> The fw_event_work struct is concurrently referenced at shutdown, so
> add a refcount to protect it, and refactor the code to use it.
> 
> Additionally, refactor _scsih_fw_event_cleanup_queue() such that it
> no longer iterates over the list without holding the lock, since
> _firmware_event_work() concurrently deletes items from the list.
> 
> This patch is a port of Calvin's PATCH-v4 for mpt2sas code.
> 
> Cc: Calvin Owens <calvinowens@fb.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> Cc: MPT-FusionLinux.pdl <MPT-FusionLinux.pdl@avagotech.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 116 ++++++++++++++++++++++++++++-------
>  1 file changed, 94 insertions(+), 22 deletions(-)

Looks good, thanks again for this.

Reviewed-by: Calvin Owens <calvinowens@fb.com>
