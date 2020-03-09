Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFFCC10F25
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 22:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0338A2253D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 22:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XRNvBmtO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgCIWgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 18:36:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726536AbgCIWgu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 18:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583793409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wq21Ges+zLsEL9GL1rfmfUjntp0jRUks71GtfkYmpog=;
        b=XRNvBmtOQ7iyOJFWV7iVc0x121wmMKdaEpfSzGBNnF6cEhkFdewFhRFWZymQ/q6Uyibfve
        RzJ9XHXBO4YCvTMLgDQjI8NJFXrUoscsNDj0zOPn41U4B08xOL3v0lIDIprANyyxhUDbIc
        mmq8ysRYRgGNwvz9JrjV9QhfqDFG1E0=
Received: from mail-yw1-f71.google.com (mail-yw1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-uKG-kMFbNGmgbigF2MCzAw-1; Mon, 09 Mar 2020 18:36:48 -0400
X-MC-Unique: uKG-kMFbNGmgbigF2MCzAw-1
Received: by mail-yw1-f71.google.com with SMTP id 84so10470995ywr.4
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2020 15:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wq21Ges+zLsEL9GL1rfmfUjntp0jRUks71GtfkYmpog=;
        b=tu8U/t4YghcOO6Qes0z9oCyo4TWENiGcgU9ey3M3I81XSdkB4emDQ1jXFkE5cedINl
         SeX4GaudyLssUOuX+bWK0SOzr29t2VZCm1oDOUoxTsOa1ZJpQE5Znttwh3myWkyM47UD
         OUUDgB68B/rafeidfc57qYa2NH+4VTWNwG+JhHuTGzHAQdsCq1v8D+NqdScHPVf+WwCx
         D1tW0Z+CpQDQU90sY0SCSyAlcbFwfKe1AGkFUUEfKyX1+OA3gZtMfteAi3mMmUgFfT+n
         ObVoRw5oMq5i8nVkRqPn22q1fMCwMSTFr8h8Y+xK7Gw+8zlNuVhCRpAXDnvRxmRc4Pcy
         42DA==
X-Gm-Message-State: ANhLgQ3EumF5wIen6BSgNcri+zflDqdFOiTSO3+nZrGTZcUi95q7c4gt
        +2uSAzyf/DExFQ636TRSow4Vq+m7RwUppPx0yhwJVf98bPZIy2/EbtcqL0ETCU7OPo0BmG5rOdg
        qupTnGsuPRb9WiQ6unkpk5g==
X-Received: by 2002:a25:1202:: with SMTP id 2mr21336667ybs.477.1583793407322;
        Mon, 09 Mar 2020 15:36:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vusV6OujgEGxjJefi+wQE8ZiTVqCGw6+QU4yEJEwDP9BUJuULnfwwacP+C1KofK5aCKIbIOgA==
X-Received: by 2002:a25:1202:: with SMTP id 2mr21336611ybs.477.1583793406726;
        Mon, 09 Mar 2020 15:36:46 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:2941:4bf6:8ce7:6ce9])
        by smtp.gmail.com with ESMTPSA id 72sm307658ywd.59.2020.03.09.15.36.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Mar 2020 15:36:46 -0700 (PDT)
Message-ID: <bc66f9107587c9c42d222a8cc3e551189706e396.camel@redhat.com>
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline
 messages
From:   Laurence Oberman <loberman@redhat.com>
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Date:   Mon, 09 Mar 2020 18:36:44 -0400
In-Reply-To: <20200309181416.10665-1-emilne@redhat.com>
References: <20200309181416.10665-1-emilne@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-03-09 at 14:14 -0400, Ewan D. Milne wrote:
> Large queues of I/O to offline devices that are eventually
> submitted when devices are unblocked result in a many repeated
> "rejecting I/O to offline device" messages.  These messages
> can fill up the dmesg buffer in crash dumps so no useful
> prior messages remain.  In addition, if a serial console
> is used, the flood of messages can cause a hard lockup in
> the console code.
> 
> Introduce a flag indicating the message has already been logged
> for the device, and reset the flag when scsi_device_set_state()
> changes the device state.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c    | 8 ++++++--
>  include/scsi/scsi_device.h | 2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41..d3a6d97 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device
> *sdev, struct request *req)
>  		 * commands.  The device must be brought online
>  		 * before trying any recovery commands.
>  		 */
> -		sdev_printk(KERN_ERR, sdev,
> -			    "rejecting I/O to offline device\n");
> +		if (!sdev->offline_already) {
> +			sdev->offline_already = 1;
> +			sdev_printk(KERN_ERR, sdev,
> +				    "rejecting I/O to offline
> device\n");
> +		}
>  		return BLK_STS_IOERR;
>  	case SDEV_DEL:
>  		/*
> @@ -2340,6 +2343,7 @@ scsi_device_set_state(struct scsi_device *sdev,
> enum scsi_device_state state)
>  		break;
>  
>  	}
> +	sdev->offline_already = 0;
>  	sdev->sdev_state = state;
>  	return 0;
>  
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f8312a3..72987a0 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -204,6 +204,8 @@ struct scsi_device {
>  	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for
> WRITE SAME */
>  	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend
> at device
>  					 * creation time */
> +	unsigned offline_already:1;	/* Device offline message
> logged */
> +
>  	atomic_t disk_events_disable_depth; /* disable depth for disk
> events */
>  
>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /*
> supported events */

I tested this on a customer issue.
If its accepted please use

Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com> 


