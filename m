From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: iscsi: make mutex for target scanning and unbinding per-session
Date: Thu, 10 Nov 2016 17:13:03 -0800
Message-ID: <20161111011303.mod2s5wyymge6byx@straylight.hirudinean.org>
References: <1478542920-24460-1-git-send-email-cleech@redhat.com>
 <58250144.2050009@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBJVWSTAQKGQEL3UCPDY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <58250144.2050009-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 10, 2016 at 05:22:44PM -0600, Mike Christie wrote:
> On 11/07/2016 12:22 PM, Chris Leech wrote:
> > Currently the iSCSI transport class synchronises target scanning and
> > unbinding with a host level mutex.  For multi-session hosts (offloading
> > iSCSI HBAs) connecting to storage arrays that may implement one
> > target-per-lun, this can result in the target scan work for hundreds of
> > sessions being serialized behind a single mutex.  With slow enough
> 
> Does this patch alone help or is there a scsi piece too?
 
I had this tested when working a hung task timeout issue at boot, and
was told that it fixed the issue.  The exact situation may be more
complex, I think it was only 128 sessions which is surprising that it
would hit a 2 minute timeout.  But every backtrace was at this mutex.

> There is also scsi_host->scan_mutex taken in the scsi layer during
> scsi_scan_target, so it is serialized there too. It seems like this
> patch would move that problem one layer down.

I'll take a closer look at that, thanks.
 
> >  
> > @@ -1801,10 +1798,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
> >  
> >  	ISCSI_DBG_TRANS_SESSION(session, "Scanning session\n");
> >  
> > -	shost = iscsi_session_to_shost(session);
> > -	ihost = shost->shost_data;
> > -
> > -	mutex_lock(&ihost->mutex);
> > +	mutex_lock(&session->mutex);
> >  	spin_lock_irqsave(&session->lock, flags);
> >  	if (session->state != ISCSI_SESSION_LOGGED_IN) {
> >  		spin_unlock_irqrestore(&session->lock, flags);
> > @@ -1823,7 +1817,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
> >  	}
> 
> The patch will allow you to remove other sessions while scanning is
> running, so it could still be a good idea.
> 
> I think I originally added the mutex because we did our own loop over a
> list of the host's sessions. If a unbind were to occur at the same time
> then it would be freed while scanning. We changed the user scan to use
> device_for_each_child so that will grab a reference to the session so
> the memory will not be freed now. It now just makes sure that scsi
> target removal and iscsi_remove_session wait until the scan is done.
> 
> On a related note, you can remove all the iscsi_scan_session code. We do
> not use it anymore. qla4xxx used to do async scans in the kernel with
> that code but does not anymore. In the future someone will also not ask
> why we grab the mutex around one scan and not the other.
> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
