From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: QoS for iSCSI target?
Date: Thu, 31 Mar 2016 00:05:29 -0700
Message-ID: <1459407929.31390.89.camel@haakon3.risingtidesystems.com>
References: <56E1F419.5070005@windriver.com>
	 <20160311073018.GA23379@infradead.org>
	 <1457682341.4062.74.camel@haakon3.risingtidesystems.com>
	 <56E98E5F.9030107@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38711 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbcCaHFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 03:05:31 -0400
In-Reply-To: <56E98E5F.9030107@windriver.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <chris.friesen@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Wed, 2016-03-16 at 10:48 -0600, Chris Friesen wrote:
> On 03/11/2016 01:45 AM, Nicholas A. Bellinger wrote:
> > On Thu, 2016-03-10 at 23:30 -0800, Christoph Hellwig wrote:
> >> On Thu, Mar 10, 2016 at 04:24:25PM -0600, Chris Friesen wrote:
> >>> Hi,
> >>>
> >>> I'm looking for information on whether the iSCSI target in the kernel offers
> >>> any way to do QoS between traffic driven by different initiators.
> >>>
> >>> I'm trying to make sure that one initiator can't do a denial-of-service
> >>> attack against others.
> >>>
> >>> Does the kernel target have this sort of thing built-in, or do I need to
> >>> look at network traffic-shaping to achieve this?
> >>
> >> It doesn't right now, but it shouldn't be hard to integrate it with
> >> blk cgroups.
> >
> > For iscsi-target application QoS, the per session command sequence
> > number window depth (CmdSN) exists to enforce per InitiatorName limits
> > via TPG default_cmdsn_depth + se_node_acl->queue_depth configfs
> > attributes.
> >
> > Note these values can be changed on the fly for iscsi-target using
> > explicit se_node_acl->acl_group, but currently require a se_session
> > reinstatement event for updated ExpCmdSN + MaxCmdSN to take effect.
> 
> On a slightly different note, is there any way to throttle or limit the overall 
> bandwidth consumed by the iSCSI target in the kernel?  I'd like to ensure that 
> the iSCSI traffic doesn't completely swamp the host accesses to the same block 
> device.
> 
> I suppose I could do networking-based traffic shaping, but are there any 
> controls in the block IO subsystem?
> 

On a individual block_device backend basis, block cgroups is the
preferred method for doing this.

Note that any rate limiting imposed by block cgroups is subject to the
current se_node_acl->queue_depth enforced across all LUNs within a given
iscsi session.

