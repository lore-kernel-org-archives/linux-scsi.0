From: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] libiscsi: Fix NULL pointer dereference in
 iscsi_eh_session_reset
Date: Mon, 26 Nov 2018 16:57:59 -0800
Message-ID: <96ce0aea-42a3-fec2-2ba8-cf1076e2d0da@suse.com>
References: <1542763365-22253-1-git-send-email-fred.herard@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBD54HHNYIIIJZLPS34CRUBHXWAWHG-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1542763365-22253-1-git-send-email-fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/20/18 5:22 PM, fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
> From: Fred Herard <fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> This commit addresses NULL pointer dereference in iscsi_eh_session_reset.
> Reference should not be made to session->leadconn when session->state
> is set to ISCSI_STATE_TERMINATE.
> 
> Signed-off-by: Fred Herard <fred.herard-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/libiscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 088e903..21d2a6d 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2426,8 +2426,8 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>  failed:
>  		ISCSI_DBG_EH(session,
>  			     "failing session reset: Could not log back into "
> -			     "%s, %s [age %d]\n", session->targetname,
> -			     conn->persistent_address, session->age);
> +			     "%s [age %d]\n", session->targetname,
> +			     session->age);
>  		spin_unlock_bh(&session->frwd_lock);
>  		mutex_unlock(&session->eh_mutex);
>  		return FAILED;
> 

Reviewed-by: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
