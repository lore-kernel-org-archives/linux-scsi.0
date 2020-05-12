Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D00FC54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 08:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE992082E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 08:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589272131;
	bh=xic9Wa4tqu8MQopJT18weegGL8B8WOphD+KWExBuHy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uLo6EQUCB32m5eNooe6kjFB7syMvlGgkyT8Ntt5szq3ar3ozjsvHga6YglucVzqMu
	 pi9gmzlaWZbm+9ajbXNLqUW4BJMiXx0iFJKd6B1PhhAuLypWl6MgBod6lroD8tF5Qt
	 NNbsJoNwlFoe7GtZl09FTyDpze00CWFSgGjZI1EI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgELI2u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 04:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgELI2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 04:28:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7E5206A3;
        Tue, 12 May 2020 08:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589272129;
        bh=xic9Wa4tqu8MQopJT18weegGL8B8WOphD+KWExBuHy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Thw2OguQ0Roa5JQgz17PW9AC4NeRdMJaeQKNU47bRqCeeMWOAHVzbwtpfTCQ+2LTE
         h8nyzVDOoQIjIExpo+8oPNg4rCjJOCSLUH/JFTJPRe3LLgAfP75JSvBEOQbWDSNMCd
         pegQ4oNR5bYrjNJoJvu/pMSWzoZV2Fg4yTbflL6s=
Date:   Tue, 12 May 2020 07:54:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Christie <mchristi@redhat.com>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/15] target: add sysfs support
Message-ID: <20200512055442.GA3505885@kroah.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-12-mchristi@redhat.com>
 <20200511063002.GA1260895@kroah.com>
 <aad8269e-f9ee-ebc7-6e54-aa4b5b6021b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aad8269e-f9ee-ebc7-6e54-aa4b5b6021b8@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 11, 2020 at 12:15:12PM -0500, Mike Christie wrote:
> On 5/11/20 1:30 AM, Greg Kroah-Hartman wrote:
> > On Sun, May 10, 2020 at 04:57:40PM -0500, Mike Christie wrote:
> >> These next two patches add a sysfs interface that reports the target
> >> layer's I_T nexuses/sessions. For the non-SCSI people cc'd, this just means
> >> we are reporting a server's connections to remote clients.
> >>
> >> This patch adds the upper level dirs which shows/organizes our local port
> >> (tpgts below) and the connection (session below). The next patch will then
> >> add the dirs/files for each connection/session which exports info like
> >> ACL/permissions and SCSI port values.
> >>
> >> Here is the general layout:
> >>
> >> [sys]# tree scsi_target/
> >> scsi_target/
> >> |-- fabric/target module
> >> |   `-- target name
> >> |       `-- tpgt_$target_port_group_number
> >> |           `-- sessions
> >> |               `-- initiator name - session ID number
> >> |                   |-- acl
> >> |                   `-- transport_id
> >> |                       |-- name
> >> |                       |-- proto
> >> |                       `-- session_id
> >>
> >> Here is an example with the scsi target layer's iSCSI driver:
> >>
> >> scsi_target/
> >> |-- iscsi
> >> |   `-- iqn.1999-09.com.tcmu:minna
> >> |       `-- tpgt_1
> >> |           `-- sessions
> >> |               `-- iqn.2005-03.com.ceph:ini1-1
> >> |                   |-- acl
> >> |                   `-- transport_id
> >> |                       |-- name
> >> |                       |-- proto
> >> |                       `-- session_id
> >> |-- fc
> >> |-- loopback
> >> |-- qla2xxx_tcm
> >>
> >>
> >> Note/Question for Greg:
> >>
> >> We are not exporting info in the upper level dirs like "fabric/target
> >> module", "target name", tpgt, etc and just need those dirs to be able to
> >> organize/view the endpoints of the session. So, in this patch I made a new
> >> top level dir scsi_target and made the other dirs with
> >> kobject_create_and_add. It looks like we could also add device structs in
> >> the target related structs, use classes, and build the tree/hierarchy that
> >> way too. It was not clear to me when to use one or the other.
> > 
> > Never use kobject calls in a driver subsystem like you have here, as
> > those objects will not be seen by userspace tools that get uevents.
> > Just use real 'struct devices' if you really really need a deep
> > directory tree.
> > 
> > But I would push back here, why do you feel you want such a deep tree?
> > What are you getting from this?  Why do you need that "sessions"
> > directory at all?
> 
> I do not need the sessions under the tpgt dir and will drop it. The
> target subsystem does not have a bus or use device structs at all right
> now.

Then fix that and everything shows up automatically "for free".

> And, I saw how other code that does not have a bus like btrfs/ext4
> use kobject_create_and_add() to group/organize objects and went wild
> with dirs :)

file systems are not devices with busses and drivers :)

> And, I can move the code to device structs, but had a question about the
> deep tree question.

Don't do it.

> A common operation will be that userspace knows the names of the objects
> above the session in the tree already. Apps then want to read in a
> specific session or scan the specific sessions in a target or a tpgt.
> The deep tree makes it easy to build the sysfs path and scan/read the
> specific object/objects.

Again, a "deep tree" with raw kobjects will be invisible to the normal
userspace tools that monitor changes in sysfs for devices because they
will not notice them at all.

> I wanted to avoid the issue where apps have with the flat layout where
> they have to scan every session when they just want something specific.

There should not be any difference in "speed" for something like that,
it's an in-ram filesystem with no i/o times.

> Will a deep tree be ok for this type of reason?

Nope :(

greg k-h
