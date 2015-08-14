From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: fix init_vp_index() for reloading
 hv_netvsc
Date: Fri, 14 Aug 2015 01:32:04 +0000
Message-ID: <BY2PR0301MB165407BC397C346F69A796B5A07C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1439510823-16280-1-git-send-email-kys@microsoft.com>
 <1439507350.8421.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1439507350.8421.13.camel@HansenPartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, August 13, 2015 4:09 PM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> Dexuan Cui <decui@microsoft.com>
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: fix init_vp_index() for reloading
> hv_netvsc
> 
> On Thu, 2015-08-13 at 17:07 -0700, K. Y. Srinivasan wrote:
> > From: Dexuan Cui <decui@microsoft.com>
> >
> > This fixes the recent commit 3b71107d73b16074afa7658f3f0fcf837aabfe24:
> 
> Which tree is this in?  upstream linus is giving me bad object on that
> id.

Greg's char-misc tree.
> 
> 
> > Drivers: hv: vmbus: Further improve CPU affiliation logic
> >
> > Without the fix, reloading hv_netvsc hangs the guest.
> 
> The reason for looking for the commit id was to see if cc to stable was
> necessary, is it?
The offending patch was committed on August 5th and cc to stable was not necessary.

K. Y
> 
> James
> 
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/channel_mgmt.c |   17 +++++++++++++++++
> >  1 files changed, 17 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> > index 3ab4753..8a4105c 100644
> > --- a/drivers/hv/channel_mgmt.c
> > +++ b/drivers/hv/channel_mgmt.c
> > @@ -204,6 +204,8 @@ void hv_process_channel_removal(struct
> vmbus_channel *channel, u32 relid)
> >  		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
> >  		list_del(&channel->listentry);
> >  		spin_unlock_irqrestore(&vmbus_connection.channel_lock,
> flags);
> > +
> > +		primary_channel = channel;
> >  	} else {
> >  		primary_channel = channel->primary_channel;
> >  		spin_lock_irqsave(&primary_channel->lock, flags);
> > @@ -211,6 +213,14 @@ void hv_process_channel_removal(struct
> vmbus_channel *channel, u32 relid)
> >  		primary_channel->num_sc--;
> >  		spin_unlock_irqrestore(&primary_channel->lock, flags);
> >  	}
> > +
> > +	/*
> > +	 * We need to free the bit for init_vp_index() to work in the case
> > +	 * of sub-channel, when we reload drivers like hv_netvsc.
> > +	 */
> > +	cpumask_clear_cpu(channel->target_cpu,
> > +			  &primary_channel->alloced_cpus_in_node);
> > +
> >  	free_channel(channel);
> >  }
> >
> > @@ -457,6 +467,13 @@ static void init_vp_index(struct vmbus_channel
> *channel, const uuid_le *type_gui
> >  			continue;
> >  		}
> >
> > +		/*
> > +		 * NOTE: in the case of sub-channel, we clear the sub-channel
> > +		 * related bit(s) in primary->alloced_cpus_in_node in
> > +		 * hv_process_channel_removal(), so when we reload
> drivers
> > +		 * like hv_netvsc in SMP guest, here we're able to re-allocate
> > +		 * bit from primary->alloced_cpus_in_node.
> > +		 */
> >  		if (!cpumask_test_cpu(cur_cpu,
> >  				&primary->alloced_cpus_in_node)) {
> >  			cpumask_set_cpu(cur_cpu,
> 
> 
