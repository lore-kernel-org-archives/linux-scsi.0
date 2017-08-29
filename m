From: Chris Leech <cleech@redhat.com>
Subject: Re: [Patch v2 1/2] libiscsi: Fix use-after-free race during
 iscsi_session_teardown
Date: Tue, 29 Aug 2017 11:29:14 -0700
Message-ID: <20170829182914.5oza32ohjj4lua6j@straylight.hirudinean.org>
References: <20170713161122.89375-1-khazhy@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170713161122.89375-1-khazhy@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 'Khazhismel Kumykov' via open-iscsi <open-iscsi@googlegroups.com>
Cc: lduncan@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>
List-Id: linux-scsi@vger.kernel.org


Looks good to me, fixes up the code given that the comment there about
calling iscsi_remove_session wasn't being followed.

Thanks

Acked-by: Chris Leech <cleech@redhat.com>

On Thu, Jul 13, 2017 at 09:11:21AM -0700, 'Khazhismel Kumykov' via open-iscsi wrote:
> Session attributes exposed through sysfs were freed before the device
> was destroyed, resulting in a potential use-after-free. Free these
> attributes after removing the device.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> ---
>  drivers/scsi/libiscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 42381adf0769..8696a51a5a0c 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2851,9 +2851,6 @@ EXPORT_SYMBOL_GPL(iscsi_session_setup);
>  /**
>   * iscsi_session_teardown - destroy session, host, and cls_session
>   * @cls_session: iscsi session
> - *
> - * The driver must have called iscsi_remove_session before
> - * calling this.
>   */
>  void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
>  {
> @@ -2863,6 +2860,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
>  
>  	iscsi_pool_free(&session->cmdpool);
>  
> +	iscsi_remove_session(cls_session);
> +
>  	kfree(session->password);
>  	kfree(session->password_in);
>  	kfree(session->username);
> @@ -2877,7 +2876,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
>  	kfree(session->portal_type);
>  	kfree(session->discovery_parent_type);
>  
> -	iscsi_destroy_session(cls_session);
> +	iscsi_free_session(cls_session);
> +
>  	iscsi_host_dec_session_cnt(shost);
>  	module_put(owner);
>  }
> -- 
> 2.13.2.932.g7449e964c-goog
> 
> -- 
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe@googlegroups.com.
> To post to this group, send email to open-iscsi@googlegroups.com.
> Visit this group at https://groups.google.com/group/open-iscsi.
> For more options, visit https://groups.google.com/d/optout.
