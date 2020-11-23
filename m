Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6726FC2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 101E720727
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 19:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJBG/35z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgKWTsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:48:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729809AbgKWTsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 14:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606160882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AgzMIFao/YbnZhP4AkImGuWFBkuLt+T46648V6M2VbI=;
        b=fJBG/35zp8iUJUd4GGC1ITsl+J4r+htSlO2hFlub/r92PpiMogEPF0y+dKIsFKWHRagGNn
        6cOTU0fef+JqI61Ma7kXQNCjIEKVZXnyxz2rP1ynfD8g+kt0uHT4ge94YTcIn4EUrI4pr2
        gE2tY5+ZJwP7Mt3MANAGL6qbJKBXgPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-o7ROU2iyNPqO6bg8-e2oUA-1; Mon, 23 Nov 2020 14:47:57 -0500
X-MC-Unique: o7ROU2iyNPqO6bg8-e2oUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5245BBF0D;
        Mon, 23 Nov 2020 19:47:47 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CABDD5D9EF;
        Mon, 23 Nov 2020 19:47:45 +0000 (UTC)
Message-ID: <59b3b1c6d7d25a8d8b9715dcbcd44fdf0ceb0209.camel@redhat.com>
Subject: Re: [PATCH v7 4/5] scsi_transport_fc: Added store fucntionality to
 set the rport port_state using sysfs
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, mkumar@redhat.com
Date:   Mon, 23 Nov 2020 14:47:45 -0500
In-Reply-To: <1605070685-20945-5-git-send-email-muneendra.kumar@broadcom.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
         <1605070685-20945-5-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-11 at 10:28 +0530, Muneendra wrote:
> Added a store functionality to set rport port_state using sysfs
> under  fc_remote_ports/rport-*/port_state
> 
> With this functionality the user can move the port_state from
> Marginal -> Online and Online->Marginal.
> 
> On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> Below is the interface provided to set the port state to Marginal
> and Online.
> 
> echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
> echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> No change
> 
> v6:
> No change
> 
> v5:
> No change
> 
> v4:
> Addressed the error reported by kernel test robot
> Removed the code needed to traverse all the devices under rport
> to set/clear SCMD_NORETRIES_ABORT
> Removed unncessary comments.
> Return the error values on failure while setting the port_state
> 
> v3:
> Removed the port_state from starget attributes.
> Enabled the store functionality for port_state under remote port.
> used the starget_for_each_device to traverse around all the devices
> under rport
> 
> v2:
> Changed from a noretries_abort attribute under fc_transport/target*/
> to
> port_state for changing the port_state to a marginal state
> ---
>  drivers/scsi/scsi_transport_fc.c | 56
> ++++++++++++++++++++++++++++++--
>  1 file changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c
> b/drivers/scsi/scsi_transport_fc.c
> index ffd25195ae62..d378ca4a60fe 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -1238,7 +1238,59 @@ show_fc_rport_roles (struct device *dev,
> struct device_attribute *attr,
>  static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
>  		show_fc_rport_roles, NULL);
>  
> -fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
> +static ssize_t fc_rport_set_marginal_state(struct device *dev,
> +						struct device_attribute
> *attr,
> +						const char *buf, size_t
> count)
> +{
> +	struct fc_rport *rport = transport_class_to_rport(dev);
> +	enum fc_port_state port_state;
> +	int ret = 0;
> +
> +	ret = get_fc_port_state_match(buf, &port_state);
> +	if (ret)
> +		return -EINVAL;
> +	if (port_state == FC_PORTSTATE_MARGINAL) {
> +		/*
> +		 * Change the state to marginal only if the
> +		 * current rport state is Online
> +		 * Allow only Online->marginal
> +		 */
> +		if (rport->port_state == FC_PORTSTATE_ONLINE)
> +			rport->port_state = port_state;
> +		else
> +			return -EINVAL;
> +	} else if (port_state == FC_PORTSTATE_ONLINE) {
> +		/*
> +		 * Change the state to Online only if the
> +		 * current rport state is Marginal
> +		 * Allow only  MArginal->Online
> +		 */
> +		if (rport->port_state == FC_PORTSTATE_MARGINAL)
> +			rport->port_state = port_state;
> +		else
> +			return -EINVAL;
> +	} else
> +		return -EINVAL;
> +	return count;
> +}
> +
> +static ssize_t
> +show_fc_rport_port_state(struct device *dev,
> +				struct device_attribute *attr, char
> *buf)
> +{
> +	const char *name;
> +	struct fc_rport *rport = transport_class_to_rport(dev);
> +
> +	name = get_fc_port_state_name(rport->port_state);
> +	if (!name)
> +		return -EINVAL;
> +
> +	return snprintf(buf, 20, "%s\n", name);
> +}
> +
> +static FC_DEVICE_ATTR(rport, port_state, 0444 | 0200,
> +			show_fc_rport_port_state,
> fc_rport_set_marginal_state);
> +
>  fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
>  
>  /*
> @@ -2681,7 +2733,7 @@ fc_attach_transport(struct fc_function_template
> *ft)
>  	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
>  	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
>  	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
> -	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
> +	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
>  	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
>  	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
>  

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


