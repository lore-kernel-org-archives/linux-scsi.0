From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: QoS for iSCSI target?
Date: Thu, 10 Mar 2016 23:45:41 -0800
Message-ID: <1457682341.4062.74.camel@haakon3.risingtidesystems.com>
References: <56E1F419.5070005@windriver.com>
	 <20160311073018.GA23379@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160311073018.GA23379@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Friesen <chris.friesen@windriver.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-03-10 at 23:30 -0800, Christoph Hellwig wrote:
> On Thu, Mar 10, 2016 at 04:24:25PM -0600, Chris Friesen wrote:
> > Hi,
> > 
> > I'm looking for information on whether the iSCSI target in the kernel offers
> > any way to do QoS between traffic driven by different initiators.
> > 
> > I'm trying to make sure that one initiator can't do a denial-of-service
> > attack against others.
> > 
> > Does the kernel target have this sort of thing built-in, or do I need to
> > look at network traffic-shaping to achieve this?
> 
> It doesn't right now, but it shouldn't be hard to integrate it with
> blk cgroups.

For iscsi-target application QoS, the per session command sequence
number window depth (CmdSN) exists to enforce per InitiatorName limits
via TPG default_cmdsn_depth + se_node_acl->queue_depth configfs
attributes.

Note these values can be changed on the fly for iscsi-target using
explicit se_node_acl->acl_group, but currently require a se_session
reinstatement event for updated ExpCmdSN + MaxCmdSN to take effect.
