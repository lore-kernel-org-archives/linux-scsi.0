From: Mike Christie <mchristi@redhat.com>
Subject: Re: iscsi: make mutex for target scanning and unbinding per-session
Date: Thu, 10 Nov 2016 17:22:44 -0600
Message-ID: <58250144.2050009@redhat.com>
References: <1478542920-24460-1-git-send-email-cleech@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755952AbcKJXWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 18:22:47 -0500
In-Reply-To: <1478542920-24460-1-git-send-email-cleech@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, lduncan@suse.com

On 11/07/2016 12:22 PM, Chris Leech wrote:
> Currently the iSCSI transport class synchronises target scanning and
> unbinding with a host level mutex.  For multi-session hosts (offloading
> iSCSI HBAs) connecting to storage arrays that may implement one
> target-per-lun, this can result in the target scan work for hundreds of
> sessions being serialized behind a single mutex.  With slow enough

Does this patch alone help or is there a scsi piece too?

There is also scsi_host->scan_mutex taken in the scsi layer during
scsi_scan_target, so it is serialized there too. It seems like this
patch would move that problem one layer down.

>  
> @@ -1801,10 +1798,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
>  
>  	ISCSI_DBG_TRANS_SESSION(session, "Scanning session\n");
>  
> -	shost = iscsi_session_to_shost(session);
> -	ihost = shost->shost_data;
> -
> -	mutex_lock(&ihost->mutex);
> +	mutex_lock(&session->mutex);
>  	spin_lock_irqsave(&session->lock, flags);
>  	if (session->state != ISCSI_SESSION_LOGGED_IN) {
>  		spin_unlock_irqrestore(&session->lock, flags);
> @@ -1823,7 +1817,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
>  	}

The patch will allow you to remove other sessions while scanning is
running, so it could still be a good idea.

I think I originally added the mutex because we did our own loop over a
list of the host's sessions. If a unbind were to occur at the same time
then it would be freed while scanning. We changed the user scan to use
device_for_each_child so that will grab a reference to the session so
the memory will not be freed now. It now just makes sure that scsi
target removal and iscsi_remove_session wait until the scan is done.

On a related note, you can remove all the iscsi_scan_session code. We do
not use it anymore. qla4xxx used to do async scans in the kernel with
that code but does not anymore. In the future someone will also not ask
why we grab the mutex around one scan and not the other.
