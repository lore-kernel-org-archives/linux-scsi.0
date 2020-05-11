Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A76C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7291820708
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgEKGV1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 02:21:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:47376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgEKGV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 02:21:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4C42DABD1;
        Mon, 11 May 2020 06:21:28 +0000 (UTC)
Subject: Re: [PATCH 11/15] target: add sysfs support
To:     Mike Christie <mchristi@redhat.com>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-12-mchristi@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ba76d44a-9d04-e5e4-39ef-3b3a820c4452@suse.de>
Date:   Mon, 11 May 2020 08:21:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200510215744.21999-12-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> These next two patches add a sysfs interface that reports the target
> layer's I_T nexuses/sessions. For the non-SCSI people cc'd, this just means
> we are reporting a server's connections to remote clients.
> 
> This patch adds the upper level dirs which shows/organizes our local port
> (tpgts below) and the connection (session below). The next patch will then
> add the dirs/files for each connection/session which exports info like
> ACL/permissions and SCSI port values.
> 
> Here is the general layout:
> 
> [sys]# tree scsi_target/
> scsi_target/
> |-- fabric/target module
> |   `-- target name
> |       `-- tpgt_$target_port_group_number
> |           `-- sessions
> |               `-- initiator name - session ID number
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> 
> Here is an example with the scsi target layer's iSCSI driver:
> 
> scsi_target/
> |-- iscsi
> |   `-- iqn.1999-09.com.tcmu:minna
> |       `-- tpgt_1
> |           `-- sessions
> |               `-- iqn.2005-03.com.ceph:ini1-1
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> |-- fc
> |-- loopback
> |-- qla2xxx_tcm
> 
> 
I'm not sure if we want to include the actual name for the target name 
or initiatorname; that we we'll get an instant denial of service if we 
fail to cleanup this directory and want to recreate a new one.
Normally we have been using logical names for sysfs directories (ie 
targertport0 or session0) and include the actual names in a sysfs 
attribute. That way the structure can stay around for slightly longer 
(ie for cleanup operations) _and_ we can create a new one to allow new 
connections with the same credentials.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
