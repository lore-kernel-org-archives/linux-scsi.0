From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/3] scsi_transport_iscsi: Add stats support for iscsi
 host
Date: Fri, 22 Apr 2016 13:37:20 -0500
Message-ID: <571A6F60.1010400@cs.wisc.edu>
References: <1461332373-18491-1-git-send-email-adheer.chandravanshi@qlogic.com>
 <1461332373-18491-2-git-send-email-adheer.chandravanshi@qlogic.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBZ665G4AKGQEQOQW64A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1461332373-18491-2-git-send-email-adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shyam.sundar-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/22/2016 08:39 AM, adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org wrote:
> From: Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> 
> Add stats for iscsi initiator that will be maintained at iscsi host level
> and will be exported as iscsi_host sysfs attributes.
> 
> Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 51 +++++++++++++++++++++++++++++++++++++
>  include/scsi/iscsi_if.h             | 24 +++++++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 42bca61..076843c 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4253,6 +4253,21 @@ iscsi_host_attr(ipaddress, ISCSI_HOST_PARAM_IPADDRESS);
>  iscsi_host_attr(initiatorname, ISCSI_HOST_PARAM_INITIATOR_NAME);
>  iscsi_host_attr(port_state, ISCSI_HOST_PARAM_PORT_STATE);
>  iscsi_host_attr(port_speed, ISCSI_HOST_PARAM_PORT_SPEED);
> +iscsi_host_attr(login_accept_rsps, ISCSI_HOST_PARAM_LOGIN_ACCEPT_RSPS);
> +iscsi_host_attr(login_other_fails, ISCSI_HOST_PARAM_LOGIN_OTHER_FAILS);
> +iscsi_host_attr(login_authentication_fails,
> +		ISCSI_HOST_PARAM_LOGIN_AUTHENTICATION_FAILS);
> +iscsi_host_attr(login_authorization_fails,
> +		ISCSI_HOST_PARAM_LOGIN_AUTHORIZATION_FAILS);
> +iscsi_host_attr(login_negotiation_fails,
> +		ISCSI_HOST_PARAM_LOGIN_NEGOTIATION_FAILS);
> +iscsi_host_attr(login_redirect_rsps, ISCSI_HOST_PARAM_LOGIN_REDIRECT_RSPS);
> +iscsi_host_attr(logout_normal_rsps, ISCSI_HOST_PARAM_LOGOUT_NORMAL_RSPS);
> +iscsi_host_attr(logout_other_rsps, ISCSI_HOST_PARAM_LOGOUT_OTHER_RSPS);
> +iscsi_host_attr(digest_err, ISCSI_HOST_PARAM_DIGEST_ERR);
> +iscsi_host_attr(timeout_err, ISCSI_HOST_PARAM_TIMEOUT_ERR);
> +iscsi_host_attr(format_err, ISCSI_HOST_PARAM_FORMAT_ERR);
> +iscsi_host_attr(session_fails, ISCSI_HOST_PARAM_SESSION_FAILS);
>  
>  static struct attribute *iscsi_host_attrs[] = {
>  	&dev_attr_host_netdev.attr,
> @@ -4261,6 +4276,18 @@ static struct attribute *iscsi_host_attrs[] = {
>  	&dev_attr_host_initiatorname.attr,
>  	&dev_attr_host_port_state.attr,
>  	&dev_attr_host_port_speed.attr,
> +	&dev_attr_host_login_accept_rsps.attr,
> +	&dev_attr_host_login_other_fails.attr,
> +	&dev_attr_host_login_authentication_fails.attr,
> +	&dev_attr_host_login_authorization_fails.attr,
> +	&dev_attr_host_login_negotiation_fails.attr,
> +	&dev_attr_host_login_redirect_rsps.attr,
> +	&dev_attr_host_logout_normal_rsps.attr,
> +	&dev_attr_host_logout_other_rsps.attr,
> +	&dev_attr_host_digest_err.attr,
> +	&dev_attr_host_timeout_err.attr,
> +	&dev_attr_host_format_err.attr,
> +	&dev_attr_host_session_fails.attr,
>  	NULL,
>  };
>  
> @@ -4284,6 +4311,30 @@ static umode_t iscsi_host_attr_is_visible(struct kobject *kobj,
>  		param = ISCSI_HOST_PARAM_PORT_STATE;
>  	else if (attr == &dev_attr_host_port_speed.attr)
>  		param = ISCSI_HOST_PARAM_PORT_SPEED;
> +	else if (attr == &dev_attr_host_login_accept_rsps.attr)
> +		param = ISCSI_HOST_PARAM_LOGIN_ACCEPT_RSPS;
> +	else if (attr == &dev_attr_host_login_other_fails.attr)
> +		param = ISCSI_HOST_PARAM_LOGIN_OTHER_FAILS;
> +	else if (attr == &dev_attr_host_login_authentication_fails.attr)
> +		param = ISCSI_HOST_PARAM_LOGIN_AUTHENTICATION_FAILS;
> +	else if (attr == &dev_attr_host_login_authorization_fails.attr)
> +		param = ISCSI_HOST_PARAM_LOGIN_AUTHORIZATION_FAILS;
> +	else if (attr == &dev_attr_host_login_negotiation_fails.attr)
> +		param = ISCSI_HOST_PARAM_LOGIN_NEGOTIATION_FAILS;
> +	else if (attr == &dev_attr_host_login_redirect_rsps.attr)
> +		param = ISCSI_HOST_PARAM_LOGIN_REDIRECT_RSPS;
> +	else if (attr == &dev_attr_host_logout_normal_rsps.attr)
> +		param = ISCSI_HOST_PARAM_LOGOUT_NORMAL_RSPS;
> +	else if (attr == &dev_attr_host_logout_other_rsps.attr)
> +		param = ISCSI_HOST_PARAM_LOGOUT_OTHER_RSPS;
> +	else if (attr == &dev_attr_host_digest_err.attr)
> +		param = ISCSI_HOST_PARAM_DIGEST_ERR;
> +	else if (attr == &dev_attr_host_timeout_err.attr)
> +		param = ISCSI_HOST_PARAM_TIMEOUT_ERR;
> +	else if (attr == &dev_attr_host_format_err.attr)
> +		param = ISCSI_HOST_PARAM_FORMAT_ERR;
> +	else if (attr == &dev_attr_host_session_fails.attr)
> +		param = ISCSI_HOST_PARAM_SESSION_FAILS;
>  	else {
>  		WARN_ONCE(1, "Invalid host attr");
>  		return 0;
> diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
> index d66c070..d6a3909 100644
> --- a/include/scsi/iscsi_if.h
> +++ b/include/scsi/iscsi_if.h
> @@ -632,6 +632,18 @@ enum iscsi_host_param {
>  	ISCSI_HOST_PARAM_IPADDRESS,
>  	ISCSI_HOST_PARAM_PORT_STATE,
>  	ISCSI_HOST_PARAM_PORT_SPEED,
> +	ISCSI_HOST_PARAM_LOGIN_ACCEPT_RSPS,
> +	ISCSI_HOST_PARAM_LOGIN_OTHER_FAILS,
> +	ISCSI_HOST_PARAM_LOGIN_AUTHENTICATION_FAILS,
> +	ISCSI_HOST_PARAM_LOGIN_AUTHORIZATION_FAILS,
> +	ISCSI_HOST_PARAM_LOGIN_NEGOTIATION_FAILS,
> +	ISCSI_HOST_PARAM_LOGIN_REDIRECT_RSPS,
> +	ISCSI_HOST_PARAM_LOGOUT_NORMAL_RSPS,
> +	ISCSI_HOST_PARAM_LOGOUT_OTHER_RSPS,
> +	ISCSI_HOST_PARAM_DIGEST_ERR,
> +	ISCSI_HOST_PARAM_TIMEOUT_ERR,
> +	ISCSI_HOST_PARAM_FORMAT_ERR,
> +	ISCSI_HOST_PARAM_SESSION_FAILS,
>  	ISCSI_HOST_PARAM_MAX,
>  };
>  
> @@ -819,6 +831,18 @@ struct iscsi_stats {
>  	/* errors */
>  	uint32_t digest_err;
>  	uint32_t timeout_err;
> +	uint32_t format_err;
> +	uint32_t session_fails;
> +
> +	/* login/logout stats */
> +	uint32_t login_accept_rsps;
> +	uint32_t login_other_fails;
> +	uint32_t login_authentication_fails;
> +	uint32_t login_authorization_fails;
> +	uint32_t login_negotiation_fails;
> +	uint32_t login_redirect_rsps;
> +	uint32_t logout_normal_rsps;
> +	uint32_t logout_other_rsps;
>  

I do not think we can add new fields here because this is passed between
the kernel and userspace.

Also, lets either go with the get stats nl type of approach or say we
are depreciating that and going with sysfs now and the future. Not a mix
based on who is submitting patches.

I can see why the get stats approach is nasty, because it is difficult
to extend. If we want to go sysfs based approach then we should probably
make it more like the other transports where there is a stats dir and a
reset admin file.

Lee and Chris should probably decide how to proceed.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
