From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: scsi_transport_fc: Fix a bug in the error
 handling function
Date: Fri, 08 Jan 2016 11:20:52 -0800
Message-ID: <1452280852.2297.17.camel@HansenPartnership.com>
References: <1452213645-18889-1-git-send-email-kys@microsoft.com>
	 <1452210511.15259.38.camel@HansenPartnership.com>
	 <BY2PR0301MB1654D797E802F3CF5355942FA0F60@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <BY2PR0301MB1654D797E802F3CF5355942FA0F60@BY2PR0301MB1654.namprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-01-08 at 18:58 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com
> > ]
> > Sent: Thursday, January 7, 2016 3:49 PM
> > To: KY Srinivasan <kys@microsoft.com>; gregkh@linuxfoundation.org;
> > linux-
> > kernel@vger.kernel.org; devel@linuxdriverproject.org; 
> > ohering@suse.com;
> > jbottomley@parallels.com; hch@infradead.org; 
> > linux-scsi@vger.kernel.org;
> > apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> > martin.petersen@oracle.com; hare@suse.de
> > Cc: stable@vger.kernel.org
> > Subject: Re: [PATCH 1/1] scsi: scsi_transport_fc: Fix a bug in the
> > error
> > handling function
> > 
> > On Thu, 2016-01-07 at 16:40 -0800, K. Y. Srinivasan wrote:
> > > The macro startget_to_rport() can return NULL; handle that case
> > > properly.
> > 
> > OK, can we unwind why you think you could possibly need this?  It
> > would
> > mean that fc_timed_out was called for a non-FC device, which was
> > thought to be an impossibility when the fc transport class was
> > designed.
> 
> As you know, on Hyper-V, FC devices are handled exactly like normal 
> scsi devices and the only additional information that is provided for 
> FC devices is the WWN for port and node. Till recently, I was not 
> publishing the WWN in the guest and so I was not even using the FC 
> transport. Recently, I implemented support for publishing the WWN in 
> the guest and for that I am using the FC transport for FC hosts. When 
> an FC LUN is dynamically removed, sometimes I see the timeout occurri
> ng and since there is no rport associated with these devices I am 
> hitting the issue this patch is addressing. I could have addressed 
> this problem by establishing a storvsc specific time out function 
> even for FC devices - the same timeout function that I currently use 
> for scsi devices -  storvsc_eh_timed_out(). I chose to instead fix 
> the fc_timed_out() function since the code was not handling a
> possible condition.

OK, so the specific problem is that the device is partly torn down when
the timeout fires?  I'm having a hard time seeing how we get a null
rport in that case.  The starget_to_rport() can only return NULL if the
parent isn't an rport ... that shouldn't depend on the state of the FC
device because the parent is torn down after the child.

In any case, returning BLK_EH_RESET_TIMER will cause all sorts of
problems because it resets the timer to fire again for the device. 
 What you want is something to return BLK_EH_HANDLED which will just
complete the request ... probably at a generic level, since this
doesn't sound to be specific to FC.

Something like the below ... assuming the teardown issue is the real
problem.

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 984ddcb..3c514c6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -273,6 +273,10 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 	struct Scsi_Host *host = scmd->device->host;
 
+	/* timeout for an already dead device, just kill the request */
+	if (scmd->device->sdev_state == SDEV_DEL)
+		return BLK_EH_HANDLED;
+
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
