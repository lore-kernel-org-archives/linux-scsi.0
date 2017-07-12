From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Add login_keys_workaround attribute for
 non RFC initiators
Date: Tue, 11 Jul 2017 17:32:54 -0700
Message-ID: <1499819574.30046.6.camel@haakon3.daterainc.com>
References: <1499466285-9907-1-git-send-email-nab@linux-iscsi.org>
         <1499816315.2586.51.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499816315.2586.51.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "robert@leblancnet.us" <robert@leblancnet.us>, "arun.easi@cavium.com" <arun.easi@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-07-11 at 23:38 +0000, Bart Van Assche wrote:
> On Fri, 2017-07-07 at 22:24 +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch re-introduces part of a long standing login workaround that
> > was recently dropped by:
> > 
> >   commit 1c99de981f30b3e7868b8d20ce5479fa1c0fea46
> >   Author: Nicholas Bellinger <nab@linux-iscsi.org>
> >   Date:   Sun Apr 2 13:36:44 2017 -0700
> > 
> >       iscsi-target: Drop work-around for legacy GlobalSAN initiator
> > 
> > Namely, the workaround for FirstBurstLength ended up being required by
> > Mellanox Flexboot PXE boot ROMs as reported by Robert.
> > 
> > So this patch re-adds the work-around for FirstBurstLength within
> > iscsi_check_proposer_for_optional_reply(), and makes the key optional
> > to respond when the initiator does not propose, nor respond to it.
> > 
> > Also as requested by Arun, this patch introduces a new TPG attribute
> > named 'login_keys_workaround' that controls the use of both the
> > FirstBurstLength workaround, as well as the two other existing
> > workarounds for gPXE iSCSI boot client.
> > 
> > By default, the workaround is enabled with login_keys_workaround=1,
> > since Mellanox FlexBoot requires it, and Arun has verified the Qlogic
> > MSFT initiator already proposes FirstBurstLength, so it's uneffected
> > by this re-adding this part of the original work-around.
> 
> Hello Nick,
> 
> The new configfs attribute ("login_keys_workaround") may confuse users - for
> someone who has not followed this e-mail thread it can take a long time
> before they figure out that they need to set this configfs attribute.

It's enabled by default, so there is nothing a user has to explicitly
change in order all hosts to 'just work'.

The only reason the attribute was added was by request of Arun, so if
some future initiator doesn't proposed the keys controlled by the
work-around, and still attempts to respond they can at least get
something working w/o code change.

>  Have
> you considered to let the iSCSI target driver figure out whether or not that
> variable has to be set, e.g. by looking up the initiator IQN in a list?
> 

Given InitiatorName is end user configurable, trying to do a workaround
based on IQN regexs is error prone, at best.

Also, since the FirstBurstLength work-around this patch re-adds had
already been in place for the better part of 8 years, the risk of
interopt issues is almost non existent.
