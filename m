From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: scsi_transport_fc: Fix a bug in the error
 handling function
Date: Fri, 08 Jan 2016 12:26:36 -0800
Message-ID: <1452284796.2297.25.camel@HansenPartnership.com>
References: <1452213645-18889-1-git-send-email-kys@microsoft.com>
	 <1452210511.15259.38.camel@HansenPartnership.com>
	 <BY2PR0301MB1654D797E802F3CF5355942FA0F60@BY2PR0301MB1654.namprd03.prod.outlook.com>
	 <1452280852.2297.17.camel@HansenPartnership.com>
	 <BY2PR0301MB1654941121DDC4AD7EA043A4A0F60@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <BY2PR0301MB1654941121DDC4AD7EA043A4A0F60@BY2PR0301MB1654.namprd03.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-01-08 at 20:12 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com
> > ]
> > Sent: Friday, January 8, 2016 11:21 AM
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
> > On Fri, 2016-01-08 at 18:58 +0000, KY Srinivasan wrote:
> > > 
> > > > -----Original Message-----
> > > > From: James Bottomley
> > [mailto:James.Bottomley@HansenPartnership.com
> > > > ]
> > > > Sent: Thursday, January 7, 2016 3:49 PM
> > > > To: KY Srinivasan <kys@microsoft.com>; 
> > > > gregkh@linuxfoundation.org;
> > > > linux-
> > > > kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > > ohering@suse.com;
> > > > jbottomley@parallels.com; hch@infradead.org;
> > > > linux-scsi@vger.kernel.org;
> > > > apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> > > > martin.petersen@oracle.com; hare@suse.de
> > > > Cc: stable@vger.kernel.org
> > > > Subject: Re: [PATCH 1/1] scsi: scsi_transport_fc: Fix a bug in
> > > > the
> > > > error
> > > > handling function
> > > > 
> > > > On Thu, 2016-01-07 at 16:40 -0800, K. Y. Srinivasan wrote:
> > > > > The macro startget_to_rport() can return NULL; handle that
> > > > > case
> > > > > properly.
> > > > 
> > > > OK, can we unwind why you think you could possibly need this? 
> > > >  It
> > > > would
> > > > mean that fc_timed_out was called for a non-FC device, which
> > > > was
> > > > thought to be an impossibility when the fc transport class was
> > > > designed.
> > > 
> > > As you know, on Hyper-V, FC devices are handled exactly like
> > > normal
> > > scsi devices and the only additional information that is provided
> > > for
> > > FC devices is the WWN for port and node. Till recently, I was not
> > > publishing the WWN in the guest and so I was not even using the
> > > FC
> > > transport. Recently, I implemented support for publishing the WWN
> > > in
> > > the guest and for that I am using the FC transport for FC hosts.
> > > When
> > > an FC LUN is dynamically removed, sometimes I see the timeout
> > > occurri
> > > ng and since there is no rport associated with these devices I am
> > > hitting the issue this patch is addressing. I could have
> > > addressed
> > > this problem by establishing a storvsc specific time out function
> > > even for FC devices - the same timeout function that I currently
> > > use
> > > for scsi devices -  storvsc_eh_timed_out(). I chose to instead
> > > fix
> > > the fc_timed_out() function since the code was not handling a
> > > possible condition.
> > 
> > OK, so the specific problem is that the device is partly torn down
> > when
> > the timeout fires?  I'm having a hard time seeing how we get a null
> > rport in that case.  The starget_to_rport() can only return NULL if
> > the
> > parent isn't an rport ... that shouldn't depend on the state of the
> > FC
> > device because the parent is torn down after the child.
> 
> In our case, the parent is not an rport since I don't invoke 
> fc_remote_port_add() and so I do get a NULL value from the
> starget_to_rport().

OK, so it's nothing to do with teardown? I'm going to need the FC
people to comment on this.  The transport class was apparently designed
to allow use without rports.  However, there are several places where
we assume rports are present:  The times out and the port block
interface ... I'm betting all current users are rport otherwise we
would have spotted this problem sooner.

> > In any case, returning BLK_EH_RESET_TIMER will cause all sorts of
> > problems because it resets the timer to fire again for the device.
> >  What you want is something to return BLK_EH_HANDLED which will
> > just
> > complete the request ... probably at a generic level, since this
> > doesn't sound to be specific to FC.
> 
> On Hyper-V, the host implements a variety of recovery strategies and 
> for that reason, the  eh_timed_out handler for standard scsi devices 
> will effectively have infinite timeout value: storvsc_eh_timed_out() 
> just resets the timer. This is the behavior I wanted for the FC
> devices as well.

All the world isn't hyper-v.  If we change something in the generic
interface, it needs to work for everyone.  To me it looks like
fc_timed_out is designed to support the port block function.  If we
assume port block is not supported for non-rport devices, then
fc_timed_out should be returning BLK_EH_NOT_HANDLED for the non-rport
case.

James
